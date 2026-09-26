import prisma from '../lib/prisma';
import { applyVipTimeoutReductionMs, isVipStatusActive } from './vipBenefitsService';
import { checkIfJailed } from './policeService';

const MAX_SESSIONS = 100;
const COOLDOWN_MS = 60 * 60 * 1000; // 1 hour
const MAX_BONUS = 0.1; // Up to +10% accuracy
const DEFAULT_TRAIN_COST = 750;

async function getRuntimeConfig(keys: string[]): Promise<Record<string, string>> {
  if (keys.length === 0) return {};
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...keys,
  );
  return rows.reduce<Record<string, string>>((acc, row) => {
    acc[row.configKey] = row.configValue;
    return acc;
  }, {});
}

async function getShootingRangeTrainCost(): Promise<number> {
  const cfg = await getRuntimeConfig(['SHOOTING_RANGE_TRAIN_COST']);
  const raw = Number(cfg.SHOOTING_RANGE_TRAIN_COST ?? DEFAULT_TRAIN_COST);
  return Math.max(0, Math.floor(Number.isFinite(raw) ? raw : DEFAULT_TRAIN_COST));
}

function computeAccuracyBonus(sessionsCompleted: number): number {
  const progress = Math.min(1, sessionsCompleted / MAX_SESSIONS);
  return Number((progress * MAX_BONUS).toFixed(4));
}

class ShootingRangeService {
  async getStatus(playerId: number) {
    const [stats, player] = await Promise.all([
      prisma.shootingRangeStats.findUnique({
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
    const accuracyBonus = stats?.accuracyBonus || 0;
    const lastTrainedAt = stats?.lastTrainedAt || null;
    const cooldownMs = applyVipTimeoutReductionMs(COOLDOWN_MS, isVipStatusActive(player));
    const nextTrainAt = lastTrainedAt ? new Date(lastTrainedAt.getTime() + cooldownMs) : null;
    const remainingJailTime = await checkIfJailed(playerId);
    const canTrain =
      remainingJailTime <= 0 && (!nextTrainAt || nextTrainAt.getTime() <= Date.now());

    const hitlistAccuracy = Number(
      Math.min(0.9, 0.5 + (sessionsCompleted / MAX_SESSIONS) * 0.4).toFixed(4),
    );

    const trainCost = await getShootingRangeTrainCost();

    return {
      sessionsCompleted,
      accuracyBonus,
      hitlistAccuracy,
      lastTrainedAt,
      nextTrainAt,
      canTrain,
      jailed: remainingJailTime > 0,
      jailTimeRemaining: remainingJailTime,
      trainCost,
    };
  }

  async train(playerId: number) {
    const remainingJailTime = await checkIfJailed(playerId);
    if (remainingJailTime > 0) {
      return { success: false as const, error: 'JAILED' as const, remainingTime: remainingJailTime };
    }

    const [stats, player] = await Promise.all([
      prisma.shootingRangeStats.findUnique({
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

    const trainCost = await getShootingRangeTrainCost();
    const newSessions = sessionsCompleted + 1;
    const newBonus = computeAccuracyBonus(newSessions);
    const trainedAt = new Date();

    try {
      const updated = await prisma.$transaction(async (tx) => {
        if (trainCost > 0) {
          const charged = await tx.player.updateMany({
            where: { id: playerId, money: { gte: trainCost } },
            data: { money: { decrement: trainCost } },
          });
          if (charged.count === 0) {
            throw new Error('INSUFFICIENT_FUNDS');
          }
        }

        return tx.shootingRangeStats.upsert({
          where: { playerId },
          update: {
            sessionsCompleted: newSessions,
            accuracyBonus: newBonus,
            lastTrainedAt: trainedAt,
          },
          create: {
            playerId,
            sessionsCompleted: newSessions,
            accuracyBonus: newBonus,
            lastTrainedAt: trainedAt,
          },
        });
      });

      return { success: true, stats: updated, trainCost };
    } catch (err) {
      if (err instanceof Error && err.message === 'INSUFFICIENT_FUNDS') {
        return { success: false as const, error: 'INSUFFICIENT_FUNDS' as const, trainCost };
      }
      throw err;
    }
  }
}

export const shootingRangeService = new ShootingRangeService();
