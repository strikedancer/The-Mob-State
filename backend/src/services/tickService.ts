import config from '../config';
import prisma from '../lib/prisma';
import * as policeService from './policeService';
import * as fbiService from './fbiService';
import { prostituteService } from './prostituteService';
import { propertyService } from './propertyService';
import nightclubService from './nightclubService';
import { RealTimeProvider, ITimeProvider } from '../utils/timeProvider';
import { isRedisConnected } from './redisClient';
import { tickQueue } from '../queues/tickQueue';

class TickService {
  private intervalId: NodeJS.Timeout | null = null;
  private isRunning = false;
  private timeProvider: ITimeProvider;
  private useQueue = false;

  constructor(timeProvider: ITimeProvider = new RealTimeProvider()) {
    this.timeProvider = timeProvider;
  }

  /**
   * Start the tick service (singleton pattern - only runs once)
   * Uses background queue if Redis is available, otherwise falls back to setInterval
   */
  async start(): Promise<void> {
    if (this.isRunning) {
      console.log('⚠️  Tick service already running');
      return;
    }

    const intervalMs = config.tickIntervalMinutes * 60 * 1000;

    // Check if we can use the queue system
    this.useQueue = isRedisConnected();

    if (this.useQueue) {
      console.log(`⏰ Starting tick service with background queue (interval: ${config.tickIntervalMinutes} minutes)`);
      
      // Initialize the queue
      await tickQueue.init();
      
      // Schedule recurring tick jobs
      const scheduled = await tickQueue.scheduleRecurringTick(intervalMs);
      
      if (scheduled) {
        this.isRunning = true;
        console.log('✅ Tick service running with BullMQ queue');
      } else {
        console.warn('⚠️  Failed to schedule recurring tick, falling back to setInterval');
        this.startWithInterval(intervalMs);
      }
    } else {
      console.log(`⏰ Starting tick service with setInterval (interval: ${config.tickIntervalMinutes} minutes)`);
      this.startWithInterval(intervalMs);
    }
  }

  /**
   * Fallback method using setInterval (when Redis not available)
   */
  private startWithInterval(intervalMs: number): void {
    this.intervalId = setInterval(() => {
      this.runTick().catch((error) => {
        console.error('❌ Tick service error:', error);
      });
    }, intervalMs);

    this.isRunning = true;

    // Run first tick immediately on startup (optional)
    // this.runTick().catch((error) => {
    //   console.error('❌ Initial tick error:', error);
    // });
  }

  /**
   * Stop the tick service
   */
  stop(): void {
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
      this.isRunning = false;
      console.log('⏰ Tick service stopped');
    }
  }

  /**
   * Run a single tick cycle for all players
   */
  private async runTick(): Promise<void> {
    const startTime = this.timeProvider.timestamp();
    console.log(`\n⏰ Running tick at ${this.timeProvider.now().toISOString()}`);

    try {
      // Get all players for periodic processing
      const players = await prisma.player.findMany({
        select: {
          id: true,
          username: true,
          health: true,
        },
      });

      console.log(`📊 Processing ${players.length} players...`);

      // Process each player
      for (const player of players) {
        // Passive healing: +5 HP per tick if HP > 0 and < 100
        // Fetch full player data for health access
        const fullPlayer = await prisma.player.findUnique({
          where: { id: player.id },
          select: { health: true, username: true },
        });

        if (fullPlayer && fullPlayer.health > 0 && fullPlayer.health < 100) {
          const newHealth = Math.min(100, fullPlayer.health + config.passiveHealingPerTick);
          await prisma.player.update({
            where: { id: player.id },
            data: { health: newHealth },
          });
          console.log(
            `💚 Player ${fullPlayer.username} passive heal: ${fullPlayer.health} → ${newHealth} HP`
          );
        }

        // Decay wanted level
        await policeService.decayWantedLevel(player.id);

        // Decay FBI heat (slower than wanted level)
        await fbiService.decayFBIHeat(player.id);
      }

      // Settle prostitution earnings for all players
      const prostitutionResult = await prostituteService.settleAllProstitutionEarnings();
      if (prostitutionResult.playersProcessed > 0) {
        console.log(
          `💃 Settled prostitution earnings for ${prostitutionResult.playersProcessed} players (total: €${prostitutionResult.totalEarningsSettled.toLocaleString()}, evicted: ${prostitutionResult.totalEvicted})`
        );
      }

      // Process automatic nightclub drug sales for all open venues
      await nightclubService.processAutomagicSales();
      console.log('🏪 Nightclub auto-sales processed');

      const seasonResult = await nightclubService.processWeeklySeasonIfNeeded();
      if (seasonResult.processed) {
        console.log(
          `🏆 Nightclub season rotated. Winners rewarded: ${seasonResult.winners.length}`
        );
      }

      // Check for property forfeitures (death or long imprisonment)
      const forfeitResult = await this.checkPropertyForfeitures();
      if (forfeitResult.playersChecked > 0) {
        console.log(
          `🏚️  Checked ${forfeitResult.playersChecked} property owners, forfeited ${forfeitResult.propertiesForfeited} properties`
        );
      }

      const duration = this.timeProvider.timestamp() - startTime;
      console.log(
        `✅ Tick complete in ${duration}ms (${players.length} players)\n`
      );
    } catch (error) {
      console.error('❌ Error during tick:', error);
      throw error;
    }
  }

  /**
   * Check all property owners for forfeiture conditions
   * Returns stats about forfeitures
   */
  private async checkPropertyForfeitures(): Promise<{
    playersChecked: number;
    propertiesForfeited: number;
  }> {
    // Get all unique property owners
    const propertyOwners = await prisma.property.findMany({
      select: {
        playerId: true,
      },
      distinct: ['playerId'],
    });

    let totalForfeited = 0;

    for (const { playerId } of propertyOwners) {
      const forfeited = await propertyService.checkPlayerForfeiture(playerId);
      totalForfeited += forfeited;
    }

    return {
      playersChecked: propertyOwners.length,
      propertiesForfeited: totalForfeited,
    };
  }

  /**
   * Get tick service status
   */
  getStatus(): { isRunning: boolean; intervalMinutes: number } {
    return {
      isRunning: this.isRunning,
      intervalMinutes: config.tickIntervalMinutes,
    };
  }
}

// Export singleton instance
export const tickService = new TickService();
