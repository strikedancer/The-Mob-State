import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';
import { notificationService } from './notificationService';
import { translationService } from './translationService';

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
    'TERRITORY_PASSIVE_INCOME_INTERVAL_MINUTES',
    'TERRITORY_PASSIVE_INCOME_TIER_1_CASH',
    'TERRITORY_PASSIVE_INCOME_TIER_2_CASH',
    'TERRITORY_PASSIVE_INCOME_TIER_3_CASH',
    'TERRITORY_PASSIVE_INCOME_TIER_4_CASH',
    'TERRITORY_WAR_AFTERMATH_HOURS',
    'TERRITORY_WAR_AFTERMATH_TARGET_ATTACK_BONUS',
    'TERRITORY_WAR_AFTERMATH_ADJACENT_ATTACK_BONUS',
    'TERRITORY_WAR_AFTERMATH_TARGET_STABILITY_PENALTY',
    'TERRITORY_WAR_AFTERMATH_ADJACENT_STABILITY_PENALTY',
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
    passiveIncomeIntervalMinutes: Number(cfg['TERRITORY_PASSIVE_INCOME_INTERVAL_MINUTES'] ?? 60),
    passiveIncomeTier1Cash: Number(cfg['TERRITORY_PASSIVE_INCOME_TIER_1_CASH'] ?? 25000),
    passiveIncomeTier2Cash: Number(cfg['TERRITORY_PASSIVE_INCOME_TIER_2_CASH'] ?? 50000),
    passiveIncomeTier3Cash: Number(cfg['TERRITORY_PASSIVE_INCOME_TIER_3_CASH'] ?? 90000),
    passiveIncomeTier4Cash: Number(cfg['TERRITORY_PASSIVE_INCOME_TIER_4_CASH'] ?? 140000),
    warAftermathHours: Number(cfg['TERRITORY_WAR_AFTERMATH_HOURS'] ?? 6),
    warAftermathTargetAttackBonus: Number(cfg['TERRITORY_WAR_AFTERMATH_TARGET_ATTACK_BONUS'] ?? 3),
    warAftermathAdjacentAttackBonus: Number(cfg['TERRITORY_WAR_AFTERMATH_ADJACENT_ATTACK_BONUS'] ?? 1),
    warAftermathTargetStabilityPenalty: Number(cfg['TERRITORY_WAR_AFTERMATH_TARGET_STABILITY_PENALTY'] ?? 20),
    warAftermathAdjacentStabilityPenalty: Number(cfg['TERRITORY_WAR_AFTERMATH_ADJACENT_STABILITY_PENALTY'] ?? 10),
  };
}

// ── Shared Types ────────────────────────────────────────────────────────────

type TerritoryRow = { id: number; countryCode: string; displayNameNl: string; displayNameEn: string; svgAssetKey: string; enabled: number };
type RegionRow = { id: number; countryCode: string; regionKey: string; nameNl: string; nameEn: string; svgElementId: string; valueTier: number; strategicTagsJson: string | null; neighborsJson: string | null; enabled: number };
type ControlRow = { id: number; regionKey: string; ownerCrewId: number | null; controlJson: string | null; stability: number; lastDecayAt: Date | null; lastIncomeAt: Date | null; updatedAt: Date };
type ContestRow = { id: number; regionKey: string; status: string; attackerCrewId: number; defenderCrewId: number | null; startedAt: Date; activeAt: Date | null; lockdownAt: Date | null; resolveAt: Date | null; resolvedAt: Date | null; winnerCrewId: number | null; metadataJson: string | null };
type SeasonRow = { id: number; seasonKey: string; status: string; startsAt: Date; endsAt: Date; rewardConfigJson: string | null };
type MapContestRow = ContestRow & { attackerCrewName: string | null; defenderCrewName: string | null };
type PassiveIncomeRegionRow = {
  regionKey: string;
  countryCode: string;
  ownerCrewId: number;
  valueTier: number;
  lastIncomeAt: Date | null;
};

type PassiveIncomePayoutRow = {
  regionKey: string;
  countryCode: string;
  ownerCrewId: number;
  valueTier: number;
  payoutCycles: number;
  payoutAmount: number;
  newLastIncomeAt: Date;
};

type RegionEffectRow = {
  id: number;
  regionKey: string;
  effectType: string;
  sourceType: string;
  sourceId: number | null;
  favoredCrewId: number | null;
  affectedCrewId: number | null;
  metadataJson: string | null;
  startsAt: Date;
  endsAt: Date;
  resolvedAt: Date | null;
  createdAt: Date;
  updatedAt: Date;
};

type ActiveWarPressureEffect = {
  effectId: number;
  sourceWarId: number | null;
  favoredCrewId: number | null;
  affectedCrewId: number | null;
  attackBonusPoints: number;
  stabilityPenalty: number;
  regionRole: 'theater' | 'target' | 'adjacent';
  startsAt: Date;
  endsAt: Date;
};

type TerritoryIncomeSnapshot = {
  amountPerInterval: number;
  intervalMinutes: number;
  amountPerHour: number;
  amountPerDay: number;
};

type TerritoryCrewEconomySummary = {
  regionsOwned: number;
  countriesOwned: number;
  incomeIntervalMinutes: number;
  passiveIncomePerInterval: number;
  passiveIncomePerHour: number;
  passiveIncomePerDay: number;
  totalPassiveIncomeEarned: number;
  crewBankBalance: number;
};

const TRAVEL_TO_TERRITORY_COUNTRY_CODE: Record<string, string> = {
  ar: 'ar',
  argentina: 'ar',
  au: 'au',
  australia: 'au',
  be: 'be',
  belgium: 'be',
  br: 'br',
  brazil: 'br',
  ch: 'ch',
  switzerland: 'ch',
  cn: 'cn',
  china: 'cn',
  co: 'co',
  colombia: 'co',
  de: 'de',
  germany: 'de',
  es: 'es',
  spain: 'es',
  fr: 'fr',
  france: 'fr',
  gb: 'gb',
  uk: 'gb',
  unitedkingdom: 'gb',
  united_kingdom: 'gb',
  'united-kingdom': 'gb',
  it: 'it',
  italy: 'it',
  jp: 'jp',
  japan: 'jp',
  mx: 'mx',
  mexico: 'mx',
  nl: 'nl',
  netherlands: 'nl',
  ru: 'ru',
  russia: 'ru',
  tr: 'tr',
  turkey: 'tr',
  us: 'us',
  usa: 'us',
  unitedstates: 'us',
  united_states: 'us',
  'united-states': 'us',
  za: 'za',
  southafrica: 'za',
  south_africa: 'za',
  'south-africa': 'za',
};

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

function parseStringArray(value: string | null | undefined): string[] {
  if (!value) return [];
  try {
    const parsed = JSON.parse(value);
    if (!Array.isArray(parsed)) return [];
    return [...new Set(parsed.map((entry) => String(entry ?? '').trim()).filter(Boolean))];
  } catch {
    return [];
  }
}

function toNumeric(value: unknown): number {
  if (typeof value === 'number') return Number.isFinite(value) ? value : 0;
  if (typeof value === 'bigint') return Number(value);
  const parsed = Number(value ?? 0);
  return Number.isFinite(parsed) ? parsed : 0;
}

function mapTravelCountryToTerritoryCode(currentCountry: string | null | undefined): string | null {
  if (!currentCountry) return null;
  const normalized = currentCountry.trim().toLowerCase();
  if (!normalized) return null;
  return TRAVEL_TO_TERRITORY_COUNTRY_CODE[normalized] ?? null;
}

function assertPlayerInTerritoryCountry(currentCountry: string | null | undefined, regionCountryCode: string): void {
  const territoryCountryCode = mapTravelCountryToTerritoryCode(currentCountry);
  if (!territoryCountryCode || territoryCountryCode !== regionCountryCode.toLowerCase()) {
    throw new Error('ACTION_OUTSIDE_CURRENT_COUNTRY');
  }
}

function getPassiveIncomeCashForTier(
  tier: number,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): number {
  switch (tier) {
    case 1:
      return Math.max(0, cfg.passiveIncomeTier1Cash);
    case 2:
      return Math.max(0, cfg.passiveIncomeTier2Cash);
    case 3:
      return Math.max(0, cfg.passiveIncomeTier3Cash);
    default:
      return Math.max(0, cfg.passiveIncomeTier4Cash);
  }
}

function buildPassiveIncomeSnapshot(
  tier: number,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): TerritoryIncomeSnapshot {
  const intervalMinutes = Math.max(1, cfg.passiveIncomeIntervalMinutes);
  const amountPerInterval = getPassiveIncomeCashForTier(tier, cfg);
  const cyclesPerHour = 60 / intervalMinutes;
  const amountPerHour = Math.round(amountPerInterval * cyclesPerHour);
  return {
    amountPerInterval,
    intervalMinutes,
    amountPerHour,
    amountPerDay: amountPerHour * 24,
  };
}

type StrategicActionBonus = {
  actionType: string;
  bonusPoints: number;
  source: 'strategic-tag' | 'adjacency' | 'war-aftermath';
  labelNl: string;
  labelEn: string;
};

function parseWarPressureEffect(row: RegionEffectRow): ActiveWarPressureEffect | null {
  if (row.effectType !== 'crew_war_aftermath') return null;
  const metadata = parseJson(row.metadataJson);
  const regionRoleRaw = String(metadata.regionRole ?? 'target').trim().toLowerCase();
  const regionRole = regionRoleRaw === 'theater' || regionRoleRaw === 'adjacent' ? regionRoleRaw : 'target';
  return {
    effectId: row.id,
    sourceWarId: row.sourceId == null ? null : Number(row.sourceId),
    favoredCrewId: row.favoredCrewId == null ? null : Number(row.favoredCrewId),
    affectedCrewId: row.affectedCrewId == null ? null : Number(row.affectedCrewId),
    attackBonusPoints: Number(metadata.attackBonusPoints ?? 0),
    stabilityPenalty: Number(metadata.stabilityPenalty ?? 0),
    regionRole,
    startsAt: row.startsAt,
    endsAt: row.endsAt,
  };
}

async function getActiveWarPressureEffects(regionKeys: string[], now: Date): Promise<Record<string, ActiveWarPressureEffect>> {
  if (regionKeys.length === 0) return {};
  const placeholders = regionKeys.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<RegionEffectRow[]>(
    `SELECT *
     FROM territory_region_effects
     WHERE effectType = 'crew_war_aftermath'
       AND resolvedAt IS NULL
       AND startsAt <= ?
       AND endsAt > ?
       AND regionKey IN (${placeholders})
     ORDER BY createdAt DESC`,
    now,
    now,
    ...regionKeys,
  );

  const effectMap: Record<string, ActiveWarPressureEffect> = {};
  for (const row of rows) {
    const effect = parseWarPressureEffect(row);
    if (!effect) continue;
    const current = effectMap[row.regionKey];
    if (!current || effect.stabilityPenalty > current.stabilityPenalty || effect.attackBonusPoints > current.attackBonusPoints) {
      effectMap[row.regionKey] = effect;
    }
  }
  return effectMap;
}

function buildWarPressureActionBonuses(effect: ActiveWarPressureEffect | null): StrategicActionBonus[] {
  if (!effect || effect.attackBonusPoints <= 0) return [];
  return ['intel_scan', 'sabotage', 'raid'].map((actionType) => ({
    actionType,
    bonusPoints: effect.attackBonusPoints,
    source: 'war-aftermath' as const,
    labelNl: 'Nasleep crew war',
    labelEn: 'Crew war aftermath',
  }));
}

function buildStrategicActionBonuses(
  region: RegionRow,
  adjacentOwnedRegions: number,
): StrategicActionBonus[] {
  const bonuses: StrategicActionBonus[] = [];
  const strategicTags = parseStringArray(region.strategicTagsJson).map((tag) => tag.toLowerCase());
  const pushBonus = (
    actionType: string,
    bonusPoints: number,
    labelNl: string,
    labelEn: string,
    source: 'strategic-tag' | 'adjacency' = 'strategic-tag',
  ) => {
    bonuses.push({ actionType, bonusPoints, source, labelNl, labelEn });
  };

  if (strategicTags.includes('capital')) {
    pushBonus('defense', 2, 'Bestuurlijke kern', 'Administrative stronghold');
    pushBonus('patrol', 1, 'Bestuurlijke kern', 'Administrative stronghold');
  }
  if (strategicTags.includes('harbor')) {
    pushBonus('intel_scan', 1, 'Havenroutes', 'Harbor routes');
    pushBonus('supply_run', 1, 'Havenroutes', 'Harbor routes');
  }
  if (strategicTags.includes('industry')) {
    pushBonus('sabotage', 2, 'Industriele infrastructuur', 'Industrial infrastructure');
    pushBonus('supply_run', 1, 'Industriele infrastructuur', 'Industrial infrastructure');
  }
  if (strategicTags.includes('border')) {
    pushBonus('raid', 1, 'Grenscorridor', 'Border corridor');
    pushBonus('patrol', 1, 'Grenscorridor', 'Border corridor');
  }
  if (strategicTags.includes('logistics')) {
    pushBonus('supply_run', 2, 'Logistiek knooppunt', 'Logistics hub');
    pushBonus('raid', 1, 'Logistiek knooppunt', 'Logistics hub');
  }
  if (adjacentOwnedRegions > 0) {
    const adjacencyPoints = Math.min(2, adjacentOwnedRegions);
    pushBonus('patrol', adjacencyPoints, 'Steun uit aangrenzende regio\'s', 'Support from adjacent regions', 'adjacency');
    pushBonus('raid', adjacencyPoints, 'Steun uit aangrenzende regio\'s', 'Support from adjacent regions', 'adjacency');
    pushBonus('defense', adjacencyPoints, 'Steun uit aangrenzende regio\'s', 'Support from adjacent regions', 'adjacency');
  }

  return bonuses;
}

function getActionBonusForType(bonuses: StrategicActionBonus[], actionType: string): number {
  return bonuses
    .filter((bonus) => bonus.actionType === actionType)
    .reduce((sum, bonus) => sum + bonus.bonusPoints, 0);
}

async function getAdjacentOwnedRegionCount(region: RegionRow, crewId: number): Promise<number> {
  const neighbors = parseStringArray(region.neighborsJson);
  if (neighbors.length === 0) return 0;
  const placeholders = neighbors.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt
     FROM territory_control
     WHERE ownerCrewId = ? AND regionKey IN (${placeholders})`,
    crewId,
    ...neighbors,
  );
  return toNumeric(rows[0]?.cnt ?? 0);
}

async function processPassiveTerritoryIncome(
  now: Date,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): Promise<void> {
  const intervalMinutes = Math.max(1, cfg.passiveIncomeIntervalMinutes);
  const intervalMs = intervalMinutes * 60 * 1000;
  const seasons = await prisma.$queryRawUnsafe<SeasonRow[]>(
    `SELECT * FROM territory_seasons WHERE status = 'active' ORDER BY startsAt DESC LIMIT 1`,
  );
  const seasonKey = seasons[0]?.seasonKey ?? 'territory-open';

  const rows = await prisma.$queryRawUnsafe<PassiveIncomeRegionRow[]>(
    `SELECT tc.regionKey, tr.countryCode, tc.ownerCrewId, tr.valueTier, tc.lastIncomeAt
     FROM territory_control tc
     JOIN territory_regions tr ON tr.regionKey = tc.regionKey
     WHERE tc.ownerCrewId IS NOT NULL AND tr.enabled = 1`,
  );

  const payoutsByCrew = new Map<number, { totalPayoutAmount: number; rows: PassiveIncomePayoutRow[] }>();

  for (const row of rows) {
    const lastIncomeAt = row.lastIncomeAt ?? now;
    const elapsedMs = now.getTime() - lastIncomeAt.getTime();
    const payoutCycles = Math.floor(elapsedMs / intervalMs);
    if (payoutCycles <= 0) {
      continue;
    }

    const amountPerCycle = getPassiveIncomeCashForTier(toNumeric(row.valueTier), cfg);
    const payoutAmount = payoutCycles * amountPerCycle;
    const newLastIncomeAt = new Date(lastIncomeAt.getTime() + (payoutCycles * intervalMs));

    const ownerCrewId = toNumeric(row.ownerCrewId);
    const crewPayout = payoutsByCrew.get(ownerCrewId) ?? { totalPayoutAmount: 0, rows: [] };
    crewPayout.totalPayoutAmount += payoutAmount;
    crewPayout.rows.push({
      regionKey: row.regionKey,
      countryCode: row.countryCode,
      ownerCrewId,
      valueTier: toNumeric(row.valueTier),
      payoutCycles,
      payoutAmount,
      newLastIncomeAt,
    });
    payoutsByCrew.set(ownerCrewId, crewPayout);
  }

  for (const [ownerCrewId, crewPayout] of payoutsByCrew.entries()) {
    await prisma.$transaction(async (tx) => {
      if (crewPayout.totalPayoutAmount > 0) {
        await tx.$executeRawUnsafe(
          `UPDATE crews SET bankBalance = bankBalance + ? WHERE id = ?`,
          crewPayout.totalPayoutAmount,
          ownerCrewId,
        );
      }

      for (const payout of crewPayout.rows) {
        if (payout.payoutAmount > 0) {
          await tx.$executeRawUnsafe(
            `INSERT INTO territory_reward_log (seasonKey, crewId, playerId, rewardType, cashAmount, xpAmount, metadataJson)
             VALUES (?, ?, NULL, 'passive_income', ?, 0, ?)`,
            seasonKey,
            ownerCrewId,
            payout.payoutAmount,
            JSON.stringify({
              regionKey: payout.regionKey,
              countryCode: payout.countryCode,
              valueTier: payout.valueTier,
              payoutCycles: payout.payoutCycles,
              intervalMinutes,
              source: 'territory_passive_income',
            }),
          );
        }

        await tx.$executeRawUnsafe(
          `UPDATE territory_control
           SET lastIncomeAt = ?, updatedAt = updatedAt
           WHERE regionKey = ? AND ownerCrewId = ?`,
          payout.newLastIncomeAt,
          payout.regionKey,
          ownerCrewId,
        );
      }
    });
  }
}

export async function getCrewEconomySummary(crewId: number): Promise<TerritoryCrewEconomySummary> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  const [controlledRows, rewardRows, crew] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{ regionKey: string; countryCode: string; valueTier: number }>>(
      `SELECT tr.regionKey, tr.countryCode, tr.valueTier
       FROM territory_control tc
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       WHERE tc.ownerCrewId = ? AND tr.enabled = 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ totalCash: number }>>(
      `SELECT COALESCE(SUM(cashAmount), 0) AS totalCash
       FROM territory_reward_log
       WHERE crewId = ? AND rewardType = 'passive_income'`,
      crewId,
    ),
    prisma.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    }),
  ]);

  const countriesOwned = new Set(controlledRows.map((row) => row.countryCode)).size;
  const passiveIncomePerInterval = controlledRows.reduce((sum, row) => {
    return sum + buildPassiveIncomeSnapshot(toNumeric(row.valueTier), cfg).amountPerInterval;
  }, 0);
  const cyclesPerHour = 60 / Math.max(1, cfg.passiveIncomeIntervalMinutes);
  const passiveIncomePerHour = Math.round(passiveIncomePerInterval * cyclesPerHour);

  return {
    regionsOwned: controlledRows.length,
    countriesOwned,
    incomeIntervalMinutes: Math.max(1, cfg.passiveIncomeIntervalMinutes),
    passiveIncomePerInterval,
    passiveIncomePerHour,
    passiveIncomePerDay: passiveIncomePerHour * 24,
    totalPassiveIncomeEarned: toNumeric(rewardRows[0]?.totalCash ?? 0),
    crewBankBalance: toNumeric(crew?.bankBalance ?? 0),
  };
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

  await processPassiveTerritoryIncome(now, cfg);
}

export async function processPendingTerritoryContests(now: Date = new Date()): Promise<void> {
  await syncContestLifecycle(now);
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
    passiveIncomeIntervalMinutes: number;
    passiveIncomeCash: number;
    passiveIncomeCashHourly: number;
    passiveIncomeCashDaily: number;
    strategicTags: string[];
    neighbors: string[];
    adjacentOwnedRegions: number;
    effectiveStability: number;
    activeWarPressure: {
      favoredCrewId: number | null;
      favoredCrewName: string | null;
      affectedCrewId: number | null;
      affectedCrewName: string | null;
      attackBonusPoints: number;
      stabilityPenalty: number;
      regionRole: 'theater' | 'target' | 'adjacent';
      endsAt: Date;
    } | null;
    strategicActionBonuses: StrategicActionBonus[];
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

  const activeWarPressureByRegion = await getActiveWarPressureEffects(
    regions.map((region) => region.regionKey),
    now,
  );

  // Build owner crew name lookup from crew ids
  const ownerIds = [...new Set([
    ...controls.filter(c => c.ownerCrewId).map(c => c.ownerCrewId!),
    ...Object.values(activeWarPressureByRegion)
      .flatMap((effect) => [effect.favoredCrewId, effect.affectedCrewId])
      .filter((crewId): crewId is number => crewId !== null),
  ])];
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
    const incomeSnapshot = buildPassiveIncomeSnapshot(r.valueTier, cfg);
    const strategicTags = parseStringArray(r.strategicTagsJson);
    const neighbors = parseStringArray(r.neighborsJson);
    const adjacentOwnedRegions = viewer?.viewerCrewId == null
      ? 0
      : neighbors.reduce((count, neighborKey) => {
          const neighborControl = controlMap[neighborKey];
          return count + (neighborControl?.ownerCrewId === viewer.viewerCrewId ? 1 : 0);
        }, 0);
    const rawWarPressure = activeWarPressureByRegion[r.regionKey] ?? null;
    const activeWarPressure = rawWarPressure && (ctrl?.ownerCrewId === rawWarPressure.affectedCrewId || contest?.defenderCrewId === rawWarPressure.affectedCrewId)
      ? {
          ...rawWarPressure,
          favoredCrewName: rawWarPressure.favoredCrewId == null ? null : (crewNameMap[rawWarPressure.favoredCrewId] ?? null),
          affectedCrewName: rawWarPressure.affectedCrewId == null ? null : (crewNameMap[rawWarPressure.affectedCrewId] ?? null),
        }
      : null;
    const strategicActionBonuses = [
      ...buildStrategicActionBonuses(r, adjacentOwnedRegions),
      ...(viewer?.viewerCrewId != null && activeWarPressure?.favoredCrewId === viewer.viewerCrewId
        ? buildWarPressureActionBonuses(activeWarPressure)
        : []),
    ];
    const effectiveStability = Math.max(0, (ctrl?.stability ?? 100) - (activeWarPressure?.stabilityPenalty ?? 0));
    return {
      ...r,
      ownerCrewId: ctrl?.ownerCrewId ?? null,
      ownerCrewName: ctrl?.ownerCrewId ? (crewNameMap[ctrl.ownerCrewId] ?? null) : null,
      controlPercent,
      stability: ctrl?.stability ?? 100,
      effectiveStability,
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
      passiveIncomeIntervalMinutes: incomeSnapshot.intervalMinutes,
      passiveIncomeCash: incomeSnapshot.amountPerInterval,
      passiveIncomeCashHourly: incomeSnapshot.amountPerHour,
      passiveIncomeCashDaily: incomeSnapshot.amountPerDay,
      strategicTags,
      neighbors,
      adjacentOwnedRegions,
      activeWarPressure,
      strategicActionBonuses,
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
  return {
    config: cfg,
    activeSeason: seasons[0] ?? null,
    leaderboard: leaderboard.map((entry) => ({
      crewId: toNumeric(entry.crewId),
      crewName: entry.crewName,
      regionsOwned: toNumeric(entry.regionsOwned),
      totalControl: toNumeric(entry.totalControl),
    })),
  };
}

export async function getAdminOverview(): Promise<{
  config: Awaited<ReturnType<typeof getTerritoryConfig>>;
  activeSeason: SeasonRow | null;
  seasons: SeasonRow[];
  countries: TerritoryRow[];
  crews: Array<{ id: number; name: string }>;
  leaderboard: Array<{ crewId: number; crewName: string; regionsOwned: number; totalControl: number }>;
  summary: {
    enabledCountries: number;
    enabledRegions: number;
    activeContests: number;
    controlledRegions: number;
  };
  contests: Array<{
    id: number;
    regionKey: string;
    regionNameNl: string;
    countryCode: string;
    status: string;
    attackerCrewId: number;
    attackerCrewName: string | null;
    defenderCrewId: number | null;
    defenderCrewName: string | null;
    winnerCrewId: number | null;
    winnerCrewName: string | null;
    startedAt: Date;
    activeAt: Date | null;
    lockdownAt: Date | null;
    resolveAt: Date | null;
    resolvedAt: Date | null;
  }>;
  regions: Array<{
    regionKey: string;
    countryCode: string;
    nameNl: string;
    nameEn: string;
    svgElementId: string;
    valueTier: number;
    ownerCrewId: number | null;
    ownerCrewName: string | null;
    stability: number;
    activeContestId: number | null;
    activeContestStatus: string | null;
  }>;
}> {
  await syncContestLifecycle();

  const [cfg, seasons, countries, crews, leaderboard, contestRows, regionRows] = await Promise.all([
    getTerritoryConfig(),
    prisma.$queryRawUnsafe<SeasonRow[]>(
      `SELECT * FROM territory_seasons ORDER BY startsAt DESC LIMIT 8`,
    ),
    getCountries(),
    prisma.$queryRawUnsafe<Array<{ id: number; name: string }>>(
      `SELECT id, name FROM crews ORDER BY name ASC`,
    ),
    prisma.$queryRawUnsafe<Array<{ crewId: number; crewName: string; regionsOwned: number; totalControl: number }>>(
      `SELECT c.id AS crewId, c.name AS crewName, COUNT(tc.id) AS regionsOwned, 0 AS totalControl
       FROM territory_control tc
       JOIN crews c ON c.id = tc.ownerCrewId
       WHERE tc.ownerCrewId IS NOT NULL
       GROUP BY c.id, c.name
       ORDER BY regionsOwned DESC, c.name ASC
       LIMIT 20`,
    ),
    prisma.$queryRawUnsafe<Array<{
      id: number;
      regionKey: string;
      regionNameNl: string;
      countryCode: string;
      status: string;
      attackerCrewId: number;
      attackerCrewName: string | null;
      defenderCrewId: number | null;
      defenderCrewName: string | null;
      winnerCrewId: number | null;
      winnerCrewName: string | null;
      startedAt: Date;
      activeAt: Date | null;
      lockdownAt: Date | null;
      resolveAt: Date | null;
      resolvedAt: Date | null;
    }>>(
      `SELECT tc.id,
              tc.regionKey,
              tr.nameNl AS regionNameNl,
              tr.countryCode,
              tc.status,
              tc.attackerCrewId,
              attacker.name AS attackerCrewName,
              tc.defenderCrewId,
              defender.name AS defenderCrewName,
              tc.winnerCrewId,
              winner.name AS winnerCrewName,
              tc.startedAt,
              tc.activeAt,
              tc.lockdownAt,
              tc.resolveAt,
              tc.resolvedAt
       FROM territory_contests tc
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       LEFT JOIN crews attacker ON attacker.id = tc.attackerCrewId
       LEFT JOIN crews defender ON defender.id = tc.defenderCrewId
       LEFT JOIN crews winner ON winner.id = tc.winnerCrewId
       ORDER BY tc.startedAt DESC
       LIMIT 25`,
    ),
    prisma.$queryRawUnsafe<Array<{
      regionKey: string;
      countryCode: string;
      nameNl: string;
      nameEn: string;
      svgElementId: string;
      valueTier: number;
      ownerCrewId: number | null;
      ownerCrewName: string | null;
      stability: number;
      activeContestId: number | null;
      activeContestStatus: string | null;
    }>>(
      `SELECT tr.regionKey,
              tr.countryCode,
              tr.nameNl,
              tr.nameEn,
              tr.svgElementId,
              tr.valueTier,
              ctrl.ownerCrewId,
              owner.name AS ownerCrewName,
              ctrl.stability,
              contest.id AS activeContestId,
              contest.status AS activeContestStatus
       FROM territory_regions tr
       LEFT JOIN territory_control ctrl ON ctrl.regionKey = tr.regionKey
       LEFT JOIN crews owner ON owner.id = ctrl.ownerCrewId
       LEFT JOIN territory_contests contest
         ON contest.regionKey = tr.regionKey
        AND contest.status NOT IN ('resolved', 'cancelled')
       WHERE tr.enabled = 1
       ORDER BY tr.countryCode ASC, tr.nameNl ASC`,
    ),
  ]);

  return {
    config: cfg,
    activeSeason: seasons.find((season) => season.status === 'active') ?? null,
    seasons,
    countries,
    crews: crews.map((crew) => ({ id: toNumeric(crew.id), name: crew.name })),
    leaderboard: leaderboard.map((entry) => ({
      crewId: toNumeric(entry.crewId),
      crewName: entry.crewName,
      regionsOwned: toNumeric(entry.regionsOwned),
      totalControl: toNumeric(entry.totalControl),
    })),
    summary: {
      enabledCountries: countries.length,
      enabledRegions: regionRows.length,
      activeContests: contestRows.filter((contest) => !['resolved', 'cancelled'].includes(contest.status)).length,
      controlledRegions: regionRows.filter((region) => region.ownerCrewId != null).length,
    },
    contests: contestRows.map((contest) => ({
      ...contest,
      id: toNumeric(contest.id),
      attackerCrewId: toNumeric(contest.attackerCrewId),
      defenderCrewId: contest.defenderCrewId == null ? null : toNumeric(contest.defenderCrewId),
      winnerCrewId: contest.winnerCrewId == null ? null : toNumeric(contest.winnerCrewId),
    })),
    regions: regionRows.map((region) => ({
      ...region,
      valueTier: toNumeric(region.valueTier),
      ownerCrewId: region.ownerCrewId == null ? null : toNumeric(region.ownerCrewId),
      stability: toNumeric(region.stability),
      activeContestId: region.activeContestId == null ? null : toNumeric(region.activeContestId),
    })),
  };
}

export async function startContest(
  playerId: number,
  crewId: number,
  regionKey: string,
  currentCountry: string | null | undefined,
): Promise<{
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
  assertPlayerInTerritoryCountry(currentCountry, regions[0].countryCode);

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
    contestId: toNumeric(contestId),
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
  currentCountry: string | null | undefined,
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

  const contestRegions = await prisma.$queryRawUnsafe<RegionRow[]>(
    'SELECT * FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    contest.regionKey,
  );
  const contestRegion = contestRegions[0];
  if (!contestRegion) throw new Error('REGION_NOT_FOUND');
  assertPlayerInTerritoryCountry(currentCountry, contestRegion.countryCode);

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
  const adjacentOwnedRegions = await getAdjacentOwnedRegionCount(contestRegion, crewId);
  const strategicActionBonuses = buildStrategicActionBonuses(contestRegion, adjacentOwnedRegions);
  const activeWarPressure = (await getActiveWarPressureEffects([contest.regionKey], new Date()))[contest.regionKey] ?? null;
  const warPressureApplies = activeWarPressure
    && activeWarPressure.favoredCrewId === crewId
    && attackerActions.has(actionType)
    && contest.defenderCrewId === activeWarPressure.affectedCrewId;
  const warPressureBonuses = warPressureApplies ? buildWarPressureActionBonuses(activeWarPressure) : [];
  const allActionBonuses = [...strategicActionBonuses, ...warPressureBonuses];
  const actionBonusPoints = getActionBonusForType(allActionBonuses, actionType);
  const pointsDelta = abuseFlagged ? 0 : ((ACTION_POINTS[actionType] ?? 4) + actionBonusPoints);
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
    adjacentOwnedRegions,
    actionBonusPoints,
    strategicActionBonuses: allActionBonuses
      .filter((bonus) => bonus.actionType == actionType)
      .map((bonus) => ({
        bonusPoints: bonus.bonusPoints,
        source: bonus.source,
        labelNl: bonus.labelNl,
        labelEn: bonus.labelEn,
      })),
    message: abuseFlagged ? 'ANTI_FARM_LIMITED' : 'ACTION_OK',
  };
}

export async function defendContest(
  playerId: number,
  crewId: number,
  contestId: number,
  currentCountry: string | null | undefined,
): Promise<void> {
  await syncContestLifecycle();

  const contests = await prisma.$queryRawUnsafe<ContestRow[]>(
    `SELECT * FROM territory_contests WHERE id = ? AND defenderCrewId = ? LIMIT 1`,
    contestId, crewId,
  );
  if (!contests[0]) throw new Error('CONTEST_NOT_FOUND');
  const contestRegions = await prisma.$queryRawUnsafe<RegionRow[]>(
    'SELECT * FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    contests[0].regionKey,
  );
  const contestRegion = contestRegions[0];
  if (!contestRegion) throw new Error('REGION_NOT_FOUND');
  assertPlayerInTerritoryCountry(currentCountry, contestRegion.countryCode);
  if (contests[0].status !== 'preparing' && contests[0].status !== 'active') {
    throw new Error('CONTEST_NOT_JOINABLE');
  }
  // Defender has joined — no extra state needed; they do actions via doAction
}

export async function getCrewTerritory(crewId: number): Promise<{
  regions: Array<{ regionKey: string; nameNl: string; nameEn: string; stability: number; controlPercent: number; contestStatus: string | null }>;
  season: SeasonRow | null;
  summary: TerritoryCrewEconomySummary;
}> {
  await syncContestLifecycle();

  const [controlled, seasons, summary] = await Promise.all([
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
    getCrewEconomySummary(crewId),
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
    summary,
  };
}

export async function getLeaderboard(): Promise<Array<{ crewId: number; crewName: string; regionsOwned: number }>> {
  await syncContestLifecycle();

  const leaderboard = await prisma.$queryRawUnsafe<Array<{ crewId: number; crewName: string; regionsOwned: number }>>(
    `SELECT c.id AS crewId, c.name AS crewName, COUNT(tc.id) AS regionsOwned
     FROM territory_control tc
     JOIN crews c ON c.id = tc.ownerCrewId
     WHERE tc.ownerCrewId IS NOT NULL
     GROUP BY c.id, c.name
     ORDER BY regionsOwned DESC
     LIMIT 20`
  );

  return leaderboard.map((entry) => ({
    crewId: toNumeric(entry.crewId),
    crewName: entry.crewName,
    regionsOwned: toNumeric(entry.regionsOwned),
  }));
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

  const attackerPoints = toNumeric(tally.find(t => t.actorCrewId === contest.attackerCrewId)?.totalPoints ?? 0);
  const defenderPoints = toNumeric(tally.find(t => t.actorCrewId === (contest.defenderCrewId ?? -1))?.totalPoints ?? 0);
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
      `UPDATE territory_control SET ownerCrewId = ?, controlJson = ?, stability = 100, lastIncomeAt = NOW(), updatedAt = NOW()
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
     SET ownerCrewId = ?, controlJson = ?, stability = 100, lastIncomeAt = NOW(), updatedAt = NOW()
     WHERE regionKey = ?`,
    crewId,
    crewId ? JSON.stringify({ [crewId]: 100 }) : '{}',
    regionKey,
  );
}

export async function adminResetRegion(regionKey: string): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control SET ownerCrewId = NULL, controlJson = '{}', stability = 100, lastIncomeAt = NOW() WHERE regionKey = ?`,
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
  const players = await _getCrewPlayers(crewId);
  for (const p of players) {
    await notificationService.sendToPlayer(
      p.id,
      'Gebied aangevallen! / Region under attack!',
      `Regio ${regionKey} wordt aangevallen (contest #${contestId}).`,
      { type: 'territory_contest_started', regionKey, contestId: String(contestId) },
    ).catch(() => {});
    await _sendTerritoryInboxMessage(
      p.id,
      (language) => language === 'nl'
        ? [
            'Gebied aangevallen!',
            '',
            `Regio: ${regionKey}`,
            `Contest: #${contestId}`,
            'Een andere crew heeft een territoriumaanval gestart.',
          ].join('\n')
        : [
            'Region under attack!',
            '',
            `Region: ${regionKey}`,
            `Contest: #${contestId}`,
            'Another crew has started a territory attack.',
          ].join('\n'),
    ).catch(() => {});
  }
}

async function _notifyCrewRegionCaptured(crewId: number, regionKey: string): Promise<void> {
  const players = await _getCrewPlayers(crewId);
  for (const p of players) {
    await notificationService.sendToPlayer(
      p.id,
      'Gebied veroverd! / Region captured!',
      `Jullie crew heeft ${regionKey} veroverd. / Your crew captured ${regionKey}.`,
      { type: 'territory_captured', regionKey },
    ).catch(() => {});
    await _sendTerritoryInboxMessage(
      p.id,
      (language) => language === 'nl'
        ? [
            'Gebied veroverd!',
            '',
            `Regio: ${regionKey}`,
            'Jullie crew heeft deze regio succesvol overgenomen.',
          ].join('\n')
        : [
            'Region captured!',
            '',
            `Region: ${regionKey}`,
            'Your crew successfully captured this region.',
          ].join('\n'),
    ).catch(() => {});
  }
}

async function _notifyCrewRegionLost(crewId: number, regionKey: string): Promise<void> {
  const players = await _getCrewPlayers(crewId);
  for (const p of players) {
    await notificationService.sendToPlayer(
      p.id,
      'Gebied verloren! / Region lost!',
      `${regionKey} is overgenomen door een andere crew. / ${regionKey} was taken by another crew.`,
      { type: 'territory_lost', regionKey },
    ).catch(() => {});
    await _sendTerritoryInboxMessage(
      p.id,
      (language) => language === 'nl'
        ? [
            'Gebied verloren!',
            '',
            `Regio: ${regionKey}`,
            'Deze regio is overgenomen door een andere crew.',
          ].join('\n')
        : [
            'Region lost!',
            '',
            `Region: ${regionKey}`,
            'This region was taken by another crew.',
          ].join('\n'),
    ).catch(() => {});
  }
}

async function _getCrewPlayers(crewId: number): Promise<Array<{ id: number }>> {
  return prisma.$queryRawUnsafe<Array<{ id: number }>>(
    'SELECT playerId AS id FROM crew_members WHERE crewId = ? LIMIT 50',
    crewId,
  );
}

async function _sendTerritoryInboxMessage(
  playerId: number,
  buildMessage: (language: string) => string,
): Promise<void> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  const language = translationService.getPlayerLanguage(player ?? {});
  await directMessageService.sendSystemMessage(playerId, buildMessage(language), {
    sendPush: false,
    senderName: 'Territory Control',
  });
}

