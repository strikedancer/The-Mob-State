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

export function computeExpungePetitionCost(convictionCount: number): number {
  const n = Math.max(0, Math.floor(Number(convictionCount) || 0));
  if (n <= 0) return 0;
  return EXPUNGE_PETITION_BASE_COST + Math.max(0, n - 1) * EXPUNGE_PETITION_COST_PER_EXTRA;
}

export function computeExpungeRecordModifierPercent(convictionCount: number): number {
  const extra = Math.max(0, Math.floor(Number(convictionCount) || 0) - 1);
  return Math.max(EXPUNGE_PETITION_RECORD_FLOOR, extra * -2);
}

export function computeExpungeRecencyModifierPercent(hoursSinceLastArrest: number | null): number {
  if (hoursSinceLastArrest == null || !Number.isFinite(hoursSinceLastArrest)) {
    return 0;
  }
  const hours = Math.max(0, hoursSinceLastArrest);
  if (hours < 1) return -15;
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
  input: ExpungePetitionOddsInput
): ExpungePetitionOddsBreakdown {
  const convictionCount = Math.max(0, Math.floor(Number(input.convictionCount) || 0));
  const reputation = Math.max(0, Math.floor(Number(input.reputation) || 0));
  const recordModifierPercent = computeExpungeRecordModifierPercent(convictionCount);
  const recencyModifierPercent = computeExpungeRecencyModifierPercent(input.hoursSinceLastArrest);
  const reputationModifierPercent = computeExpungeReputationModifierPercent(reputation);
  const donJudgePercent = input.hasJudge ? EXPUNGE_PETITION_DON_JUDGE_PERCENT : 0;
  const donCommissionerPercent = input.hasCommissioner
    ? EXPUNGE_PETITION_DON_COMMISSIONER_PERCENT
    : 0;
  const donAldermanPercent = input.hasAlderman ? EXPUNGE_PETITION_DON_ALDERMAN_PERCENT : 0;

  const rawPercent =
    EXPUNGE_PETITION_BASE_PERCENT +
    recordModifierPercent +
    recencyModifierPercent +
    reputationModifierPercent +
    donJudgePercent +
    donCommissionerPercent +
    donAldermanPercent;
  const successPercent = Math.max(
    EXPUNGE_PETITION_MIN_PERCENT,
    Math.min(EXPUNGE_PETITION_MAX_PERCENT, rawPercent)
  );

  return {
    convictionCount,
    basePercent: EXPUNGE_PETITION_BASE_PERCENT,
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
