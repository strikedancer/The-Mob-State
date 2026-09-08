import prisma from '../lib/prisma';

export const RACE_RUNTIME_SETTING_DEFAULTS: Record<string, string> = {
  RACE_ENABLED: '1',
  RACE_MIN_RANK: '3',
  RACE_WINDOW_MINUTES: '90',
  RACE_COOLDOWN_MINUTES: '120',
  RACE_RAKE_BPS: '800',
  RACE_MIN_STAKE: '1000',
  RACE_MAX_STAKE: '25000',
  RACE_MIN_BET: '500',
  RACE_MAX_BET: '8000',
  RACE_MAX_ENTRIES: '12',
  RACE_MAX_BETS_PER_PLAYER: '3',
  RACE_MIN_CONDITION: '35',
  RACE_FIXING_WANTED: '8',
};

export const RACE_RUNTIME_SETTING_KEYS = Object.keys(RACE_RUNTIME_SETTING_DEFAULTS);

export type RaceRuntimeConfig = {
  enabled: boolean;
  minRank: number;
  windowMinutes: number;
  cooldownMinutes: number;
  rakeBps: number;
  minStake: number;
  maxStake: number;
  minBet: number;
  maxBet: number;
  maxEntries: number;
  maxBetsPerPlayer: number;
  minCondition: number;
  fixingWanted: number;
};

let cache: { value: RaceRuntimeConfig; expiresAt: number } | null = null;
const TTL_MS = 60_000;

function num(map: Record<string, string>, key: string, fallback: number): number {
  const parsed = Number.parseInt(map[key] ?? '', 10);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function build(map: Record<string, string>): RaceRuntimeConfig {
  return {
    enabled: (map.RACE_ENABLED ?? '1') !== '0',
    minRank: num(map, 'RACE_MIN_RANK', 3),
    windowMinutes: num(map, 'RACE_WINDOW_MINUTES', 90),
    cooldownMinutes: num(map, 'RACE_COOLDOWN_MINUTES', 120),
    rakeBps: num(map, 'RACE_RAKE_BPS', 800),
    minStake: num(map, 'RACE_MIN_STAKE', 1000),
    maxStake: num(map, 'RACE_MAX_STAKE', 25000),
    minBet: num(map, 'RACE_MIN_BET', 500),
    maxBet: num(map, 'RACE_MAX_BET', 8000),
    maxEntries: num(map, 'RACE_MAX_ENTRIES', 12),
    maxBetsPerPlayer: num(map, 'RACE_MAX_BETS_PER_PLAYER', 3),
    minCondition: num(map, 'RACE_MIN_CONDITION', 35),
    fixingWanted: num(map, 'RACE_FIXING_WANTED', 8),
  };
}

export function invalidateRaceConfigCache(): void {
  cache = null;
}

export async function getRaceRuntimeConfig(): Promise<RaceRuntimeConfig> {
  if (cache && cache.expiresAt > Date.now()) {
    return cache.value;
  }

  const keys = RACE_RUNTIME_SETTING_KEYS;
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma
    .$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...keys,
    )
    .catch(() => [] as Array<{ configKey: string; configValue: string }>);

  const map: Record<string, string> = { ...RACE_RUNTIME_SETTING_DEFAULTS };
  for (const row of rows) {
    map[row.configKey] = String(row.configValue ?? map[row.configKey] ?? '');
  }

  const value = build(map);
  cache = { value, expiresAt: Date.now() + TTL_MS };
  return value;
}
