import { PrismaClient } from '@prisma/client';
import cron from 'node-cron';
import { processOpenOrdersInBackground } from './cryptoService';
import { gameEventService } from './gameEventService';

const prisma = new PrismaClient();

/**
 * Cron Service - Automated background tasks for prostitution system
 * 
 * Jobs:
 * 1. Expire VIP Events - Every 5 minutes
 * 2. Update Leaderboards - Daily at midnight
 * 3. Reset Weekly Leaderboard - Monday at 00:00
 * 4. Cleanup Inactive Rivalries - Weekly on Sundays at 03:00
 */

// Track job execution for debugging
let lastJobExecutions: Record<string, Date> = {};

/**
 * Check and end expired VIP events
 * Runs every 5 minutes
 */
export async function checkExpiredEvents(): Promise<void> {
  const now = new Date();
  
  try {
    // Find events that have ended but are not marked as expired
    const expiredEvents = await prisma.vipEvent.findMany({
      where: {
        endTime: { lt: now },
        // We'll check if there are active participations to determine if still "active"
      },
      include: {
        participations: {
          where: {
            status: 'active', // Still in event
          },
        },
      },
    });

    if (expiredEvents.length === 0) {
      console.log('[CRON] No expired events found');
      lastJobExecutions['expiredEvents'] = now;
      return;
    }

    // End all active participations for expired events
    for (const event of expiredEvents) {
      if (event.participations.length > 0) {
        await prisma.eventParticipation.updateMany({
          where: {
            eventId: event.id,
            status: 'active',
          },
          data: {
            status: 'completed',
            completedAt: now,
          },
        });

        console.log(
          `[CRON] Expired event ${event.id} (${event.title}) - ended ${event.participations.length} participations`
        );
      }
    }

    console.log(`[CRON] Processed ${expiredEvents.length} expired events`);
    lastJobExecutions['expiredEvents'] = now;
  } catch (error) {
    console.error('[CRON ERROR] checkExpiredEvents:', error);
  }
}

/**
 * Update all player leaderboard rankings
 * Runs daily at midnight
 */
export async function updateLeaderboards(): Promise<void> {
  const now = new Date();
  
  try {
    // Get all players who have prostitution activity
    const players = await prisma.player.findMany({
      where: {
        prostitutes: {
          some: {}, // Has at least one prostitute
        },
      },
      include: {
        prostitutes: {
          select: { level: true },
        },
        ownedRedLightDistricts: true,
      },
    });

    if (players.length === 0) {
      console.log('[CRON] No active prostitution players found');
      lastJobExecutions['updateLeaderboards'] = now;
      return;
    }

    // Update stats for all three periods
    const periods: ('weekly' | 'monthly' | 'all_time')[] = ['weekly', 'monthly', 'all_time'];

    for (const period of periods) {
      const periodStart = getPeriodStart(period);

      for (const player of players) {
        const highestLevel =
          player.prostitutes.length > 0
            ? Math.max(...player.prostitutes.map((p: any) => p.level))
            : 1;

        await prisma.prostitutionLeaderboard.upsert({
          where: {
            playerId_period_periodStart: {
              playerId: player.id,
              period,
              periodStart,
            },
          },
          update: {
            totalEarnings: player.money,
            totalProstitutes: player.prostitutes.length,
            totalDistricts: player.ownedRedLightDistricts.length,
            highestLevel,
          },
          create: {
            playerId: player.id,
            period,
            periodStart,
            totalEarnings: player.money,
            totalProstitutes: player.prostitutes.length,
            totalDistricts: player.ownedRedLightDistricts.length,
            highestLevel,
          },
        });
      }
    }

    console.log(`[CRON] Updated leaderboards for ${players.length} players across all periods`);
    lastJobExecutions['updateLeaderboards'] = now;
  } catch (error) {
    console.error('[CRON ERROR] updateLeaderboards:', error);
  }
}

/**
 * Reset weekly leaderboard (archive old week, start new)
 * Runs every Monday at 00:00
 */
export async function resetWeeklyLeaderboard(): Promise<void> {
  const now = new Date();
  
  try {
    // Get last Monday
    const lastMonday = getPreviousMonday();
    
    // Archive last week's rankings
    const lastWeekEntries = await prisma.prostitutionLeaderboard.findMany({
      where: {
        period: 'weekly',
        periodStart: lastMonday,
      },
      orderBy: {
        totalEarnings: 'desc',
      },
    });

    // Update rank positions for archived entries
    for (let i = 0; i < lastWeekEntries.length; i++) {
      await prisma.prostitutionLeaderboard.update({
        where: { id: lastWeekEntries[i].id },
        data: { rankPosition: i + 1 },
      });
    }

    console.log(`[CRON] Archived weekly leaderboard: ${lastWeekEntries.length} entries with ranks`);

    // Create new weekly entries for all active players (will be populated by daily update)
    const thisMonday = getPeriodStart('weekly');

    console.log(`[CRON] Weekly leaderboard reset complete. New period starts: ${thisMonday.toISOString()}`);
    lastJobExecutions['resetWeeklyLeaderboard'] = now;
  } catch (error) {
    console.error('[CRON ERROR] resetWeeklyLeaderboard:', error);
  }
}

/**
 * Cleanup inactive rivalries (30+ days with no attacks)
 * Runs weekly on Sundays at 03:00
 */
export async function cleanupOldRivalries(): Promise<void> {
  const now = new Date();
  const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);
  
  try {
    // Find rivalries with no recent activity
    const inactiveRivalries = await prisma.prostitutionRivalry.findMany({
      where: {
        OR: [
          { lastAttackAt: { lt: thirtyDaysAgo } },
          { lastAttackAt: null, startedAt: { lt: thirtyDaysAgo } }, // Never attacked
        ],
      },
      include: {
        player: { select: { username: true } },
        rivalPlayer: { select: { username: true } },
      },
    });

    if (inactiveRivalries.length === 0) {
      console.log('[CRON] No inactive rivalries found');
      lastJobExecutions['cleanupRivalries'] = now;
      return;
    }

    // Delete inactive rivalries
    const rivalryIds = inactiveRivalries.map((r: any) => r.id);
    await prisma.prostitutionRivalry.deleteMany({
      where: {
        id: { in: rivalryIds },
      },
    });

    console.log(
      `[CRON] Cleaned up ${inactiveRivalries.length} inactive rivalries (30+ days no activity)`
    );
    lastJobExecutions['cleanupRivalries'] = now;
  } catch (error) {
    console.error('[CRON ERROR] cleanupOldRivalries:', error);
  }
}

/**
 * Helper: Get period start date
 */
function getPeriodStart(period: 'weekly' | 'monthly' | 'all_time'): Date {
  const now = new Date();

  if (period === 'all_time') {
    return new Date('1970-01-01');
  }

  if (period === 'monthly') {
    return new Date(now.getFullYear(), now.getMonth(), 1, 0, 0, 0, 0);
  }

  // Weekly: get this Monday
  const day = now.getDay();
  const diffToMonday = day === 0 ? 6 : day - 1;
  const monday = new Date(now);
  monday.setDate(now.getDate() - diffToMonday);
  monday.setHours(0, 0, 0, 0);
  return monday;
}

/**
 * Helper: Get previous Monday
 */
function getPreviousMonday(): Date {
  const thisMonday = getPeriodStart('weekly');
  const lastMonday = new Date(thisMonday);
  lastMonday.setDate(thisMonday.getDate() - 7);
  return lastMonday;
}


export async function runEventScheduler(): Promise<void> {
  const now = new Date();
  try {
    await gameEventService.resolveExpiredEvents();

    const schedules = await prisma.gameEventSchedule.findMany({
      where: {
        enabled: true,
        scheduleType: 'interval',
        template: { isActive: true },
      },
      include: { template: true },
    });

    for (const schedule of schedules) {
      if (!schedule.intervalMinutes) continue;

      const intervalMs = schedule.intervalMinutes * 60 * 1000;
      const cooldownMs = (schedule.cooldownMinutes ?? 0) * 60 * 1000;
      const durationMs = (schedule.durationMinutes ?? 60) * 60 * 1000;

      if (schedule.lastTriggeredAt) {
        const nextAllowedAt = new Date(
          schedule.lastTriggeredAt.getTime() + Math.max(intervalMs, cooldownMs),
        );
        if (now < nextAllowedAt) continue;
      }

      const existingActive = await prisma.gameLiveEvent.findFirst({
        where: {
          templateId: schedule.templateId,
          status: { in: ['active', 'scheduled'] },
        },
      });
      if (existingActive) continue;

      const endsAt = new Date(now.getTime() + durationMs);
      await gameEventService.createLiveEvent({
        templateId: schedule.templateId,
        status: 'active',
        startedAt: now,
        endsAt,
      });

      await prisma.gameEventSchedule.update({
        where: { id: schedule.id },
        data: { lastTriggeredAt: now },
      });

      console.log(
        `[EventScheduler] Auto-started event for template "${schedule.template.key}", ends ${endsAt.toISOString()}`,
      );
    }

    lastJobExecutions['eventScheduler'] = now;
  } catch (err) {
    console.error('[CRON ERROR] runEventScheduler:', err);
  }
}

export function getCronStatus() {
  return {
    lastExecutions: lastJobExecutions,
    jobs: {
      expiredEvents: 'Every 5 minutes',
      updateLeaderboards: 'Daily at 00:00',
      resetWeeklyLeaderboard: 'Monday at 00:00',
      cleanupRivalries: 'Sunday at 03:00',
      cryptoOrderProcessor: 'Every 30 seconds',
      eventScheduler: 'Every 5 minutes',
    },
  };
}

export function initializeCronJobs(): void {
  console.log('[CRON] Initializing scheduled jobs...');

  cron.schedule('*/5 * * * *', async () => {
    console.log('[CRON JOB] Running: checkExpiredEvents');
    await checkExpiredEvents();
  });

  cron.schedule('0 0 * * *', async () => {
    console.log('[CRON JOB] Running: updateLeaderboards');
    await updateLeaderboards();
  });

  cron.schedule('0 0 * * 1', async () => {
    console.log('[CRON JOB] Running: resetWeeklyLeaderboard');
    await resetWeeklyLeaderboard();
  });

  cron.schedule('0 3 * * 0', async () => {
    console.log('[CRON JOB] Running: cleanupOldRivalries');
    await cleanupOldRivalries();
  });

  cron.schedule('*/30 * * * * *', async () => {
    try {
      const result = await processOpenOrdersInBackground();
      if (result.processed > 0 || result.remainingOpen > 0) {
        console.log(
          `[CRON JOB] cryptoOrderProcessor processed=${result.processed} filled=${result.filled} failed=${result.failed} remainingOpen=${result.remainingOpen}`
        );
      }
      lastJobExecutions['cryptoOrderProcessor'] = new Date();
    } catch (error) {
      console.error('[CRON ERROR] cryptoOrderProcessor:', error);
    }
  });

  cron.schedule('*/5 * * * *', async () => {
    console.log('[CRON JOB] Running: runEventScheduler');
    await runEventScheduler();
  });

  console.log('[CRON] All scheduled jobs initialized successfully');
  console.log('[CRON] Schedule:');
  console.log('  - Expire VIP Events: Every 5 minutes');
  console.log('  - Update Leaderboards: Daily at 00:00');
  console.log('  - Reset Weekly Leaderboard: Monday at 00:00');
  console.log('  - Cleanup Old Rivalries: Sunday at 03:00');
  console.log('  - Crypto Order Processor: Every 30 seconds');
  console.log('  - Game Event Scheduler: Every 5 minutes');
}
