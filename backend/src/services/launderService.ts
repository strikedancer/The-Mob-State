import prisma from '../lib/prisma';
import { activityService } from './activityService';
import { getOrCreateBankAccount } from './bankService';

export class LaunderBoundError extends Error {
  minAmount: number;
  maxAmount: number;

  constructor(code: 'LAUNDER_AMOUNT_TOO_LOW' | 'LAUNDER_AMOUNT_TOO_HIGH', minAmount: number, maxAmount: number) {
    super(code);
    this.name = 'LaunderBoundError';
    this.minAmount = minAmount;
    this.maxAmount = maxAmount;
  }
}

type LaunderConfig = {
  enabled: boolean;
  feePercent: number;
  minAmount: number;
  maxAmount: number;
  durationMinutes: number;
  cooldownSeconds: number;
  seizeChancePerHeat: number;
  heatReductionOnSuccess: number;
};

function toNumeric(value: unknown): number {
  const n = Number(value);
  return Number.isFinite(n) ? n : 0;
}

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

async function getLaunderConfig(): Promise<LaunderConfig> {
  const cfg = await getRuntimeConfig([
    'LAUNDER_ENABLED',
    'LAUNDER_FEE_PERCENT',
    'LAUNDER_MIN_AMOUNT',
    'LAUNDER_MAX_AMOUNT',
    'LAUNDER_DURATION_MINUTES',
    'LAUNDER_COOLDOWN_SECONDS',
    'LAUNDER_SEIZE_CHANCE_PER_HEAT',
    'LAUNDER_HEAT_REDUCTION_ON_SUCCESS',
  ]);
  return {
    enabled: Number(cfg.LAUNDER_ENABLED ?? 1) === 1,
    feePercent: Math.max(1, Number(cfg.LAUNDER_FEE_PERCENT ?? 12)),
    minAmount: Math.max(1, Math.floor(Number(cfg.LAUNDER_MIN_AMOUNT ?? 10000))),
    maxAmount: Math.max(1, Math.floor(Number(cfg.LAUNDER_MAX_AMOUNT ?? 5000000))),
    durationMinutes: Math.max(1, Math.floor(Number(cfg.LAUNDER_DURATION_MINUTES ?? 30))),
    cooldownSeconds: Math.max(0, Math.floor(Number(cfg.LAUNDER_COOLDOWN_SECONDS ?? 900))),
    seizeChancePerHeat: Math.max(0, Number(cfg.LAUNDER_SEIZE_CHANCE_PER_HEAT ?? 0.4)),
    heatReductionOnSuccess: Math.max(0, Math.floor(Number(cfg.LAUNDER_HEAT_REDUCTION_ON_SUCCESS ?? 2))),
  };
}

export async function processDueLaunderJobs(limit = 50): Promise<number> {
  const rows = await prisma.$queryRawUnsafe<Array<{
    id: number;
    playerId: number;
    amountOut: number;
    seizeChancePercent: number | string;
  }>>(
    `SELECT id, playerId, amountOut, seizeChancePercent
     FROM launder_jobs
     WHERE status = 'processing' AND completesAt <= NOW()
     ORDER BY completesAt ASC
     LIMIT ?`,
    Math.max(1, Math.min(200, limit)),
  );

  let processed = 0;
  const cfg = await getLaunderConfig();
  for (const row of rows) {
    const seizeRoll = Math.random() * 100;
    const seizeChance = Math.max(0, toNumeric(row.seizeChancePercent));
    if (seizeRoll < seizeChance) {
      await prisma.$executeRawUnsafe(
        `UPDATE launder_jobs
         SET status = 'seized', completedAt = NOW(), updatedAt = NOW(),
             metadataJson = ?
         WHERE id = ? AND status = 'processing'`,
        JSON.stringify({ reason: 'heat_seize', roll: Number(seizeRoll.toFixed(3)) }),
        row.id,
      );
      await activityService.logActivity(
        toNumeric(row.playerId),
        'launder.seized',
        'Money laundering job seized',
        { jobId: row.id, amountOut: row.amountOut, seizeChance },
        false,
      ).catch(() => {});
    } else {
      const account = await getOrCreateBankAccount(toNumeric(row.playerId));
      await prisma.$transaction(async (tx) => {
        const claim = await tx.$executeRawUnsafe(
          `UPDATE launder_jobs
           SET status = 'completed', completedAt = NOW(), updatedAt = NOW()
           WHERE id = ? AND status = 'processing'`,
          row.id,
        );
        if (toNumeric(claim) <= 0) return;
        await tx.bankAccount.update({
          where: { id: account.id },
          data: { balance: { increment: toNumeric(row.amountOut) } },
        });
        if (cfg.heatReductionOnSuccess > 0) {
          await tx.$executeRawUnsafe(
            `UPDATE players SET fbiHeat = GREATEST(0, fbiHeat - ?) WHERE id = ?`,
            cfg.heatReductionOnSuccess,
            toNumeric(row.playerId),
          );
        }
      });
      await activityService.logActivity(
        toNumeric(row.playerId),
        'launder.completed',
        'Money laundering job completed',
        { jobId: row.id, amountOut: row.amountOut },
        false,
      ).catch(() => {});
    }
    processed += 1;
  }
  return processed;
}

export async function getLaunderStatus(playerId: number) {
  await processDueLaunderJobs(20);
  const cfg = await getLaunderConfig();
  const [player, active, recent, lastCompleted] = await Promise.all([
    prisma.player.findUnique({
      where: { id: playerId },
      select: { money: true, fbiHeat: true, wantedLevel: true },
    }),
    prisma.$queryRawUnsafe<Array<Record<string, unknown>>>(
      `SELECT id, amountIn, feeAmount, amountOut, status, seizeChancePercent, startedAt, completesAt
       FROM launder_jobs
       WHERE playerId = ? AND status = 'processing'
       ORDER BY completesAt ASC
       LIMIT 1`,
      playerId,
    ),
    prisma.$queryRawUnsafe<Array<Record<string, unknown>>>(
      `SELECT id, amountIn, feeAmount, amountOut, status, startedAt, completesAt, completedAt
       FROM launder_jobs
       WHERE playerId = ?
       ORDER BY id DESC
       LIMIT 10`,
      playerId,
    ),
    prisma.$queryRawUnsafe<Array<{ completedAt: Date | null }>>(
      `SELECT completedAt FROM launder_jobs
       WHERE playerId = ? AND status IN ('completed', 'seized')
       ORDER BY completedAt DESC
       LIMIT 1`,
      playerId,
    ),
  ]);

  if (!player) throw new Error('PLAYER_NOT_FOUND');

  let cooldownSecondsRemaining = 0;
  const lastAt = lastCompleted[0]?.completedAt;
  if (lastAt && cfg.cooldownSeconds > 0) {
    const elapsed = Math.floor((Date.now() - new Date(lastAt).getTime()) / 1000);
    cooldownSecondsRemaining = Math.max(0, cfg.cooldownSeconds - elapsed);
  }

  const heat = toNumeric(player.fbiHeat);
  const estimatedSeizeChance = Math.min(75, Number((heat * cfg.seizeChancePerHeat).toFixed(2)));

  return {
    enabled: cfg.enabled,
    cash: toNumeric(player.money),
    fbiHeat: heat,
    wantedLevel: toNumeric(player.wantedLevel),
    config: {
      feePercent: cfg.feePercent,
      minAmount: cfg.minAmount,
      maxAmount: cfg.maxAmount,
      durationMinutes: cfg.durationMinutes,
      cooldownSeconds: cfg.cooldownSeconds,
      heatReductionOnSuccess: cfg.heatReductionOnSuccess,
    },
    estimatedSeizeChancePercent: estimatedSeizeChance,
    cooldownSecondsRemaining,
    activeJob: active[0]
      ? {
          id: toNumeric(active[0].id),
          amountIn: toNumeric(active[0].amountIn),
          feeAmount: toNumeric(active[0].feeAmount),
          amountOut: toNumeric(active[0].amountOut),
          status: String(active[0].status),
          seizeChancePercent: toNumeric(active[0].seizeChancePercent),
          startedAt: active[0].startedAt,
          completesAt: active[0].completesAt,
        }
      : null,
    recentJobs: recent.map((job) => ({
      id: toNumeric(job.id),
      amountIn: toNumeric(job.amountIn),
      feeAmount: toNumeric(job.feeAmount),
      amountOut: toNumeric(job.amountOut),
      status: String(job.status),
      startedAt: job.startedAt,
      completesAt: job.completesAt,
      completedAt: job.completedAt,
    })),
  };
}

export async function startLaunderJob(playerId: number, amountInput: number) {
  const cfg = await getLaunderConfig();
  if (!cfg.enabled) throw new Error('LAUNDER_DISABLED');

  const amount = Math.floor(Number(amountInput));
  if (!Number.isFinite(amount) || amount <= 0) throw new Error('INVALID_AMOUNT');
  if (amount < cfg.minAmount) {
    throw new LaunderBoundError('LAUNDER_AMOUNT_TOO_LOW', cfg.minAmount, cfg.maxAmount);
  }
  if (amount > cfg.maxAmount) {
    throw new LaunderBoundError('LAUNDER_AMOUNT_TOO_HIGH', cfg.minAmount, cfg.maxAmount);
  }

  await processDueLaunderJobs(20);
  const status = await getLaunderStatus(playerId);
  if (status.activeJob) throw new Error('LAUNDER_ALREADY_ACTIVE');
  if (status.cooldownSecondsRemaining > 0) throw new Error('LAUNDER_COOLDOWN');

  const player = await prisma.player.findUnique({
    where: { id: playerId },
    select: { money: true, fbiHeat: true },
  });
  if (!player) throw new Error('PLAYER_NOT_FOUND');
  if (toNumeric(player.money) < amount) throw new Error('INSUFFICIENT_CASH');

  const feeAmount = Math.max(1, Math.floor(amount * (cfg.feePercent / 100)));
  const amountOut = Math.max(0, amount - feeAmount);
  if (amountOut <= 0) throw new Error('INVALID_AMOUNT');

  const seizeChancePercent = Math.min(
    75,
    Number((toNumeric(player.fbiHeat) * cfg.seizeChancePerHeat).toFixed(3)),
  );
  const completesAt = new Date(Date.now() + cfg.durationMinutes * 60 * 1000);

  await prisma.$transaction(async (tx) => {
    const updated = await tx.player.updateMany({
      where: { id: playerId, money: { gte: amount } },
      data: { money: { decrement: amount } },
    });
    if (updated.count !== 1) throw new Error('INSUFFICIENT_CASH');

    await tx.$executeRawUnsafe(
      `INSERT INTO launder_jobs
         (playerId, amountIn, feeAmount, amountOut, status, seizeChancePercent, startedAt, completesAt)
       VALUES (?, ?, ?, ?, 'processing', ?, NOW(), ?)`,
      playerId,
      amount,
      feeAmount,
      amountOut,
      seizeChancePercent,
      completesAt,
    );
  });

  await activityService.logActivity(
    playerId,
    'launder.started',
    'Money laundering job started',
    { amountIn: amount, feeAmount, amountOut, seizeChancePercent },
    false,
  ).catch(() => {});

  return getLaunderStatus(playerId);
}
