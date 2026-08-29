import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { jobService } from '../services/jobService';
import * as policeService from '../services/policeService';
import * as cooldownService from '../services/cooldownService';
import { intensiveCareService } from '../services/intensiveCareService';

const router = Router();

/**
 * GET /jobs
 * Get all available job types
 */
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (playerId) {
      // Check for active cooldown
      const cooldown = await cooldownService.getCooldown(playerId, 'job');
      if (cooldown && cooldown.remainingSeconds > 0) {
        return res.status(200).json({
          event: 'jobs.list',
          params: {},
          jobs: [],
          cooldown: {
            actionType: 'job',
            remainingSeconds: cooldown.remainingSeconds,
          },
        });
      }
    }

    const jobs = jobService.getAvailableJobs();

    return res.status(200).json({
      event: 'jobs.list',
      params: {},
      jobs,
    });
  } catch (error) {
    console.error('[Jobs] GET / failed:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /jobs/available
 * Get jobs available for the authenticated player's level
 */
router.get('/available', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const [availability, cooldown] = await Promise.all([
      jobService.getJobsForPlayer(playerId, req.player!.rank),
      cooldownService.getCooldown(playerId, 'job'),
    ]);

    const payload: Record<string, unknown> = {
      event: 'jobs.available',
      params: {},
      jobs: availability.availableJobs,
      lockedJobs: availability.lockedJobs,
    };

    if (cooldown && cooldown.remainingSeconds > 0) {
      payload.cooldown = {
        actionType: 'job',
        remainingSeconds: cooldown.remainingSeconds,
      };
    }

    return res.status(200).json(payload);
  } catch (error) {
    console.error('[Jobs] GET /available failed:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /jobs/history
 * Get player's job history
 */
router.get('/history', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const limit = req.query.limit ? parseInt(req.query.limit as string, 10) : 20;
    const history = await jobService.getJobHistory(req.player!.id, limit);

    return res.status(200).json({
      event: 'jobs.history',
      params: {},
      history,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /jobs/:jobId/work
 * Work a job (perform the job action)
 */
router.post('/:jobId/work', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const jobId = req.params.jobId as string;
    const jobDefinition = jobService.getJobDefinition(jobId);

    if (!jobDefinition) {
      return res.status(400).json({
        event: 'job.error',
        params: { reason: 'INVALID_JOB_ID' },
      });
    }

    const jobCooldownSeconds = cooldownService.calculateJobCooldown(
      jobDefinition.maxEarnings,
    );

    const remainingCooldown = await cooldownService.checkCooldown(
      req.player!.id,
      'job',
    );
    if (remainingCooldown > 0) {
      return res.status(429).json({
        event: 'error.cooldown',
        params: {
          actionType: 'job',
          remainingSeconds: remainingCooldown,
          message: `You must wait ${remainingCooldown} seconds before performing this action again`,
        },
      });
    }

    // Check if player is in intensive care
    const icuMinutes = await intensiveCareService.checkICUStatus(req.player!.id);
    if (icuMinutes > 0) {
      return res.status(403).json({
        event: 'error.inICU',
        params: {
          message: `Je ligt op de intensive care. Je kunt over ${icuMinutes} minuten weer actief worden.`,
          remainingMinutes: icuMinutes,
        },
      });
    }

    // Check if player is in jail
    const remainingJailTime = await policeService.checkIfJailed(req.player!.id);
    if (remainingJailTime > 0) {
      return res.status(403).json({
        event: 'error.jailed',
        params: {
          remainingTime: remainingJailTime,
        },
      });
    }

    const result = await jobService.workJob(req.player!.id, jobId);
    
    // Set cooldown after job completion
    const cooldownInfo = await cooldownService.setCooldown(
      req.player!.id,
      'job',
      jobCooldownSeconds,
    );

    return res.status(200).json({
      event: result.success ? 'job.completed' : 'job.failed',
      params: {
        jobId,
        earnings: result.earnings,
        xpGained: result.xpGained,
        xpLost: result.xpLost,
        success: result.success,
        successChance: (result as any).successChance ?? 85,
        educationBonusPercent: (result as any).educationBonusPercent ?? 0,
        flavorKey: (result as any).flavorKey ?? null,
        tipBonusAmount: (result as any).tipBonusAmount ?? 0,
        tipBonusPercent: (result as any).tipBonusPercent ?? 0,
        bonusXp: (result as any).bonusXp ?? 0,
        intelDropped: (result as any).intelDropped === true,
        sessionPayoutMultiplier: (result as any).sessionPayoutMultiplier ?? 1,
        sessionAttemptsInWindow: (result as any).sessionAttemptsInWindow ?? 0,
        sessionWindowMinutes: (result as any).sessionWindowMinutes ?? 60,
      },
      player: result.player,
      cooldown: cooldownInfo,
    });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'Unknown error';
    console.error('[JobsRoute] Failed to process job work action', {
      playerId: req.player?.id,
      jobId: req.params.jobId,
      error,
    });

    // Handle specific errors
    if (errorMessage === 'INVALID_JOB_ID') {
      return res.status(400).json({
        event: 'job.error',
        params: { reason: 'INVALID_JOB_ID' },
      });
    }

    if (errorMessage === 'LEVEL_TOO_LOW') {
      return res.status(400).json({
        event: 'job.error',
        params: { reason: 'LEVEL_TOO_LOW' },
      });
    }

    if (errorMessage.startsWith('ON_COOLDOWN:')) {
      const secondsRemaining = parseInt(errorMessage.split(':')[1], 10);
      return res.status(400).json({
        event: 'job.error',
        params: {
          reason: 'ON_COOLDOWN',
          secondsRemaining,
        },
      });
    }

    if (errorMessage.startsWith('EDUCATION_REQUIREMENTS_NOT_MET:')) {
      const raw = errorMessage.replace('EDUCATION_REQUIREMENTS_NOT_MET:', '');
      let details: any = {};
      try {
        details = JSON.parse(raw);
      } catch {
        details = {};
      }

      return res.status(400).json({
        event: 'job.error',
        params: {
          reason: 'EDUCATION_REQUIREMENTS_NOT_MET',
          reasonKey: 'job.error.education_requirements_not_met',
          ...details,
        },
      });
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
