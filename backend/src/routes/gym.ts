import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { gymService, type GymTrainTrack } from '../services/gymService';
import { checkAndUnlockAchievements } from '../services/achievementService';

const router = Router();

/**
 * GET /gym/status
 * Get player's gym training status
 */
router.get('/status', authenticate, async (req: AuthRequest, res) => {
  const status = await gymService.getStatus(req.player!.id);
  return res.status(200).json({
    success: true,
    status,
  });
});

/**
 * POST /gym/train
 * Train at the gym (1 hour cooldown)
 */
router.post('/train', authenticate, async (req: AuthRequest, res) => {
  const raw = (req.body as { track?: string } | undefined)?.track;
  const track: GymTrainTrack =
    raw === 'speed' || raw === 'stamina' || raw === 'strength' ? raw : 'strength';

  const result = await gymService.train(req.player!.id, track);

  if (!result.success) {
    if (result.error === 'MAX_SESSIONS') {
      return res.status(400).json({
        event: 'gym.error',
        params: { reason: 'MAX_SESSIONS' },
      });
    }
    if (result.error === 'COOLDOWN') {
      return res.status(400).json({
        event: 'gym.error',
        params: {
          reason: 'COOLDOWN',
          nextTrainAt: result.nextTrainAt,
        },
      });
    }
  }

  void checkAndUnlockAchievements(req.player!.id).catch(() => {});

  return res.json({
    event: 'gym.trained',
    params: result.stats,
  });
});

export default router;
