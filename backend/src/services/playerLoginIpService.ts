import prisma from '../lib/prisma';

export async function recordPlayerLoginIp(
  playerId: number,
  ip: string | null | undefined,
  previousIp?: string | null,
): Promise<void> {
  if (!ip || ip === previousIp) return;
  try {
    await prisma.player.update({
      where: { id: playerId },
      data: {
        lastLoginIp: ip,
        lastLoginIpAt: new Date(),
      },
    });
  } catch (error) {
    console.error('[Auth] Failed to store lastLoginIp', { playerId, error });
  }
}
