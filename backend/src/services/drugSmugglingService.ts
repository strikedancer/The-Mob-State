import prisma from '../lib/prisma';
import countries from '../../content/countries.json';
import { getTravelCost, isValidCountry } from './travelService';

type ShipmentStatus = 'in_transit' | 'ready' | 'seized' | 'claimed';

interface ShipmentRow {
  id: number;
  player_id: number;
  origin_country: string;
  destination_country: string;
  drug_type: string;
  quality: string;
  quantity: number;
  status: ShipmentStatus;
  seizure_chance: number;
  shipping_fee: number;
  eta_at: Date;
  created_at: Date;
  delivered_at: Date | null;
  claimed_at: Date | null;
}

class DrugSmugglingService {
  private initialized = false;

  private async ensureTable(): Promise<void> {
    if (this.initialized) return;

    await prisma.$executeRaw`
      CREATE TABLE IF NOT EXISTS drug_smuggling_shipments (
        id INT NOT NULL AUTO_INCREMENT,
        player_id INT NOT NULL,
        origin_country VARCHAR(50) NOT NULL,
        destination_country VARCHAR(50) NOT NULL,
        drug_type VARCHAR(50) NOT NULL,
        quality VARCHAR(2) NOT NULL DEFAULT 'C',
        quantity INT NOT NULL,
        status VARCHAR(20) NOT NULL DEFAULT 'in_transit',
        seizure_chance DECIMAL(6,4) NOT NULL DEFAULT 0.0500,
        shipping_fee INT NOT NULL DEFAULT 0,
        eta_at DATETIME NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        delivered_at DATETIME NULL,
        claimed_at DATETIME NULL,
        PRIMARY KEY (id),
        INDEX idx_smuggle_player_status_country (player_id, status, destination_country),
        INDEX idx_smuggle_player_eta (player_id, eta_at)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
    `;

    this.initialized = true;
  }

  private clamp(value: number, min: number, max: number): number {
    return Math.max(min, Math.min(max, value));
  }

  private async refreshDueShipments(playerId: number): Promise<void> {
    await this.ensureTable();

    const due = await prisma.$queryRaw<ShipmentRow[]>`
      SELECT *
      FROM drug_smuggling_shipments
      WHERE player_id = ${playerId}
        AND status = 'in_transit'
        AND eta_at <= NOW()
      ORDER BY id ASC
    `;

    for (const shipment of due) {
      const seized = Math.random() < Number(shipment.seizure_chance);
      const nextStatus: ShipmentStatus = seized ? 'seized' : 'ready';

      await prisma.$executeRaw`
        UPDATE drug_smuggling_shipments
        SET status = ${nextStatus}, delivered_at = NOW()
        WHERE id = ${shipment.id}
      `;
    }
  }

  async sendShipment(
    playerId: number,
    destinationCountry: string,
    drugType: string,
    quantity: number,
    quality: string = 'C'
  ): Promise<{ success: boolean; message: string; shipmentId?: number; etaMinutes?: number; shippingFee?: number; seizureChance?: number }> {
    await this.ensureTable();

    if (!isValidCountry(destinationCountry)) {
      return { success: false, message: 'Bestemmingsland bestaat niet' };
    }

    if (!drugType || quantity <= 0) {
      return { success: false, message: 'Ongeldige zending' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true, wantedLevel: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    if (destinationCountry === player.currentCountry) {
      return { success: false, message: 'Gebruik lokale verkoop of opslag voor hetzelfde land' };
    }

    const inventory = await prisma.drugInventory.findUnique({
      where: {
        playerId_country_drugType_quality: {
          playerId,
          country: player.currentCountry,
          drugType,
          quality,
        },
      },
    });

    if (!inventory || inventory.quantity < quantity) {
      return { success: false, message: `Je hebt niet genoeg ${drugType} (${quality})` };
    }

    const travelCost = getTravelCost(player.currentCountry, destinationCountry);
    const shippingFee = Math.max(350, Math.round(travelCost * 0.55 + quantity * 4));
    const etaMinutes = this.clamp(30 + Math.round(travelCost / 60), 30, 240);
    const seizureChance = this.clamp(0.04 + player.wantedLevel * 0.012 + quantity / 4000, 0.03, 0.35);

    const etaAt = new Date(Date.now() + etaMinutes * 60 * 1000);

    const result = await prisma.$transaction(async (tx) => {
      const playerMoney = await tx.player.findUnique({
        where: { id: playerId },
        select: { money: true },
      });

      if (!playerMoney || playerMoney.money < shippingFee) {
        return { success: false, message: 'Niet genoeg geld voor verzendkosten' } as const;
      }

      if (inventory.quantity === quantity) {
        await tx.drugInventory.delete({
          where: {
            playerId_country_drugType_quality: {
              playerId,
              country: player.currentCountry,
              drugType,
              quality,
            },
          },
        });
      } else {
        await tx.drugInventory.update({
          where: {
            playerId_country_drugType_quality: {
              playerId,
              country: player.currentCountry,
              drugType,
              quality,
            },
          },
          data: { quantity: inventory.quantity - quantity },
        });
      }

      await tx.player.update({
        where: { id: playerId },
        data: {
          money: { decrement: shippingFee },
          drugHeat: { increment: 2 },
        },
      });

      await tx.$executeRaw`
        INSERT INTO drug_smuggling_shipments
          (player_id, origin_country, destination_country, drug_type, quality, quantity, status, seizure_chance, shipping_fee, eta_at)
        VALUES
          (${playerId}, ${player.currentCountry}, ${destinationCountry}, ${drugType}, ${quality}, ${quantity}, 'in_transit', ${seizureChance}, ${shippingFee}, ${etaAt})
      `;

      const inserted = await tx.$queryRaw<Array<{ id: number }>>`
        SELECT id
        FROM drug_smuggling_shipments
        WHERE player_id = ${playerId}
        ORDER BY id DESC
        LIMIT 1
      `;

      return {
        success: true,
        message: `Zending vertrokken naar ${destinationCountry}. Verwachte aankomst: ~${etaMinutes} min.`,
        shipmentId: inserted[0]?.id,
      } as const;
    });

    if (!result.success) {
      return result;
    }

    return {
      success: true,
      message: result.message,
      shipmentId: result.shipmentId,
      etaMinutes,
      shippingFee,
      seizureChance,
    };
  }

  async getOverview(playerId: number, currentCountry: string): Promise<{ success: boolean; shipments: any[]; depots: any[] }> {
    await this.refreshDueShipments(playerId);

    const shipments = await prisma.$queryRaw<ShipmentRow[]>`
      SELECT *
      FROM drug_smuggling_shipments
      WHERE player_id = ${playerId}
      ORDER BY id DESC
      LIMIT 100
    `;

    const countryNameById = new Map((countries as Array<{ id: string; name: string }>).map((c) => [c.id, c.name]));

    const mappedShipments = shipments.map((s) => ({
      id: s.id,
      originCountry: s.origin_country,
      originCountryName: countryNameById.get(s.origin_country) ?? s.origin_country,
      destinationCountry: s.destination_country,
      destinationCountryName: countryNameById.get(s.destination_country) ?? s.destination_country,
      drugType: s.drug_type,
      quality: s.quality,
      quantity: s.quantity,
      status: s.status,
      shippingFee: s.shipping_fee,
      seizureChance: Number(s.seizure_chance),
      etaAt: s.eta_at,
      createdAt: s.created_at,
      deliveredAt: s.delivered_at,
      claimedAt: s.claimed_at,
      canClaimHere: s.status === 'ready' && s.destination_country === currentCountry,
    }));

    const depots = await prisma.$queryRaw<Array<{ destination_country: string; packages: bigint; total_quantity: bigint }>>`
      SELECT destination_country,
             COUNT(*) AS packages,
             COALESCE(SUM(quantity), 0) AS total_quantity
      FROM drug_smuggling_shipments
      WHERE player_id = ${playerId}
        AND status = 'ready'
      GROUP BY destination_country
      ORDER BY destination_country ASC
    `;

    const mappedDepots = depots.map((d) => ({
      countryId: d.destination_country,
      countryName: countryNameById.get(d.destination_country) ?? d.destination_country,
      packages: Number(d.packages),
      totalQuantity: Number(d.total_quantity),
      canClaimHere: d.destination_country === currentCountry,
    }));

    return {
      success: true,
      shipments: mappedShipments,
      depots: mappedDepots,
    };
  }

  async claimReadyInCurrentCountry(playerId: number): Promise<{ success: boolean; message: string; claimedPackages?: number; claimedQuantity?: number }> {
    await this.ensureTable();

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    if (!player) {
      return { success: false, message: 'Speler niet gevonden' };
    }

    await this.refreshDueShipments(playerId);

    const ready = await prisma.$queryRaw<ShipmentRow[]>`
      SELECT *
      FROM drug_smuggling_shipments
      WHERE player_id = ${playerId}
        AND destination_country = ${player.currentCountry}
        AND status = 'ready'
      ORDER BY id ASC
    `;

    if (ready.length === 0) {
      return { success: false, message: 'Geen zendingen klaar in dit depot' };
    }

    let claimedQty = 0;

    await prisma.$transaction(async (tx) => {
      for (const s of ready) {
        const existing = await tx.drugInventory.findUnique({
          where: {
            playerId_country_drugType_quality: {
              playerId,
              country: s.destination_country,
              drugType: s.drug_type,
              quality: s.quality,
            },
          },
        });

        if (existing) {
          await tx.drugInventory.update({
            where: {
              playerId_country_drugType_quality: {
                playerId,
                country: s.destination_country,
                drugType: s.drug_type,
                quality: s.quality,
              },
            },
            data: { quantity: existing.quantity + s.quantity },
          });
        } else {
          await tx.drugInventory.create({
            data: {
              playerId,
              country: s.destination_country,
              drugType: s.drug_type,
              quality: s.quality,
              quantity: s.quantity,
            },
          });
        }

        await tx.$executeRaw`
          UPDATE drug_smuggling_shipments
          SET status = 'claimed', claimed_at = NOW()
          WHERE id = ${s.id}
        `;

        claimedQty += s.quantity;
      }
    });

    return {
      success: true,
      message: `${ready.length} pakket(ten) opgehaald uit depot`,
      claimedPackages: ready.length,
      claimedQuantity: claimedQty,
    };
  }
}

export const drugSmugglingService = new DrugSmugglingService();
