/**
 * Tick Queue - Background job processor for game ticks
 * 
 * Offloads heavy tick processing to background workers,
 * preventing main thread blocking during game state updates.
 */

import { Job } from 'bullmq';
import { queueService } from './queueService';
import prisma from '../lib/prisma';
import config from '../config';
import * as policeService from '../services/policeService';
import * as fbiService from '../services/fbiService';
import { prostituteService } from '../services/prostituteService';
import nightclubService from '../services/nightclubService';
import { RealTimeProvider, ITimeProvider } from '../utils/timeProvider';

interface TickJobData {
  tickId: string;
  timestamp: number;
}

class TickQueue {
  private static readonly QUEUE_NAME = 'game-ticks';
  private timeProvider: ITimeProvider;

  constructor(timeProvider: ITimeProvider = new RealTimeProvider()) {
    this.timeProvider = timeProvider;
  }

  /**
   * Initialize the tick queue and worker
   */
  async init(): Promise<void> {
    // Create the queue
    const queue = queueService.getQueue<TickJobData>({
      name: TickQueue.QUEUE_NAME,
      defaultJobOptions: {
        attempts: 2, // Retry once on failure
        backoff: {
          type: 'fixed',
          delay: 5000, // 5 seconds
        },
        removeOnComplete: 50,  // Keep last 50 completed ticks
        removeOnFail: 100,     // Keep last 100 failed ticks
      },
    });

    if (!queue) {
      console.warn('⚠️  Tick queue not available - Redis not connected');
      return;
    }

    // Register the worker
    queueService.registerWorker<TickJobData>(
      TickQueue.QUEUE_NAME,
      this.processTickJob.bind(this),
      1 // Process one tick at a time (serial processing)
    );

    // Register queue events for monitoring
    queueService.registerQueueEvents(TickQueue.QUEUE_NAME);

    console.log('✅ Tick queue initialized');
  }

  /**
   * Schedule a tick job
   */
  async scheduleTick(delayMs = 0): Promise<boolean> {
    const tickId = `tick-${Date.now()}`;
    const timestamp = this.timeProvider.timestamp();

    const job = await queueService.addJob<TickJobData>(
      TickQueue.QUEUE_NAME,
      {
        tickId,
        timestamp,
      },
      {
        delay: delayMs,
        jobId: tickId,
      }
    );

    if (!job) {
      console.warn('⚠️  Failed to schedule tick - queue unavailable');
      return false;
    }

    console.log(`📅 Tick scheduled: ${tickId} (delay: ${delayMs}ms)`);
    return true;
  }

  /**
   * Schedule a recurring tick job (replaces setInterval)
   */
  async scheduleRecurringTick(intervalMs: number): Promise<boolean> {
    const tickId = 'recurring-tick';
    const timestamp = this.timeProvider.timestamp();

    const job = await queueService.addRecurringJob<TickJobData>(
      TickQueue.QUEUE_NAME,
      tickId,
      {
        tickId,
        timestamp,
      },
      {
        every: intervalMs,
      }
    );

    if (!job) {
      console.warn('⚠️  Failed to schedule recurring tick - queue unavailable');
      return false;
    }

    console.log(`🔁 Recurring tick scheduled (interval: ${intervalMs}ms)`);
    return true;
  }

  /**
   * Process a single tick job (background worker)
   */
  private async processTickJob(job: Job<TickJobData>): Promise<void> {
    const startTime = Date.now();
    const { tickId, timestamp } = job.data;

    console.log(`⏰ Processing tick: ${tickId} at ${new Date(timestamp).toISOString()}`);

    try {
      // 1. Process periodic player systems
      const players = await prisma.player.findMany({
        select: {
          id: true,
          username: true,
          health: true,
        },
      });

      let playersProcessed = 0;
      for (const player of players) {
        try {
          // Passive healing: +X HP per tick if alive and below max health
          if (player.health > 0 && player.health < 100) {
            const newHealth = Math.min(100, player.health + config.passiveHealingPerTick);
            await prisma.player.update({
              where: { id: player.id },
              data: { health: newHealth },
            });
          }

          // Decay wanted level and FBI heat
          await policeService.decayWantedLevel(player.id);
          await fbiService.decayFBIHeat(player.id);

          playersProcessed++;
        } catch (error) {
          console.error(`❌ Error processing tick for player ${player.id}:`, error);
        }
      }

      // Settle prostitution earnings for all players
      const prostitutionResult = await prostituteService.settleAllProstitutionEarnings();
      // Keep nightclub economy running in queue-mode ticks as well.
      await nightclubService.processAutomagicSales();
      const seasonResult = await nightclubService.processWeeklySeasonIfNeeded();

      const duration = Date.now() - startTime;

      console.log(`✅ Tick ${tickId} completed in ${duration}ms:`, {
        players: playersProcessed,
        prostitutionPlayers: prostitutionResult.playersProcessed,
        prostitutionEarnings: prostitutionResult.totalEarningsSettled,
        nightclubAutoSalesProcessed: true,
        seasonProcessed: seasonResult.processed,
        seasonWinnerCount: seasonResult.winners.length,
        duration: `${duration}ms`,
      });

      // Result logged above, no return needed for worker
    } catch (error) {
      console.error(`❌ Tick ${tickId} failed:`, error);
      throw error;
    }
  }

  /**
   * Get queue statistics
   */
  async getStats() {
    return queueService.getQueueStats(TickQueue.QUEUE_NAME);
  }

  /**
   * Clean old tick jobs
   */
  async cleanOldJobs(olderThanHours = 24): Promise<void> {
    const grace = olderThanHours * 60 * 60 * 1000;
    await queueService.cleanQueue(TickQueue.QUEUE_NAME, grace, 1000);
  }

  /**
   * Pause tick processing
   */
  async pause(): Promise<void> {
    await queueService.pauseQueue(TickQueue.QUEUE_NAME);
  }

  /**
   * Resume tick processing
   */
  async resume(): Promise<void> {
    await queueService.resumeQueue(TickQueue.QUEUE_NAME);
  }
}

// Singleton instance
export const tickQueue = new TickQueue();
