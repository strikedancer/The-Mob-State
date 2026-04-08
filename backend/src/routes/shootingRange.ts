import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { shootingRangeService } from '../services/shootingRangeService';

const router = Router();

/**
 * GET /shooting-range/status
 */
router.get('/status', authenticate, async (req: AuthRequest, res: Response) => {
  const status = await shootingRangeService.getStatus(req.player!.id);

  return res.status(200).json({
    success: true,
    status,
  });
});

/**
 * POST /shooting-range/train
 */
router.post('/train', authenticate, async (req: AuthRequest, res: Response) => {
  const result = await shootingRangeService.train(req.player!.id);

  if (!result.success) {
    let message = 'Could not train';
    let statusCode = 400;

    switch (result.error) {
      case 'MAX_SESSIONS':
        message = 'Maximum training sessions reached';
        statusCode = 400;
        break;
      case 'COOLDOWN':
        message = 'Training is on cooldown';
        statusCode = 429;
        break;
    }

    return res.status(statusCode).json({
      success: false,
      error: result.error,
      message,
      nextTrainAt: (result as any).nextTrainAt,
    });
  }

  return res.status(200).json({
    success: true,
    stats: result.stats,
  });
});

export default router;
