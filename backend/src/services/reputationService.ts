import prisma from '../lib/prisma';
import { calculateReputationChange } from '../utils/rankSystem';

export async function applyReputationDelta(
  playerId: number,
  delta: number,
): Promise<number> {
  if (delta !== 0) {
    await prisma.$executeRaw`
      UPDATE players
      SET reputation = GREATEST(0, reputation + ${delta})
      WHERE id = ${playerId}
    `;
  }

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { reputation: true },
  });

  return player?.reputation ?? 0;
}

export async function applyReputationAction(
  playerId: number,
  action: string,
  success: boolean,
  extraDelta = 0,
): Promise<number> {
  const baseDelta = calculateReputationChange(action, success);
  return applyReputationDelta(playerId, baseDelta + extraDelta);
}
