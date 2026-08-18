import { NPCService } from '../services/npcService';
import npcBehaviors from '../../content/npcBehaviors.json';

/**
 * NPC Activity Scheduler
 * Simulates NPC activity at regular intervals
 */
export class NPCScheduler {
  private intervalId: NodeJS.Timeout | null = null;
  private isRunning: boolean = false;

  /**
   * Start the NPC activity scheduler
   */
  start() {
    if (this.isRunning) {
      console.log('[NPC Scheduler] Already running');
      return;
    }

    const intervalMinutes = npcBehaviors.simulationSettings.tickIntervalMinutes;
    const intervalMs = intervalMinutes * 60 * 1000;

    console.log(`[NPC Scheduler] Starting with ${intervalMinutes} minute intervals`);

    this.intervalId = setInterval(async () => {
      await this.runSimulation();
    }, intervalMs);

    this.isRunning = true;

    // Run initial simulation
    this.runSimulation();
  }

  /**
   * Stop the NPC activity scheduler
   */
  stop() {
    if (!this.isRunning) {
      console.log('[NPC Scheduler] Not running');
      return;
    }

    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }

    this.isRunning = false;
    console.log('[NPC Scheduler] Stopped');
  }

  /**
   * Run a single simulation cycle
   */
  private async runSimulation() {
    try {
      console.log('[NPC Scheduler] Running live ticks');

      const result = await NPCService.runScheduledTicks();

      console.log('[NPC Scheduler] Tick complete:', {
        npcs: result.totalNPCs,
        ran: result.results.length,
        activities: result.totalActivities,
        moneyEarned: result.totalMoneyEarned,
        xpEarned: result.totalXpEarned,
        arrests: result.totalArrests,
      });
    } catch (error) {
      console.error('[NPC Scheduler] Error during simulation:', error);
    }
  }

  /**
   * Check if scheduler is running
   */
  isActive(): boolean {
    return this.isRunning;
  }
}

// Singleton instance
export const npcScheduler = new NPCScheduler();
