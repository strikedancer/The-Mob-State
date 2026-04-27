import prisma from '../lib/prisma';
import { getRankFromXP } from '../config';
import { activityService } from './activityService';

export type DailyGoalKey =
  | 'crime_3'
  | 'job_2'
  | 'vehicle_theft_1'
  | 'travel_1'
  | 'weekly_crime_20'
  | 'weekly_job_10'
  | 'weekly_vehicle_theft_5'
  | 'weekly_travel_3';

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
  {
    key: 'weekly_crime_20',
    titleNl: 'Weekdoel: 20 misdaden',
    titleEn: 'Weekly: 20 crimes',
    target: 20,
    rewardCash: 5000,
    rewardXp: 120,
  },
  {
    key: 'weekly_job_10',
    titleNl: 'Weekdoel: 10x werken',
    titleEn: 'Weekly: work 10 times',
    target: 10,
    rewardCash: 3500,
    rewardXp: 90,
  },
  {
    key: 'weekly_vehicle_theft_5',
    titleNl: 'Weekdoel: 5 voertuigen stelen',
    titleEn: 'Weekly: steal 5 vehicles',
    target: 5,
    rewardCash: 6000,
    rewardXp: 150,
  },
  {
    key: 'weekly_travel_3',
    titleNl: 'Weekdoel: 3 reizen',
    titleEn: 'Weekly: 3 travels',
    target: 3,
    rewardCash: 2500,
    rewardXp: 60,
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
    weekly_crime_20: crimeCount,
    weekly_job_10: jobCount,
    weekly_vehicle_theft_5: vehicleTheftCount,
    weekly_travel_3: travelCount,
  };
}

function startOfUtcWeek(date: Date): Date {
  // ISO-like: week starts on Monday (1). JS getUTCDay: Sunday=0.
  const day = date.getUTCDay();
  const mondayBased = day === 0 ? 7 : day;
  const start = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), 0, 0, 0));
  start.setUTCDate(start.getUTCDate() - (mondayBased - 1));
  return start;
}

function weekKeyUtc(date: Date): string {
  const start = startOfUtcWeek(date);
  return dateKeyUtc(start);
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

    const goals = GOALS.filter((g) => !g.key.startsWith('weekly_')).map((g) => {
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

  async getWeeklyGoals(playerId: number) {
    const now = new Date();
    const from = startOfUtcWeek(now);
    const key = weekKeyUtc(now);

    const [progress, claims] = await Promise.all([
      computeProgress(playerId, from),
      prisma.playerDailyGoalClaim.findMany({
        where: { playerId, dateKey: key },
        select: { goalKey: true },
      }),
    ]);

    const claimed = new Set(claims.map((c) => c.goalKey));

    const goals = GOALS.filter((g) => g.key.startsWith('weekly_')).map((g) => {
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

    return { weekKey: key, startsAt: from.toISOString(), goals };
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
    const isWeekly = def.key.startsWith('weekly_');
    const from = isWeekly ? startOfUtcWeek(now) : startOfUtcDay(now);
    const key = isWeekly ? weekKeyUtc(now) : dateKeyUtc(now);
    const progress = await computeProgress(playerId, from);
    const current = progress[goalKey] ?? 0;
    if (current < def.target) {
      const err = new Error('NOT_COMPLETE');
      // @ts-expect-error tag
      err.code = 'NOT_COMPLETE';
      throw err;
    }

    const result = await prisma.$transaction(async (tx) => {
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

    // Best-effort activity log OUTSIDE the transaction to avoid tx timeouts.
    try {
      await activityService.logActivity(
        playerId,
        isWeekly ? 'WEEKLY_GOAL_CLAIM' : 'DAILY_GOAL_CLAIM',
        `Claimed ${isWeekly ? 'weekly' : 'daily'} goal ${goalKey}`,
        {
          dateKey: result.dateKey,
          goalKey,
          rewardCash: def.rewardCash,
          rewardXp: def.rewardXp,
          newMoney: result.money,
          newXp: result.xp,
          newRank: result.rank,
        },
        false
      );
    } catch (error) {
      console.error('[dailyGoalsService] activity log failed', {
        playerId,
        goalKey,
        error,
      });
    }

    return result;
  },
};

