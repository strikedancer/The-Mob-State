import { Response, NextFunction } from 'express';
import { AuthRequest } from './authenticate';
import * as cooldownService from '../services/cooldownService';

/**
 * Middleware to check if an action is on cooldown
 * @param actionType - Type of action to check cooldown for
 */
export function checkCooldown(actionType: 'crime' | 'job' | 'travel' | 'heist' | 'appeal') {
  return async (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.player) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const playerId = req.player.id;
    const remainingSeconds = await cooldownService.checkCooldown(playerId, actionType);

    if (remainingSeconds > 0) {
      return res.status(429).json({
        event: 'error.cooldown',
        params: {
          actionType,
          remainingSeconds,
          message: `You must wait ${remainingSeconds} seconds before performing this action again`,
        },
      });
    }

    // No cooldown, proceed
    return next();
  };
}
