'use strict';

const EXPUNGE_PETITION_BASE_COST = 100000;
const EXPUNGE_PETITION_COST_PER_EXTRA = 1000;
const EXPUNGE_PETITION_BASE_PERCENT = 38;
const EXPUNGE_PETITION_MIN_PERCENT = 8;
const EXPUNGE_PETITION_MAX_PERCENT = 70;
const EXPUNGE_PETITION_RECORD_FLOOR = -30;
const EXPUNGE_PETITION_DON_JUDGE_PERCENT = 8;
const EXPUNGE_PETITION_DON_COMMISSIONER_PERCENT = 6;
const EXPUNGE_PETITION_DON_ALDERMAN_PERCENT = 5;

function computeExpungePetitionCost(convictionCount) {
  const n = Math.max(0, Math.floor(Number(convictionCount) || 0));
  if (n <= 0) return 0;
  return EXPUNGE_PETITION_BASE_COST + Math.max(0, n - 1) * EXPUNGE_PETITION_COST_PER_EXTRA;
}

function computeExpungeRecordModifierPercent(convictionCount) {
  const extra = Math.max(0, Math.floor(Number(convictionCount) || 0) - 1);
  return Math.max(EXPUNGE_PETITION_RECORD_FLOOR, extra * -2);
}

function computeExpungeRecencyModifierPercent(hoursSinceLastArrest) {
  if (hoursSinceLastArrest == null || !Number.isFinite(hoursSinceLastArrest)) {
    return 0;
  }
  const hours = Math.max(0, hoursSinceLastArrest);
  if (hours < 24) return -15;
  if (hours < 72) return -8;
  if (hours < 168) return 0;
  if (hours < 336) return 8;
  return 15;
}

function computeExpungeReputationModifierPercent(reputation) {
  const points = Math.max(0, Math.floor(Number(reputation) || 0));
  return Math.min(15, Math.floor(points / 20));
}

function computeExpungePetitionOdds(input) {
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
    recordModifierPercent,
    recencyModifierPercent,
    reputationModifierPercent,
    donJudgePercent,
    donCommissionerPercent,
    donAldermanPercent,
    successPercent,
  };
}

function failPetitionClearsRecord(success) {
  return success === true;
}

function assertEqual(actual, expected, label) {
  if (actual !== expected) {
    throw new Error(`${label}: expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
}

assertEqual(computeExpungePetitionCost(0), 0, 'no record costs 0');
assertEqual(computeExpungePetitionCost(1), 100000, 'one conviction is 100k');
assertEqual(computeExpungePetitionCost(2), 101000, 'two convictions are 101k');
assertEqual(computeExpungePetitionCost(10), 109000, 'ten convictions are 109k');

const oneFresh = computeExpungePetitionOdds({
  convictionCount: 1,
  hoursSinceLastArrest: 4,
  reputation: 0,
  hasJudge: false,
  hasCommissioner: false,
  hasAlderman: false,
});
assertEqual(oneFresh.recordModifierPercent, 0, 'first conviction no extra record penalty');
assertEqual(oneFresh.recencyModifierPercent, -15, 'under 24h recency');
assertEqual(oneFresh.successPercent, 23, '38 - 15 recency');

const tenFresh = computeExpungePetitionOdds({
  convictionCount: 10,
  hoursSinceLastArrest: 2,
  reputation: 0,
  hasJudge: false,
  hasCommissioner: false,
  hasAlderman: false,
});
assertEqual(tenFresh.recordModifierPercent, -18, 'ten convictions -18');
assertEqual(tenFresh.successPercent, 8, '38-18-15 clamps to 8');

const stacked = computeExpungePetitionOdds({
  convictionCount: 1,
  hoursSinceLastArrest: 24 * 20,
  reputation: 400,
  hasJudge: true,
  hasCommissioner: true,
  hasAlderman: true,
});
assertEqual(stacked.reputationModifierPercent, 15, 'reputation caps at +15');
assertEqual(stacked.recencyModifierPercent, 15, '14+ days recency');
assertEqual(stacked.donJudgePercent, 8, 'judge don bonus');
assertEqual(stacked.donCommissionerPercent, 6, 'commissioner don bonus');
assertEqual(stacked.donAldermanPercent, 5, 'alderman don bonus');
assertEqual(stacked.successPercent, 70, '38+15+15+19 clamps to 70');

assertEqual(failPetitionClearsRecord(false), false, 'fail path does not wipe the record');
assertEqual(failPetitionClearsRecord(true), true, 'success path wipes the record');

console.log('test-expunge-petition: ok');
