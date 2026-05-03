import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { gymService } from '../services/gymService';
import { shootingRangeService } from '../services/shootingRangeService';

const router = Router();

/**
 * GET /training/status
 * Combined gym + shooting-range status (one round-trip for the training hub / crime UI).
 */
router.get('/status', authenticate, async (req: AuthRequest, res) => {
  const playerId = req.player!.id;
  const [gym, shootingRange] = await Promise.all([
    gymService.getStatus(playerId),
    shootingRangeService.getStatus(playerId),
  ]);
  return res.status(200).json({
    success: true,
    gym,
    shootingRange,
  });
});

export default router;
