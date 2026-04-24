import prisma from '../lib/prisma';
import { applyVipTimeoutReductionMs, isVipStatusActive } from './vipBenefitsService';

const MAX_SESSIONS = 100;
const COOLDOWN_MS = 60 * 60 * 1000; // 1 hour
const MAX_BONUS = 0.08; // Up to +8% strength

function computeStrengthBonus(sessionsCompleted: number): number {
  const progress = Math.min(1, sessionsCompleted / MAX_SESSIONS);
  return Number((progress * MAX_BONUS).toFixed(4));
}

class GymService {
  async getStatus(playerId: number) {
    const [stats, player] = await Promise.all([
      prisma.gymStats.findUnique({
        where: { playerId },
      }),
      prisma.player.findUnique({
        where: { id: playerId },
        select: {
          isVip: true,
          vipExpiresAt: true,
        },
      }),
    ]);

    const sessionsCompleted = stats?.sessionsCompleted || 0;
    const strengthBonus = stats?.strengthBonus || 0;
    const lastTrainedAt = stats?.lastTrainedAt || null;
    const cooldownMs = applyVipTimeoutReductionMs(COOLDOWN_MS, isVipStatusActive(player));
    const nextTrainAt = lastTrainedAt ? new Date(lastTrainedAt.getTime() + cooldownMs) : null;
    const canTrain = !nextTrainAt || nextTrainAt.getTime() <= Date.now();

    return {
      sessionsCompleted,
      strengthBonus,
      lastTrainedAt,
      nextTrainAt,
      canTrain,
      maxSessions: MAX_SESSIONS,
      cooldownMs,
    };
  }

  async train(playerId: number) {
    const [stats, player] = await Promise.all([
      prisma.gymStats.findUnique({
        where: { playerId },
      }),
      prisma.player.findUnique({
        where: { id: playerId },
        select: {
          isVip: true,
          vipExpiresAt: true,
        },
      }),
    ]);

    const sessionsCompleted = stats?.sessionsCompleted || 0;
    if (sessionsCompleted >= MAX_SESSIONS) {
      return { success: false, error: 'MAX_SESSIONS' };
    }

    const cooldownMs = applyVipTimeoutReductionMs(COOLDOWN_MS, isVipStatusActive(player));

    if (stats?.lastTrainedAt) {
      const nextTrainAt = new Date(stats.lastTrainedAt.getTime() + cooldownMs);
      if (nextTrainAt.getTime() > Date.now()) {
        return { success: false, error: 'COOLDOWN', nextTrainAt };
      }
    }

    const newSessions = sessionsCompleted + 1;
    const newBonus = computeStrengthBonus(newSessions);

    const updated = await prisma.gymStats.upsert({
      where: { playerId },
      update: {
        sessionsCompleted: newSessions,
        strengthBonus: newBonus,
        lastTrainedAt: new Date(),
      },
      create: {
        playerId,
        sessionsCompleted: newSessions,
        strengthBonus: newBonus,
        lastTrainedAt: new Date(),
      },
    });

    return { success: true, stats: updated };
  }
}

export const gymService = new GymService();
