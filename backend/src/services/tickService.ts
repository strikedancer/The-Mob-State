import config from '../config';
import prisma from '../lib/prisma';
import { applyPassivePlayerTickBatch } from './playerTickBatch';
import { prostituteService } from './prostituteService';
import { propertyService } from './propertyService';
import nightclubService from './nightclubService';
import { policeRaidService } from './policeRaidService';
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
      const playerTick = await applyPassivePlayerTickBatch();
      console.log(
        `📊 Passive player tick: healed ${playerTick.healed}, wanted ${playerTick.wantedDecayed}, fbi ${playerTick.fbiHeatDecayed}`
      );

      try {
        const { countryPoliceService } = await import('./countryPoliceService');
        const cooled = await countryPoliceService.decayAllCountries();
        if (cooled > 0) {
          console.log(`🚔 Country police pressure decayed in ${cooled} countries`);
        }
      } catch (pressureDecayErr) {
        console.error('[Tick] Country police decay failed:', pressureDecayErr);
      }

      // Settle prostitution earnings for all players
      const prostitutionResult = await prostituteService.settleAllProstitutionEarnings();
      if (prostitutionResult.playersProcessed > 0) {
        console.log(
          `💃 Settled prostitution earnings for ${prostitutionResult.playersProcessed} players (total: €${prostitutionResult.totalEarningsSettled.toLocaleString()}, evicted: ${prostitutionResult.totalEvicted})`
        );
      }

      const raidCandidates = await prisma.player.findMany({
        where: {
          fbiHeat: { gte: 50 },
          OR: [
            { prostitutes: { some: { isBusted: false } } },
            { ownedRedLightDistricts: { some: {} } },
          ],
        },
        select: { id: true },
        take: 200,
      });
      let raidsTriggered = 0;
      for (const candidate of raidCandidates) {
        try {
          const raid = await policeRaidService.checkAndExecuteRaid(candidate.id);
          if (raid.raidOccurred) raidsTriggered += 1;
        } catch (raidError) {
          console.error(`[Tick] RLD raid check failed for player ${candidate.id}:`, raidError);
        }
      }
      if (raidsTriggered > 0) {
        console.log(`🚨 RLD raids executed this tick: ${raidsTriggered}`);
      }

      // Process automatic nightclub drug sales for all open venues
      await nightclubService.processAutomagicSales();
      console.log('🏪 Nightclub auto-sales processed');

      try {
        const casinoOwnershipService = await import('./casinoOwnershipService');
        const staffPay = await casinoOwnershipService.payCasinoStaffSalaries();
        if (staffPay.paid > 0 || staffPay.fired > 0) {
          console.log(
            `🎰 Casino staff salaries: paid €${staffPay.paid.toLocaleString()}, fired ${staffPay.fired}`,
          );
        }
      } catch (casinoStaffErr) {
        console.error('[Tick] Casino staff salaries failed:', casinoStaffErr);
      }

      try {
        const wholesale = await import('./drugWholesaleService');
        const settled = await wholesale.settleDueExports();
        if (settled.settled > 0 || settled.seized > 0) {
          console.log(
            `💊 Drug wholesale settle: paid ${settled.settled}, seized ${settled.seized}`,
          );
        }
      } catch (wholesaleErr) {
        console.error('[Tick] Drug wholesale settle failed:', wholesaleErr);
      }

      try {
        const { donService } = await import('./donService');
        await donService.processTick();
      } catch (donTickErr) {
        console.error('[Tick] Don tick failed:', donTickErr);
      }

      try {
        const { raceService } = await import('./raceService');
        const raceTick = await raceService.processTick();
        if (raceTick.settled > 0 || raceTick.refunded > 0) {
          console.log(
            `🏁 Midnight races: settled ${raceTick.settled}, refunded ${raceTick.refunded}`,
          );
        }
      } catch (raceTickErr) {
        console.error('[Tick] Midnight races tick failed:', raceTickErr);
      }

      const seasonResult = await nightclubService.processWeeklySeasonIfNeeded();
      if (seasonResult.processed) {
        console.log(
          `🏆 Nightclub season rotated. Winners rewarded: ${seasonResult.winners.length}`
        );
      }

      // Check for property forfeitures (death or long imprisonment)
      const forfeitResult = await propertyService.checkForfeituresForEligibleOwners();
      if (forfeitResult.playersChecked > 0) {
        console.log(
          `🏚️  Checked ${forfeitResult.playersChecked} property owners, forfeited ${forfeitResult.propertiesForfeited} properties`
        );
      }

      const duration = this.timeProvider.timestamp() - startTime;
      console.log(
        `✅ Tick complete in ${duration}ms (healed ${playerTick.healed}, wanted ${playerTick.wantedDecayed}, fbi ${playerTick.fbiHeatDecayed})\n`
      );
    } catch (error) {
      console.error('❌ Error during tick:', error);
      throw error;
    }
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
