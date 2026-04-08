import { Router, Request, Response } from 'express';
import nightclubService from '../services/nightclubService';
import { authenticate, AuthRequest } from '../middleware/authenticate';

const router = Router();

// ═══════════════════════════════════════════════════════════════════════════════════════
// VENUE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════

/**
 * GET /mine
 * Get all nightclub venues owned by current player
 */
router.get('/mine', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });
    const venues = await nightclubService.getPlayerVenues(playerId);
    res.json({ success: true, data: venues });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * GET /leaderboard
 * Query: ?scope=global|country&limit=10
 */
router.get('/leaderboard', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });

    const scope = (req.query.scope?.toString() ?? 'global').toLowerCase();
    const limit = Math.max(1, Math.min(Number(req.query.limit ?? 10), 50));

    let country: string | undefined;
    if (scope === 'country') {
      const playerCountry = await nightclubService.getPlayerCountry(playerId);
      country = playerCountry ?? undefined;
    }

    const leaderboard = await nightclubService.getTopNightclubs(limit, country);
    res.json({
      success: true,
      data: leaderboard,
      meta: {
        scope,
        country: country ?? null,
        limit,
      },
    });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * GET /season
 * Current weekly season summary and recent rewards
 */
router.get('/season', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });

    const data = await nightclubService.getSeasonSummary(playerId);
    res.json({ success: true, data });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * POST /setup
 * Create nightclub venue for an owned nightclub property (idempotent)
 * Body: { propertyId }
 */
router.post('/setup', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });
    const { propertyId } = req.body;
    if (!propertyId) {
      return res.status(400).json({ success: false, message: 'Missing propertyId' });
    }

    const result = await nightclubService.setupNightclubForProperty(playerId, Number(propertyId));
    if (result.success) {
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * GET /:venueId/stats
 * Get detailed statistics for a nightclub
 */
router.get('/:venueId/stats', authenticate, async (req: Request, res: Response) => {
  try {
    const venueId = parseInt(req.params.venueId);

    const stats = await nightclubService.getVenueStats(venueId);
    
    if (!stats) {
      return res.status(404).json({ success: false, message: 'Nachtclub niet gevonden' });
    }

    res.json({ success: true, data: stats });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

// ═══════════════════════════════════════════════════════════════════════════════════════
// DJ MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════

/**
 * GET /dj/available
 * Get list of available DJs
 */
router.get('/dj/available', authenticate, async (req: Request, res: Response) => {
  try {
    const djs = await nightclubService.getAvailableDJs();
    res.json({ success: true, data: djs });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * POST /:venueId/dj/hire
 * Hire a DJ for a venue
 * Body: { djId, hoursCount, startTime }
 */
router.post('/:venueId/dj/hire', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });
    const venueId = parseInt(req.params.venueId);
    const { djId, hoursCount, startTime } = req.body;

    if (!djId || !hoursCount) {
      return res.status(400).json({ success: false, message: 'Missing djId or hoursCount' });
    }

    const result = await nightclubService.hireDJ(
      playerId,
      venueId,
      djId,
      hoursCount,
      new Date(startTime)
    );

    if (result.success) {
      res.json(result);
    } else {
      res.status(400).json(result);
    }
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

// ═══════════════════════════════════════════════════════════════════════════════════════
// SECURITY MANAGEMENT
// ═══════════════════════════════════════════════════════════════════════════════════════

/**
 * GET /security/available
 * Get list of available security guards
 */
router.get('/security/available', authenticate, async (req: Request, res: Response) => {
  try {
    const guards = await nightclubService.getAvailableSecurityGuards();
    res.json({ success: true, data: guards });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * POST /:venueId/security/hire
 * Hire security for a night
 * Body: { guardId, shiftDate }
 */
router.post('/:venueId/security/hire', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });
    const venueId = parseInt(req.params.venueId);
    const { guardId, shiftDate } = req.body;

    if (!guardId || !shiftDate) {
      return res.status(400).json({ success: false, message: 'Missing guardId or shiftDate' });
    }

    const result = await nightclubService.hireSecurityGuard(
      playerId,
      venueId,
      guardId,
      new Date(shiftDate)
    );

    if (result.success) {
      res.json(result);
    } else {
      res.status(400).json(result);
    }
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

// ═══════════════════════════════════════════════════════════════════════════════════════
// DRUG INVENTORY
// ═══════════════════════════════════════════════════════════════════════════════════════

/**
 * POST /:venueId/drugs/store
 * Store drugs in the nightclub
 * Body: { drugType, quality, quantity }
 */
router.post('/:venueId/drugs/store', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });
    const venueId = parseInt(req.params.venueId);
    const { drugType, quality, quantity } = req.body;

    if (!drugType || !quality || !quantity) {
      return res.status(400).json({ success: false, message: 'Missing required fields' });
    }

    const result = await nightclubService.storeDrugsInNightclub(
      playerId,
      venueId,
      drugType,
      quality,
      quantity
    );

    if (result.success) {
      res.json(result);
    } else {
      res.status(400).json(result);
    }
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

// ═══════════════════════════════════════════════════════════════════════════════════════
// PROSTITUTE STAFFING
// ═══════════════════════════════════════════════════════════════════════════════════════

/**
 * GET /:venueId/prostitutes/available
 * Get assignable prostitutes for this venue
 */
router.get('/:venueId/prostitutes/available', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });

    const venueId = parseInt(req.params.venueId);
    const data = await nightclubService.getAssignableProstitutes(playerId, venueId);
    res.json({ success: true, data });
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * POST /:venueId/prostitutes/assign
 * Body: { prostituteId }
 */
router.post('/:venueId/prostitutes/assign', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });

    const venueId = parseInt(req.params.venueId);
    const { prostituteId } = req.body;
    if (!prostituteId) {
      return res.status(400).json({ success: false, message: 'Missing prostituteId' });
    }

    const result = await nightclubService.assignProstituteToVenue(playerId, venueId, Number(prostituteId));
    if (result.success) {
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

/**
 * POST /:venueId/prostitutes/unassign
 * Body: { prostituteId }
 */
router.post('/:venueId/prostitutes/unassign', authenticate, async (req: Request, res: Response) => {
  try {
    const playerId = (req as AuthRequest).player?.id;
    if (!playerId) return res.status(401).json({ success: false, message: 'Unauthorized' });

    const venueId = parseInt(req.params.venueId);
    const { prostituteId } = req.body;
    if (!prostituteId) {
      return res.status(400).json({ success: false, message: 'Missing prostituteId' });
    }

    const result = await nightclubService.unassignProstituteFromVenue(playerId, venueId, Number(prostituteId));
    if (result.success) {
      return res.json(result);
    }

    return res.status(400).json(result);
  } catch (err) {
    res.status(500).json({ success: false, message: (err as any).message });
  }
});

export default router;
