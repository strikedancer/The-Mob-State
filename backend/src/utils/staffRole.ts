export const PLAYER_STAFF_ROLES = ['NONE', 'MOD', 'OPS'] as const;

export type PlayerStaffRole = (typeof PLAYER_STAFF_ROLES)[number];

export function normalizeStaffRole(raw: unknown): PlayerStaffRole {
  const value = String(raw ?? 'NONE').trim().toUpperCase();
  if (value === 'MOD' || value === 'OPS') return value;
  return 'NONE';
}

export function isPlayerStaff(raw: unknown): raw is 'MOD' | 'OPS' {
  const value = normalizeStaffRole(raw);
  return value === 'MOD' || value === 'OPS';
}

export function asPlayerId(value: unknown): number | null {
  if (typeof value === 'bigint') {
    const n = Number(value);
    return Number.isSafeInteger(n) && n > 0 ? n : null;
  }
  if (typeof value === 'number') {
    return Number.isInteger(value) && value > 0 ? value : null;
  }
  const n = Number(value);
  return Number.isInteger(n) && n > 0 ? n : null;
}
