import { readFileSync } from 'fs';
import { join } from 'path';
import prisma from '../lib/prisma';
import toolService from './toolService';
import { weaponService } from './weaponService';
import { ammoService } from './ammoService';
import backpackService from './backpackService';

type StorageCategory = 'tools' | 'drugs' | 'weapons' | 'cash' | 'ammo' | 'armor';

const PROPERTY_STORAGE_RULES: Record<string, StorageCategory[]> = {
  warehouse: ['tools'],
  nightclub: ['drugs'],
  house: ['weapons', 'cash', 'ammo', 'armor'],
  apartment: ['weapons', 'cash', 'ammo', 'armor'],
  mansion: ['weapons', 'cash', 'ammo', 'armor'],
  penthouse: ['weapons', 'cash', 'ammo', 'armor'],
  safehouse: ['weapons', 'cash', 'ammo', 'armor'],
};

const CASH_SLOT_VALUE = 10000;
const AMMO_ROUNDS_PER_SLOT = 50;

const NON_DRUG_STORAGE_FILTER = [
  { drugType: { startsWith: 'weapon:' } },
  { drugType: { startsWith: 'weapon_' } },
  { drugType: { startsWith: 'ammo:' } },
  { drugType: { startsWith: 'armor:' } },
  { drugType: { startsWith: 'armorcond:' } },
  { drugType: '__cash__' },
];

type ArmorDef = { id: string; name: string; armor: number };

function loadArmorDefinitions(): ArmorDef[] {
  const raw = readFileSync(join(__dirname, '../../content/security.json'), 'utf8');
  return JSON.parse(raw) as ArmorDef[];
}

class PropertyStorageService {
  getAllowedCategories(propertyType: string): StorageCategory[] {
    return PROPERTY_STORAGE_RULES[propertyType] ?? [];
  }

  private async getPlayerAndProperty(playerId: number, propertyId: number) {
    const [player, property] = await Promise.all([
      prisma.player.findUnique({ where: { id: playerId }, select: { currentCountry: true } }),
      prisma.property.findFirst({ where: { id: propertyId, playerId } }),
    ]);

    if (!player || !property) {
      throw new Error('PROPERTY_NOT_FOUND');
    }

    return { player, property };
  }

  private ensureCountryAccess(playerCountry: string, propertyCountry: string) {
    if (playerCountry !== propertyCountry) {
      throw new Error('WRONG_COUNTRY');
    }
  }

  private async getCapacity(propertyType: string): Promise<number> {
    const configured = await prisma.propertyStorageCapacity.findUnique({
      where: { propertyType },
      select: { maxSlots: true },
    });
    return configured?.maxSlots ?? 20;
  }

  private async getWeaponStorage(propertyId: number) {
    const rows = await prisma.propertyDrugStorage.findMany({
      where: {
        propertyId,
        OR: [{ drugType: { startsWith: 'weapon:' } }, { drugType: { startsWith: 'weapon_' } }],
      },
      orderBy: { drugType: 'asc' },
    });

    const weaponsById = new Map(
      weaponService.getAllWeapons().map((weapon) => [weapon.id, weapon.name]),
    );

    return rows.map((row) => ({
      weaponId: row.drugType.startsWith('weapon:')
        ? row.drugType.replace('weapon:', '')
        : row.drugType.replace('weapon_', ''),
      name: weaponsById.get(
        row.drugType.startsWith('weapon:')
          ? row.drugType.replace('weapon:', '')
          : row.drugType.replace('weapon_', ''),
      ),
      quantity: row.quantity,
    }));
  }

  private async getCashStorage(propertyId: number): Promise<number> {
    const row = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: '__cash__',
        },
      },
      select: { quantity: true },
    });

    return row?.quantity ?? 0;
  }

  async getPropertyStorageOverview(playerId: number) {
    const properties = await prisma.property.findMany({
      where: { playerId },
      orderBy: { purchasedAt: 'desc' },
    });

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });

    const overview = [] as any[];

    for (const property of properties) {
      const allowedCategories = this.getAllowedCategories(property.propertyType);
      const capacity = await this.getCapacity(property.propertyType);

      let toolCount = 0;
      let tools: any[] = [];
      let drugCount = 0;
      let weaponCount = 0;
      let cashAmount = 0;
      let usage = 0;

      if (allowedCategories.includes('tools')) {
        tools = await toolService.getPropertyStorage(playerId, property.id);
        toolCount = tools.length;
        usage += await toolService.getPropertyStorageUsage(playerId, property.id);
      }

      if (allowedCategories.includes('drugs')) {
        const drugs = await prisma.propertyDrugStorage.findMany({
          where: {
            propertyId: property.id,
            NOT: NON_DRUG_STORAGE_FILTER,
          },
          select: { quantity: true },
        });
        drugCount = drugs.reduce((sum, row) => sum + row.quantity, 0);
        usage += drugCount;
      }

      if (allowedCategories.includes('weapons')) {
        const weapons = await this.getWeaponStorage(property.id);
        weaponCount = weapons.reduce((sum, row) => sum + row.quantity, 0);
        usage += weaponCount;
      }

      if (allowedCategories.includes('cash')) {
        cashAmount = await this.getCashStorage(property.id);
        usage += Math.ceil(cashAmount / CASH_SLOT_VALUE);
      }

      let ammoCount = 0;
      let armorCount = 0;
      if (allowedCategories.includes('ammo')) {
        const ammo = await this.getAmmoStorage(property.id);
        ammoCount = ammo.reduce((sum, row) => sum + row.quantity, 0);
        usage += this.ammoSlotsForQuantity(ammoCount);
      }
      if (allowedCategories.includes('armor')) {
        const armor = await this.getArmorStorage(property.id);
        armorCount = armor.reduce((sum, row) => sum + row.quantity, 0);
        usage += armorCount;
      }

      const accessibleInCurrentCountry = player?.currentCountry === property.countryId;

      overview.push({
        propertyId: property.id,
        propertyType: property.propertyType,
        propertyCountry: property.countryId,
        allowedCategories,
        usage,
        capacity,
        percentFull: capacity > 0 ? Math.min(100, Math.round((usage / capacity) * 100)) : 0,
        toolCount,
        tools,
        weaponCount,
        ammoCount,
        armorCount,
        drugCount,
        cashAmount,
        accessibleInCurrentCountry,
      });
    }

    return overview;
  }

  async getPropertyStorageDetail(playerId: number, propertyId: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowedCategories = this.getAllowedCategories(property.propertyType);
    const capacity = await this.getCapacity(property.propertyType);

    const tools = allowedCategories.includes('tools')
      ? await toolService.getPropertyStorage(playerId, property.id)
      : [];

    const drugs = allowedCategories.includes('drugs')
      ? await prisma.propertyDrugStorage.findMany({
          where: {
            propertyId: property.id,
            NOT: NON_DRUG_STORAGE_FILTER,
          },
          select: { drugType: true, quantity: true },
          orderBy: { drugType: 'asc' },
        })
      : [];

    const weapons = allowedCategories.includes('weapons')
      ? await this.getWeaponStorage(property.id)
      : [];

    const ammo = allowedCategories.includes('ammo')
      ? await this.getAmmoStorage(property.id)
      : [];

    const armor = allowedCategories.includes('armor')
      ? await this.getArmorStorage(property.id)
      : [];

    const cashAmount = allowedCategories.includes('cash')
      ? await this.getCashStorage(property.id)
      : 0;

    const toolUsage = allowedCategories.includes('tools')
      ? await toolService.getPropertyStorageUsage(playerId, property.id)
      : 0;
    const drugUsage = drugs.reduce((sum, row) => sum + row.quantity, 0);
    const weaponUsage = weapons.reduce((sum, row) => sum + row.quantity, 0);
    const ammoUsage = this.ammoSlotsForQuantity(
      ammo.reduce((sum, row) => sum + row.quantity, 0),
    );
    const armorUsage = armor.reduce((sum, row) => sum + row.quantity, 0);
    const cashUsage = Math.ceil(cashAmount / CASH_SLOT_VALUE);
    const usage = toolUsage + drugUsage + weaponUsage + ammoUsage + armorUsage + cashUsage;

    return {
      propertyId: property.id,
      propertyType: property.propertyType,
      propertyCountry: property.countryId,
      allowedCategories,
      capacity,
      usage,
      percentFull: capacity > 0 ? Math.min(100, Math.round((usage / capacity) * 100)) : 0,
      tools,
      weapons,
      ammo,
      armor,
      drugs,
      cashAmount,
    };
  }

  async depositWeapon(playerId: number, propertyId: number, weaponId: string, quantity: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('weapons')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    const weapon = await prisma.weaponInventory.findUnique({
      where: {
        playerId_weaponId: {
          playerId,
          weaponId,
        },
      },
    });

    if (!weapon || weapon.quantity < quantity) {
      throw new Error('INSUFFICIENT_WEAPON_QUANTITY');
    }

    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    if (detail.usage + quantity > detail.capacity) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      if (weapon.quantity === quantity) {
        await tx.weaponInventory.delete({ where: { id: weapon.id } });
      } else {
        await tx.weaponInventory.update({
          where: { id: weapon.id },
          data: { quantity: weapon.quantity - quantity },
        });
      }

      const storageKey = `weapon:${weaponId}`;
      const existing = await tx.propertyDrugStorage.findUnique({
        where: {
          propertyId_drugType: {
            propertyId,
            drugType: storageKey,
          },
        },
      });

      if (existing) {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + quantity },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: {
            propertyId,
            drugType: storageKey,
            quantity,
          },
        });
      }
    });
  }

  async withdrawWeapon(
    playerId: number,
    propertyId: number,
    weaponId: string,
    quantity: number,
    options?: { equip?: boolean },
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('weapons')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    const withdrawQty = options?.equip ? 1 : quantity;
    const storageKey = `weapon:${weaponId}`;
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: storageKey,
        },
      },
    });

    if (!stored || stored.quantity < withdrawQty) {
      throw new Error('INSUFFICIENT_WEAPON_QUANTITY');
    }

    const usage = await toolService.calculateInventoryUsage(playerId);
    const capacity = await backpackService.getPlayerCarryingCapacity(playerId);
    const incomingSlots = options?.equip ? 0 : withdrawQty;
    if (usage + incomingSlots > capacity) {
      throw new Error('INVENTORY_FULL');
    }

    await prisma.$transaction(async (tx) => {
      if (stored.quantity === withdrawQty) {
        await tx.propertyDrugStorage.delete({ where: { id: stored.id } });
      } else {
        await tx.propertyDrugStorage.update({
          where: { id: stored.id },
          data: { quantity: stored.quantity - withdrawQty },
        });
      }

      const existing = await tx.weaponInventory.findUnique({
        where: {
          playerId_weaponId: {
            playerId,
            weaponId,
          },
        },
      });

      if (existing) {
        await tx.weaponInventory.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + withdrawQty },
        });
      } else {
        await tx.weaponInventory.create({
          data: {
            playerId,
            weaponId,
            quantity: withdrawQty,
            condition: 100,
          },
        });
      }
    });

    const newUsage = await toolService.calculateInventoryUsage(playerId);
    await prisma.player.update({
      where: { id: playerId },
      data: { inventory_slots_used: newUsage },
    });
  }

  private ammoSlotsForQuantity(rounds: number): number {
    if (rounds <= 0) return 0;
    return Math.ceil(rounds / AMMO_ROUNDS_PER_SLOT);
  }

  private async getAmmoStorage(propertyId: number) {
    const rows = await prisma.propertyDrugStorage.findMany({
      where: { propertyId, drugType: { startsWith: 'ammo:' } },
      orderBy: { drugType: 'asc' },
    });
    return rows.map((row) => {
      const ammoType = row.drugType.slice('ammo:'.length);
      const def = ammoService.getAmmoDefinition(ammoType);
      return {
        ammoType,
        name: def?.name ?? ammoType,
        quantity: row.quantity,
      };
    });
  }

  private async getArmorStorage(propertyId: number) {
    const rows = await prisma.propertyDrugStorage.findMany({
      where: { propertyId, drugType: { startsWith: 'armor:' } },
      orderBy: { drugType: 'asc' },
    });
    const defs = loadArmorDefinitions();
    const condRows = await prisma.propertyDrugStorage.findMany({
      where: { propertyId, drugType: { startsWith: 'armorcond:' } },
    });
    const condByType = new Map(
      condRows.map((row) => [row.drugType.slice('armorcond:'.length), row.quantity]),
    );
    return rows.map((row) => {
      const armorId = row.drugType.slice('armor:'.length);
      const def = defs.find((item) => item.id === armorId);
      return {
        armorId,
        name: def?.name ?? armorId,
        quantity: row.quantity,
        condition: condByType.get(armorId) ?? 100,
        armor: def?.armor ?? 0,
      };
    });
  }

  private async bumpStorageKey(
    tx: any,
    propertyId: number,
    storageKey: string,
    delta: number,
  ) {
    const existing = await tx.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: storageKey } },
    });
    if (delta > 0) {
      if (existing) {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + delta },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: { propertyId, drugType: storageKey, quantity: delta },
        });
      }
      return;
    }
    if (!existing || existing.quantity + delta < 0) {
      throw new Error('INSUFFICIENT_QUANTITY');
    }
    if (existing.quantity + delta === 0) {
      await tx.propertyDrugStorage.delete({ where: { id: existing.id } });
    } else {
      await tx.propertyDrugStorage.update({
        where: { id: existing.id },
        data: { quantity: existing.quantity + delta },
      });
    }
  }

  async depositAmmo(playerId: number, propertyId: number, ammoType: string, quantity: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    if (!this.getAllowedCategories(property.propertyType).includes('ammo')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }
    if (!ammoService.getAmmoDefinition(ammoType)) {
      throw new Error('AMMO_NOT_FOUND');
    }

    const inv = await prisma.ammoInventory.findUnique({
      where: { playerId_ammoType: { playerId, ammoType } },
    });
    if (!inv || inv.quantity < quantity) {
      throw new Error('INSUFFICIENT_AMMO_QUANTITY');
    }

    const stored = await this.getAmmoStorage(propertyId);
    const currentRounds = stored.reduce((sum, row) => sum + row.quantity, 0);
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    const deltaSlots =
      this.ammoSlotsForQuantity(currentRounds + quantity) -
      this.ammoSlotsForQuantity(currentRounds);
    if (detail.usage + deltaSlots > detail.capacity) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      if (inv.quantity === quantity) {
        await tx.ammoInventory.delete({ where: { id: inv.id } });
      } else {
        await tx.ammoInventory.update({
          where: { id: inv.id },
          data: { quantity: inv.quantity - quantity },
        });
      }
      await this.bumpStorageKey(tx, propertyId, `ammo:${ammoType}`, quantity);
    });
  }

  async withdrawAmmo(playerId: number, propertyId: number, ammoType: string, quantity: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    if (!this.getAllowedCategories(property.propertyType).includes('ammo')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }
    const def = ammoService.getAmmoDefinition(ammoType);
    if (!def) {
      throw new Error('AMMO_NOT_FOUND');
    }

    const storageKey = `ammo:${ammoType}`;
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: storageKey } },
    });
    if (!stored || stored.quantity < quantity) {
      throw new Error('INSUFFICIENT_AMMO_QUANTITY');
    }

    const inv = await prisma.ammoInventory.findUnique({
      where: { playerId_ammoType: { playerId, ammoType } },
    });
    const nextQty = (inv?.quantity ?? 0) + quantity;
    if (def.maxInventory && nextQty > def.maxInventory) {
      throw new Error('AMMO_INVENTORY_FULL');
    }

    await prisma.$transaction(async (tx) => {
      await this.bumpStorageKey(tx, propertyId, storageKey, -quantity);
      if (inv) {
        await tx.ammoInventory.update({
          where: { id: inv.id },
          data: { quantity: inv.quantity + quantity },
        });
      } else {
        await tx.ammoInventory.create({
          data: { playerId, ammoType, quantity },
        });
      }
    });
  }

  async depositArmor(playerId: number, propertyId: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    if (!this.getAllowedCategories(property.propertyType).includes('armor')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    const security = await prisma.playerSecurity.findUnique({ where: { playerId } });
    const armorId = security?.armorType;
    if (!security || !armorId || Number(security.armor || 0) <= 0) {
      throw new Error('ARMOR_NOT_EQUIPPED');
    }

    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    if (detail.usage + 1 > detail.capacity) {
      throw new Error('STORAGE_FULL');
    }

    const condition = Math.max(1, Math.min(100, Number(security.armorCondition ?? 100)));

    await prisma.$transaction(async (tx) => {
      await this.bumpStorageKey(tx, propertyId, `armor:${armorId}`, 1);
      const condKey = `armorcond:${armorId}`;
      const existingCond = await tx.propertyDrugStorage.findUnique({
        where: { propertyId_drugType: { propertyId, drugType: condKey } },
      });
      if (existingCond) {
        await tx.propertyDrugStorage.update({
          where: { id: existingCond.id },
          data: { quantity: condition },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: { propertyId, drugType: condKey, quantity: condition },
        });
      }
      await tx.playerSecurity.update({
        where: { playerId },
        data: { armor: 0, armorCondition: 100, armorType: null },
      });
    });
  }

  async withdrawArmor(playerId: number, propertyId: number, armorId: string) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    if (!this.getAllowedCategories(property.propertyType).includes('armor')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    const defs = loadArmorDefinitions();
    const def = defs.find((item) => item.id === armorId);
    if (!def) {
      throw new Error('ARMOR_NOT_FOUND');
    }

    const storageKey = `armor:${armorId}`;
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: storageKey } },
    });
    if (!stored || stored.quantity < 1) {
      throw new Error('INSUFFICIENT_ARMOR_QUANTITY');
    }

    const security = await prisma.playerSecurity.findUnique({ where: { playerId } });
    if (security && security.armorType && Number(security.armor || 0) > 0) {
      throw new Error('ARMOR_ALREADY_EQUIPPED');
    }

    const condRow = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: { propertyId, drugType: `armorcond:${armorId}` },
      },
    });
    const condition = Math.max(1, Math.min(100, condRow?.quantity ?? 100));

    await prisma.$transaction(async (tx) => {
      await this.bumpStorageKey(tx, propertyId, storageKey, -1);
      if (condRow && stored.quantity <= 1) {
        await tx.propertyDrugStorage.delete({ where: { id: condRow.id } });
      }
      if (security) {
        await tx.playerSecurity.update({
          where: { playerId },
          data: { armor: def.armor, armorCondition: condition, armorType: armorId },
        });
      } else {
        await tx.playerSecurity.create({
          data: {
            playerId,
            armor: def.armor,
            armorCondition: condition,
            armorType: armorId,
            bodyguardUpkeepDueAt: null,
          },
        });
      }
    });
  }

  async depositCash(playerId: number, propertyId: number, amount: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('cash')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    if (amount <= 0) throw new Error('INVALID_AMOUNT');

    const currentPlayer = await prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true },
    });

    if (!currentPlayer || currentPlayer.money < amount) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    const cashStored = await this.getCashStorage(propertyId);
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    const currentCashSlots = Math.ceil(cashStored / CASH_SLOT_VALUE);
    const newCashSlots = Math.ceil((cashStored + amount) / CASH_SLOT_VALUE);
    const deltaSlots = newCashSlots - currentCashSlots;

    if (detail.usage + deltaSlots > detail.capacity) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      await tx.player.update({
        where: { id: playerId },
        data: { money: { decrement: amount } },
      });

      const existing = await tx.propertyDrugStorage.findUnique({
        where: {
          propertyId_drugType: {
            propertyId,
            drugType: '__cash__',
          },
        },
      });

      if (existing) {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + amount },
        });
      } else {
        await tx.propertyDrugStorage.create({
          data: {
            propertyId,
            drugType: '__cash__',
            quantity: amount,
          },
        });
      }
    });
  }

  async withdrawCash(playerId: number, propertyId: number, amount: number) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);

    const allowed = this.getAllowedCategories(property.propertyType);
    if (!allowed.includes('cash')) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }

    if (amount <= 0) throw new Error('INVALID_AMOUNT');

    const existing = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: '__cash__',
        },
      },
    });

    if (!existing || existing.quantity < amount) {
      throw new Error('INSUFFICIENT_FUNDS');
    }

    await prisma.$transaction(async (tx) => {
      if (existing.quantity === amount) {
        await tx.propertyDrugStorage.delete({ where: { id: existing.id } });
      } else {
        await tx.propertyDrugStorage.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity - amount },
        });
      }

      await tx.player.update({
        where: { id: playerId },
        data: { money: { increment: amount } },
      });
    });
  }
}

export const propertyStorageService = new PropertyStorageService();
