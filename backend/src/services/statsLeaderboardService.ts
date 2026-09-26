import prisma from '../lib/prisma';

export type StatsLeaderboardMetric = 'crimes' | 'jail' | 'vehicle_thefts' | 'crime_income';
export type StatsLeaderboardPeriod = 'weekly' | 'all_time';

function periodStart(period: StatsLeaderboardPeriod): Date | null {
  if (period === 'all_time') return null;
  const now = new Date();
  const day = now.getUTCDay();
  const diffToMonday = day === 0 ? 6 : day - 1;
  const monday = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate()));
  monday.setUTCDate(monday.getUTCDate() - diffToMonday);
  monday.setUTCHours(0, 0, 0, 0);
  return monday;
}

type Row = { playerId: number; username: string; score: number | string };

async function queryTop(
  metric: StatsLeaderboardMetric,
  period: StatsLeaderboardPeriod,
  limit: number,
): Promise<Row[]> {
  const start = periodStart(period);
  const safeLimit = Math.max(1, Math.min(100, limit));

  if (metric === 'crimes') {
    return prisma.$queryRawUnsafe<Row[]>(
      start
        ? `SELECT c.playerId, p.username, COUNT(*) AS score
           FROM crime_attempts c
           JOIN players p ON p.id = c.playerId
           WHERE c.success = 1
             AND c.crimeId NOT LIKE 'arrest_%'
             AND c.crimeId NOT LIKE 'crew_mission:%'
             AND c.createdAt >= ?
           GROUP BY c.playerId, p.username
           ORDER BY score DESC
           LIMIT ?`
        : `SELECT c.playerId, p.username, COUNT(*) AS score
           FROM crime_attempts c
           JOIN players p ON p.id = c.playerId
           WHERE c.success = 1
             AND c.crimeId NOT LIKE 'arrest_%'
             AND c.crimeId NOT LIKE 'crew_mission:%'
           GROUP BY c.playerId, p.username
           ORDER BY score DESC
           LIMIT ?`,
      ...(start ? [start, safeLimit] : [safeLimit]),
    );
  }

  if (metric === 'jail') {
    return prisma.$queryRawUnsafe<Row[]>(
      start
        ? `SELECT c.playerId, p.username, COALESCE(SUM(c.jailTime), 0) AS score
           FROM crime_attempts c
           JOIN players p ON p.id = c.playerId
           WHERE c.jailTime > 0 AND c.createdAt >= ?
           GROUP BY c.playerId, p.username
           ORDER BY score DESC
           LIMIT ?`
        : `SELECT c.playerId, p.username, COALESCE(SUM(c.jailTime), 0) AS score
           FROM crime_attempts c
           JOIN players p ON p.id = c.playerId
           WHERE c.jailTime > 0
           GROUP BY c.playerId, p.username
           ORDER BY score DESC
           LIMIT ?`,
      ...(start ? [start, safeLimit] : [safeLimit]),
    );
  }

  if (metric === 'vehicle_thefts') {
    return prisma.$queryRawUnsafe<Row[]>(
      start
        ? `SELECT a.playerId, p.username, COUNT(*) AS score
           FROM player_activities a
           JOIN players p ON p.id = a.playerId
           WHERE a.activityType = 'VEHICLE_THEFT' AND a.createdAt >= ?
           GROUP BY a.playerId, p.username
           ORDER BY score DESC
           LIMIT ?`
        : `SELECT a.playerId, p.username, COUNT(*) AS score
           FROM player_activities a
           JOIN players p ON p.id = a.playerId
           WHERE a.activityType = 'VEHICLE_THEFT'
           GROUP BY a.playerId, p.username
           ORDER BY score DESC
           LIMIT ?`,
      ...(start ? [start, safeLimit] : [safeLimit]),
    );
  }

  // crime_income: successful crime rewards only (narrow "income")
  return prisma.$queryRawUnsafe<Row[]>(
    start
      ? `SELECT c.playerId, p.username, COALESCE(SUM(c.reward), 0) AS score
         FROM crime_attempts c
         JOIN players p ON p.id = c.playerId
         WHERE c.success = 1
           AND c.crimeId NOT LIKE 'arrest_%'
           AND c.crimeId NOT LIKE 'crew_mission:%'
           AND c.createdAt >= ?
         GROUP BY c.playerId, p.username
         ORDER BY score DESC
         LIMIT ?`
      : `SELECT c.playerId, p.username, COALESCE(SUM(c.reward), 0) AS score
         FROM crime_attempts c
         JOIN players p ON p.id = c.playerId
         WHERE c.success = 1
           AND c.crimeId NOT LIKE 'arrest_%'
           AND c.crimeId NOT LIKE 'crew_mission:%'
         GROUP BY c.playerId, p.username
         ORDER BY score DESC
         LIMIT ?`,
    ...(start ? [start, safeLimit] : [safeLimit]),
  );
}

export const statsLeaderboardService = {
  async getLeaderboard(
    metric: StatsLeaderboardMetric,
    period: StatsLeaderboardPeriod,
    limit = 50,
    currentPlayerId?: number,
  ) {
    const rows = await queryTop(metric, period, limit);
    return {
      metric,
      period,
      periodStart: periodStart(period),
      entries: rows.map((row, index) => ({
        rank: index + 1,
        playerId: Number(row.playerId),
        username: String(row.username),
        score: Number(row.score) || 0,
        isCurrentPlayer: currentPlayerId != null && Number(row.playerId) === currentPlayerId,
      })),
    };
  },
};
