import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';
import { weaponService } from './weaponService';
import { notificationService } from './notificationService';
import { translationService, type Language } from './translationService';
import { directMessageService } from './directMessageService';
import {
  AMMO_ROUNDS_PER_SLOT,
  ammoSlotsForRounds,
  maxAddForSlotStack,
} from '../utils/propertyStash';

type ArsenalKind = 'weapon' | 'ammo';
type StockSource = 'cache' | 'hq';

type ArsenalRow = {
  regionKey: string;
  crewId: number;
  kind: ArsenalKind;
  itemKey: string;
  quantity: number;
  averageCondition: number;
};

type StockStack = {
  itemKey: string;
  quantity: number;
  averageCondition: number;
  weaponType?: string;
  ammoType?: string;
};

export type ArsenalActionPreview = {
  actionType: string;
  ammoCost: number;
  ammoType: string | null;
  weaponTypes: string[];
  source: StockSource | 'none';
  longSupply: boolean;
};

export type ArsenalStackView = {
  kind: ArsenalKind;
  itemKey: string;
  name: string;
  quantity: number;
  averageCondition: number;
};

export type ArsenalRegionSummary = {
  hasCache: boolean;
  cacheStatus: string | null;
  source: StockSource | 'none';
  longSupply: boolean;
  weapons: number;
  ammo: number;
  hqWeapons: number;
  hqAmmo: number;
  fillPercent: number;
  fillLevel: 'empty' | 'half' | 'full';
  viewerIsOfficer: boolean;
  actionPreviews: ArsenalActionPreview[];
  cacheStacks: ArsenalStackView[];
  hqStacks: ArsenalStackView[];
  bonuses: Array<{
    actionType: string;
    bonusPoints: number;
    source: 'arsenal';
    labelNl: string;
    labelEn: string;
  }>;
};

export type ArsenalSpendResult = {
  source: StockSource | 'none';
  longSupply: boolean;
  ammoSpent: number;
  ammoType: string | null;
  ammoRequested: number;
  weaponWear: number;
  weaponBroken: number;
  dryFire: boolean;
  weaponBonus: number;
  ammoBonus: number;
  fillPercent: number;
  bonuses: Array<{
    actionType: string;
    bonusPoints: number;
    source: 'arsenal';
    labelNl: string;
    labelEn: string;
  }>;
  garrisonFill: number;
  crossedLow: boolean;
};

const COMBAT_ACTIONS = new Set(['patrol', 'raid', 'defense', 'sabotage']);

const ACTION_WEAPON_TYPES: Record<string, string[]> = {
  defense: ['rifle', 'shotgun'],
  raid: ['automatic', 'smg'],
  patrol: ['handgun'],
  sabotage: ['handgun', 'melee'],
};

const ACTION_AMMO_TYPES: Record<string, string[]> = {
  defense: ['762mm', '12gauge'],
  raid: ['9mm'],
  patrol: ['9mm'],
  sabotage: ['9mm'],
};

function toNum(value: unknown): number {
  return Math.max(0, Math.floor(Number(value ?? 0)));
}

function expandWeaponType(type: string | undefined): string[] {
  if (!type) return [];
  if (type === 'automatic' || type === 'smg') return ['automatic', 'smg'];
  return [type];
}

function weaponMatchesAction(weaponType: string | undefined, actionType: string): boolean {
  const allowed = ACTION_WEAPON_TYPES[actionType] ?? [];
  return expandWeaponType(weaponType).some((type) => allowed.includes(type));
}

async function getRuntime(keys: string[]): Promise<Record<string, string>> {
  if (keys.length === 0) return {};
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...keys,
  );
  return rows.reduce<Record<string, string>>((acc, row) => {
    acc[row.configKey] = row.configValue;
    return acc;
  }, {});
}

export async function getArsenalConfig() {
  const cfg = await getRuntime([
    'TERRITORY_ARSENAL_HQ_BONUS_MULT',
    'TERRITORY_ARSENAL_HQ_AMMO_TAX_MULT',
    'TERRITORY_ARSENAL_LOOT_PERCENT',
    'TERRITORY_ARSENAL_SABOTAGE_STEAL_PERCENT',
    'TERRITORY_ARSENAL_SABOTAGE_BURN_PERCENT',
    'TERRITORY_ARSENAL_WEAPON_WEAR',
    'TERRITORY_ARSENAL_DRYFIRE_WEAR',
    'TERRITORY_ARSENAL_LOW_THRESHOLD',
    'TERRITORY_ARSENAL_GARRISON_LEAK_AMMO_PER_HOUR',
    'TERRITORY_ARSENAL_SUPPLY_RUN_AMMO',
    'TERRITORY_ARSENAL_SUPPLY_RUN_WEAPONS',
    'TERRITORY_ARSENAL_AMMO_COST_RAID',
    'TERRITORY_ARSENAL_AMMO_COST_DEFENSE',
    'TERRITORY_ARSENAL_AMMO_COST_PATROL',
    'TERRITORY_ARSENAL_AMMO_COST_SABOTAGE',
    'TERRITORY_BUILDING_ACTION_BONUS_CAP',
    'TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL',
    'TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL',
  ]);
  return {
    hqBonusMult: Math.max(0, Math.min(1, Number(cfg.TERRITORY_ARSENAL_HQ_BONUS_MULT ?? 0.5))),
    hqAmmoTaxMult: Math.max(1, Number(cfg.TERRITORY_ARSENAL_HQ_AMMO_TAX_MULT ?? 1.5)),
    lootPercent: Math.max(0, Math.min(100, toNum(cfg.TERRITORY_ARSENAL_LOOT_PERCENT ?? 40))),
    sabotageStealPercent: Math.max(0, Math.min(100, toNum(cfg.TERRITORY_ARSENAL_SABOTAGE_STEAL_PERCENT ?? 10))),
    sabotageBurnPercent: Math.max(0, Math.min(100, toNum(cfg.TERRITORY_ARSENAL_SABOTAGE_BURN_PERCENT ?? 15))),
    weaponWear: Math.max(1, toNum(cfg.TERRITORY_ARSENAL_WEAPON_WEAR ?? 8)),
    dryFireWear: Math.max(1, toNum(cfg.TERRITORY_ARSENAL_DRYFIRE_WEAR ?? 16)),
    lowThreshold: Math.max(1, toNum(cfg.TERRITORY_ARSENAL_LOW_THRESHOLD ?? 40)),
    garrisonLeakAmmoPerHour: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_GARRISON_LEAK_AMMO_PER_HOUR ?? 8)),
    supplyRunAmmo: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_SUPPLY_RUN_AMMO ?? 80)),
    supplyRunWeapons: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_SUPPLY_RUN_WEAPONS ?? 2)),
    ammoCost: {
      raid: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_AMMO_COST_RAID ?? 40)),
      defense: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_AMMO_COST_DEFENSE ?? 30)),
      patrol: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_AMMO_COST_PATROL ?? 15)),
      sabotage: Math.max(0, toNum(cfg.TERRITORY_ARSENAL_AMMO_COST_SABOTAGE ?? 8)),
      supply_run: 0,
      intel_scan: 0,
    } as Record<string, number>,
    buildingActionBonusCap: Math.max(0, Number(cfg.TERRITORY_BUILDING_ACTION_BONUS_CAP ?? 3)),
    weaponStorageDefenseBonusPerLevel: Number(cfg.TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL ?? 0.18),
    ammoStorageDefenseBonusPerLevel: Number(cfg.TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL ?? 0.16),
  };
}

export async function isCrewOfficer(playerId: number, crewId: number): Promise<boolean> {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId, crewId, role: { in: ['leader', 'co_leader'] } },
    select: { id: true },
  });
  return Boolean(membership);
}

async function loadCacheProject(regionKey: string, crewId: number) {
  const rows = await prisma.$queryRawUnsafe<Array<{
    projectType: string;
    status: string;
    hp: number;
    maxHp: number;
    ownerCrewId: number;
  }>>(
    `SELECT projectType, status, hp, maxHp, ownerCrewId
     FROM territory_region_projects
     WHERE regionKey = ? AND ownerCrewId = ? AND projectType = 'arms_cache'
     LIMIT 1`,
    regionKey,
    crewId,
  );
  const row = rows[0];
  if (!row) return null;
  if (row.status !== 'active' && row.status !== 'damaged') return null;
  return {
    status: row.status,
    hp: toNum(row.hp),
    maxHp: Math.max(1, toNum(row.maxHp)),
  };
}

function cacheCapMult(project: { hp: number; maxHp: number } | null): number {
  if (!project) return 0;
  return Math.max(0.25, Math.min(1, project.hp / project.maxHp));
}

async function loadCacheRows(regionKey: string, crewId: number): Promise<ArsenalRow[]> {
  return prisma.$queryRawUnsafe<ArsenalRow[]>(
    `SELECT regionKey, crewId, kind, itemKey, quantity, averageCondition
     FROM territory_region_arsenal
     WHERE regionKey = ? AND crewId = ? AND quantity > 0`,
    regionKey,
    crewId,
  );
}

async function loadHqWeapons(crewId: number): Promise<StockStack[]> {
  const rows = await prisma.crewWeaponInventory.findMany({ where: { crewId, quantity: { gt: 0 } } });
  return rows.map((row) => {
    const def = weaponService.getWeaponDefinition(row.weaponId);
    return {
      itemKey: row.weaponId,
      quantity: row.quantity,
      averageCondition: row.averageCondition,
      weaponType: def?.type,
      ammoType: def?.ammoType,
    };
  });
}

async function loadHqAmmo(crewId: number): Promise<StockStack[]> {
  const rows = await prisma.crewAmmoInventory.findMany({ where: { crewId, quantity: { gt: 0 } } });
  return rows.map((row) => ({
    itemKey: row.ammoType,
    quantity: row.quantity,
    averageCondition: 100,
    ammoType: row.ammoType,
  }));
}

function cacheToWeaponStacks(rows: ArsenalRow[]): StockStack[] {
  return rows
    .filter((row) => row.kind === 'weapon')
    .map((row) => {
      const def = weaponService.getWeaponDefinition(row.itemKey);
      return {
        itemKey: row.itemKey,
        quantity: toNum(row.quantity),
        averageCondition: toNum(row.averageCondition),
        weaponType: def?.type,
        ammoType: def?.ammoType,
      };
    });
}

function cacheToAmmoStacks(rows: ArsenalRow[]): StockStack[] {
  return rows
    .filter((row) => row.kind === 'ammo')
    .map((row) => ({
      itemKey: row.itemKey,
      quantity: toNum(row.quantity),
      averageCondition: 100,
      ammoType: row.itemKey,
    }));
}

async function upsertCacheStack(
  regionKey: string,
  crewId: number,
  kind: ArsenalKind,
  itemKey: string,
  quantityDelta: number,
  incomingCondition = 100,
): Promise<void> {
  if (quantityDelta === 0) return;
  const existing = await prisma.$queryRawUnsafe<ArsenalRow[]>(
    `SELECT regionKey, crewId, kind, itemKey, quantity, averageCondition
     FROM territory_region_arsenal
     WHERE regionKey = ? AND crewId = ? AND kind = ? AND itemKey = ?
     LIMIT 1`,
    regionKey,
    crewId,
    kind,
    itemKey,
  );
  const row = existing[0];
  if (!row) {
    if (quantityDelta <= 0) return;
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_region_arsenal
        (regionKey, crewId, kind, itemKey, quantity, averageCondition)
       VALUES (?, ?, ?, ?, ?, ?)`,
      regionKey,
      crewId,
      kind,
      itemKey,
      quantityDelta,
      incomingCondition,
    );
    return;
  }
  const nextQty = toNum(row.quantity) + quantityDelta;
  if (nextQty <= 0) {
    await prisma.$executeRawUnsafe(
      `DELETE FROM territory_region_arsenal
       WHERE regionKey = ? AND crewId = ? AND kind = ? AND itemKey = ?`,
      regionKey,
      crewId,
      kind,
      itemKey,
    );
    return;
  }
  const prevQty = toNum(row.quantity);
  const nextCondition = quantityDelta > 0
    ? Math.floor(((toNum(row.averageCondition) * prevQty) + (incomingCondition * quantityDelta)) / nextQty)
    : toNum(row.averageCondition);
  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_arsenal
     SET quantity = ?, averageCondition = ?, updatedAt = NOW()
     WHERE regionKey = ? AND crewId = ? AND kind = ? AND itemKey = ?`,
    nextQty,
    nextCondition,
    regionKey,
    crewId,
    kind,
    itemKey,
  );
}

async function addHqWeapon(crewId: number, weaponId: string, quantity: number, condition: number): Promise<number> {
  if (quantity <= 0) return 0;
  const capacity = await getCrewStorageCapacity(crewId, 'weapon_storage');
  const current = await prisma.crewWeaponInventory.aggregate({
    where: { crewId },
    _sum: { quantity: true },
  });
  const used = current._sum.quantity ?? 0;
  const room = Math.max(0, capacity - used);
  const take = Math.min(room, quantity);
  if (take <= 0) return 0;
  const existing = await prisma.crewWeaponInventory.findUnique({
    where: { crewId_weaponId: { crewId, weaponId } },
  });
  if (existing) {
    const total = existing.quantity + take;
    const weighted = Math.floor(
      (existing.averageCondition * existing.quantity + condition * take) / total,
    );
    await prisma.crewWeaponInventory.update({
      where: { id: existing.id },
      data: { quantity: total, averageCondition: weighted },
    });
  } else {
    await prisma.crewWeaponInventory.create({
      data: { crewId, weaponId, quantity: take, averageCondition: condition },
    });
  }
  return take;
}

async function addHqAmmo(crewId: number, ammoType: string, quantity: number): Promise<number> {
  if (quantity <= 0) return 0;
  const capacity = await getCrewStorageCapacity(crewId, 'ammo_storage');
  const rows = await prisma.crewAmmoInventory.findMany({
    where: { crewId, quantity: { gt: 0 } },
    select: { ammoType: true, quantity: true },
  });
  const usedSlots = rows.reduce((sum, row) => sum + ammoSlotsForRounds(row.quantity), 0);
  const existingQty = rows.find((row) => row.ammoType === ammoType)?.quantity ?? 0;
  const freeSlots = Math.max(0, capacity - usedSlots);
  const room = maxAddForSlotStack(existingQty, AMMO_ROUNDS_PER_SLOT, freeSlots);
  const take = Math.min(room, quantity);
  if (take <= 0) return 0;
  await prisma.crewAmmoInventory.upsert({
    where: { crewId_ammoType: { crewId, ammoType } },
    create: { crewId, ammoType, quantity: take },
    update: { quantity: { increment: take } },
  });
  return take;
}

async function takeHqWeapon(crewId: number, weaponId: string, quantity: number): Promise<{ taken: number; condition: number }> {
  const row = await prisma.crewWeaponInventory.findUnique({
    where: { crewId_weaponId: { crewId, weaponId } },
  });
  if (!row || row.quantity <= 0) return { taken: 0, condition: 100 };
  const taken = Math.min(quantity, row.quantity);
  if (taken === row.quantity) {
    await prisma.crewWeaponInventory.delete({ where: { id: row.id } });
  } else {
    await prisma.crewWeaponInventory.update({
      where: { id: row.id },
      data: { quantity: row.quantity - taken },
    });
  }
  return { taken, condition: row.averageCondition };
}

async function takeHqAmmo(crewId: number, ammoType: string, quantity: number): Promise<number> {
  const row = await prisma.crewAmmoInventory.findUnique({
    where: { crewId_ammoType: { crewId, ammoType } },
  });
  if (!row || row.quantity <= 0) return 0;
  const taken = Math.min(quantity, row.quantity);
  if (taken === row.quantity) {
    await prisma.crewAmmoInventory.delete({ where: { id: row.id } });
  } else {
    await prisma.crewAmmoInventory.update({
      where: { id: row.id },
      data: { quantity: row.quantity - taken },
    });
  }
  return taken;
}

async function regionHasActiveContest(regionKey: string): Promise<boolean> {
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM territory_contests
     WHERE regionKey = ? AND status IN ('preparing', 'active', 'lockdown')
     LIMIT 1`,
    regionKey,
  );
  return rows.length > 0;
}

export async function getCommittedTotals(crewId: number): Promise<{ weapons: number; ammo: number }> {
  const rows = await prisma.$queryRawUnsafe<Array<{ kind: string; qty: number }>>(
    `SELECT kind, COALESCE(SUM(quantity), 0) AS qty
     FROM territory_region_arsenal
     WHERE crewId = ?
     GROUP BY kind`,
    crewId,
  );
  const weapons = toNum(rows.find((row) => row.kind === 'weapon')?.qty);
  const ammo = toNum(rows.find((row) => row.kind === 'ammo')?.qty);
  return { weapons, ammo };
}

function fillLevel(percent: number): 'empty' | 'half' | 'full' {
  if (percent <= 15) return 'empty';
  if (percent >= 70) return 'full';
  return 'half';
}

function stackName(kind: ArsenalKind, itemKey: string): string {
  if (kind === 'weapon') return weaponService.getWeaponDefinition(itemKey)?.name ?? itemKey;
  return itemKey;
}

function toStackViews(kind: ArsenalKind, stacks: StockStack[]): ArsenalStackView[] {
  return stacks
    .filter((stack) => stack.quantity > 0)
    .map((stack) => ({
      kind,
      itemKey: stack.itemKey,
      name: stackName(kind, stack.itemKey),
      quantity: stack.quantity,
      averageCondition: stack.averageCondition,
    }));
}

function pickAmmoType(stacks: StockStack[], actionType: string): string | null {
  const preferred = ACTION_AMMO_TYPES[actionType] ?? [];
  for (const ammoType of preferred) {
    if (stacks.some((stack) => stack.itemKey === ammoType && stack.quantity > 0)) return ammoType;
  }
  const fromWeapons = stacks.find((stack) => stack.ammoType && stack.quantity > 0)?.ammoType;
  return fromWeapons ?? preferred[0] ?? null;
}

async function resolveSource(regionKey: string, crewId: number): Promise<{
  source: StockSource;
  longSupply: boolean;
  project: Awaited<ReturnType<typeof loadCacheProject>>;
  weapons: StockStack[];
  ammo: StockStack[];
}> {
  const project = await loadCacheProject(regionKey, crewId);
  const cacheRows = project ? await loadCacheRows(regionKey, crewId) : [];
  const cacheWeapons = cacheToWeaponStacks(cacheRows);
  const cacheAmmo = cacheToAmmoStacks(cacheRows);
  const cacheHasStock = cacheWeapons.some((s) => s.quantity > 0) || cacheAmmo.some((s) => s.quantity > 0);
  if (project && cacheHasStock) {
    return { source: 'cache', longSupply: false, project, weapons: cacheWeapons, ammo: cacheAmmo };
  }
  const [hqWeapons, hqAmmo] = await Promise.all([loadHqWeapons(crewId), loadHqAmmo(crewId)]);
  return { source: 'hq', longSupply: true, project, weapons: hqWeapons, ammo: hqAmmo };
}

function matchingWeapons(stacks: StockStack[], actionType: string): StockStack[] {
  return stacks.filter((stack) => weaponMatchesAction(stack.weaponType, actionType));
}

function matchingAmmo(stacks: StockStack[], actionType: string): StockStack[] {
  const types = ACTION_AMMO_TYPES[actionType] ?? [];
  return stacks.filter((stack) => types.includes(stack.itemKey));
}

async function computeFill(
  crewId: number,
  weapons: StockStack[],
  ammo: StockStack[],
  actionType: string,
): Promise<number> {
  const [weaponCap, ammoCap] = await Promise.all([
    getCrewStorageCapacity(crewId, 'weapon_storage'),
    getCrewStorageCapacity(crewId, 'ammo_storage'),
  ]);
  const matchW = matchingWeapons(weapons, actionType);
  const matchA = matchingAmmo(ammo, actionType);
  const weaponFill = weaponCap > 0 ? Math.min(1, matchW.reduce((s, row) => s + row.quantity, 0) / weaponCap) : 0;
  const ammoFill =
    ammoCap > 0
      ? Math.min(
          1,
          matchA.reduce((s, row) => s + ammoSlotsForRounds(row.quantity), 0) / ammoCap,
        )
      : 0;
  if (actionType === 'intel_scan' || actionType === 'supply_run') {
    const allW = weapons.reduce((s, row) => s + row.quantity, 0);
    const allA = ammo.reduce((s, row) => s + ammoSlotsForRounds(row.quantity), 0);
    const wf = weaponCap > 0 ? Math.min(1, allW / weaponCap) : 0;
    const af = ammoCap > 0 ? Math.min(1, allA / ammoCap) : 0;
    return (wf + af) / 2;
  }
  return (weaponFill + ammoFill) / 2;
}

export async function summarizeRegionArsenal(params: {
  regionKey: string;
  crewId: number | null;
  playerId?: number | null;
  neighbors?: string[];
}): Promise<ArsenalRegionSummary | null> {
  if (!params.crewId) return null;
  const cfg = await getArsenalConfig();
  const project = await loadCacheProject(params.regionKey, params.crewId);
  const cacheRows = await loadCacheRows(params.regionKey, params.crewId);
  const hqWeapons = await loadHqWeapons(params.crewId);
  const hqAmmo = await loadHqAmmo(params.crewId);
  const cacheWeapons = cacheToWeaponStacks(cacheRows);
  const cacheAmmo = cacheToAmmoStacks(cacheRows);
  const source = project && (cacheWeapons.length > 0 || cacheAmmo.length > 0) ? 'cache' : 'hq';
  const liveWeapons = source === 'cache' ? cacheWeapons : hqWeapons;
  const liveAmmo = source === 'cache' ? cacheAmmo : hqAmmo;
  const fill = await computeFill(params.crewId, liveWeapons, liveAmmo, 'defense');
  const officer = params.playerId ? await isCrewOfficer(params.playerId, params.crewId) : false;
  const actionPreviews: ArsenalActionPreview[] = ['patrol', 'raid', 'defense', 'sabotage', 'supply_run'].map((actionType) => {
    const ammoCostRaw = cfg.ammoCost[actionType] ?? 0;
    const tax = source === 'hq' ? cfg.hqAmmoTaxMult : 1;
    const ammoCost = Math.ceil(ammoCostRaw * tax);
    return {
      actionType,
      ammoCost,
      ammoType: pickAmmoType(liveAmmo, actionType),
      weaponTypes: ACTION_WEAPON_TYPES[actionType] ?? [],
      source: liveWeapons.length || liveAmmo.length ? source : 'none',
      longSupply: source === 'hq',
    };
  });
  const bonuses = [] as ArsenalRegionSummary['bonuses'];
  for (const actionType of ['patrol', 'raid', 'defense', 'sabotage']) {
    const stats = logisticsBonuses({
      actionType,
      weapons: liveWeapons,
      ammo: liveAmmo,
      longSupply: source === 'hq',
      fill: await computeFill(params.crewId, liveWeapons, liveAmmo, actionType),
      cfg,
    });
    bonuses.push(...stats.bonuses);
  }
  return {
    hasCache: Boolean(project),
    cacheStatus: project?.status ?? null,
    source: liveWeapons.length || liveAmmo.length ? source : 'none',
    longSupply: source === 'hq',
    weapons: cacheWeapons.reduce((s, row) => s + row.quantity, 0),
    ammo: cacheAmmo.reduce((s, row) => s + row.quantity, 0),
    hqWeapons: hqWeapons.reduce((s, row) => s + row.quantity, 0),
    hqAmmo: hqAmmo.reduce((s, row) => s + row.quantity, 0),
    fillPercent: Math.round(fill * 100),
    fillLevel: fillLevel(fill * 100),
    viewerIsOfficer: officer,
    actionPreviews,
    cacheStacks: [...toStackViews('weapon', cacheWeapons), ...toStackViews('ammo', cacheAmmo)],
    hqStacks: [...toStackViews('weapon', hqWeapons), ...toStackViews('ammo', hqAmmo)],
    bonuses,
  };
}

export async function summarizeViewerArsenalByRegions(params: {
  crewId: number;
  playerId?: number | null;
  regionKeys: string[];
}): Promise<Record<string, ArsenalRegionSummary>> {
  const out: Record<string, ArsenalRegionSummary> = {};
  for (const regionKey of params.regionKeys) {
    const summary = await summarizeRegionArsenal({
      regionKey,
      crewId: params.crewId,
      playerId: params.playerId,
    });
    if (summary) out[regionKey] = summary;
  }
  return out;
}

export async function getRegionArsenalFill(regionKey: string, crewId: number): Promise<number> {
  const resolved = await resolveSource(regionKey, crewId);
  return computeFill(crewId, resolved.weapons, resolved.ammo, 'defense');
}

export async function mapArsenalBadges(regionKeys: string[]): Promise<Record<string, {
  hasCache: boolean;
  fillLevel: 'empty' | 'half' | 'full';
  fillPercent: number;
}>> {
  const out: Record<string, { hasCache: boolean; fillLevel: 'empty' | 'half' | 'full'; fillPercent: number }> = {};
  if (regionKeys.length === 0) return out;
  const placeholders = regionKeys.map(() => '?').join(', ');
  const projects = await prisma.$queryRawUnsafe<Array<{ regionKey: string; ownerCrewId: number; status: string }>>(
    `SELECT regionKey, ownerCrewId, status
     FROM territory_region_projects
     WHERE projectType = 'arms_cache'
       AND status IN ('active', 'damaged')
       AND regionKey IN (${placeholders})`,
    ...regionKeys,
  );
  const totals = await prisma.$queryRawUnsafe<Array<{ regionKey: string; crewId: number; qty: number }>>(
    `SELECT regionKey, crewId, COALESCE(SUM(quantity), 0) AS qty
     FROM territory_region_arsenal
     WHERE regionKey IN (${placeholders})
     GROUP BY regionKey, crewId`,
    ...regionKeys,
  );
  const qtyByRegionCrew = new Map<string, number>();
  for (const row of totals) {
    qtyByRegionCrew.set(`${row.regionKey}:${row.crewId}`, toNum(row.qty));
  }
  for (const project of projects) {
    const qty = qtyByRegionCrew.get(`${project.regionKey}:${project.ownerCrewId}`) ?? 0;
    const percent = qty <= 0 ? 0 : (qty < 40 ? 40 : 85);
    out[project.regionKey] = {
      hasCache: true,
      fillLevel: fillLevel(percent),
      fillPercent: percent,
    };
  }
  return out;
}

export async function clearRegionCache(regionKey: string): Promise<void> {
  await prisma.$executeRawUnsafe(
    'DELETE FROM territory_region_arsenal WHERE regionKey = ?',
    regionKey,
  );
}

export async function commitToCache(params: {
  playerId: number;
  crewId: number;
  regionKey: string;
  kind: ArsenalKind;
  itemKey: string;
  quantity: number;
}): Promise<{ moved: number }> {
  if (!await isCrewOfficer(params.playerId, params.crewId)) throw new Error('ARSENAL_OFFICER_ONLY');
  if (!Number.isInteger(params.quantity) || params.quantity <= 0) throw new Error('INVALID_QUANTITY');
  const project = await loadCacheProject(params.regionKey, params.crewId);
  if (!project) throw new Error('ARSENAL_CACHE_REQUIRED');
  const owned = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    'SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1',
    params.regionKey,
  );
  if (toNum(owned[0]?.ownerCrewId) !== params.crewId) throw new Error('ARSENAL_NOT_OWNER');

  const capMult = cacheCapMult(project);
  if (params.kind === 'weapon') {
    const cap = Math.floor((await getCrewStorageCapacity(params.crewId, 'weapon_storage')) * capMult);
    const current = cacheToWeaponStacks(await loadCacheRows(params.regionKey, params.crewId))
      .reduce((s, row) => s + row.quantity, 0);
    const room = Math.max(0, cap - current);
    const want = Math.min(params.quantity, room);
    if (want <= 0) throw new Error('ARSENAL_CACHE_FULL');
    const taken = await takeHqWeapon(params.crewId, params.itemKey, want);
    if (taken.taken <= 0) throw new Error('ARSENAL_INSUFFICIENT_STOCK');
    await upsertCacheStack(params.regionKey, params.crewId, 'weapon', params.itemKey, taken.taken, taken.condition);
    return { moved: taken.taken };
  }
  const cap = Math.floor((await getCrewStorageCapacity(params.crewId, 'ammo_storage')) * capMult);
  const ammoStacks = cacheToAmmoStacks(await loadCacheRows(params.regionKey, params.crewId));
  const usedSlots = ammoStacks.reduce((s, row) => s + ammoSlotsForRounds(row.quantity), 0);
  const existingQty = ammoStacks.find((row) => row.itemKey === params.itemKey)?.quantity ?? 0;
  const freeSlots = Math.max(0, cap - usedSlots);
  const room = maxAddForSlotStack(existingQty, AMMO_ROUNDS_PER_SLOT, freeSlots);
  const want = Math.min(params.quantity, room);
  if (want <= 0) throw new Error('ARSENAL_CACHE_FULL');
  const taken = await takeHqAmmo(params.crewId, params.itemKey, want);
  if (taken <= 0) throw new Error('ARSENAL_INSUFFICIENT_STOCK');
  await upsertCacheStack(params.regionKey, params.crewId, 'ammo', params.itemKey, taken, 100);
  return { moved: taken };
}

export async function recallFromCache(params: {
  playerId: number;
  crewId: number;
  regionKey: string;
  kind: ArsenalKind;
  itemKey: string;
  quantity: number;
}): Promise<{ moved: number }> {
  if (!await isCrewOfficer(params.playerId, params.crewId)) throw new Error('ARSENAL_OFFICER_ONLY');
  if (!Number.isInteger(params.quantity) || params.quantity <= 0) throw new Error('INVALID_QUANTITY');
  if (await regionHasActiveContest(params.regionKey)) throw new Error('ARSENAL_RECALL_LOCKED');
  const owned = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    'SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1',
    params.regionKey,
  );
  if (toNum(owned[0]?.ownerCrewId) !== params.crewId) throw new Error('ARSENAL_NOT_OWNER');
  const rows = await loadCacheRows(params.regionKey, params.crewId);
  const stack = rows.find((row) => row.kind === params.kind && row.itemKey === params.itemKey);
  if (!stack || stack.quantity <= 0) throw new Error('ARSENAL_INSUFFICIENT_STOCK');
  const want = Math.min(params.quantity, stack.quantity);
  if (params.kind === 'weapon') {
    const stored = await addHqWeapon(params.crewId, params.itemKey, want, stack.averageCondition);
    if (stored <= 0) throw new Error('WEAPON_STORAGE_FULL');
    await upsertCacheStack(params.regionKey, params.crewId, 'weapon', params.itemKey, -stored);
    return { moved: stored };
  }
  const stored = await addHqAmmo(params.crewId, params.itemKey, want);
  if (stored <= 0) throw new Error('AMMO_STORAGE_FULL');
  await upsertCacheStack(params.regionKey, params.crewId, 'ammo', params.itemKey, -stored);
  return { moved: stored };
}

async function spendAmmoFromSource(
  source: StockSource,
  regionKey: string,
  crewId: number,
  ammoType: string,
  amount: number,
): Promise<number> {
  if (amount <= 0) return 0;
  if (source === 'hq') return takeHqAmmo(crewId, ammoType, amount);
  const rows = await loadCacheRows(regionKey, crewId);
  const stack = rows.find((row) => row.kind === 'ammo' && row.itemKey === ammoType);
  const take = Math.min(amount, toNum(stack?.quantity));
  if (take <= 0) return 0;
  await upsertCacheStack(regionKey, crewId, 'ammo', ammoType, -take);
  return take;
}

async function wearWeaponFromSource(
  source: StockSource,
  regionKey: string,
  crewId: number,
  actionType: string,
  wear: number,
): Promise<{ worn: number; broken: number }> {
  if (source === 'hq') {
    const stacks = matchingWeapons(await loadHqWeapons(crewId), actionType)
      .sort((a, b) => b.quantity - a.quantity);
    const target = stacks[0];
    if (!target) return { worn: 0, broken: 0 };
    const row = await prisma.crewWeaponInventory.findUnique({
      where: { crewId_weaponId: { crewId, weaponId: target.itemKey } },
    });
    if (!row) return { worn: 0, broken: 0 };
    const nextCondition = Math.max(0, row.averageCondition - wear);
    if (nextCondition <= 0) {
      if (row.quantity <= 1) {
        await prisma.crewWeaponInventory.delete({ where: { id: row.id } });
      } else {
        await prisma.crewWeaponInventory.update({
          where: { id: row.id },
          data: { quantity: row.quantity - 1, averageCondition: 100 },
        });
      }
      return { worn: wear, broken: 1 };
    }
    await prisma.crewWeaponInventory.update({
      where: { id: row.id },
      data: { averageCondition: nextCondition },
    });
    return { worn: wear, broken: 0 };
  }
  const stacks = matchingWeapons(cacheToWeaponStacks(await loadCacheRows(regionKey, crewId)), actionType)
    .sort((a, b) => b.quantity - a.quantity);
  const target = stacks[0];
  if (!target) return { worn: 0, broken: 0 };
  const nextCondition = Math.max(0, target.averageCondition - wear);
  if (nextCondition <= 0) {
    await upsertCacheStack(regionKey, crewId, 'weapon', target.itemKey, -1);
    return { worn: wear, broken: 1 };
  }
  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_arsenal
     SET averageCondition = ?, updatedAt = NOW()
     WHERE regionKey = ? AND crewId = ? AND kind = 'weapon' AND itemKey = ?`,
    nextCondition,
    regionKey,
    crewId,
    target.itemKey,
  );
  return { worn: wear, broken: 0 };
}

function scaledBonus(fill: number, sourceMult: number, cap: number): number {
  return Math.min(cap, Math.max(0, Math.round(cap * fill * sourceMult)));
}

function logisticsBonuses(params: {
  actionType: string;
  weapons: StockStack[];
  ammo: StockStack[];
  longSupply: boolean;
  fill: number;
  cfg: Awaited<ReturnType<typeof getArsenalConfig>>;
}): { weaponBonus: number; ammoBonus: number; dryFire: boolean; bonuses: ArsenalSpendResult['bonuses'] } {
  const sourceMult = params.longSupply ? params.cfg.hqBonusMult : 1;
  const cap = params.cfg.buildingActionBonusCap;
  const matchW = matchingWeapons(params.weapons, params.actionType);
  const matchA = matchingAmmo(params.ammo, params.actionType);
  const hasWeapon = matchW.length > 0;
  const hasAmmo = matchA.length > 0 || actionTypeNeedsNoAmmo(params.actionType, matchW);
  const requested = Math.ceil((params.cfg.ammoCost[params.actionType] ?? 0) * (params.longSupply ? params.cfg.hqAmmoTaxMult : 1));
  const dryFire = COMBAT_ACTIONS.has(params.actionType) && requested > 0 && !hasAmmo;
  const weaponBonus = hasWeapon ? scaledBonus(params.fill, sourceMult, cap) : 0;
  const ammoUncapped = hasAmmo && !dryFire ? scaledBonus(params.fill, sourceMult, cap) : 0;
  const ammoBonus = Math.min(ammoUncapped, Math.max(0, cap - weaponBonus));
  const bonuses = [] as ArsenalSpendResult['bonuses'];
  if (weaponBonus > 0) {
    bonuses.push({
      actionType: params.actionType,
      bonusPoints: weaponBonus,
      source: 'arsenal',
      labelNl: params.longSupply ? 'HQ-arsenaal (lange lijn)' : 'Frontlijn-wapens',
      labelEn: params.longSupply ? 'HQ arsenal (long supply)' : 'Frontline weapons',
    });
  }
  if (ammoBonus > 0 && params.actionType !== 'sabotage') {
    bonuses.push({
      actionType: params.actionType,
      bonusPoints: ammoBonus,
      source: 'arsenal',
      labelNl: params.longSupply ? 'HQ-kogels (lange lijn)' : 'Frontlijn-kogels',
      labelEn: params.longSupply ? 'HQ ammo (long supply)' : 'Frontline ammo',
    });
  }
  return { weaponBonus, ammoBonus, dryFire, bonuses };
}

export async function applyCombatLogistics(params: {
  actionType: string;
  regionKey: string;
  crewId: number;
  weaponBuildingLevel: number;
  ammoBuildingLevel: number;
}): Promise<ArsenalSpendResult> {
  const cfg = await getArsenalConfig();
  const resolved = await resolveSource(params.regionKey, params.crewId);
  const fill = await computeFill(params.crewId, resolved.weapons, resolved.ammo, params.actionType);
  const matchW = matchingWeapons(resolved.weapons, params.actionType);
  const matchA = matchingAmmo(resolved.ammo, params.actionType);
  const hasWeapon = matchW.length > 0;
  const hasAmmo = matchA.length > 0 || actionTypeNeedsNoAmmo(params.actionType, matchW);
  const ammoType = pickAmmoType(resolved.ammo, params.actionType);
  const requested = Math.ceil((cfg.ammoCost[params.actionType] ?? 0) * (resolved.longSupply ? cfg.hqAmmoTaxMult : 1));
  const stats = logisticsBonuses({
    actionType: params.actionType,
    weapons: resolved.weapons,
    ammo: resolved.ammo,
    longSupply: resolved.longSupply,
    fill,
    cfg,
  });

  let ammoSpent = 0;
  if (COMBAT_ACTIONS.has(params.actionType) && ammoType && requested > 0 && hasAmmo) {
    ammoSpent = await spendAmmoFromSource(resolved.source, params.regionKey, params.crewId, ammoType, requested);
  }
  const wear = stats.dryFire ? cfg.dryFireWear : cfg.weaponWear;
  let weaponWear = 0;
  let weaponBroken = 0;
  if (COMBAT_ACTIONS.has(params.actionType) && hasWeapon) {
    const worn = await wearWeaponFromSource(resolved.source, params.regionKey, params.crewId, params.actionType, wear);
    weaponWear = worn.worn;
    weaponBroken = worn.broken;
  }

  const remainingAmmo = matchingAmmo(
    resolved.source === 'cache'
      ? cacheToAmmoStacks(await loadCacheRows(params.regionKey, params.crewId))
      : await loadHqAmmo(params.crewId),
    params.actionType,
  ).reduce((s, row) => s + row.quantity, 0);
  const crossedLow = remainingAmmo < cfg.lowThreshold && remainingAmmo + ammoSpent >= cfg.lowThreshold;

  return {
    source: hasWeapon || hasAmmo ? resolved.source : 'none',
    longSupply: resolved.longSupply,
    ammoSpent,
    ammoType,
    ammoRequested: requested,
    weaponWear,
    weaponBroken,
    dryFire: stats.dryFire,
    weaponBonus: stats.weaponBonus,
    ammoBonus: stats.ammoBonus,
    fillPercent: Math.round(fill * 100),
    bonuses: stats.bonuses,
    garrisonFill: fill,
    crossedLow,
  };
}

function actionTypeNeedsNoAmmo(actionType: string, weapons: StockStack[]): boolean {
  if (actionType !== 'sabotage') return false;
  return weapons.every((stack) => stack.weaponType === 'melee') && weapons.length > 0;
}

export async function applySupplyRunResupply(params: {
  regionKey: string;
  crewId: number;
  neighbors: string[];
}): Promise<{ movedWeapons: number; movedAmmo: number; from: 'hq' | 'adjacent' | 'none' }> {
  const cfg = await getArsenalConfig();
  const project = await loadCacheProject(params.regionKey, params.crewId);
  if (!project) return { movedWeapons: 0, movedAmmo: 0, from: 'none' };

  const adjacentWithCache: string[] = [];
  for (const neighbor of params.neighbors) {
    const live = await loadCacheProject(neighbor, params.crewId);
    if (live) adjacentWithCache.push(neighbor);
  }

  let movedWeapons = 0;
  let movedAmmo = 0;
  let from: 'hq' | 'adjacent' | 'none' = 'none';

  const tryMoveAmmo = async (sourceRegion: string | null, ammoType: string, amount: number) => {
    if (amount <= 0) return 0;
    if (sourceRegion) {
      const rows = await loadCacheRows(sourceRegion, params.crewId);
      const stack = rows.find((row) => row.kind === 'ammo' && row.itemKey === ammoType);
      const take = Math.min(amount, toNum(stack?.quantity));
      if (take <= 0) return 0;
      await upsertCacheStack(sourceRegion, params.crewId, 'ammo', ammoType, -take);
      await upsertCacheStack(params.regionKey, params.crewId, 'ammo', ammoType, take);
      return take;
    }
    const taken = await takeHqAmmo(params.crewId, ammoType, amount);
    if (taken > 0) await upsertCacheStack(params.regionKey, params.crewId, 'ammo', ammoType, taken);
    return taken;
  };

  const tryMoveWeapon = async (sourceRegion: string | null, weaponId: string, amount: number) => {
    if (amount <= 0) return 0;
    if (sourceRegion) {
      const rows = await loadCacheRows(sourceRegion, params.crewId);
      const stack = rows.find((row) => row.kind === 'weapon' && row.itemKey === weaponId);
      const take = Math.min(amount, toNum(stack?.quantity));
      if (take <= 0) return 0;
      await upsertCacheStack(sourceRegion, params.crewId, 'weapon', weaponId, -take);
      await upsertCacheStack(params.regionKey, params.crewId, 'weapon', weaponId, take, stack?.averageCondition ?? 100);
      return take;
    }
    const taken = await takeHqWeapon(params.crewId, weaponId, amount);
    if (taken.taken > 0) {
      await upsertCacheStack(params.regionKey, params.crewId, 'weapon', weaponId, taken.taken, taken.condition);
    }
    return taken.taken;
  };

  const adjacent = adjacentWithCache[0] ?? null;
  const ammoNeed = cfg.supplyRunAmmo;
  const ammoTypes = ['9mm', '762mm', '12gauge'];
  for (const ammoType of ammoTypes) {
    if (movedAmmo >= ammoNeed) break;
    const got = await tryMoveAmmo(adjacent, ammoType, ammoNeed - movedAmmo);
    if (got > 0) {
      movedAmmo += got;
      from = adjacent ? 'adjacent' : 'hq';
    }
  }
  if (movedAmmo < ammoNeed && adjacent) {
    for (const ammoType of ammoTypes) {
      if (movedAmmo >= ammoNeed) break;
      const got = await tryMoveAmmo(null, ammoType, ammoNeed - movedAmmo);
      if (got > 0) {
        movedAmmo += got;
        from = from === 'none' ? 'hq' : from;
      }
    }
  }

  const weaponNeed = cfg.supplyRunWeapons;
  const hqWeapons = await loadHqWeapons(params.crewId);
  const adjWeapons = adjacent ? cacheToWeaponStacks(await loadCacheRows(adjacent, params.crewId)) : [];
  const candidates = [...adjWeapons, ...hqWeapons];
  for (const stack of candidates) {
    if (movedWeapons >= weaponNeed) break;
    const fromAdj = adjWeapons.some((row) => row.itemKey === stack.itemKey && row.quantity > 0);
    const got = await tryMoveWeapon(fromAdj ? adjacent : null, stack.itemKey, weaponNeed - movedWeapons);
    if (got > 0) {
      movedWeapons += got;
      from = fromAdj ? 'adjacent' : (from === 'adjacent' ? 'adjacent' : 'hq');
    }
  }

  return { movedWeapons, movedAmmo, from };
}

export async function dumpCacheOnSabotage(params: {
  regionKey: string;
  defenderCrewId: number | null;
  attackerCrewId: number;
}): Promise<{ stolenWeapons: number; stolenAmmo: number; burnedWeapons: number; burnedAmmo: number }> {
  if (!params.defenderCrewId) {
    return { stolenWeapons: 0, stolenAmmo: 0, burnedWeapons: 0, burnedAmmo: 0 };
  }
  const cfg = await getArsenalConfig();
  const rows = await loadCacheRows(params.regionKey, params.defenderCrewId);
  let stolenWeapons = 0;
  let stolenAmmo = 0;
  let burnedWeapons = 0;
  let burnedAmmo = 0;
  for (const row of rows) {
    const qty = toNum(row.quantity);
    if (qty <= 0) continue;
    const steal = Math.floor((qty * cfg.sabotageStealPercent) / 100);
    const burn = Math.floor((qty * cfg.sabotageBurnPercent) / 100);
    const drop = steal + burn;
    if (drop <= 0) continue;
    await upsertCacheStack(params.regionKey, params.defenderCrewId, row.kind, row.itemKey, -drop);
    if (row.kind === 'weapon') {
      const stored = await addHqWeapon(params.attackerCrewId, row.itemKey, steal, row.averageCondition);
      stolenWeapons += stored;
      burnedWeapons += burn + Math.max(0, steal - stored);
    } else {
      const stored = await addHqAmmo(params.attackerCrewId, row.itemKey, steal);
      stolenAmmo += stored;
      burnedAmmo += burn + Math.max(0, steal - stored);
    }
  }
  return { stolenWeapons, stolenAmmo, burnedWeapons, burnedAmmo };
}

export async function transferCacheOnOwnershipChange(params: {
  regionKey: string;
  previousOwnerId: number | null;
  winnerCrewId: number;
}): Promise<{ lootedWeapons: number; lootedAmmo: number; burnedWeapons: number; burnedAmmo: number }> {
  if (!params.previousOwnerId || params.previousOwnerId === params.winnerCrewId) {
    return { lootedWeapons: 0, lootedAmmo: 0, burnedWeapons: 0, burnedAmmo: 0 };
  }
  const cfg = await getArsenalConfig();
  const rows = await loadCacheRows(params.regionKey, params.previousOwnerId);
  let lootedWeapons = 0;
  let lootedAmmo = 0;
  let burnedWeapons = 0;
  let burnedAmmo = 0;
  for (const row of rows) {
    const qty = toNum(row.quantity);
    if (qty <= 0) continue;
    const loot = Math.floor((qty * cfg.lootPercent) / 100);
    const burn = qty - loot;
    await prisma.$executeRawUnsafe(
      `DELETE FROM territory_region_arsenal
       WHERE regionKey = ? AND crewId = ? AND kind = ? AND itemKey = ?`,
      params.regionKey,
      params.previousOwnerId,
      row.kind,
      row.itemKey,
    );
    if (row.kind === 'weapon') {
      const stored = await addHqWeapon(params.winnerCrewId, row.itemKey, loot, row.averageCondition);
      lootedWeapons += stored;
      burnedWeapons += burn + Math.max(0, loot - stored);
    } else {
      const stored = await addHqAmmo(params.winnerCrewId, row.itemKey, loot);
      lootedAmmo += stored;
      burnedAmmo += burn + Math.max(0, loot - stored);
    }
  }
  if (lootedWeapons + lootedAmmo + burnedWeapons + burnedAmmo > 0) {
    await notifyArsenalCaptured(params.previousOwnerId, params.regionKey);
  }
  return { lootedWeapons, lootedAmmo, burnedWeapons, burnedAmmo };
}

export async function leakGarrisonAmmo(now: Date = new Date()): Promise<number> {
  const cfg = await getArsenalConfig();
  if (cfg.garrisonLeakAmmoPerHour <= 0) return 0;
  const rows = await prisma.$queryRawUnsafe<Array<{
    id: number;
    regionKey: string;
    favoredCrewId: number | null;
    metadataJson: string | null;
    startsAt: Date;
  }>>(
    `SELECT id, regionKey, favoredCrewId, metadataJson, startsAt
     FROM territory_region_effects
     WHERE effectType = 'garrison' AND resolvedAt IS NULL AND endsAt > ?`,
    now,
  );
  let leaked = 0;
  for (const row of rows) {
    const crewId = row.favoredCrewId == null ? null : toNum(row.favoredCrewId);
    if (!crewId) continue;
    let meta: { lastArsenalLeakAt?: string } = {};
    try {
      meta = row.metadataJson ? JSON.parse(row.metadataJson) as { lastArsenalLeakAt?: string } : {};
    } catch {
      meta = {};
    }
    const last = meta.lastArsenalLeakAt ? new Date(meta.lastArsenalLeakAt) : new Date(row.startsAt);
    const hours = Math.max(0, (now.getTime() - last.getTime()) / 3600000);
    const amount = Math.floor(hours * cfg.garrisonLeakAmmoPerHour);
    if (amount <= 0) continue;
    const ammoRows = cacheToAmmoStacks(await loadCacheRows(row.regionKey, crewId));
    let remaining = amount;
    for (const stack of ammoRows) {
      if (remaining <= 0) break;
      const take = Math.min(remaining, stack.quantity);
      await upsertCacheStack(row.regionKey, crewId, 'ammo', stack.itemKey, -take);
      remaining -= take;
      leaked += take;
    }
    meta.lastArsenalLeakAt = now.toISOString();
    await prisma.$executeRawUnsafe(
      `UPDATE territory_region_effects SET metadataJson = ?, updatedAt = NOW() WHERE id = ?`,
      JSON.stringify(meta),
      row.id,
    );
  }
  return leaked;
}

export function scaleGarrisonBonus(basePoints: number, fill: number): number {
  return Math.max(0, Math.round(basePoints * Math.max(0, Math.min(1, fill))));
}

async function getCrewPlayers(crewId: number): Promise<Array<{ id: number }>> {
  return prisma.$queryRawUnsafe<Array<{ id: number }>>(
    'SELECT playerId AS id FROM crew_members WHERE crewId = ? LIMIT 50',
    crewId,
  );
}

async function getPlayerLanguage(playerId: number): Promise<Language> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  return translationService.getPlayerLanguage(player ?? {});
}

async function sendArsenalInbox(playerId: number, language: Language, message: string): Promise<void> {
  const sender = translationService.getTranslations(language).common.territorySystemSender;
  await directMessageService.sendSystemMessage(playerId, message, {
    sendPush: false,
    senderName: sender,
  });
}

export async function notifyArsenalLow(crewId: number, regionKey: string): Promise<void> {
  const players = await getCrewPlayers(crewId);
  for (const p of players) {
    const lang = await getPlayerLanguage(p.id);
    const n = translationService.getTranslations(lang).notification;
    await notificationService.sendToPlayer(
      p.id,
      n.territoryArsenalLow.title,
      n.territoryArsenalLow.pushBody(regionKey),
      { type: 'territory_arsenal_low', regionKey },
    ).catch(() => {});
    await sendArsenalInbox(p.id, lang, n.territoryArsenalLow.inboxMessage(regionKey)).catch(() => {});
  }
}

export async function notifyArsenalCaptured(crewId: number, regionKey: string): Promise<void> {
  const players = await getCrewPlayers(crewId);
  for (const p of players) {
    const lang = await getPlayerLanguage(p.id);
    const n = translationService.getTranslations(lang).notification;
    await notificationService.sendToPlayer(
      p.id,
      n.territoryArsenalCaptured.title,
      n.territoryArsenalCaptured.pushBody(regionKey),
      { type: 'territory_arsenal_captured', regionKey },
    ).catch(() => {});
    await sendArsenalInbox(p.id, lang, n.territoryArsenalCaptured.inboxMessage(regionKey)).catch(() => {});
  }
}
