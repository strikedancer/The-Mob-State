'use strict';

function clampNumber(value, min, max) {
  return Math.min(max, Math.max(min, value));
}

function clampMissionSuccessChance(value) {
  return clampNumber(value, 0.2, 0.95);
}

function conditionGearPp(condition) {
  return clampNumber(Math.round((condition - 60) / 5), -8, 8);
}

function fuelGearPp(fuel) {
  if (fuel < 20) return -10;
  if (fuel < 50) return -4;
  if (fuel >= 80) return 3;
  return 0;
}

function catalogStatGearPp(stat, threshold) {
  return clampNumber(Math.round((stat - threshold) / 8), -6, 6);
}

const QUALITY_BONUS_PP = { D: -8, C: 0, B: 4, A: 8, S: 12 };

function weightedDrugQualityPp(consumed) {
  const total = consumed.reduce((sum, row) => sum + Math.max(0, row.quantity), 0);
  if (total <= 0) return 0;
  const weighted = consumed.reduce((sum, row) => {
    const bonus = QUALITY_BONUS_PP[row.quality] ?? 0;
    return sum + bonus * Math.max(0, row.quantity);
  }, 0);
  return weighted / total;
}

function parseMissionRequirements(raw) {
  if (!raw) return [];
  const parsed = JSON.parse(raw);
  if (!Array.isArray(parsed)) return [];
  return parsed
    .map((entry) => {
      const kind = String(entry?.kind ?? '').trim().toLowerCase();
      const quantity = Number.parseInt(String(entry?.quantity ?? '0'), 10) || 0;
      if (!kind && entry?.goodType && quantity > 0) {
        return { kind: 'trade', quantity, goodType: String(entry.goodType).trim() };
      }
      if (!['trade', 'ammo', 'drug', 'weapon', 'tool', 'vehicle'].includes(kind) || quantity <= 0) {
        return null;
      }
      return { kind, quantity, ...entry };
    })
    .filter(Boolean);
}

function quoteSimple(requirements, snapshot) {
  const missing = [];
  for (const req of requirements) {
    if (req.kind === 'trade') {
      const have = snapshot.trade
        .filter((row) => row.goodType === req.goodType)
        .reduce((sum, row) => sum + row.quantity, 0);
      if (have < req.quantity) missing.push({ kind: 'trade', have, need: req.quantity });
    }
    if (req.kind === 'ammo') {
      const have = snapshot.ammo
        .filter((row) => row.ammoType === req.ammoType)
        .reduce((sum, row) => sum + row.quantity, 0);
      if (have < req.quantity) missing.push({ kind: 'ammo', have, need: req.quantity });
    }
    if (req.kind === 'tool') {
      const have = snapshot.tools.filter(
        (row) => row.toolId === req.toolId && row.durability >= (req.minDurability ?? 1)
      ).length;
      if (have < req.quantity) missing.push({ kind: 'tool', have, need: req.quantity });
    }
  }
  return { canStart: missing.length === 0, missing };
}

let failed = 0;
function assert(name, cond) {
  if (!cond) {
    failed += 1;
    console.error(`FAIL ${name}`);
  } else {
    console.log(`ok   ${name}`);
  }
}

const legacy = parseMissionRequirements(
  JSON.stringify([{ goodType: 'contraband_tobacco', quantity: 35 }])
);
assert('legacy trade json still parses', legacy.length === 1 && legacy[0].kind === 'trade' && legacy[0].quantity === 35);

const typed = parseMissionRequirements(
  JSON.stringify([{ kind: 'tool', quantity: 1, toolId: 'crowbar', minDurability: 25 }])
);
assert('typed tool json parses', typed[0].kind === 'tool' && typed[0].toolId === 'crowbar');

const blocked = quoteSimple(typed, { trade: [], ammo: [], tools: [] });
assert('missing storage blocks start', blocked.canStart === false && blocked.missing[0].kind === 'tool');

const ready = quoteSimple(typed, {
  trade: [],
  ammo: [],
  tools: [{ toolId: 'crowbar', durability: 80 }],
});
assert('matching tool unlocks start', ready.canStart === true);

assert('condition 80 is +4pp', conditionGearPp(80) === 4);
assert('condition 40 is -4pp', conditionGearPp(40) === -4);
assert('condition clamp high', conditionGearPp(200) === 8);
assert('fuel empty penalty', fuelGearPp(10) === -10);
assert('fuel mid no bonus', fuelGearPp(60) === 0);
assert('fuel full bonus', fuelGearPp(90) === 3);
assert('catalog under threshold negative', catalogStatGearPp(20, 40) === -2);
assert('S drug quality +12', weightedDrugQualityPp([{ quality: 'S', quantity: 80 }]) === 12);
assert(
  'mixed drug quality weighted',
  Math.abs(weightedDrugQualityPp([{ quality: 'S', quantity: 100 }, { quality: 'B', quantity: 50 }]) - (1200 + 200) / 150) < 0.01
);

const chance = clampMissionSuccessChance(0.62 + 0.4);
assert('success chance clamps at 95%', chance === 0.95);
assert('success chance floor 20%', clampMissionSuccessChance(0.05) === 0.2);

assert('consume ammo is spend not wear', parseMissionRequirements(JSON.stringify([{ kind: 'ammo', quantity: 80, ammoType: '9mm' }]))[0].kind === 'ammo');
assert('weapon wear kind', parseMissionRequirements(JSON.stringify([{ kind: 'weapon', quantity: 1, weaponType: 'handgun' }]))[0].kind === 'weapon');

if (failed) {
  console.error(`\n${failed} assertion(s) failed`);
  process.exit(1);
}
console.log('\ncrew mission storage requirement tests passed');
