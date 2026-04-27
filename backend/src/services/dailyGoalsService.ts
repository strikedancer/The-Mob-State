import prisma from '../lib/prisma';
import { getRankFromXP } from '../config';
import { activityService } from './activityService';

export type DailyGoalKey = 'crime_3' | 'job_2' | 'vehicle_theft_1' | 'travel_1';

type DailyGoalDef = {
  key: DailyGoalKey;
  titleNl: string;
  titleEn: string;
  target: number;
  rewardCash: number;
  rewardXp: number;
};

const GOALS: DailyGoalDef[] = [
  {
    key: 'crime_3',
    titleNl: 'Doe 3 misdaden',
    titleEn: 'Do 3 crimes',
    target: 3,
    rewardCash: 750,
    rewardXp: 25,
  },
  {
    key: 'job_2',
    titleNl: 'Werk 2 keer',
    titleEn: 'Work 2 times',
    target: 2,
    rewardCash: 600,
    rewardXp: 20,
  },
  {
    key: 'vehicle_theft_1',
    titleNl: 'Steel 1 voertuig',
    titleEn: 'Steal 1 vehicle',
    target: 1,
    rewardCash: 900,
    rewardXp: 30,
  },
  {
    key: 'travel_1',
    titleNl: 'Maak 1 reis',
    titleEn: 'Complete 1 travel',
    target: 1,
    rewardCash: 500,
    rewardXp: 15,
  },
];

function startOfUtcDay(date: Date): Date {
  return new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), 0, 0, 0));
}

function dateKeyUtc(date: Date): string {
  const y = date.getUTCFullYear();
  const m = String(date.getUTCMonth() + 1).padStart(2, '0');
  const d = String(date.getUTCDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

async function computeProgress(playerId: number, from: Date): Promise<Record<DailyGoalKey, number>> {
  const [crimeCount, jobCount, vehicleTheftCount, travelCount] = await Promise.all([
    prisma.crimeAttempt.count({
      where: { playerId, createdAt: { gte: from }, NOT: { crimeId: 'police_arrest' } },
    }),
    prisma.jobAttempt.count({
      where: { playerId, completedAt: { gte: from } },
    }),
    prisma.playerActivity.count({
      where: { playerId, activityType: 'VEHICLE_THEFT', createdAt: { gte: from } },
    }),
    prisma.worldEvent.count({
      where: {
        playerId,
        createdAt: { gte: from },
        eventKey: { in: ['travel.arrived', 'travel.journey_complete'] },
      },
    }),
  ]);

  return {
    crime_3: crimeCount,
    job_2: jobCount,
    vehicle_theft_1: vehicleTheftCount,
    travel_1: travelCount,
  };
}

export const dailyGoalsService = {
  dateKeyUtc,

  async getDailyGoals(playerId: number) {
    const now = new Date();
    const from = startOfUtcDay(now);
    const key = dateKeyUtc(now);

    const [progress, claims] = await Promise.all([
      computeProgress(playerId, from),
      prisma.playerDailyGoalClaim.findMany({
        where: { playerId, dateKey: key },
        select: { goalKey: true },
      }),
    ]);

    const claimed = new Set(claims.map((c) => c.goalKey));

    const goals = GOALS.map((g) => {
      const current = progress[g.key] ?? 0;
      const claimable = current >= g.target && !claimed.has(g.key);
      return {
        key: g.key,
        titleNl: g.titleNl,
        titleEn: g.titleEn,
        progress: current,
        target: g.target,
        claimed: claimed.has(g.key),
        claimable,
        rewardCash: g.rewardCash,
        rewardXp: g.rewardXp,
      };
    });

    return { dateKey: key, goals };
  },

  async claimDailyGoal(playerId: number, goalKeyRaw: string) {
    const goalKey = goalKeyRaw as DailyGoalKey;
    const def = GOALS.find((g) => g.key === goalKey);
    if (!def) {
      const err = new Error('INVALID_GOAL');
      // @ts-expect-error tag
      err.code = 'INVALID_GOAL';
      throw err;
    }

    const now = new Date();
    const from = startOfUtcDay(now);
    const key = dateKeyUtc(now);
    const progress = await computeProgress(playerId, from);
    const current = progress[goalKey] ?? 0;
    if (current < def.target) {
      const err = new Error('NOT_COMPLETE');
      // @ts-expect-error tag
      err.code = 'NOT_COMPLETE';
      throw err;
    }

    return await prisma.$transaction(async (tx) => {
      const existing = await tx.playerDailyGoalClaim.findFirst({
        where: { playerId, dateKey: key, goalKey },
        select: { id: true },
      });
      if (existing) {
        const err = new Error('ALREADY_CLAIMED');
        // @ts-expect-error tag
        err.code = 'ALREADY_CLAIMED';
        throw err;
      }

      await tx.playerDailyGoalClaim.create({
        data: { playerId, dateKey: key, goalKey },
      });

      const player = await tx.player.findUnique({
        where: { id: playerId },
        select: { id: true, money: true, xp: true, rank: true },
      });
      if (!player) {
        const err = new Error('PLAYER_NOT_FOUND');
        // @ts-expect-error tag
        err.code = 'PLAYER_NOT_FOUND';
        throw err;
      }

      const newXp = player.xp + def.rewardXp;
      const newRank = getRankFromXP(newXp);

      const updated = await tx.player.update({
        where: { id: playerId },
        data: {
          money: { increment: def.rewardCash },
          xp: { increment: def.rewardXp },
          rank: newRank,
        },
        select: { money: true, xp: true, rank: true },
      });

      // Best-effort activity log (outside tx would be fine, but keep it simple)
      await activityService.logActivity(
        playerId,
        'DAILY_GOAL_CLAIM',
        `Claimed daily goal ${goalKey}`,
        {
          dateKey: key,
          goalKey,
          rewardCash: def.rewardCash,
          rewardXp: def.rewardXp,
          newMoney: updated.money,
          newXp: updated.xp,
          newRank: updated.rank,
        },
        false
      );

      return {
        dateKey: key,
        goalKey,
        rewardCash: def.rewardCash,
        rewardXp: def.rewardXp,
        money: updated.money,
        xp: updated.xp,
        rank: updated.rank,
      };
    });
  },
};

