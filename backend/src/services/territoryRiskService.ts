import prisma from '../lib/prisma';
import {
  getTerritoryConfig,
  parseTerritoryStringArray,
  mapTravelCountryToTerritoryCode,
  buildViewerTerritoryCaps,
  getCrewVipTerritoryPerks,
} from './territoryService';
import * as territoryCrewStatsService from './territoryCrewStatsService';
import * as territoryArsenalService from './territoryArsenalService';
import { notificationService } from './notificationService';
import { translationService, type Language } from './translationService';
import { directMessageService } from './directMessageService';

type RiskConfig = {
  enabled: boolean;
  /** When true, every country uses Risk ownership (MODE=* / all). */
  allCountries: boolean;
  modeCountries: Set<string>;
  reinforceHours: number;
  attackCooldownSeconds: number;
  maxRoundsPerAttack: number;
  minArmiesOnCapture: number;
  neutralGarrison: number;
  /** Bonus armies when a crew owns every enabled region in a country. */
  fullControlBonus: number;
  seedArmiesOnOwned: number;
  /** Crews with 0 owned regions may land once per cooldown. */
  invadeEnabled: boolean;
  invadeExpedition: number;
  /** Landing fights only this many defender armies (soft beachhead). */
  invadeDefenderCap: number;
  /** Extra armies the winner keeps from the captured depot (1–2 typical). */
  invadeRemnant: number;
  invadeCooldownHours: number;
};

const LANDING_FROM_KEY = '__landing__';

function toNum(v: unknown): number {
  const n = Number(v);
  return Number.isFinite(n) ? n : 0;
}

async function loadRuntimeMap(keys: string[]): Promise<Record<string, string>> {
  if (keys.length === 0) return {};
  const placeholders = keys.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...keys,
  );
  const out: Record<string, string> = {};
  for (const row of rows) out[row.configKey] = row.configValue;
  return out;
}

async function getRiskConfig(): Promise<RiskConfig> {
  const cfg = await loadRuntimeMap([
    'TERRITORY_RISK_ENABLED',
    'TERRITORY_RISK_MODE_COUNTRIES',
    'TERRITORY_RISK_REINFORCE_HOURS',
    'TERRITORY_RISK_ATTACK_COOLDOWN_SECONDS',
    'TERRITORY_RISK_MAX_ROUNDS_PER_ATTACK',
    'TERRITORY_RISK_MIN_ARMIES_ON_CAPTURE',
    'TERRITORY_RISK_NEUTRAL_GARRISON',
    'TERRITORY_RISK_NL_FULL_CONTROL_BONUS',
    'TERRITORY_RISK_SEED_ARMIES_ON_OWNED',
    'TERRITORY_RISK_INVADE_ENABLED',
    'TERRITORY_RISK_INVADE_EXPEDITION',
    'TERRITORY_RISK_INVADE_DEFENDER_CAP',
    'TERRITORY_RISK_INVADE_REMNANT',
    'TERRITORY_RISK_INVADE_COOLDOWN_HOURS',
  ]);
  const countries = String(cfg['TERRITORY_RISK_MODE_COUNTRIES'] ?? '*')
    .split(',')
    .map((c) => c.trim().toLowerCase())
    .filter(Boolean);
  const allCountries =
    countries.length === 0 ||
    countries.includes('*') ||
    countries.includes('all');
  return {
    enabled: Number(cfg['TERRITORY_RISK_ENABLED'] ?? 1) === 1,
    allCountries,
    modeCountries: new Set(countries.filter((c) => c !== '*' && c !== 'all')),
    reinforceHours: Math.max(1, toNum(cfg['TERRITORY_RISK_REINFORCE_HOURS'] ?? 8)),
    attackCooldownSeconds: Math.max(30, toNum(cfg['TERRITORY_RISK_ATTACK_COOLDOWN_SECONDS'] ?? 300)),
    maxRoundsPerAttack: Math.max(1, Math.min(50, toNum(cfg['TERRITORY_RISK_MAX_ROUNDS_PER_ATTACK'] ?? 20))),
    minArmiesOnCapture: Math.max(1, toNum(cfg['TERRITORY_RISK_MIN_ARMIES_ON_CAPTURE'] ?? 1)),
    neutralGarrison: Math.max(1, toNum(cfg['TERRITORY_RISK_NEUTRAL_GARRISON'] ?? 3)),
    fullControlBonus: Math.max(0, toNum(cfg['TERRITORY_RISK_NL_FULL_CONTROL_BONUS'] ?? 5)),
    seedArmiesOnOwned: Math.max(1, toNum(cfg['TERRITORY_RISK_SEED_ARMIES_ON_OWNED'] ?? 3)),
    invadeEnabled: Number(cfg['TERRITORY_RISK_INVADE_ENABLED'] ?? 1) === 1,
    invadeExpedition: Math.max(2, toNum(cfg['TERRITORY_RISK_INVADE_EXPEDITION'] ?? 6)),
    invadeDefenderCap: Math.max(1, toNum(cfg['TERRITORY_RISK_INVADE_DEFENDER_CAP'] ?? 4)),
    invadeRemnant: Math.max(0, Math.min(5, toNum(cfg['TERRITORY_RISK_INVADE_REMNANT'] ?? 2))),
    invadeCooldownHours: Math.max(1, toNum(cfg['TERRITORY_RISK_INVADE_COOLDOWN_HOURS'] ?? 8)),
  };
}

function countryUsesRiskMode(risk: RiskConfig, countryCode: string): boolean {
  if (!risk.enabled) return false;
  const code = countryCode.trim().toLowerCase();
  if (!code) return false;
  if (risk.allCountries) return true;
  return risk.modeCountries.has(code);
}

export async function isRiskModeCountry(countryCode: string | null | undefined): Promise<boolean> {
  const risk = await getRiskConfig();
  return countryUsesRiskMode(risk, String(countryCode ?? ''));
}

function assertInCountry(currentCountry: string | null | undefined, regionCountryCode: string): void {
  const mapped = mapTravelCountryToTerritoryCode(currentCountry);
  if (!mapped || mapped !== regionCountryCode.toLowerCase()) {
    throw new Error('ACTION_OUTSIDE_CURRENT_COUNTRY');
  }
}

function regionsShareBorder(
  fromRegionKey: string,
  fromNeighborsJson: string | null | undefined,
  toRegionKey: string,
  toNeighborsJson: string | null | undefined,
): boolean {
  const fromNeighbors = parseTerritoryStringArray(fromNeighborsJson);
  const toNeighbors = parseTerritoryStringArray(toNeighborsJson);
  return fromNeighbors.includes(toRegionKey) || toNeighbors.includes(fromRegionKey);
}

function rollDie(): number {
  return 1 + Math.floor(Math.random() * 6);
}

function resolveRiskRound(
  attackerStack: number,
  defenderArmies: number,
): {
  attackerDice: number[];
  defenderDice: number[];
  attackerLosses: number;
  defenderLosses: number;
} {
  const attackDiceCount = Math.min(3, Math.max(1, attackerStack));
  const defendDiceCount = Math.min(2, Math.max(1, defenderArmies));
  const attackerDice = Array.from({ length: attackDiceCount }, rollDie).sort((a, b) => b - a);
  const defenderDice = Array.from({ length: defendDiceCount }, rollDie).sort((a, b) => b - a);
  let attackerLosses = 0;
  let defenderLosses = 0;
  const pairs = Math.min(attackerDice.length, defenderDice.length);
  for (let i = 0; i < pairs; i += 1) {
    if (attackerDice[i]! > defenderDice[i]!) defenderLosses += 1;
    else attackerLosses += 1;
  }
  return { attackerDice, defenderDice, attackerLosses, defenderLosses };
}

export async function getArmiesByRegionKeys(
  regionKeys: string[],
): Promise<Record<string, { crewId: number; armies: number }>> {
  if (regionKeys.length === 0) return {};
  const placeholders = regionKeys.map(() => '?').join(',');
  const rows = await prisma.$queryRawUnsafe<Array<{ regionKey: string; crewId: number; armies: number }>>(
    `SELECT regionKey, crewId, armies FROM territory_region_armies WHERE regionKey IN (${placeholders})`,
    ...regionKeys,
  );
  const out: Record<string, { crewId: number; armies: number }> = {};
  for (const row of rows) {
    out[row.regionKey] = { crewId: toNum(row.crewId), armies: Math.max(0, toNum(row.armies)) };
  }
  return out;
}

async function setRegionArmies(regionKey: string, crewId: number | null, armies: number): Promise<void> {
  if (crewId == null || armies <= 0) {
    await prisma.$executeRawUnsafe(`DELETE FROM territory_region_armies WHERE regionKey = ?`, regionKey);
    return;
  }
  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_region_armies (regionKey, crewId, armies)
     VALUES (?, ?, ?)
     ON DUPLICATE KEY UPDATE crewId = VALUES(crewId), armies = VALUES(armies), updatedAt = NOW()`,
    regionKey,
    crewId,
    Math.floor(armies),
  );
}

/** Ensure owned regions in risk countries have at least seed armies. */
export async function ensureSeedArmiesForOwnedRegions(countryCode: string): Promise<void> {
  const risk = await getRiskConfig();
  if (!countryUsesRiskMode(risk, countryCode)) return;

  const rows = await prisma.$queryRawUnsafe<Array<{ regionKey: string; ownerCrewId: number }>>(
    `SELECT tc.regionKey, tc.ownerCrewId
     FROM territory_control tc
     INNER JOIN territory_regions tr ON tr.regionKey = tc.regionKey
     WHERE tr.countryCode = ? AND tr.enabled = 1 AND tc.ownerCrewId IS NOT NULL`,
    countryCode.toLowerCase(),
  );
  const existing = await getArmiesByRegionKeys(rows.map((r) => r.regionKey));
  for (const row of rows) {
    const cur = existing[row.regionKey];
    if (!cur || cur.crewId !== toNum(row.ownerCrewId) || cur.armies <= 0) {
      await setRegionArmies(row.regionKey, toNum(row.ownerCrewId), risk.seedArmiesOnOwned);
    }
  }
}

export async function syncArmiesOnOwnershipChange(params: {
  regionKey: string;
  newOwnerCrewId: number | null;
  armies?: number;
}): Promise<void> {
  const risk = await getRiskConfig();
  const region = await prisma.$queryRawUnsafe<Array<{ countryCode: string }>>(
    `SELECT countryCode FROM territory_regions WHERE regionKey = ? LIMIT 1`,
    params.regionKey,
  );
  const countryCode = String(region[0]?.countryCode ?? '').toLowerCase();
  if (!countryUsesRiskMode(risk, countryCode)) {
    await setRegionArmies(params.regionKey, null, 0);
    return;
  }
  if (params.newOwnerCrewId == null) {
    await setRegionArmies(params.regionKey, null, 0);
    return;
  }
  const armies = Math.max(risk.minArmiesOnCapture, params.armies ?? risk.seedArmiesOnOwned);
  await setRegionArmies(params.regionKey, params.newOwnerCrewId, armies);
}

async function countOwnedInCountry(crewId: number, countryCode: string): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt
     FROM territory_control tc
     INNER JOIN territory_regions tr ON tr.regionKey = tc.regionKey
     WHERE tc.ownerCrewId = ? AND tr.countryCode = ? AND tr.enabled = 1`,
    crewId,
    countryCode,
  );
  return toNum(rows[0]?.cnt);
}

async function countEnabledInCountry(countryCode: string): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
    `SELECT COUNT(*) AS cnt FROM territory_regions WHERE countryCode = ? AND enabled = 1`,
    countryCode,
  );
  return toNum(rows[0]?.cnt);
}

function computeReinforceGrant(
  ownedCount: number,
  totalInCountry: number,
  countryCode: string,
  risk: RiskConfig,
  vipReinforceBonus = 0,
): number {
  let grant = Math.max(3, Math.floor(ownedCount / 3));
  if (totalInCountry > 0 && ownedCount >= totalInCountry) {
    grant += risk.fullControlBonus;
  }
  grant += Math.max(0, Math.floor(vipReinforceBonus));
  return grant;
}

async function getOrOpenReinforceWindow(
  crewId: number,
  countryCode: string,
  risk: RiskConfig,
): Promise<{
  armiesRemaining: number;
  armiesGranted: number;
  fortifyUsed: boolean;
  fortifyCount: number;
  fortifyMax: number;
  windowStartedAt: Date;
  windowEndsAt: Date;
  canClaimNew: boolean;
}> {
  const now = new Date();
  const vipPerks = await getCrewVipTerritoryPerks(crewId);
  const fortifyMax = Math.max(1, vipPerks.vipFortifyMax);
  const rows = await prisma.$queryRawUnsafe<
    Array<{
      windowStartedAt: Date;
      armiesGranted: number;
      armiesRemaining: number;
      fortifyUsed: number;
    }>
  >(
    `SELECT windowStartedAt, armiesGranted, armiesRemaining, fortifyUsed
     FROM territory_risk_reinforce WHERE crewId = ? AND countryCode = ? LIMIT 1`,
    crewId,
    countryCode,
  );
  const existing = rows[0];
  const windowMs = risk.reinforceHours * 3600 * 1000;
  if (existing) {
    const started = new Date(existing.windowStartedAt);
    const endsAt = new Date(started.getTime() + windowMs);
    if (now < endsAt) {
      const fortifyCount = Math.max(0, toNum(existing.fortifyUsed));
      return {
        armiesRemaining: Math.max(0, toNum(existing.armiesRemaining)),
        armiesGranted: Math.max(0, toNum(existing.armiesGranted)),
        fortifyUsed: fortifyCount >= fortifyMax,
        fortifyCount,
        fortifyMax,
        windowStartedAt: started,
        windowEndsAt: endsAt,
        canClaimNew: false,
      };
    }
  }

  const owned = await countOwnedInCountry(crewId, countryCode);
  if (owned <= 0) {
    throw new Error('RISK_NO_OWNED_REGIONS');
  }
  const total = await countEnabledInCountry(countryCode);
  const grant = computeReinforceGrant(
    owned,
    total,
    countryCode,
    risk,
    vipPerks.vipReinforceBonus,
  );
  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_risk_reinforce
       (crewId, countryCode, windowStartedAt, armiesGranted, armiesRemaining, fortifyUsed, notifiedAt)
     VALUES (?, ?, NOW(), ?, ?, 0, NULL)
     ON DUPLICATE KEY UPDATE
       windowStartedAt = NOW(),
       armiesGranted = VALUES(armiesGranted),
       armiesRemaining = VALUES(armiesRemaining),
       fortifyUsed = 0,
       notifiedAt = NULL,
       updatedAt = NOW()`,
    crewId,
    countryCode,
    grant,
    grant,
  );
  const endsAt = new Date(now.getTime() + windowMs);
  return {
    armiesRemaining: grant,
    armiesGranted: grant,
    fortifyUsed: false,
    fortifyCount: 0,
    fortifyMax,
    windowStartedAt: now,
    windowEndsAt: endsAt,
    canClaimNew: true,
  };
}

export async function getRiskSnapshotForMap(params: {
  countryCode: string;
  viewerCrewId: number | null;
  regionKeys: string[];
}): Promise<{
  riskMode: boolean;
  reinforce: null | {
    armiesRemaining: number;
    armiesGranted: number;
    fortifyUsed: boolean;
    fortifyCount: number;
    fortifyMax: number;
    windowEndsAt: Date;
    secondsRemaining: number;
  };
  invade: null | {
    eligible: boolean;
    enabled: boolean;
    canInvade: boolean;
    expedition: number;
    defenderCap: number;
    remnant: number;
    secondsRemaining: number;
  };
  armiesByRegion: Record<string, number>;
}> {
  const risk = await getRiskConfig();
  const code = params.countryCode.toLowerCase();
  const riskMode = countryUsesRiskMode(risk, code);
  if (!riskMode) {
    return { riskMode: false, reinforce: null, invade: null, armiesByRegion: {} };
  }

  await ensureSeedArmiesForOwnedRegions(code);
  const armyRows = await getArmiesByRegionKeys(params.regionKeys);
  const armiesByRegion: Record<string, number> = {};
  for (const [key, val] of Object.entries(armyRows)) {
    armiesByRegion[key] = val.armies;
  }

  // Neutral regions show neutral garrison as display strength when unowned.
  const controls = await prisma.$queryRawUnsafe<Array<{ regionKey: string; ownerCrewId: number | null }>>(
    params.regionKeys.length === 0
      ? `SELECT regionKey, ownerCrewId FROM territory_control WHERE 1=0`
      : `SELECT regionKey, ownerCrewId FROM territory_control WHERE regionKey IN (${params.regionKeys.map(() => '?').join(',')})`,
    ...params.regionKeys,
  );
  const ownerByKey = new Map(controls.map((c) => [c.regionKey, c.ownerCrewId == null ? null : toNum(c.ownerCrewId)]));
  for (const key of params.regionKeys) {
    if (ownerByKey.get(key) == null && (armiesByRegion[key] ?? 0) <= 0) {
      armiesByRegion[key] = risk.neutralGarrison;
    }
  }

  let reinforce: {
    armiesRemaining: number;
    armiesGranted: number;
    fortifyUsed: boolean;
    fortifyCount: number;
    fortifyMax: number;
    windowEndsAt: Date;
    secondsRemaining: number;
  } | null = null;

  let invade: {
    eligible: boolean;
    enabled: boolean;
    canInvade: boolean;
    expedition: number;
    defenderCap: number;
    remnant: number;
    secondsRemaining: number;
  } | null = null;

  if (params.viewerCrewId != null) {
    const owned = await countOwnedInCountry(params.viewerCrewId, code);
    if (owned > 0) {
      const vipPerks = await getCrewVipTerritoryPerks(params.viewerCrewId);
      const fortifyMax = Math.max(1, vipPerks.vipFortifyMax);
      const rows = await prisma.$queryRawUnsafe<
        Array<{
          windowStartedAt: Date;
          armiesGranted: number;
          armiesRemaining: number;
          fortifyUsed: number;
        }>
      >(
        `SELECT windowStartedAt, armiesGranted, armiesRemaining, fortifyUsed
         FROM territory_risk_reinforce WHERE crewId = ? AND countryCode = ? LIMIT 1`,
        params.viewerCrewId,
        code,
      );
      const now = Date.now();
      const windowMs = risk.reinforceHours * 3600 * 1000;
      if (rows[0]) {
        const started = new Date(rows[0].windowStartedAt).getTime();
        const endsAt = new Date(started + windowMs);
        const fortifyCount = Math.max(0, toNum(rows[0].fortifyUsed));
        if (now < endsAt.getTime()) {
          reinforce = {
            armiesRemaining: Math.max(0, toNum(rows[0].armiesRemaining)),
            armiesGranted: Math.max(0, toNum(rows[0].armiesGranted)),
            fortifyUsed: fortifyCount >= fortifyMax,
            fortifyCount,
            fortifyMax,
            windowEndsAt: endsAt,
            secondsRemaining: Math.max(0, Math.ceil((endsAt.getTime() - now) / 1000)),
          };
        } else {
          reinforce = {
            armiesRemaining: 0,
            armiesGranted: 0,
            fortifyUsed: false,
            fortifyCount: 0,
            fortifyMax,
            windowEndsAt: new Date(now),
            secondsRemaining: 0,
          };
        }
      } else {
        reinforce = {
          armiesRemaining: 0,
          armiesGranted: 0,
          fortifyUsed: false,
          fortifyCount: 0,
          fortifyMax,
          windowEndsAt: new Date(now),
          secondsRemaining: 0,
        };
      }
    } else {
      // Zero-owned: expose landing / invade status for this country.
      const cdRows = await prisma.$queryRawUnsafe<Array<{ availableAt: Date }>>(
        `SELECT availableAt FROM territory_risk_invade_cooldown
         WHERE crewId = ? AND countryCode = ? LIMIT 1`,
        params.viewerCrewId,
        code,
      );
      const now = Date.now();
      const availableAt = cdRows[0] ? new Date(cdRows[0].availableAt).getTime() : 0;
      const secondsRemaining = availableAt > now ? Math.max(0, Math.ceil((availableAt - now) / 1000)) : 0;
      invade = {
        eligible: true,
        enabled: risk.invadeEnabled,
        canInvade: risk.invadeEnabled && secondsRemaining <= 0,
        expedition: risk.invadeExpedition,
        defenderCap: risk.invadeDefenderCap,
        remnant: risk.invadeRemnant,
        secondsRemaining,
      };
    }
  }

  return { riskMode: true, reinforce, invade, armiesByRegion };
}

export async function claimReinforce(
  playerId: number,
  crewId: number,
  countryCode: string,
  currentCountry: string | null | undefined,
): Promise<{
  armiesGranted: number;
  armiesRemaining: number;
  windowEndsAt: Date;
}> {
  const code = countryCode.toLowerCase();
  if (!(await isRiskModeCountry(code))) throw new Error('RISK_MODE_INACTIVE');
  assertInCountry(currentCountry, code);
  const risk = await getRiskConfig();
  const window = await getOrOpenReinforceWindow(crewId, code, risk);
  if (window.canClaimNew && window.armiesRemaining > 0) {
    void notifyCrewRiskReinforce(crewId, code, window.armiesRemaining, window.windowEndsAt).catch(
      (err) => console.error('[Risk] reinforce claim notify failed', err),
    );
  }
  return {
    armiesGranted: window.armiesGranted,
    armiesRemaining: window.armiesRemaining,
    windowEndsAt: window.windowEndsAt,
  };
}

export async function placeReinforce(
  playerId: number,
  crewId: number,
  regionKey: string,
  amount: number,
  currentCountry: string | null | undefined,
): Promise<{ armiesOnRegion: number; armiesRemaining: number }> {
  const place = Math.floor(amount);
  if (place < 1) throw new Error('RISK_INVALID_AMOUNT');

  const regions = await prisma.$queryRawUnsafe<
    Array<{ regionKey: string; countryCode: string; neighborsJson: string | null }>
  >(`SELECT regionKey, countryCode, neighborsJson FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1`, regionKey);
  if (!regions[0]) throw new Error('REGION_NOT_FOUND');
  const code = regions[0].countryCode.toLowerCase();
  if (!(await isRiskModeCountry(code))) throw new Error('RISK_MODE_INACTIVE');
  assertInCountry(currentCountry, code);

  const control = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    `SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1`,
    regionKey,
  );
  if (toNum(control[0]?.ownerCrewId) !== crewId) throw new Error('RISK_NOT_OWNER');

  const risk = await getRiskConfig();
  const window = await getOrOpenReinforceWindow(crewId, code, risk);
  if (window.armiesRemaining < place) throw new Error('RISK_NO_REINFORCEMENTS');

  const armies = await getArmiesByRegionKeys([regionKey]);
  const current = armies[regionKey]?.crewId === crewId ? armies[regionKey]!.armies : risk.seedArmiesOnOwned;
  const next = current + place;
  await setRegionArmies(regionKey, crewId, next);
  await prisma.$executeRawUnsafe(
    `UPDATE territory_risk_reinforce
     SET armiesRemaining = GREATEST(0, armiesRemaining - ?), updatedAt = NOW()
     WHERE crewId = ? AND countryCode = ?`,
    place,
    crewId,
    code,
  );
  const remainingRows = await prisma.$queryRawUnsafe<Array<{ armiesRemaining: number }>>(
    `SELECT armiesRemaining FROM territory_risk_reinforce WHERE crewId = ? AND countryCode = ? LIMIT 1`,
    crewId,
    code,
  );
  return {
    armiesOnRegion: next,
    armiesRemaining: Math.max(0, toNum(remainingRows[0]?.armiesRemaining)),
  };
}

export async function fortify(
  playerId: number,
  crewId: number,
  fromRegionKey: string,
  toRegionKey: string,
  amount: number,
  currentCountry: string | null | undefined,
): Promise<{ fromArmies: number; toArmies: number }> {
  const move = Math.floor(amount);
  if (move < 1) throw new Error('RISK_INVALID_AMOUNT');
  if (fromRegionKey === toRegionKey) throw new Error('RISK_SAME_REGION');

  const regions = await prisma.$queryRawUnsafe<
    Array<{ regionKey: string; countryCode: string; neighborsJson: string | null }>
  >(
    `SELECT regionKey, countryCode, neighborsJson FROM territory_regions
     WHERE regionKey IN (?, ?) AND enabled = 1`,
    fromRegionKey,
    toRegionKey,
  );
  if (regions.length !== 2) throw new Error('REGION_NOT_FOUND');
  const from = regions.find((r) => r.regionKey === fromRegionKey)!;
  const to = regions.find((r) => r.regionKey === toRegionKey)!;
  if (from.countryCode !== to.countryCode) throw new Error('RISK_CROSS_COUNTRY');
  const code = from.countryCode.toLowerCase();
  if (!(await isRiskModeCountry(code))) throw new Error('RISK_MODE_INACTIVE');
  assertInCountry(currentCountry, code);

  if (!regionsShareBorder(fromRegionKey, from.neighborsJson, toRegionKey, to.neighborsJson)) {
    throw new Error('RISK_NOT_ADJACENT');
  }

  const controls = await prisma.$queryRawUnsafe<Array<{ regionKey: string; ownerCrewId: number | null }>>(
    `SELECT regionKey, ownerCrewId FROM territory_control WHERE regionKey IN (?, ?)`,
    fromRegionKey,
    toRegionKey,
  );
  const ownerFrom = toNum(controls.find((c) => c.regionKey === fromRegionKey)?.ownerCrewId);
  const ownerTo = toNum(controls.find((c) => c.regionKey === toRegionKey)?.ownerCrewId);
  if (ownerFrom !== crewId || ownerTo !== crewId) throw new Error('RISK_NOT_OWNER');

  const risk = await getRiskConfig();
  const window = await getOrOpenReinforceWindow(crewId, code, risk);
  if (window.fortifyUsed) throw new Error('RISK_FORTIFY_USED');

  const armies = await getArmiesByRegionKeys([fromRegionKey, toRegionKey]);
  const fromArmies = armies[fromRegionKey]?.crewId === crewId ? armies[fromRegionKey]!.armies : 0;
  const toArmies = armies[toRegionKey]?.crewId === crewId ? armies[toRegionKey]!.armies : risk.seedArmiesOnOwned;
  if (fromArmies - move < 1) throw new Error('RISK_INSUFFICIENT_ARMIES');

  await setRegionArmies(fromRegionKey, crewId, fromArmies - move);
  await setRegionArmies(toRegionKey, crewId, toArmies + move);
  await prisma.$executeRawUnsafe(
    `UPDATE territory_risk_reinforce SET fortifyUsed = fortifyUsed + 1, updatedAt = NOW()
     WHERE crewId = ? AND countryCode = ?`,
    crewId,
    code,
  );

  return { fromArmies: fromArmies - move, toArmies: toArmies + move };
}

async function transferOwnership(params: {
  regionKey: string;
  winnerCrewId: number;
  previousOwnerId: number | null;
  armiesMovedIn: number;
}): Promise<void> {
  const activeSeasonKey = await territoryCrewStatsService.getActiveSeasonKey();
  const prev = await prisma.$queryRawUnsafe<Array<{ ownedSince: Date | null }>>(
    `SELECT ownedSince FROM territory_control WHERE regionKey = ? LIMIT 1`,
    params.regionKey,
  );
  if (params.previousOwnerId != null && params.previousOwnerId !== params.winnerCrewId) {
    await territoryCrewStatsService.bankHoldSecondsForOwner(
      params.previousOwnerId,
      prev[0]?.ownedSince ?? null,
      activeSeasonKey,
    );
    await territoryCrewStatsService.bumpCrewStatsAllScopes(params.previousOwnerId, activeSeasonKey, {
      regionsLost: 1,
    });
  }
  await territoryCrewStatsService.bumpCrewStatsAllScopes(params.winnerCrewId, activeSeasonKey, {
    regionsWon: 1,
  });

  await prisma.$executeRawUnsafe(
    `UPDATE territory_control
     SET ownerCrewId = ?, controlJson = ?, stability = 100, lastIncomeAt = NOW(),
         ownedSince = NOW(), updatedAt = NOW()
     WHERE regionKey = ?`,
    params.winnerCrewId,
    JSON.stringify({ [params.winnerCrewId]: 100 }),
    params.regionKey,
  );
  await prisma.$executeRawUnsafe(
    `UPDATE territory_control
     SET holdDueAt = NULL, holdMissStreak = 0, lastHoldAt = NULL
     WHERE regionKey = ?`,
    params.regionKey,
  );
  await prisma.$executeRawUnsafe(
    `UPDATE territory_contests SET status = 'cancelled'
     WHERE regionKey = ? AND status NOT IN ('resolved', 'cancelled')`,
    params.regionKey,
  );
  if (params.previousOwnerId != null && params.previousOwnerId !== params.winnerCrewId) {
    await territoryArsenalService.transferCacheOnOwnershipChange({
      regionKey: params.regionKey,
      previousOwnerId: params.previousOwnerId,
      winnerCrewId: params.winnerCrewId,
    });
  }
  await syncArmiesOnOwnershipChange({
    regionKey: params.regionKey,
    newOwnerCrewId: params.winnerCrewId,
    armies: params.armiesMovedIn,
  });
}

export async function attack(
  playerId: number,
  crewId: number,
  fromRegionKey: string,
  toRegionKey: string,
  commitArmies: number,
  currentCountry: string | null | undefined,
  options?: { maxRounds?: number },
): Promise<{
  captured: boolean;
  rounds: Array<{
    attackerDice: number[];
    defenderDice: number[];
    attackerLosses: number;
    defenderLosses: number;
    attackerArmiesLeft: number;
    defenderArmiesLeft: number;
  }>;
  attackerLosses: number;
  defenderLosses: number;
  fromArmies: number;
  toArmies: number;
  toOwnerCrewId: number | null;
}> {
  const commit = Math.floor(commitArmies);
  if (commit < 1) throw new Error('RISK_INVALID_AMOUNT');
  if (fromRegionKey === toRegionKey) throw new Error('RISK_SAME_REGION');

  const regions = await prisma.$queryRawUnsafe<
    Array<{ regionKey: string; countryCode: string; neighborsJson: string | null }>
  >(
    `SELECT regionKey, countryCode, neighborsJson FROM territory_regions
     WHERE regionKey IN (?, ?) AND enabled = 1`,
    fromRegionKey,
    toRegionKey,
  );
  if (regions.length !== 2) throw new Error('REGION_NOT_FOUND');
  const from = regions.find((r) => r.regionKey === fromRegionKey)!;
  const to = regions.find((r) => r.regionKey === toRegionKey)!;
  if (from.countryCode !== to.countryCode) throw new Error('RISK_CROSS_COUNTRY');
  const code = from.countryCode.toLowerCase();
  if (!(await isRiskModeCountry(code))) throw new Error('RISK_MODE_INACTIVE');
  assertInCountry(currentCountry, code);

  if (!regionsShareBorder(fromRegionKey, from.neighborsJson, toRegionKey, to.neighborsJson)) {
    throw new Error('RISK_NOT_ADJACENT');
  }

  const controls = await prisma.$queryRawUnsafe<Array<{ regionKey: string; ownerCrewId: number | null }>>(
    `SELECT regionKey, ownerCrewId FROM territory_control WHERE regionKey IN (?, ?)`,
    fromRegionKey,
    toRegionKey,
  );
  const ownerFrom = controls.find((c) => c.regionKey === fromRegionKey)?.ownerCrewId;
  const ownerToRaw = controls.find((c) => c.regionKey === toRegionKey)?.ownerCrewId;
  const ownerTo = ownerToRaw == null ? null : toNum(ownerToRaw);
  if (toNum(ownerFrom) !== crewId) throw new Error('RISK_NOT_OWNER');
  if (ownerTo === crewId) throw new Error('RISK_OWN_TARGET');

  // Region cap when capturing a new (not already owned) region:
  // same dual-key + Crew VIP (+2) limit as the Territory UI / contests.
  if (ownerTo !== crewId) {
    const territoryCfg = await getTerritoryConfig();
    const caps = await buildViewerTerritoryCaps(crewId, territoryCfg);
    if (caps.ownedRegions >= caps.effectiveMaxRegions) {
      throw new Error('REGIONS_CAP_REACHED');
    }
  }

  const risk = await getRiskConfig();
  const cdRows = await prisma.$queryRawUnsafe<Array<{ availableAt: Date }>>(
    `SELECT availableAt FROM territory_risk_attack_cooldown
     WHERE crewId = ? AND fromRegionKey = ? AND toRegionKey = ? LIMIT 1`,
    crewId,
    fromRegionKey,
    toRegionKey,
  );
  if (cdRows[0] && new Date(cdRows[0].availableAt).getTime() > Date.now()) {
    throw new Error('RISK_ATTACK_COOLDOWN');
  }

  const armies = await getArmiesByRegionKeys([fromRegionKey, toRegionKey]);
  const fromArmiesTotal = armies[fromRegionKey]?.crewId === crewId ? armies[fromRegionKey]!.armies : 0;
  if (fromArmiesTotal < 2) throw new Error('RISK_INSUFFICIENT_ARMIES');
  if (commit > fromArmiesTotal - 1) throw new Error('RISK_INSUFFICIENT_ARMIES');

  let defenderArmies =
    ownerTo != null && armies[toRegionKey]?.crewId === ownerTo
      ? armies[toRegionKey]!.armies
      : risk.neutralGarrison;
  if (defenderArmies < 1) defenderArmies = risk.neutralGarrison;

  let attackingForce = commit;
  const leftBehind = fromArmiesTotal - commit;
  const rounds: Array<{
    attackerDice: number[];
    defenderDice: number[];
    attackerLosses: number;
    defenderLosses: number;
    attackerArmiesLeft: number;
    defenderArmiesLeft: number;
  }> = [];
  let attackerLossesTotal = 0;
  let defenderLossesTotal = 0;
  const maxRounds = options?.maxRounds ?? risk.maxRoundsPerAttack;

  while (attackingForce > 0 && defenderArmies > 0 && rounds.length < maxRounds) {
    const resolved = resolveRiskRound(attackingForce, defenderArmies);
    const aLoss = Math.min(resolved.attackerLosses, attackingForce);
    const dLoss = Math.min(resolved.defenderLosses, defenderArmies);
    attackingForce -= aLoss;
    defenderArmies -= dLoss;
    attackerLossesTotal += aLoss;
    defenderLossesTotal += dLoss;
    rounds.push({
      attackerDice: resolved.attackerDice,
      defenderDice: resolved.defenderDice,
      attackerLosses: aLoss,
      defenderLosses: dLoss,
      attackerArmiesLeft: attackingForce,
      defenderArmiesLeft: defenderArmies,
    });
  }

  const captured = defenderArmies <= 0 && attackingForce > 0;
  let finalFrom = leftBehind;
  let finalTo = defenderArmies;
  let finalOwner: number | null = ownerTo;

  if (captured) {
    const movedIn = Math.max(risk.minArmiesOnCapture, attackingForce);
    finalFrom = leftBehind;
    finalTo = movedIn;
    finalOwner = crewId;
    await setRegionArmies(fromRegionKey, crewId, finalFrom);
    await transferOwnership({
      regionKey: toRegionKey,
      winnerCrewId: crewId,
      previousOwnerId: ownerTo,
      armiesMovedIn: movedIn,
    });
  } else {
    finalFrom = leftBehind + attackingForce;
    await setRegionArmies(fromRegionKey, crewId, finalFrom);
    if (ownerTo != null) {
      await setRegionArmies(toRegionKey, ownerTo, Math.max(1, defenderArmies));
      finalTo = Math.max(1, defenderArmies);
    } else {
      finalTo = Math.max(0, defenderArmies);
    }
  }

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_risk_battle_log
       (attackerCrewId, defenderCrewId, fromRegionKey, toRegionKey, countryCode, committedArmies, roundsJson, attackerLosses, defenderLosses, captured)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    crewId,
    ownerTo,
    fromRegionKey,
    toRegionKey,
    code,
    commit,
    JSON.stringify(rounds),
    attackerLossesTotal,
    defenderLossesTotal,
    captured ? 1 : 0,
  );

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_risk_attack_cooldown (crewId, fromRegionKey, toRegionKey, availableAt)
     VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? SECOND))
     ON DUPLICATE KEY UPDATE availableAt = VALUES(availableAt), updatedAt = NOW()`,
    crewId,
    fromRegionKey,
    toRegionKey,
    risk.attackCooldownSeconds,
  );

  const eventPoints = Math.max(0, defenderLossesTotal) + (captured ? 5 : 0);
  if (eventPoints > 0) {
    void import('./gameEventService')
      .then(({ gameEventService }) =>
        gameEventService.recordContribution(playerId, 'territory', eventPoints),
      )
      .catch(() => {});
  }

  return {
    captured,
    rounds,
    attackerLosses: attackerLossesTotal,
    defenderLosses: defenderLossesTotal,
    fromArmies: finalFrom,
    toArmies: finalTo,
    toOwnerCrewId: finalOwner,
  };
}

/**
 * Soft landing for crews with zero owned regions in a Risk country.
 * Fights only invadeDefenderCap armies; on capture winner gets survivors + remnant.
 */
export async function invade(
  playerId: number,
  crewId: number,
  toRegionKey: string,
  currentCountry: string | null | undefined,
  options?: { maxRounds?: number },
): Promise<{
  captured: boolean;
  rounds: Array<{
    attackerDice: number[];
    defenderDice: number[];
    attackerLosses: number;
    defenderLosses: number;
    attackerArmiesLeft: number;
    defenderArmiesLeft: number;
  }>;
  attackerLosses: number;
  defenderLosses: number;
  toArmies: number;
  toOwnerCrewId: number | null;
  expedition: number;
  defenderCap: number;
  remnant: number;
}> {
  const risk = await getRiskConfig();
  if (!risk.invadeEnabled) throw new Error('RISK_INVADE_DISABLED');

  const region = await prisma.$queryRawUnsafe<
    Array<{ regionKey: string; countryCode: string }>
  >(
    `SELECT regionKey, countryCode FROM territory_regions WHERE regionKey = ? AND enabled = 1 LIMIT 1`,
    toRegionKey,
  );
  if (!region[0]) throw new Error('REGION_NOT_FOUND');
  const code = String(region[0].countryCode).toLowerCase();
  if (!(await isRiskModeCountry(code))) throw new Error('RISK_MODE_INACTIVE');
  assertInCountry(currentCountry, code);

  const owned = await countOwnedInCountry(crewId, code);
  if (owned > 0) throw new Error('RISK_INVADE_NOT_ELIGIBLE');

  const control = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    `SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1`,
    toRegionKey,
  );
  const ownerToRaw = control[0]?.ownerCrewId;
  const ownerTo = ownerToRaw == null ? null : toNum(ownerToRaw);
  if (ownerTo === crewId) throw new Error('RISK_OWN_TARGET');

  const territoryCfg = await getTerritoryConfig();
  const caps = await buildViewerTerritoryCaps(crewId, territoryCfg);
  if (caps.ownedRegions >= caps.effectiveMaxRegions) {
    throw new Error('REGIONS_CAP_REACHED');
  }

  const cdRows = await prisma.$queryRawUnsafe<Array<{ availableAt: Date }>>(
    `SELECT availableAt FROM territory_risk_invade_cooldown
     WHERE crewId = ? AND countryCode = ? LIMIT 1`,
    crewId,
    code,
  );
  if (cdRows[0] && new Date(cdRows[0].availableAt).getTime() > Date.now()) {
    throw new Error('RISK_INVADE_COOLDOWN');
  }

  const armies = await getArmiesByRegionKeys([toRegionKey]);
  const realDefenderArmies =
    ownerTo != null && armies[toRegionKey]?.crewId === ownerTo
      ? armies[toRegionKey]!.armies
      : risk.neutralGarrison;
  const fightingDefender = Math.min(
    Math.max(1, realDefenderArmies || risk.neutralGarrison),
    risk.invadeDefenderCap,
  );

  let attackingForce = risk.invadeExpedition;
  let defenderArmies = fightingDefender;
  const rounds: Array<{
    attackerDice: number[];
    defenderDice: number[];
    attackerLosses: number;
    defenderLosses: number;
    attackerArmiesLeft: number;
    defenderArmiesLeft: number;
  }> = [];
  let attackerLossesTotal = 0;
  let defenderLossesTotal = 0;
  const maxRounds = options?.maxRounds ?? risk.maxRoundsPerAttack;

  while (attackingForce > 0 && defenderArmies > 0 && rounds.length < maxRounds) {
    const resolved = resolveRiskRound(attackingForce, defenderArmies);
    const aLoss = Math.min(resolved.attackerLosses, attackingForce);
    const dLoss = Math.min(resolved.defenderLosses, defenderArmies);
    attackingForce -= aLoss;
    defenderArmies -= dLoss;
    attackerLossesTotal += aLoss;
    defenderLossesTotal += dLoss;
    rounds.push({
      attackerDice: resolved.attackerDice,
      defenderDice: resolved.defenderDice,
      attackerLosses: aLoss,
      defenderLosses: dLoss,
      attackerArmiesLeft: attackingForce,
      defenderArmiesLeft: defenderArmies,
    });
  }

  const captured = defenderArmies <= 0 && attackingForce > 0;
  let finalTo = defenderArmies;
  let finalOwner: number | null = ownerTo;

  if (captured) {
    const movedIn = Math.max(
      risk.minArmiesOnCapture,
      attackingForce + risk.invadeRemnant,
    );
    finalTo = movedIn;
    finalOwner = crewId;
    await transferOwnership({
      regionKey: toRegionKey,
      winnerCrewId: crewId,
      previousOwnerId: ownerTo,
      armiesMovedIn: movedIn,
    });
  } else if (ownerTo != null) {
    const after = Math.max(1, realDefenderArmies - defenderLossesTotal);
    await setRegionArmies(toRegionKey, ownerTo, after);
    finalTo = after;
  } else {
    finalTo = Math.max(0, realDefenderArmies - defenderLossesTotal);
  }

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_risk_battle_log
       (attackerCrewId, defenderCrewId, fromRegionKey, toRegionKey, countryCode, committedArmies, roundsJson, attackerLosses, defenderLosses, captured)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
    crewId,
    ownerTo,
    LANDING_FROM_KEY,
    toRegionKey,
    code,
    risk.invadeExpedition,
    JSON.stringify(rounds),
    attackerLossesTotal,
    defenderLossesTotal,
    captured ? 1 : 0,
  );

  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_risk_invade_cooldown (crewId, countryCode, availableAt)
     VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ? HOUR))
     ON DUPLICATE KEY UPDATE availableAt = VALUES(availableAt), updatedAt = NOW()`,
    crewId,
    code,
    risk.invadeCooldownHours,
  );

  const eventPoints = Math.max(0, defenderLossesTotal) + (captured ? 5 : 0);
  if (eventPoints > 0) {
    void import('./gameEventService')
      .then(({ gameEventService }) =>
        gameEventService.recordContribution(playerId, 'territory', eventPoints),
      )
      .catch(() => {});
  }

  return {
    captured,
    rounds,
    attackerLosses: attackerLossesTotal,
    defenderLosses: defenderLossesTotal,
    toArmies: finalTo,
    toOwnerCrewId: finalOwner,
    expedition: risk.invadeExpedition,
    defenderCap: risk.invadeDefenderCap,
    remnant: risk.invadeRemnant,
  };
}

export async function adminSetArmies(regionKey: string, armies: number): Promise<void> {
  const control = await prisma.$queryRawUnsafe<Array<{ ownerCrewId: number | null }>>(
    `SELECT ownerCrewId FROM territory_control WHERE regionKey = ? LIMIT 1`,
    regionKey,
  );
  const owner = control[0]?.ownerCrewId == null ? null : toNum(control[0].ownerCrewId);
  if (owner == null) {
    await setRegionArmies(regionKey, null, 0);
    return;
  }
  await setRegionArmies(regionKey, owner, Math.max(0, Math.floor(armies)));
}

async function _getCrewPlayerIds(crewId: number): Promise<number[]> {
  const rows = await prisma.$queryRawUnsafe<Array<{ id: number }>>(
    `SELECT playerId AS id FROM crew_members WHERE crewId = ?
     ORDER BY FIELD(role, 'leader', 'co_leader', 'consigliere', 'capo', 'officer', 'member'), playerId ASC`,
    crewId,
  );
  return rows.map((r) => toNum(r.id)).filter((id) => id > 0);
}

async function _getPlayerLanguage(playerId: number): Promise<Language> {
  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  return translationService.getPlayerLanguage(player ?? {});
}

async function notifyCrewRiskReinforce(
  crewId: number,
  countryCode: string,
  armiesRemaining: number,
  windowEndsAt: Date,
): Promise<void> {
  const armiesLabel = String(Math.max(0, Math.floor(armiesRemaining)));
  const countryLabel = countryCode.toUpperCase();
  const players = await _getCrewPlayerIds(crewId);
  for (const playerId of players) {
    const lang = await _getPlayerLanguage(playerId);
    const n = translationService.getTranslations(lang).notification;
    const sender = translationService.getTranslations(lang).common.territorySystemSender;
    await notificationService
      .sendToPlayer(
        playerId,
        n.territoryRiskReinforce.title,
        n.territoryRiskReinforce.pushBody(armiesLabel, countryLabel),
        {
          type: 'territory_risk_reinforce',
          countryCode,
          armiesRemaining: armiesLabel,
          windowEndsAt: windowEndsAt.toISOString(),
        },
      )
      .catch(() => {});
    await directMessageService
      .sendSystemMessage(playerId, n.territoryRiskReinforce.inboxMessage(armiesLabel, countryLabel), {
        sendPush: false,
        senderName: sender,
      })
      .catch(() => {});
  }
  await prisma.$executeRawUnsafe(
    `UPDATE territory_risk_reinforce SET notifiedAt = NOW(), updatedAt = NOW()
     WHERE crewId = ? AND countryCode = ?`,
    crewId,
    countryCode.toLowerCase(),
  );
}

/**
 * Once per open reinforce window: remind crews that still have unplaced armies.
 */
export async function processRiskReinforceReminders(now: Date = new Date()): Promise<number> {
  const risk = await getRiskConfig();
  if (!risk.enabled) return 0;
  const hours = risk.reinforceHours;
  const rows = await prisma.$queryRawUnsafe<
    Array<{
      crewId: number;
      countryCode: string;
      armiesRemaining: number;
      windowEndsAt: Date;
    }>
  >(
    `SELECT crewId, countryCode, armiesRemaining,
            DATE_ADD(windowStartedAt, INTERVAL ? HOUR) AS windowEndsAt
     FROM territory_risk_reinforce
     WHERE armiesRemaining > 0
       AND notifiedAt IS NULL
       AND DATE_ADD(windowStartedAt, INTERVAL ? HOUR) > ?
     ORDER BY armiesRemaining DESC
     LIMIT 40`,
    hours,
    hours,
    now,
  );
  let sent = 0;
  for (const row of rows) {
    await notifyCrewRiskReinforce(
      toNum(row.crewId),
      String(row.countryCode).toLowerCase(),
      toNum(row.armiesRemaining),
      new Date(row.windowEndsAt),
    );
    sent += 1;
  }
  return sent;
}

export async function getCrewRiskReinforcePending(crewId: number): Promise<{
  countryCode: string;
  armiesRemaining: number;
  windowEndsAt: string | null;
  secondsRemaining: number;
  canClaim: boolean;
} | null> {
  if (!crewId) return null;
  const risk = await getRiskConfig();
  if (!risk.enabled) return null;
  const hours = risk.reinforceHours;
  const open = await prisma.$queryRawUnsafe<
    Array<{
      countryCode: string;
      armiesRemaining: number;
      windowEndsAt: Date;
    }>
  >(
    `SELECT countryCode, armiesRemaining,
            DATE_ADD(windowStartedAt, INTERVAL ? HOUR) AS windowEndsAt
     FROM territory_risk_reinforce
     WHERE crewId = ?
       AND armiesRemaining > 0
       AND DATE_ADD(windowStartedAt, INTERVAL ? HOUR) > NOW()
     ORDER BY armiesRemaining DESC
     LIMIT 1`,
    hours,
    crewId,
    hours,
  );
  if (open[0]) {
    const ends = new Date(open[0].windowEndsAt);
    const secondsRemaining = Math.max(0, Math.floor((ends.getTime() - Date.now()) / 1000));
    return {
      countryCode: String(open[0].countryCode).toLowerCase(),
      armiesRemaining: Math.max(0, toNum(open[0].armiesRemaining)),
      windowEndsAt: ends.toISOString(),
      secondsRemaining,
      canClaim: false,
    };
  }

  // No open window with leftover armies: check if any owned country can claim a new window.
  const claimable = await prisma.$queryRawUnsafe<Array<{ countryCode: string }>>(
    `SELECT DISTINCT tc.countryCode
     FROM territory_control ctrl
     JOIN territory_regions tc ON tc.regionKey = ctrl.regionKey AND tc.enabled = 1
     LEFT JOIN territory_risk_reinforce r
       ON r.crewId = ? AND r.countryCode = tc.countryCode
     WHERE ctrl.ownerCrewId = ?
       AND (
         r.crewId IS NULL
         OR DATE_ADD(r.windowStartedAt, INTERVAL ? HOUR) <= NOW()
       )
     LIMIT 1`,
    crewId,
    crewId,
    hours,
  );
  if (!claimable[0]) return null;
  return {
    countryCode: String(claimable[0].countryCode).toLowerCase(),
    armiesRemaining: 0,
    windowEndsAt: null,
    secondsRemaining: 0,
    canClaim: true,
  };
}

export async function getRiskCaptureWire(limit = 10): Promise<
  Array<{
    id: number;
    regionKey: string;
    regionNameNl: string | null;
    regionNameEn: string | null;
    countryCode: string;
    winnerCrewName: string | null;
    defenderCrewName: string | null;
    capturedAt: Date;
  }>
> {
  const take = Math.max(1, Math.min(25, Math.floor(limit) || 10));
  const rows = await prisma.$queryRawUnsafe<
    Array<{
      id: number;
      toRegionKey: string;
      countryCode: string;
      createdAt: Date;
      winnerCrewName: string | null;
      defenderCrewName: string | null;
      nameNl: string | null;
      nameEn: string | null;
    }>
  >(
    `SELECT b.id, b.toRegionKey, b.countryCode, b.createdAt,
            ac.name AS winnerCrewName, dc.name AS defenderCrewName,
            tr.nameNl, tr.nameEn
     FROM territory_risk_battle_log b
     LEFT JOIN crews ac ON ac.id = b.attackerCrewId
     LEFT JOIN crews dc ON dc.id = b.defenderCrewId
     LEFT JOIN territory_regions tr ON tr.regionKey = b.toRegionKey
     WHERE b.captured = 1
     ORDER BY b.createdAt DESC
     LIMIT ?`,
    take,
  );
  return rows.map((row) => ({
    id: toNum(row.id),
    regionKey: row.toRegionKey,
    regionNameNl: row.nameNl,
    regionNameEn: row.nameEn,
    countryCode: String(row.countryCode).toLowerCase(),
    winnerCrewName: row.winnerCrewName,
    defenderCrewName: row.defenderCrewName,
    capturedAt: new Date(row.createdAt),
  }));
}
