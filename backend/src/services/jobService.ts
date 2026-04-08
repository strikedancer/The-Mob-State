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

interface JobDefinition {
  id: string;
  name: string;
  description: string;
  minLevel: number;
  minEarnings: number;
  maxEarnings: number;
  xpReward: number;
  cooldownMinutes: number;
}

type PlayerEducationProfile = Awaited<
  ReturnType<typeof educationService.getPlayerEducationProfile>
>;

class JobService {
  private jobs: JobDefinition[] = [];

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
    return this.jobs;
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
    return this.jobs.filter((job) => job.minLevel <= playerLevel);
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
        availableJobs.push(job);
        continue;
      }

      lockedJobs.push({
        ...job,
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

    // Check cooldown
    const cooldownCheck = await this.checkCooldown(playerId, jobId, job.cooldownMinutes);
    if (cooldownCheck.onCooldown) {
      throw new Error(`ON_COOLDOWN:${cooldownCheck.secondsRemaining}`);
    }

    // Jobs have 85% success rate (safer than crimes)
    const successRoll = Math.random();
    const success = successRoll < 0.85;

    let earnings = 0;
    let educationBonusPercent = 0;
    let xpGained = 0;
    let xpLost = 0;

    if (success) {
      // Success: Calculate earnings (random between min and max)
      const baseEarnings = Math.floor(
        Math.random() * (job.maxEarnings - job.minEarnings + 1) + job.minEarnings
      );
      const salaryBonus = this.getEducationSalaryMultiplier(educationProfile, jobId);
      educationBonusPercent = salaryBonus.bonusPercent;
      earnings = Math.floor(baseEarnings * salaryBonus.multiplier);
      xpGained = job.xpReward;
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
        await worldEventService.createEvent(
          'job.completed',
          {
            jobId,
            jobName: job.name,
            earnings,
            educationBonusPercent,
          },
          playerId
        );
      } catch (err) {
        console.error('[JobService] Failed to create job.completed world event:', err);
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
          },
          playerId
        );
      } catch (err) {
        console.error('[JobService] Failed to create job.failed world event:', err);
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
      player: result.player,
      newlyUnlockedAchievements,
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
