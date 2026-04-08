import express from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { prostituteService } from '../services/prostituteService';

const router = express.Router();

/**
 * GET /prostitutes
 * Get all prostitutes for the authenticated player
 */
router.get('/', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;

    const prostitutes = await prostituteService.getPlayerProstitutes(playerId);
    const stats = await prostituteService.getEarningsStats(playerId);
    const housingSummary = await prostituteService.getHousingSummary(playerId);

    res.json({
      success: true,
      prostitutes,
      stats,
      housingSummary,
    });
  } catch (error) {
    console.error('Error fetching prostitutes:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /prostitutes/recruit
 * Recruit a new prostitute
 */
router.post('/recruit', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;

    const result = await prostituteService.recruitProstitute(playerId);

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error recruiting prostitute:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /prostitutes/:id/move-to-redlight
 * Move a prostitute to a red light district room
 */
router.post('/:id/move-to-redlight', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const prostituteId = parseInt(String(req.params.id), 10);
    const { redLightRoomId } = req.body;
    const { redLightDistrictId } = req.body;

    if (!redLightRoomId && !redLightDistrictId) {
      return res.status(400).json({ success: false, message: 'redLightRoomId of redLightDistrictId is vereist' });
    }

    const result = await prostituteService.moveToRedLight(
      playerId,
      prostituteId,
      redLightRoomId ? parseInt(String(redLightRoomId), 10) : undefined,
      redLightDistrictId ? parseInt(String(redLightDistrictId), 10) : undefined
    );

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error moving prostitute to red light:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /prostitutes/:id/move-to-street
 * Move a prostitute back to the street
 */
router.post('/:id/move-to-street', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const prostituteId = parseInt(String(req.params.id), 10);

    const result = await prostituteService.moveToStreet(playerId, prostituteId);

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error moving prostitute to street:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /prostitutes/settle-earnings
* Settle earnings for all prostitutes (work shift: earn money and XP)
*/
router.post('/:id/work-shift', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const prostituteId = parseInt(String(req.params.id), 10);
    const { location } = req.body;

    const result = await prostituteService.workShift(
      playerId,
      prostituteId,
      location || 'street'
    );

    if (!result.success) {
      return res.status(400).json(result);
    }

    res.json(result);
  } catch (error) {
    console.error('Error executing work shift:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * POST /prostitutes/settle-earnings
 * Settle earnings for all prostitutes
 */
router.post('/settle-earnings', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;

    const earnings = await prostituteService.settleEarnings(playerId);

    res.json({
      success: true,
      earnings,
      message: earnings > 0 ? `Je hebt €${earnings} verdiend!` : 'Geen inkomsten om te verzilveren'
    });
  } catch (error) {
    console.error('Error settling earnings:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

/**
 * GET /prostitutes/can-recruit
 * Check if player can recruit (cooldown status)
 */
router.get('/can-recruit', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;

    const canRecruit = await prostituteService.canRecruit(playerId);

    res.json(canRecruit);
  } catch (error) {
    console.error('Error checking recruitment status:', error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
});

export default router;
