export const ARMOR_REPAIR_RATE = 0.5;
export const ARMOR_TRADE_IN_RATE = 0.4;
export const BODYGUARD_CAP = 10;

export type BodyguardTypeId = 'street' | 'standard' | 'elite';

export interface BodyguardTypeDefinition {
  id: BodyguardTypeId;
  hireCost: number;
  defense: number;
  dailyCost: number;
}

export interface BodyguardRoster {
  street: number;
  standard: number;
  elite: number;
}

export const BODYGUARD_TYPES: Record<BodyguardTypeId, BodyguardTypeDefinition> = {
  street: { id: 'street', hireCost: 6000, defense: 8, dailyCost: 4000 },
  standard: { id: 'standard', hireCost: 10000, defense: 10, dailyCost: 10000 },
  elite: { id: 'elite', hireCost: 35000, defense: 22, dailyCost: 18000 },
};

export const BODYGUARD_TYPE_LIST: BodyguardTypeDefinition[] = [
  BODYGUARD_TYPES.street,
  BODYGUARD_TYPES.standard,
  BODYGUARD_TYPES.elite,
];

export function emptyBodyguardRoster(): BodyguardRoster {
  return { street: 0, standard: 0, elite: 0 };
}

export function normalizeBodyguardRoster(input?: Partial<BodyguardRoster> | null): BodyguardRoster {
  return {
    street: Math.max(0, Math.floor(Number(input?.street || 0))),
    standard: Math.max(0, Math.floor(Number(input?.standard || 0))),
    elite: Math.max(0, Math.floor(Number(input?.elite || 0))),
  };
}

export function isBodyguardTypeId(value: unknown): value is BodyguardTypeId {
  return value === 'street' || value === 'standard' || value === 'elite';
}

export function bodyguardTotal(roster?: Partial<BodyguardRoster> | null): number {
  const counts = normalizeBodyguardRoster(roster);
  return counts.street + counts.standard + counts.elite;
}

export function bodyguardDefense(roster?: Partial<BodyguardRoster> | null): number {
  const counts = normalizeBodyguardRoster(roster);
  return (
    counts.street * BODYGUARD_TYPES.street.defense +
    counts.standard * BODYGUARD_TYPES.standard.defense +
    counts.elite * BODYGUARD_TYPES.elite.defense
  );
}

export function bodyguardDailyCost(roster?: Partial<BodyguardRoster> | null): number {
  const counts = normalizeBodyguardRoster(roster);
  return (
    counts.street * BODYGUARD_TYPES.street.dailyCost +
    counts.standard * BODYGUARD_TYPES.standard.dailyCost +
    counts.elite * BODYGUARD_TYPES.elite.dailyCost
  );
}

export function canHireBodyguards(
  roster: Partial<BodyguardRoster> | null | undefined,
  quantity: number,
  cap = BODYGUARD_CAP
): boolean {
  const add = Math.max(0, Math.floor(Number(quantity || 0)));
  return bodyguardTotal(roster) + add <= cap;
}

export function armorRepairCost(price: number, condition: number): number {
  const safePrice = Math.max(0, Math.floor(Number(price || 0)));
  const missing = Math.max(0, Math.min(100, 100 - Math.floor(Number(condition || 0))));
  if (missing <= 0 || safePrice <= 0) {
    return 0;
  }
  return Math.max(1, Math.ceil((safePrice * missing * ARMOR_REPAIR_RATE) / 100));
}

export function armorTradeInCredit(price: number, condition: number): number {
  const safePrice = Math.max(0, Math.floor(Number(price || 0)));
  const safeCondition = Math.max(0, Math.min(100, Math.floor(Number(condition || 0))));
  if (safePrice <= 0 || safeCondition <= 0) {
    return 0;
  }
  return Math.floor((safePrice * safeCondition * ARMOR_TRADE_IN_RATE) / 100);
}

export function armorNetPrice(newPrice: number, tradeInCredit: number): number {
  return Math.max(0, Math.floor(Number(newPrice || 0)) - Math.max(0, Math.floor(Number(tradeInCredit || 0))));
}

export const CRIME_HEALTH_MITIGATION_CAP = 0.55;

export function effectiveArmorRating(armor: number, condition: number): number {
  const rating = Math.max(0, Math.floor(Number(armor || 0)));
  const cond = Math.max(0, Math.min(100, Math.floor(Number(condition ?? 100))));
  if (rating <= 0) {
    return 0;
  }
  return Math.max(0, Math.round(rating * (cond / 100)));
}

export function crimeHealthMitigationFactor(
  armorRating: number,
  guardDefense: number
): number {
  const score = Math.max(0, Number(armorRating || 0)) + Math.max(0, Number(guardDefense || 0)) * 0.35;
  return Math.min(CRIME_HEALTH_MITIGATION_CAP, score / 400);
}

export function applyCrimeHealthMitigation(
  rawDamage: number,
  armorRating: number,
  guardDefense: number
): number {
  const raw = Math.max(0, Math.floor(Number(rawDamage || 0)));
  if (raw <= 0) {
    return 0;
  }
  const factor = 1 - crimeHealthMitigationFactor(armorRating, guardDefense);
  return Math.max(1, Math.round(raw * factor));
}

export type InvestigationTierId = 'quick' | 'standard' | 'deep';
export type InvestigationClarity = 'full' | 'partial' | 'blocked';

export const INVESTIGATION_TIER_PIERCE: Record<InvestigationTierId, number> = {
  quick: 40,
  standard: 90,
  deep: 160,
};

export function investigationClarity(
  guardDefense: number,
  tier: InvestigationTierId
): InvestigationClarity {
  const pierce = INVESTIGATION_TIER_PIERCE[tier] ?? INVESTIGATION_TIER_PIERCE.standard;
  const pressure = Math.max(0, Number(guardDefense || 0));
  if (pressure <= pierce) {
    return 'full';
  }
  if (pressure <= pierce + 50) {
    return 'partial';
  }
  return 'blocked';
}

export function murderCaseSolveChance(baseChance: number, killerGuardDefense: number): number {
  const base = Math.max(0, Math.min(1, Number(baseChance || 0)));
  const penalty = Math.min(0.35, Math.max(0, Number(killerGuardDefense || 0)) / 400);
  return Math.max(0.2, base - penalty);
}
