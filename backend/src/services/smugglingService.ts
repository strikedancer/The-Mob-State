import prisma from '../lib/prisma';
import countries from '../../content/countries.json';

export type SmugglingCategory = 'drug' | 'trade' | 'vehicle' | 'weapon' | 'ammo';
export type SmugglingChannel = 'package' | 'courier' | 'container';
export type SmugglingNetworkScope = 'personal' | 'crew';

type ShipmentStatus = 'in_transit' | 'ready' | 'seized' | 'claimed';

interface ShipmentRow {
  id: number;
  player_id: number;
  crew_id: number | null;
  category: SmugglingCategory;
  channel: SmugglingChannel;
  network_scope: SmugglingNetworkScope;
  item_key: string;
  item_label: string;
  quantity: number;
  unit_tag: string;
  origin_country: string;
  destination_country: string;
  status: ShipmentStatus;
  metadata_json: string | null;
  seizure_chance: number;
  shipping_fee: number;
  eta_at: Date;
  created_at: Date;
  delivered_at: Date | null;
  claimed_at: Date | null;
}

interface SendShipmentInput {
  category: SmugglingCategory;
  itemKey: string;
  quantity: number;
  destinationCountry: string;
  channel?: SmugglingChannel;
  networkScope?: SmugglingNetworkScope;
  metadata?: Record<string, any>;
}

interface QuoteShipmentResult {
  success: boolean;
  message: string;
  shippingFee?: number;
  etaMinutes?: number;
  seizureChance?: number;
  availableQuantity?: number;
  canAfford?: boolean;
  cooldownRemainingSeconds?: number;
  recommendedChannel?: SmugglingChannel;
}

class SmugglingService {
  private initialized = false;
  private readonly channelCooldownSeconds: Record<SmugglingChannel, number> = {
    package: 8,
    courier: 14,
    container: 22,
  };

  private parseCrewDrugGoodType(goodType: string): { drugType: string; quality: string } {
    // Canonical crew format: drug:<drugType>:<quality>
    if (goodType.startsWith('drug:')) {
      const parts = goodType.split(':');
      if (parts.length >= 3) {
        return {
          drugType: parts.slice(1, parts.length - 1).join(':'),
          quality: parts[parts.length - 1] || 'C',
        };
      }
    }

    return { drugType: goodType, quality: 'C' };
  }

  private async ensureTable(): Promise<void> {
    if (this.initialized) return;

    await prisma.$executeRaw`
      CREATE TABLE IF NOT EXISTS smuggling_shipments (
        id INT NOT NULL AUTO_INCREMENT,
        player_id INT NOT NULL,
        crew_id INT NULL,
        category VARCHAR(20) NOT NULL,
        channel VARCHAR(20) NOT NULL DEFAULT 'package',
        network_scope VARCHAR(20) NOT NULL DEFAULT 'personal',
        item_key VARCHAR(100) NOT NULL,
        item_label VARCHAR(120) NOT NULL,
        quantity INT NOT NULL,
        unit_tag VARCHAR(20) NOT NULL DEFAULT 'unit',
        origin_country VARCHAR(50) NOT NULL,
        destination_country VARCHAR(50) NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'in_transit',
        metadata_json LONGTEXT NULL,
        seizure_chance DECIMAL(6,4) NOT NULL DEFAULT 0.0500,
        shipping_fee INT NOT NULL DEFAULT 0,
        eta_at DATETIME NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        delivered_at DATETIME NULL,
        claimed_at DATETIME NULL,
        PRIMARY KEY (id),
        INDEX idx_smuggling_player_status_country (player_id, status, destination_country),
        INDEX idx_smuggling_player_eta (player_id, eta_at),
        INDEX idx_smuggling_player_category (player_id, category),
        INDEX idx_smuggling_crew_scope (crew_id, network_scope, status, destination_country)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `;

    await prisma.$executeRaw`
      ALTER TABLE smuggling_shipments
      ADD COLUMN IF NOT EXISTS crew_id INT NULL,
      ADD COLUMN IF NOT EXISTS channel VARCHAR(20) NOT NULL DEFAULT 'package',
      ADD COLUMN IF NOT EXISTS network_scope VARCHAR(20) NOT NULL DEFAULT 'personal'
    `;

    this.initialized = true;
  }

  private async getPlayerCrewId(playerId: number): Promise<number | null> {
    const membership = await prisma.crewMember.findUnique({
      where: { playerId },
      select: { crewId: true },
    });
    return membership?.crewId ?? null;
  }

  private clamp(value: number, min: number, max: number): number {
    return Math.max(min, Math.min(max, value));
  }

  private parseMetadata(row: ShipmentRow): Record<string, any> {
    try {
      return row.metadata_json ? JSON.parse(row.metadata_json) : {};
    } catch {
      return {};
    }
  }

  private async refreshDueShipments(playerId: number, crewId: number | null): Promise<void> {
    await this.ensureTable();

    const due = await prisma.$queryRaw<ShipmentRow[]>`
      SELECT *
      FROM smuggling_shipments
      WHERE (
        player_id = ${playerId}
        OR (network_scope = 'crew' AND crew_id = ${crewId ?? -1})
      )
        AND status = 'in_transit'
        AND eta_at <= NOW()
      ORDER BY id ASC
    `;

    for (const shipment of due) {
      const seized = Math.random() < Number(shipment.seizure_chance);
      const nextStatus: ShipmentStatus = seized ? 'seized' : 'ready';

      await prisma.$executeRaw`
        UPDATE smuggling_shipments
        SET status = ${nextStatus}, delivered_at = NOW()
        WHERE id = ${shipment.id}
      `;
    }
  }

  private buildPricing(
    category: SmugglingCategory,
    quantity: number,
    wantedLevel: number,
    channel: SmugglingChannel,
    networkScope: SmugglingNetworkScope
  ): { fee: number; etaMinutes: number; seizureChance: number } {
    const baseByCategory: Record<SmugglingCategory, { fee: number; eta: number; risk: number; qtyFee: number; qtyRisk: number }> = {
      drug: { fee: 350, eta: 55, risk: 0.06, qtyFee: 4, qtyRisk: 0.00025 },
      trade: { fee: 280, eta: 50, risk: 0.04, qtyFee: 2, qtyRisk: 0.00015 },
      vehicle: { fee: 1800, eta: 90, risk: 0.09, qtyFee: 0, qtyRisk: 0.0 },
      weapon: { fee: 600, eta: 70, risk: 0.08, qtyFee: 14, qtyRisk: 0.0008 },
      ammo: { fee: 450, eta: 60, risk: 0.05, qtyFee: 1, qtyRisk: 0.00012 },
    };

    const channelFactor: Record<SmugglingChannel, { fee: number; eta: number; risk: number }> = {
      package: { fee: 0.85, eta: 0.85, risk: 1.15 },
      courier: { fee: 1.00, eta: 1.00, risk: 1.00 },
      container: { fee: 1.25, eta: 1.30, risk: 0.75 },
    };

    const p = baseByCategory[category];
    const cf = channelFactor[channel];

    let fee = Math.round((p.fee + quantity * p.qtyFee + wantedLevel * 35) * cf.fee);
    let etaMinutes = this.clamp(Math.round((p.eta + quantity * 0.02) * cf.eta), 30, 360);
    let seizureChance = this.clamp((p.risk + quantity * p.qtyRisk + wantedLevel * 0.012) * cf.risk, 0.02, 0.50);

    if (networkScope === 'crew') {
      fee = Math.max(100, Math.round(fee * 0.92));
      seizureChance = this.clamp(seizureChance * 0.95, 0.02, 0.50);
      etaMinutes = this.clamp(Math.round(etaMinutes * 0.95), 30, 360);
    }

    const categoryChannelAdjust: Record<SmugglingCategory, Record<SmugglingChannel, { fee: number; eta: number; risk: number }>> = {
      drug: {
        package: { fee: 0.96, eta: 0.94, risk: 1.08 },
        courier: { fee: 1.00, eta: 1.00, risk: 1.00 },
        container: { fee: 1.12, eta: 1.08, risk: 0.86 },
      },
      trade: {
        package: { fee: 0.92, eta: 0.93, risk: 1.06 },
        courier: { fee: 1.00, eta: 1.00, risk: 1.00 },
        container: { fee: 1.08, eta: 1.06, risk: 0.88 },
      },
      vehicle: {
        package: { fee: 1.00, eta: 1.00, risk: 1.00 },
        courier: { fee: 0.94, eta: 0.92, risk: 1.06 },
        container: { fee: 1.10, eta: 1.12, risk: 0.82 },
      },
      weapon: {
        package: { fee: 0.98, eta: 0.96, risk: 1.10 },
        courier: { fee: 1.00, eta: 1.00, risk: 1.00 },
        container: { fee: 1.10, eta: 1.10, risk: 0.84 },
      },
      ammo: {
        package: { fee: 0.96, eta: 0.95, risk: 1.08 },
        courier: { fee: 1.00, eta: 1.00, risk: 1.00 },
        container: { fee: 1.08, eta: 1.07, risk: 0.86 },
      },
    };

    const adj = categoryChannelAdjust[category][channel];
    fee = Math.max(50, Math.round(fee * adj.fee));
    etaMinutes = this.clamp(Math.round(etaMinutes * adj.eta), 25, 420);
    seizureChance = this.clamp(seizureChance * adj.risk, 0.02, 0.50);

    return { fee, etaMinutes, seizureChance };
  }

  private validateQuantityByCategoryAndChannel(
    category: SmugglingCategory,
    channel: SmugglingChannel,
    quantity: number
  ): { ok: boolean; message?: string; normalizedQuantity: number } {
    if (category === 'vehicle') {
      if (channel === 'package') {
        return { ok: false, message: 'Voertuigen kunnen niet via pakketkanaal', normalizedQuantity: 1 };
      }
      return { ok: true, normalizedQuantity: 1 };
    }

    const maxByCategoryChannel: Record<SmugglingCategory, Record<SmugglingChannel, number>> = {
      drug: { package: 750, courier: 3000, container: 9000 },
      trade: { package: 400, courier: 2000, container: 8000 },
      weapon: { package: 20, courier: 120, container: 300 },
      ammo: { package: 1500, courier: 8000, container: 25000 },
      vehicle: { package: 1, courier: 1, container: 1 },
    };

    const maxAllowed = maxByCategoryChannel[category][channel];
    if (quantity > maxAllowed) {
      return {
        ok: false,
        message: `Hoeveelheid te hoog voor ${channel}. Max: ${maxAllowed}`,
        normalizedQuantity: quantity,
      };
    }

    return { ok: true, normalizedQuantity: quantity };
  }

  private recommendedChannelFor(category: SmugglingCategory, quantity: number): SmugglingChannel {
    if (category === 'vehicle') return 'courier';
    if (quantity >= 2000) return 'container';
    if (quantity <= 250) return 'package';
    return 'courier';
  }

  private async getSendCooldownRemainingSeconds(
    playerId: number,
    networkScope: SmugglingNetworkScope,
    channel: SmugglingChannel
  ): Promise<number> {
    const rows = await prisma.$queryRaw<Array<{ elapsed: number | null }>>`
      SELECT TIMESTAMPDIFF(SECOND, created_at, NOW()) AS elapsed
      FROM smuggling_shipments
      WHERE player_id = ${playerId}
        AND network_scope = ${networkScope}
      ORDER BY id DESC
      LIMIT 1
    `;

    const elapsed = Number(rows[0]?.elapsed ?? -1);
    if (elapsed < 0) return 0;

    const cooldown = this.channelCooldownSeconds[channel];
    return Math.max(0, cooldown - elapsed);
  }

  private countryNameById(countryId: string): string {
    const row = (countries as Array<{ id: string; name: string }>).find((c) => c.id === countryId);
    return row?.name ?? countryId;
  }

  async getCatalog(playerId: number, networkScope: SmugglingNetworkScope = 'personal'): Promise<{ success: boolean; currentCountry: string; destinations: any[]; canUseCrewNetwork: boolean; channels: SmugglingChannel[]; selectedNetworkScope: SmugglingNetworkScope; categories: Record<SmugglingCategory, any[]> }> {
    await this.ensureTable();

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    if (!player) {
      return {
        success: false,
        currentCountry: 'netherlands',
        destinations: [],
        canUseCrewNetwork: false,
        channels: ['package', 'courier', 'container'],
        selectedNetworkScope: 'personal',
        categories: { drug: [], trade: [], vehicle: [], weapon: [], ammo: [] },
      };
    }

    const crewId = await this.getPlayerCrewId(playerId);

    const resolvedScope: SmugglingNetworkScope = networkScope === 'crew' && crewId ? 'crew' : 'personal';

    if (resolvedScope === 'crew' && crewId) {
      const [crewDrugs, crewCars, crewBoats, crewWeapons, crewAmmo] = await Promise.all([
        prisma.crewDrugInventory.findMany({ where: { crewId, quantity: { gt: 0 } }, orderBy: { goodType: 'asc' } }),
        prisma.crewCarInventory.findMany({ where: { crewId }, orderBy: { addedAt: 'desc' } }),
        prisma.crewBoatInventory.findMany({ where: { crewId }, orderBy: { addedAt: 'desc' } }),
        prisma.crewWeaponInventory.findMany({ where: { crewId, quantity: { gt: 0 } }, orderBy: { weaponId: 'asc' } }),
        prisma.crewAmmoInventory.findMany({ where: { crewId, quantity: { gt: 0 } }, orderBy: { ammoType: 'asc' } }),
      ]);

      const destinations = (countries as Array<{ id: string; name: string }>)
        .filter((c) => c.id !== player.currentCountry)
        .map((c) => ({ id: c.id, name: c.name }));

      return {
        success: true,
        currentCountry: player.currentCountry,
        destinations,
        canUseCrewNetwork: true,
        channels: ['package', 'courier', 'container'],
        selectedNetworkScope: 'crew',
        categories: {
          drug: crewDrugs.map((d) => {
            const parsed = this.parseCrewDrugGoodType(d.goodType);
            return {
              itemKey: d.goodType,
              itemLabel: `${parsed.drugType} (${parsed.quality})`,
              quantity: d.quantity,
              quality: parsed.quality,
              unitTag: 'g',
              metadata: { quality: parsed.quality, crewGoodType: d.goodType },
            };
          }),
          trade: [],
          vehicle: [
            ...crewCars.map((v) => ({
              itemKey: `car:${v.id}`,
              itemLabel: `CAR • ${v.vehicleId}`,
              quantity: 1,
              unitTag: 'vehicle',
              metadata: { vehicleType: 'car', crewInventoryId: v.id },
            })),
            ...crewBoats.map((v) => ({
              itemKey: `boat:${v.id}`,
              itemLabel: `BOAT • ${v.vehicleId}`,
              quantity: 1,
              unitTag: 'vehicle',
              metadata: { vehicleType: 'boat', crewInventoryId: v.id },
            })),
          ],
          weapon: crewWeapons.map((w) => ({ itemKey: w.weaponId, itemLabel: w.weaponId, quantity: w.quantity, unitTag: 'weapon' })),
          ammo: crewAmmo.map((a) => ({ itemKey: a.ammoType, itemLabel: a.ammoType, quantity: a.quantity, unitTag: 'round' })),
        },
      };
    }

    const [drugs, tradeGoods, vehicles, weapons, ammo] = await Promise.all([
      prisma.drugInventory.findMany({ where: { playerId, country: player.currentCountry, quantity: { gt: 0 } }, orderBy: [{ drugType: 'asc' }, { quality: 'asc' }] }),
      prisma.inventory.findMany({ where: { playerId, quantity: { gt: 0 } }, orderBy: { goodType: 'asc' } }),
      prisma.vehicleInventory.findMany({ where: { playerId, currentLocation: player.currentCountry, transportStatus: null, marketListing: false }, orderBy: { stolenAt: 'desc' } }),
      prisma.weaponInventory.findMany({ where: { playerId, quantity: { gt: 0 } }, orderBy: { weaponId: 'asc' } }),
      prisma.ammoInventory.findMany({ where: { playerId, quantity: { gt: 0 } }, orderBy: { ammoType: 'asc' } }),
    ]);

    const destinations = (countries as Array<{ id: string; name: string }>)
      .filter((c) => c.id !== player.currentCountry)
      .map((c) => ({ id: c.id, name: c.name }));

    return {
      success: true,
      currentCountry: player.currentCountry,
      destinations,
      canUseCrewNetwork: crewId !== null,
      channels: ['package', 'courier', 'container'],
      selectedNetworkScope: 'personal',
      categories: {
        drug: drugs.map((d) => ({ itemKey: `${d.drugType}:${d.quality}`, itemLabel: `${d.drugType} (${d.quality})`, quantity: d.quantity, quality: d.quality, unitTag: 'g' })),
        trade: tradeGoods.map((g) => ({ itemKey: g.goodType, itemLabel: g.goodType, quantity: g.quantity, unitTag: 'unit' })),
        vehicle: vehicles.map((v) => ({ itemKey: String(v.id), itemLabel: `${v.vehicleType.toUpperCase()} • ${v.vehicleId}`, quantity: 1, unitTag: 'vehicle', metadata: { vehicleType: v.vehicleType } })),
        weapon: weapons.map((w) => ({ itemKey: w.weaponId, itemLabel: w.weaponId, quantity: w.quantity, unitTag: 'weapon' })),
        ammo: ammo.map((a) => ({ itemKey: a.ammoType, itemLabel: a.ammoType, quantity: a.quantity, unitTag: 'round' })),
      },
    };
  }

  async sendShipment(playerId: number, input: SendShipmentInput): Promise<{ success: boolean; message: string; shipmentId?: number; etaMinutes?: number; shippingFee?: number; seizureChance?: number }> {
    await this.ensureTable();

    const { category, itemKey, destinationCountry } = input;
    const requestedQuantity = Math.max(1, Math.floor(input.quantity));
    const channel = (input.channel ?? 'courier') as SmugglingChannel;
    const networkScope = (input.networkScope ?? 'personal') as SmugglingNetworkScope;

    if (!['package', 'courier', 'container'].includes(channel)) {
      return { success: false, message: 'Ongeldig smokkelkanaal' };
    }

    if (!['personal', 'crew'].includes(networkScope)) {
      return { success: false, message: 'Ongeldige netwerkkeuze' };
    }

    const quantityValidation = this.validateQuantityByCategoryAndChannel(category, channel, requestedQuantity);
    if (!quantityValidation.ok) {
      return { success: false, message: quantityValidation.message ?? 'Ongeldige hoeveelheid' };
    }
    const quantity = quantityValidation.normalizedQuantity;

    const destinationExists = (countries as Array<{ id: string }>).some((c) => c.id === destinationCountry);
    if (!destinationExists) {
      return { success: false, message: 'Bestemmingsland bestaat niet' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true, wantedLevel: true, money: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.currentCountry === destinationCountry) {
      return { success: false, message: 'Gebruik lokale inventory voor hetzelfde land' };
    }

    const crewId = await this.getPlayerCrewId(playerId);
    if (networkScope === 'crew' && !crewId) {
      return { success: false, message: 'Je zit niet in een crew' };
    }

    if (networkScope === 'crew' && category === 'trade') {
      return { success: false, message: 'Crew-smokkel voor handelswaar is nog niet beschikbaar' };
    }

    const cooldownRemainingSeconds = await this.getSendCooldownRemainingSeconds(playerId, networkScope, channel);
    if (cooldownRemainingSeconds > 0) {
      return {
        success: false,
        message: `Wacht ${cooldownRemainingSeconds}s voor een nieuwe ${channel}-zending`,
      };
    }

    const wantedLevel = player.wantedLevel ?? 0;
    const pricing = this.buildPricing(category, quantity, wantedLevel, channel, networkScope);

    if (player.money < pricing.fee) {
      return { success: false, message: 'Niet genoeg geld voor smokkelkosten' };
    }

    const etaAt = new Date(Date.now() + pricing.etaMinutes * 60 * 1000);

    const result = await prisma.$transaction(async (tx) => {
      let itemLabel = itemKey;
      let unitTag = 'unit';
      let metadata: Record<string, any> = input.metadata ?? {};
      let effectiveQuantity = quantity;
      let storeItemKey = itemKey;

      if (category === 'drug') {
        if (networkScope === 'crew') {
          const inv = await tx.crewDrugInventory.findUnique({
            where: { crewId_goodType: { crewId: crewId!, goodType: itemKey } },
          });
          if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg drugs in crew inventory' } as const;

          if (inv.quantity === quantity) {
            await tx.crewDrugInventory.delete({ where: { crewId_goodType: { crewId: crewId!, goodType: itemKey } } });
          } else {
            await tx.crewDrugInventory.update({
              where: { crewId_goodType: { crewId: crewId!, goodType: itemKey } },
              data: { quantity: inv.quantity - quantity },
            });
          }

          const parsed = this.parseCrewDrugGoodType(itemKey);
          itemLabel = `${parsed.drugType} (${parsed.quality})`;
          unitTag = 'g';
          metadata = { ...metadata, quality: parsed.quality, crewGoodType: itemKey };
        } else {
          const colonIdx = itemKey.lastIndexOf(':');
          const drugType = colonIdx > 0 ? itemKey.slice(0, colonIdx) : itemKey;
          const quality = colonIdx > 0 ? itemKey.slice(colonIdx + 1) : String(input.metadata?.quality ?? 'C');
          storeItemKey = drugType;
          const inv = await tx.drugInventory.findUnique({
            where: { playerId_country_drugType_quality: { playerId, country: player.currentCountry, drugType, quality } },
          });
          if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg drugs in inventory' } as const;

          if (inv.quantity === quantity) {
            await tx.drugInventory.delete({ where: { playerId_country_drugType_quality: { playerId, country: player.currentCountry, drugType, quality } } });
          } else {
            await tx.drugInventory.update({
              where: { playerId_country_drugType_quality: { playerId, country: player.currentCountry, drugType, quality } },
              data: { quantity: inv.quantity - quantity },
            });
          }

          itemLabel = `${drugType} (${quality})`;
          unitTag = 'g';
          metadata = { ...metadata, quality };
        }
      } else if (category === 'trade') {
        const inv = await tx.inventory.findUnique({
          where: { playerId_goodType: { playerId, goodType: itemKey } },
        });
        if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg handelswaar in inventory' } as const;

        if (inv.quantity === quantity) {
          await tx.inventory.delete({ where: { playerId_goodType: { playerId, goodType: itemKey } } });
        } else {
          await tx.inventory.update({
            where: { playerId_goodType: { playerId, goodType: itemKey } },
            data: { quantity: inv.quantity - quantity },
          });
        }

        itemLabel = itemKey;
        unitTag = 'unit';
      } else if (category === 'weapon') {
        if (networkScope === 'crew') {
          const inv = await tx.crewWeaponInventory.findUnique({ where: { crewId_weaponId: { crewId: crewId!, weaponId: itemKey } } });
          if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg wapens in crew inventory' } as const;

          if (inv.quantity === quantity) {
            await tx.crewWeaponInventory.delete({ where: { crewId_weaponId: { crewId: crewId!, weaponId: itemKey } } });
          } else {
            await tx.crewWeaponInventory.update({ where: { crewId_weaponId: { crewId: crewId!, weaponId: itemKey } }, data: { quantity: inv.quantity - quantity } });
          }
        } else {
          const inv = await tx.weaponInventory.findUnique({ where: { playerId_weaponId: { playerId, weaponId: itemKey } } });
          if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg wapens in inventory' } as const;

          if (inv.quantity === quantity) {
            await tx.weaponInventory.delete({ where: { playerId_weaponId: { playerId, weaponId: itemKey } } });
          } else {
            await tx.weaponInventory.update({ where: { playerId_weaponId: { playerId, weaponId: itemKey } }, data: { quantity: inv.quantity - quantity } });
          }
        }

        itemLabel = itemKey;
        unitTag = 'weapon';
      } else if (category === 'ammo') {
        if (networkScope === 'crew') {
          const inv = await tx.crewAmmoInventory.findUnique({ where: { crewId_ammoType: { crewId: crewId!, ammoType: itemKey } } });
          if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg munitie in crew inventory' } as const;

          if (inv.quantity === quantity) {
            await tx.crewAmmoInventory.delete({ where: { crewId_ammoType: { crewId: crewId!, ammoType: itemKey } } });
          } else {
            await tx.crewAmmoInventory.update({ where: { crewId_ammoType: { crewId: crewId!, ammoType: itemKey } }, data: { quantity: inv.quantity - quantity } });
          }

          itemLabel = itemKey;
          unitTag = 'round';
          metadata = { ...metadata, quality: 1.0 };
        } else {
          const inv = await tx.ammoInventory.findUnique({ where: { playerId_ammoType: { playerId, ammoType: itemKey } } });
          if (!inv || inv.quantity < quantity) return { ok: false, message: 'Niet genoeg munitie in inventory' } as const;

          if (inv.quantity === quantity) {
            await tx.ammoInventory.delete({ where: { playerId_ammoType: { playerId, ammoType: itemKey } } });
          } else {
            await tx.ammoInventory.update({ where: { playerId_ammoType: { playerId, ammoType: itemKey } }, data: { quantity: inv.quantity - quantity } });
          }

          itemLabel = itemKey;
          unitTag = 'round';
          metadata = { ...metadata, quality: inv?.quality ?? 1.0 };
        }
      } else if (category === 'vehicle') {
        if (networkScope === 'crew') {
          const [rawType, rawId] = String(itemKey).split(':');
          const vehicleType = rawType === 'boat' ? 'boat' : 'car';
          const crewInventoryId = Number(rawId);

          if (!Number.isFinite(crewInventoryId) || crewInventoryId <= 0) {
            return { ok: false, message: 'Ongeldig crew-voertuig' } as const;
          }

          if (vehicleType === 'boat') {
            const boat = await tx.crewBoatInventory.findFirst({ where: { id: crewInventoryId, crewId: crewId! } });
            if (!boat) return { ok: false, message: 'Crew-boot niet beschikbaar voor smokkel' } as const;

            await tx.crewBoatInventory.delete({ where: { id: boat.id } });

            effectiveQuantity = 1;
            itemLabel = `BOAT • ${boat.vehicleId}`;
            unitTag = 'vehicle';
            metadata = {
              ...metadata,
              vehicleType: 'boat',
              vehicleId: boat.vehicleId,
              condition: boat.condition,
              fuelLevel: boat.fuelLevel,
              stolenInCountry: boat.stolenInCountry,
            };
          } else {
            const car = await tx.crewCarInventory.findFirst({ where: { id: crewInventoryId, crewId: crewId! } });
            if (!car) return { ok: false, message: 'Crew-auto niet beschikbaar voor smokkel' } as const;

            await tx.crewCarInventory.delete({ where: { id: car.id } });

            effectiveQuantity = 1;
            itemLabel = `CAR • ${car.vehicleId}`;
            unitTag = 'vehicle';
            metadata = {
              ...metadata,
              vehicleType: 'car',
              vehicleId: car.vehicleId,
              condition: car.condition,
              fuelLevel: car.fuelLevel,
              stolenInCountry: car.stolenInCountry,
            };
          }
        } else {
          const vehicleInventoryId = Number(itemKey);
          const vehicle = await tx.vehicleInventory.findFirst({
            where: {
              id: vehicleInventoryId,
              playerId,
              currentLocation: player.currentCountry,
              transportStatus: null,
              marketListing: false,
            },
          });

          if (!vehicle) return { ok: false, message: 'Voertuig niet beschikbaar voor smokkel' } as const;

          await tx.vehicleInventory.delete({ where: { id: vehicle.id } });

          effectiveQuantity = 1;
          itemLabel = `${vehicle.vehicleType.toUpperCase()} • ${vehicle.vehicleId}`;
          unitTag = 'vehicle';
          metadata = {
            ...metadata,
            vehicleType: vehicle.vehicleType,
            vehicleId: vehicle.vehicleId,
            condition: vehicle.condition,
            fuelLevel: vehicle.fuelLevel,
            stolenInCountry: vehicle.stolenInCountry,
          };
        }
      }

      await tx.player.update({
        where: { id: playerId },
        data: {
          money: { decrement: pricing.fee },
          drugHeat: category === 'drug' ? { increment: 2 } : undefined,
        },
      });

      const metadataJson = JSON.stringify(metadata ?? {});

      await tx.$executeRaw`
        INSERT INTO smuggling_shipments
          (player_id, crew_id, category, channel, network_scope, item_key, item_label, quantity, unit_tag, origin_country, destination_country, status, metadata_json, seizure_chance, shipping_fee, eta_at)
        VALUES
          (${playerId}, ${networkScope === 'crew' ? crewId : null}, ${category}, ${channel}, ${networkScope}, ${storeItemKey}, ${itemLabel}, ${effectiveQuantity}, ${unitTag}, ${player.currentCountry}, ${destinationCountry}, 'in_transit', ${metadataJson}, ${pricing.seizureChance}, ${pricing.fee}, ${etaAt})
      `;

      const inserted = await tx.$queryRaw<Array<{ id: number }>>`
        SELECT id FROM smuggling_shipments
        WHERE player_id = ${playerId}
        ORDER BY id DESC
        LIMIT 1
      `;

      return { ok: true, id: inserted[0]?.id } as const;
    });

    if (!result.ok) {
      return { success: false, message: result.message };
    }

    return {
      success: true,
      message: `Smokkelzending (${channel}) naar ${this.countryNameById(destinationCountry)} gestart`,
      shipmentId: result.id,
      etaMinutes: pricing.etaMinutes,
      shippingFee: pricing.fee,
      seizureChance: pricing.seizureChance,
    };
  }

  async quoteShipment(playerId: number, input: SendShipmentInput): Promise<QuoteShipmentResult> {
    await this.ensureTable();

    const { category, itemKey, destinationCountry } = input;
    const requestedQuantity = Math.max(1, Math.floor(input.quantity));
    const channel = (input.channel ?? 'courier') as SmugglingChannel;
    const networkScope = (input.networkScope ?? 'personal') as SmugglingNetworkScope;

    if (!['package', 'courier', 'container'].includes(channel)) {
      return { success: false, message: 'Ongeldig smokkelkanaal' };
    }

    if (!['personal', 'crew'].includes(networkScope)) {
      return { success: false, message: 'Ongeldige netwerkkeuze' };
    }

    const quantityValidation = this.validateQuantityByCategoryAndChannel(category, channel, requestedQuantity);
    if (!quantityValidation.ok) {
      return {
        success: false,
        message: quantityValidation.message ?? 'Ongeldige hoeveelheid',
        recommendedChannel: this.recommendedChannelFor(category, requestedQuantity),
      };
    }
    const quantity = quantityValidation.normalizedQuantity;

    const destinationExists = (countries as Array<{ id: string }>).some((c) => c.id === destinationCountry);
    if (!destinationExists) {
      return { success: false, message: 'Bestemmingsland bestaat niet' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true, wantedLevel: true, money: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (player.currentCountry === destinationCountry) {
      return { success: false, message: 'Gebruik lokale inventory voor hetzelfde land' };
    }

    const crewId = await this.getPlayerCrewId(playerId);
    if (networkScope === 'crew' && !crewId) {
      return { success: false, message: 'Je zit niet in een crew' };
    }

    if (networkScope === 'crew' && category === 'trade') {
      return { success: false, message: 'Crew-smokkel voor handelswaar is nog niet beschikbaar' };
    }

    const cooldownRemainingSeconds = await this.getSendCooldownRemainingSeconds(playerId, networkScope, channel);

    let availableQuantity = 0;

    if (category === 'drug') {
      if (networkScope === 'crew') {
        const inv = await prisma.crewDrugInventory.findUnique({
          where: { crewId_goodType: { crewId: crewId!, goodType: itemKey } },
          select: { quantity: true },
        });
        availableQuantity = inv?.quantity ?? 0;
      } else {
        const colonIdx = itemKey.lastIndexOf(':');
        const drugType = colonIdx > 0 ? itemKey.slice(0, colonIdx) : itemKey;
        const quality = colonIdx > 0 ? itemKey.slice(colonIdx + 1) : String(input.metadata?.quality ?? 'C');
        const inv = await prisma.drugInventory.findUnique({
          where: { playerId_country_drugType_quality: { playerId, country: player.currentCountry, drugType, quality } },
          select: { quantity: true },
        });
        availableQuantity = inv?.quantity ?? 0;
      }
    } else if (category === 'trade') {
      const inv = await prisma.inventory.findUnique({
        where: { playerId_goodType: { playerId, goodType: itemKey } },
        select: { quantity: true },
      });
      availableQuantity = inv?.quantity ?? 0;
    } else if (category === 'weapon') {
      if (networkScope === 'crew') {
        const inv = await prisma.crewWeaponInventory.findUnique({
          where: { crewId_weaponId: { crewId: crewId!, weaponId: itemKey } },
          select: { quantity: true },
        });
        availableQuantity = inv?.quantity ?? 0;
      } else {
        const inv = await prisma.weaponInventory.findUnique({
          where: { playerId_weaponId: { playerId, weaponId: itemKey } },
          select: { quantity: true },
        });
        availableQuantity = inv?.quantity ?? 0;
      }
    } else if (category === 'ammo') {
      if (networkScope === 'crew') {
        const inv = await prisma.crewAmmoInventory.findUnique({
          where: { crewId_ammoType: { crewId: crewId!, ammoType: itemKey } },
          select: { quantity: true },
        });
        availableQuantity = inv?.quantity ?? 0;
      } else {
        const inv = await prisma.ammoInventory.findUnique({
          where: { playerId_ammoType: { playerId, ammoType: itemKey } },
          select: { quantity: true },
        });
        availableQuantity = inv?.quantity ?? 0;
      }
    } else if (category === 'vehicle') {
      if (networkScope === 'crew') {
        const [rawType, rawId] = String(itemKey).split(':');
        const vehicleType = rawType === 'boat' ? 'boat' : 'car';
        const crewInventoryId = Number(rawId);

        if (!Number.isFinite(crewInventoryId) || crewInventoryId <= 0) {
          return { success: false, message: 'Ongeldig crew-voertuig' };
        }

        if (vehicleType === 'boat') {
          const boat = await prisma.crewBoatInventory.findFirst({
            where: { id: crewInventoryId, crewId: crewId! },
            select: { id: true },
          });
          availableQuantity = boat ? 1 : 0;
        } else {
          const car = await prisma.crewCarInventory.findFirst({
            where: { id: crewInventoryId, crewId: crewId! },
            select: { id: true },
          });
          availableQuantity = car ? 1 : 0;
        }
      } else {
        const vehicleInventoryId = Number(itemKey);
        const vehicle = await prisma.vehicleInventory.findFirst({
          where: {
            id: vehicleInventoryId,
            playerId,
            currentLocation: player.currentCountry,
            transportStatus: null,
            marketListing: false,
          },
          select: { id: true },
        });
        availableQuantity = vehicle ? 1 : 0;
      }
    }

    if (availableQuantity < quantity) {
      return {
        success: false,
        message: 'Onvoldoende voorraad voor deze zending',
        availableQuantity,
        cooldownRemainingSeconds,
        recommendedChannel: this.recommendedChannelFor(category, quantity),
      };
    }

    const wantedLevel = player.wantedLevel ?? 0;
    const pricing = this.buildPricing(category, quantity, wantedLevel, channel, networkScope);

    return {
      success: true,
      message: 'Quote berekend',
      shippingFee: pricing.fee,
      etaMinutes: pricing.etaMinutes,
      seizureChance: pricing.seizureChance,
      availableQuantity,
      canAfford: (player.money ?? 0) >= pricing.fee,
      cooldownRemainingSeconds,
      recommendedChannel: this.recommendedChannelFor(category, quantity),
    };
  }

  async getOverview(playerId: number, currentCountry: string): Promise<{ success: boolean; shipments: any[]; depots: any[] }> {
    const crewId = await this.getPlayerCrewId(playerId);
    await this.refreshDueShipments(playerId, crewId);

    const shipments = await prisma.$queryRaw<ShipmentRow[]>`
      SELECT *
      FROM smuggling_shipments
      WHERE (
        player_id = ${playerId}
        OR (network_scope = 'crew' AND crew_id = ${crewId ?? -1})
      )
      ORDER BY id DESC
      LIMIT 120
    `;

    const mappedShipments = shipments.map((s) => ({
      id: s.id,
      networkScope: s.network_scope,
      channel: s.channel,
      crewId: s.crew_id,
      category: s.category,
      itemKey: s.item_key,
      itemLabel: s.item_label,
      quantity: s.quantity,
      unitTag: s.unit_tag,
      originCountry: s.origin_country,
      originCountryName: this.countryNameById(s.origin_country),
      destinationCountry: s.destination_country,
      destinationCountryName: this.countryNameById(s.destination_country),
      status: s.status,
      shippingFee: s.shipping_fee,
      seizureChance: Number(s.seizure_chance),
      metadata: this.parseMetadata(s),
      etaAt: s.eta_at,
      createdAt: s.created_at,
      deliveredAt: s.delivered_at,
      claimedAt: s.claimed_at,
      canClaimHere: s.status === 'ready' && s.destination_country === currentCountry,
    }));

    const depots = await prisma.$queryRaw<Array<{ destination_country: string; network_scope: string; packages: bigint; total_quantity: bigint }>>`
      SELECT destination_country,
             network_scope,
             COUNT(*) AS packages,
             COALESCE(SUM(quantity), 0) AS total_quantity
      FROM smuggling_shipments
      WHERE (
        player_id = ${playerId}
        OR (network_scope = 'crew' AND crew_id = ${crewId ?? -1})
      )
        AND status = 'ready'
      GROUP BY destination_country, network_scope
      ORDER BY destination_country ASC, network_scope ASC
    `;

    return {
      success: true,
      shipments: mappedShipments,
      depots: depots.map((d) => ({
        countryId: d.destination_country,
        networkScope: d.network_scope,
        countryName: this.countryNameById(d.destination_country),
        packages: Number(d.packages),
        totalQuantity: Number(d.total_quantity),
        canClaimHere: d.destination_country === currentCountry,
      })),
    };
  }

  async claimCurrentDepot(playerId: number, scope: SmugglingNetworkScope = 'personal'): Promise<{ success: boolean; message: string; claimedPackages?: number; claimedQuantity?: number }> {
    await this.ensureTable();

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    const crewId = await this.getPlayerCrewId(playerId);
    if (scope === 'crew' && !crewId) {
      return { success: false, message: 'Je zit niet in een crew' };
    }

    await this.refreshDueShipments(playerId, crewId);

    const ready = await prisma.$queryRaw<ShipmentRow[]>`
      SELECT *
      FROM smuggling_shipments
      WHERE (
        (network_scope = 'personal' AND player_id = ${playerId} AND ${scope} = 'personal')
        OR (network_scope = 'crew' AND crew_id = ${crewId ?? -1} AND ${scope} = 'crew')
      )
        AND destination_country = ${player.currentCountry}
        AND status = 'ready'
      ORDER BY id ASC
    `;

    if (ready.length === 0) {
      return { success: false, message: 'Geen zendingen klaar in dit landdepot' };
    }

    let claimedQty = 0;

    await prisma.$transaction(async (tx) => {
      for (const shipment of ready) {
        const metadata = this.parseMetadata(shipment);

        if (shipment.category === 'drug' && scope === 'crew') {
          const quality = String(metadata.quality ?? 'C');
          const goodType = `drug:${shipment.item_key}:${quality}`;
          const existingCrewDrug = await tx.crewDrugInventory.findUnique({
            where: { crewId_goodType: { crewId: crewId!, goodType } },
          });
          if (existingCrewDrug) {
            await tx.crewDrugInventory.update({
              where: { crewId_goodType: { crewId: crewId!, goodType } },
              data: { quantity: existingCrewDrug.quantity + shipment.quantity },
            });
          } else {
            await tx.crewDrugInventory.create({
              data: { crewId: crewId!, goodType, quantity: shipment.quantity, averageCondition: 100, averagePurchasePrice: 0 },
            });
          }
        } else if (shipment.category === 'drug') {
          const quality = String(metadata.quality ?? 'C');
          const existing = await tx.drugInventory.findUnique({
            where: { playerId_country_drugType_quality: { playerId, country: shipment.destination_country, drugType: shipment.item_key, quality } },
          });

          if (existing) {
            await tx.drugInventory.update({
              where: { playerId_country_drugType_quality: { playerId, country: shipment.destination_country, drugType: shipment.item_key, quality } },
              data: { quantity: existing.quantity + shipment.quantity },
            });
          } else {
            await tx.drugInventory.create({
              data: { playerId, country: shipment.destination_country, drugType: shipment.item_key, quality, quantity: shipment.quantity },
            });
          }
        } else if (shipment.category === 'trade') {
          const existing = await tx.inventory.findUnique({ where: { playerId_goodType: { playerId, goodType: shipment.item_key } } });
          if (existing) {
            await tx.inventory.update({
              where: { playerId_goodType: { playerId, goodType: shipment.item_key } },
              data: { quantity: existing.quantity + shipment.quantity },
            });
          } else {
            await tx.inventory.create({
              data: {
                playerId,
                goodType: shipment.item_key,
                quantity: shipment.quantity,
                purchasePrice: 0,
                condition: 100,
              },
            });
          }
        } else if (shipment.category === 'weapon' && scope === 'crew') {
          const existingCrewWeapon = await tx.crewWeaponInventory.findUnique({
            where: { crewId_weaponId: { crewId: crewId!, weaponId: shipment.item_key } },
          });
          if (existingCrewWeapon) {
            await tx.crewWeaponInventory.update({
              where: { crewId_weaponId: { crewId: crewId!, weaponId: shipment.item_key } },
              data: { quantity: existingCrewWeapon.quantity + shipment.quantity },
            });
          } else {
            await tx.crewWeaponInventory.create({
              data: { crewId: crewId!, weaponId: shipment.item_key, quantity: shipment.quantity, averageCondition: 100 },
            });
          }
        } else if (shipment.category === 'weapon') {
          const existing = await tx.weaponInventory.findUnique({ where: { playerId_weaponId: { playerId, weaponId: shipment.item_key } } });
          if (existing) {
            await tx.weaponInventory.update({
              where: { playerId_weaponId: { playerId, weaponId: shipment.item_key } },
              data: { quantity: existing.quantity + shipment.quantity },
            });
          } else {
            await tx.weaponInventory.create({
              data: { playerId, weaponId: shipment.item_key, quantity: shipment.quantity, condition: 100 },
            });
          }
        } else if (shipment.category === 'ammo' && scope === 'crew') {
          const existingCrewAmmo = await tx.crewAmmoInventory.findUnique({ where: { crewId_ammoType: { crewId: crewId!, ammoType: shipment.item_key } } });
          if (existingCrewAmmo) {
            await tx.crewAmmoInventory.update({
              where: { crewId_ammoType: { crewId: crewId!, ammoType: shipment.item_key } },
              data: { quantity: existingCrewAmmo.quantity + shipment.quantity },
            });
          } else {
            await tx.crewAmmoInventory.create({
              data: { crewId: crewId!, ammoType: shipment.item_key, quantity: shipment.quantity },
            });
          }
        } else if (shipment.category === 'ammo') {
          const ammoQuality = Number(metadata.quality ?? 1.0);
          const existing = await tx.ammoInventory.findUnique({ where: { playerId_ammoType: { playerId, ammoType: shipment.item_key } } });
          if (existing) {
            await tx.ammoInventory.update({
              where: { playerId_ammoType: { playerId, ammoType: shipment.item_key } },
              data: { quantity: existing.quantity + shipment.quantity },
            });
          } else {
            await tx.ammoInventory.create({
              data: { playerId, ammoType: shipment.item_key, quantity: shipment.quantity, quality: ammoQuality },
            });
          }
        } else if (shipment.category === 'vehicle' && scope === 'crew') {
          const vehicleType = String(metadata.vehicleType ?? 'car');
          const vehicleId = String(metadata.vehicleId ?? shipment.item_key);
          const condition = Number(metadata.condition ?? 100);
          const fuelLevel = Number(metadata.fuelLevel ?? 100);
          const stolenInCountry = String(metadata.stolenInCountry ?? shipment.origin_country);

          if (vehicleType === 'boat') {
            await tx.crewBoatInventory.create({
              data: {
                crewId: crewId!,
                vehicleId,
                condition,
                fuelLevel,
                stolenInCountry,
                addedByPlayerId: playerId,
              },
            });
          } else {
            await tx.crewCarInventory.create({
              data: {
                crewId: crewId!,
                vehicleId,
                condition,
                fuelLevel,
                stolenInCountry,
                addedByPlayerId: playerId,
              },
            });
          }
        } else if (shipment.category === 'vehicle') {
          const vehicleType = String(metadata.vehicleType ?? 'car');
          const vehicleId = String(metadata.vehicleId ?? shipment.item_key);
          const condition = Number(metadata.condition ?? 100);
          const fuelLevel = Number(metadata.fuelLevel ?? 100);
          const stolenInCountry = String(metadata.stolenInCountry ?? shipment.origin_country);

          await tx.vehicleInventory.create({
            data: {
              playerId,
              vehicleType,
              vehicleId,
              stolenInCountry,
              currentLocation: player.currentCountry,
              condition,
              fuelLevel,
              marketListing: false,
            },
          });
        }

        await tx.$executeRaw`
          UPDATE smuggling_shipments
          SET status = 'claimed', claimed_at = NOW()
          WHERE id = ${shipment.id}
        `;

        claimedQty += shipment.quantity;
      }
    });

    return {
      success: true,
      message: `${ready.length} ${scope === 'crew' ? 'crew-' : ''}zending(en) opgehaald in ${this.countryNameById(player.currentCountry)}`,
      claimedPackages: ready.length,
      claimedQuantity: claimedQty,
    };
  }
}

export const smugglingService = new SmugglingService();
