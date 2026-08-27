import prisma from '../lib/prisma';
import { readFileSync } from 'fs';
import { join } from 'path';
import { timeProvider } from '../utils/timeProvider';
import { worldEventService } from './worldEventService';
import { activityService } from './activityService';
import { playerService } from './playerService';
import { educationService } from './educationService';
import config from '../config';
import { serializeAchievementForClient } from './achievementService';
import { economyBalanceService } from './economyBalanceService';
import { calculateJobCooldown } from './cooldownService';
import { jobFlavorService } from './jobFlavorService';

interface JobDefinition {
  id: string;
  name: string;
  description: string;
  minLevel: number;
  minEarnings: number;
  maxEarnings: number;
  xpReward: number;
  cooldownMinutes: number;
  successChance?: number;
  educationBonusPercent?: number;
}

type PlayerEducationProfile = Awaited<
  ReturnType<typeof educationService.getPlayerEducationProfile>
>;

class JobService {
  private jobs: JobDefinition[] = [];

  private withComputedCooldown(job: JobDefinition): JobDefinition {
    const computedMinutes = Math.max(
      1,
      Math.ceil(calculateJobCooldown(job.maxEarnings) / 60),
    );
    return {
      ...job,
      cooldownMinutes: computedMinutes,
    };
  }

  private getEducationSalaryMultiplier(
    profile: PlayerEducationProfile,
    jobId: string
  ): { multiplier: number; bonusPercent: number } {
    const gate = educationService.getJobGate(jobId);
    if (!gate) {
      return { multiplier: 1, bonusPercent: 0 };
    }

    const trackId = gate.requirements.trackId;
    const trackLevel = trackId ? (profile.tracks[trackId]?.level ?? 0) : 0;
    const levelBonusPercent = Math.min(20, Math.max(0, trackLevel * 2));

    const requiredCertifications = gate.requirements.certifications ?? [];
    const hasAllRequiredCertifications = requiredCertifications.every((certificationId) =>
      profile.certifications.includes(certificationId)
    );
    const certificationBonusPercent = hasAllRequiredCertifications && requiredCertifications.length > 0
      ? 5
      : 0;

    const bonusPercent = Math.min(25, levelBonusPercent + certificationBonusPercent);
    const multiplier = 1 + bonusPercent / 100;

    return { multiplier, bonusPercent };
  }

  /** Base success by payout tier — entry jobs safer, elite jobs harder. */
  private getBaseSuccessRate(maxEarnings: number): number {
    if (maxEarnings >= 2000) return 0.78;
    if (maxEarnings >= 500) return 0.85;
    return 0.92;
  }

  /** +2% per relevant school track level on gated jobs (max +12%). */
  private getEducationSuccessBonus(
    profile: PlayerEducationProfile,
    jobId: string,
  ): number {
    const gate = educationService.getJobGate(jobId);
    if (!gate?.requirements.trackId) return 0;
    const trackLevel = profile.tracks[gate.requirements.trackId]?.level ?? 0;
    return Math.min(0.12, Math.max(0, trackLevel * 0.02));
  }

  /** Penalty for spamming the same job back-to-back (−4% per repeat after first, max −12%). */
  private getRepeatJobPenalty(consecutiveSameJob: number): number {
    if (consecutiveSameJob < 2) return 0;
    return Math.min(0.12, (consecutiveSameJob - 1) * 0.04);
  }

  private countConsecutiveSameJob(
    recentAttempts: Array<{ jobId: string }>,
    jobId: string,
  ): number {
    if (recentAttempts.length === 0 || recentAttempts[0]?.jobId !== jobId) {
      return 0;
    }
    let streak = 0;
    for (const attempt of recentAttempts) {
      if (attempt.jobId === jobId) streak += 1;
      else break;
    }
    return streak;
  }

  calculateSuccessRateForJob(
    job: Pick<JobDefinition, 'id' | 'maxEarnings'>,
    profile: PlayerEducationProfile,
    consecutiveSameJob: number,
  ): number {
    const raw =
      this.getBaseSuccessRate(job.maxEarnings) +
      this.getEducationSuccessBonus(profile, job.id) -
      this.getRepeatJobPenalty(consecutiveSameJob);
    return Math.min(0.95, Math.max(0.55, raw));
  }

  private async getRecentJobAttempts(playerId: number, limit = 8) {
    return prisma.jobAttempt.findMany({
      where: { playerId },
      orderBy: { completedAt: 'desc' },
      take: limit,
      select: { jobId: true },
    });
  }

  private enrichJobForPlayer(
    job: JobDefinition,
    profile: PlayerEducationProfile,
    recentAttempts: Array<{ jobId: string }>,
  ): JobDefinition {
    const consecutiveSameJob = this.countConsecutiveSameJob(
      recentAttempts,
      job.id,
    );
    const successRate = this.calculateSuccessRateForJob(
      job,
      profile,
      consecutiveSameJob,
    );
    const salaryBonus = this.getEducationSalaryMultiplier(profile, job.id);
    return {
      ...this.withComputedCooldown(job),
      successChance: Math.round(successRate * 100),
      educationBonusPercent: salaryBonus.bonusPercent,
    };
  }

  constructor() {
    this.loadJobs();
  }

  private loadJobs() {
    const jobsPath = join(__dirname, '../../content/jobs.json');
    const jobsData = readFileSync(jobsPath, 'utf-8');
    this.jobs = JSON.parse(jobsData);
  }

  /**
   * Get all available jobs
   */
  getAvailableJobs(): JobDefinition[] {
    return this.jobs.map((job) => this.withComputedCooldown(job));
  }

  /**
   * Get a specific job by ID
   */
  getJobDefinition(jobId: string): JobDefinition | undefined {
    return this.jobs.find((j) => j.id === jobId);
  }

  /**
   * Get jobs available for a specific player level
   */
  getJobsForLevel(playerLevel: number): JobDefinition[] {
    return this.jobs
      .filter((job) => job.minLevel <= playerLevel)
      .map((job) => this.withComputedCooldown(job));
  }

  async getJobsForPlayer(playerId: number, playerRank: number): Promise<{
    availableJobs: JobDefinition[];
    lockedJobs: Array<
      JobDefinition & {
        gateId?: string;
        gateLabelKey?: string;
        educationMissing: Array<{ code: string; reasonKey: string; params: Record<string, unknown> }>;
      }
    >;
  }> {
    const rankFilteredJobs = this.getJobsForLevel(playerRank);
    const profile = await educationService.getPlayerEducationProfile(playerId);
    const recentAttempts = await this.getRecentJobAttempts(playerId);

    const availableJobs: JobDefinition[] = [];
    const lockedJobs: Array<
      JobDefinition & {
        gateId?: string;
        gateLabelKey?: string;
        educationMissing: Array<{ code: string; reasonKey: string; params: Record<string, unknown> }>;
      }
    > = [];

    for (const job of rankFilteredJobs) {
      const eligibility = educationService.checkJobEligibilityWithProfile(
        profile,
        job.id,
        playerRank
      );

      if (eligibility.allowed) {
        availableJobs.push(
          this.enrichJobForPlayer(job, profile, recentAttempts),
        );
        continue;
      }

      lockedJobs.push({
        ...this.withComputedCooldown(job),
        gateId: eligibility.gateId,
        gateLabelKey: eligibility.gateLabelKey,
        educationMissing: eligibility.missing,
      });
    }

    return { availableJobs, lockedJobs };
  }

  /**
   * Check if player is on cooldown for a specific job
   */
  async checkCooldown(
    playerId: number,
    jobId: string,
    cooldownMinutes: number
  ): Promise<{ onCooldown: boolean; secondsRemaining: number }> {
    const lastAttempt = await prisma.jobAttempt.findFirst({
      where: { playerId, jobId },
      orderBy: { completedAt: 'desc' },
    });

    if (!lastAttempt) {
      return { onCooldown: false, secondsRemaining: 0 };
    }

    const now = timeProvider.now();
    const cooldownMs = cooldownMinutes * 60 * 1000;
    const timeSinceLastAttempt = now.getTime() - lastAttempt.completedAt.getTime();

    if (timeSinceLastAttempt < cooldownMs) {
      const remainingMs = cooldownMs - timeSinceLastAttempt;
      const secondsRemaining = Math.floor(remainingMs / 1000);
      return { onCooldown: true, secondsRemaining };
    }

    return { onCooldown: false, secondsRemaining: 0 };
  }

  /**
   * Work a job (perform the job action)
   */
  async workJob(playerId: number, jobId: string) {
    const job = this.getJobDefinition(jobId);

    if (!job) {
      throw new Error('INVALID_JOB_ID');
    }

    // Get player for level check and full data
    const player = await prisma.player.findUnique({
      where: { id: playerId },
    });

    if (!player) {
      throw new Error('PLAYER_NOT_FOUND');
    }

    // Check level requirement
    if (player.rank < job.minLevel) {
      throw new Error('LEVEL_TOO_LOW');
    }

    const educationProfile = await educationService.getPlayerEducationProfile(playerId);
    const educationEligibility = educationService.checkJobEligibilityWithProfile(
      educationProfile,
      jobId,
      player.rank
    );

    if (!educationEligibility.allowed) {
      throw new Error(
        `EDUCATION_REQUIREMENTS_NOT_MET:${JSON.stringify({
          gateId: educationEligibility.gateId,
          gateLabelKey: educationEligibility.gateLabelKey,
          missing: educationEligibility.missing,
        })}`
      );
    }

    // Reward-based job cooldown pacing is enforced in the jobs route
    // through cooldownService before and after workJob is executed.

    const recentAttempts = await this.getRecentJobAttempts(playerId);
    const consecutiveSameJob = this.countConsecutiveSameJob(
      recentAttempts,
      jobId,
    );
    const successRate = this.calculateSuccessRateForJob(
      job,
      educationProfile,
      consecutiveSameJob,
    );
    const successRoll = Math.random();
    const success = successRoll < successRate;
    const flavor = await jobFlavorService.rollOutcome({
      playerId,
      jobId,
      maxPay: job.maxEarnings,
      success,
      currentCountry: player.currentCountry,
    });
    const diminishingContext = await economyBalanceService.getDiminishingContext(
      playerId,
      'job',
    );
    const sessionPayoutMultiplier = diminishingContext.multiplier;

    let earnings = 0;
    let educationBonusPercent = 0;
    let xpGained = 0;
    let xpLost = 0;
    let tipBonusAmount = 0;

    if (success) {
      // Success: Calculate earnings (random between min and max)
      const baseEarnings = Math.floor(
        Math.random() * (job.maxEarnings - job.minEarnings + 1) + job.minEarnings
      );
      const salaryBonus = this.getEducationSalaryMultiplier(educationProfile, jobId);
      educationBonusPercent = salaryBonus.bonusPercent;
      earnings = Math.floor(baseEarnings * salaryBonus.multiplier);
      if (flavor.tipBonusPercent > 0) {
        tipBonusAmount = Math.floor(earnings * (flavor.tipBonusPercent / 100));
        earnings += tipBonusAmount;
      }
      if (sessionPayoutMultiplier < 1) {
        earnings = economyBalanceService.applySoftDiminishing(
          earnings,
          sessionPayoutMultiplier,
          1,
        );
      }
      xpGained = job.xpReward + (flavor.bonusXp ?? 0);
    } else {
      // Failure: Lose XP (5-10% of potential earnings as XP penalty)
      const xpLossPercent =
        config.xpLoss.jobFailed.min +
        Math.random() * (config.xpLoss.jobFailed.max - config.xpLoss.jobFailed.min);
      const xpToLose = Math.floor(job.maxEarnings * xpLossPercent);

      if (xpToLose > 0) {
        const lossResult = await playerService.loseXP(playerId, xpToLose);
        xpLost = lossResult.xpLost;
      }
    }

    // Use transaction to update player and create job attempt record
    const result = await prisma.$transaction(async (tx) => {
      // Update player money and XP
      const updatedPlayer = await tx.player.update({
        where: { id: playerId },
        data: {
          money: { increment: earnings },
          xp: { increment: xpGained },
        },
      });

      // Check for rank up using exponential system
      const { getRankFromXP } = await import('../config');
      const calculatedNewRank = getRankFromXP(updatedPlayer.xp);
      if (calculatedNewRank > player.rank) {
        await tx.player.update({
          where: { id: playerId },
          data: { rank: calculatedNewRank },
        });
      }

      // Create job attempt record
      await tx.jobAttempt.create({
        data: {
          playerId,
          jobId,
          earnings,
          xpGained,
          completedAt: timeProvider.now(),
        },
      });

      return {
        success,
        earnings,
        educationBonusPercent,
        xpGained,
        xpLost,
        player: {
          id: updatedPlayer.id,
          money: updatedPlayer.money,
          xp: updatedPlayer.xp,
          rank: calculatedNewRank,
          health: updatedPlayer.health,
          wantedLevel: updatedPlayer.wantedLevel,
          fbiHeat: updatedPlayer.fbiHeat,
        }
      };
    });

    // Non-critical side effects should never block core job outcome
    if (success) {
      try {
        const { onboardingService } = await import('./onboardingService');
        await onboardingService.markJob(playerId);
      } catch (err) {
        console.error('[JobService] Failed to mark onboarding job:', err);
      }

      try {
        await worldEventService.createEvent(
          'job.completed',
          {
            jobId,
            jobName: job.name,
            earnings,
            xpGained,
            educationBonusPercent,
            sessionPayoutMultiplier,
            flavorKey: flavor.flavorKey,
            tipBonusAmount,
            tipBonusPercent: flavor.tipBonusPercent,
            bonusXp: flavor.bonusXp,
            intelDropped: flavor.intel != null,
          },
          playerId
        );
      } catch (err) {
        console.error('[JobService] Failed to create job.completed world event:', err);
      }

      if (flavor.intel) {
        try {
          await jobFlavorService.deliverIntelInbox(playerId, flavor.intel);
        } catch (err) {
          console.error('[JobService] Failed to deliver job intel inbox:', err);
        }
      }

      try {
        await activityService.logActivity(
          playerId,
          'JOB',
          `Worked as ${job.name} and earned €${earnings.toLocaleString()}`,
          {
            jobId: job.id,
            jobName: job.name,
            earnings,
            xpGained,
            sessionPayoutMultiplier,
            flavorKey: flavor.flavorKey,
            tipBonusAmount,
            intelDropped: flavor.intel != null,
          },
          true
        );
      } catch (err) {
        console.error('[JobService] Failed to log JOB activity:', err);
      }
    } else {
      try {
        await worldEventService.createEvent(
          'job.failed',
          {
            jobId,
            jobName: job.name,
            xpLost,
            flavorKey: flavor.flavorKey,
          },
          playerId,
        );
      } catch (err) {
        console.error('[JobService] Failed to create job.failed world event:', err);
      }

      try {
        await activityService.logActivity(
          playerId,
          'JOB',
          `Failed work as ${job.name}`,
          {
            jobId: job.id,
            jobName: job.name,
            xpLost,
            success: false,
            flavorKey: flavor.flavorKey,
          },
          false
        );
      } catch (err) {
        console.error('[JobService] Failed to log failed JOB activity:', err);
      }
    }

    // Check for achievement unlocks if job was successful
    let newlyUnlockedAchievements: any[] = [];
    if (success) {
      try {
        const { checkAndUnlockAchievements } = await import('./achievementService');
        const achievementResults = await checkAndUnlockAchievements(playerId);
        newlyUnlockedAchievements = achievementResults.map(r =>
          serializeAchievementForClient(r.achievement)
        );
      } catch (err) {
        console.error('[Achievement Check] Error after job:', err);
      }
    }

    return {
      success,
      earnings: result.earnings,
      xpGained: result.xpGained,
      xpLost,
      successChance: Math.round(successRate * 100),
      educationBonusPercent,
      flavorKey: flavor.flavorKey,
      tipBonusAmount,
      tipBonusPercent: flavor.tipBonusPercent,
      bonusXp: flavor.bonusXp,
      intelDropped: flavor.intel != null,
      player: result.player,
      newlyUnlockedAchievements,
      sessionPayoutMultiplier,
      sessionAttemptsInWindow: diminishingContext.attemptsInWindow,
      sessionWindowMinutes: diminishingContext.sessionWindowMinutes,
    };
  }

  /**
   * Get job history for a player
   */
  async getJobHistory(playerId: number, limit = 20) {
    const attempts = await prisma.jobAttempt.findMany({
      where: { playerId },
      orderBy: { completedAt: 'desc' },
      take: limit,
    });

    // Enrich with job names
    return attempts.map((attempt) => {
      const job = this.getJobDefinition(attempt.jobId);
      return {
        ...attempt,
        jobName: job?.name || 'Unknown Job',
      };
    });
  }
}

export const jobService = new JobService();
