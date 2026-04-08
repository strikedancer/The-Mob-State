import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient() as any;

export type LeaderboardPeriod = 'weekly' | 'monthly' | 'all_time';

interface LeaderboardEntryData {
  rank: number;
  playerId: number;
  username: string;
  totalEarnings: number;
  totalProstitutes: number;
  totalDistricts: number;
  highestLevel: number;
  isCurrentPlayer: boolean;
}

interface PlayerRankData {
  rank: number | null;
  totalPlayers: number;
  period: LeaderboardPeriod;
  periodStart: Date;
  stats: {
    totalEarnings: number;
    totalProstitutes: number;
    totalDistricts: number;
    highestLevel: number;
  } | null;
}

function getPeriodStart(period: LeaderboardPeriod): Date {
  const now = new Date();

  if (period === 'all_time') {
    return new Date('1970-01-01');
  }

  if (period === 'monthly') {
    return new Date(now.getFullYear(), now.getMonth(), 1);
  }

  const day = now.getDay();
  const diffToMonday = day === 0 ? 6 : day - 1;
  const monday = new Date(now);
  monday.setDate(now.getDate() - diffToMonday);
  monday.setHours(0, 0, 0, 0);
  return monday;
}

async function updatePlayerStats(playerId: number, period: LeaderboardPeriod): Promise<void> {
  const periodStart = getPeriodStart(period);

  const [player, prostitutes, districts] = await Promise.all([
    prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, money: true },
    }),
    prisma.prostitute.findMany({
      where: { playerId },
      select: { level: true },
    }),
    prisma.redLightDistrict.count({
      where: { ownerId: playerId },
    }),
  ]);

  if (!player) {
    return;
  }

  const highestLevel = prostitutes.length
    ? Math.max(...prostitutes.map((prostitute: any) => prostitute.level))
    : 1;

  await prisma.prostitutionLeaderboard.upsert({
    where: {
      playerId_period_periodStart: {
        playerId,
        period,
        periodStart,
      },
    },
    update: {
      totalEarnings: player.money,
      totalProstitutes: prostitutes.length,
      totalDistricts: districts,
      highestLevel,
    },
    create: {
      playerId,
      period,
      periodStart,
      totalEarnings: player.money,
      totalProstitutes: prostitutes.length,
      totalDistricts: districts,
      highestLevel,
    },
  });
}

async function refreshPeriodStats(period: LeaderboardPeriod): Promise<Date> {
  const periodStart = getPeriodStart(period);

  const players = await prisma.player.findMany({
    select: { id: true },
  });

  await Promise.all(players.map((player: any) => updatePlayerStats(player.id, period)));

  return periodStart;
}

async function updateRanks(period: LeaderboardPeriod): Promise<void> {
  const periodStart = await refreshPeriodStats(period);

  const entries = await prisma.prostitutionLeaderboard.findMany({
    where: { period, periodStart },
    orderBy: [
      { totalEarnings: 'desc' },
      { totalProstitutes: 'desc' },
      { highestLevel: 'desc' },
      { playerId: 'asc' },
    ],
    select: { id: true },
  });

  await Promise.all(
    entries.map((entry: any, index: number) =>
      prisma.prostitutionLeaderboard.update({
        where: { id: entry.id },
        data: { rankPosition: index + 1 },
      }),
    ),
  );
}

async function getLeaderboard(
  period: LeaderboardPeriod,
  limit: number,
  currentPlayerId?: number,
): Promise<LeaderboardEntryData[]> {
  await updateRanks(period);
  const periodStart = getPeriodStart(period);

  const entries = await prisma.prostitutionLeaderboard.findMany({
    where: { period, periodStart },
    orderBy: [
      { rankPosition: 'asc' },
      { totalEarnings: 'desc' },
    ],
    take: limit,
    include: {
      player: {
        select: {
          id: true,
          username: true,
        },
      },
    },
  });

  return entries.map((entry: any, index: number) => ({
    rank: entry.rankPosition ?? index + 1,
    playerId: entry.playerId,
    username: entry.player.username,
    totalEarnings: Number(entry.totalEarnings),
    totalProstitutes: entry.totalProstitutes,
    totalDistricts: entry.totalDistricts,
    highestLevel: entry.highestLevel,
    isCurrentPlayer: currentPlayerId === entry.playerId,
  }));
}

async function getPlayerRank(playerId: number, period: LeaderboardPeriod): Promise<PlayerRankData> {
  await updatePlayerStats(playerId, period);
  await updateRanks(period);

  const periodStart = getPeriodStart(period);

  const [entry, totalPlayers] = await Promise.all([
    prisma.prostitutionLeaderboard.findUnique({
      where: {
        playerId_period_periodStart: {
          playerId,
          period,
          periodStart,
        },
      },
    }),
    prisma.prostitutionLeaderboard.count({
      where: { period, periodStart },
    }),
  ]);

  return {
    rank: entry?.rankPosition ?? null,
    totalPlayers,
    period,
    periodStart,
    stats: entry
      ? {
          totalEarnings: Number(entry.totalEarnings),
          totalProstitutes: entry.totalProstitutes,
          totalDistricts: entry.totalDistricts,
          highestLevel: entry.highestLevel,
        }
      : null,
  };
}

async function checkAchievements(playerId: number) {
  const [prostitutes, districtCount, participations] = await Promise.all([
    prisma.prostitute.findMany({
      where: { playerId },
      select: { id: true, level: true, bustedUntil: true, isBusted: true },
    }),
    prisma.redLightDistrict.count({ where: { ownerId: playerId } }),
    prisma.eventParticipation.count({
      where: {
        playerId,
        status: 'completed',
      },
    }),
  ]);

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true },
  });

  const existing = await prisma.prostitutionAchievement.findMany({
    where: { playerId },
    select: { achievementType: true },
  });

  const unlocked = new Set(existing.map((achievement: any) => achievement.achievementType));
  const toCreate: Array<{ achievementType: string; achievementData: object }> = [];

  if (prostitutes.length >= 1 && !unlocked.has('first_steps')) {
    toCreate.push({ achievementType: 'first_steps', achievementData: { prostitutes: prostitutes.length } });
  }

  if (districtCount >= 5 && !unlocked.has('empire_builder')) {
    toCreate.push({ achievementType: 'empire_builder', achievementData: { districts: districtCount } });
  }

  if (prostitutes.some((prostitute: any) => prostitute.level >= 10) && !unlocked.has('leveling_master')) {
    toCreate.push({ achievementType: 'leveling_master', achievementData: { maxLevel: 10 } });
  }

  if ((player?.money ?? 0) >= 1000000 && !unlocked.has('millionaire')) {
    toCreate.push({ achievementType: 'millionaire', achievementData: { totalEarnings: player?.money ?? 0 } });
  }

  if (participations >= 10 && !unlocked.has('vip_service')) {
    toCreate.push({ achievementType: 'vip_service', achievementData: { completedEvents: participations } });
  }

  if (toCreate.length > 0) {
    await prisma.prostitutionAchievement.createMany({
      data: toCreate.map((achievement) => ({
        playerId,
        achievementType: achievement.achievementType,
        achievementData: achievement.achievementData,
      })),
      skipDuplicates: true,
    });
  }

  return prisma.prostitutionAchievement.findMany({
    where: { playerId },
    orderBy: { unlockedAt: 'desc' },
  });
}

export const leaderboardService = {
  updatePlayerStats,
  getLeaderboard,
  getPlayerRank,
  checkAchievements,
};
