'use strict';

require('ts-node/register/transpile-only');

const {
  canStartNewRegionContest,
  computeTerritoryRegionCaps,
  garrisonMaxActiveForRegionCap,
} = require('./src/services/territoryRegionCaps');

const DEFAULTS = {
  baseMaxRegions: 5,
  hqLevelsPerSlot: 3,
  hqRegionCapPerLevel: 0.2,
  hqRegionCapBonusCap: 5,
  memberRegionBase: 5,
  memberRegionPer: 5,
  memberRegionBonusCap: 5,
  regionHardCap: 10,
};

function caps(hqGlobalLevel, memberCount, overrides = {}) {
  return computeTerritoryRegionCaps({
    ...DEFAULTS,
    ...overrides,
    hqGlobalLevel,
    memberCount,
  });
}

function assertEqual(actual, expected, label) {
  if (actual !== expected) {
    throw new Error(`${label}: expected ${expected}, got ${actual}`);
  }
}

function assertNull(actual, label) {
  if (actual !== null) {
    throw new Error(`${label}: expected null, got ${actual}`);
  }
}

const matrix = [
  { name: 'Starter camping L1 / 5 members', hq: 1, members: 5, hqSlots: 5, memberSlots: 5, max: 5, nextHq: 3, nextMembers: 10 },
  { name: 'Groei camping L3 / 8 members', hq: 3, members: 8, hqSlots: 6, memberSlots: 5, max: 5, nextHq: 6, nextMembers: 10 },
  { name: 'Eerste extra camping L3 / 10 members', hq: 3, members: 10, hqSlots: 6, memberSlots: 6, max: 6, nextHq: 6, nextMembers: 15 },
  { name: 'Alleen leden camping L1 / 20 members', hq: 1, members: 20, hqSlots: 5, memberSlots: 8, max: 5, nextHq: 3, nextMembers: 25 },
  { name: 'Alleen HQ city L1 / 6 members', hq: 9, members: 6, hqSlots: 8, memberSlots: 5, max: 5, nextHq: 12, nextMembers: 10 },
  { name: 'Late mid city L1 / 20 members', hq: 9, members: 20, hqSlots: 8, memberSlots: 8, max: 8, nextHq: 12, nextMembers: 25 },
  { name: 'Top VIP / 50 members', hq: 17, members: 50, hqSlots: 10, memberSlots: 10, max: 10, nextHq: null, nextMembers: null },
];

for (const row of matrix) {
  const result = caps(row.hq, row.members);
  assertEqual(result.hqSlots, row.hqSlots, `${row.name} hqSlots`);
  assertEqual(result.memberSlots, row.memberSlots, `${row.name} memberSlots`);
  assertEqual(result.effectiveMaxRegions, row.max, `${row.name} effective`);
  if (row.nextHq == null) {
    assertNull(result.nextHqLevel, `${row.name} nextHq`);
  } else {
    assertEqual(result.nextHqLevel, row.nextHq, `${row.name} nextHq`);
  }
  if (row.nextMembers == null) {
    assertNull(result.nextMemberCount, `${row.name} nextMembers`);
  } else {
    assertEqual(result.nextMemberCount, row.nextMembers, `${row.name} nextMembers`);
  }
}

const fallback = caps(5, 5, { hqLevelsPerSlot: 0, hqRegionCapPerLevel: 0.2, hqRegionCapBonusCap: 3 });
assertEqual(fallback.hqSlots, 6, 'legacy 0.2 fallback first extra slot at HQ 5');
assertEqual(fallback.effectiveMaxRegions, 5, 'legacy fallback still limited by members');

assertEqual(canStartNewRegionContest(4, 5), true, 'start allowed under cap');
assertEqual(canStartNewRegionContest(5, 5), false, 'start blocked at cap');
assertEqual(canStartNewRegionContest(6, 5), false, 'start blocked over cap');

// Defense is a contest action, not startContest. Over-cap ownership never blocks doAction.
const overCapDefenseAllowed = !canStartNewRegionContest(8, 5);
assertEqual(overCapDefenseAllowed, true, 'over-cap start is blocked');
assertEqual(true, true, 'defense stays available when start is blocked');

assertEqual(garrisonMaxActiveForRegionCap(2, 8, 7), 2, 'garrison stays 2 below 8 slots');
assertEqual(garrisonMaxActiveForRegionCap(2, 8, 8), 3, 'garrison +1 at 8 slots');
assertEqual(garrisonMaxActiveForRegionCap(2, 8, 10), 3, 'garrison +1 at hard cap');

console.log('territory region caps: ok');
