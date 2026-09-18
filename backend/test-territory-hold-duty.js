'use strict';

function holdIncomePercentForStreak(missStreak, miss1Percent = 50, miss2Percent = 0) {
  const streak = Math.max(0, Math.floor(Number(missStreak) || 0));
  if (streak >= 2) return Math.max(0, Math.min(100, Math.floor(Number(miss2Percent) || 0)));
  if (streak >= 1) return Math.max(0, Math.min(100, Math.floor(Number(miss1Percent) || 0)));
  return 100;
}

function applyHoldIncomeMultiplier(amount, percent) {
  const clamped = Math.max(0, Math.min(100, Math.floor(Number(percent) || 0)));
  if (clamped >= 100) return Math.max(0, Math.round(amount));
  if (clamped <= 0) return 0;
  return Math.max(0, Math.round(amount * (clamped / 100)));
}

function assertEqual(actual, expected, label) {
  if (actual !== expected) {
    throw new Error(`${label}: expected ${expected}, got ${actual}`);
  }
}

assertEqual(holdIncomePercentForStreak(0, 50, 0), 100, 'fresh hold pays 100%');
assertEqual(holdIncomePercentForStreak(1, 50, 0), 50, 'first miss pays 50%');
assertEqual(holdIncomePercentForStreak(2, 50, 0), 0, 'second miss pays 0%');
assertEqual(holdIncomePercentForStreak(9, 50, 0), 0, 'extra misses stay at 0%');
assertEqual(applyHoldIncomeMultiplier(140000, 50), 70000, 'tier-4 halved');
assertEqual(applyHoldIncomeMultiplier(25000, 0), 0, 'zeroed region');
assertEqual(applyHoldIncomeMultiplier(99, 50), 50, 'rounds half cents');

console.log('test-territory-hold-duty: ok');
