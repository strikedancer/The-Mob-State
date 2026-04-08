import { Router, Request, Response } from 'express';
import { timeProvider } from '../utils/timeProvider';
import prisma from '../lib/prisma';
import { isRedisConnected } from '../services/redisClient';
import { queueService } from '../queues/queueService';
import { getCronStatus } from '../services/cronService';

const router = Router();

router.get('/', (_req: Request, res: Response) => {
  res.json({
    status: 'ok',
    timestamp: timeProvider.now().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
  });
});

router.get('/details', async (_req: Request, res: Response) => {
  const startedAt = Date.now();

  let databaseOk = false;
  let databaseError: string | null = null;
  try {
    await prisma.$queryRawUnsafe('SELECT 1');
    databaseOk = true;
  } catch (error) {
    databaseError = error instanceof Error ? error.message : 'Database check failed';
  }

  const redisOk = isRedisConnected();
  const queueOk = queueService.isAvailable();
  const cron = getCronStatus();
  const cronLastExecutions = Object.values(cron.lastExecutions || {});
  const cronRecentExecution = cronLastExecutions.some((value: any) => {
    const asDate = value instanceof Date ? value : new Date(value);
    return !Number.isNaN(asDate.getTime()) && Date.now() - asDate.getTime() <= 15 * 60 * 1000;
  });

  const components = {
    api: { status: 'ok' as const },
    database: {
      status: databaseOk ? ('ok' as const) : ('down' as const),
      error: databaseError,
    },
    redis: {
      status: redisOk ? ('ok' as const) : ('degraded' as const),
    },
    queue: {
      status: queueOk ? ('ok' as const) : ('degraded' as const),
    },
    cron: {
      status: cronRecentExecution ? ('ok' as const) : ('degraded' as const),
      jobs: cron.jobs,
      lastExecutions: cron.lastExecutions,
    },
  };

  const overall = databaseOk ? (redisOk && queueOk && cronRecentExecution ? 'ok' : 'degraded') : 'down';

  return res.json({
    status: overall,
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    environment: process.env.NODE_ENV || 'development',
    responseTimeMs: Date.now() - startedAt,
    components,
  });
});

export default router;
