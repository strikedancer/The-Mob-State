import prisma from '../lib/prisma';
import { notificationService } from './notificationService';

// ---------------------------------------------------------------------------
// Territory Service
// All tuning values come from runtime_config (admin-managed, never from files).
// ---------------------------------------------------------------------------

// ── Runtime Config Helpers ──────────────────────────────────────────────────

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

async function getTerritoryConfig() {
  const keys = [
    'TERRITORY_ENABLED',
    'TERRITORY_CONTEST_PREP_MINUTES',
    'TERRITORY_CONTEST_ACTIVE_MINUTES',
    'TERRITORY_CONTEST_LOCKDOWN_MINUTES',
    'TERRITORY_ACTION_COOLDOWN_SECONDS',
    'TERRITORY_ACTION_DAILY_CAP',
    'TERRITORY_CAPTURE_THRESHOLD_PERCENT',
    'TERRITORY_DECAY_PER_HOUR',
    'TERRITORY_DECAY_GRACE_MINUTES',
    'TERRITORY_MAX_REGIONS_PER_CREW',
    'TERRITORY_MAX_CONCURRENT_CONTESTS_PER_CREW',
    'TERRITORY_PRIME_TIME_START_HOUR_UTC',
    'TERRITORY_PRIME_TIME_END_HOUR_UTC',
    'TERRITORY_ANTI_FARM_WINDOW_SECONDS',
    'TERRITORY_ANTI_FARM_REPEAT_TARGET_CAP',
    'TERRITORY_REWARD_CASH_MULTIPLIER_PERCENT',
    'TERRITORY_REWARD_XP_MULTIPLIER_PERCENT',
  ];
  const cfg = await getRuntimeConfig(keys);
  return {
    enabled: true,
    contestPrepMinutes: Number(cfg['TERRITORY_CONTEST_PREP_MINUTES'] ?? 30),
    contestActiveMinutes: Number(cfg['TERRITORY_CONTEST_ACTIVE_MINUTES'] ?? 120),
    contestLockdownMinutes: Number(cfg['TERRITORY_CONTEST_LOCKDOWN_MINUTES'] ?? 15),
    actionCooldownSeconds: Number(cfg['TERRITORY_ACTION_COOLDOWN_SECONDS'] ?? 900),
    actionDailyCap: Number(cfg['TERRITORY_ACTION_DAILY_CAP'] ?? 20),
    captureThresholdPercent: Number(cfg['TERRITORY_CAPTURE_THRESHOLD_PERCENT'] ?? 60),
    decayPerHour: Number(cfg['TERRITORY_DECAY_PER_HOUR'] ?? 2),
    decayGraceMinutes: Number(cfg['TERRITORY_DECAY_GRACE_MINUTES'] ?? 60),
    maxRegionsPerCrew: Number(cfg['TERRITORY_MAX_REGIONS_PER_CREW'] ?? 5),
    maxConcurrentContestsPerCrew: Number(cfg['TERRITORY_MAX_CONCURRENT_CONTESTS_PER_CREW'] ?? 2),
    primeTimeStartHour: Number(cfg['TERRITORY_PRIME_TIME_START_HOUR_UTC'] ?? 17),
    primeTimeEndHour: Number(cfg['TERRITORY_PRIME_TIME_END_HOUR_UTC'] ?? 23),
    antiFarmWindowSeconds: Number(cfg['TERRITORY_ANTI_FARM_WINDOW_SECONDS'] ?? 1800),
    antiFarmRepeatTargetCap: Number(cfg['TERRITORY_ANTI_FARM_REPEAT_TARGET_CAP'] ?? 3),
    rewardCashMultiplierPercent: Number(cfg['TERRITORY_REWARD_CASH_MULTIPLIER_PERCENT'] ?? 110),
    rewardXpMultiplierPercent: Number(cfg['TERRITORY_REWARD_XP_MULTIPLIER_PERCENT'] ?? 110),
  };
}

// ── Shared Types ────────────────────────────────────────────────────────────

type TerritoryRow = { id: number; countryCode: string; displayNameNl: string; displayNameEn: string; svgAssetKey: string; enabled: number };
type RegionRow = { id: number; countryCode: string; regionKey: string; nameNl: string; nameEn: string; svgElementId: string; valueTier: number; strategicTagsJson: string | null; neighborsJson: string | null; enabled: number };
type ControlRow = { id: number; regionKey: string; ownerCrewId: number | null; controlJson: string | null; stability: number; lastDecayAt: Date | null; updatedAt: Date };
type ContestRow = { id: number; regionKey: string; status: string; attackerCrewId: number; defenderCrewId: number | null; startedAt: Date; activeAt: Date | null; lockdownAt: Date | null; resolveAt: Date | null; resolvedAt: Date | null; winnerCrewId: number | null; metadataJson: string | null };
type SeasonRow = { id: number; seasonKey: string; status: string; startsAt: Date; endsAt: Date; rewardConfigJson: string | null };
type MapContestRow = ContestRow & { attackerCrewName: string | null; defenderCrewName: string | null };

function buildContestSchedule(
  startedAt: Date,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): { activeAt: Date; lockdownAt: Date; resolveAt: Date } {
  const activeAt = new Date(startedAt.getTime() + (cfg.contestPrepMinutes * 60 * 1000));
  const lockdownAt = new Date(activeAt.getTime() + (cfg.contestActiveMinutes * 60 * 1000));
  const resolveAt = new Date(lockdownAt.getTime() + (cfg.contestLockdownMinutes * 60 * 1000));
  return { activeAt, lockdownAt, resolveAt };
}

function normalizeContestSchedule(
  contest: Pick<ContestRow, 'startedAt' | 'activeAt' | 'lockdownAt' | 'resolveAt'>,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): { activeAt: Date; lockdownAt: Date; resolveAt: Date } {
  const fallback = buildContestSchedule(contest.startedAt, cfg);
  return {
    activeAt: contest.activeAt ?? fallback.activeAt,
    lockdownAt: contest.lockdownAt ?? fallback.lockdownAt,
    resolveAt: contest.resolveAt ?? fallback.resolveAt,
  };
}

function parseJson(v: string | null | undefined): Record<string, unknown> {
  if (!v) return {};
  try { return JSON.parse(v) as Record<string, unknown>; } catch { return {}; }
}

async function syncContestLifecycle(now: Date = new Date()): Promise<void> {
  const cfg = await getTerritoryConfig();

  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests
     SET activeAt = COALESCE(activeAt, TIMESTAMPADD(MINUTE, ?, startedAt)),
         lockdownAt = COALESCE(lockdownAt, TIMESTAMPADD(MINUTE, ?, startedAt)),
         resolveAt = COALESCE(resolveAt, TIMESTAMPADD(MINUTE, ?, startedAt))
     WHERE status IN ('preparing', 'active', 'lockdown')
       AND (activeAt IS NULL OR lockdownAt IS NULL OR resolveAt IS NULL)` ,
    cfg.contestPrepMinutes,
    cfg.contestPrepMinutes + cfg.contestActiveMinutes,
    cfg.contestPrepMinutes + cfg.contestActiveMinutes + cfg.contestLockdownMinutes,
  );

  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests
     SET status = 'active'
     WHERE status = 'preparing' AND activeAt IS NOT NULL AND activeAt <= ?`,
    now,
  );

  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests
     SET status = 'lockdown'
     WHERE status = 'active' AND lockdownAt IS NOT NULL AND lockdownAt <= ?`,
    now,
  );

  const contestsToResolve = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM territory_contests
     WHERE status IN ('active', 'lockdown') AND resolveAt IS NOT NULL AND resolveAt <= ?`,
    now,
  );

  for (const contest of contestsToResolve) {
    try {
      await resolveContest(contest.id);
    } catch (error) {
      if (!(error instanceof Error) || error.message !== 'CONTEST_NOT_FOUND_OR_ALREADY_RESOLVED') {
        throw error;
      }
    }
  }
}

// ── Public API ──────────────────────────────────────────────────────────────

export async function getCountries(): Promise<TerritoryRow[]> {
  return prisma.$queryRawUnsafe<TerritoryRow[]>(
    `SELECT id, countryCode, displayNameNl, displayNameEn, svgAssetKey, enabled
     FROM territory_countries WHERE enabled = 1 ORDER BY countryCode`
  );
}

export async function getMapData(
  countryCode: string,
  viewer?: { viewerPlayerId?: number | null; viewerCrewId?: number | null },
): Promise<{
  country: TerritoryRow;
  regions: Array<RegionRow & {
    ownerCrewId: number | null;
    ownerCrewName: string | null;
    controlPercent: number;
    stability: number;
    contestId: number | null;
    contestStatus: string | null;
    contestStartedAt: Date | null;
    contestActiveAt: Date | null;
    contestLockdownAt: Date | null;
    contestResolveAt: Date | null;
    attackerCrewId: number | null;
    attackerCrewName: string | null;
    defenderCrewId: number | null;
    defenderCrewName: string | null;
    viewerContestRole: 'attacker' | 'defender' | null;
    viewerNextActionAt: Date | null;
    viewerCooldownSecondsRemaining: number;
  }>;
}> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  const now = new Date();

  const [countries, regions, controls, contests] = await Promise.all([
    prisma.$queryRawUnsafe<TerritoryRow[]>(
      'SELECT id, countryCode, displayNameNl, displayNameEn, svgAssetKey, enabled FROM territory_countries WHERE countryCode = ? LIMIT 1',
      countryCode,
    ),
    prisma.$queryRawUnsafe<RegionRow[]>(
      'SELECT * FROM territory_regions WHERE countryCode = ? AND enabled = 1 ORDER BY regionKey',
      countryCode,
    ),
    prisma.$queryRawUnsafe<ControlRow[]>(
      `SELECT tc.* FROM territory_control tc
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       WHERE tr.countryCode = ?`,
      countryCode,
    ),
    prisma.$queryRawUnsafe<MapContestRow[]>(
      `SELECT tc.*, ac.name AS attackerCrewName, dc.name AS defenderCrewName FROM territory_contests tc
       LEFT JOIN crews ac ON ac.id = tc.attackerCrewId
       LEFT JOIN crews dc ON dc.id = tc.defenderCrewId
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       WHERE tr.countryCode = ? AND tc.status NOT IN ('resolved', 'cancelled')`,
      countryCode,
    ),
  ]);

  const country = countries[0];
  if (!country) throw new Error('COUNTRY_NOT_FOUND');

  // Build owner crew name lookup from crew ids
  const ownerIds = [...new Set(controls.filter(c => c.ownerCrewId).map(c => c.ownerCrewId!))];
  let crewNames: Array<{ id: number; name: string }> = [];
  if (ownerIds.length > 0) {
    const placeholders = ownerIds.map(() => '?').join(',');
    crewNames = await prisma.$queryRawUnsafe<Array<{ id: number; name: string }>>(
      `SELECT id, name FROM crews WHERE id IN (${placeholders})`,
      ...ownerIds,
    );
  }
  const crewNameMap = crewNames.reduce<Record<number, string>>((a, c) => { a[c.id] = c.name; return a; }, {});
  const controlMap = controls.reduce<Record<string, ControlRow>>((a, c) => { a[c.regionKey] = c; return a; }, {});
  const contestMap = contests.reduce<Record<string, MapContestRow>>((acc, contest) => {
    acc[contest.regionKey] = contest;
    return acc;
  }, {});

  let viewerCooldownByContestId: Record<number, { nextActionAt: Date; secondsRemaining: number }> = {};
  if (viewer?.viewerPlayerId && contests.length > 0) {
    const contestIds = contests.map((contest) => contest.id);
    const placeholders = contestIds.map(() => '?').join(', ');
    const latestViewerActions = await prisma.$queryRawUnsafe<Array<{ contestId: number; lastActionAt: Date }>>(
      `SELECT contestId, MAX(createdAt) AS lastActionAt
       FROM territory_actions
       WHERE actorId = ? AND contestId IN (${placeholders})
       GROUP BY contestId`,
      viewer.viewerPlayerId,
      ...contestIds,
    );

    viewerCooldownByContestId = latestViewerActions.reduce<Record<number, { nextActionAt: Date; secondsRemaining: number }>>(
      (acc, action) => {
        const nextActionAt = new Date(action.lastActionAt.getTime() + (cfg.actionCooldownSeconds * 1000));
        const secondsRemaining = Math.max(0, Math.ceil((nextActionAt.getTime() - now.getTime()) / 1000));
        if (secondsRemaining > 0) {
          acc[action.contestId] = { nextActionAt, secondsRemaining };
        }
        return acc;
      },
      {},
    );
  }

  const enrichedRegions = regions.map(r => {
    const ctrl = controlMap[r.regionKey];
    const contest = contestMap[r.regionKey];
    const contestSchedule = contest ? normalizeContestSchedule(contest, cfg) : null;
    const viewerContestRole = viewer?.viewerCrewId == null || !contest
      ? null
      : (contest.attackerCrewId === viewer.viewerCrewId ? 'attacker' : (contest.defenderCrewId === viewer.viewerCrewId ? 'defender' : null));
    const viewerCooldown = contest ? viewerCooldownByContestId[contest.id] : undefined;
    const controlPercent = ctrl ? (() => {
      const cpJson = parseJson(ctrl.controlJson ?? null);
      if (!ctrl.ownerCrewId) return 0;
      return Number(cpJson[String(ctrl.ownerCrewId)] ?? 0);
    })() : 0;
    return {
      ...r,
      ownerCrewId: ctrl?.ownerCrewId ?? null,
      ownerCrewName: ctrl?.ownerCrewId ? (crewNameMap[ctrl.ownerCrewId] ?? null) : null,
      controlPercent,
      stability: ctrl?.stability ?? 100,
      contestId: contest?.id ?? null,
      contestStatus: contest?.status ?? null,
      contestStartedAt: contest?.startedAt ?? null,
      contestActiveAt: contestSchedule?.activeAt ?? null,
      contestLockdownAt: contestSchedule?.lockdownAt ?? null,
      contestResolveAt: contestSchedule?.resolveAt ?? null,
      attackerCrewId: contest?.attackerCrewId ?? null,
      attackerCrewName: contest?.attackerCrewName ?? null,
      defenderCrewId: contest?.defenderCrewId ?? null,
      defenderCrewName: contest?.defenderCrewName ?? null,
      viewerContestRole,
      viewerNextActionAt: viewerCooldown?.nextActionAt ?? null,
      viewerCooldownSecondsRemaining: viewerCooldown?.secondsRemaining ?? 0,
    };
  });

  return { country, regions: enrichedRegions };
}

export async function getOverview(): Promise<{
  config: Awaited<ReturnType<typeof getTerritoryConfig>>;
  activeSeason: SeasonRow | null;
  leaderboard: Array<{ crewId: number; crewName: string; regionsOwned: number; totalControl: number }>;
}> {
  await syncContestLifecycle();

  const [cfg, seasons, leaderboard] = await Promise.all([
    getTerritoryConfig(),
    prisma.$queryRawUnsafe<SeasonRow[]>(
      `SELECT * FROM territory_seasons WHERE status = 'active' ORDER BY startsAt DESC LIMIT 1`
    ),
    prisma.$queryRawUnsafe<Array<{ crewId: number; crewName: string; regionsOwned: number; totalControl: number }>>(
      `SELECT c.id AS crewId, c.name AS crewName, COUNT(tc.id) AS regionsOwned, 0 AS totalControl
       FROM territory_control tc
       JOIN crews c ON c.id = tc.ownerCrewId
       WHERE tc.ownerCrewId IS NOT NULL
       GROUP BY c.id, c.name
       ORDER BY regionsOwned DESC
       LIMIT 10`
    ),
  ]);
  return { config: cfg, activeSeason: seasons[0] ?? null, leaderboard };
}

export async function startContest(playerId: number, crewId: number, regionKey: string): Promise<{
  contestId: number;
  status: string;
  activeAt: Date;
  lockdownAt: Date;
  resolveAt: Date;
}> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');

  // Validate region exists and is enabled
  const regions = await prisma.$queryRawUnsafe<RegionRow[]>(
    'SELECT * FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    regionKey,
  );
  if (!regions[0]) throw new Error('REGION_NOT_FOUND');

  // Validate no concurrent active contest
  const existingContests = await prisma.$queryRawUnsafe<ContestRow[]>(
    `SELECT id FROM territory_contests WHERE regionKey = ? AND status NOT IN ('resolved', 'cancelled') LIMIT 1`,
    regionKey,
  );
  if (existingContests.length > 0) throw new Error('CONTEST_ALREADY_ACTIVE');

  // Validate crew concurrent contest limit
  const crewContests = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_contests
     WHERE attackerCrewId = ? AND status NOT IN ('resolved', 'cancelled')`,
    crewId,
  );
  if (Number(crewContests[0]?.cnt ?? 0) >= cfg.maxConcurrentContestsPerCrew) {
    throw new Error('CREW_CONTEST_LIMIT_REACHED');
  }

  // Validate max regions per crew
  const ownedCount = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_control WHERE ownerCrewId = ?`,
    crewId,
  );
  if (Number(ownedCount[0]?.cnt ?? 0) >= cfg.maxRegionsPerCrew) {
    throw new Error('REGIONS_CAP_REACHED');
  }

  const now = new Date();
  const schedule = buildContestSchedule(now, cfg);
  const activeAt = schedule.activeAt;
  const lockdownAt = schedule.lockdownAt;
  const resolveAt = schedule.resolveAt;

  // Get current owner for defender
  const controlRows = await prisma.$queryRawUnsafe<ControlRow[]>(
    'SELECT * FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  const defenderCrewId = controlRows[0]?.ownerCrewId ?? null;

  const contestId = await prisma.$transaction(async (tx) => {
    await tx.$executeRawUnsafe(
      `INSERT INTO territory_contests (regionKey, status, attackerCrewId, defenderCrewId, startedAt, activeAt, lockdownAt, resolveAt)
       VALUES (?, 'preparing', ?, ?, ?, ?, ?, ?)`,
      regionKey, crewId, defenderCrewId, now, activeAt, lockdownAt, resolveAt,
    );

    const inserted = await tx.$queryRawUnsafe<Array<{ id: number }>>(
      'SELECT LAST_INSERT_ID() AS id',
    );

    const insertedContestId = inserted[0]?.id ?? 0;
    if (!insertedContestId) {
      throw new Error('CONTEST_INSERT_FAILED');
    }
    return insertedContestId;
  });

  // Notify defending crew (if any)
  if (defenderCrewId) {
    _notifyCrewContestStarted(defenderCrewId, regionKey, contestId).catch(() => {});
  }

  return {
    contestId,
    status: 'preparing',
    activeAt,
    lockdownAt,
    resolveAt,
  };
}

export async function doAction(
  playerId: number,
  crewId: number,
  contestId: number,
  actionType: string,
): Promise<{ pointsDelta: number; message: string }> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');

  const validActions = ['patrol', 'intel_scan', 'sabotage', 'supply_run', 'raid', 'defense'];
  if (!validActions.includes(actionType)) throw new Error('INVALID_ACTION_TYPE');

  const contests = await prisma.$queryRawUnsafe<ContestRow[]>(
    'SELECT * FROM territory_contests WHERE id = ? LIMIT 1',
    contestId,
  );
  const contest = contests[0];
  if (!contest) throw new Error('CONTEST_NOT_FOUND');
  if (contest.status !== 'active') throw new Error('CONTEST_NOT_ACTIVE');
  if (contest.attackerCrewId !== crewId && contest.defenderCrewId !== crewId) {
    throw new Error('NOT_IN_CONTEST');
  }

  const attackerActions = new Set(['intel_scan', 'sabotage', 'raid']);
  const defenderActions = new Set(['patrol', 'supply_run', 'defense']);
  if (attackerActions.has(actionType) && contest.attackerCrewId !== crewId) {
    throw new Error('ACTION_ROLE_MISMATCH');
  }
  if (defenderActions.has(actionType) && contest.defenderCrewId !== crewId) {
    throw new Error('ACTION_ROLE_MISMATCH');
  }

  // Cooldown check
  const cooldownMs = cfg.actionCooldownSeconds * 1000;
  const recentActions = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_actions
     WHERE actorId = ? AND contestId = ? AND createdAt > DATE_SUB(NOW(), INTERVAL ? SECOND)`,
    playerId, contestId, cfg.actionCooldownSeconds,
  );
  if (Number(recentActions[0]?.cnt ?? 0) > 0) throw new Error('ACTION_COOLDOWN');

  // Daily cap check
  const todayActions = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_actions
     WHERE actorId = ? AND createdAt > DATE_SUB(NOW(), INTERVAL 24 HOUR)`,
    playerId,
  );
  if (Number(todayActions[0]?.cnt ?? 0) >= cfg.actionDailyCap) throw new Error('DAILY_CAP_REACHED');

  // Anti-farm: repeated target crew limit
  const antiFarmCount = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_actions
     WHERE actorId = ? AND contestId = ? AND createdAt > DATE_SUB(NOW(), INTERVAL ? SECOND)`,
    playerId, contestId, cfg.antiFarmWindowSeconds,
  );
  const abuseFlagged = Number(antiFarmCount[0]?.cnt ?? 0) >= cfg.antiFarmRepeatTargetCap ? 1 : 0;

  const ACTION_POINTS: Record<string, number> = {
    patrol: 4,
    intel_scan: 3,
    sabotage: 8,
    supply_run: 5,
    raid: 12,
    defense: 6,
  };
  const pointsDelta = abuseFlagged ? 0 : (ACTION_POINTS[actionType] ?? 4);
  const stabilityDelta = actionType === 'sabotage' ? -5 : (actionType === 'supply_run' ? 3 : 0);

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_actions (contestId, actorId, actorCrewId, regionKey, actionType, pointsDelta, stabilityDelta, abuseFlagged)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    contestId, playerId, crewId, contest.regionKey, actionType, pointsDelta, stabilityDelta, abuseFlagged,
  );

  // Update control percentages
  await _recalcContestControl(contestId, contest.regionKey, crewId, pointsDelta);

  return {
    pointsDelta,
    message: abuseFlagged ? 'ANTI_FARM_LIMITED' : 'ACTION_OK',
  };
}

export async function defendContest(playerId: number, crewId: number, contestId: number): Promise<void> {
  await syncContestLifecycle();

  const contests = await prisma.$queryRawUnsafe<ContestRow[]>(
    `SELECT * FROM territory_contests WHERE id = ? AND defenderCrewId = ? LIMIT 1`,
    contestId, crewId,
  );
  if (!contests[0]) throw new Error('CONTEST_NOT_FOUND');
  if (contests[0].status !== 'preparing' && contests[0].status !== 'active') {
    throw new Error('CONTEST_NOT_JOINABLE');
  }
  // Defender has joined — no extra state needed; they do actions via doAction
}

export async function getCrewTerritory(crewId: number): Promise<{
  regions: Array<{ regionKey: string; nameNl: string; nameEn: string; stability: number; controlPercent: number; contestStatus: string | null }>;
  season: SeasonRow | null;
}> {
  await syncContestLifecycle();

  const [controlled, seasons] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{ regionKey: string; nameNl: string; nameEn: string; stability: number; controlJson: string | null; ownerCrewId: number | null }>>(
      `SELECT tc.regionKey, tr.nameNl, tr.nameEn, tc.stability, tc.controlJson, tc.ownerCrewId
       FROM territory_control tc
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       WHERE tc.ownerCrewId = ?`,
      crewId,
    ),
    prisma.$queryRawUnsafe<SeasonRow[]>(
      `SELECT * FROM territory_seasons WHERE status = 'active' ORDER BY startsAt DESC LIMIT 1`
    ),
  ]);

  // Active contests per region
  const regionKeys = controlled.map(r => r.regionKey);
  let activeContests: Array<{ regionKey: string; status: string }> = [];
  if (regionKeys.length > 0) {
    const placeholders = regionKeys.map(() => '?').join(',');
    activeContests = await prisma.$queryRawUnsafe<Array<{ regionKey: string; status: string }>>(
      `SELECT regionKey, status FROM territory_contests
       WHERE regionKey IN (${placeholders}) AND status NOT IN ('resolved', 'cancelled')`,
      ...regionKeys,
    );
  }
  const contestByRegion = activeContests.reduce<Record<string, string>>((a, c) => { a[c.regionKey] = c.status; return a; }, {});

  return {
    regions: controlled.map(r => {
      const cpJson = parseJson(r.controlJson);
      const controlPercent = r.ownerCrewId ? Number(cpJson[String(r.ownerCrewId)] ?? 0) : 0;
      return {
        regionKey: r.regionKey,
        nameNl: r.nameNl,
        nameEn: r.nameEn,
        stability: r.stability,
        controlPercent,
        contestStatus: contestByRegion[r.regionKey] ?? null,
      };
    }),
    season: seasons[0] ?? null,
  };
}

export async function getLeaderboard(): Promise<Array<{ crewId: number; crewName: string; regionsOwned: number }>> {
  await syncContestLifecycle();

  return prisma.$queryRawUnsafe<Array<{ crewId: number; crewName: string; regionsOwned: number }>>(
    `SELECT c.id AS crewId, c.name AS crewName, COUNT(tc.id) AS regionsOwned
     FROM territory_control tc
     JOIN crews c ON c.id = tc.ownerCrewId
     WHERE tc.ownerCrewId IS NOT NULL
     GROUP BY c.id, c.name
     ORDER BY regionsOwned DESC
     LIMIT 20`
  );
}

export async function resolveContest(contestId: number): Promise<{ winnerCrewId: number | null; regionKey: string }> {
  const cfg = await getTerritoryConfig();

  const contests = await prisma.$queryRawUnsafe<ContestRow[]>(
    `SELECT * FROM territory_contests WHERE id = ? AND status IN ('lockdown', 'active') LIMIT 1`,
    contestId,
  );
  const contest = contests[0];
  if (!contest) throw new Error('CONTEST_NOT_FOUND_OR_ALREADY_RESOLVED');

  // Tally points per crew
  const tally = await prisma.$queryRawUnsafe<Array<{ actorCrewId: number; totalPoints: number }>>(
    `SELECT actorCrewId, SUM(pointsDelta) AS totalPoints
     FROM territory_actions
     WHERE contestId = ? AND abuseFlagged = 0
     GROUP BY actorCrewId
     ORDER BY totalPoints DESC`,
    contestId,
  );

  const attackerPoints = tally.find(t => t.actorCrewId === contest.attackerCrewId)?.totalPoints ?? 0;
  const defenderPoints = tally.find(t => t.actorCrewId === (contest.defenderCrewId ?? -1))?.totalPoints ?? 0;
  const totalPoints = attackerPoints + defenderPoints;

  let winnerCrewId: number | null = null;
  const captureThreshold = cfg.captureThresholdPercent;

  if (totalPoints > 0) {
    const attackerPct = (attackerPoints / totalPoints) * 100;
    if (attackerPct >= captureThreshold) {
      winnerCrewId = contest.attackerCrewId;
    } else if (contest.defenderCrewId && (100 - attackerPct) >= captureThreshold) {
      winnerCrewId = contest.defenderCrewId;
    }
  }

  // Transaction-safe resolve using a single statement
  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests SET status = 'resolved', resolvedAt = NOW(), winnerCrewId = ?
     WHERE id = ? AND status IN ('lockdown', 'active')`,
    winnerCrewId, contestId,
  );

  if (winnerCrewId !== null) {
    await prisma.$executeRawUnsafe(
      `UPDATE territory_control SET ownerCrewId = ?, controlJson = ?, stability = 100, updatedAt = NOW()
       WHERE regionKey = ?`,
      winnerCrewId,
      JSON.stringify({ [winnerCrewId]: 100 }),
      contest.regionKey,
    );

    _notifyCrewRegionCaptured(winnerCrewId, contest.regionKey).catch(() => {});
    if (contest.defenderCrewId && contest.defenderCrewId !== winnerCrewId) {
      _notifyCrewRegionLost(contest.defenderCrewId, contest.regionKey).catch(() => {});
    }
  }

  return { winnerCrewId, regionKey: contest.regionKey };
}

// ── Admin Moderation ────────────────────────────────────────────────────────

export async function adminAssignRegion(regionKey: string, crewId: number | null): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control
     SET ownerCrewId = ?, controlJson = ?, stability = 100, updatedAt = NOW()
     WHERE regionKey = ?`,
    crewId,
    crewId ? JSON.stringify({ [crewId]: 100 }) : '{}',
    regionKey,
  );
}

export async function adminResetRegion(regionKey: string): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control SET ownerCrewId = NULL, controlJson = '{}', stability = 100 WHERE regionKey = ?`,
    regionKey,
  );
  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests SET status = 'cancelled' WHERE regionKey = ? AND status NOT IN ('resolved', 'cancelled')`,
    regionKey,
  );
}

export async function adminStartSeason(seasonKey: string, startsAt: Date, endsAt: Date): Promise<void> {
  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_seasons (seasonKey, status, startsAt, endsAt)
     VALUES (?, 'active', ?, ?)
     ON DUPLICATE KEY UPDATE status = 'active', startsAt = ?, endsAt = ?`,
    seasonKey, startsAt, endsAt, startsAt, endsAt,
  );
}

export async function adminCloseSeason(seasonKey: string): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE territory_seasons SET status = 'closed' WHERE seasonKey = ?`,
    seasonKey,
  );
}

// ── Internal Helpers ────────────────────────────────────────────────────────

async function _recalcContestControl(contestId: number, regionKey: string, actorCrewId: number, pointsDelta: number): Promise<void> {
  if (pointsDelta <= 0) return;

  const controlRows = await prisma.$queryRawUnsafe<ControlRow[]>(
    'SELECT * FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  const ctrl = controlRows[0];
  if (!ctrl) return;

  const cpJson = parseJson(ctrl.controlJson);
  const current = Number(cpJson[String(actorCrewId)] ?? 0);
  const updated = Math.min(100, current + pointsDelta);
  cpJson[String(actorCrewId)] = updated;

  // Normalize so other crews lose proportionally
  const total = Object.values(cpJson).reduce<number>((s, v) => s + Number(v), 0);
  if (total > 100) {
    const factor = 100 / total;
    for (const k of Object.keys(cpJson)) {
      cpJson[k] = Math.round(Number(cpJson[k]) * factor);
    }
  }

  await prisma.$executeRawUnsafe(
    'UPDATE territory_control SET controlJson = ?, updatedAt = NOW() WHERE regionKey = ?',
    JSON.stringify(cpJson),
    regionKey,
  );
}

async function _notifyCrewContestStarted(crewId: number, regionKey: string, contestId: number): Promise<void> {
  const players = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    'SELECT playerId AS id FROM crew_members WHERE crewId = ? LIMIT 50',
    crewId,
  );
  for (const p of players) {
    await notificationService.sendToPlayer(
      p.id,
      'Gebied aangevallen! / Region under attack!',
      `Regio ${regionKey} wordt aangevallen (contest #${contestId}).`,
      { type: 'territory_contest_started', regionKey, contestId: String(contestId) },
    ).catch(() => {});
  }
}

async function _notifyCrewRegionCaptured(crewId: number, regionKey: string): Promise<void> {
  const players = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    'SELECT playerId AS id FROM crew_members WHERE crewId = ? LIMIT 50',
    crewId,
  );
  for (const p of players) {
    await notificationService.sendToPlayer(
      p.id,
      'Gebied veroverd! / Region captured!',
      `Jullie crew heeft ${regionKey} veroverd. / Your crew captured ${regionKey}.`,
      { type: 'territory_captured', regionKey },
    ).catch(() => {});
  }
}

async function _notifyCrewRegionLost(crewId: number, regionKey: string): Promise<void> {
  const players = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    'SELECT playerId AS id FROM crew_members WHERE crewId = ? LIMIT 50',
    crewId,
  );
  for (const p of players) {
    await notificationService.sendToPlayer(
      p.id,
      'Gebied verloren! / Region lost!',
      `${regionKey} is overgenomen door een andere crew. / ${regionKey} was taken by another crew.`,
      { type: 'territory_lost', regionKey },
    ).catch(() => {});
  }
}

