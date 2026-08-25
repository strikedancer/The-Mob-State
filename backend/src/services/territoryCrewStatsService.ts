import prisma from '../lib/prisma';

/** Sentinel season key for career / all-time counters. */
export const TERRITORY_STATS_ALL_TIME = '__all__';

export type TerritoryCrewStats = {
  crewId: number;
  seasonKey: string;
  regionsWon: number;
  regionsDefended: number;
  regionsLost: number;
  contestsPlayed: number;
  holdSecondsTotal: number;
};

export type TerritoryCrewStatsBundle = {
  allTime: TerritoryCrewStats;
  season: TerritoryCrewStats | null;
  seasonKey: string | null;
  currentHoldSeconds: number;
  regionsOwned: number;
};

type StatsDelta = {
  regionsWon?: number;
  regionsDefended?: number;
  regionsLost?: number;
  contestsPlayed?: number;
  holdSecondsTotal?: number;
};

function toNumeric(value: unknown): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : 0;
}

function emptyStats(crewId: number, seasonKey: string): TerritoryCrewStats {
  return {
    crewId,
    seasonKey,
    regionsWon: 0,
    regionsDefended: 0,
    regionsLost: 0,
    contestsPlayed: 0,
    holdSecondsTotal: 0,
  };
}

function mapRow(row: {
  crewId: number;
  seasonKey: string;
  regionsWon: number;
  regionsDefended: number;
  regionsLost: number;
  contestsPlayed: number;
  holdSecondsTotal: number | bigint;
}): TerritoryCrewStats {
  return {
    crewId: toNumeric(row.crewId),
    seasonKey: row.seasonKey,
    regionsWon: toNumeric(row.regionsWon),
    regionsDefended: toNumeric(row.regionsDefended),
    regionsLost: toNumeric(row.regionsLost),
    contestsPlayed: toNumeric(row.contestsPlayed),
    holdSecondsTotal: toNumeric(row.holdSecondsTotal),
  };
}

export async function getActiveSeasonKey(): Promise<string | null> {
  const rows = await prisma.$queryRawUnsafe<Array<{ seasonKey: string }>>(
    `SELECT seasonKey FROM territory_seasons WHERE status = 'active' ORDER BY startsAt DESC LIMIT 1`,
  );
  return rows[0]?.seasonKey ?? null;
}

export async function bumpCrewStats(
  crewId: number,
  seasonKey: string,
  delta: StatsDelta,
): Promise<void> {
  if (!crewId || !seasonKey) return;
  const regionsWon = Math.max(0, Math.floor(delta.regionsWon ?? 0));
  const regionsDefended = Math.max(0, Math.floor(delta.regionsDefended ?? 0));
  const regionsLost = Math.max(0, Math.floor(delta.regionsLost ?? 0));
  const contestsPlayed = Math.max(0, Math.floor(delta.contestsPlayed ?? 0));
  const holdSecondsTotal = Math.max(0, Math.floor(delta.holdSecondsTotal ?? 0));
  if (
    regionsWon === 0
    && regionsDefended === 0
    && regionsLost === 0
    && contestsPlayed === 0
    && holdSecondsTotal === 0
  ) {
    return;
  }

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_crew_stats
       (crewId, seasonKey, regionsWon, regionsDefended, regionsLost, contestsPlayed, holdSecondsTotal)
     VALUES (?, ?, ?, ?, ?, ?, ?)
     ON DUPLICATE KEY UPDATE
       regionsWon = regionsWon + VALUES(regionsWon),
       regionsDefended = regionsDefended + VALUES(regionsDefended),
       regionsLost = regionsLost + VALUES(regionsLost),
       contestsPlayed = contestsPlayed + VALUES(contestsPlayed),
       holdSecondsTotal = holdSecondsTotal + VALUES(holdSecondsTotal),
       updatedAt = NOW()`,
    crewId,
    seasonKey,
    regionsWon,
    regionsDefended,
    regionsLost,
    contestsPlayed,
    holdSecondsTotal,
  );
}

export async function bumpCrewStatsAllScopes(
  crewId: number,
  activeSeasonKey: string | null,
  delta: StatsDelta,
): Promise<void> {
  await bumpCrewStats(crewId, TERRITORY_STATS_ALL_TIME, delta);
  if (activeSeasonKey) {
    await bumpCrewStats(crewId, activeSeasonKey, delta);
  }
}

export async function bankHoldSecondsForOwner(
  crewId: number | null | undefined,
  ownedSince: Date | string | null | undefined,
  activeSeasonKey: string | null,
  now: Date = new Date(),
): Promise<number> {
  if (crewId == null || !ownedSince) return 0;
  const started = new Date(ownedSince).getTime();
  if (!Number.isFinite(started)) return 0;
  const holdSeconds = Math.max(0, Math.floor((now.getTime() - started) / 1000));
  if (holdSeconds <= 0) return 0;
  await bumpCrewStatsAllScopes(crewId, activeSeasonKey, { holdSecondsTotal: holdSeconds });
  return holdSeconds;
}

export async function getStatsForCrew(
  crewId: number,
  seasonKey: string,
): Promise<TerritoryCrewStats> {
  const rows = await prisma.$queryRawUnsafe<Array<{
    crewId: number;
    seasonKey: string;
    regionsWon: number;
    regionsDefended: number;
    regionsLost: number;
    contestsPlayed: number;
    holdSecondsTotal: number | bigint;
  }>>(
    `SELECT crewId, seasonKey, regionsWon, regionsDefended, regionsLost, contestsPlayed, holdSecondsTotal
     FROM territory_crew_stats WHERE crewId = ? AND seasonKey = ? LIMIT 1`,
    crewId,
    seasonKey,
  );
  return rows[0] ? mapRow(rows[0]) : emptyStats(crewId, seasonKey);
}

export async function getStatsBundleForCrew(crewId: number): Promise<TerritoryCrewStatsBundle> {
  const seasonKey = await getActiveSeasonKey();
  const [allTime, season, owned] = await Promise.all([
    getStatsForCrew(crewId, TERRITORY_STATS_ALL_TIME),
    seasonKey ? getStatsForCrew(crewId, seasonKey) : Promise.resolve(null),
    prisma.$queryRawUnsafe<Array<{ cnt: number; holdSeconds: number }>>(
      `SELECT COUNT(*) AS cnt,
              COALESCE(SUM(TIMESTAMPDIFF(SECOND, ownedSince, NOW())), 0) AS holdSeconds
       FROM territory_control
       WHERE ownerCrewId = ? AND ownedSince IS NOT NULL`,
      crewId,
    ),
  ]);

  return {
    allTime,
    season,
    seasonKey,
    currentHoldSeconds: toNumeric(owned[0]?.holdSeconds ?? 0),
    regionsOwned: toNumeric(owned[0]?.cnt ?? 0),
  };
}

export async function getStatsByCrewIds(
  crewIds: number[],
  seasonKey: string,
): Promise<Record<number, TerritoryCrewStats>> {
  if (crewIds.length === 0) return {};
  const placeholders = crewIds.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<Array<{
    crewId: number;
    seasonKey: string;
    regionsWon: number;
    regionsDefended: number;
    regionsLost: number;
    contestsPlayed: number;
    holdSecondsTotal: number | bigint;
  }>>(
    `SELECT crewId, seasonKey, regionsWon, regionsDefended, regionsLost, contestsPlayed, holdSecondsTotal
     FROM territory_crew_stats
     WHERE seasonKey = ? AND crewId IN (${placeholders})`,
    seasonKey,
    ...crewIds,
  );
  return rows.reduce<Record<number, TerritoryCrewStats>>((acc, row) => {
    acc[toNumeric(row.crewId)] = mapRow(row);
    return acc;
  }, {});
}

/**
 * One-time-ish backfill from resolved contests when the stats table is empty.
 * Hold-time history cannot be reconstructed accurately; only win/defense/loss + contests.
 */
export async function backfillTerritoryCrewStatsFromContestsIfEmpty(): Promise<void> {
  const countRows = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    'SELECT COUNT(*) AS cnt FROM territory_crew_stats',
  );
  if (toNumeric(countRows[0]?.cnt ?? 0) > 0) return;

  const contests = await prisma.$queryRawUnsafe<Array<{
    attackerCrewId: number;
    defenderCrewId: number | null;
    winnerCrewId: number | null;
    startedAt: Date;
  }>>(
    `SELECT attackerCrewId, defenderCrewId, winnerCrewId, startedAt
     FROM territory_contests
     WHERE status = 'resolved'`,
  );
  if (contests.length === 0) return;

  const seasons = await prisma.$queryRawUnsafe<Array<{ seasonKey: string; startsAt: Date; endsAt: Date }>>(
    `SELECT seasonKey, startsAt, endsAt FROM territory_seasons`,
  );

  const seasonFor = (at: Date): string | null => {
    const t = at.getTime();
    for (const season of seasons) {
      const start = new Date(season.startsAt).getTime();
      const end = new Date(season.endsAt).getTime();
      if (t >= start && t <= end) return season.seasonKey;
    }
    return null;
  };

  for (const contest of contests) {
    const attackerId = toNumeric(contest.attackerCrewId);
    const defenderId = contest.defenderCrewId == null ? null : toNumeric(contest.defenderCrewId);
    const winnerId = contest.winnerCrewId == null ? null : toNumeric(contest.winnerCrewId);
    const seasonKey = seasonFor(new Date(contest.startedAt));

    await bumpCrewStatsAllScopes(attackerId, seasonKey, { contestsPlayed: 1 });
    if (defenderId != null) {
      await bumpCrewStatsAllScopes(defenderId, seasonKey, { contestsPlayed: 1 });
    }

    if (winnerId == null) continue;
    if (winnerId === attackerId) {
      await bumpCrewStatsAllScopes(attackerId, seasonKey, { regionsWon: 1 });
      if (defenderId != null) {
        await bumpCrewStatsAllScopes(defenderId, seasonKey, { regionsLost: 1 });
      }
    } else if (defenderId != null && winnerId === defenderId) {
      await bumpCrewStatsAllScopes(defenderId, seasonKey, { regionsDefended: 1 });
    }
  }

  console.log(`[TerritoryStats] Backfilled crew stats from ${contests.length} resolved contest(s)`);
}
