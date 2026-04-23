import prisma from '../lib/prisma';
import { calculateCrimeCooldown, calculateJobCooldown } from './cooldownService';
import crimesData from '../../content/crimes.json';
import jobsData from '../../content/jobs.json';

type SessionActionType = 'crime' | 'job' | 'vehicle_theft';

type RatioBucket = {
  attempts: number;
  successes: number;
  failures: number;
  jailed: number;
  payout: number;
  xp: number;
  cooldownSeconds: number;
};

type CooldownSkipStats = {
  total: number;
  byActionType: Record<string, number>;
};

type DiminishingStep = {
  minAttempts: number;
  multiplier: number;
};

type RuntimeBalanceConfig = {
  sessionWindowMinutes: number;
  curve: DiminishingStep[];
};

type CrimeDefinition = {
  id: string;
  maxReward: number;
};

type JobDefinition = {
  id: string;
  maxEarnings: number;
};

export const ECON_RUNTIME_SETTING_DEFAULTS = {
  ECON_SESSION_WINDOW_MINUTES: process.env.ECON_SESSION_WINDOW_MINUTES || '60',
  ECON_DIMINISH_1_MIN_ATTEMPTS: process.env.ECON_DIMINISH_1_MIN_ATTEMPTS || '8',
  ECON_DIMINISH_1_MULTIPLIER: process.env.ECON_DIMINISH_1_MULTIPLIER || '0.96',
  ECON_DIMINISH_2_MIN_ATTEMPTS: process.env.ECON_DIMINISH_2_MIN_ATTEMPTS || '16',
  ECON_DIMINISH_2_MULTIPLIER: process.env.ECON_DIMINISH_2_MULTIPLIER || '0.90',
  ECON_DIMINISH_3_MIN_ATTEMPTS: process.env.ECON_DIMINISH_3_MIN_ATTEMPTS || '26',
  ECON_DIMINISH_3_MULTIPLIER: process.env.ECON_DIMINISH_3_MULTIPLIER || '0.84',
  ECON_DIMINISH_4_MIN_ATTEMPTS: process.env.ECON_DIMINISH_4_MIN_ATTEMPTS || '40',
  ECON_DIMINISH_4_MULTIPLIER: process.env.ECON_DIMINISH_4_MULTIPLIER || '0.78',
} as const;

export const ECON_RUNTIME_SETTING_KEYS = Object.keys(ECON_RUNTIME_SETTING_DEFAULTS);

const VEHICLE_THEFT_COOLDOWN_SECONDS_BY_TYPE: Record<string, number> = {
  car: 300,
  motorcycle: 240,
  boat: 600,
};

const RUNTIME_CONFIG_CACHE_TTL_MS = 60_000;
let runtimeConfigCache: { value: RuntimeBalanceConfig; expiresAt: number } | null = null;

const toSafeNumber = (value: unknown): number => {
  const numeric = Number(value);
  return Number.isFinite(numeric) ? numeric : 0;
};

const parseDetailsObject = (value: string | null): Record<string, unknown> => {
  if (!value) return {};
  try {
    const parsed = JSON.parse(value);
    if (parsed && typeof parsed === 'object') {
      return parsed as Record<string, unknown>;
    }
  } catch {
    return {};
  }
  return {};
};

const getSessionWindowStart = (minutes: number): Date => {
  const now = Date.now();
  return new Date(now - minutes * 60_000);
};

const toRatioSummary = (bucket: RatioBucket) => {
  const attempts = bucket.attempts;
  const cooldownMinutes = bucket.cooldownSeconds > 0 ? bucket.cooldownSeconds / 60 : 0;

  return {
    attempts,
    successes: bucket.successes,
    failures: bucket.failures,
    jailed: bucket.jailed,
    successRate: attempts > 0 ? Number((bucket.successes / attempts).toFixed(4)) : 0,
    failRate: attempts > 0 ? Number((bucket.failures / attempts).toFixed(4)) : 0,
    jailRate: attempts > 0 ? Number((bucket.jailed / attempts).toFixed(4)) : 0,
    payoutPerMinute:
      cooldownMinutes > 0 ? Number((bucket.payout / cooldownMinutes).toFixed(2)) : 0,
    xpPerMinute: cooldownMinutes > 0 ? Number((bucket.xp / cooldownMinutes).toFixed(2)) : 0,
    averageCooldownSeconds:
      attempts > 0 ? Number((bucket.cooldownSeconds / attempts).toFixed(1)) : 0,
    totalPayout: bucket.payout,
    totalXp: bucket.xp,
  };
};

const parseRuntimeInteger = (
  raw: string | undefined,
  fallback: number,
  min: number,
  max: number,
): number => {
  const parsed = Number.parseInt(String(raw ?? ''), 10);
  if (!Number.isFinite(parsed)) return fallback;
  return Math.min(max, Math.max(min, parsed));
};

const parseRuntimeMultiplier = (raw: string | undefined, fallback: number): number => {
  const parsed = Number.parseFloat(String(raw ?? ''));
  if (!Number.isFinite(parsed)) return fallback;
  return Math.min(1, Math.max(0.4, parsed));
};

const buildRuntimeConfig = (source: Record<string, string>): RuntimeBalanceConfig => {
  const sessionWindowMinutes = parseRuntimeInteger(
    source.ECON_SESSION_WINDOW_MINUTES,
    Number.parseInt(ECON_RUNTIME_SETTING_DEFAULTS.ECON_SESSION_WINDOW_MINUTES, 10),
    15,
    240,
  );

  const steps: DiminishingStep[] = [
    { minAttempts: 0, multiplier: 1 },
    {
      minAttempts: parseRuntimeInteger(
        source.ECON_DIMINISH_1_MIN_ATTEMPTS,
        Number.parseInt(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_1_MIN_ATTEMPTS, 10),
        1,
        500,
      ),
      multiplier: parseRuntimeMultiplier(
        source.ECON_DIMINISH_1_MULTIPLIER,
        Number.parseFloat(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_1_MULTIPLIER),
      ),
    },
    {
      minAttempts: parseRuntimeInteger(
        source.ECON_DIMINISH_2_MIN_ATTEMPTS,
        Number.parseInt(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_2_MIN_ATTEMPTS, 10),
        1,
        500,
      ),
      multiplier: parseRuntimeMultiplier(
        source.ECON_DIMINISH_2_MULTIPLIER,
        Number.parseFloat(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_2_MULTIPLIER),
      ),
    },
    {
      minAttempts: parseRuntimeInteger(
        source.ECON_DIMINISH_3_MIN_ATTEMPTS,
        Number.parseInt(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_3_MIN_ATTEMPTS, 10),
        1,
        500,
      ),
      multiplier: parseRuntimeMultiplier(
        source.ECON_DIMINISH_3_MULTIPLIER,
        Number.parseFloat(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_3_MULTIPLIER),
      ),
    },
    {
      minAttempts: parseRuntimeInteger(
        source.ECON_DIMINISH_4_MIN_ATTEMPTS,
        Number.parseInt(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_4_MIN_ATTEMPTS, 10),
        1,
        500,
      ),
      multiplier: parseRuntimeMultiplier(
        source.ECON_DIMINISH_4_MULTIPLIER,
        Number.parseFloat(ECON_RUNTIME_SETTING_DEFAULTS.ECON_DIMINISH_4_MULTIPLIER),
      ),
    },
  ];

  steps.sort((a, b) => a.minAttempts - b.minAttempts);
  let previousThreshold = 0;
  let previousMultiplier = 1;

  for (let i = 1; i < steps.length; i += 1) {
    const step = steps[i];
    if (step.minAttempts <= previousThreshold) {
      step.minAttempts = previousThreshold + 1;
    }
    if (step.multiplier > previousMultiplier) {
      step.multiplier = previousMultiplier;
    }
    previousThreshold = step.minAttempts;
    previousMultiplier = step.multiplier;
  }

  return { sessionWindowMinutes, curve: steps };
};

const loadRuntimeConfigValues = async (): Promise<Record<string, string>> => {
  const placeholders = ECON_RUNTIME_SETTING_KEYS.map(() => '?').join(', ');
  const rows = await prisma.$queryRawUnsafe<Array<{ configKey: string; configValue: string }>>(
    `SELECT configKey, configValue FROM runtime_config WHERE configKey IN (${placeholders})`,
    ...ECON_RUNTIME_SETTING_KEYS,
  );

  const merged: Record<string, string> = {
    ...ECON_RUNTIME_SETTING_DEFAULTS,
  };
  for (const row of rows) {
    merged[row.configKey] = String(row.configValue ?? '').trim();
  }
  return merged;
};

const getRuntimeBalanceConfig = async (): Promise<RuntimeBalanceConfig> => {
  const now = Date.now();
  if (runtimeConfigCache && runtimeConfigCache.expiresAt > now) {
    return runtimeConfigCache.value;
  }

  try {
    const values = await loadRuntimeConfigValues();
    const value = buildRuntimeConfig(values);
    runtimeConfigCache = { value, expiresAt: now + RUNTIME_CONFIG_CACHE_TTL_MS };
    return value;
  } catch {
    const fallback = buildRuntimeConfig({ ...ECON_RUNTIME_SETTING_DEFAULTS });
    runtimeConfigCache = { value: fallback, expiresAt: now + RUNTIME_CONFIG_CACHE_TTL_MS };
    return fallback;
  }
};

const resolveDiminishingMultiplier = (attemptCount: number, curve: DiminishingStep[]): number => {
  let multiplier = 1;
  for (const step of curve) {
    if (attemptCount >= step.minAttempts) {
      multiplier = step.multiplier;
    }
  }
  return multiplier;
};

async function getRecentActionCount(
  playerId: number,
  actionType: SessionActionType,
  sessionWindowMinutes: number,
): Promise<number> {
  const from = getSessionWindowStart(sessionWindowMinutes);

  if (actionType === 'crime') {
    return prisma.crimeAttempt.count({
      where: {
        playerId,
        createdAt: { gte: from },
        NOT: { crimeId: 'police_arrest' },
      },
    });
  }

  if (actionType === 'job') {
    return prisma.jobAttempt.count({
      where: {
        playerId,
        completedAt: { gte: from },
      },
    });
  }

  return prisma.playerActivity.count({
    where: {
      playerId,
      activityType: 'VEHICLE_THEFT',
      createdAt: { gte: from },
    },
  });
}

async function getCooldownSkipUsage(from: Date): Promise<CooldownSkipStats> {
  const redemptions = await prisma.playerCreditTransaction.findMany({
    where: {
      reasonType: 'REDEEM',
      createdAt: { gte: from },
    },
    select: {
      reasonKey: true,
      metadataJson: true,
    },
  });

  const byActionType: Record<string, number> = {};
  let total = 0;

  for (const redemption of redemptions) {
    const details = parseDetailsObject(redemption.metadataJson);
    const effectType = String(details.effectType || '');
    const actionType = String(details.actionType || '');

    const isCooldownReset =
      redemption.reasonKey === 'crime_cooldown_reset' || effectType === 'ACTION_COOLDOWN_RESET';
    if (!isCooldownReset) {
      continue;
    }

    total += 1;
    const bucketKey = actionType || 'crime';
    byActionType[bucketKey] = (byActionType[bucketKey] ?? 0) + 1;
  }

  return { total, byActionType };
}

export const economyBalanceService = {
  async getDiminishingContext(
    playerId: number,
    actionType: SessionActionType,
  ): Promise<{
    attemptsInWindow: number;
    sessionWindowMinutes: number;
    multiplier: number;
  }> {
    const runtimeConfig = await getRuntimeBalanceConfig();
    const attemptsInWindow = await getRecentActionCount(
      playerId,
      actionType,
      runtimeConfig.sessionWindowMinutes,
    );

    return {
      attemptsInWindow,
      sessionWindowMinutes: runtimeConfig.sessionWindowMinutes,
      multiplier: resolveDiminishingMultiplier(attemptsInWindow, runtimeConfig.curve),
    };
  },

  applySoftDiminishing(rawAmount: number, multiplier: number, minimumValue = 0): number {
    const normalized = Math.max(0, Math.floor(rawAmount * multiplier));
    if (rawAmount <= 0) return 0;
    return Math.max(minimumValue, normalized);
  },

  async getDiminishingCurve(): Promise<DiminishingStep[]> {
    const runtimeConfig = await getRuntimeBalanceConfig();
    return runtimeConfig.curve.map((step) => ({
      minAttempts: step.minAttempts,
      multiplier: step.multiplier,
    }));
  },

  async getSessionWindowMinutes(): Promise<number> {
    const runtimeConfig = await getRuntimeBalanceConfig();
    return runtimeConfig.sessionWindowMinutes;
  },

  async getTelemetry(windowHours: number = 24) {
    const runtimeConfig = await getRuntimeBalanceConfig();
    const safeWindowHours = Math.min(168, Math.max(1, Math.floor(windowHours)));
    const from = new Date(Date.now() - safeWindowHours * 60 * 60 * 1000);

    const [crimeAttempts, jobAttempts, vehicleTheftActivities, cooldownSkips] = await Promise.all([
      prisma.crimeAttempt.findMany({
        where: {
          createdAt: { gte: from },
          NOT: { crimeId: 'police_arrest' },
        },
        select: {
          crimeId: true,
          success: true,
          jailed: true,
          reward: true,
          xpGained: true,
        },
      }),
      prisma.jobAttempt.findMany({
        where: {
          completedAt: { gte: from },
        },
        select: {
          jobId: true,
          earnings: true,
          xpGained: true,
        },
      }),
      prisma.playerActivity.findMany({
        where: {
          activityType: 'VEHICLE_THEFT',
          createdAt: { gte: from },
        },
        select: {
          details: true,
        },
      }),
      getCooldownSkipUsage(from),
    ]);

    const crimeById = new Map<string, CrimeDefinition>(
      (((crimesData as { crimes?: CrimeDefinition[] }).crimes ?? []) as CrimeDefinition[]).map(
        (crime) => [crime.id, crime],
      ),
    );
    const jobsById = new Map<string, JobDefinition>(
      ((jobsData as JobDefinition[]) ?? []).map((job) => [job.id, job]),
    );

    const crimeBucket: RatioBucket = {
      attempts: 0,
      successes: 0,
      failures: 0,
      jailed: 0,
      payout: 0,
      xp: 0,
      cooldownSeconds: 0,
    };

    for (const attempt of crimeAttempts) {
      const crimeDef = crimeById.get(attempt.crimeId);
      const cooldownSeconds = calculateCrimeCooldown(crimeDef?.maxReward ?? attempt.reward);

      crimeBucket.attempts += 1;
      crimeBucket.successes += attempt.success ? 1 : 0;
      crimeBucket.failures += attempt.success ? 0 : 1;
      crimeBucket.jailed += attempt.jailed ? 1 : 0;
      crimeBucket.payout += toSafeNumber(attempt.reward);
      crimeBucket.xp += toSafeNumber(attempt.xpGained);
      crimeBucket.cooldownSeconds += cooldownSeconds;
    }

    const jobBucket: RatioBucket = {
      attempts: 0,
      successes: 0,
      failures: 0,
      jailed: 0,
      payout: 0,
      xp: 0,
      cooldownSeconds: 0,
    };

    for (const attempt of jobAttempts) {
      const jobDef = jobsById.get(attempt.jobId);
      const cooldownSeconds = calculateJobCooldown(jobDef?.maxEarnings ?? attempt.earnings);
      const success = toSafeNumber(attempt.earnings) > 0;

      jobBucket.attempts += 1;
      jobBucket.successes += success ? 1 : 0;
      jobBucket.failures += success ? 0 : 1;
      jobBucket.payout += toSafeNumber(attempt.earnings);
      jobBucket.xp += toSafeNumber(attempt.xpGained);
      jobBucket.cooldownSeconds += cooldownSeconds;
    }

    const vehicleTheftBucket: RatioBucket = {
      attempts: 0,
      successes: 0,
      failures: 0,
      jailed: 0,
      payout: 0,
      xp: 0,
      cooldownSeconds: 0,
    };

    for (const activity of vehicleTheftActivities) {
      const details = parseDetailsObject(activity.details);
      const success = Boolean(details.success);
      const jailed = Boolean(details.arrested) || Boolean(details.arrestedAfterTheft);
      const vehicleType = String(details.vehicleType || 'car');
      const cooldownSeconds =
        VEHICLE_THEFT_COOLDOWN_SECONDS_BY_TYPE[vehicleType] ??
        VEHICLE_THEFT_COOLDOWN_SECONDS_BY_TYPE.car;

      vehicleTheftBucket.attempts += 1;
      vehicleTheftBucket.successes += success ? 1 : 0;
      vehicleTheftBucket.failures += success ? 0 : 1;
      vehicleTheftBucket.jailed += jailed ? 1 : 0;
      vehicleTheftBucket.xp += toSafeNumber(details.xpGained);
      vehicleTheftBucket.cooldownSeconds += cooldownSeconds;
    }

    return {
      generatedAt: new Date().toISOString(),
      windowHours: safeWindowHours,
      from: from.toISOString(),
      diminishing: {
        sessionWindowMinutes: runtimeConfig.sessionWindowMinutes,
        curve: runtimeConfig.curve.map((step) => ({
          minAttempts: step.minAttempts,
          multiplier: step.multiplier,
        })),
      },
      loops: {
        crimes: toRatioSummary(crimeBucket),
        jobs: toRatioSummary(jobBucket),
        vehicleTheft: toRatioSummary(vehicleTheftBucket),
      },
      cooldownSkips,
    };
  },
};

