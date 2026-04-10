import { Router, Response } from 'express';
import { authenticate } from '../middleware/authenticate';
import { AuthRequest } from '../middleware/authenticate';
import { checkCooldown } from '../middleware/checkCooldown';
import * as judgeService from '../services/judgeService';
import { worldEventService } from '../services/worldEventService';
import * as cooldownService from '../services/cooldownService';

const router = Router();

router.get('/current-sentence', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const result = await judgeService.getCurrentSentence(playerId);
    return res.status(200).json({
      sentence: result?.sentence ?? null,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/record', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const record = await judgeService.getCriminalRecord(playerId);

    return res.status(200).json({
      event: 'trial.record',
      params: {
        totalConvictions: record.totalConvictions,
        recentCrimes: record.recentCrimes.map((crime) => ({
          ...crime,
          createdAt: crime.createdAt.toISOString(),
        })),
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/appeal', authenticate, checkCooldown('appeal'), async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    const { crimeAttemptId } = req.body;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    if (!crimeAttemptId) {
      return res.status(400).json({
        event: 'error.missing_crime_attempt_id',
        params: {},
      });
    }

    const attemptId = parseInt(crimeAttemptId, 10);
    if (Number.isNaN(attemptId)) {
      return res.status(400).json({
        event: 'error.invalid_crime_attempt_id',
        params: {},
      });
    }

    const result = await judgeService.appealSentence(playerId, attemptId);
    await cooldownService.setCooldown(playerId, 'appeal');

    if (result.success) {
      await worldEventService.createEvent('trial.appeal_granted', {
        playerId,
        crimeAttemptId: attemptId,
        originalSentence: result.originalSentence,
        newSentence: result.newSentence,
        cost: result.cost,
      });

      return res.status(200).json({
        event: 'trial.appeal_granted',
        params: {
          success: true,
          originalSentence: result.originalSentence,
          newSentence: result.newSentence,
          newBalance: result.newBalance,
          cost: result.cost,
          reason: result.reason,
        },
      });
    }

    await worldEventService.createEvent('trial.appeal_denied', {
      playerId,
      crimeAttemptId: attemptId,
      originalSentence: result.originalSentence,
      cost: result.cost,
    });

    return res.status(200).json({
      event: 'trial.appeal_denied',
      params: {
        success: false,
        originalSentence: result.originalSentence,
        newBalance: result.newBalance,
        cost: result.cost,
        reason: result.reason,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'CRIME_ATTEMPT_NOT_FOUND') {
        return res.status(404).json({ event: 'error.crime_attempt_not_found', params: {} });
      }
      if (error.message === 'NOT_YOUR_CRIME') {
        return res.status(403).json({ event: 'error.not_your_crime', params: {} });
      }
      if (error.message === 'ALREADY_APPEALED') {
        return res.status(400).json({ event: 'error.already_appealed', params: {} });
      }
      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({ event: 'error.insufficient_money', params: {} });
      }
      if (error.message === 'NOT_JAILED' || error.message === 'SENTENCE_ALREADY_SERVED') {
        return res.status(400).json({ event: 'error.not_jailed', params: {} });
      }
      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({ event: 'error.player_not_found', params: {} });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/bribe', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    const { crimeAttemptId, amount } = req.body;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    if (!crimeAttemptId || !amount) {
      return res.status(400).json({
        event: 'error.missing_parameters',
        params: {},
      });
    }

    const attemptId = parseInt(crimeAttemptId, 10);
    const bribeAmount = parseInt(amount, 10);

    if (Number.isNaN(attemptId) || Number.isNaN(bribeAmount) || bribeAmount <= 0) {
      return res.status(400).json({
        event: 'error.invalid_parameters',
        params: {},
      });
    }

    const result = await judgeService.bribeJudgeForAttempt(playerId, attemptId, bribeAmount);

    if (result.success) {
      await worldEventService.createEvent('trial.bribe_success', {
        playerId,
        crimeAttemptId: attemptId,
        amount: bribeAmount,
      });
    } else {
      await worldEventService.createEvent('trial.bribe_failed', {
        playerId,
        crimeAttemptId: attemptId,
        amount: bribeAmount,
      });
    }

    return res.status(200).json({
      success: result.success,
      newBalance: result.newBalance,
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'CRIME_ATTEMPT_NOT_FOUND') {
        return res.status(404).json({ event: 'error.crime_attempt_not_found', params: {} });
      }
      if (error.message === 'NOT_YOUR_CRIME') {
        return res.status(403).json({ event: 'error.not_your_crime', params: {} });
      }
      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({ event: 'error.insufficient_money', params: {} });
      }
      if (error.message === 'NOT_JAILED' || error.message === 'SENTENCE_ALREADY_SERVED') {
        return res.status(400).json({ event: 'error.not_jailed', params: {} });
      }
      if (error.message === 'BRIBE_TOO_LOW') {
        return res.status(400).json({ event: 'error.bribe_too_low', params: {} });
      }
      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({ event: 'error.player_not_found', params: {} });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
