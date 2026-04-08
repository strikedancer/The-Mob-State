/**
 * Trade Routes - Phase 9.2
 *
 * API endpoints for buying and selling contraband.
 */

import express, { Request, Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as tradeService from '../services/tradeService';

const router = express.Router();

/**
 * GET /trade/goods
 * Get all available tradable goods (unauthenticated)
 */
router.get('/goods', async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const goods = tradeService.getAllGoods();
    return res.json({
      success: true,
      goods,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * GET /trade/prices
 * Get current prices for all goods in player's country (authenticated)
 */
router.get('/prices', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ error: 'Not authenticated' });
    }

    const prices = await tradeService.getCurrentPrices(playerId);
    return res.json({
      success: true,
      prices,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * GET /trade/inventory
 * Get player's inventory (authenticated)
 */
router.get(
  '/inventory',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const inventory = await tradeService.getFullInventory(playerId);
      return res.json({
        success: true,
        inventory,
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * POST /trade/buy
 * Buy goods in current country (authenticated)
 */
router.post('/buy', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ error: 'Not authenticated' });
    }

    const { goodType, quantity } = req.body;

    if (!goodType || !quantity) {
      return res.status(400).json({
        success: false,
        error: 'MISSING_PARAMETERS',
        message: 'goodType en quantity zijn verplicht.',
      });
    }

    const result = await tradeService.buyGoods(playerId, goodType, quantity);

    return res.json({
      message: `Je hebt ${quantity}x ${result.goodName} gekocht voor €${result.totalCost.toLocaleString()}!`,
      ...result,
    });
  } catch (error: any) {
    // Handle specific trade errors
    if (error.message === 'INVALID_QUANTITY') {
      return res.status(400).json({
        success: false,
        error: 'INVALID_QUANTITY',
        message: 'Hoeveelheid moet een positief geheel getal zijn.',
      });
    }

    if (error.message === 'INVALID_GOOD_TYPE') {
      return res.status(400).json({
        success: false,
        error: 'INVALID_GOOD_TYPE',
        message: 'Dit product bestaat niet.',
      });
    }

    if (error.message === 'INSUFFICIENT_MONEY') {
      return res.status(400).json({
        success: false,
        error: 'INSUFFICIENT_MONEY',
        message: 'Je hebt niet genoeg geld voor deze aankoop.',
      });
    }

    if (error.message === 'INVENTORY_FULL') {
      return res.status(400).json({
        success: false,
        error: 'INVENTORY_FULL',
        message: 'Je inventaris is vol. Verkoop eerst items voordat je meer koopt.',
      });
    }

    return next(error);
  }
});

/**
 * POST /trade/sell
 * Sell goods in current country (authenticated)
 */
router.post('/sell', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ error: 'Not authenticated' });
    }

    const { goodType, quantity } = req.body;

    if (!goodType || !quantity) {
      return res.status(400).json({
        success: false,
        error: 'MISSING_PARAMETERS',
        message: 'goodType en quantity zijn verplicht.',
      });
    }

    const result = await tradeService.sellGoods(playerId, goodType, quantity);

    return res.json({
      message: `Je hebt ${quantity}x ${result.goodName} verkocht voor €${result.totalCost.toLocaleString()}!`,
      ...result,
    });
  } catch (error: any) {
    // Handle specific trade errors
    if (error.message === 'INVALID_QUANTITY') {
      return res.status(400).json({
        success: false,
        error: 'INVALID_QUANTITY',
        message: 'Hoeveelheid moet een positief geheel getal zijn.',
      });
    }

    if (error.message === 'INVALID_GOOD_TYPE') {
      return res.status(400).json({
        success: false,
        error: 'INVALID_GOOD_TYPE',
        message: 'Dit product bestaat niet.',
      });
    }

    if (error.message === 'INSUFFICIENT_INVENTORY') {
      return res.status(400).json({
        success: false,
        error: 'INSUFFICIENT_INVENTORY',
        message: 'Je hebt niet genoeg van dit product in je inventaris.',
      });
    }

    return next(error);
  }
});

export default router;
