/**
 * Training "combo-readiness" (plan: gym + shooting same UTC calendar day) —
 * small extra crime success chance, server-authoritative.
 * @see docs/module-protocols/balance-economy.md
 */
export const TRAINING_COMBO_READINESS_BONUS = 0.005; // +0.5% crime success when both tracks trained same UTC day

function isUtcCalendarDay(date: Date, ref: Date): boolean {
  return (
    date.getUTCFullYear() === ref.getUTCFullYear() &&
    date.getUTCMonth() === ref.getUTCMonth() &&
    date.getUTCDate() === ref.getUTCDate()
  );
}

export function isTrainingComboReadinessActive(
  gymLastTrainedAt: Date | null | undefined,
  shootingLastTrainedAt: Date | null | undefined,
  now: Date = new Date(),
): boolean {
  if (!gymLastTrainedAt || !shootingLastTrainedAt) return false;
  return (
    isUtcCalendarDay(gymLastTrainedAt, now) &&
    isUtcCalendarDay(shootingLastTrainedAt, now)
  );
}

export function getTrainingComboReadinessPayload(
  gymLastTrainedAt: Date | null | undefined,
  shootingLastTrainedAt: Date | null | undefined,
  now: Date = new Date(),
): { active: boolean; bonusFraction: number } {
  const active = isTrainingComboReadinessActive(
    gymLastTrainedAt,
    shootingLastTrainedAt,
    now,
  );
  return {
    active,
    bonusFraction: active ? TRAINING_COMBO_READINESS_BONUS : 0,
  };
}
