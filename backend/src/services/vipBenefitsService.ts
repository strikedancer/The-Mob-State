import prisma from '../lib/prisma';

export const VIP_TIMEOUT_REDUCTION_PERCENT = 10;
const VIP_TIMEOUT_MULTIPLIER = (100 - VIP_TIMEOUT_REDUCTION_PERCENT) / 100;

/** Display-only prestige tiers from cumulative VIP days granted. */
export const VIP_PRESTIGE_THRESHOLDS = {
  bronze: 30,
  silver: 180,
  gold: 365,
} as const;

export type VipPrestigeTier = 'none' | 'bronze' | 'silver' | 'gold';

export type VipStatusLike = {
  isVip?: boolean | null;
  vipExpiresAt?: Date | null;
};

export function isVipStatusActive(
  status: VipStatusLike | null | undefined,
  now: Date = new Date()
): boolean {
  if (!status?.isVip) {
    return false;
  }

  if (!status.vipExpiresAt) {
    return true;
  }

  return status.vipExpiresAt.getTime() > now.getTime();
}

export function getVipPrestigeTier(lifetimeDays: number): VipPrestigeTier {
  const days = Math.max(0, Math.floor(Number(lifetimeDays) || 0));
  if (days >= VIP_PRESTIGE_THRESHOLDS.gold) return 'gold';
  if (days >= VIP_PRESTIGE_THRESHOLDS.silver) return 'silver';
  if (days >= VIP_PRESTIGE_THRESHOLDS.bronze) return 'bronze';
  return 'none';
}

export function applyVipTimeoutReductionSeconds(seconds: number, vipActive: boolean): number {
  const safeSeconds = Math.max(0, Math.floor(Number(seconds) || 0));
  if (!vipActive || safeSeconds <= 0) {
    return safeSeconds;
  }

  return Math.max(1, Math.ceil(safeSeconds * VIP_TIMEOUT_MULTIPLIER));
}

export function applyVipTimeoutReductionMs(milliseconds: number, vipActive: boolean): number {
  const safeMs = Math.max(0, Math.floor(Number(milliseconds) || 0));
  if (!vipActive || safeMs <= 0) {
    return safeMs;
  }

  return Math.max(1000, Math.ceil(safeMs * VIP_TIMEOUT_MULTIPLIER));
}

export async function getPlayerVipTimeoutStatus(playerId: number): Promise<boolean> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: {
      isVip: true,
      vipExpiresAt: true,
    },
  });

  return isVipStatusActive(player);
}

export function extendVipExpiryDate(current: Date | null | undefined, days = 30, now = new Date()): Date {
  const safeDays = Math.max(1, Math.floor(days));
  const base = current && current > now ? current : now;
  return new Date(base.getTime() + safeDays * 24 * 60 * 60 * 1000);
}

export async function grantPlayerVipDays(
  playerId: number,
  days: number,
  options?: { mollieSubscriptionId?: string | null },
): Promise<{ vipExpiresAt: Date; vipLifetimeDays: number }> {
  const safeDays = Math.max(1, Math.floor(days));
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { vipExpiresAt: true, vipLifetimeDays: true },
  });
  if (!player) {
    throw new Error('PLAYER_NOT_FOUND');
  }

  const vipExpiresAt = extendVipExpiryDate(player.vipExpiresAt, safeDays);
  const data: {
    isVip: boolean;
    vipExpiresAt: Date;
    vipLifetimeDays: { increment: number };
    mollieSubscriptionId?: string;
  } = {
    isVip: true,
    vipExpiresAt,
    vipLifetimeDays: { increment: safeDays },
  };
  if (options?.mollieSubscriptionId) {
    data.mollieSubscriptionId = options.mollieSubscriptionId;
  }

  const updated = await prisma.player.update({
    where: { id: playerId },
    data,
    select: { vipExpiresAt: true, vipLifetimeDays: true },
  });

  return {
    vipExpiresAt: updated.vipExpiresAt!,
    vipLifetimeDays: updated.vipLifetimeDays,
  };
}

export async function grantCrewVipDays(
  crewId: number,
  days: number,
  options?: { mollieSubscriptionId?: string | null },
): Promise<{ vipExpiresAt: Date; vipLifetimeDays: number }> {
  const safeDays = Math.max(1, Math.floor(days));
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { vipExpiresAt: true, vipLifetimeDays: true },
  });
  if (!crew) {
    throw new Error('CREW_NOT_FOUND');
  }

  const vipExpiresAt = extendVipExpiryDate(crew.vipExpiresAt, safeDays);
  const data: {
    isVip: boolean;
    vipExpiresAt: Date;
    vipLifetimeDays: { increment: number };
    mollieSubscriptionId?: string;
  } = {
    isVip: true,
    vipExpiresAt,
    vipLifetimeDays: { increment: safeDays },
  };
  if (options?.mollieSubscriptionId) {
    data.mollieSubscriptionId = options.mollieSubscriptionId;
  }

  const updated = await prisma.crew.update({
    where: { id: crewId },
    data,
    select: { vipExpiresAt: true, vipLifetimeDays: true },
  });

  return {
    vipExpiresAt: updated.vipExpiresAt!,
    vipLifetimeDays: updated.vipLifetimeDays,
  };
}

const MAX_NON_VIP_BUILDING_LEVEL = 10;

export async function downgradeCrewAfterVipExpiry(crewId: number): Promise<void> {
  await prisma.$transaction(async (tx) => {
    await tx.crewHqBuilding.updateMany({
      where: { crewId },
      data: { style: 'villa', level: 3 },
    });

    await Promise.all([
      tx.crewCarStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewBoatStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewWeaponStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewAmmoStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewDrugStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
      tx.crewCashStorageBuilding.updateMany({
        where: { crewId, level: { gt: MAX_NON_VIP_BUILDING_LEVEL } },
        data: { level: MAX_NON_VIP_BUILDING_LEVEL },
      }),
    ]);
  });
}

export async function expireStaleVipFlags(limit = 200): Promise<{ players: number; crews: number }> {
  const now = new Date();
  const playerResult = await prisma.player.updateMany({
    where: {
      isVip: true,
      vipExpiresAt: { not: null, lt: now },
    },
    data: { isVip: false },
  });

  const expiredCrews = await prisma.crew.findMany({
    where: {
      isVip: true,
      vipExpiresAt: { not: null, lt: now },
    },
    select: { id: true },
    take: Math.max(1, Math.min(500, limit)),
  });

  for (const crew of expiredCrews) {
    await prisma.crew.update({
      where: { id: crew.id },
      data: { isVip: false },
    });
    await downgradeCrewAfterVipExpiry(crew.id);
  }

  return { players: playerResult.count, crews: expiredCrews.length };
}
