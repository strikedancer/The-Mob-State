import prisma from '../lib/prisma';
import { applyVipTimeoutReductionMs, isVipStatusActive } from './vipBenefitsService';

export type GymTrainTrack = 'strength' | 'speed' | 'stamina';

const MAX_SESSIONS = 100;
const COOLDOWN_MS = 60 * 60 * 1000; // 1 hour
const STRENGTH_CAP = 0.04;
const SPEED_CAP = 0.02;
const STAMINA_CAP = 0.02;
const DEFAULT_TRAIN_COST = 500;

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

async function getGymTrainCost(): Promise<number> {
  const cfg = await getRuntimeConfig(['GYM_TRAIN_COST']);
  const raw = Number(cfg.GYM_TRAIN_COST ?? DEFAULT_TRAIN_COST);
  return Math.max(0, Math.floor(Number.isFinite(raw) ? raw : DEFAULT_TRAIN_COST));
}

/** Max aggregate crime success bonus from all gym tracks (+8%). */
export function computeAggregateGymBonus(
  strengthSessions: number,
  speedSessions: number,
  staminaSessions: number,
): number {
  const s = Math.min(1, Math.max(0, strengthSessions) / MAX_SESSIONS) * STRENGTH_CAP;
  const sp = Math.min(1, Math.max(0, speedSessions) / MAX_SESSIONS) * SPEED_CAP;
  const st = Math.min(1, Math.max(0, staminaSessions) / MAX_SESSIONS) * STAMINA_CAP;
  return Number((s + sp + st).toFixed(4));
}

export function latestGymTrainAt(stats: {
  lastTrainedAt: Date | null;
  speedLastTrainedAt: Date | null;
  staminaLastTrainedAt: Date | null;
}): Date | null {
  const times = [stats.lastTrainedAt, stats.speedLastTrainedAt, stats.staminaLastTrainedAt].filter(
    (d): d is Date => d instanceof Date && !Number.isNaN(d.getTime()),
  );
  if (times.length === 0) return null;
  return new Date(Math.max(...times.map((t) => t.getTime())));
}

function trackNextTrainAt(
  sessions: number,
  lastAt: Date | null | undefined,
  cooldownMs: number,
): Date | null {
  if (sessions >= MAX_SESSIONS) return null;
  if (!lastAt) return null;
  return new Date(lastAt.getTime() + cooldownMs);
}

function trackCanTrain(
  sessions: number,
  lastAt: Date | null | undefined,
  cooldownMs: number,
): boolean {
  if (sessions >= MAX_SESSIONS) return false;
  if (!lastAt) return true;
  return lastAt.getTime() + cooldownMs <= Date.now();
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

    const strengthSessions = stats?.sessionsCompleted ?? 0;
    const speedSessions = stats?.speedSessionsCompleted ?? 0;
    const staminaSessions = stats?.staminaSessionsCompleted ?? 0;
    const strengthBonus = computeAggregateGymBonus(strengthSessions, speedSessions, staminaSessions);
    const lastTrainedAt = stats?.lastTrainedAt ?? null;
    const speedLastTrainedAt = stats?.speedLastTrainedAt ?? null;
    const staminaLastTrainedAt = stats?.staminaLastTrainedAt ?? null;

    const cooldownMs = applyVipTimeoutReductionMs(COOLDOWN_MS, isVipStatusActive(player));

    const strNext = trackNextTrainAt(strengthSessions, lastTrainedAt, cooldownMs);
    const spdNext = trackNextTrainAt(speedSessions, speedLastTrainedAt, cooldownMs);
    const staNext = trackNextTrainAt(staminaSessions, staminaLastTrainedAt, cooldownMs);

    const canTrainStrength = trackCanTrain(strengthSessions, lastTrainedAt, cooldownMs);
    const canTrainSpeed = trackCanTrain(speedSessions, speedLastTrainedAt, cooldownMs);
    const canTrainStamina = trackCanTrain(staminaSessions, staminaLastTrainedAt, cooldownMs);
    const canTrain = canTrainStrength || canTrainSpeed || canTrainStamina;

    const strengthTrackBonus = Number(
      (Math.min(1, strengthSessions / MAX_SESSIONS) * STRENGTH_CAP).toFixed(4),
    );
    const speedTrackBonus = Number(
      (Math.min(1, speedSessions / MAX_SESSIONS) * SPEED_CAP).toFixed(4),
    );
    const staminaTrackBonus = Number(
      (Math.min(1, staminaSessions / MAX_SESSIONS) * STAMINA_CAP).toFixed(4),
    );

    const trainCost = await getGymTrainCost();

    return {
      sessionsCompleted: strengthSessions,
      speedSessionsCompleted: speedSessions,
      staminaSessionsCompleted: staminaSessions,
      strengthBonus,
      strengthTrackBonus,
      speedTrackBonus,
      staminaTrackBonus,
      lastTrainedAt,
      speedLastTrainedAt,
      staminaLastTrainedAt,
      nextTrainAt: strNext,
      nextTrainAtStrength: strNext,
      nextTrainAtSpeed: spdNext,
      nextTrainAtStamina: staNext,
      canTrain,
      canTrainStrength,
      canTrainSpeed,
      canTrainStamina,
      maxSessions: MAX_SESSIONS,
      cooldownMs,
      trainCost,
      gymLastTrainedAt: latestGymTrainAt({
        lastTrainedAt,
        speedLastTrainedAt,
        staminaLastTrainedAt,
      }),
    };
  }

  /**
   * @param track strength | speed | stamina — separate cooldown and 100-session cap per track.
   */
  async train(playerId: number, track: GymTrainTrack = 'strength') {
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

    const cooldownMs = applyVipTimeoutReductionMs(COOLDOWN_MS, isVipStatusActive(player));
    const now = new Date();

    const strengthSessions = stats?.sessionsCompleted ?? 0;
    const speedSessions = stats?.speedSessionsCompleted ?? 0;
    const staminaSessions = stats?.staminaSessionsCompleted ?? 0;

    const pick = (): {
      key: 'sessionsCompleted' | 'speedSessionsCompleted' | 'staminaSessionsCompleted';
      lastKey: 'lastTrainedAt' | 'speedLastTrainedAt' | 'staminaLastTrainedAt';
      sessions: number;
      lastAt: Date | null;
    } => {
      if (track === 'speed') {
        return {
          key: 'speedSessionsCompleted',
          lastKey: 'speedLastTrainedAt',
          sessions: speedSessions,
          lastAt: stats?.speedLastTrainedAt ?? null,
        };
      }
      if (track === 'stamina') {
        return {
          key: 'staminaSessionsCompleted',
          lastKey: 'staminaLastTrainedAt',
          sessions: staminaSessions,
          lastAt: stats?.staminaLastTrainedAt ?? null,
        };
      }
      return {
        key: 'sessionsCompleted',
        lastKey: 'lastTrainedAt',
        sessions: strengthSessions,
        lastAt: stats?.lastTrainedAt ?? null,
      };
    };

    const { key, lastKey, sessions, lastAt } = pick();

    if (sessions >= MAX_SESSIONS) {
      return { success: false as const, error: 'MAX_SESSIONS' as const, track };
    }

    if (lastAt) {
      const nextTrainAt = new Date(lastAt.getTime() + cooldownMs);
      if (nextTrainAt.getTime() > Date.now()) {
        return { success: false as const, error: 'COOLDOWN' as const, nextTrainAt, track };
      }
    }

    const trainCost = await getGymTrainCost();
    const newSessions = sessions + 1;
    const nextStrength =
      key === 'sessionsCompleted' ? newSessions : strengthSessions;
    const nextSpeed = key === 'speedSessionsCompleted' ? newSessions : speedSessions;
    const nextStamina = key === 'staminaSessionsCompleted' ? newSessions : staminaSessions;
    const newBonus = computeAggregateGymBonus(nextStrength, nextSpeed, nextStamina);

    const baseUpdate = {
      strengthBonus: newBonus,
      sessionsCompleted: nextStrength,
      speedSessionsCompleted: nextSpeed,
      staminaSessionsCompleted: nextStamina,
    };
    const stamp =
      lastKey === 'lastTrainedAt'
        ? { lastTrainedAt: now }
        : lastKey === 'speedLastTrainedAt'
          ? { speedLastTrainedAt: now }
          : { staminaLastTrainedAt: now };

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

        return tx.gymStats.upsert({
          where: { playerId },
          update: { ...baseUpdate, ...stamp },
          create: {
            playerId,
            sessionsCompleted: nextStrength,
            speedSessionsCompleted: nextSpeed,
            staminaSessionsCompleted: nextStamina,
            strengthBonus: newBonus,
            lastTrainedAt: lastKey === 'lastTrainedAt' ? now : null,
            speedLastTrainedAt: lastKey === 'speedLastTrainedAt' ? now : null,
            staminaLastTrainedAt: lastKey === 'staminaLastTrainedAt' ? now : null,
          },
        });
      });

      return { success: true as const, stats: updated, track, trainCost };
    } catch (err) {
      if (err instanceof Error && err.message === 'INSUFFICIENT_FUNDS') {
        return {
          success: false as const,
          error: 'INSUFFICIENT_FUNDS' as const,
          trainCost,
          track,
        };
      }
      throw err;
    }
  }
}

export const gymService = new GymService();
