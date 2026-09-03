import prisma from '../lib/prisma';
import { timeProvider } from '../utils/timeProvider';
import countriesData from '../../content/countries.json';

export const COUNTRY_POLICE_RUNTIME_SETTING_DEFAULTS = {
  COUNTRY_POLICE_PRESSURE_ENABLED: '0',
  COUNTRY_POLICE_BASELINE: '15',
  COUNTRY_POLICE_DECAY_PER_TICK: '1',
  COUNTRY_POLICE_GAIN_CRIME: '1',
  COUNTRY_POLICE_GAIN_CRIME_HIGH_TIER: '2',
  COUNTRY_POLICE_HIGH_TIER_REWARD: '5000',
  COUNTRY_POLICE_GAIN_VEHICLE_THEFT: '1',
  COUNTRY_POLICE_GAIN_DRUG_COLLECT: '1',
  COUNTRY_POLICE_SUCCESS_PENALTY_MAX_PP: '8',
  COUNTRY_POLICE_ARREST_BONUS_MAX_PP: '12',
  COUNTRY_POLICE_PLAYER_GAIN_CAP_PER_HOUR: '10',
  COUNTRY_POLICE_TERRITORY_GAIN_MULT: '0.95',
  COUNTRY_POLICE_TERRITORY_EXTRA_DECAY: '1',
  COUNTRY_POLICE_CRACKDOWN_MULT: '1.5',
  COUNTRY_POLICE_DISRUPT_ENABLED: '1',
  COUNTRY_POLICE_DISRUPT_MIN_RANK: '10',
  COUNTRY_POLICE_DISRUPT_REQUIRE_CREW: '1',
  COUNTRY_POLICE_DISRUPT_COOLDOWN_SECONDS: '14400',
  COUNTRY_POLICE_DISRUPT_COOL_MINUTES: '90',
  COUNTRY_POLICE_DISRUPT_SUCCESS_CHANCE: '0.45',
} as const;

export const COUNTRY_POLICE_RUNTIME_SETTING_KEYS = Object.keys(
  COUNTRY_POLICE_RUNTIME_SETTING_DEFAULTS,
);

/** Soft flavor floors (Phase 2) — never below global baseline after max(). */
const COUNTRY_FLAVOR_FLOOR: Record<string, number> = {
  netherlands: 18,
  belgium: 16,
  germany: 17,
  france: 18,
  spain: 15,
  italy: 16,
  uk: 20,
  switzerland: 12,
  usa: 22,
  mexico: 18,
  colombia: 20,
  brazil: 18,
  argentina: 15,
  japan: 17,
  china: 19,
  russia: 20,
  turkey: 16,
  united_arab_emirates: 14,
  south_africa: 17,
  australia: 14,
};

const TRAVEL_TO_TERRITORY: Record<string, string> = {
  netherlands: 'nl',
  belgium: 'be',
  germany: 'de',
  france: 'fr',
  spain: 'es',
  italy: 'it',
  uk: 'gb',
  switzerland: 'ch',
  usa: 'us',
  mexico: 'mx',
  colombia: 'co',
  brazil: 'br',
  argentina: 'ar',
  japan: 'jp',
  china: 'cn',
  russia: 'ru',
  turkey: 'tr',
  united_arab_emirates: 'ae',
  south_africa: 'za',
  australia: 'au',
};

export type PolicePressureBand = 'calm' | 'watchful' | 'hot' | 'lockdown';

export type CountryPoliceModifiers = {
  enabled: boolean;
  countryCode: string;
  pressure: number;
  band: PolicePressureBand;
  successPenaltyPp: number;
  arrestBonusPp: number;
  coolUntil: Date | null;
};

export type DisruptActionType = 'corruption' | 'distract' | 'raid';

type RuntimeCfg = {
  enabled: boolean;
  baseline: number;
  decayPerTick: number;
  gainCrime: number;
  gainCrimeHighTier: number;
  highTierReward: number;
  gainVehicleTheft: number;
  gainDrugCollect: number;
  successPenaltyMaxPp: number;
  arrestBonusMaxPp: number;
  playerGainCapPerHour: number;
  territoryGainMult: number;
  territoryExtraDecay: number;
  crackdownMult: number;
  crackdownCategories: Set<string>;
  disruptEnabled: boolean;
  disruptMinRank: number;
  disruptRequireCrew: boolean;
  disruptCooldownSeconds: number;
  disruptCoolMinutes: number;
  disruptSuccessChance: number;
};

const CACHE_TTL_MS = 30_000;
let cfgCache: { value: RuntimeCfg; expiresAt: number } | null = null;
let schemaReady = false;

const TRAVEL_COUNTRY_IDS: string[] = (countriesData as Array<{ id: string }>).map(
  (c) => c.id,
);

function toInt(value: unknown, fallback: number): number {
  const n = Number(value);
  return Number.isFinite(n) ? Math.trunc(n) : fallback;
}

function toFloat(value: unknown, fallback: number): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : fallback;
}

function clampPressure(n: number): number {
  return Math.max(0, Math.min(100, Math.trunc(n)));
}

export function pressureBand(pressure: number): PolicePressureBand {
  if (pressure >= 75) return 'lockdown';
  if (pressure >= 50) return 'hot';
  if (pressure >= 25) return 'watchful';
  return 'calm';
}

function hourKey(now = timeProvider.now()): string {
  return now.toISOString().slice(0, 13); // YYYY-MM-DDTHH
}

async function ensureSchema(): Promise<void> {
  if (schemaReady) return;
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS country_police_state (
      countryCode VARCHAR(50) NOT NULL PRIMARY KEY,
      pressure INT NOT NULL DEFAULT 15,
      updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      lastActivityAt DATETIME(3) NULL,
      coolUntil DATETIME(3) NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
  await prisma.$executeRawUnsafe(`
    CREATE TABLE IF NOT EXISTS country_police_player_hourly (
      playerId INT NOT NULL,
      countryCode VARCHAR(50) NOT NULL,
      hourKey VARCHAR(16) NOT NULL,
      gained INT NOT NULL DEFAULT 0,
      updatedAt DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
      PRIMARY KEY (playerId, countryCode, hourKey),
      INDEX idx_country_police_hourly_hour (hourKey)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
  `);
  schemaReady = true;
}

async function loadRuntimeCfg(): Promise<RuntimeCfg> {
  const now = Date.now();
  if (cfgCache && cfgCache.expiresAt > now) {
    return cfgCache.value;
  }

  await ensureSchema();
  const keys = COUNTRY_POLICE_RUNTIME_SETTING_KEYS;
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...keys,
  ).catch(() => [] as Array<{ configKey: string; configValue: string }>);

  const map: Record<string, string> = { ...COUNTRY_POLICE_RUNTIME_SETTING_DEFAULTS };
  for (const row of rows) {
    map[row.configKey] = String(row.configValue ?? map[row.configKey] ?? '');
  }

  const cats = ['crime'];

  const value: RuntimeCfg = {
    enabled: map.COUNTRY_POLICE_PRESSURE_ENABLED === '1' || map.COUNTRY_POLICE_PRESSURE_ENABLED === 'true',
    baseline: toInt(map.COUNTRY_POLICE_BASELINE, 15),
    decayPerTick: Math.max(0, toInt(map.COUNTRY_POLICE_DECAY_PER_TICK, 1)),
    gainCrime: Math.max(0, toInt(map.COUNTRY_POLICE_GAIN_CRIME, 1)),
    gainCrimeHighTier: Math.max(0, toInt(map.COUNTRY_POLICE_GAIN_CRIME_HIGH_TIER, 2)),
    highTierReward: Math.max(0, toInt(map.COUNTRY_POLICE_HIGH_TIER_REWARD, 5000)),
    gainVehicleTheft: Math.max(0, toInt(map.COUNTRY_POLICE_GAIN_VEHICLE_THEFT, 1)),
    gainDrugCollect: Math.max(0, toInt(map.COUNTRY_POLICE_GAIN_DRUG_COLLECT, 1)),
    successPenaltyMaxPp: Math.max(0, toInt(map.COUNTRY_POLICE_SUCCESS_PENALTY_MAX_PP, 8)),
    arrestBonusMaxPp: Math.max(0, toInt(map.COUNTRY_POLICE_ARREST_BONUS_MAX_PP, 12)),
    playerGainCapPerHour: Math.max(0, toInt(map.COUNTRY_POLICE_PLAYER_GAIN_CAP_PER_HOUR, 10)),
    territoryGainMult: Math.min(1, Math.max(0.5, toFloat(map.COUNTRY_POLICE_TERRITORY_GAIN_MULT, 0.95))),
    territoryExtraDecay: Math.max(0, toInt(map.COUNTRY_POLICE_TERRITORY_EXTRA_DECAY, 1)),
    crackdownMult: Math.max(1, toFloat(map.COUNTRY_POLICE_CRACKDOWN_MULT, 1.5)),
    crackdownCategories: new Set(cats),
    disruptEnabled: map.COUNTRY_POLICE_DISRUPT_ENABLED !== '0' && map.COUNTRY_POLICE_DISRUPT_ENABLED !== 'false',
    disruptMinRank: Math.max(1, toInt(map.COUNTRY_POLICE_DISRUPT_MIN_RANK, 10)),
    disruptRequireCrew: map.COUNTRY_POLICE_DISRUPT_REQUIRE_CREW !== '0',
    disruptCooldownSeconds: Math.max(60, toInt(map.COUNTRY_POLICE_DISRUPT_COOLDOWN_SECONDS, 14400)),
    disruptCoolMinutes: Math.max(15, toInt(map.COUNTRY_POLICE_DISRUPT_COOL_MINUTES, 90)),
    disruptSuccessChance: Math.min(0.9, Math.max(0.1, toFloat(map.COUNTRY_POLICE_DISRUPT_SUCCESS_CHANCE, 0.45))),
  };

  cfgCache = { value, expiresAt: now + CACHE_TTL_MS };
  return value;
}

export function invalidateCountryPoliceConfigCache(): void {
  cfgCache = null;
}

function countryFloor(cfg: RuntimeCfg, countryCode: string): number {
  const flavor = COUNTRY_FLAVOR_FLOOR[countryCode] ?? cfg.baseline;
  return Math.max(cfg.baseline, flavor);
}

async function ensureCountryRow(countryCode: string, floor: number): Promise<void> {
  await prisma.$executeRawUnsafe(
    `INSERT INTO country_police_state (countryCode, pressure, updatedAt)
     VALUES (?, ?, NOW(3))
     ON DUPLICATE KEY UPDATE countryCode = countryCode`,
    countryCode,
    floor,
  );
}

async function readState(countryCode: string): Promise<{
  pressure: number;
  coolUntil: Date | null;
  lastActivityAt: Date | null;
}> {
  const cfg = await loadRuntimeCfg();
  const floor = countryFloor(cfg, countryCode);
  await ensureCountryRow(countryCode, floor);
  const rows = await prisma.$queryRawUnsafe<
    Array<{ pressure: number; coolUntil: Date | null; lastActivityAt: Date | null }>
  >(
    `SELECT pressure, coolUntil, lastActivityAt FROM country_police_state WHERE countryCode = ? LIMIT 1`,
    countryCode,
  );
  const row = rows[0];
  return {
    pressure: clampPressure(row?.pressure ?? floor),
    coolUntil: row?.coolUntil ? new Date(row.coolUntil) : null,
    lastActivityAt: row?.lastActivityAt ? new Date(row.lastActivityAt) : null,
  };
}

function modifiersFromPressure(
  cfg: RuntimeCfg,
  countryCode: string,
  pressure: number,
  coolUntil: Date | null,
): CountryPoliceModifiers {
  if (!cfg.enabled) {
    return {
      enabled: false,
      countryCode,
      pressure: 0,
      band: 'calm',
      successPenaltyPp: 0,
      arrestBonusPp: 0,
      coolUntil: null,
    };
  }
  const p = clampPressure(pressure);
  return {
    enabled: true,
    countryCode,
    pressure: p,
    band: pressureBand(p),
    successPenaltyPp: Math.floor((p / 100) * cfg.successPenaltyMaxPp),
    arrestBonusPp: Math.floor((p / 100) * cfg.arrestBonusMaxPp),
    coolUntil,
  };
}

async function crewOwnsTerritoryInCountry(playerId: number, travelCountry: string): Promise<boolean> {
  const territoryCode = TRAVEL_TO_TERRITORY[travelCountry];
  if (!territoryCode) return false;

  const membership = await prisma.crewMember.findFirst({
    where: { playerId },
    select: { crewId: true },
  });
  if (!membership?.crewId) return false;

  try {
    const rows = await prisma.$queryRawUnsafe<Array<{ n: number }>>(
      `SELECT COUNT(*) AS n
       FROM territory_control tc
       JOIN territory_regions tr ON tr.regionKey = tc.regionKey
       WHERE tc.ownerCrewId = ? AND tr.countryCode = ? AND tr.enabled = 1
       LIMIT 1`,
      membership.crewId,
      territoryCode,
    );
    return Number(rows[0]?.n ?? 0) > 0;
  } catch {
    return false;
  }
}

async function isCrackdownActive(cfg: RuntimeCfg): Promise<boolean> {
  if (cfg.crackdownCategories.size === 0) return false;
  try {
    const now = timeProvider.now();
    const active = await prisma.gameLiveEvent.findMany({
      where: {
        status: 'active',
        AND: [
          { OR: [{ startedAt: null }, { startedAt: { lte: now } }] },
          { OR: [{ endsAt: null }, { endsAt: { gt: now } }] },
        ],
      },
      select: {
        template: { select: { category: true } },
      },
      take: 20,
    });
    return active.some((ev) =>
      cfg.crackdownCategories.has(String(ev.template?.category || '').toLowerCase()),
    );
  } catch {
    return false;
  }
}

async function remainingHourlyCap(
  playerId: number,
  countryCode: string,
  cap: number,
): Promise<number> {
  if (cap <= 0) return 0;
  const key = hourKey();
  const rows = await prisma.$queryRawUnsafe<Array<{ gained: number }>>(
    `SELECT gained FROM country_police_player_hourly
     WHERE playerId = ? AND countryCode = ? AND hourKey = ? LIMIT 1`,
    playerId,
    countryCode,
    key,
  );
  const gained = Number(rows[0]?.gained ?? 0);
  return Math.max(0, cap - gained);
}

async function addHourlyGain(
  playerId: number,
  countryCode: string,
  amount: number,
): Promise<void> {
  if (amount <= 0) return;
  const key = hourKey();
  await prisma.$executeRawUnsafe(
    `INSERT INTO country_police_player_hourly (playerId, countryCode, hourKey, gained, updatedAt)
     VALUES (?, ?, ?, ?, NOW(3))
     ON DUPLICATE KEY UPDATE gained = gained + VALUES(gained), updatedAt = NOW(3)`,
    playerId,
    countryCode,
    key,
    amount,
  );
}

export const countryPoliceService = {
  async isEnabled(): Promise<boolean> {
    const cfg = await loadRuntimeCfg();
    return cfg.enabled;
  },

  async getModifiersForCountry(countryCode: string): Promise<CountryPoliceModifiers> {
    const cfg = await loadRuntimeCfg();
    const code = countryCode || 'netherlands';
    if (!cfg.enabled) {
      return modifiersFromPressure(cfg, code, 0, null);
    }
    const state = await readState(code);
    return modifiersFromPressure(cfg, code, state.pressure, state.coolUntil);
  },

  async getModifiersForPlayer(playerId: number): Promise<CountryPoliceModifiers> {
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true },
    });
    return this.getModifiersForCountry(player?.currentCountry || 'netherlands');
  },

  async listCountries(): Promise<
    Array<{
      countryCode: string;
      pressure: number;
      band: PolicePressureBand;
      successPenaltyPp: number;
      arrestBonusPp: number;
    }>
  > {
    const cfg = await loadRuntimeCfg();
    if (!cfg.enabled) {
      return TRAVEL_COUNTRY_IDS.map((countryCode) => ({
        countryCode,
        pressure: 0,
        band: 'calm' as const,
        successPenaltyPp: 0,
        arrestBonusPp: 0,
      }));
    }

    for (const id of TRAVEL_COUNTRY_IDS) {
      await ensureCountryRow(id, countryFloor(cfg, id));
    }

    const rows = await prisma.$queryRawUnsafe<
      Array<{ countryCode: string; pressure: number; coolUntil: Date | null }>
    >(`SELECT countryCode, pressure, coolUntil FROM country_police_state`);

    const byCode = new Map(rows.map((r) => [r.countryCode, r]));
    return TRAVEL_COUNTRY_IDS.map((countryCode) => {
      const row = byCode.get(countryCode);
      const pressure = clampPressure(row?.pressure ?? countryFloor(cfg, countryCode));
      const mod = modifiersFromPressure(cfg, countryCode, pressure, row?.coolUntil ?? null);
      return {
        countryCode,
        pressure: mod.pressure,
        band: mod.band,
        successPenaltyPp: mod.successPenaltyPp,
        arrestBonusPp: mod.arrestBonusPp,
      };
    });
  },

  /**
   * Apply world pressure penalty (percentage points) to a 0–1 success chance.
   */
  applySuccessPenalty(chance01: number, successPenaltyPp: number): number {
    if (successPenaltyPp <= 0) return chance01;
    return Math.max(0.05, Math.min(0.95, chance01 - successPenaltyPp / 100));
  },

  async recordActivityGain(params: {
    playerId: number;
    countryCode: string;
    source: 'crime' | 'vehicle_theft' | 'drug_collect';
    maxReward?: number;
  }): Promise<{ gained: number; pressure: number }> {
    const cfg = await loadRuntimeCfg();
    if (!cfg.enabled) {
      return { gained: 0, pressure: 0 };
    }

    const countryCode = params.countryCode || 'netherlands';
    let gain = 0;
    if (params.source === 'crime') {
      gain = cfg.gainCrime;
      if ((params.maxReward ?? 0) >= cfg.highTierReward) {
        gain += cfg.gainCrimeHighTier;
      }
    } else if (params.source === 'vehicle_theft') {
      gain = cfg.gainVehicleTheft;
    } else {
      gain = cfg.gainDrugCollect;
    }

    if (await isCrackdownActive(cfg)) {
      gain = Math.max(1, Math.round(gain * cfg.crackdownMult));
    }

    if (await crewOwnsTerritoryInCountry(params.playerId, countryCode)) {
      gain = Math.max(0, Math.round(gain * cfg.territoryGainMult));
    }

    const remaining = await remainingHourlyCap(
      params.playerId,
      countryCode,
      cfg.playerGainCapPerHour,
    );
    gain = Math.min(gain, remaining);
    if (gain <= 0) {
      const state = await readState(countryCode);
      return { gained: 0, pressure: state.pressure };
    }

    await ensureCountryRow(countryCode, countryFloor(cfg, countryCode));
    await prisma.$executeRawUnsafe(
      `UPDATE country_police_state
       SET pressure = LEAST(100, pressure + ?),
           lastActivityAt = NOW(3),
           updatedAt = NOW(3)
       WHERE countryCode = ?`,
      gain,
      countryCode,
    );
    await addHourlyGain(params.playerId, countryCode, gain);

    const state = await readState(countryCode);
    console.log(
      `[CountryPolice] +${gain} ${params.source} player=${params.playerId} country=${countryCode} pressure=${state.pressure}`,
    );
    return { gained: gain, pressure: state.pressure };
  },

  async decayAllCountries(): Promise<number> {
    const cfg = await loadRuntimeCfg();
    if (!cfg.enabled) return 0;

    let updated = 0;
    for (const countryCode of TRAVEL_COUNTRY_IDS) {
      const floor = countryFloor(cfg, countryCode);
      await ensureCountryRow(countryCode, floor);
      const state = await readState(countryCode);
      if (state.pressure <= floor) continue;

      let decay = cfg.decayPerTick;
      if (state.lastActivityAt) {
        const quietMs = timeProvider.now().getTime() - state.lastActivityAt.getTime();
        if (quietMs > 2 * 60 * 60 * 1000) {
          decay *= 2;
        }
      }

      // Phase 2: crews that dominate the country help cool streets slightly via extra decay
      // applied globally when any crew owns territory there (not per-player tick).
      try {
        const territoryCode = TRAVEL_TO_TERRITORY[countryCode];
        if (territoryCode) {
          const owned = await prisma.$queryRawUnsafe<Array<{ n: number }>>(
            `SELECT COUNT(*) AS n
             FROM territory_control tc
             JOIN territory_regions tr ON tr.regionKey = tc.regionKey
             WHERE tr.countryCode = ? AND tr.enabled = 1 AND tc.ownerCrewId IS NOT NULL
             LIMIT 1`,
            territoryCode,
          );
          if (Number(owned[0]?.n ?? 0) > 0) {
            decay += cfg.territoryExtraDecay;
          }
        }
      } catch {
        // territory schema may be absent in some envs
      }

      const next = Math.max(floor, state.pressure - decay);
      if (next === state.pressure) continue;
      await prisma.$executeRawUnsafe(
        `UPDATE country_police_state SET pressure = ?, updatedAt = NOW(3) WHERE countryCode = ?`,
        next,
        countryCode,
      );
      updated += 1;
    }
    return updated;
  },

  getDisruptCatalog(cfg?: RuntimeCfg) {
    const coolHint = cfg?.disruptCoolMinutes ?? 90;
    return [
      {
        actionType: 'corruption' as const,
        costMoney: 25000,
        pressureDrop: 15,
        failWanted: 8,
        failFbi: 5,
        minRank: 10,
      },
      {
        actionType: 'distract' as const,
        costMoney: 40000,
        pressureDrop: 20,
        failWanted: 12,
        failFbi: 8,
        minRank: 15,
      },
      {
        actionType: 'raid' as const,
        costMoney: 75000,
        pressureDrop: 25,
        failWanted: 18,
        failFbi: 12,
        minRank: 20,
      },
    ].map((row) => ({ ...row, coolMinutes: coolHint }));
  },

  async disrupt(params: {
    playerId: number;
    actionType: DisruptActionType;
  }): Promise<{
    success: boolean;
    countryCode: string;
    pressureBefore: number;
    pressureAfter: number;
    costMoney: number;
    wantedDelta: number;
    fbiDelta: number;
    cooldownSeconds: number;
    coolUntil: Date | null;
  }> {
    const cfg = await loadRuntimeCfg();
    if (!cfg.enabled || !cfg.disruptEnabled) {
      throw new Error('COUNTRY_POLICE_DISABLED');
    }

    const player = await prisma.player.findUnique({
      where: { id: params.playerId },
      select: {
        id: true,
        rank: true,
        money: true,
        currentCountry: true,
        wantedLevel: true,
        fbiHeat: true,
      },
    });
    if (!player) throw new Error('PLAYER_NOT_FOUND');

    const catalog = this.getDisruptCatalog(cfg);
    const action = catalog.find((a) => a.actionType === params.actionType);
    if (!action) throw new Error('INVALID_DISRUPT_ACTION');

    const minRank = Math.max(cfg.disruptMinRank, action.minRank);
    if (player.rank < minRank) throw new Error('RANK_TOO_LOW');

    if (cfg.disruptRequireCrew) {
      const membership = await prisma.crewMember.findFirst({
        where: { playerId: params.playerId },
        select: { crewId: true },
      });
      if (!membership) throw new Error('CREW_REQUIRED');
    }

    if (player.money < action.costMoney) throw new Error('INSUFFICIENT_MONEY');

    const countryCode = player.currentCountry || 'netherlands';

    const existingCd = await prisma.actionCooldown.findUnique({
      where: {
        playerId_actionType: {
          playerId: params.playerId,
          actionType: 'country_police_disrupt',
        },
      },
      select: { lastUsedAt: true, cooldownSeconds: true },
    });

    if (existingCd) {
      const elapsed = Math.floor(
        (timeProvider.now().getTime() - existingCd.lastUsedAt.getTime()) / 1000,
      );
      const left = Math.max(0, (existingCd.cooldownSeconds ?? cfg.disruptCooldownSeconds) - elapsed);
      if (left > 0) {
        throw new Error(`ON_COOLDOWN:${left}`);
      }
    }

    const before = await readState(countryCode);
    const success = Math.random() < cfg.disruptSuccessChance;

    await prisma.player.update({
      where: { id: params.playerId },
      data: {
        money: { decrement: action.costMoney },
        ...(success
          ? {}
          : {
              wantedLevel: { increment: action.failWanted },
              fbiHeat: { increment: action.failFbi },
            }),
      },
    });

    let pressureAfter = before.pressure;
    let coolUntil: Date | null = before.coolUntil;

    if (success) {
      let drop = action.pressureDrop;
      if (before.coolUntil && before.coolUntil.getTime() > timeProvider.now().getTime()) {
        drop = Math.max(5, Math.floor(drop * 0.4));
      }
      pressureAfter = Math.max(countryFloor(cfg, countryCode), before.pressure - drop);
      coolUntil = new Date(
        timeProvider.now().getTime() + cfg.disruptCoolMinutes * 60 * 1000,
      );
      await prisma.$executeRawUnsafe(
        `UPDATE country_police_state
         SET pressure = ?, coolUntil = ?, updatedAt = NOW(3)
         WHERE countryCode = ?`,
        pressureAfter,
        coolUntil,
        countryCode,
      );
    } else {
      pressureAfter = Math.min(100, before.pressure + Math.max(3, Math.floor(action.pressureDrop / 3)));
      await prisma.$executeRawUnsafe(
        `UPDATE country_police_state
         SET pressure = ?, lastActivityAt = NOW(3), updatedAt = NOW(3)
         WHERE countryCode = ?`,
        pressureAfter,
        countryCode,
      );
    }

    const now = timeProvider.now();
    await prisma.actionCooldown.upsert({
      where: {
        playerId_actionType: {
          playerId: params.playerId,
          actionType: 'country_police_disrupt',
        },
      },
      create: {
        playerId: params.playerId,
        actionType: 'country_police_disrupt',
        lastUsedAt: now,
        cooldownSeconds: cfg.disruptCooldownSeconds,
      },
      update: {
        lastUsedAt: now,
        cooldownSeconds: cfg.disruptCooldownSeconds,
        lastNotifiedAt: null,
      },
    });

    return {
      success,
      countryCode,
      pressureBefore: before.pressure,
      pressureAfter,
      costMoney: action.costMoney,
      wantedDelta: success ? 0 : action.failWanted,
      fbiDelta: success ? 0 : action.failFbi,
      cooldownSeconds: cfg.disruptCooldownSeconds,
      coolUntil,
    };
  },

  async getRuntimeConfigView() {
    await ensureSchema();
    const keys = COUNTRY_POLICE_RUNTIME_SETTING_KEYS;
    const placeholders = keys.map(() => '?').join(', ');
    const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...keys,
    ).catch(() => [] as Array<{ configKey: string; configValue: string }>);

    const values: Record<string, string> = { ...COUNTRY_POLICE_RUNTIME_SETTING_DEFAULTS };
    for (const row of rows) {
      values[row.configKey] = String(row.configValue ?? values[row.configKey] ?? '');
    }

    return {
      defaults: COUNTRY_POLICE_RUNTIME_SETTING_DEFAULTS,
      values,
      keys,
    };
  },

  async updateRuntimeConfig(updates: Record<string, string | number>) {
    const normalized: Record<string, string> = {};
    for (const [key, value] of Object.entries(updates)) {
      if (!COUNTRY_POLICE_RUNTIME_SETTING_KEYS.includes(key)) {
        throw new Error(`INVALID_RUNTIME_KEY:${key}`);
      }
      const asString = String(value ?? '').trim();
      if (key === 'COUNTRY_POLICE_PRESSURE_ENABLED' || key === 'COUNTRY_POLICE_DISRUPT_ENABLED' || key === 'COUNTRY_POLICE_DISRUPT_REQUIRE_CREW') {
        if (!['0', '1', 'true', 'false'].includes(asString.toLowerCase())) {
          throw new Error(`RUNTIME_OUT_OF_RANGE:${key}`);
        }
        normalized[key] = asString === 'true' ? '1' : asString === 'false' ? '0' : asString;
        continue;
      }
      const asNumber = Number(asString);
      if (!Number.isFinite(asNumber)) {
        throw new Error(`RUNTIME_VALUE_NOT_NUMERIC:${key}`);
      }
      normalized[key] = asString;
    }

    if (Object.keys(normalized).length > 0) {
      for (const [key, value] of Object.entries(normalized)) {
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
      invalidateCountryPoliceConfigCache();
    }
    return this.getRuntimeConfigView();
  },
};
