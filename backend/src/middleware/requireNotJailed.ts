import { Response, NextFunction } from 'express';
import { AuthRequest } from './authenticate';
import { checkIfJailed } from '../services/policeService';

/**
 * Block black-market and similar street actions while the player is in jail.
 * Gym training is intentionally not gated here.
 */
export async function requireNotJailed(req: AuthRequest, res: Response, next: NextFunction) {
  try {
    if (!req.player) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const remainingTime = await checkIfJailed(req.player.id);
    if (remainingTime > 0) {
      return res.status(403).json({
        event: 'error.jailed',
        params: { remainingTime },
      });
    }

    return next();
  } catch (error) {
    return next(error);
  }
}
