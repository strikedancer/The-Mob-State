/** Reward-tier wear/fuel multipliers for crimes (burglary light, bank heavy). */
export function crimeVehicleWearProfile(maxReward: number): {
  wearMult: number;
  fuelMult: number;
} {
  if (maxReward >= 100_000) return { wearMult: 2.0, fuelMult: 1.6 };
  if (maxReward >= 50_000) return { wearMult: 1.75, fuelMult: 1.45 };
  if (maxReward >= 15_000) return { wearMult: 1.35, fuelMult: 1.2 };
  if (maxReward >= 5_000) return { wearMult: 1.1, fuelMult: 1.05 };
  if (maxReward >= 1_500) return { wearMult: 0.85, fuelMult: 0.9 };
  return { wearMult: 0.7, fuelMult: 0.8 };
}

/** Crew heist getaway wear by difficulty tier. */
export function heistVehicleWearProfile(
  difficulty: string,
  basePayout: number,
): { wearMult: number; fuelMult: number } {
  const byDiff: Record<string, { wearMult: number; fuelMult: number }> = {
    easy: { wearMult: 0.9, fuelMult: 0.85 },
    medium: { wearMult: 1.2, fuelMult: 1.1 },
    hard: { wearMult: 1.5, fuelMult: 1.25 },
    very_hard: { wearMult: 1.75, fuelMult: 1.4 },
    extreme: { wearMult: 2.0, fuelMult: 1.55 },
    legendary: { wearMult: 2.3, fuelMult: 1.7 },
  };
  return byDiff[difficulty] ?? crimeVehicleWearProfile(basePayout);
}

export function computeVehicleConditionLoss(
  vehicleSpeed: number,
  wearMult: number,
): number {
  const baseWear = (1 + Math.random() * 4) * wearMult;
  const speedWear = (vehicleSpeed / 100) * 2 * wearMult;
  return Math.ceil(baseWear + speedWear);
}

export function computeVehicleFuelUse(fuelMult: number): number {
  return Math.floor((10 + Math.random() * 20) * fuelMult);
}
