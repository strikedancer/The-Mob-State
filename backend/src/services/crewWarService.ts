import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { notificationService } from './notificationService';
import { activityService } from './activityService';
import { discordWebhookService } from './discordWebhookService';
import { checkAndUnlockAchievements } from './achievementService';
import {
  applyWarRaidLoot,
  applyWarSabotage,
  isRaidLootTarget,
  isSabotageBuildingType,
  type RaidLootTarget,
} from './crewWarRaidService';

const CREW_WAR_RUNTIME_SETTING_DEFAULTS = {
  CREW_WAR_MIN_MEMBERS: '1',
  CREW_WAR_PREPARATION_MINUTES: '15',
  CREW_WAR_ACTIVE_HOURS: '24',
  CREW_WAR_LOCKDOWN_MINUTES: '30',
  CREW_WAR_COOLDOWN_HOURS: '8',
} as const;

const CREW_WAR_RUNTIME_SETTING_KEYS = Object.keys(CREW_WAR_RUNTIME_SETTING_DEFAULTS);

type CrewWarRuntimeConfig = {
  minMembers: number;
  preparationMinutes: number;
  activeHours: number;
  lockdownMinutes: number;
  cooldownHours: number;
};

const REPEATED_TARGET_WINDOW_MS = 30 * 60 * 1000;
const TERRITORY_TICK_MS = 30 * 60 * 1000;
const DEFAULT_REWARD_POOL = 150000;
const DEFAULT_WAR_TERRITORY_TARGET_COUNT = 3;

const WAR_ACTIONS: Record<string, {
  basePoints: number;
  cooldownMs: number;
  requiresTarget?: boolean;
  vipPlayerOnly?: boolean;
  vipCrewOnly?: boolean;
}> = {
  attack_kill: { basePoints: 12, cooldownMs: 20 * 60 * 1000, requiresTarget: true },
  attack_mug: { basePoints: 9, cooldownMs: 35 * 60 * 1000, requiresTarget: true },
  attack_sabotage: { basePoints: 8, cooldownMs: 30 * 60 * 1000, requiresTarget: true },
  defense_success: { basePoints: 6, cooldownMs: 45 * 60 * 1000 },
  intel_scan: { basePoints: 4, cooldownMs: 25 * 60 * 1000, vipPlayerOnly: true },
  raid: { basePoints: 15, cooldownMs: 60 * 60 * 1000, requiresTarget: true },
  crew_shield: { basePoints: 5, cooldownMs: 75 * 60 * 1000, vipCrewOnly: true },
  war_boost: { basePoints: 5, cooldownMs: 60 * 60 * 1000, vipPlayerOnly: true },
  territory_claim: { basePoints: 10, cooldownMs: 20 * 60 * 1000 },
};

const LEGACY_TERRITORIES = ['docks', 'downtown', 'harbor'];

type CrewWarTerritoryTarget = {
  regionKey: string;
  countryCode: string | null;
  nameNl: string;
  nameEn: string;
  ownerCrewId: number | null;
  ownerCrewName: string | null;
  currentHolderCrewId?: number | null;
  valueTier?: number;
  strategicTags?: string[];
  adjacentDefenderRegions?: number;
  adjacentAttackerRegions?: number;
  claimBonusPoints?: number;
  tickPoints?: number;
  warPriorityScore?: number;
};

type WarStatus = 'preparing' | 'active' | 'lockdown' | 'resolved' | 'archived' | 'cancelled';
type WarType = 'kill_war' | 'economy_war' | 'territory_war' | 'total_war';

type CrewWarRecord = Awaited<ReturnType<typeof prisma.crewWar.findUnique>>;

function asJson(value: string | null | undefined): Record<string, any> {
  if (!value) return {};
  try {
    const parsed = JSON.parse(value);
    return parsed && typeof parsed === 'object' ? parsed : {};
  } catch {
    return {};
  }
}

function stringifyJson(value: Record<string, any>): string {
  return JSON.stringify(value ?? {});
}

function clampInt(value: number, min: number, max: number, fallback: number): number {
  if (!Number.isFinite(value)) return fallback;
  return Math.min(max, Math.max(min, Math.floor(value)));
}

async function ensureRuntimeConfigTable(): Promise<void> {
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS runtime_config (
      configKey VARCHAR(120) NOT NULL PRIMARY KEY,
      configValue VARCHAR(255) NOT NULL,
      updatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
}

async function loadCrewWarRuntimeConfig(): Promise<CrewWarRuntimeConfig> {
  const defaults = { ...CREW_WAR_RUNTIME_SETTING_DEFAULTS };
  try {
    await ensureRuntimeConfigTable();
    const placeholders = CREW_WAR_RUNTIME_SETTING_KEYS.map(() => '?').join(', ');
    const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...CREW_WAR_RUNTIME_SETTING_KEYS,
    );
    for (const row of rows) {
      if (row.configKey in defaults) {
        defaults[row.configKey as keyof typeof defaults] = String(row.configValue ?? '');
      }
    }
  } catch {
    // Keep code defaults when runtime_config is unavailable.
  }

  const activeHours = clampInt(Number(defaults.CREW_WAR_ACTIVE_HOURS), 1, 72, 24);
  const lockdownMinutes = clampInt(Number(defaults.CREW_WAR_LOCKDOWN_MINUTES), 1, 180, 30);
  return {
    minMembers: clampInt(Number(defaults.CREW_WAR_MIN_MEMBERS), 1, 20, 1),
    preparationMinutes: clampInt(Number(defaults.CREW_WAR_PREPARATION_MINUTES), 1, 180, 15),
    activeHours,
    lockdownMinutes: Math.min(lockdownMinutes, activeHours * 60 - 1),
    cooldownHours: clampInt(Number(defaults.CREW_WAR_COOLDOWN_HOURS), 0, 72, 8),
  };
}

function warSchedule(
  from: Date,
  cfg: CrewWarRuntimeConfig,
  prepMinutes = cfg.preparationMinutes,
) {
  const activeFrom = new Date(from.getTime() + prepMinutes * 60 * 1000);
  const activeMs = cfg.activeHours * 60 * 60 * 1000;
  const lockdownMs = Math.min(cfg.lockdownMinutes * 60 * 1000, activeMs - 60_000);
  return {
    activeFrom,
    lockDownFrom: new Date(activeFrom.getTime() + Math.max(60_000, activeMs - lockdownMs)),
    endTime: new Date(activeFrom.getTime() + activeMs),
    cooldownUntil: new Date(activeFrom.getTime() + activeMs + cfg.cooldownHours * 60 * 60 * 1000),
  };
}

async function upsertCrewWarRuntimeConfigValues(updates: Record<string, string>): Promise<void> {
  await ensureRuntimeConfigTable();
  for (const [key, value] of Object.entries(updates)) {
    await prisma.$executeRawUnsafe(
      `
        INSERT INTO runtime_config (configKey, configValue)
        VALUES (?, ?)
        ON DUPLICATE KEY UPDATE configValue = VALUES(configValue)
      `,
      key,
      value,
    );
  }
}

async function getTerritoryWarAftermathConfig() {
  const keys = [
    'TERRITORY_WAR_AFTERMATH_HOURS',
    'TERRITORY_WAR_AFTERMATH_TARGET_ATTACK_BONUS',
    'TERRITORY_WAR_AFTERMATH_ADJACENT_ATTACK_BONUS',
    'TERRITORY_WAR_AFTERMATH_TARGET_STABILITY_PENALTY',
    'TERRITORY_WAR_AFTERMATH_ADJACENT_STABILITY_PENALTY',
  ];
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...keys,
  );
  const cfg = rows.reduce<Record<string, string>>((acc, row) => {
    acc[row.configKey] = row.configValue;
    return acc;
  }, {});
  return {
    hours: Number(cfg.TERRITORY_WAR_AFTERMATH_HOURS ?? 6),
    targetAttackBonus: Number(cfg.TERRITORY_WAR_AFTERMATH_TARGET_ATTACK_BONUS ?? 3),
    adjacentAttackBonus: Number(cfg.TERRITORY_WAR_AFTERMATH_ADJACENT_ATTACK_BONUS ?? 1),
    targetStabilityPenalty: Number(cfg.TERRITORY_WAR_AFTERMATH_TARGET_STABILITY_PENALTY ?? 20),
    adjacentStabilityPenalty: Number(cfg.TERRITORY_WAR_AFTERMATH_ADJACENT_STABILITY_PENALTY ?? 10),
  };
}

function parseStringArray(value: unknown): string[] {
  if (typeof value !== 'string' || value.trim().length === 0) return [];
  try {
    const parsed = JSON.parse(value);
    if (!Array.isArray(parsed)) return [];
    return [...new Set(parsed.map((entry) => String(entry ?? '').trim()).filter(Boolean))];
  } catch {
    return [];
  }
}

function computeStrategicClaimBonus(strategicTags: string[], valueTier: number, adjacentEnemyRegions: number): number {
  let bonus = valueTier >= 3 ? 1 : 0;
  if (strategicTags.includes('capital')) bonus += 2;
  if (strategicTags.includes('harbor')) bonus += 1;
  if (strategicTags.includes('industry')) bonus += 1;
  if (strategicTags.includes('logistics')) bonus += 1;
  if (strategicTags.includes('border')) bonus += 1;
  if (adjacentEnemyRegions > 0) bonus += 1;
  return Math.min(4, bonus);
}

function computeStrategicTickPoints(valueTier: number, strategicTags: string[], adjacentFriendlyRegions: number): number {
  let points = 4 + Math.max(0, valueTier - 1);
  if (strategicTags.includes('capital')) points += 2;
  if (strategicTags.includes('harbor') || strategicTags.includes('industry') || strategicTags.includes('logistics')) {
    points += 1;
  }
  points += Math.min(2, adjacentFriendlyRegions);
  return Math.min(10, points);
}

function computeWarPriorityScore(row: {
  ownerCrewId: number | null;
  valueTier: number;
  strategicTags: string[];
  adjacentDefenderRegions: number;
  adjacentAttackerRegions: number;
}, attackerCrewId: number, defenderCrewId: number): number {
  let score = row.valueTier * 10;
  if (row.ownerCrewId === defenderCrewId) {
    score += 50;
  } else if (row.ownerCrewId === attackerCrewId) {
    score += 24;
  } else {
    score += 8;
  }

  for (const tag of row.strategicTags) {
    switch (tag) {
      case 'capital':
        score += 18;
        break;
      case 'harbor':
        score += 12;
        break;
      case 'industry':
      case 'logistics':
        score += 10;
        break;
      case 'border':
        score += 8;
        break;
      default:
        break;
    }
  }

  score += row.adjacentDefenderRegions * 5;
  score += row.adjacentAttackerRegions * 3;
  return score;
}

function normalizeCrewWarTerritoryTarget(raw: any, territoryState: Record<string, any>): CrewWarTerritoryTarget | null {
  const regionKey = typeof raw?.regionKey === 'string' ? raw.regionKey.trim() : '';
  if (!regionKey) return null;
  const ownerCrewId = raw?.ownerCrewId == null ? null : Number(raw.ownerCrewId);
  const currentHolderRaw = territoryState[regionKey];
  const currentHolderCrewId = currentHolderRaw == null ? ownerCrewId : Number(currentHolderRaw);
  return {
    regionKey,
    countryCode: typeof raw?.countryCode === 'string' && raw.countryCode.trim().isNotEmpty ? raw.countryCode.trim() : null,
    nameNl: typeof raw?.nameNl === 'string' && raw.nameNl.trim().length > 0 ? raw.nameNl.trim() : regionKey,
    nameEn: typeof raw?.nameEn === 'string' && raw.nameEn.trim().length > 0 ? raw.nameEn.trim() : regionKey,
    ownerCrewId: Number.isFinite(ownerCrewId) ? ownerCrewId : null,
    ownerCrewName: typeof raw?.ownerCrewName === 'string' && raw.ownerCrewName.trim().length > 0 ? raw.ownerCrewName.trim() : null,
    currentHolderCrewId: Number.isFinite(currentHolderCrewId) ? currentHolderCrewId : null,
    valueTier: Number.isFinite(Number(raw?.valueTier)) ? Number(raw.valueTier) : 1,
    strategicTags: Array.isArray(raw?.strategicTags)
      ? [...new Set(raw.strategicTags.map((tag: unknown) => String(tag ?? '').trim()).filter(Boolean))]
      : [],
    adjacentDefenderRegions: Number.isFinite(Number(raw?.adjacentDefenderRegions)) ? Number(raw.adjacentDefenderRegions) : 0,
    adjacentAttackerRegions: Number.isFinite(Number(raw?.adjacentAttackerRegions)) ? Number(raw.adjacentAttackerRegions) : 0,
    claimBonusPoints: Number.isFinite(Number(raw?.claimBonusPoints)) ? Number(raw.claimBonusPoints) : 0,
    tickPoints: Number.isFinite(Number(raw?.tickPoints)) ? Number(raw.tickPoints) : 4,
    warPriorityScore: Number.isFinite(Number(raw?.warPriorityScore)) ? Number(raw.warPriorityScore) : 0,
  };
}

function getLegacyCrewWarTerritoryTargets(territoryState: Record<string, any>): CrewWarTerritoryTarget[] {
  const labels: Record<string, { nl: string; en: string }> = {
    docks: { nl: 'Havengebied', en: 'Docks' },
    downtown: { nl: 'Binnenstad', en: 'Downtown' },
    harbor: { nl: 'Haven', en: 'Harbor' },
  };
  return LEGACY_TERRITORIES.map((regionKey) => ({
    regionKey,
    countryCode: null,
    nameNl: labels[regionKey]?.nl ?? regionKey,
    nameEn: labels[regionKey]?.en ?? regionKey,
    ownerCrewId: null,
    ownerCrewName: null,
    currentHolderCrewId: territoryState[regionKey] == null ? null : Number(territoryState[regionKey]),
    valueTier: 1,
    strategicTags: [],
    adjacentDefenderRegions: 0,
    adjacentAttackerRegions: 0,
    claimBonusPoints: 0,
    tickPoints: 4,
    warPriorityScore: 0,
  }));
}

function getWarTerritoryTargetsFromMetadata(metadata: Record<string, any>): CrewWarTerritoryTarget[] {
  const territoryState = (metadata.territories ?? {}) as Record<string, any>;
  const rawTargets = Array.isArray(metadata.territoryTargets) ? metadata.territoryTargets : [];
  const normalized = rawTargets
    .map((target) => normalizeCrewWarTerritoryTarget(target, territoryState))
    .filter((target): target is CrewWarTerritoryTarget => target !== null);

  if (normalized.length > 0) {
    return normalized;
  }

  return getLegacyCrewWarTerritoryTargets(territoryState);
}

function pickTheaterTarget(targets: CrewWarTerritoryTarget[]): CrewWarTerritoryTarget | null {
  if (targets.length === 0) return null;
  return [...targets].sort((left, right) => {
    return (right.warPriorityScore ?? 0) - (left.warPriorityScore ?? 0)
      || (right.tickPoints ?? 0) - (left.tickPoints ?? 0)
      || (right.claimBonusPoints ?? 0) - (left.claimBonusPoints ?? 0)
      || left.regionKey.localeCompare(right.regionKey);
  })[0] ?? null;
}

function attachTheaterMetadata(
  metadata: Record<string, any>,
  warType: WarType,
  targets: CrewWarTerritoryTarget[],
): Record<string, any> {
  if (warType !== 'territory_war' && warType !== 'total_war') {
    return metadata;
  }
  const theater = pickTheaterTarget(targets);
  if (!theater) return metadata;
  metadata.theaterRegionKey = theater.regionKey;
  metadata.theaterNameNl = theater.nameNl;
  metadata.theaterNameEn = theater.nameEn;
  return metadata;
}

async function buildCrewWarTerritoryTargets(attackerCrewId: number, defenderCrewId: number): Promise<CrewWarTerritoryTarget[]> {
  const rows = await prisma.$queryRawUnsafe<Array<{
    regionKey: string;
    countryCode: string;
    nameNl: string;
    nameEn: string;
    valueTier: number;
    strategicTagsJson: string | null;
    neighborsJson: string | null;
    ownerCrewId: number | null;
    ownerCrewName: string | null;
  }>>(
    `SELECT tr.regionKey, tr.countryCode, tr.nameNl, tr.nameEn, tr.valueTier, tr.strategicTagsJson, tr.neighborsJson, tc.ownerCrewId, c.name AS ownerCrewName
     FROM territory_regions tr
     LEFT JOIN territory_control tc ON tc.regionKey = tr.regionKey
     LEFT JOIN crews c ON c.id = tc.ownerCrewId
     WHERE tr.enabled = 1`,
  );

  const ownerByRegion = new Map(rows.map((row) => [row.regionKey, row.ownerCrewId]));
  const candidateTargets = rows.map((row) => {
    const strategicTags = parseStringArray(row.strategicTagsJson).map((tag) => tag.toLowerCase());
    const neighbors = parseStringArray(row.neighborsJson);
    const adjacentDefenderRegions = neighbors.reduce((count, neighborKey) => {
      return count + (ownerByRegion.get(neighborKey) === defenderCrewId ? 1 : 0);
    }, 0);
    const adjacentAttackerRegions = neighbors.reduce((count, neighborKey) => {
      return count + (ownerByRegion.get(neighborKey) === attackerCrewId ? 1 : 0);
    }, 0);
    const claimBonusPoints = computeStrategicClaimBonus(
      strategicTags,
      Number(row.valueTier ?? 1),
      Math.max(adjacentDefenderRegions, adjacentAttackerRegions),
    );
    const tickPoints = computeStrategicTickPoints(
      Number(row.valueTier ?? 1),
      strategicTags,
      Math.max(adjacentDefenderRegions, adjacentAttackerRegions),
    );
    const warPriorityScore = computeWarPriorityScore({
      ownerCrewId: row.ownerCrewId,
      valueTier: Number(row.valueTier ?? 1),
      strategicTags,
      adjacentDefenderRegions,
      adjacentAttackerRegions,
    }, attackerCrewId, defenderCrewId);

    return {
      regionKey: row.regionKey,
      countryCode: row.countryCode,
      nameNl: row.nameNl,
      nameEn: row.nameEn,
      ownerCrewId: row.ownerCrewId,
      ownerCrewName: row.ownerCrewName,
      currentHolderCrewId: row.ownerCrewId,
      valueTier: Number(row.valueTier ?? 1),
      strategicTags,
      adjacentDefenderRegions,
      adjacentAttackerRegions,
      claimBonusPoints,
      tickPoints,
      warPriorityScore,
    } satisfies CrewWarTerritoryTarget;
  });

  const selected = candidateTargets
    .sort((left, right) => {
      return (right.warPriorityScore ?? 0) - (left.warPriorityScore ?? 0)
        || (right.tickPoints ?? 0) - (left.tickPoints ?? 0)
        || (right.claimBonusPoints ?? 0) - (left.claimBonusPoints ?? 0)
        || (right.valueTier ?? 1) - (left.valueTier ?? 1)
        || left.regionKey.localeCompare(right.regionKey);
    })
    .slice(0, DEFAULT_WAR_TERRITORY_TARGET_COUNT);

  return selected.size > 0 ? Array.from(selected.values()) : getLegacyCrewWarTerritoryTargets({});
}

function isVipActive(entity: { isVip: boolean; vipExpiresAt: Date | null } | null | undefined): boolean {
  if (!entity?.isVip) return false;
  if (!entity.vipExpiresAt) return true;
  return entity.vipExpiresAt.getTime() > Date.now();
}

function getMonthSeasonBounds(now = new Date()) {
  const startsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), 1, 0, 0, 0));
  const endsAt = new Date(Date.UTC(now.getUTCFullYear(), now.getUTCMonth() + 1, 1, 0, 0, 0));
  const seasonKey = `${startsAt.getUTCFullYear()}-${String(startsAt.getUTCMonth() + 1).padStart(2, '0')}`;
  return { seasonKey, startsAt, endsAt };
}

async function ensureCurrentSeason() {
  const { seasonKey, startsAt, endsAt } = getMonthSeasonBounds();
  let season = await prisma.crewWarSeason.findUnique({ where: { seasonKey } });
  if (!season) {
    season = await prisma.crewWarSeason.create({
      data: {
        seasonKey,
        startsAt,
        endsAt,
        status: 'active',
        rewardConfigJson: stringifyJson({
          winnerCrewBankReward: 300000,
          topPlayerReward: 75000,
        }),
      },
    });
  }

  await prisma.crewWarSeason.updateMany({
    where: {
      id: { not: season.id },
      status: 'active',
      endsAt: { lte: new Date() },
    },
    data: { status: 'resolved' },
  });

  return season;
}

async function getCrewMemberCount(crewId: number) {
  return prisma.crewMember.count({ where: { crewId } });
}

async function getWarByIdRaw(warId: number) {
  return prisma.crewWar.findUnique({ where: { id: warId } });
}

async function upsertStanding(tx: any, warId: number, crewId: number, delta: {
  totalPoints?: number;
  totalKills?: number;
  totalDeaths?: number;
  totalLoot?: number;
  territoriesHeld?: number;
}) {
  return tx.crewWarStanding.upsert({
    where: {
      warId_crewId: {
        warId,
        crewId,
      },
    },
    create: {
      warId,
      crewId,
      totalPoints: delta.totalPoints ?? 0,
      totalKills: delta.totalKills ?? 0,
      totalDeaths: delta.totalDeaths ?? 0,
      totalLoot: delta.totalLoot ?? 0,
      territoriesHeld: delta.territoriesHeld ?? 0,
      rank: 0,
    },
    update: {
      totalPoints: { increment: delta.totalPoints ?? 0 },
      totalKills: { increment: delta.totalKills ?? 0 },
      totalDeaths: { increment: delta.totalDeaths ?? 0 },
      totalLoot: { increment: delta.totalLoot ?? 0 },
      territoriesHeld: delta.territoriesHeld !== undefined ? delta.territoriesHeld : undefined,
    },
  });
}

async function recomputeRanks(tx: any, warId: number) {
  const standings = await tx.crewWarStanding.findMany({
    where: { warId },
    orderBy: [
      { totalPoints: 'desc' },
      { totalKills: 'desc' },
      { totalLoot: 'desc' },
      { totalDeaths: 'asc' },
    ],
  });

  for (let index = 0; index < standings.length; index += 1) {
    await tx.crewWarStanding.update({
      where: { id: standings[index].id },
      data: { rank: index + 1 },
    });
  }
}

async function applyTerritoryTicks(war: NonNullable<CrewWarRecord>) {
  if (war.status !== 'active' && war.status !== 'lockdown') return;
  if (war.warType !== 'territory_war' && war.warType !== 'total_war') return;

  const now = new Date();
  const metadata = asJson(war.metadataJson);
  const territories = metadata.territories ?? {};
  const territoryTargets = getWarTerritoryTargetsFromMetadata(metadata);
  let lastTickAt = metadata.lastTerritoryTickAt ? new Date(metadata.lastTerritoryTickAt) : new Date(war.activeFrom);
  const tickUntil = new Date(Math.min(now.getTime(), war.endTime.getTime()));

  if (Number.isNaN(lastTickAt.getTime())) {
    lastTickAt = new Date(war.activeFrom);
  }

  let changed = false;
  while (lastTickAt.getTime() + TERRITORY_TICK_MS <= tickUntil.getTime()) {
    const ownershipCounts = [war.attackerCrewId, war.defenderCrewId].reduce<Record<number, number>>((acc, crewId) => {
      acc[crewId] = 0;
      return acc;
    }, {});

    for (const territory of territoryTargets) {
      const territoryKey = territory.regionKey;
      const ownerCrewId = Number(territories[territoryKey] ?? 0);
      if (ownerCrewId && ownershipCounts[ownerCrewId] !== undefined) {
        ownershipCounts[ownerCrewId] += 1;
      }
    }

    await prisma.$transaction(async (tx) => {
      for (const [crewIdRaw, heldCount] of Object.entries(ownershipCounts)) {
        const crewId = Number(crewIdRaw);
        if (heldCount <= 0) continue;
        const heldTerritories = territoryTargets.filter((territory) => Number(territories[territory.regionKey] ?? 0) === crewId);
        const pointsAwarded = heldTerritories.reduce((sum, territory) => sum + (territory.tickPoints ?? 4), 0);
        await upsertStanding(tx, war.id, crewId, {
          totalPoints: pointsAwarded,
          territoriesHeld: heldCount,
        });
        await tx.crewWarAction.create({
          data: {
            warId: war.id,
            actorCrewId: crewId,
            actionType: 'territory_tick',
            result: 'awarded',
            pointsAwarded,
            metadataJson: stringifyJson({
              heldCount,
              tickAt: lastTickAt.toISOString(),
              territories: heldTerritories.map((territory) => ({
                regionKey: territory.regionKey,
                tickPoints: territory.tickPoints ?? 4,
              })),
            }),
          },
        });
      }

      await recomputeRanks(tx, war.id);
    });

    lastTickAt = new Date(lastTickAt.getTime() + TERRITORY_TICK_MS);
    changed = true;
  }

  if (changed) {
    metadata.lastTerritoryTickAt = lastTickAt.toISOString();
    await prisma.crewWar.update({
      where: { id: war.id },
      data: { metadataJson: stringifyJson(metadata) },
    });
  }
}

async function applyTerritoryWarAftermath(war: NonNullable<CrewWarRecord>, winnerCrewId: number | null) {
  if (!winnerCrewId) return null;
  if (war.warType !== 'territory_war' && war.warType !== 'total_war') return null;

  const loserCrewId = winnerCrewId === war.attackerCrewId ? war.defenderCrewId : war.attackerCrewId;
  if (!loserCrewId) return null;

  const metadata = asJson(war.metadataJson);
  const territoryTargets = getWarTerritoryTargetsFromMetadata(metadata);
  if (territoryTargets.length === 0) return null;

  const territoryState = (metadata.territories ?? {}) as Record<string, any>;
  const winnerHeldTargets = territoryTargets.filter((target) => Number(territoryState[target.regionKey] ?? 0) === winnerCrewId);
  const rankedTargets = (winnerHeldTargets.length > 0 ? winnerHeldTargets : territoryTargets).sort((left, right) => {
    return (right.warPriorityScore ?? 0) - (left.warPriorityScore ?? 0)
      || (right.tickPoints ?? 0) - (left.tickPoints ?? 0)
      || left.regionKey.localeCompare(right.regionKey);
  });
  const theaterTarget = rankedTargets[0] ?? null;
  if (!theaterTarget) return null;

  const theaterRows = await prisma.$queryRawUnsafe<Array<{ regionKey: string; neighborsJson: string | null }>>(
    'SELECT regionKey, neighborsJson FROM territory_regions WHERE regionKey = ? LIMIT 1',
    theaterTarget.regionKey,
  );
  const theaterRow = theaterRows[0];
  let theaterNeighbors: string[] = [];
  if (theaterRow?.neighborsJson) {
    try {
      const parsed = JSON.parse(theaterRow.neighborsJson);
      if (Array.isArray(parsed)) {
        theaterNeighbors = [...new Set(parsed.map((entry) => String(entry ?? '').trim()).filter(Boolean))];
      }
    } catch {
      theaterNeighbors = [];
    }
  }

  const targetKeys = territoryTargets.map((target) => target.regionKey);
  const candidateKeys = [...new Set([theaterTarget.regionKey, ...targetKeys, ...theaterNeighbors])];
  if (candidateKeys.length === 0) return null;

  const placeholders = candidateKeys.map(() => '?').join(', ');
  const controlRows = await prisma.$queryRawUnsafe<Array<{ regionKey: string; ownerCrewId: number | null }>>(
    `SELECT regionKey, ownerCrewId FROM territory_control WHERE regionKey IN (${placeholders})`,
    ...candidateKeys,
  );
  const ownerMap = new Map(controlRows.map((row) => [row.regionKey, row.ownerCrewId]));

  const cfg = await getTerritoryWarAftermathConfig();
  const now = new Date();
  const endsAt = new Date(now.getTime() + (Math.max(1, cfg.hours) * 60 * 60 * 1000));
  const effectRows = [
    ...targetKeys
      .filter((regionKey) => ownerMap.get(regionKey) === loserCrewId)
      .map((regionKey) => ({
        regionKey,
        regionRole: regionKey === theaterTarget.regionKey ? 'theater' : 'target',
        attackBonusPoints: cfg.targetAttackBonus,
        stabilityPenalty: cfg.targetStabilityPenalty,
      })),
    ...theaterNeighbors
      .filter((regionKey) => ownerMap.get(regionKey) === loserCrewId && !targetKeys.includes(regionKey))
      .map((regionKey) => ({
        regionKey,
        regionRole: 'adjacent' as const,
        attackBonusPoints: cfg.adjacentAttackBonus,
        stabilityPenalty: cfg.adjacentStabilityPenalty,
      })),
  ];

  if (effectRows.length === 0) return null;

  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_effects
     SET resolvedAt = NOW()
     WHERE effectType = 'crew_war_aftermath' AND sourceType = 'crew_war' AND sourceId = ? AND resolvedAt IS NULL`,
    war.id,
  );

  for (const effect of effectRows) {
    await prisma.$executeRawUnsafe(
      `INSERT INTO territory_region_effects
         (regionKey, effectType, sourceType, sourceId, favoredCrewId, affectedCrewId, metadataJson, startsAt, endsAt)
       VALUES (?, 'crew_war_aftermath', 'crew_war', ?, ?, ?, ?, ?, ?)`,
      effect.regionKey,
      war.id,
      winnerCrewId,
      loserCrewId,
      stringifyJson({
        regionRole: effect.regionRole,
        attackBonusPoints: effect.attackBonusPoints,
        stabilityPenalty: effect.stabilityPenalty,
      }),
      now,
      endsAt,
    );
  }

  return {
    theaterRegionKey: theaterTarget.regionKey,
    affectedRegionKeys: effectRows.map((effect) => effect.regionKey),
    favoredCrewId: winnerCrewId,
    affectedCrewId: loserCrewId,
    endsAt,
  };
}

async function finalizeWar(war: NonNullable<CrewWarRecord>) {
  if (war.resolvedAt) return;

  await applyTerritoryTicks(war);

  let topParticipantReward: { playerId: number; rewardMoney: number } | null = null;

  await prisma.$transaction(async (tx) => {
    const standings = await tx.crewWarStanding.findMany({
      where: { warId: war.id },
      orderBy: [
        { totalPoints: 'desc' },
        { totalKills: 'desc' },
        { totalLoot: 'desc' },
        { totalDeaths: 'asc' },
      ],
    });

    if (standings.length === 0) {
      await tx.crewWarStanding.createMany({
        data: [
          { warId: war.id, crewId: war.attackerCrewId, rank: 1 },
          { warId: war.id, crewId: war.defenderCrewId, rank: 2 },
        ],
      });
    }

    const sortedStandings = standings.length > 0 ? standings : await tx.crewWarStanding.findMany({
      where: { warId: war.id },
      orderBy: { rank: 'asc' },
    });

    const winningStanding = sortedStandings[0] ?? null;
    const winnerCrewId = winningStanding?.crewId ?? null;
    const rewardPool = DEFAULT_REWARD_POOL + (war.entryStake || 0);

    if (winnerCrewId) {
      await tx.crew.update({
        where: { id: winnerCrewId },
        data: { bankBalance: { increment: rewardPool } },
      });
    }

    const topParticipant = await tx.crewWarParticipant.findFirst({
      where: { warId: war.id },
      orderBy: [
        { points: 'desc' },
        { kills: 'desc' },
        { lootStolen: 'desc' },
      ],
    });

    if (topParticipant) {
      await tx.player.update({
        where: { id: topParticipant.playerId },
        data: { money: { increment: 75000 }, reputation: { increment: 3 } },
      });
      topParticipantReward = { playerId: topParticipant.playerId, rewardMoney: 75000 };
    }

    await tx.crewWar.update({
      where: { id: war.id },
      data: {
        status: 'resolved',
        winnerCrewId,
        resolvedAt: new Date(),
      },
    });

    await recomputeRanks(tx, war.id);
  });

  const latestWar = await prisma.crewWar.findUnique({ where: { id: war.id } });
  const territoryAftermath = latestWar?.winnerCrewId ? await applyTerritoryWarAftermath(war, latestWar.winnerCrewId) : null;
  const crews = await prisma.crew.findMany({
    where: { id: { in: [war.attackerCrewId, war.defenderCrewId] } },
    select: { id: true, name: true },
  });
  const crewNameMap = crews.reduce<Record<number, string>>((acc, crew) => {
    acc[crew.id] = crew.name;
    return acc;
  }, {});
  const memberRows = await prisma.crewMember.findMany({
    where: { crewId: { in: [war.attackerCrewId, war.defenderCrewId] } },
    include: { player: { select: { id: true, preferredLanguage: true } } },
  });

  if (latestWar?.winnerCrewId) {
    for (const member of memberRows) {
      await notificationService.sendCrewWarEndedNotification(
        member.player.id,
        latestWar.id,
        latestWar.winnerCrewId,
        crewNameMap[latestWar.winnerCrewId] ?? null,
        territoryAftermath,
      );
    }
  }

  // Dedicated frontline-pressure ping for the losing crew when aftermath lands.
  if (
    territoryAftermath &&
    territoryAftermath.affectedCrewId &&
    Array.isArray(territoryAftermath.affectedRegionKeys) &&
    territoryAftermath.affectedRegionKeys.length > 0
  ) {
    const theaterKey =
      territoryAftermath.theaterRegionKey ?? territoryAftermath.affectedRegionKeys[0];
    for (const member of memberRows) {
      if (member.crewId !== territoryAftermath.affectedCrewId) continue;
      await notificationService.sendTerritoryFrontlinePressureNotification(
        member.player.id,
        theaterKey,
        {
          reason: 'war_aftermath',
          endsAt: territoryAftermath.endsAt,
          affectedRegionCount: territoryAftermath.affectedRegionKeys.length,
        },
      );
    }
  }

  if (topParticipantReward) {
    await activityService.logActivity(
      topParticipantReward.playerId,
      'crew_war_reward',
      'Crew war MVP reward received',
      { warId: war.id, rewardMoney: topParticipantReward.rewardMoney },
      true,
    );

    void checkAndUnlockAchievements(topParticipantReward.playerId).catch((error) => {
      console.error('[CrewWarService] Achievement check after war MVP reward failed:', error);
    });
  }

  await worldEventService.createEvent('crew.war_resolved', {
    warId: war.id,
    winnerCrewId: latestWar?.winnerCrewId,
    attackerCrewId: war.attackerCrewId,
    defenderCrewId: war.defenderCrewId,
    territoryAftermath,
  });

  void postCrewWarDiscord('war_resolved', war, { winnerCrewId: latestWar?.winnerCrewId });
}

async function syncWarLifecycle(warId: number) {
  const war = await getWarByIdRaw(warId);
  if (!war || war.status === 'resolved' || war.status === 'archived' || war.status === 'cancelled') {
    return war;
  }

  const now = new Date();
  let current = war;

  if (current.status === 'preparing' && current.activeFrom <= now) {
    current = await prisma.crewWar.update({
      where: { id: current.id },
      data: { status: 'active', startTime: now },
    });
    await notifyWarMembers(current, 'started');
    await worldEventService.createEvent('crew.war_started', {
      warId: current.id,
      attackerCrewId: current.attackerCrewId,
      defenderCrewId: current.defenderCrewId,
    });
    void postCrewWarDiscord('war_started', current);
  }

  if (current.status === 'active') {
    await applyTerritoryTicks(current);
    if (current.lockDownFrom <= now) {
      current = await prisma.crewWar.update({
        where: { id: current.id },
        data: { status: 'lockdown' },
      });
      await notifyWarMembers(current, 'lockdown');
      await worldEventService.createEvent('crew.war_lockdown', { warId: current.id });
      void postCrewWarDiscord('war_lockdown', current);
    }
  }

  if ((current.status === 'active' || current.status === 'lockdown') && current.endTime <= now) {
    await finalizeWar(current);
    return prisma.crewWar.findUnique({ where: { id: current.id } });
  }

  return current;
}

async function syncCrewWarsForCrew(crewId: number) {
  const openWars = await prisma.crewWar.findMany({
    where: {
      status: { in: ['preparing', 'active', 'lockdown'] },
      OR: [{ attackerCrewId: crewId }, { defenderCrewId: crewId }],
    },
    select: { id: true },
  });

  for (const war of openWars) {
    await syncWarLifecycle(war.id);
  }
}

async function getCrewNames(crewIds: number[]) {
  const crews = await prisma.crew.findMany({
    where: { id: { in: crewIds } },
    select: { id: true, name: true, isVip: true, vipExpiresAt: true, bankBalance: true },
  });
  return new Map(crews.map((crew) => [crew.id, crew]));
}

function warTypeLabelNl(warType: string | null | undefined): string {
  switch (warType) {
    case 'kill_war':
      return 'Kill-oorlog';
    case 'economy_war':
      return 'Economie-oorlog';
    case 'territory_war':
      return 'Territoriumoorlog';
    case 'total_war':
      return 'Totale oorlog';
    default:
      return warType?.trim() || 'Oorlog';
  }
}

async function postCrewWarDiscord(
  eventType: 'war_declared' | 'war_started' | 'war_lockdown' | 'war_resolved',
  war: {
    id: number;
    attackerCrewId: number;
    defenderCrewId: number;
    warType?: string | null;
    endTime?: Date | null;
    winnerCrewId?: number | null;
  },
  options?: { viaAdmin?: boolean; winnerCrewId?: number | null },
) {
  try {
    const winnerCrewId = options?.winnerCrewId ?? war.winnerCrewId ?? null;
    const crewMap = await getCrewNames([war.attackerCrewId, war.defenderCrewId]);
    let attackerPoints: number | null = null;
    let defenderPoints: number | null = null;
    if (eventType === 'war_resolved') {
      const standings = await prisma.crewWarStanding.findMany({
        where: { warId: war.id },
        select: { crewId: true, totalPoints: true },
      });
      attackerPoints = standings.find((row) => row.crewId === war.attackerCrewId)?.totalPoints ?? 0;
      defenderPoints = standings.find((row) => row.crewId === war.defenderCrewId)?.totalPoints ?? 0;
    }

    await discordWebhookService.sendCrewWarEvent(eventType, {
      warId: war.id,
      attackerName: crewMap.get(war.attackerCrewId)?.name ?? `Crew ${war.attackerCrewId}`,
      defenderName: crewMap.get(war.defenderCrewId)?.name ?? `Crew ${war.defenderCrewId}`,
      warTypeLabel: warTypeLabelNl(war.warType),
      winnerName: winnerCrewId ? crewMap.get(winnerCrewId)?.name ?? null : null,
      attackerPoints,
      defenderPoints,
      endsAt: war.endTime ?? null,
      viaAdmin: options?.viaAdmin === true,
    });
  } catch (error) {
    console.warn('[CrewWarService] Discord war post failed:', error);
  }
}

type DeclareBlockReason = 'not_leader' | 'in_war' | 'not_enough_members' | 'on_cooldown' | null;

async function listResolvedCooldownWars() {
  return prisma.crewWar.findMany({
    where: {
      status: { in: ['resolved', 'archived'] },
      cooldownUntil: { gt: new Date() },
    },
    select: {
      attackerCrewId: true,
      defenderCrewId: true,
      cooldownUntil: true,
    },
  });
}

function resolveDeclareBlockReason(input: {
  role: string;
  currentWar: unknown;
  memberCount: number;
  inCooldown: boolean;
  minMembers: number;
}): DeclareBlockReason {
  if (input.currentWar) return 'in_war';
  if (input.role !== 'leader') return 'not_leader';
  if (input.inCooldown) return 'on_cooldown';
  if (input.memberCount < input.minMembers) return 'not_enough_members';
  return null;
}

async function notifyWarMembers(
  war: { id: number; attackerCrewId: number; defenderCrewId: number },
  type: 'declared' | 'started' | 'lockdown',
) {
  const [crewMap, memberRows] = await Promise.all([
    getCrewNames([war.attackerCrewId, war.defenderCrewId]),
    prisma.crewMember.findMany({
      where: { crewId: { in: [war.attackerCrewId, war.defenderCrewId] } },
      include: { player: { select: { id: true } } },
    }),
  ]);

  for (const member of memberRows) {
    const opposingCrewId = member.crewId === war.attackerCrewId ? war.defenderCrewId : war.attackerCrewId;
    const opposingCrewName = crewMap.get(opposingCrewId)?.name ?? `#${opposingCrewId}`;

    if (type === 'declared') {
      await notificationService.sendCrewWarDeclaredNotification(member.player.id, war.id, opposingCrewName);
    } else if (type === 'started') {
      await notificationService.sendCrewWarStartedNotification(member.player.id, war.id, opposingCrewName);
    } else {
      await notificationService.sendCrewWarLockdownNotification(member.player.id, war.id, opposingCrewName);
    }
  }
}

async function getPlayerNames(playerIds: number[]) {
  const players = await prisma.player.findMany({
    where: { id: { in: playerIds } },
    select: { id: true, username: true, preferredLanguage: true, isVip: true, vipExpiresAt: true },
  });
  return new Map(players.map((player) => [player.id, player]));
}

async function buildWarDetail(warId: number, playerId?: number) {
  const war = await syncWarLifecycle(warId);
  if (!war) {
    throw new Error('WAR_NOT_FOUND');
  }

  const viewerMembership = playerId
    ? await prisma.crewMember.findFirst({
        where: { playerId },
        select: { crewId: true, role: true },
      })
    : null;
  const opponentCrewId = viewerMembership
    ? war.attackerCrewId === viewerMembership.crewId
      ? war.defenderCrewId
      : war.defenderCrewId === viewerMembership.crewId
        ? war.attackerCrewId
        : null
    : null;

  const [standings, participants, actions, opponentMembers] = await Promise.all([
    prisma.crewWarStanding.findMany({
      where: { warId },
      orderBy: [{ rank: 'asc' }, { totalPoints: 'desc' }],
    }),
    prisma.crewWarParticipant.findMany({
      where: { warId },
      orderBy: [{ points: 'desc' }, { kills: 'desc' }, { joinedAt: 'asc' }],
    }),
    prisma.crewWarAction.findMany({
      where: { warId },
      orderBy: { createdAt: 'desc' },
      take: 25,
    }),
    opponentCrewId
      ? prisma.crewMember.findMany({
          where: { crewId: opponentCrewId },
          include: {
            player: {
              select: {
                id: true,
                username: true,
              },
            },
          },
          orderBy: [{ role: 'asc' }, { playerId: 'asc' }],
        })
      : Promise.resolve([]),
  ]);

  const crewMap = await getCrewNames([
    war.attackerCrewId,
    war.defenderCrewId,
    ...standings.map((entry) => entry.crewId),
    ...participants.map((entry) => entry.crewId),
    ...actions.map((entry) => entry.actorCrewId).filter((value): value is number => typeof value === 'number'),
    ...actions.map((entry) => entry.targetCrewId).filter((value): value is number => typeof value === 'number'),
  ]);
  const playerMap = await getPlayerNames([
    ...participants.map((entry) => entry.playerId),
    ...actions.map((entry) => entry.actorId).filter((value): value is number => typeof value === 'number'),
    ...actions.map((entry) => entry.targetId).filter((value): value is number => typeof value === 'number'),
  ]);

  const metadata = asJson(war.metadataJson);
  metadata.territoryTargets = getWarTerritoryTargetsFromMetadata(metadata);
  if (
    (war.warType === 'territory_war' || war.warType === 'total_war') &&
    !String(metadata.theaterRegionKey ?? '').trim()
  ) {
    attachTheaterMetadata(metadata, war.warType as WarType, metadata.territoryTargets);
    if (metadata.theaterRegionKey) {
      await prisma.crewWar.update({
        where: { id: war.id },
        data: { metadataJson: stringifyJson(metadata) },
      });
    }
  }
  const joinedParticipant = playerId
    ? participants.find((entry) => entry.playerId === playerId) ?? null
    : null;
  const participantMap = new Map(participants.map((entry) => [entry.playerId, entry]));

  return {
    ...war,
    metadata,
    attackerCrew: crewMap.get(war.attackerCrewId) ?? null,
    defenderCrew: crewMap.get(war.defenderCrewId) ?? null,
    winnerCrew: war.winnerCrewId ? crewMap.get(war.winnerCrewId) ?? null : null,
    opponentCrew: opponentCrewId ? crewMap.get(opponentCrewId) ?? null : null,
    standings: standings.map((entry) => ({
      ...entry,
      crew: crewMap.get(entry.crewId) ?? null,
    })),
    participants: participants.map((entry) => ({
      ...entry,
      player: playerMap.get(entry.playerId) ?? null,
      crew: crewMap.get(entry.crewId) ?? null,
    })),
    recentActions: actions.map((entry) => ({
      ...entry,
      metadata: asJson(entry.metadataJson),
      actor: entry.actorId ? playerMap.get(entry.actorId) ?? null : null,
      target: entry.targetId ? playerMap.get(entry.targetId) ?? null : null,
      actorCrew: entry.actorCrewId ? crewMap.get(entry.actorCrewId) ?? null : null,
      targetCrew: entry.targetCrewId ? crewMap.get(entry.targetCrewId) ?? null : null,
    })),
    opponentMembers: opponentMembers.map((entry) => {
      const participant = participantMap.get(entry.playerId);
      return {
        playerId: entry.playerId,
        role: entry.role,
        player: entry.player,
        participant: participant
          ? {
              actionCount: participant.actionCount,
              kills: participant.kills,
              deaths: participant.deaths,
              points: participant.points,
              status: participant.status,
            }
          : null,
      };
    }),
    myParticipant: joinedParticipant,
  };
}

async function getMemberRole(crewId: number, playerId: number) {
  return prisma.crewMember.findFirst({
    where: { crewId, playerId },
    select: { role: true },
  });
}

export async function getWarHubForPlayer(playerId: number) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });

  const season = await ensureCurrentSeason();
  const warCfg = await loadCrewWarRuntimeConfig();

  if (!membership) {
    return {
      myCrewId: null,
      myRole: null,
      canDeclare: false,
      declareBlockReason: null,
      minMembersRequired: warCfg.minMembers,
      currentWar: null,
      availableTargets: [],
      season,
      seasonLeaderboard: [],
      recentWars: [],
    };
  }

  await syncCrewWarsForCrew(membership.crewId);

  const [currentWarRecord, crews, recentWars, seasonStandings] = await Promise.all([
    prisma.crewWar.findFirst({
      where: {
        status: { in: ['preparing', 'active', 'lockdown'] },
        OR: [{ attackerCrewId: membership.crewId }, { defenderCrewId: membership.crewId }],
      },
      orderBy: { createdAt: 'desc' },
    }),
    prisma.crew.findMany({
      where: { id: { not: membership.crewId } },
      orderBy: { name: 'asc' },
      select: { id: true, name: true, isVip: true, vipExpiresAt: true, bankBalance: true },
    }),
    prisma.crewWar.findMany({
      where: {
        OR: [{ attackerCrewId: membership.crewId }, { defenderCrewId: membership.crewId }],
      },
      orderBy: { createdAt: 'desc' },
      take: 8,
    }),
    prisma.crewWarStanding.findMany({
      where: {
        warId: {
          in: (await prisma.crewWar.findMany({
            where: { seasonId: season.id, status: { in: ['resolved', 'archived'] } },
            select: { id: true },
          })).map((war) => war.id),
        },
      },
    }),
  ]);

  const currentWar = currentWarRecord ? await buildWarDetail(currentWarRecord.id, playerId) : null;
  const cooldownWars = await listResolvedCooldownWars();
  const targetCrewIdsInCooldown = new Set(
    cooldownWars.flatMap((war) => [war.attackerCrewId, war.defenderCrewId]),
  );
  const myCrewCooldownUntil = cooldownWars.reduce<Date | null>((latest, war) => {
    if (war.attackerCrewId !== membership.crewId && war.defenderCrewId !== membership.crewId) {
      return latest;
    }
    if (!war.cooldownUntil) return latest;
    if (!latest || war.cooldownUntil > latest) return war.cooldownUntil;
    return latest;
  }, null);
  const myCrewInCooldown = myCrewCooldownUntil != null;
  const crewCounts = await prisma.crewMember.groupBy({ by: ['crewId'], _count: { _all: true } });
  const countMap = new Map(crewCounts.map((entry) => [entry.crewId, entry._count._all]));
  const myCrewMemberCount = countMap.get(membership.crewId) ?? 0;
  const declareBlockReason = resolveDeclareBlockReason({
    role: membership.role,
    currentWar,
    memberCount: myCrewMemberCount,
    inCooldown: myCrewInCooldown,
    minMembers: warCfg.minMembers,
  });
  const recentCrewMap = await getCrewNames(
    recentWars.flatMap((war) => [war.attackerCrewId, war.defenderCrewId]),
  );

  const seasonAggregate = new Map<number, { crewId: number; totalPoints: number; totalKills: number; totalLoot: number }>();
  for (const standing of seasonStandings) {
    const existing = seasonAggregate.get(standing.crewId) ?? {
      crewId: standing.crewId,
      totalPoints: 0,
      totalKills: 0,
      totalLoot: 0,
    };
    existing.totalPoints += standing.totalPoints;
    existing.totalKills += standing.totalKills;
    existing.totalLoot += standing.totalLoot;
    seasonAggregate.set(standing.crewId, existing);
  }

  const seasonLeaderboard = Array.from(seasonAggregate.values())
    .sort((left, right) => right.totalPoints - left.totalPoints || right.totalKills - left.totalKills || right.totalLoot - left.totalLoot)
    .slice(0, 10);
  const seasonCrewMap = await getCrewNames(seasonLeaderboard.map((entry) => entry.crewId));

  return {
    myCrewId: membership.crewId,
    myRole: membership.role,
    canDeclare: declareBlockReason === null,
    declareBlockReason,
    minMembersRequired: warCfg.minMembers,
    myCrewMemberCount,
    myCrewInCooldown,
    myCrewCooldownUntil,
    currentWar,
    availableTargets: crews
      .map((crew) => ({
        ...crew,
        memberCount: countMap.get(crew.id) ?? 0,
        inCooldown: targetCrewIdsInCooldown.has(crew.id),
        isVipActive: isVipActive(crew),
      }))
      .filter((crew) => (countMap.get(crew.id) ?? 0) >= warCfg.minMembers),
    season,
    seasonLeaderboard: seasonLeaderboard.map((entry, index) => ({
      rank: index + 1,
      ...entry,
      crew: seasonCrewMap.get(entry.crewId) ?? null,
    })),
    recentWars: recentWars.map((war) => ({
      id: war.id,
      warType: war.warType,
      status: war.status,
      attackerCrewId: war.attackerCrewId,
      defenderCrewId: war.defenderCrewId,
      winnerCrewId: war.winnerCrewId,
      activeFrom: war.activeFrom,
      endTime: war.endTime,
      cooldownUntil: war.cooldownUntil,
      attackerCrew: recentCrewMap.get(war.attackerCrewId) ?? null,
      defenderCrew: recentCrewMap.get(war.defenderCrewId) ?? null,
    })),
  };
}

export async function declareWar(playerId: number, targetCrewId: number, warType: WarType) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });

  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }
  if (membership.role !== 'leader') {
    throw new Error('NOT_CREW_LEADER');
  }
  if (membership.crewId === targetCrewId) {
    throw new Error('CANNOT_DECLARE_OWN_CREW');
  }

  const [sourceMembers, targetMembers, targetCrew] = await Promise.all([
    getCrewMemberCount(membership.crewId),
    getCrewMemberCount(targetCrewId),
    prisma.crew.findUnique({ where: { id: targetCrewId }, select: { id: true, name: true } }),
  ]);

  if (!targetCrew) {
    throw new Error('TARGET_CREW_NOT_FOUND');
  }
  const warCfg = await loadCrewWarRuntimeConfig();
  if (sourceMembers < warCfg.minMembers || targetMembers < warCfg.minMembers) {
    throw new Error('NOT_ENOUGH_CREW_MEMBERS');
  }

  await syncCrewWarsForCrew(membership.crewId);
  await syncCrewWarsForCrew(targetCrewId);

  const existingWar = await prisma.crewWar.findFirst({
    where: {
      status: { in: ['preparing', 'active', 'lockdown'] },
      OR: [
        { attackerCrewId: membership.crewId },
        { defenderCrewId: membership.crewId },
        { attackerCrewId: targetCrewId },
        { defenderCrewId: targetCrewId },
      ],
    },
  });
  if (existingWar) {
    throw new Error('CREW_ALREADY_IN_WAR');
  }

  const cooldownWar = await prisma.crewWar.findFirst({
    where: {
      status: { in: ['resolved', 'archived'] },
      cooldownUntil: { gt: new Date() },
      OR: [
        { attackerCrewId: membership.crewId },
        { defenderCrewId: membership.crewId },
        { attackerCrewId: targetCrewId },
        { defenderCrewId: targetCrewId },
      ],
    },
  });
  if (cooldownWar) {
    throw new Error('CREW_WAR_COOLDOWN');
  }

  const season = await ensureCurrentSeason();
  const now = new Date();
  const { activeFrom, lockDownFrom, endTime, cooldownUntil } = warSchedule(now, warCfg);
  const territoryTargets = await buildCrewWarTerritoryTargets(membership.crewId, targetCrewId);
  const metadata: Record<string, any> = {
    territoryTargets,
    lastTerritoryTickAt: activeFrom.toISOString(),
  };
  metadata.territories = Object.fromEntries(
    territoryTargets.map((territory) => [territory.regionKey, territory.ownerCrewId ?? null]),
  );
  attachTheaterMetadata(metadata, warType, territoryTargets);

  const war = await prisma.$transaction(async (tx) => {
    const createdWar = await tx.crewWar.create({
      data: {
        seasonId: season.id,
        warType,
        status: 'preparing',
        declaredByPlayerId: playerId,
        attackerCrewId: membership.crewId,
        defenderCrewId: targetCrewId,
        metadataJson: stringifyJson(metadata),
        startTime: now,
        activeFrom,
        lockDownFrom,
        endTime,
        cooldownUntil,
        entryStake: 0,
      },
    });

    await tx.crewWarStanding.createMany({
      data: [
        { warId: createdWar.id, crewId: membership.crewId, rank: 1 },
        { warId: createdWar.id, crewId: targetCrewId, rank: 2 },
      ],
    });

    await tx.crewWarParticipant.create({
      data: {
        warId: createdWar.id,
        playerId,
        crewId: membership.crewId,
        role: membership.role,
      },
    });

    await tx.crewWarAction.create({
      data: {
        warId: createdWar.id,
        actorId: playerId,
        actorCrewId: membership.crewId,
        targetCrewId,
        actionType: 'war_declared',
        result: 'success',
        metadataJson: stringifyJson({ warType }),
      },
    });

    return createdWar;
  });

  await notifyWarMembers(war, 'declared');

  await worldEventService.createEvent('crew.war_declared', {
    warId: war.id,
    attackerCrewId: membership.crewId,
    defenderCrewId: targetCrewId,
    warType,
  });

  void postCrewWarDiscord('war_declared', war);

  return buildWarDetail(war.id, playerId);
}

export async function joinWar(playerId: number, warId: number) {
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });
  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }

  const war = await syncWarLifecycle(warId);
  if (!war) {
    throw new Error('WAR_NOT_FOUND');
  }
  if (![war.attackerCrewId, war.defenderCrewId].includes(membership.crewId)) {
    throw new Error('NOT_WAR_PARTICIPANT_CREW');
  }
  if (!['preparing', 'active', 'lockdown'].includes(war.status)) {
    throw new Error('WAR_NOT_JOINABLE');
  }

  await prisma.crewWarParticipant.upsert({
    where: { warId_playerId: { warId, playerId } },
    create: {
      warId,
      playerId,
      crewId: membership.crewId,
      role: membership.role,
    },
    update: {
      crewId: membership.crewId,
      role: membership.role,
      status: 'joined',
    },
  });

  return buildWarDetail(warId, playerId);
}

export async function performWarAction(
  playerId: number,
  warId: number,
  actionType: string,
  targetPlayerId?: number,
  territoryKey?: string,
  lootTarget?: string,
  sabotageBuilding?: string,
) {
  const actionConfig = WAR_ACTIONS[actionType];
  if (!actionConfig) {
    throw new Error('INVALID_WAR_ACTION');
  }

  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true, role: true },
  });
  if (!membership) {
    throw new Error('NOT_IN_CREW');
  }

  const war = await syncWarLifecycle(warId);
  if (!war) {
    throw new Error('WAR_NOT_FOUND');
  }
  if (war.status !== 'active') {
    throw new Error('WAR_NOT_ACTIVE');
  }
  if (![war.attackerCrewId, war.defenderCrewId].includes(membership.crewId)) {
    throw new Error('NOT_WAR_PARTICIPANT_CREW');
  }

  const enemyCrewId = war.attackerCrewId === membership.crewId ? war.defenderCrewId : war.attackerCrewId;
  const [player, crew, targetPlayer, existingParticipant] = await Promise.all([
    prisma.player.findUnique({ where: { id: playerId }, select: { id: true, username: true, isVip: true, vipExpiresAt: true } }),
    prisma.crew.findUnique({ where: { id: membership.crewId }, select: { id: true, name: true, isVip: true, vipExpiresAt: true } }),
    targetPlayerId
      ? prisma.crewMember.findFirst({
          where: { playerId: targetPlayerId, crewId: enemyCrewId },
          include: { player: { select: { id: true, username: true } } },
        })
      : Promise.resolve(null),
    prisma.crewWarParticipant.findUnique({
      where: { warId_playerId: { warId, playerId } },
    }),
  ]);

  if (!player || !crew) {
    throw new Error('WAR_ACTOR_NOT_FOUND');
  }
  if (actionConfig.requiresTarget && !targetPlayer) {
    throw new Error('WAR_TARGET_REQUIRED');
  }
  if (actionConfig.vipPlayerOnly && !isVipActive(player)) {
    throw new Error('VIP_PLAYER_REQUIRED');
  }
  if (actionConfig.vipCrewOnly && !isVipActive(crew)) {
    throw new Error('VIP_CREW_REQUIRED');
  }

  const participant = existingParticipant ?? await prisma.crewWarParticipant.create({
    data: {
      warId,
      playerId,
      crewId: membership.crewId,
      role: membership.role,
    },
  });

  const now = new Date();
  if (participant.lastActionAt && participant.lastActionAt.getTime() + actionConfig.cooldownMs > now.getTime()) {
    const remainingMs = participant.lastActionAt.getTime() + actionConfig.cooldownMs - now.getTime();
    const remainingMinutes = Math.ceil(remainingMs / 60000);
    throw new Error(`WAR_ACTION_COOLDOWN:${remainingMinutes}`);
  }

  const maxActions = isVipActive(player) ? 28 : 20;
  if (participant.actionCount >= maxActions) {
    throw new Error('WAR_ACTION_LIMIT_REACHED');
  }

  if (targetPlayerId) {
    const repeatedAction = await prisma.crewWarAction.findFirst({
      where: {
        warId,
        actorId: playerId,
        targetId: targetPlayerId,
        createdAt: { gte: new Date(Date.now() - REPEATED_TARGET_WINDOW_MS) },
        result: 'success',
      },
      orderBy: { createdAt: 'desc' },
    });
    if (repeatedAction) {
      await prisma.crewWarAction.create({
        data: {
          warId,
          actorId: playerId,
          actorCrewId: membership.crewId,
          targetId: targetPlayerId,
          targetCrewId: enemyCrewId,
          actionType,
          result: 'blocked_repeated_target',
          metadataJson: stringifyJson({ repeatedActionId: repeatedAction.id }),
        },
      });
      throw new Error('WAR_REPEATED_TARGET_BLOCKED');
    }
  }

  const crewVipBonus = isVipActive(crew) ? 1.1 : 1;
  const playerVipBonus = isVipActive(player) ? 1.15 : 1;
  let pointsAwarded = Math.round(actionConfig.basePoints * crewVipBonus * playerVipBonus);
  let moneyDelta = 0;
  let metadata = asJson(undefined);
  let raidTarget: RaidLootTarget = 'cash';
  if (actionType === 'raid') {
    raidTarget = isRaidLootTarget(lootTarget) ? lootTarget : 'cash';
  }
  if (actionType === 'attack_sabotage' && !isSabotageBuildingType(sabotageBuilding)) {
    throw new Error('WAR_BUILDING_REQUIRED');
  }

  if (actionType === 'attack_mug') {
    const targetCrew = await prisma.crew.findUnique({
      where: { id: enemyCrewId },
      select: { bankBalance: true },
    });
    const bankBalance = targetCrew?.bankBalance ?? 0;
    moneyDelta = Math.max(0, Math.min(25000, Math.floor(bankBalance * 0.03)));
    pointsAwarded += moneyDelta > 0 ? 2 : 0;
  }

  if (actionType === 'territory_claim') {
    if (war.warType !== 'territory_war' && war.warType !== 'total_war') {
      throw new Error('WAR_TERRITORY_UNAVAILABLE');
    }
    const territoryTargets = getWarTerritoryTargetsFromMetadata(asJson(war.metadataJson));
    const availableKeys = territoryTargets.map((territory) => territory.regionKey);
    if (!territoryKey || !availableKeys.includes(territoryKey)) {
      throw new Error('INVALID_TERRITORY');
    }
    const warMetadata = asJson(war.metadataJson);
    const territories = warMetadata.territories ?? {};
    warMetadata.territoryTargets = getWarTerritoryTargetsFromMetadata(warMetadata);
    const previousOwner = territories[territoryKey] ?? null;
    territories[territoryKey] = membership.crewId;
    warMetadata.territories = territories;
    const territoryInfo = territoryTargets.find((territory) => territory.regionKey === territoryKey);
    metadata = {
      territoryKey,
      territoryNameNl: territoryInfo?.nameNl ?? territoryKey,
      territoryNameEn: territoryInfo?.nameEn ?? territoryKey,
      claimBonusPoints: territoryInfo?.claimBonusPoints ?? 0,
      tickPoints: territoryInfo?.tickPoints ?? 4,
      strategicTags: territoryInfo?.strategicTags ?? [],
      previousOwner,
      newOwner: membership.crewId,
    };
    pointsAwarded += territoryInfo?.claimBonusPoints ?? 0;
    await prisma.crewWar.update({
      where: { id: warId },
      data: { metadataJson: stringifyJson(warMetadata) },
    });

    const heldByActor = availableKeys.filter((key) => territories[key] === membership.crewId).length;
    const heldByEnemy = availableKeys.filter((key) => territories[key] === enemyCrewId).length;
    await prisma.crewWarStanding.upsert({
      where: { warId_crewId: { warId, crewId: membership.crewId } },
      create: { warId, crewId: membership.crewId, territoriesHeld: heldByActor, rank: 1 },
      update: { territoriesHeld: heldByActor },
    });
    await prisma.crewWarStanding.upsert({
      where: { warId_crewId: { warId, crewId: enemyCrewId } },
      create: { warId, crewId: enemyCrewId, territoriesHeld: heldByEnemy, rank: 2 },
      update: { territoriesHeld: heldByEnemy },
    });
  }

  await prisma.$transaction(async (tx) => {
    if (actionType === 'raid') {
      const loot = await applyWarRaidLoot(tx, {
        warId,
        attackerCrewId: membership.crewId,
        defenderCrewId: enemyCrewId,
        actorPlayerId: playerId,
        lootTarget: raidTarget,
      });
      moneyDelta = loot.moneyDelta;
      metadata = { ...metadata, ...loot.metadata };
      pointsAwarded += loot.metadata.taken === true ? 2 : 0;
    }

    if (actionType === 'attack_sabotage' && isSabotageBuildingType(sabotageBuilding)) {
      const sabotage = await applyWarSabotage(tx, {
        warId,
        attackerCrewId: membership.crewId,
        defenderCrewId: enemyCrewId,
        buildingType: sabotageBuilding,
      });
      metadata = { ...metadata, ...sabotage.metadata };
      if (sabotage.metadata.levelDropped === true) {
        pointsAwarded += 4;
      }
    }

    if (actionType === 'attack_mug' && moneyDelta > 0) {
      await tx.crew.update({
        where: { id: enemyCrewId },
        data: { bankBalance: { decrement: moneyDelta } },
      });
      await tx.crew.update({
        where: { id: membership.crewId },
        data: { bankBalance: { increment: moneyDelta } },
      });
    }

    await tx.crewWarParticipant.update({
      where: { id: participant.id },
      data: {
        points: { increment: pointsAwarded },
        kills: actionType === 'attack_kill' ? { increment: 1 } : undefined,
        lootStolen: moneyDelta > 0 ? { increment: moneyDelta } : undefined,
        actionCount: { increment: 1 },
        lastActionAt: now,
      },
    });

    if (targetPlayerId) {
      await tx.crewWarParticipant.upsert({
        where: { warId_playerId: { warId, playerId: targetPlayerId } },
        create: {
          warId,
          playerId: targetPlayerId,
          crewId: enemyCrewId,
          role: targetPlayer?.role ?? 'member',
          deaths: actionType === 'attack_kill' ? 1 : 0,
        },
        update: {
          deaths: actionType === 'attack_kill' ? { increment: 1 } : undefined,
        },
      });
    }

    await upsertStanding(tx, warId, membership.crewId, {
      totalPoints: pointsAwarded,
      totalKills: actionType === 'attack_kill' ? 1 : 0,
      totalLoot: moneyDelta,
    });
    if (actionType === 'attack_kill') {
      await upsertStanding(tx, warId, enemyCrewId, {
        totalDeaths: 1,
      });
    }

    await tx.crewWarAction.create({
      data: {
        warId,
        actorId: playerId,
        actorCrewId: membership.crewId,
        targetId: targetPlayerId,
        targetCrewId: enemyCrewId,
        territoryKey: territoryKey ?? null,
        actionType,
        result: 'success',
        pointsAwarded,
        moneyDelta,
        metadataJson: stringifyJson({
          ...metadata,
          playerVip: isVipActive(player),
          crewVip: isVipActive(crew),
        }),
      },
    });

    await recomputeRanks(tx, warId);
  });

  await activityService.logActivity(
    playerId,
    'crew_war_action',
    `Crew war action: ${actionType}`,
    { warId, actionType, pointsAwarded, moneyDelta },
    true,
  );

  void checkAndUnlockAchievements(playerId).catch((error) => {
    console.error('[CrewWarService] Achievement check after war action failed:', error);
  });

  await worldEventService.createEvent('crew.war_action', {
    warId,
    actionType,
    actorId: playerId,
    actorCrewId: membership.crewId,
    targetId: targetPlayerId,
    targetCrewId: enemyCrewId,
    pointsAwarded,
    moneyDelta,
  });

  return buildWarDetail(warId, playerId);
}

export async function getWarDetailForPlayer(playerId: number, warId: number) {
  const detail = await buildWarDetail(warId, playerId);
  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true },
  });
  if (!membership || ![detail.attackerCrewId, detail.defenderCrewId].includes(membership.crewId)) {
    throw new Error('WAR_ACCESS_DENIED');
  }
  return detail;
}

export async function syncAllOpenCrewWars(): Promise<number> {
  const openWars = await prisma.crewWar.findMany({
    where: { status: { in: ['preparing', 'active', 'lockdown'] } },
    select: { id: true },
    orderBy: [{ activeFrom: 'asc' }, { createdAt: 'desc' }],
  });
  for (const war of openWars) {
    try {
      await syncWarLifecycle(war.id);
    } catch (error) {
      console.error(`[CrewWarService] Lifecycle sync failed for war ${war.id}:`, error);
    }
  }
  return openWars.length;
}

export async function getAdminWarOverview() {
  await syncAllOpenCrewWars();

  const season = await ensureCurrentSeason();
  const [activeWars, recentWars, flaggedActions, crews] = await Promise.all([
    prisma.crewWar.findMany({
      where: { status: { in: ['preparing', 'active', 'lockdown'] } },
      orderBy: [{ activeFrom: 'asc' }, { createdAt: 'desc' }],
      take: 20,
    }),
    prisma.crewWar.findMany({
      orderBy: { createdAt: 'desc' },
      take: 20,
    }),
    prisma.crewWarAction.count({
      where: { result: { startsWith: 'blocked' } },
    }),
    prisma.crew.findMany({
      orderBy: { name: 'asc' },
      select: { id: true, name: true, isVip: true, vipExpiresAt: true, bankBalance: true },
    }),
  ]);

  const detailedActiveWars = await Promise.all(activeWars.map((war) => buildWarDetail(war.id)));
  const seasonWars = await prisma.crewWar.findMany({
    where: { seasonId: season.id, status: { in: ['resolved', 'archived'] } },
    select: { id: true },
  });
  const seasonStandings = await prisma.crewWarStanding.findMany({
    where: { warId: { in: seasonWars.map((war) => war.id) } },
  });
  const aggregates = new Map<number, { crewId: number; totalPoints: number; totalKills: number; totalLoot: number }>();
  for (const standing of seasonStandings) {
    const current = aggregates.get(standing.crewId) ?? { crewId: standing.crewId, totalPoints: 0, totalKills: 0, totalLoot: 0 };
    current.totalPoints += standing.totalPoints;
    current.totalKills += standing.totalKills;
    current.totalLoot += standing.totalLoot;
    aggregates.set(standing.crewId, current);
  }
  const leaderboard = Array.from(aggregates.values()).sort((left, right) => right.totalPoints - left.totalPoints || right.totalKills - left.totalKills);
  const crewMap = await getCrewNames(leaderboard.map((entry) => entry.crewId));

  return {
    season,
    flaggedActions,
    crews,
    activeWars: detailedActiveWars,
    recentWars,
    seasonLeaderboard: leaderboard.slice(0, 10).map((entry, index) => ({
      rank: index + 1,
      ...entry,
      crew: crewMap.get(entry.crewId) ?? null,
    })),
  };
}

export async function adminDeclareWar(adminId: number, payload: {
  attackerCrewId: number;
  defenderCrewId: number;
  warType: WarType;
  startsInMinutes?: number;
}) {
  const season = await ensureCurrentSeason();
  const now = new Date();
  const warCfg = await loadCrewWarRuntimeConfig();
  const startsInMinutes = Math.max(1, Math.min(180, payload.startsInMinutes ?? warCfg.preparationMinutes));
  const { activeFrom, lockDownFrom, endTime, cooldownUntil } = warSchedule(now, warCfg, startsInMinutes);
  const territoryTargets = await buildCrewWarTerritoryTargets(payload.attackerCrewId, payload.defenderCrewId);
  const metadata: Record<string, any> = {
    territoryTargets,
    territories: Object.fromEntries(
      territoryTargets.map((territory) => [territory.regionKey, territory.ownerCrewId ?? null]),
    ),
  };
  attachTheaterMetadata(metadata, payload.warType, territoryTargets);
  const war = await prisma.crewWar.create({
    data: {
      seasonId: season.id,
      warType: payload.warType,
      status: 'preparing',
      declaredByPlayerId: adminId,
      attackerCrewId: payload.attackerCrewId,
      defenderCrewId: payload.defenderCrewId,
      metadataJson: stringifyJson(metadata),
      startTime: now,
      activeFrom,
      lockDownFrom,
      endTime,
      cooldownUntil,
    },
  });

  await prisma.crewWarStanding.createMany({
    data: [
      { warId: war.id, crewId: payload.attackerCrewId, rank: 1 },
      { warId: war.id, crewId: payload.defenderCrewId, rank: 2 },
    ],
  });

  await prisma.crewWarAction.create({
    data: {
      warId: war.id,
      actorId: adminId,
      actorCrewId: payload.attackerCrewId,
      targetCrewId: payload.defenderCrewId,
      actionType: 'war_declared',
      result: 'success',
      metadataJson: stringifyJson({ warType: payload.warType, declaredVia: 'admin' }),
    },
  });

  await notifyWarMembers(war, 'declared');

  await worldEventService.createEvent('crew.war_declared', {
    warId: war.id,
    attackerCrewId: payload.attackerCrewId,
    defenderCrewId: payload.defenderCrewId,
    warType: payload.warType,
    declaredVia: 'admin',
  });

  void postCrewWarDiscord('war_declared', war, { viaAdmin: true });

  return buildWarDetail(war.id);
}

export async function adminUpdateWarStatus(warId: number, action: 'start_now' | 'enter_lockdown' | 'resolve' | 'archive' | 'cancel') {
  const war = await prisma.crewWar.findUnique({ where: { id: warId } });
  if (!war) throw new Error('WAR_NOT_FOUND');

  if (action === 'start_now') {
    const warCfg = await loadCrewWarRuntimeConfig();
    const schedule = warSchedule(new Date(), warCfg, 0);
    const updatedWar = await prisma.crewWar.update({
      where: { id: warId },
      data: {
        status: 'active',
        activeFrom: schedule.activeFrom,
        startTime: new Date(),
        lockDownFrom: schedule.lockDownFrom,
        endTime: schedule.endTime,
      },
    });
    await notifyWarMembers(updatedWar, 'started');
    await worldEventService.createEvent('crew.war_started', {
      warId: updatedWar.id,
      attackerCrewId: updatedWar.attackerCrewId,
      defenderCrewId: updatedWar.defenderCrewId,
      startedVia: 'admin',
    });
    void postCrewWarDiscord('war_started', updatedWar, { viaAdmin: true });
  } else if (action === 'enter_lockdown') {
    const updatedWar = await prisma.crewWar.update({ where: { id: warId }, data: { status: 'lockdown', lockDownFrom: new Date() } });
    await notifyWarMembers(updatedWar, 'lockdown');
    await worldEventService.createEvent('crew.war_lockdown', {
      warId: updatedWar.id,
      attackerCrewId: updatedWar.attackerCrewId,
      defenderCrewId: updatedWar.defenderCrewId,
      enteredVia: 'admin',
    });
    void postCrewWarDiscord('war_lockdown', updatedWar, { viaAdmin: true });
  } else if (action === 'resolve') {
    await finalizeWar(war);
  } else if (action === 'archive') {
    await prisma.crewWar.update({ where: { id: warId }, data: { status: 'archived' } });
  } else if (action === 'cancel') {
    await prisma.crewWar.update({ where: { id: warId }, data: { status: 'cancelled', resolvedAt: new Date() } });
  }

  return buildWarDetail(warId);
}

export async function getRuntimeConfigView() {
  const cfg = await loadCrewWarRuntimeConfig();
  const values = {
    CREW_WAR_MIN_MEMBERS: String(cfg.minMembers),
    CREW_WAR_PREPARATION_MINUTES: String(cfg.preparationMinutes),
    CREW_WAR_ACTIVE_HOURS: String(cfg.activeHours),
    CREW_WAR_LOCKDOWN_MINUTES: String(cfg.lockdownMinutes),
    CREW_WAR_COOLDOWN_HOURS: String(cfg.cooldownHours),
  };
  return {
    defaults: { ...CREW_WAR_RUNTIME_SETTING_DEFAULTS },
    values,
    keys: [...CREW_WAR_RUNTIME_SETTING_KEYS],
  };
}

export async function updateRuntimeConfig(updates: Record<string, string | number>) {
  const normalized: Record<string, string> = {};
  for (const [key, value] of Object.entries(updates)) {
    if (!CREW_WAR_RUNTIME_SETTING_KEYS.includes(key)) {
      throw new Error(`INVALID_RUNTIME_KEY:${key}`);
    }
    const asString = String(value ?? '').trim();
    const asNumber = Number(asString);
    if (!Number.isFinite(asNumber)) {
      throw new Error(`RUNTIME_VALUE_NOT_NUMERIC:${key}`);
    }
    if (key === 'CREW_WAR_MIN_MEMBERS' && (asNumber < 1 || asNumber > 20)) {
      throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
    }
    if (key === 'CREW_WAR_PREPARATION_MINUTES' && (asNumber < 1 || asNumber > 180)) {
      throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
    }
    if (key === 'CREW_WAR_ACTIVE_HOURS' && (asNumber < 1 || asNumber > 72)) {
      throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
    }
    if (key === 'CREW_WAR_LOCKDOWN_MINUTES' && (asNumber < 1 || asNumber > 180)) {
      throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
    }
    if (key === 'CREW_WAR_COOLDOWN_HOURS' && (asNumber < 0 || asNumber > 72)) {
      throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
    }
    normalized[key] = String(Math.floor(asNumber));
  }
  if (Object.keys(normalized).length > 0) {
    await upsertCrewWarRuntimeConfigValues(normalized);
  }
  return getRuntimeConfigView();
}