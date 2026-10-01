/**
 * Vehicle-theft wanted / arrest math.
 * Wanted is 0–100 (same as crimes). Do not cap at 5 — that leftover star-scale
 * made checkArrest almost never fire after a steal.
 */

export function vehicleTheftWantedBump(success: boolean, baseValue: number): number {
  if (success) {
    return 1;
  }
  if (baseValue < 10_000) return 3;
  if (baseValue < 30_000) return 4;
  if (baseValue < 75_000) return 6;
  if (baseValue < 150_000) return 8;
  if (baseValue < 500_000) return 11;
  return 13;
}

/** Chance that a failed steal becomes jail (not only “gesnapt, walk away”). */
export function vehicleTheftFailCatchChance(
  successChance: number,
  heatPenalty: number,
  patternPenalty: number
): number {
  const difficulty = Math.max(0, Math.min(1, 1 - successChance));
  return Math.min(0.55, 0.2 + difficulty * 0.32 + Math.max(0, heatPenalty) + Math.max(0, patternPenalty));
}

export function vehicleTheftFailJailMinutes(baseValue: number, wantedLevel: number): number {
  const fromValue = baseValue < 30_000 ? 12 : baseValue < 150_000 ? 22 : baseValue < 500_000 ? 32 : 38;
  return Math.max(10, Math.min(50, Math.max(fromValue, wantedLevel * 5)));
}

export function capWantedLevel(current: number, bump: number): number {
  return Math.min(100, Math.max(0, Math.round(current) + bump));
}
