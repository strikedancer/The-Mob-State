import prisma from '../lib/prisma';
import { getCrewStorageCapacity } from './crewBuildingService';
import { directMessageService } from './directMessageService';
import { notificationService } from './notificationService';
import { translationService, type Language } from './translationService';
import * as territoryProjectService from './territoryProjectService';
import * as territoryMetaService from './territoryMetaService';
import * as territoryCrewStatsService from './territoryCrewStatsService';
import { ensureCurrentTerritorySeason } from '../startup/ensureTerritorySchema';

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
    'TERRITORY_HQ_REGION_CAP_PER_LEVEL',
    'TERRITORY_HQ_REGION_CAP_BONUS_CAP',
    'TERRITORY_HQ_CONTEST_CAP_PER_LEVEL',
    'TERRITORY_HQ_CONTEST_CAP_BONUS_CAP',
    'TERRITORY_HQ_ACTION_POINT_BONUS_PER_LEVEL',
    'TERRITORY_HQ_ACTION_POINT_BONUS_CAP',
    'TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_PER_LEVEL',
    'TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_CAP',
    'TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL',
    'TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL',
    'TERRITORY_CAR_STORAGE_RAID_BONUS_PER_LEVEL',
    'TERRITORY_BOAT_STORAGE_SUPPLY_BONUS_PER_LEVEL',
    'TERRITORY_DRUG_STORAGE_SABOTAGE_BONUS_PER_LEVEL',
    'TERRITORY_BUILDING_ACTION_BONUS_CAP',
    'TERRITORY_ACTION_UNLOCK_HQ_LEVEL_PATROL',
    'TERRITORY_ACTION_UNLOCK_HQ_LEVEL_INTEL_SCAN',
    'TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SABOTAGE',
    'TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SUPPLY_RUN',
    'TERRITORY_ACTION_UNLOCK_HQ_LEVEL_RAID',
    'TERRITORY_ACTION_UNLOCK_HQ_LEVEL_DEFENSE',
    'TERRITORY_PROJECT_SAFEHOUSE_MIN_HQ_LEVEL',
    'TERRITORY_PROJECT_SAFEHOUSE_INCOME_BONUS_PERCENT',
    'TERRITORY_PROJECT_SURVEILLANCE_MIN_HQ_LEVEL',
    'TERRITORY_PROJECT_SURVEILLANCE_INTEL_BONUS_POINTS',
    'TERRITORY_PROJECT_SURVEILLANCE_INTEL_COOLDOWN_PERCENT',
    'TERRITORY_PROJECT_ARMS_CACHE_MIN_HQ_LEVEL',
    'TERRITORY_PROJECT_ARMS_CACHE_RAID_BONUS_POINTS',
    'TERRITORY_PROJECT_ARMS_CACHE_DEFENSE_BONUS_POINTS',
    'TERRITORY_PROJECT_CONTRIBUTE_PROGRESS',
    'TERRITORY_PROJECT_CONTRIBUTE_COOLDOWN_SECONDS',
    'TERRITORY_PROJECT_SABOTAGE_HP_DAMAGE',
    'TERRITORY_PROJECT_SUPPLY_REPAIR_HP',
    'TERRITORY_PROJECT_SUPPLY_BUILD_PROGRESS',
    'TERRITORY_REGION_EVENT_ENABLED',
    'TERRITORY_REGION_EVENT_ROTATION_HOURS',
    'TERRITORY_REGION_EVENT_ACTIVE_COUNT',
    'TERRITORY_REGION_EVENT_ATTACK_BONUS_POINTS',
    'TERRITORY_REGION_EVENT_INCOME_PENALTY_PERCENT',
  ];
  const cfg = await getRuntimeConfig(keys);
  const actionUnlockHqLevels = {
    patrol: Number(cfg['TERRITORY_ACTION_UNLOCK_HQ_LEVEL_PATROL'] ?? 0),
    intel_scan: Number(cfg['TERRITORY_ACTION_UNLOCK_HQ_LEVEL_INTEL_SCAN'] ?? 2),
    sabotage: Number(cfg['TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SABOTAGE'] ?? 6),
    supply_run: Number(cfg['TERRITORY_ACTION_UNLOCK_HQ_LEVEL_SUPPLY_RUN'] ?? 2),
    raid: Number(cfg['TERRITORY_ACTION_UNLOCK_HQ_LEVEL_RAID'] ?? 8),
    defense: Number(cfg['TERRITORY_ACTION_UNLOCK_HQ_LEVEL_DEFENSE'] ?? 4),
  } as const;
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
    hqRegionCapPerLevel: Number(cfg['TERRITORY_HQ_REGION_CAP_PER_LEVEL'] ?? 0.2),
    hqRegionCapBonusCap: Number(cfg['TERRITORY_HQ_REGION_CAP_BONUS_CAP'] ?? 3),
    hqContestCapPerLevel: Number(cfg['TERRITORY_HQ_CONTEST_CAP_PER_LEVEL'] ?? 0.1),
    hqContestCapBonusCap: Number(cfg['TERRITORY_HQ_CONTEST_CAP_BONUS_CAP'] ?? 2),
    hqActionPointBonusPerLevel: Number(cfg['TERRITORY_HQ_ACTION_POINT_BONUS_PER_LEVEL'] ?? 0.12),
    hqActionPointBonusCap: Number(cfg['TERRITORY_HQ_ACTION_POINT_BONUS_CAP'] ?? 2),
    crewMissionActionPointBonusPerLevel: Number(cfg['TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_PER_LEVEL'] ?? 0.1),
    crewMissionActionPointBonusCap: Number(cfg['TERRITORY_CREW_MISSION_LEVEL_ACTION_POINT_BONUS_CAP'] ?? 2),
    weaponStorageDefenseBonusPerLevel: Number(cfg['TERRITORY_WEAPON_STORAGE_DEFENSE_BONUS_PER_LEVEL'] ?? 0.18),
    ammoStorageDefenseBonusPerLevel: Number(cfg['TERRITORY_AMMO_STORAGE_DEFENSE_BONUS_PER_LEVEL'] ?? 0.16),
    carStorageRaidBonusPerLevel: Number(cfg['TERRITORY_CAR_STORAGE_RAID_BONUS_PER_LEVEL'] ?? 0.15),
    boatStorageSupplyBonusPerLevel: Number(cfg['TERRITORY_BOAT_STORAGE_SUPPLY_BONUS_PER_LEVEL'] ?? 0.15),
    drugStorageSabotageBonusPerLevel: Number(cfg['TERRITORY_DRUG_STORAGE_SABOTAGE_BONUS_PER_LEVEL'] ?? 0.15),
    buildingActionBonusCap: Number(cfg['TERRITORY_BUILDING_ACTION_BONUS_CAP'] ?? 3),
    actionUnlockHqLevels,
    actionUnlockHqLevelPatrol: actionUnlockHqLevels.patrol,
    actionUnlockHqLevelIntelScan: actionUnlockHqLevels.intel_scan,
    actionUnlockHqLevelSabotage: actionUnlockHqLevels.sabotage,
    actionUnlockHqLevelSupplyRun: actionUnlockHqLevels.supply_run,
    actionUnlockHqLevelRaid: actionUnlockHqLevels.raid,
    actionUnlockHqLevelDefense: actionUnlockHqLevels.defense,
    projectSafehouseMinHqLevel: Number(cfg['TERRITORY_PROJECT_SAFEHOUSE_MIN_HQ_LEVEL'] ?? 4),
    projectSafehouseIncomeBonusPercent: Number(cfg['TERRITORY_PROJECT_SAFEHOUSE_INCOME_BONUS_PERCENT'] ?? 10),
    projectSurveillanceMinHqLevel: Number(cfg['TERRITORY_PROJECT_SURVEILLANCE_MIN_HQ_LEVEL'] ?? 5),
    projectSurveillanceIntelBonusPoints: Number(cfg['TERRITORY_PROJECT_SURVEILLANCE_INTEL_BONUS_POINTS'] ?? 2),
    projectSurveillanceIntelCooldownPercent: Number(cfg['TERRITORY_PROJECT_SURVEILLANCE_INTEL_COOLDOWN_PERCENT'] ?? 75),
    projectArmsCacheMinHqLevel: Number(cfg['TERRITORY_PROJECT_ARMS_CACHE_MIN_HQ_LEVEL'] ?? 6),
    projectArmsCacheRaidBonusPoints: Number(cfg['TERRITORY_PROJECT_ARMS_CACHE_RAID_BONUS_POINTS'] ?? 2),
    projectArmsCacheDefenseBonusPoints: Number(cfg['TERRITORY_PROJECT_ARMS_CACHE_DEFENSE_BONUS_POINTS'] ?? 2),
    projectContributeProgress: Number(cfg['TERRITORY_PROJECT_CONTRIBUTE_PROGRESS'] ?? 20),
    projectContributeCooldownSeconds: Number(cfg['TERRITORY_PROJECT_CONTRIBUTE_COOLDOWN_SECONDS'] ?? 900),
    projectSabotageHpDamage: Number(cfg['TERRITORY_PROJECT_SABOTAGE_HP_DAMAGE'] ?? 20),
    projectSupplyRepairHp: Number(cfg['TERRITORY_PROJECT_SUPPLY_REPAIR_HP'] ?? 15),
    projectSupplyBuildProgress: Number(cfg['TERRITORY_PROJECT_SUPPLY_BUILD_PROGRESS'] ?? 15),
    regionEventEnabled: Number(cfg['TERRITORY_REGION_EVENT_ENABLED'] ?? 1) === 1,
    regionEventRotationHours: Number(cfg['TERRITORY_REGION_EVENT_ROTATION_HOURS'] ?? 12),
    regionEventActiveCount: Number(cfg['TERRITORY_REGION_EVENT_ACTIVE_COUNT'] ?? 2),
    regionEventAttackBonusPoints: Number(cfg['TERRITORY_REGION_EVENT_ATTACK_BONUS_POINTS'] ?? 2),
    regionEventIncomePenaltyPercent: Number(cfg['TERRITORY_REGION_EVENT_INCOME_PENALTY_PERCENT'] ?? 15),
  };
}

export type ViewerTerritoryCaps = {
  hqGlobalLevel: number;
  ownedRegions: number;
  activeContests: number;
  baseMaxRegions: number;
  effectiveMaxRegions: number;
  baseMaxContests: number;
  effectiveMaxContests: number;
  hqRegionBonus: number;
  hqContestBonus: number;
  projectSafehouseMinHqLevel: number;
};

function getProjectConfig(
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): territoryProjectService.TerritoryProjectConfig {
  return {
    safehouseMinHqLevel: Math.max(0, Math.floor(cfg.projectSafehouseMinHqLevel)),
    safehouseIncomeBonusPercent: Math.max(0, Math.floor(cfg.projectSafehouseIncomeBonusPercent)),
    surveillanceMinHqLevel: Math.max(0, Math.floor(cfg.projectSurveillanceMinHqLevel)),
    surveillanceIntelBonusPoints: Math.max(0, Math.floor(cfg.projectSurveillanceIntelBonusPoints)),
    surveillanceIntelCooldownPercent: Math.min(
      100,
      Math.max(25, Math.floor(cfg.projectSurveillanceIntelCooldownPercent)),
    ),
    armsCacheMinHqLevel: Math.max(0, Math.floor(cfg.projectArmsCacheMinHqLevel)),
    armsCacheRaidBonusPoints: Math.max(0, Math.floor(cfg.projectArmsCacheRaidBonusPoints)),
    armsCacheDefenseBonusPoints: Math.max(0, Math.floor(cfg.projectArmsCacheDefenseBonusPoints)),
    contributeProgress: Math.max(1, Math.floor(cfg.projectContributeProgress)),
    contributeCooldownSeconds: Math.max(0, Math.floor(cfg.projectContributeCooldownSeconds)),
    sabotageHpDamage: Math.max(1, Math.floor(cfg.projectSabotageHpDamage)),
    supplyRepairHp: Math.max(1, Math.floor(cfg.projectSupplyRepairHp)),
    supplyBuildProgress: Math.max(1, Math.floor(cfg.projectSupplyBuildProgress)),
  };
}

function applyIncomeBonus(amount: number, bonusPercent: number): number {
  if (bonusPercent <= 0) return amount;
  return Math.round(amount * (1 + (bonusPercent / 100)));
}

async function buildViewerTerritoryCaps(
  crewId: number,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
  progression?: CrewTerritoryProgression | null,
): Promise<ViewerTerritoryCaps> {
  const crewProgression = progression ?? await getCrewTerritoryProgression(crewId);
  const hqRegionBonus = getScaledBonus(
    crewProgression.hqGlobalLevel,
    cfg.hqRegionCapPerLevel,
    cfg.hqRegionCapBonusCap,
  );
  const hqContestBonus = getScaledBonus(
    crewProgression.hqGlobalLevel,
    cfg.hqContestCapPerLevel,
    cfg.hqContestCapBonusCap,
  );
  const [ownedCount, contestCount] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
      `SELECT COUNT(*) AS cnt FROM territory_control WHERE ownerCrewId = ?`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
      `SELECT COUNT(*) AS cnt FROM territory_contests
       WHERE attackerCrewId = ? AND status NOT IN ('resolved', 'cancelled')`,
      crewId,
    ),
  ]);

  return {
    hqGlobalLevel: crewProgression.hqGlobalLevel,
    ownedRegions: toNumeric(ownedCount[0]?.cnt ?? 0),
    activeContests: toNumeric(contestCount[0]?.cnt ?? 0),
    baseMaxRegions: cfg.maxRegionsPerCrew,
    effectiveMaxRegions: Math.max(cfg.maxRegionsPerCrew, cfg.maxRegionsPerCrew + hqRegionBonus),
    baseMaxContests: cfg.maxConcurrentContestsPerCrew,
    effectiveMaxContests: Math.max(
      cfg.maxConcurrentContestsPerCrew,
      cfg.maxConcurrentContestsPerCrew + hqContestBonus,
    ),
    hqRegionBonus,
    hqContestBonus,
    projectSafehouseMinHqLevel: Math.max(0, Math.floor(cfg.projectSafehouseMinHqLevel)),
  };
}

// ── Shared Types ────────────────────────────────────────────────────────────

type TerritoryRow = { id: number; countryCode: string; displayNameNl: string; displayNameEn: string; svgAssetKey: string; enabled: number };
type RegionRow = { id: number; countryCode: string; regionKey: string; nameNl: string; nameEn: string; svgElementId: string; valueTier: number; strategicTagsJson: string | null; neighborsJson: string | null; enabled: number };
type ControlRow = { id: number; regionKey: string; ownerCrewId: number | null; controlJson: string | null; stability: number; lastDecayAt: Date | null; lastIncomeAt: Date | null; ownedSince: Date | null; updatedAt: Date };
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
  source: 'strategic-tag' | 'adjacency' | 'war-aftermath' | 'hq-level' | 'crew-mission-level' | 'crew-building' | 'region-event' | 'region-project';
  labelNl: string;
  labelEn: string;
};

type CrewTerritoryProgression = {
  missionLevel: number;
  hqGlobalLevel: number;
  buildingLevels: {
    carStorage: number;
    boatStorage: number;
    weaponStorage: number;
    ammoStorage: number;
    drugStorage: number;
  };
};

type TerritoryAdminTelemetry = {
  windowHours: number;
  rewardPerMinute: {
    totalCash: number;
    totalXp: number;
    totalRewards: number;
    cashPerMinute: number;
    rewardsPerMinute: number;
    byValueTier: Array<{
      valueTier: number;
      cashAmount: number;
      rewards: number;
      cashPerMinute: number;
    }>;
  };
  contestWinrateByHqBand: Array<{
    hqBand: string;
    contests: number;
    wins: number;
    winratePercent: number;
  }>;
  regionGrowthByCrewSize: Array<{
    crewSizeBand: string;
    crews: number;
    totalRegionsCaptured: number;
    avgRegionsCaptured: number;
  }>;
  bonusUsageByTier: {
    hqBand: Array<{
      hqBand: string;
      actions: number;
      totalBonusPoints: number;
      avgBonusPoints: number;
    }>;
    buildingTier: Array<{
      buildingTier: string;
      actions: number;
      totalBonusPoints: number;
      avgBonusPoints: number;
    }>;
  };
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

function buildRegionEventActionBonuses(event: territoryMetaService.ActiveRegionEvent | null): StrategicActionBonus[] {
  if (!event || event.attackBonusPoints <= 0) return [];
  return ['intel_scan', 'sabotage', 'raid', 'patrol', 'defense', 'supply_run'].map((actionType) => ({
    actionType,
    bonusPoints: event.attackBonusPoints,
    source: 'region-event' as const,
    labelNl: 'Regio-event',
    labelEn: 'Region event',
  }));
}

function buildStrategicActionBonuses(
  region: RegionRow,
  options: {
    /** Owned neighbors for the crew whose defender-side pocket/cluster bonuses apply. */
    holderAdjacentOwned: number;
    /** Attacker owns at least one neighbor of this region. */
    invasionFromOwnedNeighbor?: boolean;
    /** Defender/owner pocket (0–1 own neighbors) → attacker pressure bonuses. */
    pocketPressureForAttacker?: boolean;
  },
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
    if (bonusPoints <= 0) return;
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
  if (strategicTags.includes('airhub')) {
    pushBonus('intel_scan', 1, 'Luchthub', 'Air hub');
    pushBonus('supply_run', 1, 'Luchthub', 'Air hub');
  }

  const adjacentOwnedRegions = options.holderAdjacentOwned;
  if (adjacentOwnedRegions === 1) {
    // Pocket: thin supply line — modest defender support only.
    pushBonus('patrol', 1, 'Dunne supply-line (pocket)', 'Thin supply line (pocket)', 'adjacency');
    pushBonus('defense', 1, 'Dunne supply-line (pocket)', 'Thin supply line (pocket)', 'adjacency');
  } else if (adjacentOwnedRegions >= 2) {
    // Cluster: contiguous ownership — stronger patrol/raid/defense/supply.
    const clusterPoints = Math.min(3, adjacentOwnedRegions);
    pushBonus('patrol', clusterPoints, 'Cluster supply-line', 'Cluster supply line', 'adjacency');
    pushBonus('raid', clusterPoints - 1, 'Cluster supply-line', 'Cluster supply line', 'adjacency');
    pushBonus('defense', clusterPoints, 'Cluster supply-line', 'Cluster supply line', 'adjacency');
    pushBonus('supply_run', 1, 'Cluster supply-line', 'Cluster supply line', 'adjacency');
  }

  if (options.invasionFromOwnedNeighbor) {
    pushBonus('raid', 2, 'Invasie via buurregio', 'Invasion via neighboring region', 'adjacency');
    pushBonus('intel_scan', 1, 'Invasie via buurregio', 'Invasion via neighboring region', 'adjacency');
  }
  if (options.pocketPressureForAttacker) {
    pushBonus('sabotage', 2, 'Pocket-druk', 'Pocket pressure', 'adjacency');
    pushBonus('raid', 1, 'Pocket-druk', 'Pocket pressure', 'adjacency');
  }

  return bonuses;
}

function mapProjectBonusesToStrategic(
  project: territoryProjectService.TerritoryRegionProject | null,
  config: territoryProjectService.TerritoryProjectConfig,
): StrategicActionBonus[] {
  return territoryProjectService.buildProjectActionBonuses(project, config).map((bonus) => ({
    actionType: bonus.actionType,
    bonusPoints: bonus.bonusPoints,
    source: 'region-project' as const,
    labelNl: bonus.labelNl,
    labelEn: bonus.labelEn,
  }));
}

function getActionBonusForType(bonuses: StrategicActionBonus[], actionType: string): number {
  return bonuses
    .filter((bonus) => bonus.actionType === actionType)
    .reduce((sum, bonus) => sum + bonus.bonusPoints, 0);
}

function normalizeHqStyle(style: string | null | undefined): 'camping' | 'rural' | 'city' | 'villa' | 'vip' {
  const normalized = String(style ?? 'camping').trim().toLowerCase();
  if (normalized === 'landelijk') return 'rural';
  if (normalized === 'stad') return 'city';
  if (normalized === 'camping' || normalized === 'rural' || normalized === 'city' || normalized === 'villa' || normalized === 'vip') {
    return normalized;
  }
  return 'camping';
}

function getHqGlobalLevelForTerritory(styleRaw: string | null | undefined, levelRaw: number | null | undefined): number {
  const style = normalizeHqStyle(styleRaw);
  const level = Math.max(0, Math.floor(Number(levelRaw ?? 0)));
  const baseByStyle: Record<'camping' | 'rural' | 'city' | 'villa' | 'vip', number> = {
    camping: 0,
    rural: 4,
    city: 8,
    villa: 12,
    vip: 16,
  };
  return baseByStyle[style] + level;
}

function getScaledBonus(level: number, perLevel: number, cap: number): number {
  if (!Number.isFinite(level) || level <= 0) return 0;
  if (!Number.isFinite(perLevel) || perLevel <= 0) return 0;
  const safeCap = Number.isFinite(cap) ? Math.max(0, cap) : 0;
  const raw = Math.floor(level * perLevel);
  return Math.max(0, Math.min(raw, safeCap));
}

function hqLevelBand(level: number): string {
  if (level <= 0) return 'L0';
  if (level <= 5) return 'L1-5';
  if (level <= 10) return 'L6-10';
  if (level <= 15) return 'L11-15';
  if (level <= 20) return 'L16-20';
  return 'L21+';
}

function crewSizeBand(size: number): string {
  if (size <= 1) return '1';
  if (size <= 5) return '2-5';
  if (size <= 10) return '6-10';
  if (size <= 20) return '11-20';
  return '21+';
}

function buildingTierBand(maxBuildingLevel: number): string {
  if (maxBuildingLevel <= 0) return 'L0';
  if (maxBuildingLevel <= 3) return 'L1-3';
  if (maxBuildingLevel <= 7) return 'L4-7';
  if (maxBuildingLevel <= 11) return 'L8-11';
  return 'L12+';
}

async function getCrewTerritoryProgression(crewId: number): Promise<CrewTerritoryProgression> {
  const [
    crewRows,
    hqRows,
    carRows,
    boatRows,
    weaponRows,
    ammoRows,
    drugRows,
  ] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{ missionLevel: number | null }>>(
      `SELECT missionLevel FROM crews WHERE id = ? LIMIT 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ style: string | null; level: number | null }>>(
      `SELECT style, level FROM crew_hq_buildings WHERE crewId = ? LIMIT 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ level: number | null }>>(
      `SELECT level FROM crew_car_storage_buildings WHERE crewId = ? LIMIT 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ level: number | null }>>(
      `SELECT level FROM crew_boat_storage_buildings WHERE crewId = ? LIMIT 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ level: number | null }>>(
      `SELECT level FROM crew_weapon_storage_buildings WHERE crewId = ? LIMIT 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ level: number | null }>>(
      `SELECT level FROM crew_ammo_storage_buildings WHERE crewId = ? LIMIT 1`,
      crewId,
    ),
    prisma.$queryRawUnsafe<Array<{ level: number | null }>>(
      `SELECT level FROM crew_drug_storage_buildings WHERE crewId = ? LIMIT 1`,
      crewId,
    ),
  ]);

  const hqStyle = hqRows[0]?.style ?? 'camping';
  const hqLevel = toNumeric(hqRows[0]?.level ?? 0);
  return {
    missionLevel: Math.max(1, toNumeric(crewRows[0]?.missionLevel ?? 1)),
    hqGlobalLevel: getHqGlobalLevelForTerritory(hqStyle, hqLevel),
    buildingLevels: {
      carStorage: Math.max(0, toNumeric(carRows[0]?.level ?? 0)),
      boatStorage: Math.max(0, toNumeric(boatRows[0]?.level ?? 0)),
      weaponStorage: Math.max(0, toNumeric(weaponRows[0]?.level ?? 0)),
      ammoStorage: Math.max(0, toNumeric(ammoRows[0]?.level ?? 0)),
      drugStorage: Math.max(0, toNumeric(drugRows[0]?.level ?? 0)),
    },
  };
}

function buildProgressionActionBonuses(
  progression: CrewTerritoryProgression | null,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): StrategicActionBonus[] {
  if (!progression) return [];

  const bonuses: StrategicActionBonus[] = [];
  const pushBonus = (
    actionType: string,
    bonusPoints: number,
    source: StrategicActionBonus['source'],
    labelNl: string,
    labelEn: string,
  ) => {
    if (bonusPoints <= 0) return;
    bonuses.push({ actionType, bonusPoints, source, labelNl, labelEn });
  };

  const hqBonus = getScaledBonus(
    progression.hqGlobalLevel,
    cfg.hqActionPointBonusPerLevel,
    cfg.hqActionPointBonusCap,
  );
  for (const actionType of ['patrol', 'intel_scan', 'sabotage', 'supply_run', 'raid', 'defense']) {
    pushBonus(actionType, hqBonus, 'hq-level', 'HQ niveau', 'HQ level');
  }

  const missionBonus = getScaledBonus(
    progression.missionLevel,
    cfg.crewMissionActionPointBonusPerLevel,
    cfg.crewMissionActionPointBonusCap,
  );
  for (const actionType of ['patrol', 'intel_scan', 'supply_run']) {
    pushBonus(actionType, missionBonus, 'crew-mission-level', 'Crew missie level', 'Crew mission level');
  }

  const defenseBuildingBonus = Math.min(
    Math.max(0, cfg.buildingActionBonusCap),
    getScaledBonus(progression.buildingLevels.weaponStorage, cfg.weaponStorageDefenseBonusPerLevel, cfg.buildingActionBonusCap)
      + getScaledBonus(progression.buildingLevels.ammoStorage, cfg.ammoStorageDefenseBonusPerLevel, cfg.buildingActionBonusCap),
  );
  pushBonus('defense', defenseBuildingBonus, 'crew-building', 'Wapen + munitie opslag', 'Weapon + ammo storage');

  const raidBonus = getScaledBonus(
    progression.buildingLevels.carStorage,
    cfg.carStorageRaidBonusPerLevel,
    cfg.buildingActionBonusCap,
  );
  pushBonus('raid', raidBonus, 'crew-building', 'Auto-opslag logistiek', 'Vehicle storage logistics');

  const supplyBonus = getScaledBonus(
    progression.buildingLevels.boatStorage,
    cfg.boatStorageSupplyBonusPerLevel,
    cfg.buildingActionBonusCap,
  );
  pushBonus('supply_run', supplyBonus, 'crew-building', 'Haven-opslag support', 'Harbor storage support');

  const sabotageBonus = getScaledBonus(
    progression.buildingLevels.drugStorage,
    cfg.drugStorageSabotageBonusPerLevel,
    cfg.buildingActionBonusCap,
  );
  pushBonus('sabotage', sabotageBonus, 'crew-building', 'Drugslab ervaring', 'Drug lab experience');

  return bonuses;
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
  const projectConfig = getProjectConfig(cfg);
  const incomeBonusByRegion = await territoryProjectService.getActiveIncomeBonusByRegionKeys(
    rows.map((row) => row.regionKey),
    projectConfig,
  );
  const incomePenaltyByRegion = await territoryMetaService.getActiveRegionEventIncomePenaltyByRegion(
    rows.map((row) => row.regionKey),
    now,
  );

  for (const row of rows) {
    const lastIncomeAt = row.lastIncomeAt ?? now;
    const elapsedMs = now.getTime() - lastIncomeAt.getTime();
    const payoutCycles = Math.floor(elapsedMs / intervalMs);
    if (payoutCycles <= 0) {
      continue;
    }

    const boosted = applyIncomeBonus(
      getPassiveIncomeCashForTier(toNumeric(row.valueTier), cfg),
      incomeBonusByRegion[row.regionKey] ?? 0,
    );
    const penaltyPercent = incomePenaltyByRegion[row.regionKey] ?? 0;
    const amountPerCycle = penaltyPercent > 0
      ? Math.max(0, Math.round(boosted * (1 - (penaltyPercent / 100))))
      : boosted;
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
      const cashCapacity = await getCrewStorageCapacity(ownerCrewId, 'cash_storage');
      const crew = await tx.crew.findUnique({
        where: { id: ownerCrewId },
        select: { bankBalance: true },
      });

      if (!crew) {
        return;
      }

      let remainingPayoutCapacity = Math.max(0, cashCapacity - toNumeric(crew.bankBalance ?? 0));

      if (remainingPayoutCapacity > 0 && crewPayout.totalPayoutAmount > 0) {
        const creditedAmount = Math.min(crewPayout.totalPayoutAmount, remainingPayoutCapacity);
        await tx.$executeRawUnsafe(
          `UPDATE crews SET bankBalance = bankBalance + ? WHERE id = ?`,
          creditedAmount,
          ownerCrewId,
        );
        remainingPayoutCapacity -= creditedAmount;
      }

      for (const payout of crewPayout.rows) {
        const creditedPayoutAmount = Math.min(payout.payoutAmount, remainingPayoutCapacity);
        if (creditedPayoutAmount > 0) {
          const creditedCycles = Math.min(
            payout.payoutCycles,
            Math.floor(creditedPayoutAmount / Math.max(1, getPassiveIncomeCashForTier(payout.valueTier, cfg))),
          );
          await tx.$executeRawUnsafe(
            `INSERT INTO territory_reward_log (seasonKey, crewId, playerId, rewardType, cashAmount, xpAmount, metadataJson)
             VALUES (?, ?, NULL, 'passive_income', ?, 0, ?)`,
            seasonKey,
            ownerCrewId,
            creditedPayoutAmount,
            JSON.stringify({
              regionKey: payout.regionKey,
              countryCode: payout.countryCode,
              valueTier: payout.valueTier,
              payoutCycles: creditedCycles,
              intervalMinutes,
              source: 'territory_passive_income',
            }),
          );
          remainingPayoutCapacity -= creditedPayoutAmount;
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

  const contestsBecomingActive = await prisma.$queryRawUnsafe<Array<{
    id: number;
    regionKey: string;
    attackerCrewId: number;
    defenderCrewId: number | null;
  }>>(
    `SELECT id, regionKey, attackerCrewId, defenderCrewId
     FROM territory_contests
     WHERE status = 'preparing' AND activeAt IS NOT NULL AND activeAt <= ?`,
    now,
  );

  for (const contest of contestsBecomingActive) {
    const updated = await prisma.$executeRawUnsafe(
      `UPDATE territory_contests
       SET status = 'active'
       WHERE id = ? AND status = 'preparing'`,
      contest.id,
    );
    if (Number(updated) > 0) {
      _notifyCrewContestBecameActive(
        toNumeric(contest.attackerCrewId),
        contest.defenderCrewId == null ? null : toNumeric(contest.defenderCrewId),
        contest.regionKey,
        toNumeric(contest.id),
      ).catch(() => {});
    }
  }

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
  await territoryMetaService.rotateRegionEvents(now, {
    enabled: cfg.regionEventEnabled,
    rotationHours: Math.max(1, Math.floor(cfg.regionEventRotationHours)),
    activeCount: Math.max(0, Math.floor(cfg.regionEventActiveCount)),
    attackBonusPoints: Math.max(0, Math.floor(cfg.regionEventAttackBonusPoints)),
    incomePenaltyPercent: Math.max(0, Math.floor(cfg.regionEventIncomePenaltyPercent)),
  });

  const expiredSeasons = await prisma.$queryRawUnsafe<Array<{ seasonKey: string }>>(
    `SELECT seasonKey FROM territory_seasons
     WHERE status = 'active' AND endsAt IS NOT NULL AND endsAt <= ?`,
    now,
  );
  for (const season of expiredSeasons) {
    try {
      await adminCloseSeason(season.seasonKey);
    } catch (error) {
      if (!(error instanceof Error) || error.message !== 'SEASON_NOT_FOUND') {
        console.error('[Territory] auto season close failed', season.seasonKey, error);
      }
    }
  }
  await ensureCurrentTerritorySeason().catch(() => {});
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
  viewerCaps: ViewerTerritoryCaps | null;
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
    contestAttackerPoints: number;
    contestDefenderPoints: number;
    attackerCrewId: number | null;
    attackerCrewName: string | null;
    defenderCrewId: number | null;
    defenderCrewName: string | null;
    viewerContestRole: 'attacker' | 'defender' | null;
    ownerAdjacentOwnedRegions: number;
    projectOptions: territoryProjectService.TerritoryProjectOption[];
    viewerNextActionAt: Date | null;
    viewerCooldownSecondsRemaining: number;
    passiveIncomeIntervalMinutes: number;
    passiveIncomeCash: number;
    passiveIncomeCashHourly: number;
    passiveIncomeCashDaily: number;
    projectIncomeBonusPercent: number;
    regionProject: territoryProjectService.TerritoryRegionProject | null;
    regionEvent: territoryMetaService.ActiveRegionEvent | null;
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
    viewerHqGlobalLevel: number;
    actionUnlockHqLevels: {
      patrol: number;
      intel_scan: number;
      sabotage: number;
      supply_run: number;
      raid: number;
      defense: number;
    };
  }>;
}> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  const now = new Date();
  const projectConfig = getProjectConfig(cfg);
  const viewerCrewProgression = viewer?.viewerCrewId
    ? await getCrewTerritoryProgression(viewer.viewerCrewId)
    : null;
  const viewerCaps = viewer?.viewerCrewId
    ? await buildViewerTerritoryCaps(viewer.viewerCrewId, cfg, viewerCrewProgression)
    : null;

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
  const projectsByRegion = await territoryProjectService.getProjectsByRegionKeys(
    regions.map((region) => region.regionKey),
    projectConfig,
  );
  const incomeBonusByRegion = await territoryProjectService.getActiveIncomeBonusByRegionKeys(
    regions.map((region) => region.regionKey),
    projectConfig,
  );
  const regionEvents = await territoryMetaService.getActiveRegionEvents(
    regions.map((region) => region.regionKey),
    now,
  );
  const regionEventByKey = regionEvents.reduce<Record<string, territoryMetaService.ActiveRegionEvent>>((acc, event) => {
    acc[event.regionKey] = event;
    return acc;
  }, {});
  const incomePenaltyByRegion = regionEvents.reduce<Record<string, number>>((acc, event) => {
    if (event.incomePenaltyPercent > 0) {
      acc[event.regionKey] = Math.max(acc[event.regionKey] ?? 0, event.incomePenaltyPercent);
    }
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

  let contestPointsById: Record<number, { attackerPoints: number; defenderPoints: number }> = {};
  if (contests.length > 0) {
    const contestIds = contests.map((contest) => contest.id);
    const placeholders = contestIds.map(() => '?').join(', ');
    const tallyRows = await prisma.$queryRawUnsafe<Array<{ contestId: number; actorCrewId: number; totalPoints: number }>>(
      `SELECT contestId, actorCrewId, SUM(pointsDelta) AS totalPoints
       FROM territory_actions
       WHERE contestId IN (${placeholders}) AND abuseFlagged = 0
       GROUP BY contestId, actorCrewId`,
      ...contestIds,
    );
    contestPointsById = contests.reduce<Record<number, { attackerPoints: number; defenderPoints: number }>>((acc, contest) => {
      const rows = tallyRows.filter((row) => row.contestId === contest.id);
      acc[contest.id] = {
        attackerPoints: toNumeric(rows.find((row) => row.actorCrewId === contest.attackerCrewId)?.totalPoints ?? 0),
        defenderPoints: toNumeric(
          rows.find((row) => contest.defenderCrewId != null && row.actorCrewId === contest.defenderCrewId)?.totalPoints ?? 0,
        ),
      };
      return acc;
    }, {});
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
    const projectIncomeBonusPercent = incomeBonusByRegion[r.regionKey] ?? 0;
    const regionEvent = regionEventByKey[r.regionKey] ?? null;
    const eventPenaltyPercent = incomePenaltyByRegion[r.regionKey] ?? 0;
    let amountPerInterval = applyIncomeBonus(incomeSnapshot.amountPerInterval, projectIncomeBonusPercent);
    let amountPerHour = applyIncomeBonus(incomeSnapshot.amountPerHour, projectIncomeBonusPercent);
    let amountPerDay = applyIncomeBonus(incomeSnapshot.amountPerDay, projectIncomeBonusPercent);
    if (eventPenaltyPercent > 0) {
      const factor = 1 - (eventPenaltyPercent / 100);
      amountPerInterval = Math.max(0, Math.round(amountPerInterval * factor));
      amountPerHour = Math.max(0, Math.round(amountPerHour * factor));
      amountPerDay = Math.max(0, Math.round(amountPerDay * factor));
    }
    const boostedIncome = {
      amountPerInterval,
      intervalMinutes: incomeSnapshot.intervalMinutes,
      amountPerHour,
      amountPerDay,
    };
    const strategicTags = parseStringArray(r.strategicTagsJson);
    const neighbors = parseStringArray(r.neighborsJson);
    const countOwnedNeighbors = (crewId: number | null | undefined): number => {
      if (crewId == null) return 0;
      return neighbors.reduce((count, neighborKey) => {
        const neighborControl = controlMap[neighborKey];
        return count + (neighborControl?.ownerCrewId === crewId ? 1 : 0);
      }, 0);
    };
    const adjacentOwnedRegions = countOwnedNeighbors(viewer?.viewerCrewId);
    const ownerCrewId = ctrl?.ownerCrewId ?? null;
    const ownerAdjacentOwnedRegions = countOwnedNeighbors(ownerCrewId);
    const holderCrewId = contest?.defenderCrewId ?? ownerCrewId;
    const holderAdjacentOwned = countOwnedNeighbors(holderCrewId);
    const viewerIsHolder = viewer?.viewerCrewId != null && holderCrewId === viewer.viewerCrewId;
    const viewerIsPotentialAttacker = viewer?.viewerCrewId != null && !viewerIsHolder;
    const invasionFromOwnedNeighbor = Boolean(viewerIsPotentialAttacker && adjacentOwnedRegions > 0);
    const pocketPressureForAttacker = Boolean(viewerIsPotentialAttacker && holderAdjacentOwned <= 1);
    const regionProject = projectsByRegion[r.regionKey] ?? null;
    const projectOptions = territoryProjectService.listProjectOptions({
      strategicTags,
      hqGlobalLevel: viewerCrewProgression?.hqGlobalLevel ?? 0,
      config: projectConfig,
    });
    const contestPoints = contest ? (contestPointsById[contest.id] ?? { attackerPoints: 0, defenderPoints: 0 }) : null;
    const rawWarPressure = activeWarPressureByRegion[r.regionKey] ?? null;
    const activeWarPressure = rawWarPressure && (ctrl?.ownerCrewId === rawWarPressure.affectedCrewId || contest?.defenderCrewId === rawWarPressure.affectedCrewId)
      ? {
          ...rawWarPressure,
          favoredCrewName: rawWarPressure.favoredCrewId == null ? null : (crewNameMap[rawWarPressure.favoredCrewId] ?? null),
          affectedCrewName: rawWarPressure.affectedCrewId == null ? null : (crewNameMap[rawWarPressure.affectedCrewId] ?? null),
        }
      : null;
    const strategicActionBonuses = [
      ...buildStrategicActionBonuses(r, {
        holderAdjacentOwned: viewerIsHolder ? holderAdjacentOwned : 0,
        invasionFromOwnedNeighbor,
        pocketPressureForAttacker,
      }),
      ...buildProgressionActionBonuses(viewerCrewProgression, cfg),
      ...(viewer?.viewerCrewId != null && activeWarPressure?.favoredCrewId === viewer.viewerCrewId
        ? buildWarPressureActionBonuses(activeWarPressure)
        : []),
      ...buildRegionEventActionBonuses(regionEvent),
      ...mapProjectBonusesToStrategic(regionProject, projectConfig),
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
      contestAttackerPoints: contestPoints?.attackerPoints ?? 0,
      contestDefenderPoints: contestPoints?.defenderPoints ?? 0,
      attackerCrewId: contest?.attackerCrewId ?? null,
      attackerCrewName: contest?.attackerCrewName ?? null,
      defenderCrewId: contest?.defenderCrewId ?? null,
      defenderCrewName: contest?.defenderCrewName ?? null,
      viewerContestRole,
      viewerNextActionAt: viewerCooldown?.nextActionAt ?? null,
      viewerCooldownSecondsRemaining: viewerCooldown?.secondsRemaining ?? 0,
      passiveIncomeIntervalMinutes: boostedIncome.intervalMinutes,
      passiveIncomeCash: boostedIncome.amountPerInterval,
      passiveIncomeCashHourly: boostedIncome.amountPerHour,
      passiveIncomeCashDaily: boostedIncome.amountPerDay,
      projectIncomeBonusPercent,
      regionProject,
      regionEvent,
      strategicTags,
      neighbors,
      adjacentOwnedRegions,
      ownerAdjacentOwnedRegions,
      projectOptions,
      activeWarPressure,
      strategicActionBonuses,
      viewerHqGlobalLevel: viewerCrewProgression?.hqGlobalLevel ?? 0,
      actionUnlockHqLevels: { ...cfg.actionUnlockHqLevels },
    };
  });

  return { country, viewerCaps, regions: enrichedRegions };
}

export async function getOverview(): Promise<{
  config: Awaited<ReturnType<typeof getTerritoryConfig>>;
  activeSeason: SeasonRow | null;
  leaderboard: Array<{ crewId: number; crewName: string; regionsOwned: number; totalControl: number }>;
  drama: territoryMetaService.TerritoryDramaSnapshot;
  activeRegionEvents: territoryMetaService.ActiveRegionEvent[];
}> {
  await syncContestLifecycle();

  const [cfg, seasons, leaderboard, drama] = await Promise.all([
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
    territoryMetaService.getTerritoryDramaSnapshot(),
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
    drama,
    activeRegionEvents: drama.activeRegionEvents,
  };
}

export async function getAdminTelemetry(hoursInput: number = 24): Promise<TerritoryAdminTelemetry> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  const windowHours = Math.max(1, Math.min(168, Math.floor(Number(hoursInput) || 24)));
  const minutes = windowHours * 60;

  const [rewardTotalsRows, rewardByTierRows, contestRows, growthRows, bonusRows] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{ totalCash: number; totalXp: number; totalRewards: number }>>(
      `SELECT COALESCE(SUM(cashAmount), 0) AS totalCash,
              COALESCE(SUM(xpAmount), 0) AS totalXp,
              COUNT(*) AS totalRewards
       FROM territory_reward_log
       WHERE createdAt >= DATE_SUB(NOW(), INTERVAL ? HOUR)`,
      windowHours,
    ),
    prisma.$queryRawUnsafe<Array<{ valueTier: number; cashAmount: number; rewards: number }>>(
      `SELECT COALESCE(CAST(JSON_UNQUOTE(JSON_EXTRACT(metadataJson, '$.valueTier')) AS UNSIGNED), 0) AS valueTier,
              COALESCE(SUM(cashAmount), 0) AS cashAmount,
              COUNT(*) AS rewards
       FROM territory_reward_log
       WHERE createdAt >= DATE_SUB(NOW(), INTERVAL ? HOUR)
       GROUP BY valueTier
       ORDER BY valueTier ASC`,
      windowHours,
    ),
    prisma.$queryRawUnsafe<Array<{ winnerCrewId: number | null; attackerCrewId: number; hqStyle: string | null; hqLevel: number | null }>>(
      `SELECT tc.winnerCrewId,
              tc.attackerCrewId,
              hq.style AS hqStyle,
              hq.level AS hqLevel
       FROM territory_contests tc
       LEFT JOIN crew_hq_buildings hq ON hq.crewId = tc.attackerCrewId
       WHERE tc.status = 'resolved'
         AND tc.resolvedAt IS NOT NULL
         AND tc.resolvedAt >= DATE_SUB(NOW(), INTERVAL ? HOUR)`,
      windowHours,
    ),
    prisma.$queryRawUnsafe<Array<{ crewId: number; capturedRegions: number; crewSize: number }>>(
      `SELECT tc.winnerCrewId AS crewId,
              COUNT(*) AS capturedRegions,
              COUNT(DISTINCT cm.playerId) AS crewSize
       FROM territory_contests tc
       LEFT JOIN crew_members cm ON cm.crewId = tc.winnerCrewId
       WHERE tc.status = 'resolved'
         AND tc.resolvedAt IS NOT NULL
         AND tc.resolvedAt >= DATE_SUB(NOW(), INTERVAL ? HOUR)
         AND tc.winnerCrewId IS NOT NULL
       GROUP BY tc.winnerCrewId`,
      windowHours,
    ),
    prisma.$queryRawUnsafe<Array<{
      actionType: string;
      hqStyle: string | null;
      hqLevel: number | null;
      missionLevel: number | null;
      carLevel: number | null;
      boatLevel: number | null;
      weaponLevel: number | null;
      ammoLevel: number | null;
      drugLevel: number | null;
    }>>(
      `SELECT a.actionType,
              hq.style AS hqStyle,
              hq.level AS hqLevel,
              c.missionLevel,
              car.level AS carLevel,
              boat.level AS boatLevel,
              weapon.level AS weaponLevel,
              ammo.level AS ammoLevel,
              drug.level AS drugLevel
       FROM territory_actions a
       LEFT JOIN crews c ON c.id = a.actorCrewId
       LEFT JOIN crew_hq_buildings hq ON hq.crewId = a.actorCrewId
       LEFT JOIN crew_car_storage_buildings car ON car.crewId = a.actorCrewId
       LEFT JOIN crew_boat_storage_buildings boat ON boat.crewId = a.actorCrewId
       LEFT JOIN crew_weapon_storage_buildings weapon ON weapon.crewId = a.actorCrewId
       LEFT JOIN crew_ammo_storage_buildings ammo ON ammo.crewId = a.actorCrewId
       LEFT JOIN crew_drug_storage_buildings drug ON drug.crewId = a.actorCrewId
       WHERE a.createdAt >= DATE_SUB(NOW(), INTERVAL ? HOUR)`,
      windowHours,
    ),
  ]);

  const rewardTotals = rewardTotalsRows[0] ?? { totalCash: 0, totalXp: 0, totalRewards: 0 };
  const totalCash = toNumeric(rewardTotals.totalCash ?? 0);
  const totalXp = toNumeric(rewardTotals.totalXp ?? 0);
  const totalRewards = toNumeric(rewardTotals.totalRewards ?? 0);

  const rewardByTier = rewardByTierRows.map((row) => {
    const tier = Math.max(0, toNumeric(row.valueTier ?? 0));
    const cash = toNumeric(row.cashAmount ?? 0);
    const rewards = toNumeric(row.rewards ?? 0);
    return {
      valueTier: tier,
      cashAmount: cash,
      rewards,
      cashPerMinute: Number((cash / Math.max(1, minutes)).toFixed(2)),
    };
  });

  const winrateMap = new Map<string, { contests: number; wins: number }>();
  for (const row of contestRows) {
    const hqGlobalLevel = getHqGlobalLevelForTerritory(row.hqStyle, toNumeric(row.hqLevel ?? 0));
    const band = hqLevelBand(hqGlobalLevel);
    const current = winrateMap.get(band) ?? { contests: 0, wins: 0 };
    current.contests += 1;
    if (row.winnerCrewId != null && toNumeric(row.winnerCrewId) === toNumeric(row.attackerCrewId)) {
      current.wins += 1;
    }
    winrateMap.set(band, current);
  }
  const contestWinrateByHqBand = [...winrateMap.entries()]
    .map(([hqBand, stats]) => ({
      hqBand,
      contests: stats.contests,
      wins: stats.wins,
      winratePercent: stats.contests <= 0 ? 0 : Number(((stats.wins / stats.contests) * 100).toFixed(1)),
    }))
    .sort((a, b) => a.hqBand.localeCompare(b.hqBand));

  const growthBandMap = new Map<string, { crews: number; totalRegionsCaptured: number }>();
  for (const row of growthRows) {
    const sizeBand = crewSizeBand(Math.max(1, toNumeric(row.crewSize ?? 0)));
    const current = growthBandMap.get(sizeBand) ?? { crews: 0, totalRegionsCaptured: 0 };
    current.crews += 1;
    current.totalRegionsCaptured += toNumeric(row.capturedRegions ?? 0);
    growthBandMap.set(sizeBand, current);
  }
  const regionGrowthByCrewSize = [...growthBandMap.entries()]
    .map(([crewSizeBandLabel, stats]) => ({
      crewSizeBand: crewSizeBandLabel,
      crews: stats.crews,
      totalRegionsCaptured: stats.totalRegionsCaptured,
      avgRegionsCaptured: stats.crews <= 0 ? 0 : Number((stats.totalRegionsCaptured / stats.crews).toFixed(2)),
    }))
    .sort((a, b) => a.crewSizeBand.localeCompare(b.crewSizeBand));

  const hqUsageMap = new Map<string, { actions: number; totalBonusPoints: number }>();
  const buildingUsageMap = new Map<string, { actions: number; totalBonusPoints: number }>();

  for (const row of bonusRows) {
    const progression: CrewTerritoryProgression = {
      missionLevel: Math.max(1, toNumeric(row.missionLevel ?? 1)),
      hqGlobalLevel: getHqGlobalLevelForTerritory(row.hqStyle, toNumeric(row.hqLevel ?? 0)),
      buildingLevels: {
        carStorage: Math.max(0, toNumeric(row.carLevel ?? 0)),
        boatStorage: Math.max(0, toNumeric(row.boatLevel ?? 0)),
        weaponStorage: Math.max(0, toNumeric(row.weaponLevel ?? 0)),
        ammoStorage: Math.max(0, toNumeric(row.ammoLevel ?? 0)),
        drugStorage: Math.max(0, toNumeric(row.drugLevel ?? 0)),
      },
    };
    const actionType = String(row.actionType ?? '').trim().toLowerCase();
    if (!actionType) continue;

    const hqBonus = getScaledBonus(
      progression.hqGlobalLevel,
      cfg.hqActionPointBonusPerLevel,
      cfg.hqActionPointBonusCap,
    );

    let buildingBonus = 0;
    if (actionType === 'defense') {
      buildingBonus = Math.min(
        Math.max(0, cfg.buildingActionBonusCap),
        getScaledBonus(progression.buildingLevels.weaponStorage, cfg.weaponStorageDefenseBonusPerLevel, cfg.buildingActionBonusCap)
          + getScaledBonus(progression.buildingLevels.ammoStorage, cfg.ammoStorageDefenseBonusPerLevel, cfg.buildingActionBonusCap),
      );
    } else if (actionType === 'raid') {
      buildingBonus = getScaledBonus(
        progression.buildingLevels.carStorage,
        cfg.carStorageRaidBonusPerLevel,
        cfg.buildingActionBonusCap,
      );
    } else if (actionType === 'supply_run') {
      buildingBonus = getScaledBonus(
        progression.buildingLevels.boatStorage,
        cfg.boatStorageSupplyBonusPerLevel,
        cfg.buildingActionBonusCap,
      );
    } else if (actionType === 'sabotage') {
      buildingBonus = getScaledBonus(
        progression.buildingLevels.drugStorage,
        cfg.drugStorageSabotageBonusPerLevel,
        cfg.buildingActionBonusCap,
      );
    }

    if (hqBonus > 0) {
      const band = hqLevelBand(progression.hqGlobalLevel);
      const current = hqUsageMap.get(band) ?? { actions: 0, totalBonusPoints: 0 };
      current.actions += 1;
      current.totalBonusPoints += hqBonus;
      hqUsageMap.set(band, current);
    }

    if (buildingBonus > 0) {
      const maxBuildingLevel = Math.max(
        progression.buildingLevels.carStorage,
        progression.buildingLevels.boatStorage,
        progression.buildingLevels.weaponStorage,
        progression.buildingLevels.ammoStorage,
        progression.buildingLevels.drugStorage,
      );
      const band = buildingTierBand(maxBuildingLevel);
      const current = buildingUsageMap.get(band) ?? { actions: 0, totalBonusPoints: 0 };
      current.actions += 1;
      current.totalBonusPoints += buildingBonus;
      buildingUsageMap.set(band, current);
    }
  }

  const hqBandUsage = [...hqUsageMap.entries()]
    .map(([hqBandLabel, stats]) => ({
      hqBand: hqBandLabel,
      actions: stats.actions,
      totalBonusPoints: stats.totalBonusPoints,
      avgBonusPoints: stats.actions <= 0 ? 0 : Number((stats.totalBonusPoints / stats.actions).toFixed(2)),
    }))
    .sort((a, b) => a.hqBand.localeCompare(b.hqBand));

  const buildingTierUsage = [...buildingUsageMap.entries()]
    .map(([buildingTierLabel, stats]) => ({
      buildingTier: buildingTierLabel,
      actions: stats.actions,
      totalBonusPoints: stats.totalBonusPoints,
      avgBonusPoints: stats.actions <= 0 ? 0 : Number((stats.totalBonusPoints / stats.actions).toFixed(2)),
    }))
    .sort((a, b) => a.buildingTier.localeCompare(b.buildingTier));

  return {
    windowHours,
    rewardPerMinute: {
      totalCash,
      totalXp,
      totalRewards,
      cashPerMinute: Number((totalCash / Math.max(1, minutes)).toFixed(2)),
      rewardsPerMinute: Number((totalRewards / Math.max(1, minutes)).toFixed(3)),
      byValueTier: rewardByTier,
    },
    contestWinrateByHqBand,
    regionGrowthByCrewSize,
    bonusUsageByTier: {
      hqBand: hqBandUsage,
      buildingTier: buildingTierUsage,
    },
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
  telemetry: TerritoryAdminTelemetry;
}> {
  await syncContestLifecycle();

  const [cfg, seasons, countries, crews, leaderboard, contestRows, regionRows, telemetry] = await Promise.all([
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
    getAdminTelemetry(24),
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
    telemetry,
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
  const crewProgression = await getCrewTerritoryProgression(crewId);
  const caps = await buildViewerTerritoryCaps(crewId, cfg, crewProgression);
  const effectiveMaxRegionsPerCrew = caps.effectiveMaxRegions;
  const effectiveMaxContestsPerCrew = caps.effectiveMaxContests;

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
  if (Number(crewContests[0]?.cnt ?? 0) >= effectiveMaxContestsPerCrew) {
    throw new Error('CREW_CONTEST_LIMIT_REACHED');
  }

  // Validate max regions per crew
  const ownedCount = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_control WHERE ownerCrewId = ?`,
    crewId,
  );
  if (Number(ownedCount[0]?.cnt ?? 0) >= effectiveMaxRegionsPerCrew) {
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
): Promise<{
  pointsDelta: number;
  adjacentOwnedRegions: number;
  actionBonusPoints: number;
  strategicActionBonuses: Array<{
    bonusPoints: number;
    source: StrategicActionBonus['source'];
    labelNl: string;
    labelEn: string;
  }>;
  stabilityDelta: number;
  projectEffect: territoryProjectService.ContestProjectEffect | null;
  message: string;
}> {
  await syncContestLifecycle();

  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');
  const crewProgression = await getCrewTerritoryProgression(crewId);
  const projectConfig = getProjectConfig(cfg);

  const validActions = ['patrol', 'intel_scan', 'sabotage', 'supply_run', 'raid', 'defense'];
  if (!validActions.includes(actionType)) throw new Error('INVALID_ACTION_TYPE');
  const requiredHqLevel = Math.max(
    0,
    Math.floor(cfg.actionUnlockHqLevels[actionType as keyof typeof cfg.actionUnlockHqLevels] ?? 0),
  );
  if (crewProgression.hqGlobalLevel < requiredHqLevel) {
    throw new Error('HQ_LEVEL_REQUIRED');
  }

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

  // Cooldown check (surveillance grid can shorten intel_scan cooldown in-region)
  const cooldownProjects = await territoryProjectService.getProjectsByRegionKeys([contest.regionKey], projectConfig);
  const effectiveCooldownSeconds = actionType === 'intel_scan'
    ? territoryProjectService.intelCooldownSecondsForRegion(
      cfg.actionCooldownSeconds,
      cooldownProjects[contest.regionKey] ?? null,
      projectConfig,
    )
    : cfg.actionCooldownSeconds;
  const recentActions = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_actions
     WHERE actorId = ? AND contestId = ? AND createdAt > DATE_SUB(NOW(), INTERVAL ? SECOND)`,
    playerId, contestId, effectiveCooldownSeconds,
  );
  if (Number(recentActions[0]?.cnt ?? 0) > 0) throw new Error('ACTION_COOLDOWN');

  // Daily cap check (0 or negative disables hard daily cap)
  if (cfg.actionDailyCap > 0) {
    const todayActions = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
      `SELECT COUNT(*) AS cnt FROM territory_actions
       WHERE actorId = ? AND createdAt > DATE_SUB(NOW(), INTERVAL 24 HOUR)`,
      playerId,
    );
    if (Number(todayActions[0]?.cnt ?? 0) >= cfg.actionDailyCap) throw new Error('DAILY_CAP_REACHED');
  }

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
  const isAttacker = contest.attackerCrewId === crewId;
  const holderCrewId = contest.defenderCrewId ?? null;
  const holderAdjacentOwned = holderCrewId == null
    ? 0
    : await getAdjacentOwnedRegionCount(contestRegion, holderCrewId);
  const invasionFromOwnedNeighbor = isAttacker && adjacentOwnedRegions > 0;
  const pocketPressureForAttacker = isAttacker && holderAdjacentOwned <= 1;
  const strategicActionBonuses = buildStrategicActionBonuses(contestRegion, {
    holderAdjacentOwned: isAttacker ? 0 : adjacentOwnedRegions,
    invasionFromOwnedNeighbor,
    pocketPressureForAttacker,
  });
  const activeWarPressure = (await getActiveWarPressureEffects([contest.regionKey], new Date()))[contest.regionKey] ?? null;
  const warPressureApplies = activeWarPressure
    && activeWarPressure.favoredCrewId === crewId
    && attackerActions.has(actionType)
    && contest.defenderCrewId === activeWarPressure.affectedCrewId;
  const warPressureBonuses = warPressureApplies ? buildWarPressureActionBonuses(activeWarPressure) : [];
  const regionEvents = await territoryMetaService.getActiveRegionEvents([contest.regionKey], new Date());
  const regionEventBonuses = buildRegionEventActionBonuses(regionEvents[0] ?? null);
  const progressionBonuses = buildProgressionActionBonuses(crewProgression, cfg);
  const regionProjects = await territoryProjectService.getProjectsByRegionKeys([contest.regionKey], projectConfig);
  const projectBonuses = mapProjectBonusesToStrategic(regionProjects[contest.regionKey] ?? null, projectConfig);
  const allActionBonuses = [
    ...strategicActionBonuses,
    ...progressionBonuses,
    ...warPressureBonuses,
    ...regionEventBonuses,
    ...projectBonuses,
  ];
  const actionBonusPoints = getActionBonusForType(allActionBonuses, actionType);
  const pointsDelta = abuseFlagged ? 0 : ((ACTION_POINTS[actionType] ?? 4) + actionBonusPoints);
  const stabilityDelta = actionType === 'sabotage' ? -5 : (actionType === 'supply_run' ? 3 : 0);

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_actions (contestId, actorId, actorCrewId, regionKey, actionType, pointsDelta, stabilityDelta, abuseFlagged)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
    contestId, playerId, crewId, contest.regionKey, actionType, pointsDelta, stabilityDelta, abuseFlagged,
  );

  if (stabilityDelta !== 0) {
    await prisma.$executeRawUnsafe(
      `UPDATE territory_control
       SET stability = GREATEST(0, LEAST(100, stability + ?)), updatedAt = NOW()
       WHERE regionKey = ?`,
      stabilityDelta,
      contest.regionKey,
    );
  }

  const projectEffect = abuseFlagged
    ? null
    : await territoryProjectService.applyContestActionToProject({
      regionKey: contest.regionKey,
      actionType,
      actorCrewId: crewId,
      defenderCrewId: contest.defenderCrewId == null ? null : toNumeric(contest.defenderCrewId),
      config: projectConfig,
    });

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
    stabilityDelta,
    projectEffect,
    message: abuseFlagged ? 'ANTI_FARM_LIMITED' : 'ACTION_OK',
  };
}

export async function startRegionProject(
  playerId: number,
  crewId: number,
  regionKey: string,
  projectType: string,
  currentCountry: string | null | undefined,
): Promise<territoryProjectService.TerritoryRegionProject> {
  void playerId;
  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');
  const progression = await getCrewTerritoryProgression(crewId);
  const regions = await prisma.$queryRawUnsafe<RegionRow[]>(
    'SELECT * FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    regionKey,
  );
  if (!regions[0]) throw new Error('REGION_NOT_FOUND');
  return territoryProjectService.startRegionProject({
    crewId,
    regionKey,
    projectType,
    hqGlobalLevel: progression.hqGlobalLevel,
    strategicTags: parseStringArray(regions[0].strategicTagsJson),
    config: getProjectConfig(cfg),
    currentCountry,
    assertInCountry: assertPlayerInTerritoryCountry,
  });
}

export async function contributeRegionProject(
  playerId: number,
  crewId: number,
  regionKey: string,
  currentCountry: string | null | undefined,
): Promise<territoryProjectService.TerritoryRegionProject> {
  void playerId;
  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');
  return territoryProjectService.contributeRegionProject({
    crewId,
    regionKey,
    config: getProjectConfig(cfg),
    currentCountry,
    assertInCountry: assertPlayerInTerritoryCountry,
  });
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
  regions: Array<{ regionKey: string; nameNl: string; nameEn: string; stability: number; controlPercent: number; contestStatus: string | null; ownedSince: Date | null; currentHoldSeconds: number }>;
  season: SeasonRow | null;
  summary: TerritoryCrewEconomySummary;
  stats: territoryCrewStatsService.TerritoryCrewStatsBundle;
}> {
  await syncContestLifecycle();

  const [controlled, seasons, summary, stats] = await Promise.all([
    prisma.$queryRawUnsafe<Array<{ regionKey: string; nameNl: string; nameEn: string; stability: number; controlJson: string | null; ownerCrewId: number | null; ownedSince: Date | null }>>(
      `SELECT tc.regionKey, tr.nameNl, tr.nameEn, tc.stability, tc.controlJson, tc.ownerCrewId, tc.ownedSince
       FROM territory_control tc
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       WHERE tc.ownerCrewId = ?`,
      crewId,
    ),
    prisma.$queryRawUnsafe<SeasonRow[]>(
      `SELECT * FROM territory_seasons WHERE status = 'active' ORDER BY startsAt DESC LIMIT 1`
    ),
    getCrewEconomySummary(crewId),
    territoryCrewStatsService.getStatsBundleForCrew(crewId),
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

  const nowMs = Date.now();
  return {
    regions: controlled.map(r => {
      const cpJson = parseJson(r.controlJson);
      const controlPercent = r.ownerCrewId ? Number(cpJson[String(r.ownerCrewId)] ?? 0) : 0;
      const ownedSince = r.ownedSince ?? null;
      const currentHoldSeconds = ownedSince
        ? Math.max(0, Math.floor((nowMs - new Date(ownedSince).getTime()) / 1000))
        : 0;
      return {
        regionKey: r.regionKey,
        nameNl: r.nameNl,
        nameEn: r.nameEn,
        stability: r.stability,
        controlPercent,
        contestStatus: contestByRegion[r.regionKey] ?? null,
        ownedSince,
        currentHoldSeconds,
      };
    }),
    season: seasons[0] ?? null,
    summary,
    stats,
  };
}

export async function getLeaderboard(): Promise<Array<{
  crewId: number;
  crewName: string;
  regionsOwned: number;
  allTime: territoryCrewStatsService.TerritoryCrewStats;
  season: territoryCrewStatsService.TerritoryCrewStats | null;
  seasonKey: string | null;
  currentHoldSeconds: number;
}>> {
  await syncContestLifecycle();

  const seasonKey = await territoryCrewStatsService.getActiveSeasonKey();
  const leaderboard = await prisma.$queryRawUnsafe<Array<{ crewId: number; crewName: string; regionsOwned: number; currentHoldSeconds: number }>>(
    `SELECT c.id AS crewId, c.name AS crewName, COUNT(tc.id) AS regionsOwned,
            COALESCE(SUM(TIMESTAMPDIFF(SECOND, tc.ownedSince, NOW())), 0) AS currentHoldSeconds
     FROM territory_control tc
     JOIN crews c ON c.id = tc.ownerCrewId
     WHERE tc.ownerCrewId IS NOT NULL
     GROUP BY c.id, c.name
     ORDER BY regionsOwned DESC, c.name ASC
     LIMIT 20`
  );

  const crewIds = leaderboard.map((entry) => toNumeric(entry.crewId));
  const [allTimeByCrew, seasonByCrew] = await Promise.all([
    territoryCrewStatsService.getStatsByCrewIds(crewIds, territoryCrewStatsService.TERRITORY_STATS_ALL_TIME),
    seasonKey
      ? territoryCrewStatsService.getStatsByCrewIds(crewIds, seasonKey)
      : Promise.resolve({} as Record<number, territoryCrewStatsService.TerritoryCrewStats>),
  ]);

  return leaderboard.map((entry) => {
    const crewId = toNumeric(entry.crewId);
    return {
      crewId,
      crewName: entry.crewName,
      regionsOwned: toNumeric(entry.regionsOwned),
      currentHoldSeconds: toNumeric(entry.currentHoldSeconds),
      allTime: allTimeByCrew[crewId] ?? {
        crewId,
        seasonKey: territoryCrewStatsService.TERRITORY_STATS_ALL_TIME,
        regionsWon: 0,
        regionsDefended: 0,
        regionsLost: 0,
        contestsPlayed: 0,
        holdSecondsTotal: 0,
      },
      season: seasonKey ? (seasonByCrew[crewId] ?? {
        crewId,
        seasonKey,
        regionsWon: 0,
        regionsDefended: 0,
        regionsLost: 0,
        contestsPlayed: 0,
        holdSecondsTotal: 0,
      }) : null,
      seasonKey,
    };
  });
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

  const activeSeasonKey = await territoryCrewStatsService.getActiveSeasonKey();
  const controlRows = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null; ownedSince: Date | null }>>(
    'SELECT ownerCrewId, ownedSince FROM territory_control WHERE regionKey = ? LIMIT 1',
    contest.regionKey,
  );
  const previousOwnerId = controlRows[0]?.ownerCrewId == null ? null : toNumeric(controlRows[0].ownerCrewId);
  const previousOwnedSince = controlRows[0]?.ownedSince ?? null;

  await territoryCrewStatsService.bumpCrewStatsAllScopes(toNumeric(contest.attackerCrewId), activeSeasonKey, {
    contestsPlayed: 1,
  });
  if (contest.defenderCrewId != null) {
    await territoryCrewStatsService.bumpCrewStatsAllScopes(toNumeric(contest.defenderCrewId), activeSeasonKey, {
      contestsPlayed: 1,
    });
  }

  if (winnerCrewId !== null) {
    const ownershipChanged = previousOwnerId !== winnerCrewId;
    if (ownershipChanged && previousOwnerId != null) {
      await territoryCrewStatsService.bankHoldSecondsForOwner(
        previousOwnerId,
        previousOwnedSince,
        activeSeasonKey,
      );
    }

    if (winnerCrewId === toNumeric(contest.attackerCrewId)) {
      await territoryCrewStatsService.bumpCrewStatsAllScopes(winnerCrewId, activeSeasonKey, { regionsWon: 1 });
      if (contest.defenderCrewId != null) {
        await territoryCrewStatsService.bumpCrewStatsAllScopes(toNumeric(contest.defenderCrewId), activeSeasonKey, {
          regionsLost: 1,
        });
      }
    } else if (contest.defenderCrewId != null && winnerCrewId === toNumeric(contest.defenderCrewId)) {
      await territoryCrewStatsService.bumpCrewStatsAllScopes(winnerCrewId, activeSeasonKey, { regionsDefended: 1 });
    }

    await prisma.$executeRawUnsafe(
      `UPDATE territory_control
       SET ownerCrewId = ?, controlJson = ?, stability = 100, lastIncomeAt = NOW(),
           ownedSince = CASE WHEN ? THEN NOW() ELSE COALESCE(ownedSince, NOW()) END,
           updatedAt = NOW()
       WHERE regionKey = ?`,
      winnerCrewId,
      JSON.stringify({ [winnerCrewId]: 100 }),
      ownershipChanged ? 1 : 0,
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
  const activeSeasonKey = await territoryCrewStatsService.getActiveSeasonKey();
  const prev = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null; ownedSince: Date | null }>>(
    'SELECT ownerCrewId, ownedSince FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  const previousOwnerId = prev[0]?.ownerCrewId == null ? null : toNumeric(prev[0].ownerCrewId);
  if (previousOwnerId != null && previousOwnerId !== crewId) {
    await territoryCrewStatsService.bankHoldSecondsForOwner(
      previousOwnerId,
      prev[0]?.ownedSince ?? null,
      activeSeasonKey,
    );
  }
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control
     SET ownerCrewId = ?, controlJson = ?, stability = 100, lastIncomeAt = NOW(),
         ownedSince = CASE WHEN ? IS NULL THEN NULL ELSE NOW() END, updatedAt = NOW()
     WHERE regionKey = ?`,
    crewId,
    crewId ? JSON.stringify({ [crewId]: 100 }) : '{}',
    crewId,
    regionKey,
  );
}

export async function adminResetRegion(regionKey: string): Promise<void> {
  const activeSeasonKey = await territoryCrewStatsService.getActiveSeasonKey();
  const prev = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null; ownedSince: Date | null }>>(
    'SELECT ownerCrewId, ownedSince FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  const previousOwnerId = prev[0]?.ownerCrewId == null ? null : toNumeric(prev[0].ownerCrewId);
  if (previousOwnerId != null) {
    await territoryCrewStatsService.bankHoldSecondsForOwner(
      previousOwnerId,
      prev[0]?.ownedSince ?? null,
      activeSeasonKey,
    );
  }
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control SET ownerCrewId = NULL, controlJson = '{}', stability = 100, lastIncomeAt = NOW(), ownedSince = NULL WHERE regionKey = ?`,
    regionKey,
  );
  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests SET status = 'cancelled' WHERE regionKey = ? AND status NOT IN ('resolved', 'cancelled')`,
    regionKey,
  );
}

export async function adminStartSeason(seasonKey: string, startsAt: Date, endsAt: Date): Promise<void> {
  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_seasons (seasonKey, status, startsAt, endsAt, rewardConfigJson)
     VALUES (?, 'active', ?, ?, ?)
     ON DUPLICATE KEY UPDATE status = 'active', startsAt = ?, endsAt = ?,
       rewardConfigJson = COALESCE(rewardConfigJson, VALUES(rewardConfigJson)),
       rewardsDistributedAt = NULL`,
    seasonKey,
    startsAt,
    endsAt,
    territoryMetaService.defaultSeasonRewardConfigJson(),
    startsAt,
    endsAt,
  );
}

export async function adminCloseSeason(seasonKey: string): Promise<territoryMetaService.SeasonCloseResult> {
  const cfg = await getTerritoryConfig();
  const result = await territoryMetaService.closeSeasonAndDistributeAwards({
    seasonKey,
    rewardCashMultiplierPercent: cfg.rewardCashMultiplierPercent,
  });
  await _notifySeasonAwards(result).catch(() => {});
  return result;
}

export async function getTerritoryDramaSnapshot(): Promise<territoryMetaService.TerritoryDramaSnapshot> {
  await syncContestLifecycle();
  return territoryMetaService.getTerritoryDramaSnapshot();
}

async function _notifySeasonAwards(result: territoryMetaService.SeasonCloseResult): Promise<void> {
  if (result.alreadyDistributed || result.awards.length === 0) return;
  const byCrew = new Map<number, territoryMetaService.SeasonAwardPayout[]>();
  for (const award of result.awards) {
    const list = byCrew.get(award.crewId) ?? [];
    list.push(award);
    byCrew.set(award.crewId, list);
  }
  for (const [crewId, awards] of byCrew.entries()) {
    const players = await _getCrewPlayers(crewId);
    for (const p of players) {
      const lang = await _getPlayerLanguage(p.id);
      const lines = awards.map((award) => {
        const label = award.rewardType === 'season_expansion'
          ? (lang === 'nl' ? 'expansie' : 'expansion')
          : award.rewardType === 'season_defense'
            ? (lang === 'nl' ? 'verdediging' : 'defense')
            : (lang === 'nl' ? 'oorlogsfront' : 'war frontline');
        return `#${award.rank} ${label}: €${award.cashAmount.toLocaleString('en-US')}`;
      });
      const message = lang === 'nl'
        ? `Territory seizoen ${result.seasonKey} afgesloten. Jullie crew ontving:\n${lines.join('\n')}`
        : `Territory season ${result.seasonKey} closed. Your crew received:\n${lines.join('\n')}`;
      await _sendTerritoryInboxMessage(p.id, lang, message).catch(() => {});
    }
  }
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

async function _regionHasActiveWarAftermath(regionKey: string, affectedCrewId: number): Promise<boolean> {
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM territory_region_effects
     WHERE regionKey = ?
       AND effectType = 'crew_war_aftermath'
       AND affectedCrewId = ?
       AND resolvedAt IS NULL
       AND endsAt > NOW()
     LIMIT 1`,
    regionKey,
    affectedCrewId,
  );
  return rows.length > 0;
}

async function _regionNames(regionKey: string): Promise<{ nameNl: string; nameEn: string }> {
  const rows = await prisma.$queryRawUnsafe<Array<{ nameNl: string; nameEn: string }>>(
    `SELECT nameNl, nameEn FROM territory_regions WHERE regionKey = ? LIMIT 1`,
    regionKey,
  );
  return {
    nameNl: rows[0]?.nameNl || regionKey,
    nameEn: rows[0]?.nameEn || regionKey,
  };
}

function _regionNameForLang(names: { nameNl: string; nameEn: string }, lang: Language): string {
  return lang === 'nl' ? names.nameNl : names.nameEn;
}

async function _notifyCrewContestBecameActive(
  attackerCrewId: number,
  defenderCrewId: number | null,
  regionKey: string,
  contestId: number,
): Promise<void> {
  const names = await _regionNames(regionKey);
  const contestIdStr = String(contestId);
  const crewIds = defenderCrewId && defenderCrewId !== attackerCrewId
    ? [attackerCrewId, defenderCrewId]
    : [attackerCrewId];

  for (const crewId of crewIds) {
    const role = crewId === attackerCrewId ? 'attacker' : 'defender';
    const players = await _getCrewPlayers(crewId);
    for (const p of players) {
      const lang = await _getPlayerLanguage(p.id);
      const n = translationService.getTranslations(lang).notification;
      const copy = role === 'attacker'
        ? n.territoryContestActiveAttacker
        : n.territoryContestActiveDefender;
      const regionName = _regionNameForLang(names, lang);
      await notificationService.sendToPlayer(
        p.id,
        copy.title,
        copy.pushBody(regionName, contestIdStr),
        { type: 'territory_contest_active', regionKey, contestId: contestIdStr, role },
      ).catch(() => {});
      await _sendTerritoryInboxMessage(
        p.id,
        lang,
        copy.inboxMessage(regionName, contestIdStr),
      ).catch(() => {});
    }
  }
}

async function _notifyCrewContestStarted(crewId: number, regionKey: string, contestId: number): Promise<void> {
  const players = await _getCrewPlayers(crewId);
  const contestIdStr = String(contestId);
  const frontline = await _regionHasActiveWarAftermath(regionKey, crewId);
  for (const p of players) {
    const lang = await _getPlayerLanguage(p.id);
    const n = translationService.getTranslations(lang).notification;
    if (frontline) {
      await notificationService.sendTerritoryFrontlinePressureNotification(
        p.id,
        regionKey,
        { contestId, reason: 'contest_under_aftermath' },
        lang,
      ).catch(() => {});
    }
    await notificationService.sendToPlayer(
      p.id,
      n.territoryContestStarted.title,
      n.territoryContestStarted.pushBody(regionKey, contestIdStr),
      { type: 'territory_contest_started', regionKey, contestId: contestIdStr, frontlinePressure: frontline ? '1' : '0' },
    ).catch(() => {});
    await _sendTerritoryInboxMessage(
      p.id,
      lang,
      n.territoryContestStarted.inboxMessage(regionKey, contestIdStr),
    ).catch(() => {});
  }
}

async function _notifyCrewRegionCaptured(crewId: number, regionKey: string): Promise<void> {
  const players = await _getCrewPlayers(crewId);
  for (const p of players) {
    const lang = await _getPlayerLanguage(p.id);
    const n = translationService.getTranslations(lang).notification;
    await notificationService.sendToPlayer(
      p.id,
      n.territoryCaptured.title,
      n.territoryCaptured.pushBody(regionKey),
      { type: 'territory_captured', regionKey },
    ).catch(() => {});
    await _sendTerritoryInboxMessage(
      p.id,
      lang,
      n.territoryCaptured.inboxMessage(regionKey),
    ).catch(() => {});
  }
}

async function _notifyCrewRegionLost(crewId: number, regionKey: string): Promise<void> {
  const players = await _getCrewPlayers(crewId);
  for (const p of players) {
    const lang = await _getPlayerLanguage(p.id);
    const n = translationService.getTranslations(lang).notification;
    await notificationService.sendToPlayer(
      p.id,
      n.territoryLost.title,
      n.territoryLost.pushBody(regionKey),
      { type: 'territory_lost', regionKey },
    ).catch(() => {});
    await _sendTerritoryInboxMessage(
      p.id,
      lang,
      n.territoryLost.inboxMessage(regionKey),
    ).catch(() => {});
  }
}

async function _getCrewPlayers(crewId: number): Promise<Array<{ id: number }>> {
  return prisma.$queryRawUnsafe<Array<{ id: number }>>(
    'SELECT playerId AS id FROM crew_members WHERE crewId = ? LIMIT 50',
    crewId,
  );
}

async function _getPlayerLanguage(playerId: number): Promise<Language> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  return translationService.getPlayerLanguage(player ?? {});
}

/** Push + inbox share the same resolved `language` (one `findUnique` per player per notify). */
async function _sendTerritoryInboxMessage(
  playerId: number,
  language: Language,
  message: string,
): Promise<void> {
  const sender = translationService.getTranslations(language).common.territorySystemSender;
  await directMessageService.sendSystemMessage(playerId, message, {
    sendPush: false,
    senderName: sender,
  });
}

