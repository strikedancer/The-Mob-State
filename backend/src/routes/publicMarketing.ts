import { Router, Request, Response } from 'express';
import { createRateLimiter } from '../middleware/rateLimit';
import { leaderboardService } from '../services/leaderboardService';
import { getLeaderboard as getTerritoryCrewLeaderboard } from '../services/territoryService';

const router = Router();

const publicHomeLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 40,
  message: 'PUBLIC_HOME_RATE_LIMIT',
  keyGenerator: (req) => {
    const ip = req.ip || req.socket.remoteAddress || 'unknown';
    return `public_home:${ip}`;
  },
});

/**
 * GET /public/home
 * Read-only marketing payload (no auth). Safe fields only.
 */
router.get('/home', publicHomeLimiter, async (_req: Request, res: Response) => {
  try {
    const playerLimit = 10;
    const crewLimit = 10;

    const [rawPlayers, rawCrews] = await Promise.all([
      leaderboardService.getLeaderboard('all_time', playerLimit, undefined),
      getTerritoryCrewLeaderboard(),
    ]);

    const topPlayers = rawPlayers.map((p) => ({
      rank: p.rank,
      username: p.username,
    }));

    const topCrews = rawCrews.slice(0, crewLimit).map((c, i) => ({
      rank: i + 1,
      crewName: c.crewName,
      regionsOwned: c.regionsOwned,
    }));

    return res.json({
      success: true,
      data: {
        topPlayers,
        topCrews,
      },
    });
  } catch (error) {
    console.error('[public/home] error:', error);
    return res.status(500).json({
      success: false,
      event: 'public.home_failed',
      params: {},
    });
  }
});

export default router;
