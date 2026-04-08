import { Router, Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { activityService } from '../services/activityService';

const router = Router();

/**
 * GET /activities/feed
 * Get activity feed from friends
 */
router.get(
  '/feed',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;
      const limit = parseInt(req.query.limit as string) || 20;

      const activities = await activityService.getFriendActivityFeed(
        playerId,
        limit
      );

      return res.json({
        event: 'activities.feed.loaded',
        params: { activities },
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * GET /activities/me
 * Get own activity history
 */
router.get(
  '/me',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;
      const limit = parseInt(req.query.limit as string) || 50;

      const activities = await activityService.getPlayerActivities(
        playerId,
        limit
      );

      return res.json({
        event: 'activities.me.loaded',
        params: { activities },
      });
    } catch (error) {
      return next(error);
    }
  }
);

export default router;
