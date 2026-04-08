import { Router, Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { checkCooldown } from '../middleware/checkCooldown';
import * as heistService from '../services/heistService';
import * as crewService from '../services/crewService';
import * as policeService from '../services/policeService';
import * as cooldownService from '../services/cooldownService';

const router = Router();

/**
 * GET /heists
 * Get all available heists
 */
router.get('/', async (_req, res: Response, next: NextFunction) => {
  try {
    const heists = heistService.getAvailableHeists();

    return res.json({
      event: 'heists.list',
      params: { heists },
    });
  } catch (error: unknown) {
    return next(error);
  }
});

/**
 * GET /heists/:id
 * Get heist details by ID
 */
router.get('/:id', async (req, res: Response, next: NextFunction) => {
  try {
    const heistId = req.params.id as string;
    const heist = heistService.getHeistById(heistId);

    if (!heist) {
      return res.status(404).json({
        event: 'error.heist_not_found',
        params: {},
      });
    }

    return res.json({
      event: 'heist.info',
      params: { heist },
    });
  } catch (error: unknown) {
    return next(error);
  }
});

/**
 * GET /heists/crew/:crewId
 * Get available heists for a specific crew
 */
router.get('/crew/:crewId', async (req, res: Response, next: NextFunction) => {
  try {
    const crewId = parseInt(req.params.crewId as string);

    if (isNaN(crewId)) {
      return res.status(400).json({
        event: 'error.invalid_crew_id',
        params: {},
      });
    }

    const heists = await heistService.getHeistsForCrew(crewId);

    return res.json({
      event: 'heists.crew_available',
      params: { heists },
    });
  } catch (error: unknown) {
    if (error instanceof Error) {
      if (error.message === 'CREW_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.crew_not_found',
          params: {},
        });
      }
    }
    return next(error);
  }
});

/**
 * POST /heists/:id/start
 * Start a heist with the player's crew
 */
router.post(
  '/:id/start',
  authenticate,
  checkCooldown('heist'),
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const heistId = req.params.id as string;
      const playerId = req.player!.id;

      // Get player's crew
      const playerCrew = await crewService.getPlayerCrew(playerId);
      if (!playerCrew) {
        return res.status(400).json({
          event: 'error.not_in_crew',
          params: {},
        });
      }

      const result = await heistService.startHeist(heistId, playerCrew.id, playerId);
      
      // Set cooldown after heist attempt
      await cooldownService.setCooldown(playerId, 'heist');

      if (result.success) {
        return res.json({
          event: result.sabotaged ? 'heist.success_sabotaged' : 'heist.success',
          params: {
            payout: result.payout,
            xpGained: result.xpGained,
            sabotaged: result.sabotaged,
            sabotagedBy: result.sabotagedBy,
          },
        });
      } else {
        return res.json({
          event: result.sabotaged ? 'heist.failure_sabotaged' : 'heist.failure',
          params: {
            jailTime: result.jailTime,
            sabotaged: result.sabotaged,
            sabotagedBy: result.sabotagedBy,
          },
        });
      }
    } catch (error: unknown) {
      if (error instanceof Error) {
        if (error.message === 'HEIST_NOT_FOUND') {
          return res.status(404).json({
            event: 'error.heist_not_found',
            params: {},
          });
        }
        if (error.message === 'NOT_CREW_LEADER') {
          return res.status(403).json({
            event: 'error.not_crew_leader',
            params: {},
          });
        }
        if (error.message === 'INSUFFICIENT_CREW_MEMBERS') {
          return res.status(400).json({
            event: 'error.insufficient_crew_members',
            params: {},
          });
        }
        if (error.message === 'CREW_MEMBER_IN_JAIL') {
          return res.status(400).json({
            event: 'error.crew_member_in_jail',
            params: {},
          });
        }
        if (error.message === 'NOT_IN_CREW') {
          return res.status(400).json({
            event: 'error.not_in_crew',
            params: {},
          });
        }
      }
      return next(error);
    }
  }
);

/**
 * GET /heists/crew/:crewId/jailed
 * Get all jailed members of a crew
 */
router.get(
  '/crew/:crewId/jailed',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const crewId = parseInt(req.params.crewId as string, 10);

      // Get crew with members
      const crew = await crewService.getCrewById(crewId);

      // Check jail status for each member (we'll just return playerIds for now)
      const jailedMembers = [];
      for (const member of crew.members) {
        const jailTime = await policeService.checkIfJailed(member.playerId);
        if (jailTime > 0) {
          jailedMembers.push({
            playerId: member.playerId,
            jailTime,
          });
        }
      }

      return res.json({
        success: true,
        jailedMembers,
      });
    } catch (error: any) {
      return next(error);
    }
  }
);

export default router;
