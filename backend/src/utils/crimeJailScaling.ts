/**
 * Scale crime jail sentences for early-game ranks and petty crimes.
 * JSON jailTime values assume mid/late game; rank 1–5 street crimes should hurt less.
 */
export function scaleCrimeJailMinutes(
  baseMinutes: number,
  playerRank: number,
  crimeMinLevel: number,
): number {
  if (baseMinutes <= 0) {
    return 0;
  }

  let multiplier = 1;

  if (playerRank <= 5) {
    multiplier = 0.35 + playerRank * 0.08;
  } else if (playerRank <= 12) {
    multiplier = 0.85 + (playerRank - 5) * 0.02;
  }

  if (crimeMinLevel <= 3) {
    multiplier *= 0.75;
  } else if (crimeMinLevel <= 7) {
    multiplier *= 0.9;
  }

  const scaled = Math.round(baseMinutes * multiplier);
  return Math.max(2, Math.min(baseMinutes, scaled));
}

/** Wanted-level bump on failed crime — softer early ranks. */
export function crimeFailWantedIncrease(playerRank: number, configuredAmount: number): number {
  if (playerRank <= 5) {
    return Math.min(configuredAmount, 1);
  }
  if (playerRank <= 10) {
    return Math.min(configuredAmount, 3);
  }
  return configuredAmount;
}
