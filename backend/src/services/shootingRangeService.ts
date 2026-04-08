import prisma from '../lib/prisma';

const MAX_SESSIONS = 100;
const COOLDOWN_MS = 60 * 60 * 1000; // 1 hour
const MAX_BONUS = 0.1; // Up to +10% accuracy

function computeAccuracyBonus(sessionsCompleted: number): number {
  const progress = Math.min(1, sessionsCompleted / MAX_SESSIONS);
  return Number((progress * MAX_BONUS).toFixed(4));
}

class ShootingRangeService {
  async getStatus(playerId: number) {
    const stats = await prisma.shootingRangeStats.findUnique({
      where: { playerId },
    });

    const sessionsCompleted = stats?.sessionsCompleted || 0;
    const accuracyBonus = stats?.accuracyBonus || 0;
    const lastTrainedAt = stats?.lastTrainedAt || null;
    const nextTrainAt = lastTrainedAt
      ? new Date(lastTrainedAt.getTime() + COOLDOWN_MS)
      : null;
    const canTrain = !nextTrainAt || nextTrainAt.getTime() <= Date.now();

    return {
      sessionsCompleted,
      accuracyBonus,
      lastTrainedAt,
      nextTrainAt,
      canTrain,
    };
  }

  async train(playerId: number) {
    const stats = await prisma.shootingRangeStats.findUnique({
      where: { playerId },
    });

    const sessionsCompleted = stats?.sessionsCompleted || 0;
    if (sessionsCompleted >= MAX_SESSIONS) {
      return { success: false, error: 'MAX_SESSIONS' };
    }

    if (stats?.lastTrainedAt) {
      const nextTrainAt = new Date(stats.lastTrainedAt.getTime() + COOLDOWN_MS);
      if (nextTrainAt.getTime() > Date.now()) {
        return { success: false, error: 'COOLDOWN', nextTrainAt };
      }
    }

    const newSessions = sessionsCompleted + 1;
    const newBonus = computeAccuracyBonus(newSessions);

    const updated = await prisma.shootingRangeStats.upsert({
      where: { playerId },
      update: {
        sessionsCompleted: newSessions,
        accuracyBonus: newBonus,
        lastTrainedAt: new Date(),
      },
      create: {
        playerId,
        sessionsCompleted: newSessions,
        accuracyBonus: newBonus,
        lastTrainedAt: new Date(),
      },
    });

    return { success: true, stats: updated };
  }
}

export const shootingRangeService = new ShootingRangeService();
