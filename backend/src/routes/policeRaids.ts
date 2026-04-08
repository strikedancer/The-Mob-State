import express from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { policeRaidService } from '../services/policeRaidService';

const router = express.Router();

/**
 * GET /police-raids/stats
 * Get raid statistics for the authenticated player
 */
router.get('/stats', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.user!.id;

    const stats = await policeRaidService.getRaidStats(playerId);

    if (!stats) {
      return res.status(404).json({
        success: false,
        message: 'Speler niet gevonden'
      });
    }

    res.json({
      success: true,
      stats
    });
  } catch (error) {
    console.error('Error fetching raid stats:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /police-raids/check
 * Check and potentially execute a raid (for testing or manual trigger)
 */
router.post('/check', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.user!.id;

    const result = await policeRaidService.checkAndExecuteRaid(playerId);

    res.json({
      success: true,
      ...result
    });
  } catch (error) {
    console.error('Error checking/executing raid:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /police-raids/execute
 * Force execute a raid (admin/testing purposes)
 */
router.post('/execute', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.user!.id;

    const result = await policeRaidService.executeRaid(playerId);

    res.json(result);
  } catch (error) {
    console.error('Error executing raid:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

export default router;
