import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { intensiveCareService } from '../services/intensiveCareService';

const router = Router();

// Get ICU status
router.get('/status', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const status = await intensiveCareService.getICUStatus(req.player!.id);

    return res.status(200).json({
      event: 'icu.status',
      data: status,
    });
  } catch (error) {
    console.error('ICU status error:', error);
    return res.status(500).json({
      event: 'icu.error',
      params: { reason: 'UNKNOWN_ERROR' },
    });
  }
});

export default router;
