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

/** Failed hit attempts stay on the contract; next try after this pause. */
export const HIT_COMBAT_COOLDOWN_MS = 10 * 60 * 1000;

export function applyBodyguardCasualties(
  roster: Partial<BodyguardRoster> | null | undefined,
  lostCount: number
): { roster: BodyguardRoster; lost: number } {
  const next = normalizeBodyguardRoster(roster);
  let remaining = Math.max(0, Math.floor(Number(lostCount || 0)));
  let lost = 0;
  for (const key of ['elite', 'standard', 'street'] as const) {
    const take = Math.min(next[key], remaining);
    next[key] -= take;
    remaining -= take;
    lost += take;
  }
  return { roster: next, lost };
}

export function hitFailGuardLoss(totalGuards: number, pressure: number): number {
  const total = Math.max(0, Math.floor(Number(totalGuards || 0)));
  if (total <= 0) {
    return 0;
  }
  const clamped = Math.max(0, Math.min(1, Number(pressure || 0)));
  const fraction = 0.25 + clamped * 0.3;
  return Math.min(total, Math.max(1, Math.round(total * fraction)));
}

export function hitFailHealthLoss(pressure: number, armorRating: number): number {
  const clamped = Math.max(0, Math.min(1, Number(pressure || 0)));
  const raw = 22 + clamped * 28;
  const vestFactor = 1 - Math.min(0.35, Math.max(0, Number(armorRating || 0)) / 400);
  return Math.max(12, Math.round(raw * vestFactor));
}

export type InvestigationTierId = 'quick' | 'standard' | 'deep';
export type InvestigationClarity = 'full' | 'partial' | 'blocked';

export const INVESTIGATION_TIER_PIERCE: Record<InvestigationTierId, number> = {
  quick: 40,
  standard: 90,
  deep: 160,
};

/** After this offline time, intel steps up one clarity level. */
export const INVESTIGATION_OFFLINE_SOFT_MS = 48 * 60 * 60 * 1000;
/** After this offline time, reports are always full and murder-case guards stop helping. */
export const INVESTIGATION_OFFLINE_HARD_MS = 7 * 24 * 60 * 60 * 1000;

export interface InvestigationClarityOptions {
  lastTickAt?: Date | string | null;
  now?: Date;
}

export function investigationOfflineDecaySteps(
  lastTickAt?: Date | string | null,
  now: Date = new Date()
): number {
  if (!lastTickAt) {
    return 0;
  }
  const seen = lastTickAt instanceof Date ? lastTickAt : new Date(lastTickAt);
  if (Number.isNaN(seen.getTime())) {
    return 0;
  }
  const age = now.getTime() - seen.getTime();
  if (age >= INVESTIGATION_OFFLINE_HARD_MS) {
    return 2;
  }
  if (age >= INVESTIGATION_OFFLINE_SOFT_MS) {
    return 1;
  }
  return 0;
}

function raiseInvestigationClarity(
  clarity: InvestigationClarity,
  steps: number
): InvestigationClarity {
  if (steps <= 0 || clarity === 'full') {
    return clarity;
  }
  if (clarity === 'blocked') {
    return steps >= 2 ? 'full' : 'partial';
  }
  return 'full';
}

export function investigationClarity(
  guardDefense: number,
  tier: InvestigationTierId,
  options?: InvestigationClarityOptions
): InvestigationClarity {
  const pierce = INVESTIGATION_TIER_PIERCE[tier] ?? INVESTIGATION_TIER_PIERCE.standard;
  const pressure = Math.max(0, Number(guardDefense || 0));
  let clarity: InvestigationClarity;
  if (pressure <= pierce) {
    clarity = 'full';
  } else if (pressure <= pierce + 50) {
    clarity = 'partial';
  } else {
    clarity = 'blocked';
  }
  // Slow detectives always leak country, even against a paid max elite stack.
  if (tier === 'deep' && clarity === 'blocked') {
    clarity = 'partial';
  }
  return raiseInvestigationClarity(
    clarity,
    investigationOfflineDecaySteps(options?.lastTickAt, options?.now)
  );
}

export function murderCaseSolveChance(
  baseChance: number,
  killerGuardDefense: number,
  options?: InvestigationClarityOptions
): number {
  const base = Math.max(0, Math.min(1, Number(baseChance || 0)));
  const steps = investigationOfflineDecaySteps(options?.lastTickAt, options?.now);
  let defense = Math.max(0, Number(killerGuardDefense || 0));
  if (steps >= 2) {
    defense = 0;
  } else if (steps >= 1) {
    defense *= 0.5;
  }
  const penalty = Math.min(0.35, defense / 400);
  return Math.max(0.2, base - penalty);
}
