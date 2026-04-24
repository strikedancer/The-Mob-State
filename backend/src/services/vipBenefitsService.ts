import prisma from '../lib/prisma';

export const VIP_TIMEOUT_REDUCTION_PERCENT = 10;
const VIP_TIMEOUT_MULTIPLIER = (100 - VIP_TIMEOUT_REDUCTION_PERCENT) / 100;

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
