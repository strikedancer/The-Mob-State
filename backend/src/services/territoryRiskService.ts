import prisma from '../lib/prisma';
import {
  getTerritoryConfig,
  parseTerritoryStringArray,
  mapTravelCountryToTerritoryCode,
} from './territoryService';
import * as territoryCrewStatsService from './territoryCrewStatsService';
import * as territoryArsenalService from './territoryArsenalService';

type RiskConfig = {
  enabled: boolean;
  modeCountries: Set<string>;
  reinforceHours: number;
  attackCooldownSeconds: number;
  maxRoundsPerAttack: number;
  minArmiesOnCapture: number;
  neutralGarrison: number;
  nlFullControlBonus: number;
  seedArmiesOnOwned: number;
};

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
  ]);
  const countries = String(cfg['TERRITORY_RISK_MODE_COUNTRIES'] ?? 'nl')
    .split(',')
    .map((c) => c.trim().toLowerCase())
    .filter(Boolean);
  return {
    enabled: Number(cfg['TERRITORY_RISK_ENABLED'] ?? 1) === 1,
    modeCountries: new Set(countries),
    reinforceHours: Math.max(1, toNum(cfg['TERRITORY_RISK_REINFORCE_HOURS'] ?? 8)),
    attackCooldownSeconds: Math.max(30, toNum(cfg['TERRITORY_RISK_ATTACK_COOLDOWN_SECONDS'] ?? 300)),
    maxRoundsPerAttack: Math.max(1, Math.min(50, toNum(cfg['TERRITORY_RISK_MAX_ROUNDS_PER_ATTACK'] ?? 20))),
    minArmiesOnCapture: Math.max(1, toNum(cfg['TERRITORY_RISK_MIN_ARMIES_ON_CAPTURE'] ?? 1)),
    neutralGarrison: Math.max(1, toNum(cfg['TERRITORY_RISK_NEUTRAL_GARRISON'] ?? 3)),
    nlFullControlBonus: Math.max(0, toNum(cfg['TERRITORY_RISK_NL_FULL_CONTROL_BONUS'] ?? 5)),
    seedArmiesOnOwned: Math.max(1, toNum(cfg['TERRITORY_RISK_SEED_ARMIES_ON_OWNED'] ?? 3)),
  };
}

export async function isRiskModeCountry(countryCode: string | null | undefined): Promise<boolean> {
  const risk = await getRiskConfig();
  if (!risk.enabled) return false;
  const code = String(countryCode ?? '').trim().toLowerCase();
  return risk.modeCountries.has(code);
}

function assertInCountry(currentCountry: string | null | undefined, regionCountryCode: string): void {
  const mapped = mapTravelCountryToTerritoryCode(currentCountry);
  if (!mapped || mapped !== regionCountryCode.toLowerCase()) {
    throw new Error('ACTION_OUTSIDE_CURRENT_COUNTRY');
  }
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
  if (!risk.enabled || !risk.modeCountries.has(countryCode.toLowerCase())) return;

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
  if (!risk.enabled || !risk.modeCountries.has(countryCode)) {
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
): number {
  let grant = Math.max(3, Math.floor(ownedCount / 3));
  if (countryCode === 'nl' && totalInCountry > 0 && ownedCount >= totalInCountry) {
    grant += risk.nlFullControlBonus;
  }
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
  windowStartedAt: Date;
  windowEndsAt: Date;
  canClaimNew: boolean;
}> {
  const now = new Date();
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
      return {
        armiesRemaining: Math.max(0, toNum(existing.armiesRemaining)),
        armiesGranted: Math.max(0, toNum(existing.armiesGranted)),
        fortifyUsed: toNum(existing.fortifyUsed) === 1,
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
  const grant = computeReinforceGrant(owned, total, countryCode, risk);
  await prisma.$executeRawUnsafe(
    `INSERT INTO territory_risk_reinforce
       (crewId, countryCode, windowStartedAt, armiesGranted, armiesRemaining, fortifyUsed)
     VALUES (?, ?, NOW(), ?, ?, 0)
     ON DUPLICATE KEY UPDATE
       windowStartedAt = NOW(),
       armiesGranted = VALUES(armiesGranted),
       armiesRemaining = VALUES(armiesRemaining),
       fortifyUsed = 0,
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
    windowEndsAt: Date;
    secondsRemaining: number;
  };
  armiesByRegion: Record<string, number>;
}> {
  const risk = await getRiskConfig();
  const code = params.countryCode.toLowerCase();
  const riskMode = risk.enabled && risk.modeCountries.has(code);
  if (!riskMode) {
    return { riskMode: false, reinforce: null, armiesByRegion: {} };
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
    windowEndsAt: Date;
    secondsRemaining: number;
  } | null = null;

  if (params.viewerCrewId != null) {
    const owned = await countOwnedInCountry(params.viewerCrewId, code);
    if (owned > 0) {
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
        if (now < endsAt.getTime()) {
          reinforce = {
            armiesRemaining: Math.max(0, toNum(rows[0].armiesRemaining)),
            armiesGranted: Math.max(0, toNum(rows[0].armiesGranted)),
            fortifyUsed: toNum(rows[0].fortifyUsed) === 1,
            windowEndsAt: endsAt,
            secondsRemaining: Math.max(0, Math.ceil((endsAt.getTime() - now) / 1000)),
          };
        } else {
          reinforce = {
            armiesRemaining: 0,
            armiesGranted: 0,
            fortifyUsed: false,
            windowEndsAt: new Date(now),
            secondsRemaining: 0,
          };
        }
      } else {
        reinforce = {
          armiesRemaining: 0,
          armiesGranted: 0,
          fortifyUsed: false,
          windowEndsAt: new Date(now),
          secondsRemaining: 0,
        };
      }
    }
  }

  return { riskMode: true, reinforce, armiesByRegion };
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

  const neighbors = parseTerritoryStringArray(from.neighborsJson);
  if (!neighbors.includes(toRegionKey)) throw new Error('RISK_NOT_ADJACENT');

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
    `UPDATE territory_risk_reinforce SET fortifyUsed = 1, updatedAt = NOW()
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

  const neighbors = parseTerritoryStringArray(from.neighborsJson);
  if (!neighbors.includes(toRegionKey)) throw new Error('RISK_NOT_ADJACENT');

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

  // Region cap when capturing a new (not already owned) region
  if (ownerTo !== crewId) {
    const territoryCfg = await getTerritoryConfig();
    const globalOwned = await prisma.$queryRawUnsafe<Array<{ cnt: number }>>(
      `SELECT COUNT(*) AS cnt FROM territory_control WHERE ownerCrewId = ?`,
      crewId,
    );
    if (toNum(globalOwned[0]?.cnt) >= territoryCfg.regionHardCap) {
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
