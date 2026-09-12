import { readFileSync } from 'fs';
import { join } from 'path';
import prisma from '../lib/prisma';
import toolService from './toolService';
import { weaponService } from './weaponService';
import { ammoService } from './ammoService';
import backpackService from './backpackService';
import { catalogStorageCapacity } from '../utils/propertyCatalogStorage';
import tradableGoods from '../../content/tradableGoods.json';
import {
  allowedStorageCategories,
  type StorageCategory,
} from '../constants/propertyStorageRules';
import {
  STASH_DRUG_PREFIX,
  STASH_PROPERTY_TYPES,
  STASH_TRADE_PX_PREFIX,
  AMMO_ROUNDS_PER_SLOT,
  ammoSlotsForRounds,
  CASH_PER_SLOT,
  cashSlotsForAmount,
  computePropertySlotUsage,
  DRUG_GRAMS_PER_SLOT,
  MATERIAL_UNITS_PER_SLOT,
  maxAddForSlotStack,
  drugStashKey,
  isMetaStashKey,
  materialStashKey,
  parseDrugStashKey,
  parseMaterialStashKey,
  parseTradeStashKey,
  tradePriceStashKey,
  tradeStashKey,
} from '../utils/propertyStash';
import {
  addMaterialStock,
  CARRIED_MATERIAL_LOCATION,
  isCarriedLocation,
  materialSlotsForQuantity,
  removeMaterialStock,
} from './productionMaterialStock';
import {
  assertBackpackFits,
  creditCarriedTrade,
  debitBackpackTrade,
  extraSlotsForDrugAdd,
  extraSlotsForTradeAdd,
  getBackpackTradeQuantity,
  refreshInventorySlotUsage,
} from './carriedInventory';

const DRUG_QUALITIES = new Set(['D', 'C', 'B', 'A', 'S']);

type NamedCatalogItem = { id: string; name?: string; displayName?: string };

function loadNamedCatalog(
  fileName: string,
  listKey: 'drugs' | 'materials',
): Map<string, string> {
  try {
    const raw = JSON.parse(
      readFileSync(join(__dirname, `../../content/${fileName}`), 'utf8'),
    ) as Record<string, NamedCatalogItem[]>;
    const items = raw[listKey] ?? [];
    return new Map(
      items.map((item) => [item.id, item.displayName || item.name || item.id]),
    );
  } catch {
    return new Map();
  }
}

const MATERIAL_NAMES = loadNamedCatalog('drugs.json', 'materials');
const DRUG_NAMES = loadNamedCatalog('drugs.json', 'drugs');
const TRADE_NAMES = new Map(
  (tradableGoods as NamedCatalogItem[]).map((item) => [
    item.id,
    item.name || item.id,
  ]),
);

const NON_DRUG_STORAGE_FILTER = [
  { drugType: { startsWith: 'weapon:' } },
  { drugType: { startsWith: 'weapon_' } },
  { drugType: { startsWith: 'ammo:' } },
  { drugType: { startsWith: 'armor:' } },
  { drugType: { startsWith: 'armorcond:' } },
  { drugType: { startsWith: 'material:' } },
  { drugType: { startsWith: 'drug:' } },
  { drugType: { startsWith: 'trade:' } },
  { drugType: { startsWith: 'tradepx:' } },
  { drugType: '__cash__' },
];

type ArmorDef = { id: string; name: string; armor: number };

function loadArmorDefinitions(): ArmorDef[] {
  const raw = readFileSync(join(__dirname, '../../content/security.json'), 'utf8');
  return JSON.parse(raw) as ArmorDef[];
}

class PropertyStorageService {
  getAllowedCategories(propertyType: string): StorageCategory[] {
    return allowedStorageCategories(propertyType);
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

  private async getCapacity(
    propertyType: string,
    upgradeLevel = 1,
  ): Promise<number> {
    const fromCatalog = catalogStorageCapacity(propertyType, upgradeLevel);
    if (fromCatalog != null) return fromCatalog;
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
      const capacity = await this.getCapacity(
        property.propertyType,
        property.upgradeLevel,
      );

      let toolCount = 0;
      let tools: any[] = [];
      let drugCount = 0;
      let leftoverDrugRows: Array<{ drugType: string; quantity: number }> = [];
      let weaponCount = 0;
      let cashAmount = 0;
      let toolUsage = 0;

      if (allowedCategories.includes('tools')) {
        tools = await toolService.getPropertyStorage(playerId, property.id);
        toolCount = tools.length;
        toolUsage = await toolService.getPropertyStorageUsage(playerId, property.id);
      }

      if (allowedCategories.includes('drugs')) {
        leftoverDrugRows = await prisma.propertyDrugStorage.findMany({
          where: {
            propertyId: property.id,
            NOT: NON_DRUG_STORAGE_FILTER,
          },
          select: { drugType: true, quantity: true },
        });
        drugCount = leftoverDrugRows.reduce((sum, row) => sum + row.quantity, 0);
      }

      if (allowedCategories.includes('weapons')) {
        const weapons = await this.getWeaponStorage(property.id);
        weaponCount = weapons.reduce((sum, row) => sum + row.quantity, 0);
      }

      if (allowedCategories.includes('cash')) {
        cashAmount = await this.getCashStorage(property.id);
      }

      let ammoCount = 0;
      let armorCount = 0;
      let ammoUsage = 0;
      if (allowedCategories.includes('ammo')) {
        const ammo = await this.getAmmoStorage(property.id);
        ammoCount = ammo.reduce((sum, row) => sum + row.quantity, 0);
        ammoUsage = ammo.reduce(
          (sum, row) => sum + ammoSlotsForRounds(row.quantity),
          0,
        );
      }
      if (allowedCategories.includes('armor')) {
        const armor = await this.getArmorStorage(property.id);
        armorCount = armor.reduce((sum, row) => sum + row.quantity, 0);
      }

      const stashRows = await prisma.propertyDrugStorage.findMany({
        where: { propertyId: property.id },
        select: { drugType: true, quantity: true },
      });
      const usage = computePropertySlotUsage({
        toolUsage,
        weaponQuantity: weaponCount,
        ammoUsage,
        armorQuantity: armorCount,
        cashAmount,
        leftoverDrugRows,
        stashRows,
      });

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
    const capacity = await this.getCapacity(
      property.propertyType,
      property.upgradeLevel,
    );

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

    const stashRows = await prisma.propertyDrugStorage.findMany({
      where: { propertyId: property.id },
      select: { drugType: true, quantity: true },
    });
    const materials = this.parseMaterialStash(stashRows);
    const finishedDrugs = this.foldLeftoverIntoFinished(
      drugs,
      this.parseFinishedDrugStash(stashRows),
    );
    const trade = this.parseTradeStash(stashRows);
    const leftoverOnly = drugs.filter((row) => !DRUG_NAMES.has(row.drugType));

    const toolUsage = allowedCategories.includes('tools')
      ? await toolService.getPropertyStorageUsage(playerId, property.id)
      : 0;
    const leftoverDrugRows = drugs;
    const weaponQuantity = weapons.reduce((sum, row) => sum + row.quantity, 0);
    const ammoUsage = ammo.reduce(
      (sum, row) => sum + ammoSlotsForRounds(row.quantity),
      0,
    );
    const armorQuantity = armor.reduce((sum, row) => sum + row.quantity, 0);
    const usage = computePropertySlotUsage({
      toolUsage,
      weaponQuantity,
      ammoUsage,
      armorQuantity,
      cashAmount,
      leftoverDrugRows,
      stashRows,
    });

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
      drugs: leftoverOnly,
      materials,
      finishedDrugs,
      trade,
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
    quantity = this.clampToFreeSlots(quantity, detail.usage, detail.capacity);
    if (quantity <= 0) {
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

  private parseMaterialStash(
    rows: Array<{ drugType: string; quantity: number }>,
  ) {
    return rows
      .map((row) => {
        const materialId = parseMaterialStashKey(row.drugType);
        if (!materialId) return null;
        return { materialId, name: MATERIAL_NAMES.get(materialId) ?? materialId, quantity: row.quantity };
      })
      .filter((row): row is { materialId: string; name: string; quantity: number } => !!row);
  }

  private parseFinishedDrugStash(
    rows: Array<{ drugType: string; quantity: number }>,
  ) {
    return rows
      .map((row) => {
        const parsed = parseDrugStashKey(row.drugType);
        if (!parsed) return null;
        return {
          drugType: parsed.drugType,
          quality: parsed.quality,
          name: DRUG_NAMES.get(parsed.drugType) ?? parsed.drugType,
          quantity: row.quantity,
        };
      })
      .filter(
        (
          row,
        ): row is {
          drugType: string;
          quality: string;
          name: string;
          quantity: number;
        } => !!row,
      );
  }

  private foldLeftoverIntoFinished(
    leftoverRows: Array<{ drugType: string; quantity: number }>,
    finished: Array<{
      drugType: string;
      quality: string;
      name: string;
      quantity: number;
    }>,
  ) {
    const merged = finished.map((row) => ({ ...row }));
    for (const row of leftoverRows) {
      if (!row.drugType || row.quantity <= 0) continue;
      if (row.drugType.includes(':')) continue;
      if (!DRUG_NAMES.has(row.drugType)) continue;
      const target = merged.find(
        (item) => item.drugType === row.drugType && item.quality === 'C',
      );
      if (target) {
        target.quantity += row.quantity;
      } else {
        merged.push({
          drugType: row.drugType,
          quality: 'C',
          name: DRUG_NAMES.get(row.drugType) ?? row.drugType,
          quantity: row.quantity,
        });
      }
    }
    return merged;
  }

  private async findUnprefixedDrugRow(propertyId: number, drugType: string) {
    if (!DRUG_NAMES.has(drugType)) return null;
    return prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType } },
    });
  }

  private async otherPrefixedDrugQualities(
    propertyId: number,
    drugType: string,
    quality: string,
  ) {
    const prefix = `${STASH_DRUG_PREFIX}${drugType}:`;
    const rows = await prisma.propertyDrugStorage.findMany({
      where: { propertyId, drugType: { startsWith: prefix } },
      select: { drugType: true },
    });
    const keep = drugStashKey(drugType, quality);
    return rows.filter((row) => row.drugType !== keep);
  }

  private parseTradeStash(rows: Array<{ drugType: string; quantity: number }>) {
    const priceByGood = new Map<string, number>();
    for (const row of rows) {
      if (row.drugType.startsWith(STASH_TRADE_PX_PREFIX)) {
        priceByGood.set(row.drugType.slice(STASH_TRADE_PX_PREFIX.length), row.quantity);
      }
    }
    return rows
      .map((row) => {
        const goodType = parseTradeStashKey(row.drugType);
        if (!goodType) return null;
        return {
          goodType,
          name: TRADE_NAMES.get(goodType) ?? goodType,
          quantity: row.quantity,
          purchasePrice: priceByGood.get(goodType) ?? 0,
        };
      })
      .filter(
        (
          row,
        ): row is {
          goodType: string;
          name: string;
          quantity: number;
          purchasePrice: number;
        } => !!row,
      );
  }

  private assertStashProperty(propertyType: string, category: StorageCategory) {
    if (!(STASH_PROPERTY_TYPES as readonly string[]).includes(propertyType)) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }
    if (!this.getAllowedCategories(propertyType).includes(category)) {
      throw new Error('STORAGE_TYPE_NOT_ALLOWED');
    }
  }

  private clampToFreeSlots(
    requested: number,
    usage: number,
    capacity: number,
  ): number {
    const free = Math.max(0, capacity - usage);
    return Math.min(requested, free);
  }

  private clampStackDeposit(
    currentQty: number,
    unitsPerSlot: number,
    usage: number,
    capacity: number,
    requested: number,
  ): number {
    const free = Math.max(0, capacity - usage);
    return Math.min(
      requested,
      maxAddForSlotStack(currentQty, unitsPerSlot, free),
    );
  }

  async getTradeQuantityInCountry(
    playerId: number,
    country: string,
    goodType: string,
  ): Promise<number> {
    const properties = await prisma.property.findMany({
      where: {
        playerId,
        countryId: country,
        propertyType: { in: [...STASH_PROPERTY_TYPES] },
      },
      select: { id: true },
    });
    if (properties.length === 0) return 0;
    const key = tradeStashKey(goodType);
    const rows = await prisma.propertyDrugStorage.findMany({
      where: {
        propertyId: { in: properties.map((item) => item.id) },
        drugType: key,
      },
      select: { quantity: true },
    });
    return rows.reduce((sum, row) => sum + row.quantity, 0);
  }

  async depositMaterial(
    playerId: number,
    propertyId: number,
    materialId: string,
    quantity: number,
    source: 'depot' | 'carried',
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    this.assertStashProperty(property.propertyType, 'materials');
    if (quantity <= 0) throw new Error('INVALID_QUANTITY');

    const fromCountry =
      source === 'carried' ? CARRIED_MATERIAL_LOCATION : player.currentCountry;
    const owned = await prisma.productionMaterial.findUnique({
      where: {
        playerId_country_materialId: { playerId, country: fromCountry, materialId },
      },
    });
    if (!owned || owned.quantity < quantity) {
      throw new Error('INSUFFICIENT_MATERIALS');
    }

    const key = materialStashKey(materialId);
    const existing = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: key } },
    });
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    quantity = this.clampStackDeposit(
      existing?.quantity ?? 0,
      MATERIAL_UNITS_PER_SLOT,
      detail.usage,
      detail.capacity,
      quantity,
    );
    if (quantity <= 0) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      await removeMaterialStock(tx, playerId, fromCountry, materialId, quantity);
      await this.bumpStorageKey(tx, propertyId, key, quantity);
    });
    if (isCarriedLocation(fromCountry)) {
      const newUsage = await toolService.calculateInventoryUsage(playerId);
      await prisma.player.update({
        where: { id: playerId },
        data: { inventory_slots_used: newUsage },
      });
    }
  }

  async withdrawMaterial(
    playerId: number,
    propertyId: number,
    materialId: string,
    quantity: number,
    target: 'depot' | 'carried',
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    this.assertStashProperty(property.propertyType, 'materials');
    if (quantity <= 0) throw new Error('INVALID_QUANTITY');

    const key = materialStashKey(materialId);
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: key } },
    });
    if (!stored || stored.quantity < quantity) {
      throw new Error('INSUFFICIENT_MATERIALS');
    }

    const toCountry =
      target === 'carried' ? CARRIED_MATERIAL_LOCATION : player.currentCountry;
    if (target === 'carried') {
      const carried = await prisma.productionMaterial.findUnique({
        where: {
          playerId_country_materialId: {
            playerId,
            country: CARRIED_MATERIAL_LOCATION,
            materialId,
          },
        },
      });
      const extra =
        materialSlotsForQuantity((carried?.quantity ?? 0) + quantity) -
        materialSlotsForQuantity(carried?.quantity ?? 0);
      const usage = await toolService.calculateInventoryUsage(playerId);
      const capacity = await backpackService.getPlayerCarryingCapacity(playerId);
      if (usage + extra > capacity) {
        throw new Error('INVENTORY_FULL');
      }
    }

    await prisma.$transaction(async (tx) => {
      await this.bumpStorageKey(tx, propertyId, key, -quantity);
      await addMaterialStock(tx, playerId, toCountry, materialId, quantity);
    });
    if (target === 'carried') {
      const newUsage = await toolService.calculateInventoryUsage(playerId);
      await prisma.player.update({
        where: { id: playerId },
        data: { inventory_slots_used: newUsage },
      });
    }
  }

  async depositDrug(
    playerId: number,
    propertyId: number,
    drugType: string,
    quality: string,
    quantity: number,
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    this.assertStashProperty(property.propertyType, 'drugs');
    if (quantity <= 0) throw new Error('INVALID_QUANTITY');
    if (!DRUG_NAMES.has(drugType) || !DRUG_QUALITIES.has(quality)) {
      throw new Error('UNKNOWN_DRUG');
    }

    const owned = await prisma.drugInventory.findUnique({
      where: { playerId_drugType_quality: { playerId, drugType, quality } },
    });
    if (!owned || owned.quantity < quantity) {
      throw new Error('INSUFFICIENT_DRUGS');
    }

    const key = drugStashKey(drugType, quality);
    const existing = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: key } },
    });
    const leftover = await this.findUnprefixedDrugRow(propertyId, drugType);
    const otherQualities = await this.otherPrefixedDrugQualities(
      propertyId,
      drugType,
      quality,
    );
    const absorbLeftover =
      leftover != null && leftover.quantity > 0 && otherQualities.length === 0;
    const currentQty =
      (existing?.quantity ?? 0) +
      (absorbLeftover ? leftover?.quantity ?? 0 : 0);
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    quantity = this.clampStackDeposit(
      currentQty,
      DRUG_GRAMS_PER_SLOT,
      detail.usage,
      detail.capacity,
      quantity,
    );
    if (quantity <= 0) {
      throw new Error('STORAGE_FULL');
    }

    await prisma.$transaction(async (tx) => {
      if (absorbLeftover && leftover) {
        await this.bumpStorageKey(tx, propertyId, leftover.drugType, -leftover.quantity);
        await this.bumpStorageKey(tx, propertyId, key, leftover.quantity);
      }
      if (owned.quantity === quantity) {
        await tx.drugInventory.delete({ where: { id: owned.id } });
      } else {
        await tx.drugInventory.update({
          where: { id: owned.id },
          data: { quantity: owned.quantity - quantity },
        });
      }
      await this.bumpStorageKey(tx, propertyId, key, quantity);
    });
    await refreshInventorySlotUsage(playerId);
  }

  async withdrawDrug(
    playerId: number,
    propertyId: number,
    drugType: string,
    quality: string,
    quantity: number,
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    this.assertStashProperty(property.propertyType, 'drugs');
    if (quantity <= 0) throw new Error('INVALID_QUANTITY');
    if (!DRUG_QUALITIES.has(quality)) {
      throw new Error('UNKNOWN_DRUG');
    }

    const key = drugStashKey(drugType, quality);
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: key } },
    });
    const leftover = await this.findUnprefixedDrugRow(propertyId, drugType);
    const otherQualities = await this.otherPrefixedDrugQualities(
      propertyId,
      drugType,
      quality,
    );
    const useLeftover =
      leftover != null &&
      leftover.quantity > 0 &&
      (quality === 'C' || otherQualities.length === 0);
    const available =
      (stored?.quantity ?? 0) + (useLeftover ? leftover.quantity : 0);
    if (available < quantity) {
      throw new Error('INSUFFICIENT_DRUGS');
    }

    await assertBackpackFits(
      playerId,
      await extraSlotsForDrugAdd(playerId, drugType, quality, quantity),
    );

    await prisma.$transaction(async (tx) => {
      let remaining = quantity;
      if (stored && remaining > 0) {
        const take = Math.min(stored.quantity, remaining);
        await this.bumpStorageKey(tx, propertyId, key, -take);
        remaining -= take;
      }
      if (useLeftover && leftover && remaining > 0) {
        await this.bumpStorageKey(tx, propertyId, leftover.drugType, -remaining);
      }
      const existing = await tx.drugInventory.findUnique({
        where: { playerId_drugType_quality: { playerId, drugType, quality } },
      });
      if (existing) {
        await tx.drugInventory.update({
          where: { id: existing.id },
          data: { quantity: existing.quantity + quantity },
        });
      } else {
        await tx.drugInventory.create({
          data: { playerId, drugType, quality, quantity, ownProduction: false },
        });
      }
    });
    await refreshInventorySlotUsage(playerId);
  }

  async depositTrade(
    playerId: number,
    propertyId: number,
    goodType: string,
    quantity: number,
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    this.assertStashProperty(property.propertyType, 'trade');
    if (quantity <= 0) throw new Error('INVALID_QUANTITY');
    if (!TRADE_NAMES.has(goodType)) {
      throw new Error('UNKNOWN_GOOD');
    }

    const ownedQty = await getBackpackTradeQuantity(
      playerId,
      goodType,
      player.currentCountry,
    );
    if (ownedQty < quantity) {
      throw new Error('INSUFFICIENT_GOODS');
    }

    const key = tradeStashKey(goodType);
    const existing = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: key } },
    });
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    quantity = this.clampToFreeSlots(quantity, detail.usage, detail.capacity);
    if (quantity <= 0) {
      throw new Error('STORAGE_FULL');
    }

    const oldQty = existing?.quantity ?? 0;
    const pxRow = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: tradePriceStashKey(goodType),
        },
      },
    });
    const oldPx = pxRow?.quantity ?? 0;

    await prisma.$transaction(async (tx) => {
      const taken = await debitBackpackTrade(
        tx,
        playerId,
        player.currentCountry,
        goodType,
        quantity,
      );
      const nextQty = oldQty + quantity;
      const averagePrice = Math.floor(
        (oldQty * oldPx + quantity * taken.purchasePrice) / Math.max(1, nextQty),
      );
      await this.bumpStorageKey(tx, propertyId, key, quantity);
      await this.setTradeAveragePrice(tx, propertyId, goodType, nextQty, averagePrice);
    });
    await refreshInventorySlotUsage(playerId);
  }

  async withdrawTrade(
    playerId: number,
    propertyId: number,
    goodType: string,
    quantity: number,
  ) {
    const { player, property } = await this.getPlayerAndProperty(playerId, propertyId);
    this.ensureCountryAccess(player.currentCountry, property.countryId);
    this.assertStashProperty(property.propertyType, 'trade');
    if (quantity <= 0) throw new Error('INVALID_QUANTITY');

    const key = tradeStashKey(goodType);
    const stored = await prisma.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: key } },
    });
    if (!stored || stored.quantity < quantity) {
      throw new Error('INSUFFICIENT_GOODS');
    }

    const pxRow = await prisma.propertyDrugStorage.findUnique({
      where: {
        propertyId_drugType: {
          propertyId,
          drugType: tradePriceStashKey(goodType),
        },
      },
    });
    const stashPx = pxRow?.quantity ?? 0;
    const remainingQty = stored.quantity - quantity;

    await assertBackpackFits(playerId, await extraSlotsForTradeAdd(playerId, quantity));

    await prisma.$transaction(async (tx) => {
      await this.bumpStorageKey(tx, propertyId, key, -quantity);
      await creditCarriedTrade(tx, playerId, goodType, quantity, stashPx);
      await this.setTradeAveragePrice(tx, propertyId, goodType, remainingQty, stashPx);
    });
    await refreshInventorySlotUsage(playerId);
  }

  private async setTradeAveragePrice(
    tx: any,
    propertyId: number,
    goodType: string,
    remainingQty: number,
    averagePrice: number,
  ) {
    const pxKey = tradePriceStashKey(goodType);
    if (remainingQty <= 0) {
      await tx.propertyDrugStorage.deleteMany({
        where: { propertyId, drugType: pxKey },
      });
      return;
    }
    const existing = await tx.propertyDrugStorage.findUnique({
      where: { propertyId_drugType: { propertyId, drugType: pxKey } },
    });
    if (existing) {
      await tx.propertyDrugStorage.update({
        where: { id: existing.id },
        data: { quantity: averagePrice },
      });
      return;
    }
    await tx.propertyDrugStorage.create({
      data: { propertyId, drugType: pxKey, quantity: averagePrice },
    });
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
    const currentOfType =
      stored.find((row) => row.ammoType === ammoType)?.quantity ?? 0;
    const detail = await this.getPropertyStorageDetail(playerId, propertyId);
    quantity = this.clampStackDeposit(
      currentOfType,
      AMMO_ROUNDS_PER_SLOT,
      detail.usage,
      detail.capacity,
      quantity,
    );
    if (quantity <= 0) {
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
    amount = this.clampStackDeposit(
      cashStored,
      CASH_PER_SLOT,
      detail.usage,
      detail.capacity,
      amount,
    );
    if (amount <= 0) {
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

  private seizeAmount(quantity: number): number {
    if (quantity <= 0) return 0;
    const raw = quantity * 0.4;
    const base = Math.floor(raw);
    const remainder = raw - base;
    return base + (remainder > 0 && Math.random() < remainder ? 1 : 0);
  }

  /**
   * Police/FBI control of commercial storage in the arrest country.
   * Houses stay personal; only warehouses are searched.
   */
  async searchWarehousesOnArrest(playerId: number): Promise<{
    warehouseCount: number;
    seizedUnits: number;
    cashSeized: number;
  }> {
    const empty = { warehouseCount: 0, seizedUnits: 0, cashSeized: 0 };
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    if (!player?.currentCountry) return empty;

    const warehouses = await prisma.property.findMany({
      where: {
        playerId,
        propertyType: 'warehouse',
        countryId: player.currentCountry,
      },
      select: { id: true },
    });
    if (warehouses.length === 0) return empty;

    let seizedUnits = 0;
    let cashSeized = 0;

    for (const warehouse of warehouses) {
      const tools = await prisma.playerTools.findMany({
        where: { playerId, location: `property_${warehouse.id}` },
      });
      for (const tool of tools) {
        const take = this.seizeAmount(tool.quantity);
        if (take <= 0) continue;
        if (take >= tool.quantity) {
          await prisma.playerTools.delete({ where: { id: tool.id } });
          seizedUnits += tool.quantity;
        } else {
          await prisma.playerTools.update({
            where: { id: tool.id },
            data: { quantity: tool.quantity - take },
          });
          seizedUnits += take;
        }
      }

      const rows = await prisma.propertyDrugStorage.findMany({
        where: { propertyId: warehouse.id },
      });
      for (const row of rows) {
        if (isMetaStashKey(row.drugType)) continue;
        const take = this.seizeAmount(row.quantity);
        if (take <= 0) continue;
        if (row.drugType === '__cash__') {
          cashSeized += take;
        } else {
          seizedUnits += take;
        }
        if (take >= row.quantity) {
          await prisma.propertyDrugStorage.delete({ where: { id: row.id } });
          const goodType = parseTradeStashKey(row.drugType);
          if (goodType) {
            await prisma.propertyDrugStorage.deleteMany({
              where: {
                propertyId: warehouse.id,
                drugType: tradePriceStashKey(goodType),
              },
            });
          }
        } else {
          await prisma.propertyDrugStorage.update({
            where: { id: row.id },
            data: { quantity: row.quantity - take },
          });
        }
      }
    }

    return { warehouseCount: warehouses.length, seizedUnits, cashSeized };
  }
}

export const propertyStorageService = new PropertyStorageService();
