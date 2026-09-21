/** Code defaults — live values come from courtRuntimeConfig when available. */
export const EXPUNGE_PETITION_BASE_COST = 100_000;
export const EXPUNGE_PETITION_COST_PER_EXTRA = 1_000;
export const EXPUNGE_PETITION_BASE_PERCENT = 38;
export const EXPUNGE_PETITION_MIN_PERCENT = 8;
export const EXPUNGE_PETITION_MAX_PERCENT = 70;
export const EXPUNGE_PETITION_RECORD_FLOOR = -30;
export const EXPUNGE_PETITION_DON_JUDGE_PERCENT = 8;
export const EXPUNGE_PETITION_DON_COMMISSIONER_PERCENT = 6;
export const EXPUNGE_PETITION_DON_ALDERMAN_PERCENT = 5;
export const EXPUNGE_PETITION_COOLDOWN_SECONDS = 43_200;
export const EXPUNGE_PETITION_FRESH_ARREST_HOURS = 1;

export interface ExpungePetitionMathConfig {
  baseCost?: number;
  costPerExtra?: number;
  basePercent?: number;
  minPercent?: number;
  maxPercent?: number;
  donJudgePercent?: number;
  donCommissionerPercent?: number;
  donAldermanPercent?: number;
  freshArrestHours?: number;
}

export interface ExpungePetitionOddsInput {
  convictionCount: number;
  hoursSinceLastArrest: number | null;
  reputation: number;
  hasJudge: boolean;
  hasCommissioner: boolean;
  hasAlderman: boolean;
}

export interface ExpungePetitionOddsBreakdown {
  convictionCount: number;
  basePercent: number;
  recordModifierPercent: number;
  recencyModifierPercent: number;
  reputationModifierPercent: number;
  reputation: number;
  donJudgePercent: number;
  donCommissionerPercent: number;
  donAldermanPercent: number;
  hasJudge: boolean;
  hasCommissioner: boolean;
  hasAlderman: boolean;
  hoursSinceLastArrest: number | null;
  successChance: number;
  successPercent: number;
}

function resolve(cfg: ExpungePetitionMathConfig | undefined) {
  return {
    baseCost: cfg?.baseCost ?? EXPUNGE_PETITION_BASE_COST,
    costPerExtra: cfg?.costPerExtra ?? EXPUNGE_PETITION_COST_PER_EXTRA,
    basePercent: cfg?.basePercent ?? EXPUNGE_PETITION_BASE_PERCENT,
    minPercent: cfg?.minPercent ?? EXPUNGE_PETITION_MIN_PERCENT,
    maxPercent: cfg?.maxPercent ?? EXPUNGE_PETITION_MAX_PERCENT,
    donJudgePercent: cfg?.donJudgePercent ?? EXPUNGE_PETITION_DON_JUDGE_PERCENT,
    donCommissionerPercent:
      cfg?.donCommissionerPercent ?? EXPUNGE_PETITION_DON_COMMISSIONER_PERCENT,
    donAldermanPercent: cfg?.donAldermanPercent ?? EXPUNGE_PETITION_DON_ALDERMAN_PERCENT,
    freshArrestHours: cfg?.freshArrestHours ?? EXPUNGE_PETITION_FRESH_ARREST_HOURS,
  };
}

export function computeExpungePetitionCost(
  convictionCount: number,
  cfg?: ExpungePetitionMathConfig,
): number {
  const c = resolve(cfg);
  const n = Math.max(0, Math.floor(Number(convictionCount) || 0));
  if (n <= 0) return 0;
  return c.baseCost + Math.max(0, n - 1) * c.costPerExtra;
}

export function computeExpungeRecordModifierPercent(convictionCount: number): number {
  const extra = Math.max(0, Math.floor(Number(convictionCount) || 0) - 1);
  return Math.max(EXPUNGE_PETITION_RECORD_FLOOR, extra * -2);
}

export function computeExpungeRecencyModifierPercent(
  hoursSinceLastArrest: number | null,
  cfg?: ExpungePetitionMathConfig,
): number {
  if (hoursSinceLastArrest == null || !Number.isFinite(hoursSinceLastArrest)) {
    return 0;
  }
  const hours = Math.max(0, hoursSinceLastArrest);
  const freshHours = Math.max(0, resolve(cfg).freshArrestHours);
  if (hours < freshHours) return -15;
  if (hours < 72) return -8;
  if (hours < 168) return 0;
  if (hours < 336) return 8;
  return 15;
}

export function computeExpungeReputationModifierPercent(reputation: number): number {
  const points = Math.max(0, Math.floor(Number(reputation) || 0));
  return Math.min(15, Math.floor(points / 20));
}

export function computeExpungePetitionOdds(
  input: ExpungePetitionOddsInput,
  cfg?: ExpungePetitionMathConfig,
): ExpungePetitionOddsBreakdown {
  const c = resolve(cfg);
  const convictionCount = Math.max(0, Math.floor(Number(input.convictionCount) || 0));
  const reputation = Math.max(0, Math.floor(Number(input.reputation) || 0));
  const recordModifierPercent = computeExpungeRecordModifierPercent(convictionCount);
  const recencyModifierPercent = computeExpungeRecencyModifierPercent(
    input.hoursSinceLastArrest,
    cfg,
  );
  const reputationModifierPercent = computeExpungeReputationModifierPercent(reputation);
  const donJudgePercent = input.hasJudge ? c.donJudgePercent : 0;
  const donCommissionerPercent = input.hasCommissioner ? c.donCommissionerPercent : 0;
  const donAldermanPercent = input.hasAlderman ? c.donAldermanPercent : 0;

  const rawPercent =
    c.basePercent +
    recordModifierPercent +
    recencyModifierPercent +
    reputationModifierPercent +
    donJudgePercent +
    donCommissionerPercent +
    donAldermanPercent;
  const successPercent = Math.max(
    c.minPercent,
    Math.min(c.maxPercent, rawPercent),
  );

  return {
    convictionCount,
    basePercent: c.basePercent,
    recordModifierPercent,
    recencyModifierPercent,
    reputationModifierPercent,
    reputation,
    donJudgePercent,
    donCommissionerPercent,
    donAldermanPercent,
    hasJudge: !!input.hasJudge,
    hasCommissioner: !!input.hasCommissioner,
    hasAlderman: !!input.hasAlderman,
    hoursSinceLastArrest: input.hoursSinceLastArrest,
    successChance: successPercent / 100,
    successPercent,
  };
}
