import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { leaderboardService, LeaderboardPeriod } from '../services/leaderboardService';

const router = Router();

const allowedPeriods: LeaderboardPeriod[] = ['weekly', 'monthly', 'all_time'];

function isValidPeriod(period: string): period is LeaderboardPeriod {
  return allowedPeriods.includes(period as LeaderboardPeriod);
}

/**
 * GET /leaderboards/:period
 * Get leaderboard by period (weekly/monthly/all_time)
 */
router.get('/:period', authenticate, async (req: AuthRequest, res) => {
  try {
    const period = req.params.period as string;

    if (!isValidPeriod(period)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid period. Use weekly, monthly, or all_time',
      });
    }

    const limit = Math.min(Math.max(parseInt(req.query.limit as string, 10) || 20, 1), 100);
    const currentPlayerId = req.player?.id;

    const leaderboard = await leaderboardService.getLeaderboard(period, limit, currentPlayerId);

    return res.json({
      success: true,
      period,
      leaderboard,
    });
  } catch (error) {
    console.error('[Leaderboards] Error fetching leaderboard:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch leaderboard',
    });
  }
});

/**
 * GET /leaderboards/my-rank/:period
 * Get current player's rank for a period
 */
router.get('/my-rank/:period', authenticate, async (req: AuthRequest, res) => {
  try {
    const period = req.params.period as string;

    if (!isValidPeriod(period)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid period. Use weekly, monthly, or all_time',
      });
    }

    const playerId = req.player!.id;
    const rankData = await leaderboardService.getPlayerRank(playerId, period);

    return res.json({
      success: true,
      ...rankData,
    });
  } catch (error) {
    console.error('[Leaderboards] Error fetching player rank:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch player rank',
    });
  }
});

/**
 * GET /leaderboards/achievements
 * Get current player's prostitution achievements
 */
router.get('/achievements/list', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const achievements = await leaderboardService.checkAchievements(playerId);

    return res.json({
      success: true,
      achievements,
    });
  } catch (error) {
    console.error('[Leaderboards] Error fetching achievements:', error);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch achievements',
    });
  }
});

export default router;
