import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { getTrainingComboReadinessPayload } from '../lib/trainingComboReadiness';
import { gymService } from '../services/gymService';
import { shootingRangeService } from '../services/shootingRangeService';

const router = Router();

/**
 * GET /training/status
 * Combined gym + shooting-range status (one round-trip for the training hub / crime UI).
 * Includes `trainingComboReadiness` { active, bonusFraction } for same-UTC-day combo (crimeService).
 */
router.get('/status', authenticate, async (req: AuthRequest, res) => {
  const playerId = req.player!.id;
  const [gym, shootingRange] = await Promise.all([
    gymService.getStatus(playerId),
    shootingRangeService.getStatus(playerId),
  ]);
  const trainingComboReadiness = getTrainingComboReadinessPayload(
    (gym as { gymLastTrainedAt?: Date | null }).gymLastTrainedAt ??
      (gym.lastTrainedAt as Date | null | undefined),
    shootingRange.lastTrainedAt as Date | null | undefined,
  );
  return res.status(200).json({
    success: true,
    gym,
    shootingRange,
    trainingComboReadiness,
  });
});

export default router;
