import { Router, Response } from 'express';
import { AuthRequest, authenticate } from '../middleware/authenticate';
import * as policeService from '../services/policeService';
import { worldEventService } from '../services/worldEventService';
import prisma from '../lib/prisma';

const router = Router();

/**
 * POST /police/pay-bail
 * Pay bail to reduce wanted level and avoid jail
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

    // Get player's current wanted level
    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { wantedLevel: true, money: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'error.player_not_found',
        params: {},
      });
    }

    if (player.wantedLevel === 0) {
      return res.status(400).json({
        event: 'error.no_wanted_level',
        params: { message: 'You are not wanted' },
      });
    }

    const bail = policeService.calculateBail(player.wantedLevel);

    if (player.money < bail) {
      return res.status(400).json({
        event: 'error.insufficient_money',
        params: {
          required: bail,
          available: player.money,
        },
      });
    }

    // Pay bail
    await policeService.payBail(playerId);

    // Create world event
    await worldEventService.createEvent('police.bail_paid', {
      playerId,
      amount: bail,
      wantedLevel: player.wantedLevel,
    });

    return res.json({
      event: 'police.bail_paid',
      params: {
        amount: bail,
        previousWantedLevel: player.wantedLevel,
        newWantedLevel: Math.floor(player.wantedLevel / 2),
      },
    });
  } catch (error: any) {
    if (error.message === 'PLAYER_NOT_FOUND') {
      return res.status(404).json({
        event: 'error.player_not_found',
        params: {},
      });
    }

    if (error.message === 'INSUFFICIENT_MONEY') {
      return res.status(400).json({
        event: 'error.insufficient_money',
        params: {},
      });
    }

    return res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

/**
 * GET /police/countries
 * Shared police pressure per travel country.
 */
router.get('/countries', authenticate, async (_req: AuthRequest, res: Response) => {
  try {
    const { countryPoliceService } = await import('../services/countryPoliceService');
    const countries = await countryPoliceService.listCountries();
    return res.json({
      event: 'police.countries',
      params: {},
      countries,
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

/**
 * GET /police/status
 * Pressure + modifiers for the player's current country.
 */
router.get('/status', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ event: 'error.unauthorized', params: {} });
    }
    const { countryPoliceService } = await import('../services/countryPoliceService');
    const mods = await countryPoliceService.getModifiersForPlayer(playerId);
    const catalog = countryPoliceService.getDisruptCatalog();
    return res.json({
      event: 'police.status',
      params: {},
      countryPolice: mods,
      disruptActions: catalog,
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

/**
 * POST /police/disrupt
 * Phase 3 rare ops to temporarily cool country pressure.
 */
router.post('/disrupt', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ event: 'error.unauthorized', params: {} });
    }
    const actionType = String(req.body?.actionType || '');
    if (!['corruption', 'distract', 'raid'].includes(actionType)) {
      return res.status(400).json({
        event: 'police.disrupt.error',
        params: { reason: 'INVALID_DISRUPT_ACTION' },
      });
    }

    const { countryPoliceService } = await import('../services/countryPoliceService');
    const result = await countryPoliceService.disrupt({
      playerId,
      actionType: actionType as 'corruption' | 'distract' | 'raid',
    });

    return res.json({
      event: result.success ? 'police.disrupt.success' : 'police.disrupt.failed',
      params: result,
    });
  } catch (error: any) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    if (message.startsWith('ON_COOLDOWN:')) {
      const remainingSeconds = parseInt(message.split(':')[1], 10) || 0;
      return res.status(429).json({
        event: 'error.cooldown',
        params: { remainingSeconds, actionType: 'country_police_disrupt' },
      });
    }
    if (
      [
        'COUNTRY_POLICE_DISABLED',
        'INVALID_DISRUPT_ACTION',
        'RANK_TOO_LOW',
        'CREW_REQUIRED',
        'INSUFFICIENT_MONEY',
        'PLAYER_NOT_FOUND',
      ].includes(message)
    ) {
      return res.status(400).json({
        event: 'police.disrupt.error',
        params: { reason: message },
      });
    }
    return res.status(500).json({
      event: 'error.internal',
      params: { message },
    });
  }
});

/**
 * GET /police/wanted-status
 * Get player's wanted level and arrest risk
 */
router.get('/wanted-status', authenticate, async (req: AuthRequest, res: Response) => {
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
      select: { wantedLevel: true },
    });

    if (!player) {
      return res.status(404).json({
        event: 'error.player_not_found',
        params: {},
      });
    }

    const bail = policeService.calculateBail(player.wantedLevel);
    const arrestChance = Math.min((player.wantedLevel / 10) * 100, 90);

    return res.json({
      event: 'police.wanted_status',
      params: {
        wantedLevel: player.wantedLevel,
        bail,
        arrestChance: Math.round(arrestChance),
      },
    });
  } catch (error: any) {
    return res.status(500).json({
      event: 'error.internal',
      params: { message: error.message },
    });
  }
});

export default router;
