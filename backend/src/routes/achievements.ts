import express from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import {
  getPlayerAchievements,
  checkAndUnlockAchievements,
  getAllAchievementDefinitions,
  serializeAchievementForClient,
} from '../services/achievementService';

const router = express.Router();

/**
 * GET /achievements
 * Get player's achievements with progress
 */
router.get('/', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const result = await getPlayerAchievements(playerId);

    res.json({
      success: true,
      ...result,
    });
  } catch (error) {
    console.error('Error fetching achievements:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch achievements',
    });
  }
});

/**
 * POST /achievements/check
 * Manually trigger achievement check
 */
router.post('/check', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    console.log(`[Achievements] Checking achievements for player ${playerId}`);
    
    const newlyUnlocked = await checkAndUnlockAchievements(playerId);
    console.log(`[Achievements] Found ${newlyUnlocked.length} newly unlocked achievements for player ${playerId}`);

    res.json({
      success: true,
      newlyUnlocked: newlyUnlocked.map(({ achievement }) =>
        serializeAchievementForClient(achievement)
      ),
    });
  } catch (error) {
    console.error(`[Achievements] Error checking achievements for player ${req.player?.id}:`, error);
    console.error('[Achievements] Error details:', {
      message: error instanceof Error ? error.message : String(error),
      stack: error instanceof Error ? error.stack : undefined,
    });
    res.status(500).json({
      success: false,
      message: 'Failed to check achievements',
      error: process.env.NODE_ENV === 'development' ? String(error) : undefined,
    });
  }
});

/**
 * GET /achievements/definitions
 * Get all achievement definitions
 */
router.get('/definitions', async (_req, res) => {
  try {
    const definitions = getAllAchievementDefinitions();

    res.json({
      success: true,
      achievements: definitions,
    });
  } catch (error) {
    console.error('Error fetching achievement definitions:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch achievement definitions',
    });
  }
});

export default router;
