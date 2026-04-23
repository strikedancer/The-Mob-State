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

const SESSION_WINDOW_MINUTES = Number.parseInt(
  process.env.ECON_SESSION_WINDOW_MINUTES || '60',
  10,
);

const DIMINISHING_CURVE = [
  { minAttempts: 0, multiplier: 1.0 },
  { minAttempts: 8, multiplier: 0.96 },
  { minAttempts: 16, multiplier: 0.9 },
  { minAttempts: 26, multiplier: 0.84 },
  { minAttempts: 40, multiplier: 0.78 },
] as const;

const VEHICLE_THEFT_COOLDOWN_SECONDS_BY_TYPE: Record<string, number> = {
  car: 300,
  motorcycle: 240,
  boat: 600,
};

type CrimeDefinition = {
  id: string;
  maxReward: number;
};

type JobDefinition = {
  id: string;
  maxEarnings: number;
};

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

const resolveDiminishingMultiplier = (attemptCount: number): number => {
  let multiplier = 1;
  for (const step of DIMINISHING_CURVE) {
    if (attemptCount >= step.minAttempts) {
      multiplier = step.multiplier;
    }
  }
  return multiplier;
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

async function getRecentActionCount(
  playerId: number,
  actionType: SessionActionType,
  sessionWindowMinutes: number = SESSION_WINDOW_MINUTES,
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
    sessionWindowMinutes: number = SESSION_WINDOW_MINUTES,
  ): Promise<{
    attemptsInWindow: number;
    sessionWindowMinutes: number;
    multiplier: number;
  }> {
    const attemptsInWindow = await getRecentActionCount(
      playerId,
      actionType,
      sessionWindowMinutes,
    );

    return {
      attemptsInWindow,
      sessionWindowMinutes,
      multiplier: resolveDiminishingMultiplier(attemptsInWindow),
    };
  },

  applySoftDiminishing(rawAmount: number, multiplier: number, minimumValue = 0): number {
    const normalized = Math.max(0, Math.floor(rawAmount * multiplier));
    if (rawAmount <= 0) return 0;
    return Math.max(minimumValue, normalized);
  },

  getDiminishingCurve() {
    return DIMINISHING_CURVE.map((step) => ({
      minAttempts: step.minAttempts,
      multiplier: step.multiplier,
    }));
  },

  getSessionWindowMinutes() {
    return SESSION_WINDOW_MINUTES;
  },

  async getTelemetry(windowHours: number = 24) {
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
        sessionWindowMinutes: SESSION_WINDOW_MINUTES,
        curve: this.getDiminishingCurve(),
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
