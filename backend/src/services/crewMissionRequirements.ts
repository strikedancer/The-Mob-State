import type { Prisma } from '@prisma/client';
import prisma from '../lib/prisma';
import { vehicleService } from './vehicleService';
import weaponService from './weaponService';
import toolService from './toolService';

export const WEED_DRUG_TYPES = ['white_widow', 'amnesia_haze', 'og_kush', 'hash'] as const;
export const QUALITY_RANK: Record<string, number> = { D: 0, C: 1, B: 2, A: 3, S: 4 };
export const QUALITY_BONUS_PP: Record<string, number> = { D: -8, C: 0, B: 4, A: 8, S: 12 };

export const WEAPON_CONDITION_WEAR = 8;
export const VEHICLE_CONDITION_WEAR = 10;
export const VEHICLE_FUEL_DRAIN = 22;
const DEFAULT_TOOL_WEAR = 15;

export type MissionRequirementKind = 'trade' | 'ammo' | 'drug' | 'weapon' | 'tool' | 'vehicle';
export type MissionRequirementEffect = 'consume' | 'wear';
export type VehicleCategory = 'car' | 'motorcycle' | 'boat';

export type MissionRequirement = {
  kind: MissionRequirementKind;
  quantity: number;
  goodType?: string;
  ammoType?: string;
  matchWeapon?: boolean;
  drugType?: string;
  drugTypes?: string[];
  minQuality?: string;
  weaponId?: string;
  weaponType?: string;
  minCondition?: number;
  toolId?: string;
  toolIds?: string[];
  minDurability?: number;
  vehicleCategory?: VehicleCategory;
  minFuel?: number;
  minSpeed?: number;
  minArmor?: number;
  minCargo?: number;
  minStealth?: number;
};

export type MissionMissingItem = {
  kind: MissionRequirementKind;
  key: string;
  need: number;
  have: number;
};

export type MissionRequirementLine = {
  kind: MissionRequirementKind;
  key: string;
  need: number;
  have: number;
  met: boolean;
  effect: MissionRequirementEffect;
  minCondition?: number;
  minDurability?: number;
  minFuel?: number;
  minQuality?: string;
};

export type SelectedGear = {
  weapons: Array<{ stackId: number; weaponId: string; ammoType?: string; condition: number; quantity: number }>;
  tools: Array<{ inventoryId: number; toolId: string; durability: number }>;
  vehicles: Array<{
    inventoryId: number;
    vehicleId: string;
    category: VehicleCategory;
    condition: number;
    fuelLevel: number;
    speed: number;
    armor: number;
    cargo: number;
    stealth: number;
  }>;
  drugs: Array<{ lotId: number; drugType: string; quality: string; quantity: number }>;
  ammo: Array<{ ammoType: string; quantity: number }>;
  trade: Array<{ goodType: string; quantity: number }>;
};

export type MissionRequirementQuote = {
  canStart: boolean;
  missing: MissionMissingItem[];
  lines: MissionRequirementLine[];
  gearBonus: number;
  gearBonusPp: number;
  quotedSuccessChance: number;
  consumePreview: MissionRequirementLine[];
  wearPreview: MissionRequirementLine[];
  selected: SelectedGear;
};

export type CrewMissionStorageSnapshot = {
  cars: Array<{
    id: number;
    vehicleId: string;
    condition: number;
    fuelLevel: number;
    vehicleType: VehicleCategory;
  }>;
  boats: Array<{ id: number; vehicleId: string; condition: number; fuelLevel: number }>;
  weapons: Array<{ id: number; weaponId: string; quantity: number; averageCondition: number }>;
  ammo: Array<{ ammoType: string; quantity: number }>;
  drugLots: Array<{ id: number; drugType: string; quality: string; quantity: number }>;
  trade: Array<{ goodType: string; quantity: number }>;
  tools: Array<{ id: number; toolId: string; durability: number }>;
};

export class MissionStorageNotMetError extends Error {
  readonly missing: MissionMissingItem[];

  constructor(missing: MissionMissingItem[]) {
    super('MISSION_STORAGE_REQUIREMENTS_NOT_MET');
    this.name = 'MissionStorageNotMetError';
    this.missing = missing;
  }
}

export function clampNumber(value: number, min: number, max: number): number {
  return Math.min(max, Math.max(min, value));
}

export function clampMissionSuccessChance(value: number): number {
  return clampNumber(value, 0.2, 0.95);
}

export function conditionGearPp(condition: number): number {
  return clampNumber(Math.round((condition - 60) / 5), -8, 8);
}

export function fuelGearPp(fuel: number): number {
  if (fuel < 20) return -10;
  if (fuel < 50) return -4;
  if (fuel >= 80) return 3;
  return 0;
}

export function catalogStatGearPp(stat: number, threshold: number): number {
  return clampNumber(Math.round((stat - threshold) / 8), -6, 6);
}

export function weightedDrugQualityPp(
  consumed: Array<{ quality: string; quantity: number }>
): number {
  const total = consumed.reduce((sum, row) => sum + Math.max(0, row.quantity), 0);
  if (total <= 0) return 0;
  const weighted = consumed.reduce((sum, row) => {
    const bonus = QUALITY_BONUS_PP[row.quality] ?? 0;
    return sum + bonus * Math.max(0, row.quantity);
  }, 0);
  return weighted / total;
}

function toInt(value: unknown, fallback = 0): number {
  const parsed = Number.parseInt(String(value ?? ''), 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function asString(value: unknown): string {
  return String(value ?? '').trim();
}

function qualityMeets(quality: string, minQuality?: string): boolean {
  if (!minQuality) return true;
  return (QUALITY_RANK[quality] ?? 0) >= (QUALITY_RANK[minQuality] ?? 0);
}

function resolveDrugTypes(req: MissionRequirement): string[] | null {
  if (req.drugTypes && req.drugTypes.length > 0) {
    return req.drugTypes.map((item) => item.trim()).filter(Boolean);
  }
  if (req.drugType === 'weed') {
    return [...WEED_DRUG_TYPES];
  }
  if (req.drugType) {
    return [req.drugType];
  }
  return null;
}

function requirementKey(req: MissionRequirement): string {
  if (req.kind === 'trade') return req.goodType || 'trade';
  if (req.kind === 'ammo') return req.matchWeapon ? 'matching' : req.ammoType || 'ammo';
  if (req.kind === 'drug') {
    if (req.drugType === 'weed') return 'weed';
    return req.drugType || req.drugTypes?.join('|') || 'any';
  }
  if (req.kind === 'weapon') return req.weaponId || req.weaponType || req.ammoType || 'any';
  if (req.kind === 'tool') return req.toolId || req.toolIds?.join('|') || 'any';
  if (req.kind === 'vehicle') return req.vehicleCategory || 'vehicle';
  return req.kind;
}

function effectFor(kind: MissionRequirementKind): MissionRequirementEffect {
  return kind === 'weapon' || kind === 'tool' || kind === 'vehicle' ? 'wear' : 'consume';
}

function weaponMatches(req: MissionRequirement, weaponId: string): boolean {
  const def = weaponService.getWeaponDefinition(weaponId);
  if (!def) return false;
  if (req.weaponId && def.id !== req.weaponId) return false;
  if (req.weaponType && def.type !== req.weaponType) return false;
  if (req.ammoType && def.ammoType !== req.ammoType) return false;
  return true;
}

function vehicleCatalog(vehicleId: string) {
  const def = vehicleService.getVehicleById(vehicleId);
  return {
    speed: def?.stats?.speed ?? 0,
    armor: def?.stats?.armor ?? 0,
    cargo: def?.stats?.cargo ?? 0,
    stealth: def?.stats?.stealth ?? 0,
    category: (def?.vehicleCategory ?? 'car') as VehicleCategory,
  };
}

function vehiclePassesCatalog(req: MissionRequirement, vehicleId: string): boolean {
  const stats = vehicleCatalog(vehicleId);
  if (req.minSpeed != null && stats.speed < req.minSpeed) return false;
  if (req.minArmor != null && stats.armor < req.minArmor) return false;
  if (req.minCargo != null && stats.cargo < req.minCargo) return false;
  if (req.minStealth != null && stats.stealth < req.minStealth) return false;
  return true;
}

function vehicleScore(req: MissionRequirement, vehicleId: string, condition: number, fuel: number): number {
  const stats = vehicleCatalog(vehicleId);
  let score = condition + fuel * 0.4;
  if (req.minSpeed != null) score += catalogStatGearPp(stats.speed, req.minSpeed) * 4;
  if (req.minArmor != null) score += catalogStatGearPp(stats.armor, req.minArmor) * 4;
  if (req.minCargo != null) score += catalogStatGearPp(stats.cargo, req.minCargo) * 4;
  if (req.minStealth != null) score += catalogStatGearPp(stats.stealth, req.minStealth) * 4;
  return score;
}

export function parseMissionRequirements(raw: string | null | undefined): MissionRequirement[] {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed
      .map((entry) => {
        const kind = asString(entry?.kind).toLowerCase() as MissionRequirementKind;
        const quantity = toInt(entry?.quantity, 0);
        if (!kind && asString(entry?.goodType) && quantity > 0) {
          return {
            kind: 'trade' as const,
            quantity,
            goodType: asString(entry.goodType),
          };
        }
        if (!['trade', 'ammo', 'drug', 'weapon', 'tool', 'vehicle'].includes(kind) || quantity <= 0) {
          return null;
        }
        const req: MissionRequirement = { kind, quantity };
        if (entry.goodType) req.goodType = asString(entry.goodType);
        if (entry.ammoType) req.ammoType = asString(entry.ammoType);
        if (entry.matchWeapon === true) req.matchWeapon = true;
        if (entry.drugType) req.drugType = asString(entry.drugType);
        if (Array.isArray(entry.drugTypes)) {
          req.drugTypes = entry.drugTypes.map((item: unknown) => asString(item)).filter(Boolean);
        }
        if (entry.minQuality) req.minQuality = asString(entry.minQuality).toUpperCase();
        if (entry.weaponId) req.weaponId = asString(entry.weaponId);
        if (entry.weaponType) req.weaponType = asString(entry.weaponType);
        if (entry.minCondition != null) req.minCondition = toInt(entry.minCondition, 0);
        if (entry.toolId) req.toolId = asString(entry.toolId);
        if (Array.isArray(entry.toolIds)) {
          req.toolIds = entry.toolIds.map((item: unknown) => asString(item)).filter(Boolean);
        }
        if (entry.minDurability != null) req.minDurability = toInt(entry.minDurability, 0);
        if (entry.vehicleCategory) {
          const category = asString(entry.vehicleCategory) as VehicleCategory;
          if (category === 'car' || category === 'motorcycle' || category === 'boat') {
            req.vehicleCategory = category;
          }
        }
        if (entry.minFuel != null) req.minFuel = toInt(entry.minFuel, 0);
        if (entry.minSpeed != null) req.minSpeed = toInt(entry.minSpeed, 0);
        if (entry.minArmor != null) req.minArmor = toInt(entry.minArmor, 0);
        if (entry.minCargo != null) req.minCargo = toInt(entry.minCargo, 0);
        if (entry.minStealth != null) req.minStealth = toInt(entry.minStealth, 0);
        return req;
      })
      .filter((entry): entry is MissionRequirement => Boolean(entry));
  } catch {
    return [];
  }
}

export function serializeMissionRequirements(requirements?: MissionRequirement[]): string {
  return JSON.stringify(requirements?.length ? requirements : []);
}

export function tradeRequirementsFromParsed(requirements: MissionRequirement[]): Array<{ goodType: string; quantity: number }> {
  return requirements
    .filter((req) => req.kind === 'trade' && req.goodType)
    .map((req) => ({ goodType: req.goodType as string, quantity: req.quantity }));
}

export function computeGearBonusPp(selected: SelectedGear, requirements: MissionRequirement[]): number {
  let pp = 0;
  pp += weightedDrugQualityPp(selected.drugs);
  for (const weapon of selected.weapons) {
    pp += conditionGearPp(weapon.condition);
  }
  for (const tool of selected.tools) {
    pp += conditionGearPp(tool.durability);
  }
  for (const vehicle of selected.vehicles) {
    pp += conditionGearPp(vehicle.condition);
    pp += fuelGearPp(vehicle.fuelLevel);
    const req = requirements.find(
      (item) => item.kind === 'vehicle' && item.vehicleCategory === vehicle.category
    );
    if (req?.minSpeed != null) pp += catalogStatGearPp(vehicle.speed, req.minSpeed);
    if (req?.minArmor != null) pp += catalogStatGearPp(vehicle.armor, req.minArmor);
    if (req?.minCargo != null) pp += catalogStatGearPp(vehicle.cargo, req.minCargo);
    if (req?.minStealth != null) pp += catalogStatGearPp(vehicle.stealth, req.minStealth);
  }
  return pp;
}

export function quoteMissionRequirements(
  requirements: MissionRequirement[],
  snapshot: CrewMissionStorageSnapshot,
  baseSuccessChance = 0.6
): MissionRequirementQuote {
  const missing: MissionMissingItem[] = [];
  const lines: MissionRequirementLine[] = [];
  const selected: SelectedGear = {
    weapons: [],
    tools: [],
    vehicles: [],
    drugs: [],
    ammo: [],
    trade: [],
  };

  const ammoRemaining = new Map<string, number>();
  for (const row of snapshot.ammo) {
    ammoRemaining.set(row.ammoType, (ammoRemaining.get(row.ammoType) ?? 0) + row.quantity);
  }
  const tradeRemaining = new Map<string, number>();
  for (const row of snapshot.trade) {
    tradeRemaining.set(row.goodType, (tradeRemaining.get(row.goodType) ?? 0) + row.quantity);
  }
  const usedWeaponQty = new Map<number, number>();
  const usedToolIds = new Set<number>();
  const usedVehicleIds = new Set<number>();
  const usedDrugQty = new Map<number, number>();

  let matchedAmmoType: string | undefined;

  for (const req of requirements) {
    const key = requirementKey(req);
    const effect = effectFor(req.kind);
    let have = 0;
    let taken = 0;

    if (req.kind === 'trade') {
      have = tradeRemaining.get(req.goodType || '') ?? 0;
      if (have >= req.quantity && req.goodType) {
        tradeRemaining.set(req.goodType, have - req.quantity);
        selected.trade.push({ goodType: req.goodType, quantity: req.quantity });
        taken = req.quantity;
      }
    } else if (req.kind === 'ammo') {
      const ammoType = req.matchWeapon ? matchedAmmoType : req.ammoType;
      have = ammoType ? ammoRemaining.get(ammoType) ?? 0 : 0;
      if (ammoType && have >= req.quantity) {
        ammoRemaining.set(ammoType, have - req.quantity);
        selected.ammo.push({ ammoType, quantity: req.quantity });
        taken = req.quantity;
      }
    } else if (req.kind === 'drug') {
      const allowed = resolveDrugTypes(req);
      const candidates = snapshot.drugLots
        .filter((lot) => (allowed ? allowed.includes(lot.drugType) : true))
        .filter((lot) => qualityMeets(lot.quality, req.minQuality))
        .map((lot) => ({
          ...lot,
          remaining: lot.quantity - (usedDrugQty.get(lot.id) ?? 0),
        }))
        .filter((lot) => lot.remaining > 0)
        .sort((a, b) => (QUALITY_RANK[b.quality] ?? 0) - (QUALITY_RANK[a.quality] ?? 0));
      have = candidates.reduce((sum, lot) => sum + lot.remaining, 0);
      let needed = req.quantity;
      for (const lot of candidates) {
        if (needed <= 0) break;
        const take = Math.min(needed, lot.remaining);
        usedDrugQty.set(lot.id, (usedDrugQty.get(lot.id) ?? 0) + take);
        selected.drugs.push({
          lotId: lot.id,
          drugType: lot.drugType,
          quality: lot.quality,
          quantity: take,
        });
        needed -= take;
        taken += take;
      }
    } else if (req.kind === 'weapon') {
      const minCondition = req.minCondition ?? 0;
      const candidates = snapshot.weapons
        .filter((stack) => weaponMatches(req, stack.weaponId))
        .map((stack) => ({
          ...stack,
          remaining: stack.quantity - (usedWeaponQty.get(stack.id) ?? 0),
        }))
        .filter((stack) => stack.remaining > 0 && stack.averageCondition >= minCondition)
        .sort((a, b) => b.averageCondition - a.averageCondition);
      have = candidates.reduce((sum, stack) => sum + stack.remaining, 0);
      const pick = candidates[0];
      if (pick && pick.remaining >= req.quantity) {
        usedWeaponQty.set(pick.id, (usedWeaponQty.get(pick.id) ?? 0) + req.quantity);
        const def = weaponService.getWeaponDefinition(pick.weaponId);
        matchedAmmoType = def?.ammoType;
        selected.weapons.push({
          stackId: pick.id,
          weaponId: pick.weaponId,
          ammoType: def?.ammoType,
          condition: pick.averageCondition,
          quantity: req.quantity,
        });
        taken = req.quantity;
      }
    } else if (req.kind === 'tool') {
      const minDurability = req.minDurability ?? 1;
      const allowed = req.toolIds?.length ? req.toolIds : req.toolId ? [req.toolId] : [];
      const candidates = snapshot.tools
        .filter((tool) => !usedToolIds.has(tool.id))
        .filter((tool) => (allowed.length ? allowed.includes(tool.toolId) : true))
        .filter((tool) => tool.durability >= minDurability)
        .sort((a, b) => b.durability - a.durability);
      have = candidates.length;
      for (let i = 0; i < req.quantity; i += 1) {
        const pick = candidates[i];
        if (!pick) break;
        usedToolIds.add(pick.id);
        selected.tools.push({
          inventoryId: pick.id,
          toolId: pick.toolId,
          durability: pick.durability,
        });
        taken += 1;
      }
    } else if (req.kind === 'vehicle') {
      const category = req.vehicleCategory || 'car';
      const minCondition = req.minCondition ?? 0;
      const minFuel = req.minFuel ?? 0;
      const pool =
        category === 'boat'
          ? snapshot.boats.map((row) => ({ ...row, vehicleType: 'boat' as const }))
          : snapshot.cars.filter((row) => row.vehicleType === category);
      const candidates = pool
        .filter((row) => !usedVehicleIds.has(row.id))
        .filter((row) => row.condition >= minCondition && row.fuelLevel >= minFuel)
        .filter((row) => vehiclePassesCatalog(req, row.vehicleId))
        .sort(
          (a, b) =>
            vehicleScore(req, b.vehicleId, b.condition, b.fuelLevel) -
            vehicleScore(req, a.vehicleId, a.condition, a.fuelLevel)
        );
      have = candidates.length;
      for (let i = 0; i < req.quantity; i += 1) {
        const pick = candidates[i];
        if (!pick) break;
        usedVehicleIds.add(pick.id);
        const stats = vehicleCatalog(pick.vehicleId);
        selected.vehicles.push({
          inventoryId: pick.id,
          vehicleId: pick.vehicleId,
          category,
          condition: pick.condition,
          fuelLevel: pick.fuelLevel,
          ...stats,
        });
        taken += 1;
      }
    }

    const met = taken >= req.quantity;
    lines.push({
      kind: req.kind,
      key,
      need: req.quantity,
      have,
      met,
      effect,
      minCondition: req.minCondition,
      minDurability: req.minDurability,
      minFuel: req.minFuel,
      minQuality: req.minQuality,
    });
    if (!met) {
      missing.push({ kind: req.kind, key, need: req.quantity, have });
    }
  }

  const gearBonusPp = computeGearBonusPp(selected, requirements);
  const quotedSuccessChance = clampMissionSuccessChance(baseSuccessChance + gearBonusPp / 100);

  return {
    canStart: missing.length === 0,
    missing,
    lines,
    gearBonus: gearBonusPp / 100,
    gearBonusPp,
    quotedSuccessChance,
    consumePreview: lines.filter((line) => line.effect === 'consume'),
    wearPreview: lines.filter((line) => line.effect === 'wear'),
    selected,
  };
}

function landVehicleType(vehicleId: string): VehicleCategory {
  return vehicleService.getVehicleById(vehicleId)?.vehicleCategory === 'motorcycle'
    ? 'motorcycle'
    : 'car';
}

export async function loadCrewMissionStorageSnapshot(
  crewId: number,
  tx: Prisma.TransactionClient | typeof prisma = prisma
): Promise<CrewMissionStorageSnapshot> {
  const [cars, boats, weapons, ammo, drugLots, trade, tools] = await Promise.all([
    tx.crewCarInventory.findMany({ where: { crewId } }),
    tx.crewBoatInventory.findMany({ where: { crewId } }),
    tx.crewWeaponInventory.findMany({ where: { crewId } }),
    tx.crewAmmoInventory.findMany({ where: { crewId } }),
    tx.crewDrugLot.findMany({ where: { crewId } }),
    tx.crewTradeInventory.findMany({ where: { crewId } }),
    tx.crewToolInventory.findMany({ where: { crewId } }),
  ]);

  return {
    cars: cars.map((row) => ({
      id: row.id,
      vehicleId: row.vehicleId,
      condition: row.condition,
      fuelLevel: row.fuelLevel,
      vehicleType: landVehicleType(row.vehicleId),
    })),
    boats: boats.map((row) => ({
      id: row.id,
      vehicleId: row.vehicleId,
      condition: row.condition,
      fuelLevel: row.fuelLevel,
    })),
    weapons: weapons.map((row) => ({
      id: row.id,
      weaponId: row.weaponId,
      quantity: row.quantity,
      averageCondition: row.averageCondition,
    })),
    ammo: ammo.map((row) => ({ ammoType: row.ammoType, quantity: row.quantity })),
    drugLots: drugLots.map((row) => ({
      id: row.id,
      drugType: row.drugType,
      quality: row.quality,
      quantity: row.quantity,
    })),
    trade: trade.map((row) => ({ goodType: row.goodType, quantity: row.quantity })),
    tools: tools.map((row) => ({ id: row.id, toolId: row.toolId, durability: row.durability })),
  };
}

export async function consumeAndWearMissionStorage(
  crewId: number,
  requirements: MissionRequirement[]
): Promise<MissionRequirementQuote> {
  if (!requirements.length) {
    return quoteMissionRequirements([], { cars: [], boats: [], weapons: [], ammo: [], drugLots: [], trade: [], tools: [] });
  }

  return prisma.$transaction(async (tx) => {
    const snapshot = await loadCrewMissionStorageSnapshot(crewId, tx);
    const quote = quoteMissionRequirements(requirements, snapshot);
    if (!quote.canStart) {
      throw new MissionStorageNotMetError(quote.missing);
    }

    for (const row of quote.selected.trade) {
      const inv = await tx.crewTradeInventory.findUnique({
        where: { crewId_goodType: { crewId, goodType: row.goodType } },
      });
      if (!inv || inv.quantity < row.quantity) {
        throw new MissionStorageNotMetError([
          { kind: 'trade', key: row.goodType, need: row.quantity, have: inv?.quantity ?? 0 },
        ]);
      }
      if (inv.quantity === row.quantity) {
        await tx.crewTradeInventory.delete({ where: { id: inv.id } });
      } else {
        await tx.crewTradeInventory.update({
          where: { id: inv.id },
          data: { quantity: inv.quantity - row.quantity },
        });
      }
    }

    for (const row of quote.selected.ammo) {
      const inv = await tx.crewAmmoInventory.findUnique({
        where: { crewId_ammoType: { crewId, ammoType: row.ammoType } },
      });
      if (!inv || inv.quantity < row.quantity) {
        throw new MissionStorageNotMetError([
          { kind: 'ammo', key: row.ammoType, need: row.quantity, have: inv?.quantity ?? 0 },
        ]);
      }
      if (inv.quantity === row.quantity) {
        await tx.crewAmmoInventory.delete({ where: { id: inv.id } });
      } else {
        await tx.crewAmmoInventory.update({
          where: { id: inv.id },
          data: { quantity: inv.quantity - row.quantity },
        });
      }
    }

    for (const row of quote.selected.drugs) {
      const lot = await tx.crewDrugLot.findUnique({ where: { id: row.lotId } });
      if (!lot || lot.crewId !== crewId || lot.quantity < row.quantity) {
        throw new MissionStorageNotMetError([
          { kind: 'drug', key: row.drugType, need: row.quantity, have: lot?.quantity ?? 0 },
        ]);
      }
      if (lot.quantity === row.quantity) {
        await tx.crewDrugLot.delete({ where: { id: lot.id } });
      } else {
        await tx.crewDrugLot.update({
          where: { id: lot.id },
          data: { quantity: lot.quantity - row.quantity },
        });
      }
    }

    for (const row of quote.selected.weapons) {
      const stack = await tx.crewWeaponInventory.findUnique({ where: { id: row.stackId } });
      if (!stack || stack.crewId !== crewId || stack.quantity < row.quantity) {
        throw new MissionStorageNotMetError([
          { kind: 'weapon', key: row.weaponId, need: row.quantity, have: stack?.quantity ?? 0 },
        ]);
      }
      const remainingQty = stack.quantity - row.quantity;
      const wornCondition = Math.max(0, stack.averageCondition - WEAPON_CONDITION_WEAR);
      if (wornCondition < 1) {
        if (remainingQty <= 0) {
          await tx.crewWeaponInventory.delete({ where: { id: stack.id } });
        } else {
          await tx.crewWeaponInventory.update({
            where: { id: stack.id },
            data: { quantity: remainingQty },
          });
        }
      } else if (remainingQty <= 0) {
        await tx.crewWeaponInventory.update({
          where: { id: stack.id },
          data: { averageCondition: wornCondition },
        });
      } else {
        const mixed = Math.floor(
          (remainingQty * stack.averageCondition + row.quantity * wornCondition) / stack.quantity
        );
        await tx.crewWeaponInventory.update({
          where: { id: stack.id },
          data: { averageCondition: mixed },
        });
      }
    }

    for (const row of quote.selected.tools) {
      const tool = await tx.crewToolInventory.findUnique({ where: { id: row.inventoryId } });
      if (!tool || tool.crewId !== crewId) {
        throw new MissionStorageNotMetError([
          { kind: 'tool', key: row.toolId, need: 1, have: 0 },
        ]);
      }
      const def = toolService.getToolDefinition(tool.toolId);
      const wear = Math.max(1, def?.wearPerUse ?? DEFAULT_TOOL_WEAR);
      const next = tool.durability - wear;
      if (next <= 0) {
        await tx.crewToolInventory.delete({ where: { id: tool.id } });
      } else {
        await tx.crewToolInventory.update({
          where: { id: tool.id },
          data: { durability: next },
        });
      }
    }

    for (const row of quote.selected.vehicles) {
      if (row.category === 'boat') {
        const boat = await tx.crewBoatInventory.findUnique({ where: { id: row.inventoryId } });
        if (!boat || boat.crewId !== crewId) {
          throw new MissionStorageNotMetError([
            { kind: 'vehicle', key: 'boat', need: 1, have: 0 },
          ]);
        }
        await tx.crewBoatInventory.update({
          where: { id: boat.id },
          data: {
            condition: Math.max(0, boat.condition - VEHICLE_CONDITION_WEAR),
            fuelLevel: Math.max(0, boat.fuelLevel - VEHICLE_FUEL_DRAIN),
          },
        });
      } else {
        const car = await tx.crewCarInventory.findUnique({ where: { id: row.inventoryId } });
        if (!car || car.crewId !== crewId) {
          throw new MissionStorageNotMetError([
            { kind: 'vehicle', key: row.category, need: 1, have: 0 },
          ]);
        }
        await tx.crewCarInventory.update({
          where: { id: car.id },
          data: {
            condition: Math.max(0, car.condition - VEHICLE_CONDITION_WEAR),
            fuelLevel: Math.max(0, car.fuelLevel - VEHICLE_FUEL_DRAIN),
          },
        });
      }
    }

    return quote;
  });
}
