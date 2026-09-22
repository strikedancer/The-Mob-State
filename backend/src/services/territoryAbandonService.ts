/**
 * Voluntary territory abandon (relocate / free slots).
 * Region + whole-country flows; depot burns 100%; officer + travel gated.
 */

import prisma from '../lib/prisma';
import { notificationService } from './notificationService';
import * as territoryArsenalService from './territoryArsenalService';
import * as territoryCrewStatsService from './territoryCrewStatsService';
import {
  getTerritoryConfig,
  mapTravelCountryToTerritoryCode,
} from './territoryService';

function toNumeric(value: unknown): number {
  if (typeof value === 'number') return Number.isFinite(value) ? value : 0;
  if (typeof value === 'bigint') return Number(value);
  const parsed = Number(value ?? 0);
  return Number.isFinite(parsed) ? parsed : 0;
}

function passiveDailyForTier(
  tier: number,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): number {
  const intervalMinutes = Math.max(1, cfg.passiveIncomeIntervalMinutes);
  let perInterval = cfg.passiveIncomeTier1Cash;
  if (tier === 2) perInterval = cfg.passiveIncomeTier2Cash;
  else if (tier === 3) perInterval = cfg.passiveIncomeTier3Cash;
  else if (tier >= 4) perInterval = cfg.passiveIncomeTier4Cash;
  const perHour = Math.round(Math.max(0, perInterval) * (60 / intervalMinutes));
  return perHour * 24;
}

export function computeAbandonRegionCashCost(
  valueTier: number,
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): number {
  const flat = Math.max(0, Math.floor(cfg.abandonCostFlat));
  const days = Math.max(0, cfg.abandonCostDaysIncome);
  const fromIncome = Math.floor(days * passiveDailyForTier(valueTier, cfg));
  return Math.max(flat, fromIncome);
}

export function computeAbandonCountryCashCost(
  regionCosts: number[],
  cfg: Awaited<ReturnType<typeof getTerritoryConfig>>,
): number {
  const sum = regionCosts.reduce((s, n) => s + Math.max(0, n), 0);
  const factor = Math.max(0, Math.min(100, Math.floor(cfg.abandonCountryCostFactorPercent))) / 100;
  const flat = Math.max(0, Math.floor(cfg.abandonCountryFlat));
  return Math.floor(sum * factor) + flat;
}

type CooldownKind = 'region' | 'country';

async function readCooldown(crewId: number, kind: CooldownKind): Promise<Date | null> {
  const rows = await prisma.$queryRawUnsafe<Array<{ availableAt: Date }>>(
    `SELECT availableAt FROM territory_abandon_cooldowns WHERE crewId = ? AND kind = ? LIMIT 1`,
    crewId,
    kind,
  );
  return rows[0]?.availableAt ?? null;
}

async function setCooldown(crewId: number, kind: CooldownKind, availableAt: Date): Promise<void> {
  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_abandon_cooldowns (crewId, kind, availableAt)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE availableAt = VALUES(availableAt), updatedAt = CURRENT_TIMESTAMP`,
    crewId,
    kind,
    availableAt,
  );
}

function secondsUntil(availableAt: Date | null, now: Date): number {
  if (!availableAt) return 0;
  const ms = availableAt.getTime() - now.getTime();
  return ms > 0 ? Math.ceil(ms / 1000) : 0;
}

export type AbandonOffer = {
  enabled: boolean;
  cashCost: number;
  cooldownSecondsRemaining: number;
  canAbandon: boolean;
  blockReason: string | null;
  regionCount?: number;
};

export async function buildAbandonOffersForMap(params: {
  countryCode: string;
  viewerCrewId: number | null;
  viewerPlayerId: number | null;
  ownedRegionTiers: Array<{ regionKey: string; valueTier: number; hasContest: boolean }>;
}): Promise<{
  viewerIsOfficer: boolean;
  abandonCountryOffer: AbandonOffer | null;
  abandonOfferByRegion: Record<string, AbandonOffer>;
}> {
  const cfg = await getTerritoryConfig();
  const now = new Date();
  const empty = { viewerIsOfficer: false, abandonCountryOffer: null, abandonOfferByRegion: {} as Record<string, AbandonOffer> };
  if (!cfg.abandonEnabled || !params.viewerCrewId || !params.viewerPlayerId) return empty;

  const officer = await territoryArsenalService.isCrewOfficer(params.viewerPlayerId, params.viewerCrewId);
  if (!officer) return empty;

  const regionCd = await readCooldown(params.viewerCrewId, 'region');
  const countryCd = await readCooldown(params.viewerCrewId, 'country');
  const regionRemaining = secondsUntil(regionCd, now);
  const countryRemaining = secondsUntil(countryCd, now);

  const abandonOfferByRegion: Record<string, AbandonOffer> = {};
  const regionCosts: number[] = [];
  let anyContest = false;

  for (const row of params.ownedRegionTiers) {
    const cashCost = computeAbandonRegionCashCost(row.valueTier, cfg);
    regionCosts.push(cashCost);
    if (row.hasContest) anyContest = true;
    let blockReason: string | null = null;
    if (row.hasContest) blockReason = 'contest';
    else if (regionRemaining > 0) blockReason = 'cooldown';
    abandonOfferByRegion[row.regionKey] = {
      enabled: true,
      cashCost,
      cooldownSecondsRemaining: regionRemaining,
      canAbandon: blockReason == null,
      blockReason,
    };
  }

  let abandonCountryOffer: AbandonOffer | null = null;
  if (params.ownedRegionTiers.length > 0) {
    const cashCost = computeAbandonCountryCashCost(regionCosts, cfg);
    let blockReason: string | null = null;
    if (anyContest) blockReason = 'contest';
    else if (countryRemaining > 0) blockReason = 'cooldown';
    abandonCountryOffer = {
      enabled: true,
      cashCost,
      cooldownSecondsRemaining: countryRemaining,
      canAbandon: blockReason == null,
      blockReason,
      regionCount: params.ownedRegionTiers.length,
    };
  }

  return { viewerIsOfficer: true, abandonCountryOffer, abandonOfferByRegion };
}

async function clearRegionProjects(regionKey: string, crewId: number): Promise<void> {
  await prisma.$executeRawUnsafe(
    `DELETE FROM territory_region_projects WHERE regionKey = ? AND ownerCrewId = ?`,
    regionKey,
    crewId,
  );
}

async function resolveGarrison(regionKey: string, crewId: number): Promise<void> {
  await prisma.$executeRawUnsafe(
    `UPDATE territory_region_effects
     SET resolvedAt = NOW()
     WHERE regionKey = ?
       AND effectType = 'garrison'
       AND favoredCrewId = ?
       AND resolvedAt IS NULL`,
    regionKey,
    crewId,
  );
}

async function neutralizeOwnedRegion(params: {
  regionKey: string;
  crewId: number;
  seasonKey: string | null;
  ownedSince: Date | null;
}): Promise<void> {
  await territoryCrewStatsService.bankHoldSecondsForOwner(
    params.crewId,
    params.ownedSince,
    params.seasonKey,
  );
  await territoryCrewStatsService.bumpCrewStatsAllScopes(params.crewId, params.seasonKey, {
    regionsLost: 1,
  });
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control
     SET ownerCrewId = NULL, controlJson = '{}', stability = 100, lastIncomeAt = NOW(),
         ownedSince = NULL, holdDueAt = NULL, holdMissStreak = 0, lastHoldAt = NULL, updatedAt = NOW()
     WHERE regionKey = ? AND ownerCrewId = ?`,
    params.regionKey,
    params.crewId,
  );
  await clearRegionProjects(params.regionKey, params.crewId);
  await resolveGarrison(params.regionKey, params.crewId);
  await territoryArsenalService.clearRegionCache(params.regionKey);
}

async function notifyCrewAbandoned(
  crewId: number,
  regionKeys: string[],
  countryCode: string | null,
  cashCost: number,
): Promise<void> {
  const members = await prisma.crewMember.findMany({
    where: { crewId },
    select: { playerId: true },
  });
  const scope = countryCode
    ? `land ${countryCode.toUpperCase()} (${regionKeys.length})`
    : regionKeys[0] ?? 'region';
  for (const m of members) {
    const player = await prisma.player.findUnique({
      where: { id: m.playerId },
      select: { language: true },
    });
    const lang = (player?.language || 'nl').toLowerCase().startsWith('en') ? 'en' : 'nl';
    const title = lang === 'en' ? 'Territory abandoned' : 'Territorium opgegeven';
    const body = lang === 'en'
      ? `Your crew abandoned ${scope}. Crew bank −€${cashCost.toLocaleString('en-US')}. Depot burned.`
      : `Jullie crew gaf ${scope} op. Crew-bank −€${cashCost.toLocaleString('nl-NL')}. Depot verbrand.`;
    await notificationService.sendToPlayer(
      m.playerId,
      title,
      body,
      { type: 'territory_abandoned', regionKeys, countryCode, cashCost },
    ).catch(() => {});
  }
}

export async function abandonRegion(
  playerId: number,
  crewId: number,
  regionKey: string,
  currentCountry: string | null | undefined,
  confirm: string,
): Promise<{ regionKey: string; cashCost: number; regionAbandonAvailableAt: Date }> {
  if (String(confirm || '').trim().toUpperCase() !== 'ABANDON') {
    throw new Error('ABANDON_CONFIRM_REQUIRED');
  }
  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');
  if (!cfg.abandonEnabled) throw new Error('ABANDON_DISABLED');
  if (!(await territoryArsenalService.isCrewOfficer(playerId, crewId))) {
    throw new Error('ABANDON_OFFICER_ONLY');
  }

  const regions = await prisma.$queryRawUnsafe<Array<{
    regionKey: string;
    countryCode: string;
    valueTier: number;
  }>>(
    'SELECT regionKey, countryCode, valueTier FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1',
    regionKey,
  );
  const region = regions[0];
  if (!region) throw new Error('REGION_NOT_FOUND');

  const territoryCountry = mapTravelCountryToTerritoryCode(currentCountry);
  if (!territoryCountry || territoryCountry !== region.countryCode.toLowerCase()) {
    throw new Error('ACTION_OUTSIDE_CURRENT_COUNTRY');
  }

  const control = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null; ownedSince: Date | null }>>(
    'SELECT ownerCrewId, ownedSince FROM territory_control WHERE regionKey = ? LIMIT 1',
    regionKey,
  );
  if (toNumeric(control[0]?.ownerCrewId) !== crewId) {
    throw new Error('ABANDON_NOT_OWNER');
  }

  const contests = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM territory_contests
     WHERE regionKey = ? AND status NOT IN ('resolved', 'cancelled') LIMIT 1`,
    regionKey,
  );
  if (contests.length > 0) throw new Error('ABANDON_IN_CONTEST');

  const now = new Date();
  const regionCd = await readCooldown(crewId, 'region');
  if (secondsUntil(regionCd, now) > 0) throw new Error('ABANDON_COOLDOWN');

  const cashCost = computeAbandonRegionCashCost(toNumeric(region.valueTier), cfg);
  const availableAt = new Date(now.getTime() + cfg.abandonRegionCooldownSeconds * 1000);
  const seasonKey = await territoryCrewStatsService.getActiveSeasonKey();

  await prisma.$transaction(async (tx) => {
    const crew = await tx.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    });
    if (!crew || crew.bankBalance < cashCost) {
      throw new Error('INSUFFICIENT_CREW_FUNDS');
    }
    if (cashCost > 0) {
      await tx.crew.update({
        where: { id: crewId },
        data: { bankBalance: { decrement: cashCost } },
      });
    }
  });

  await neutralizeOwnedRegion({
    regionKey,
    crewId,
    seasonKey,
    ownedSince: control[0]?.ownedSince ?? null,
  });
  await setCooldown(crewId, 'region', availableAt);
  notifyCrewAbandoned(crewId, [regionKey], null, cashCost).catch(() => {});

  return { regionKey, cashCost, regionAbandonAvailableAt: availableAt };
}

export async function abandonCountry(
  playerId: number,
  crewId: number,
  countryCodeRaw: string,
  currentCountry: string | null | undefined,
  confirm: string,
): Promise<{
  countryCode: string;
  regionKeys: string[];
  cashCost: number;
  countryAbandonAvailableAt: Date;
  regionAbandonAvailableAt: Date;
}> {
  if (String(confirm || '').trim().toUpperCase() !== 'ABANDON') {
    throw new Error('ABANDON_CONFIRM_REQUIRED');
  }
  const cfg = await getTerritoryConfig();
  if (!cfg.enabled) throw new Error('TERRITORY_DISABLED');
  if (!cfg.abandonEnabled) throw new Error('ABANDON_DISABLED');
  if (!(await territoryArsenalService.isCrewOfficer(playerId, crewId))) {
    throw new Error('ABANDON_OFFICER_ONLY');
  }

  const normalized = String(countryCodeRaw || '').trim().toLowerCase();
  const countryCode =
    mapTravelCountryToTerritoryCode(normalized) ??
    (normalized.length <= 3 ? normalized : null);
  if (!countryCode) throw new Error('COUNTRY_NOT_FOUND');

  const territoryHere = mapTravelCountryToTerritoryCode(currentCountry);
  if (!territoryHere || territoryHere !== countryCode) {
    throw new Error('ACTION_OUTSIDE_CURRENT_COUNTRY');
  }

  const owned = await prisma.$queryRawUnsafe<Array<{
    regionKey: string;
    valueTier: number;
    ownedSince: Date | null;
  }>>(
    `SELECT tc.regionKey, tr.valueTier, tc.ownedSince
     FROM territory_control tc
     INNER JOIN territory_regions tr ON tr.regionKey = tc.regionKey
     WHERE tc.ownerCrewId = ? AND tr.countryCode = ? AND tr.enabled = 1`,
    crewId,
    countryCode,
  );
  if (owned.length === 0) throw new Error('ABANDON_NO_REGIONS');

  const regionKeys = owned.map((r) => r.regionKey);
  const placeholders = regionKeys.map(() => '?').join(',');
  const contests = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT id FROM territory_contests
     WHERE regionKey IN (${placeholders}) AND status NOT IN ('resolved', 'cancelled') LIMIT 1`,
    ...regionKeys,
  );
  if (contests.length > 0) throw new Error('ABANDON_IN_CONTEST');

  const now = new Date();
  const countryCd = await readCooldown(crewId, 'country');
  if (secondsUntil(countryCd, now) > 0) throw new Error('ABANDON_COOLDOWN');

  const regionCosts = owned.map((r) => computeAbandonRegionCashCost(toNumeric(r.valueTier), cfg));
  const cashCost = computeAbandonCountryCashCost(regionCosts, cfg);
  const countryAvailableAt = new Date(now.getTime() + cfg.abandonCountryCooldownSeconds * 1000);
  const regionAvailableAt = new Date(now.getTime() + cfg.abandonRegionCooldownSeconds * 1000);
  const seasonKey = await territoryCrewStatsService.getActiveSeasonKey();

  await prisma.$transaction(async (tx) => {
    const crew = await tx.crew.findUnique({
      where: { id: crewId },
      select: { bankBalance: true },
    });
    if (!crew || crew.bankBalance < cashCost) {
      throw new Error('INSUFFICIENT_CREW_FUNDS');
    }
    if (cashCost > 0) {
      await tx.crew.update({
        where: { id: crewId },
        data: { bankBalance: { decrement: cashCost } },
      });
    }
  });

  for (const row of owned) {
    await neutralizeOwnedRegion({
      regionKey: row.regionKey,
      crewId,
      seasonKey,
      ownedSince: row.ownedSince,
    });
  }
  await setCooldown(crewId, 'country', countryAvailableAt);
  await setCooldown(crewId, 'region', regionAvailableAt);
  notifyCrewAbandoned(crewId, regionKeys, countryCode, cashCost).catch(() => {});

  return {
    countryCode,
    regionKeys,
    cashCost,
    countryAbandonAvailableAt: countryAvailableAt,
    regionAbandonAvailableAt: regionAvailableAt,
  };
}
