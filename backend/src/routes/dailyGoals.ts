import express, { Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { dailyGoalsService } from '../services/dailyGoalsService';

const router = express.Router();

router.get('/daily', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const data = await dailyGoalsService.getDailyGoals(playerId);
    return res.status(200).json({ success: true, data });
  } catch (error) {
    console.error('[GET /daily-goals/daily] error', error);
    return res.status(500).json({ success: false, event: 'error.internal', params: {} });
  }
});

router.get('/weekly', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const data = await dailyGoalsService.getWeeklyGoals(playerId);
    return res.status(200).json({ success: true, data });
  } catch (error) {
    console.error('[GET /daily-goals/weekly] error', error);
    return res.status(500).json({ success: false, event: 'error.internal', params: {} });
  }
});

router.post('/daily/claim', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const goalKey = String(req.body?.goalKey ?? '').trim();
    if (!goalKey) {
      return res.status(400).json({
        success: false,
        event: 'error.validation',
        params: {
          messageNl: 'Kies een doel om te claimen.',
          messageEn: 'Choose a goal to claim.',
        },
      });
    }

    const result = await dailyGoalsService.claimDailyGoal(playerId, goalKey);
    return res.status(200).json({
      success: true,
      data: result,
      messageNl: 'Dagdoel geclaimd!',
      messageEn: 'Daily goal claimed!',
    });
  } catch (error: any) {
    const code = String(error?.code ?? error?.message ?? '');
    if (code === 'NOT_COMPLETE') {
      return res.status(400).json({
        success: false,
        event: 'daily_goal.not_complete',
        params: {
          messageNl: 'Dit dagdoel is nog niet voltooid.',
          messageEn: 'This daily goal is not complete yet.',
        },
      });
    }
    if (code === 'ALREADY_CLAIMED') {
      return res.status(400).json({
        success: false,
        event: 'daily_goal.already_claimed',
        params: {
          messageNl: 'Dit dagdoel is al geclaimd.',
          messageEn: 'This daily goal was already claimed.',
        },
      });
    }
    if (code === 'INVALID_GOAL') {
      return res.status(400).json({
        success: false,
        event: 'daily_goal.invalid',
        params: {
          messageNl: 'Ongeldig dagdoel.',
          messageEn: 'Invalid daily goal.',
        },
      });
    }

    console.error('[POST /daily-goals/daily/claim] error', error);
    return res.status(500).json({ success: false, event: 'error.internal', params: {} });
  }
});

export default router;

