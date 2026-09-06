/** Crime-success penalty from low HP. Hospital is the paid reset; ticks heal slowly. */
export type HealthInjuryBand =
  | 'healthy'
  | 'wounded'
  | 'hurt'
  | 'critical'
  | 'down';

export const HEALTH_INJURY = {
  woundedBelow: 70,
  hurtBelow: 40,
  criticalBelow: 20,
  emergencyBelow: 10,
  woundedPenalty: 0.04,
  hurtPenalty: 0.08,
  criticalPenalty: 0.12,
} as const;

export function healthInjuryBand(health: number): HealthInjuryBand {
  if (health <= 0) return 'down';
  if (health < HEALTH_INJURY.criticalBelow) return 'critical';
  if (health < HEALTH_INJURY.hurtBelow) return 'hurt';
  if (health < HEALTH_INJURY.woundedBelow) return 'wounded';
  return 'healthy';
}

export function crimeSuccessPenaltyFromHealth(health: number): number {
  switch (healthInjuryBand(health)) {
    case 'wounded':
      return HEALTH_INJURY.woundedPenalty;
    case 'hurt':
      return HEALTH_INJURY.hurtPenalty;
    case 'critical':
      return HEALTH_INJURY.criticalPenalty;
    default:
      return 0;
  }
}

export function crimeSuccessPenaltyPercent(health: number): number {
  return Math.round(crimeSuccessPenaltyFromHealth(health) * 100);
}

export function hospitalInjuryRules() {
  return {
    woundedBelow: HEALTH_INJURY.woundedBelow,
    hurtBelow: HEALTH_INJURY.hurtBelow,
    criticalBelow: HEALTH_INJURY.criticalBelow,
    emergencyBelow: HEALTH_INJURY.emergencyBelow,
    penalties: {
      wounded: Math.round(HEALTH_INJURY.woundedPenalty * 100),
      hurt: Math.round(HEALTH_INJURY.hurtPenalty * 100),
      critical: Math.round(HEALTH_INJURY.criticalPenalty * 100),
    },
  };
}
