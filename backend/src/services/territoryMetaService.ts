import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';

export type SeasonAwardPayout = {
  rewardType: 'season_expansion' | 'season_defense' | 'season_war_frontline';
  crewId: number;
  crewName: string | null;
  rank: number;
  cashAmount: number;
  metricValue: number;
};

export type SeasonCloseResult = {
  seasonKey: string;
  alreadyDistributed: boolean;
  awards: SeasonAwardPayout[];
  totalCashPaid: number;
};

export type ActiveRegionEvent = {
  id: number;
  regionKey: string;
  regionNameNl: string | null;
  regionNameEn: string | null;
  eventKey: string;
  attackBonusPoints: number;
  incomePenaltyPercent: number;
  endsAt: Date;
};

export type TerritoryDramaSnapshot = {
  hottestContests: Array<{
    contestId: number;
    regionKey: string;
    status: string;
    attackerCrewName: string | null;
    defenderCrewName: string | null;
  }>;
  recentCaptures: Array<{
    regionKey: string;
    winnerCrewName: string | null;
    resolvedAt: Date | null;
  }>;
  risingCrews: Array<{
    crewName: string;
    captures: number;
  }>;
  activeWarTheaters: Array<{
    theaterRegionKey: string;
    attackerCrewName: string | null;
    defenderCrewName: string | null;
  }>;
  activeRegionEvents: ActiveRegionEvent[];
};

export type TerritorySeasonRewardConfig = {
  expansionTopCash: number[];
  defenseTopCash: number[];
  warFrontlineTopCash: number[];
};

export type TerritoryRegionEventRuntimeConfig = {
  enabled: boolean;
  rotationHours: number;
  activeCount: number;
  attackBonusPoints: number;
  incomePenaltyPercent: number;
};

const DEFAULT_REWARD_CONFIG: TerritorySeasonRewardConfig = {
  expansionTopCash: [500000, 250000, 100000],
  defenseTopCash: [400000, 200000, 100000],
  warFrontlineTopCash: [300000, 150000, 75000],
};

const REGION_EVENT_KEYS = ['police_offensive', 'harbor_strike', 'blackout_rumor'] as const;

function toNumeric(value: unknown): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : 0;
}

function parseJson(raw: string | null | undefined): Record<string, unknown> {
  if (!raw) return {};
  try {
    const parsed = JSON.parse(raw);
    return parsed && typeof parsed === 'object' ? (parsed as Record<string, unknown>) : {};
  } catch {
    return {};
  }
}

function parseCashLadder(raw: unknown, fallback: number[]): number[] {
  if (!Array.isArray(raw) || raw.length === 0) return [...fallback];
  return raw.map((v) => Math.max(0, Math.floor(toNumeric(v))));
}

export function parseSeasonRewardConfig(raw: string | null | undefined): TerritorySeasonRewardConfig {
  const parsed = parseJson(raw);
  return {
    expansionTopCash: parseCashLadder(parsed.expansionTopCash, DEFAULT_REWARD_CONFIG.expansionTopCash),
    defenseTopCash: parseCashLadder(parsed.defenseTopCash, DEFAULT_REWARD_CONFIG.defenseTopCash),
    warFrontlineTopCash: parseCashLadder(parsed.warFrontlineTopCash, DEFAULT_REWARD_CONFIG.warFrontlineTopCash),
  };
}

export function defaultSeasonRewardConfigJson(): string {
  return JSON.stringify(DEFAULT_REWARD_CONFIG);
}

async function creditCrewBankWithinCap(crewId: number, amount: number): Promise<number> {
  if (amount <= 0) return 0;
  const cashCapacity = await getCrewStorageCapacity(crewId, 'cash_storage');
  const crew = await prisma.crew.findUnique({
    where: { id: crewId },
    select: { bankBalance: true },
  });
  if (!crew) return 0;
  const room = Math.max(0, cashCapacity - toNumeric(crew.bankBalance ?? 0));
  const credited = Math.min(amount, room);
  if (credited <= 0) return 0;
  await prisma.$executeRawUnsafe(
    `UPDATE crews SET bankBalance = bankBalance + ? WHERE id = ?`,
    credited,
    crewId,
  );
  return credited;
}

async function resolveCrewNames(crewIds: number[]): Promise<Record<number, string>> {
  const unique = [...new Set(crewIds.filter((id) => id > 0))];
  if (unique.length === 0) return {};
  const placeholders = unique.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number; name: string }>>(
    `SELECT id, name FROM crews WHERE id IN (${placeholders})`,
    ...unique,
  );
  return rows.reduce<Record<number, string>>((acc, row) => {
    acc[toNumeric(row.id)] = row.name;
    return acc;
  }, {});
}

function applyCashMultiplier(amount: number, multiplierPercent: number): number {
  const pct = Math.max(0, multiplierPercent);
  return Math.round(amount * (pct / 100));
}

export async function closeSeasonAndDistributeAwards(params: {
  seasonKey: string;
  rewardCashMultiplierPercent: number;
}): Promise<SeasonCloseResult> {
  const { seasonKey, rewardCashMultiplierPercent } = params;

  const seasons = await prisma.$queryRawUnsafe<Array<{
    seasonKey: string;
    status: string;
    startsAt: Date;
    endsAt: Date;
    rewardConfigJson: string | null;
    rewardsDistributedAt: Date | null;
  }>>(
    `SELECT seasonKey, status, startsAt, endsAt, rewardConfigJson, rewardsDistributedAt
     FROM territory_seasons WHERE seasonKey = ? LIMIT 1`,
    seasonKey,
  );
  const season = seasons[0];
  if (!season) {
    throw new Error('SEASON_NOT_FOUND');
  }

  if (season.rewardsDistributedAt) {
    await prisma.$executeRawUnsafe(
      `UPDATE territory_seasons SET status = 'closed' WHERE seasonKey = ?`,
      seasonKey,
    );
    return {
      seasonKey,
      alreadyDistributed: true,
      awards: [],
      totalCashPaid: 0,
    };
  }

  const claimToken = `dist-${Date.now()}-${Math.floor(Math.random() * 1e9)}`;
  const baseConfig = parseSeasonRewardConfig(season.rewardConfigJson);
  const claimConfigJson = JSON.stringify({
    ...baseConfig,
    distributionClaimToken: claimToken,
  });
  await prisma.$executeRawUnsafe(
    `UPDATE territory_seasons
     SET rewardsDistributedAt = NOW(),
         status = 'closed',
         rewardConfigJson = ?
     WHERE seasonKey = ? AND rewardsDistributedAt IS NULL`,
    claimConfigJson,
    seasonKey,
  );

  const claimedRows = await prisma.$queryRawUnsafe<Array<{ rewardConfigJson: string | null }>>(
    `SELECT rewardConfigJson FROM territory_seasons WHERE seasonKey = ? LIMIT 1`,
    seasonKey,
  );
  const claimedMeta = parseJson(claimedRows[0]?.rewardConfigJson);
  if (String(claimedMeta.distributionClaimToken ?? '') !== claimToken) {
    return {
      seasonKey,
      alreadyDistributed: true,
      awards: [],
      totalCashPaid: 0,
    };
  }

  const rewardConfig = baseConfig;
  const startsAt = season.startsAt;
  const endsAt = season.endsAt;
  const awards: SeasonAwardPayout[] = [];

  const expansionRows = await prisma.$queryRawUnsafe<Array<{ crewId: number; captures: number }>>(
    `SELECT winnerCrewId AS crewId, COUNT(*) AS captures
     FROM territory_contests
     WHERE status = 'resolved'
       AND winnerCrewId IS NOT NULL
       AND resolvedAt IS NOT NULL
       AND resolvedAt >= ?
       AND resolvedAt < ?
     GROUP BY winnerCrewId
     ORDER BY captures DESC, winnerCrewId ASC
     LIMIT 3`,
    startsAt,
    endsAt,
  );

  const defenseRows = await prisma.$queryRawUnsafe<Array<{ crewId: number; defensePoints: number }>>(
    `SELECT actorCrewId AS crewId, COALESCE(SUM(pointsDelta), 0) AS defensePoints
     FROM territory_actions
     WHERE actionType = 'defense'
       AND abuseFlagged = 0
       AND createdAt >= ?
       AND createdAt < ?
     GROUP BY actorCrewId
     ORDER BY defensePoints DESC, actorCrewId ASC
     LIMIT 3`,
    startsAt,
    endsAt,
  );

  let warRows: Array<{ crewId: number; totalPoints: number }> = [];
  try {
    warRows = await prisma.$queryRawUnsafe<Array<{ crewId: number; totalPoints: number }>>(
      `SELECT cws.crewId AS crewId, COALESCE(SUM(cws.totalPoints), 0) AS totalPoints
       FROM crew_war_standings cws
       JOIN crew_wars cw ON cw.id = cws.warId
       JOIN crew_war_seasons cws2 ON cws2.id = cw.seasonId
       WHERE cws2.seasonKey = ?
       GROUP BY cws.crewId
       ORDER BY totalPoints DESC, cws.crewId ASC
       LIMIT 3`,
      seasonKey,
    );
  } catch {
    warRows = [];
  }

  const nameMap = await resolveCrewNames([
    ...expansionRows.map((r) => toNumeric(r.crewId)),
    ...defenseRows.map((r) => toNumeric(r.crewId)),
    ...warRows.map((r) => toNumeric(r.crewId)),
  ]);

  const payLadder = async (
    rows: Array<{ crewId: number; metric: number }>,
    ladder: number[],
    rewardType: SeasonAwardPayout['rewardType'],
  ) => {
    for (let i = 0; i < Math.min(rows.length, ladder.length); i += 1) {
      const crewId = toNumeric(rows[i].crewId);
      if (crewId <= 0) continue;
      const baseCash = ladder[i] ?? 0;
      const cashAmount = applyCashMultiplier(baseCash, rewardCashMultiplierPercent);
      const credited = await creditCrewBankWithinCap(crewId, cashAmount);
      if (credited <= 0 && cashAmount > 0) {
        // Still log attempted award with 0 when bank full, for audit transparency.
      }
      await prisma.$executeRawUnsafe(
        `INSERT INTO territory_reward_log (seasonKey, crewId, playerId, rewardType, cashAmount, xpAmount, metadataJson)
         VALUES (?, ?, NULL, ?, ?, 0, ?)`,
        seasonKey,
        crewId,
        rewardType,
        credited,
        JSON.stringify({
          rank: i + 1,
          metricValue: rows[i].metric,
          baseCash,
          multiplierPercent: rewardCashMultiplierPercent,
          requestedCash: cashAmount,
          source: 'territory_season_award',
        }),
      );
      awards.push({
        rewardType,
        crewId,
        crewName: nameMap[crewId] ?? null,
        rank: i + 1,
        cashAmount: credited,
        metricValue: rows[i].metric,
      });
    }
  };

  await payLadder(
    expansionRows.map((r) => ({ crewId: toNumeric(r.crewId), metric: toNumeric(r.captures) })),
    rewardConfig.expansionTopCash,
    'season_expansion',
  );
  await payLadder(
    defenseRows.map((r) => ({ crewId: toNumeric(r.crewId), metric: toNumeric(r.defensePoints) })),
    rewardConfig.defenseTopCash,
    'season_defense',
  );
  await payLadder(
    warRows.map((r) => ({ crewId: toNumeric(r.crewId), metric: toNumeric(r.totalPoints) })),
    rewardConfig.warFrontlineTopCash,
    'season_war_frontline',
  );

  return {
    seasonKey,
    alreadyDistributed: false,
    awards,
    totalCashPaid: awards.reduce((sum, a) => sum + a.cashAmount, 0),
  };
}

function mapRegionEventRow(row: {
  id: number;
  regionKey: string;
  metadataJson: string | null;
  endsAt: Date;
  nameNl?: string | null;
  nameEn?: string | null;
}): ActiveRegionEvent {
  const metadata = parseJson(row.metadataJson);
  return {
    id: toNumeric(row.id),
    regionKey: row.regionKey,
    regionNameNl: row.nameNl ?? null,
    regionNameEn: row.nameEn ?? null,
    eventKey: String(metadata.eventKey ?? 'police_offensive'),
    attackBonusPoints: Math.max(0, toNumeric(metadata.attackBonusPoints ?? 0)),
    incomePenaltyPercent: Math.max(0, toNumeric(metadata.incomePenaltyPercent ?? 0)),
    endsAt: row.endsAt,
  };
}

export async function getActiveRegionEvents(
  regionKeys?: string[],
  now: Date = new Date(),
): Promise<ActiveRegionEvent[]> {
  let rows: Array<{
    id: number;
    regionKey: string;
    metadataJson: string | null;
    endsAt: Date;
    nameNl: string | null;
    nameEn: string | null;
  }>;

  if (regionKeys && regionKeys.length > 0) {
    const placeholders = regionKeys.map(() => '?').join(',');
    rows = await prisma.$queryRawUnsafe(
      `SELECT e.id, e.regionKey, e.metadataJson, e.endsAt, tr.nameNl, tr.nameEn
       FROM territory_region_effects e
       LEFT JOIN territory_regions tr ON tr.regionKey = e.regionKey
       WHERE e.effectType = 'region_event'
         AND e.resolvedAt IS NULL
         AND e.startsAt <= ?
         AND e.endsAt > ?
         AND e.regionKey IN (${placeholders})
       ORDER BY e.createdAt DESC`,
      now,
      now,
      ...regionKeys,
    );
  } else {
    rows = await prisma.$queryRawUnsafe(
      `SELECT e.id, e.regionKey, e.metadataJson, e.endsAt, tr.nameNl, tr.nameEn
       FROM territory_region_effects e
       LEFT JOIN territory_regions tr ON tr.regionKey = e.regionKey
       WHERE e.effectType = 'region_event'
         AND e.resolvedAt IS NULL
         AND e.startsAt <= ?
         AND e.endsAt > ?
       ORDER BY e.createdAt DESC
       LIMIT 20`,
      now,
      now,
    );
  }

  const byRegion = new Map<string, ActiveRegionEvent>();
  for (const row of rows) {
    if (byRegion.has(row.regionKey)) continue;
    byRegion.set(row.regionKey, mapRegionEventRow(row));
  }
  return [...byRegion.values()];
}

export async function getActiveRegionEventIncomePenaltyByRegion(
  regionKeys: string[],
  now: Date = new Date(),
): Promise<Record<string, number>> {
  const events = await getActiveRegionEvents(regionKeys, now);
  return events.reduce<Record<string, number>>((acc, event) => {
    if (event.incomePenaltyPercent > 0) {
      acc[event.regionKey] = Math.max(acc[event.regionKey] ?? 0, event.incomePenaltyPercent);
    }
    return acc;
  }, {});
}

export async function rotateRegionEvents(
  now: Date,
  cfg: TerritoryRegionEventRuntimeConfig,
): Promise<void> {
  if (!cfg.enabled || cfg.activeCount <= 0) return;

  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_effects
     SET resolvedAt = ?
     WHERE effectType = 'region_event'
       AND resolvedAt IS NULL
       AND endsAt <= ?`,
    now,
    now,
  );

  const active = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_region_effects
     WHERE effectType = 'region_event'
       AND resolvedAt IS NULL
       AND startsAt <= ?
       AND endsAt > ?`,
    now,
    now,
  );
  let openCount = toNumeric(active[0]?.cnt ?? 0);
  if (openCount >= cfg.activeCount) return;

  const occupied = await prisma.$queryRawUnsafe<Array<{ regionKey: string }>>(
    `SELECT regionKey FROM territory_region_effects
     WHERE effectType = 'region_event'
       AND resolvedAt IS NULL
       AND endsAt > ?`,
    now,
  );
  const occupiedSet = new Set(occupied.map((r) => r.regionKey));

  const candidates = await prisma.$queryRawUnsafe<Array<{
    regionKey: string;
    strategicTagsJson: string | null;
  }>>(
    `SELECT regionKey, strategicTagsJson FROM territory_regions WHERE enabled = 1`,
  );

  const preferred = candidates.filter((c) => {
    if (occupiedSet.has(c.regionKey)) return false;
    const tags = String(c.strategicTagsJson ?? '').toLowerCase();
    return tags.includes('harbor') || tags.includes('border') || tags.includes('capital') || tags.includes('industry');
  });
  const fallback = candidates.filter((c) => !occupiedSet.has(c.regionKey));
  const pool = preferred.length > 0 ? preferred : fallback;
  if (pool.length === 0) return;

  const durationMs = Math.max(1, cfg.rotationHours) * 60 * 60 * 1000;
  const endsAt = new Date(now.getTime() + durationMs);

  while (openCount < cfg.activeCount && pool.length > 0) {
    const idx = Math.floor(Math.random() * pool.length);
    const picked = pool.splice(idx, 1)[0];
    if (!picked || occupiedSet.has(picked.regionKey)) continue;
    occupiedSet.add(picked.regionKey);

    const eventKey = REGION_EVENT_KEYS[Math.floor(Math.random() * REGION_EVENT_KEYS.length)];
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_region_effects
         (regionKey, effectType, sourceType, sourceId, favoredCrewId, affectedCrewId, metadataJson, startsAt, endsAt)
       VALUES (?, 'region_event', 'territory_event_rotator', NULL, NULL, NULL, ?, ?, ?)`,
      picked.regionKey,
      JSON.stringify({
        eventKey,
        attackBonusPoints: cfg.attackBonusPoints,
        incomePenaltyPercent: cfg.incomePenaltyPercent,
      }),
      now,
      endsAt,
    );
    openCount += 1;
  }
}

export async function getTerritoryDramaSnapshot(now: Date = new Date()): Promise<TerritoryDramaSnapshot> {
  const [hottestContests, recentCaptures, risingCrews, warRows, activeRegionEvents] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{
      id: number;
      regionKey: string;
      status: string;
      attackerCrewName: string | null;
      defenderCrewName: string | null;
    }>>(
      `SELECT tc.id, tc.regionKey, tc.status, ac.name AS attackerCrewName, dc.name AS defenderCrewName
       FROM territory_contests tc
       LEFT JOIN crews ac ON ac.id = tc.attackerCrewId
       LEFT JOIN crews dc ON dc.id = tc.defenderCrewId
       WHERE tc.status IN ('preparing', 'active', 'lockdown')
       ORDER BY
         CASE tc.status WHEN 'active' THEN 0 WHEN 'preparing' THEN 1 ELSE 2 END,
         tc.startedAt DESC
       LIMIT 5`,
    ),
    prisma.$queryRawUnsafe<Array<{
      regionKey: string;
      winnerCrewName: string | null;
      resolvedAt: Date | null;
    }>>(
      `SELECT tc.regionKey, c.name AS winnerCrewName, tc.resolvedAt
       FROM territory_contests tc
       LEFT JOIN crews c ON c.id = tc.winnerCrewId
       WHERE tc.status = 'resolved' AND tc.winnerCrewId IS NOT NULL
       ORDER BY tc.resolvedAt DESC
       LIMIT 5`,
    ),
    prisma.$queryRawUnsafe<Array<{ crewName: string; captures: number }>>(
      `SELECT c.name AS crewName, COUNT(*) AS captures
       FROM territory_contests tc
       JOIN crews c ON c.id = tc.winnerCrewId
       WHERE tc.status = 'resolved'
         AND tc.winnerCrewId IS NOT NULL
         AND tc.resolvedAt >= DATE_SUB(?, INTERVAL 7 DAY)
       GROUP BY tc.winnerCrewId, c.name
       ORDER BY captures DESC, c.name ASC
       LIMIT 5`,
      now,
    ),
    prisma.$queryRawUnsafe<Array<{
      metadataJson: string | null;
      attackerCrewName: string | null;
      defenderCrewName: string | null;
    }>>(
      `SELECT cw.metadataJson, ac.name AS attackerCrewName, dc.name AS defenderCrewName
       FROM crew_wars cw
       LEFT JOIN crews ac ON ac.id = cw.attackerCrewId
       LEFT JOIN crews dc ON dc.id = cw.defenderCrewId
       WHERE cw.status IN ('declared', 'active', 'lockdown', 'preparing')
       ORDER BY cw.updatedAt DESC
       LIMIT 10`,
    ).catch(() => []),
    getActiveRegionEvents(undefined, now),
  ]);

  const activeWarTheaters: TerritoryDramaSnapshot['activeWarTheaters'] = [];
  for (const row of warRows) {
    const metadata = parseJson(row.metadataJson);
    const theaterRegionKey = String(metadata.theaterRegionKey ?? '').trim();
    if (!theaterRegionKey) continue;
    if (activeWarTheaters.some((t) => t.theaterRegionKey === theaterRegionKey)) continue;
    activeWarTheaters.push({
      theaterRegionKey,
      attackerCrewName: row.attackerCrewName,
      defenderCrewName: row.defenderCrewName,
    });
    if (activeWarTheaters.length >= 5) break;
  }

  return {
    hottestContests: hottestContests.map((row) => ({
      contestId: toNumeric(row.id),
      regionKey: row.regionKey,
      status: row.status,
      attackerCrewName: row.attackerCrewName,
      defenderCrewName: row.defenderCrewName,
    })),
    recentCaptures: recentCaptures.map((row) => ({
      regionKey: row.regionKey,
      winnerCrewName: row.winnerCrewName,
      resolvedAt: row.resolvedAt,
    })),
    risingCrews: risingCrews.map((row) => ({
      crewName: row.crewName,
      captures: toNumeric(row.captures),
    })),
    activeWarTheaters,
    activeRegionEvents: activeRegionEvents.slice(0, 5),
  };
}
