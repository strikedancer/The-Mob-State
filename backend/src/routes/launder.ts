import { Router, Response, NextFunction } from 'express';
import { z } from 'zod';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as launderService from '../services/launderService';

const router = Router();

const startSchema = z.object({
  amount: z.number().int().positive(),
});

function mapLaunderError(error: unknown, res: Response, next: NextFunction) {
  if (!(error instanceof Error)) return next(error);
  const map: Record<string, [number, string]> = {
    LAUNDER_DISABLED: [403, 'launder.disabled'],
    INVALID_AMOUNT: [400, 'launder.invalid_amount'],
    LAUNDER_AMOUNT_TOO_LOW: [400, 'launder.amount_too_low'],
    LAUNDER_AMOUNT_TOO_HIGH: [400, 'launder.amount_too_high'],
    LAUNDER_ALREADY_ACTIVE: [409, 'launder.already_active'],
    LAUNDER_COOLDOWN: [429, 'launder.cooldown'],
    INSUFFICIENT_CASH: [400, 'error.insufficient_cash'],
    PLAYER_NOT_FOUND: [404, 'error.player_not_found'],
  };
  const entry = map[error.message];
  if (entry) return res.status(entry[0]).json({ event: entry[1], params: {} });
  return next(error);
}

router.get('/status', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const status = await launderService.getLaunderStatus(req.player!.id);
    return res.json({ event: 'launder.status', params: status });
  } catch (error) {
    return mapLaunderError(error, res, next);
  }
});

router.post('/start', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const body = startSchema.parse(req.body);
    const status = await launderService.startLaunderJob(req.player!.id, body.amount);
    return res.json({ event: 'launder.started', params: status });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return res.status(400).json({ event: 'error.validation', params: { issues: error.issues } });
    }
    return mapLaunderError(error, res, next);
  }
});

export default router;
