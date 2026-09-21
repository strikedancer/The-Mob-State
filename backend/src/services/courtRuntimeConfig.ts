import prisma from '../lib/prisma';

/** Live-tunable Rechtbank / trial settings (runtime_config). */
export const COURT_RUNTIME_SETTING_DEFAULTS: Record<string, string> = {
  // Expunge petition (paid wipe on Court screen)
  COURT_EXPUNGE_BASE_COST: '100000',
  COURT_EXPUNGE_COST_PER_EXTRA: '1000',
  COURT_EXPUNGE_BASE_PERCENT: '38',
  COURT_EXPUNGE_MIN_PERCENT: '8',
  COURT_EXPUNGE_MAX_PERCENT: '70',
  COURT_EXPUNGE_DON_JUDGE_PERCENT: '8',
  COURT_EXPUNGE_DON_COMMISSIONER_PERCENT: '6',
  COURT_EXPUNGE_DON_ALDERMAN_PERCENT: '5',
  COURT_EXPUNGE_COOLDOWN_SECONDS: '43200',
  /** Hours after last arrest that still apply the heavy fresh-arrest penalty (−15%). */
  COURT_EXPUNGE_FRESH_ARREST_HOURS: '1',

  // Appeal odds (base + law education; Don judge bonus shares DON_JUDGE key)
  COURT_APPEAL_BASE_PERCENT: '35',
  COURT_APPEAL_LAW_BONUS_PER_LEVEL_PERCENT: '5',
  COURT_APPEAL_LAW_BONUS_CAP_PERCENT: '25',
  COURT_APPEAL_WANTED_THRESHOLD: '20',
  COURT_APPEAL_WANTED_PENALTY_PERCENT: '10',
  COURT_APPEAL_FBI_THRESHOLD: '10',
  COURT_APPEAL_FBI_PENALTY_PERCENT: '15',
  COURT_APPEAL_MIN_PERCENT: '10',
  COURT_APPEAL_MAX_PERCENT: '85',
  COURT_APPEAL_COST_PER_MINUTE: '100',
  COURT_APPEAL_COST_MIN: '2000',
  COURT_APPEAL_COST_MAX: '50000',

  /** Same key as Don runtime — judge patronage bonus on appeal (capped in computeAppealOdds). */
  DON_JUDGE_APPEAL_BONUS_PERCENT: '8',
};

export const COURT_RUNTIME_SETTING_KEYS = Object.keys(COURT_RUNTIME_SETTING_DEFAULTS);

export type CourtRuntimeConfig = {
  expungeBaseCost: number;
  expungeCostPerExtra: number;
  expungeBasePercent: number;
  expungeMinPercent: number;
  expungeMaxPercent: number;
  expungeDonJudgePercent: number;
  expungeDonCommissionerPercent: number;
  expungeDonAldermanPercent: number;
  expungeCooldownSeconds: number;
  expungeFreshArrestHours: number;
  appealBasePercent: number;
  appealLawBonusPerLevelPercent: number;
  appealLawBonusCapPercent: number;
  appealWantedThreshold: number;
  appealWantedPenaltyPercent: number;
  appealFbiThreshold: number;
  appealFbiPenaltyPercent: number;
  appealMinPercent: number;
  appealMaxPercent: number;
  appealCostPerMinute: number;
  appealCostMin: number;
  appealCostMax: number;
  donJudgeAppealBonusPercent: number;
};

let cache: { value: CourtRuntimeConfig; expiresAt: number } | null = null;
const TTL_MS = 30_000;

function parseIntSafe(value: string | undefined, fallback: number): number {
  const n = Number.parseInt(String(value ?? ''), 10);
  return Number.isFinite(n) ? n : fallback;
}

function build(map: Record<string, string>): CourtRuntimeConfig {
  const d = COURT_RUNTIME_SETTING_DEFAULTS;
  const read = (key: string, fallback: number) =>
    parseIntSafe(map[key] ?? d[key], fallback);

  return {
    expungeBaseCost: Math.max(0, read('COURT_EXPUNGE_BASE_COST', 100_000)),
    expungeCostPerExtra: Math.max(0, read('COURT_EXPUNGE_COST_PER_EXTRA', 1_000)),
    expungeBasePercent: Math.max(0, read('COURT_EXPUNGE_BASE_PERCENT', 38)),
    expungeMinPercent: Math.max(0, read('COURT_EXPUNGE_MIN_PERCENT', 8)),
    expungeMaxPercent: Math.max(1, read('COURT_EXPUNGE_MAX_PERCENT', 70)),
    expungeDonJudgePercent: Math.max(0, read('COURT_EXPUNGE_DON_JUDGE_PERCENT', 8)),
    expungeDonCommissionerPercent: Math.max(
      0,
      read('COURT_EXPUNGE_DON_COMMISSIONER_PERCENT', 6),
    ),
    expungeDonAldermanPercent: Math.max(0, read('COURT_EXPUNGE_DON_ALDERMAN_PERCENT', 5)),
    expungeCooldownSeconds: Math.max(60, read('COURT_EXPUNGE_COOLDOWN_SECONDS', 43_200)),
    expungeFreshArrestHours: Math.max(0, read('COURT_EXPUNGE_FRESH_ARREST_HOURS', 1)),
    appealBasePercent: Math.max(0, read('COURT_APPEAL_BASE_PERCENT', 35)),
    appealLawBonusPerLevelPercent: Math.max(
      0,
      read('COURT_APPEAL_LAW_BONUS_PER_LEVEL_PERCENT', 5),
    ),
    appealLawBonusCapPercent: Math.max(0, read('COURT_APPEAL_LAW_BONUS_CAP_PERCENT', 25)),
    appealWantedThreshold: Math.max(0, read('COURT_APPEAL_WANTED_THRESHOLD', 20)),
    appealWantedPenaltyPercent: Math.max(0, read('COURT_APPEAL_WANTED_PENALTY_PERCENT', 10)),
    appealFbiThreshold: Math.max(0, read('COURT_APPEAL_FBI_THRESHOLD', 10)),
    appealFbiPenaltyPercent: Math.max(0, read('COURT_APPEAL_FBI_PENALTY_PERCENT', 15)),
    appealMinPercent: Math.max(0, read('COURT_APPEAL_MIN_PERCENT', 10)),
    appealMaxPercent: Math.max(1, read('COURT_APPEAL_MAX_PERCENT', 85)),
    appealCostPerMinute: Math.max(0, read('COURT_APPEAL_COST_PER_MINUTE', 100)),
    appealCostMin: Math.max(0, read('COURT_APPEAL_COST_MIN', 2_000)),
    appealCostMax: Math.max(0, read('COURT_APPEAL_COST_MAX', 50_000)),
    donJudgeAppealBonusPercent: Math.max(0, read('DON_JUDGE_APPEAL_BONUS_PERCENT', 8)),
  };
}

export function invalidateCourtRuntimeConfigCache(): void {
  cache = null;
}

export async function getCourtRuntimeConfig(): Promise<CourtRuntimeConfig> {
  const now = Date.now();
  if (cache && cache.expiresAt > now) {
    return cache.value;
  }

  const map: Record<string, string> = { ...COURT_RUNTIME_SETTING_DEFAULTS };
  try {
    const placeholders = COURT_RUNTIME_SETTING_KEYS.map(() => '?').join(', ');
    const rows = await prisma.$queryRawUnsafe<
      Array<{ configKey: string; configValue: string }>
    >(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...COURT_RUNTIME_SETTING_KEYS,
    );
    for (const row of rows) {
      map[row.configKey] = String(row.configValue ?? map[row.configKey] ?? '');
    }
  } catch {
    // table missing → defaults
  }

  const value = build(map);
  cache = { value, expiresAt: now + TTL_MS };
  return value;
}

export async function getCourtRuntimeConfigView() {
  const keys = COURT_RUNTIME_SETTING_KEYS;
  const placeholders = keys.map(() => '?').join(', ');
  const rows = await prisma
    .$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
      `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
      ...keys,
    )
    .catch(() => [] as Array<{ configKey: string; configValue: string }>);

  const values: Record<string, string> = { ...COURT_RUNTIME_SETTING_DEFAULTS };
  for (const row of rows) {
    values[row.configKey] = String(row.configValue ?? values[row.configKey] ?? '');
  }
  return {
    defaults: COURT_RUNTIME_SETTING_DEFAULTS,
    values,
    keys,
  };
}

export async function updateCourtRuntimeConfig(
  updates: Record<string, string | number>,
) {
  const normalized: Record<string, string> = {};
  for (const [key, value] of Object.entries(updates)) {
    if (!COURT_RUNTIME_SETTING_KEYS.includes(key)) {
      throw new Error(`INVALID_RUNTIME_KEY:${key}`);
    }
    const asString = String(value ?? '').trim();
    const asNumber = Number(asString);
    if (!Number.isFinite(asNumber)) {
      throw new Error(`RUNTIME_VALUE_NOT_NUMERIC:${key}`);
    }
    normalized[key] = asString;
  }

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
  invalidateCourtRuntimeConfigCache();
  return getCourtRuntimeConfigView();
}

/** Map live court runtime into expungePetitionMath overrides. */
export function getExpungePetitionMathConfigFromCourt(court: CourtRuntimeConfig) {
  return {
    baseCost: court.expungeBaseCost,
    costPerExtra: court.expungeCostPerExtra,
    basePercent: court.expungeBasePercent,
    minPercent: court.expungeMinPercent,
    maxPercent: court.expungeMaxPercent,
    donJudgePercent: court.expungeDonJudgePercent,
    donCommissionerPercent: court.expungeDonCommissionerPercent,
    donAldermanPercent: court.expungeDonAldermanPercent,
    freshArrestHours: court.expungeFreshArrestHours,
  };
}
