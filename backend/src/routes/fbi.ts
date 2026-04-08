/**
 * FBI Routes - Federal Crime Investigation Endpoints
 */

import { Router, Response } from 'express';
import { authenticate } from '../middleware/authenticate';
import { AuthRequest } from '../middleware/authenticate';
import * as fbiService from '../services/fbiService';
import { worldEventService } from '../services/worldEventService';
import prisma from '../lib/prisma';

const router = Router();

/**
 * POST /fbi/pay-bail
 * Pay federal bail to reduce FBI heat
 */
router.post('/pay-bail', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { id: true, money: true, fbiHeat: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'error.player_not_found',
        params: {},
      });
    }

    if (player.fbiHeat === 0) {
      return res.status(400).json({
        event: 'error.no_fbi_heat',
        params: {},
      });
    }

    const federalBail = fbiService.calculateFederalBail(player.fbiHeat);

    if (player.money < federalBail) {
      return res.status(400).json({
        event: 'error.insufficient_money',
        params: {
          required: federalBail,
          available: player.money,
        },
      });
    }

    // Pay bail
    await fbiService.payFederalBail(playerId);

    await worldEventService.createEvent('fbi.bail_paid', {
      playerId,
      amount: federalBail,
      fbiHeat: player.fbiHeat,
    });

    return res.json({
      event: 'fbi.bail_paid',
      params: {
        amount: federalBail,
        previousFbiHeat: player.fbiHeat,
        newFbiHeat: Math.floor(player.fbiHeat * 0.6),
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.player_not_found',
          params: {},
        });
      }

      if (error.message === 'NO_FBI_HEAT') {
        return res.status(400).json({
          event: 'error.no_fbi_heat',
          params: {},
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          event: 'error.insufficient_money',
          params: {},
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /fbi/status
 * Get FBI investigation status
 */
router.get('/status', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;

    if (!playerId) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { fbiHeat: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'error.player_not_found',
        params: {},
      });
    }

    const federalBail = fbiService.calculateFederalBail(player.fbiHeat);
    const fbiRatio = 5; // 1 FBI agent per 5 heat
    const arrestChance = Math.min((player.fbiHeat / fbiRatio) * 100, 95);

    return res.json({
      event: 'fbi.status',
      params: {
        fbiHeat: player.fbiHeat,
        federalBail,
        arrestChance: Math.round(arrestChance),
      },
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
