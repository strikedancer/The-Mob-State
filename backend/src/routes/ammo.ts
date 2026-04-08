import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { ammoService } from '../services/ammoService';
import prisma from '../lib/prisma';

const router = Router();

/**
 * GET /ammo/types
 * Get all ammo type definitions
 */
router.get('/types', async (_, res: Response) => {
  const ammoTypes = ammoService.getAllAmmoTypes();

  return res.status(200).json({
    event: 'ammo.types',
    params: {},
    ammoTypes,
  });
});

/**
 * GET /ammo/inventory
 * Get player's ammo inventory
 */
router.get('/inventory', authenticate, async (req: AuthRequest, res: Response) => {
  const ammo = await ammoService.getPlayerAmmo(req.player!.id);

  return res.status(200).json({
    event: 'ammo.inventory',
    params: {},
    ammo,
  });
});

/**
 * GET /ammo/market
 * Get ammo market stock for player's country
 */
router.get('/market', authenticate, async (req: AuthRequest, res: Response) => {
  const player = await prisma.player.findUnique({
    where: { id: req.player!.id },
    select: { currentCountry: true },
  });

  if (!player) {
    return res.status(404).json({
      event: 'error.player_not_found',
      params: {},
    });
  }

  const stock = await ammoService.getMarketStock(player.currentCountry);

  return res.status(200).json({
    event: 'ammo.market',
    params: {},
    countryId: player.currentCountry,
    stock,
  });
});

/**
 * POST /ammo/buy
 * Buy ammo boxes
 * Body: { ammoType: string, boxes: number }
 */
router.post('/buy', authenticate, async (req: AuthRequest, res: Response) => {
  const { ammoType, boxes } = req.body;

  if (!ammoType || !boxes) {
    return res.status(400).json({
      event: 'error.missing_params',
      params: {
        message: 'Missing ammoType or boxes parameter',
      },
    });
  }

  const player = await prisma.player.findUnique({
    where: { id: req.player!.id },
    select: { currentCountry: true },
  });

  if (!player) {
    return res.status(404).json({
      event: 'error.player_not_found',
      params: {},
    });
  }

  const result = await ammoService.buyAmmo(
    req.player!.id,
    String(ammoType),
    Number(boxes),
    player.currentCountry
  );

  if (!result.success) {
    let message = 'Could not buy ammo';
    let statusCode = 400;

    switch (result.error) {
      case 'AMMO_TYPE_NOT_FOUND':
        message = 'Ammo type not found';
        statusCode = 404;
        break;
      case 'INVALID_QUANTITY':
        message = 'Invalid box quantity';
        statusCode = 400;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'You don\'t have enough money to buy this ammo';
        statusCode = 403;
        break;
      case 'MAX_INVENTORY_REACHED':
        message = 'Maximum ammo inventory capacity reached';
        statusCode = 403;
        break;
      case 'INSUFFICIENT_STOCK':
        message = 'Not enough ammo stock in this country';
        statusCode = 409;
        break;
      case 'PURCHASE_COOLDOWN_ACTIVE':
        message = 'You must wait 30 minutes after your last ammo purchase';
        statusCode = 429;
        // Include nextAvailableAt timestamp
        return res.status(statusCode).json({
          event: 'error.ammo_purchase_cooldown',
          params: {
            reason: result.error,
            message,
            nextAvailableAt: result.nextAvailableAt,
          },
        });
    }

    return res.status(statusCode).json({
      event: 'error.ammo_purchase',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'ammo.purchased',
    params: {
      ammoType,
      roundsPurchased: result.roundsPurchased,
      totalCost: result.totalCost,
      quality: result.quality,
    },
  });
});

/**
 * POST /ammo/sell
 * Sell ammo
 * Body: { ammoType: string, quantity: number }
 */
router.post('/sell', authenticate, async (req: AuthRequest, res: Response) => {
  const { ammoType, quantity } = req.body;

  if (!ammoType || !quantity) {
    return res.status(400).json({
      event: 'error.missing_params',
      params: {
        message: 'Missing ammoType or quantity parameter',
      },
    });
  }

  const result = await ammoService.sellAmmo(req.player!.id, String(ammoType), Number(quantity));

  if (!result.success) {
    let message = 'Could not sell ammo';
    let statusCode = 400;

    switch (result.error) {
      case 'AMMO_TYPE_NOT_FOUND':
        message = 'Ammo type not found';
        statusCode = 404;
        break;
      case 'INVALID_QUANTITY':
        message = 'Invalid quantity';
        statusCode = 400;
        break;
      case 'INSUFFICIENT_AMMO':
        message = 'You don\'t have enough ammo to sell';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.ammo_sale',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'ammo.sold',
    params: {
      sellPrice: result.sellPrice,
    },
  });
});

export default router;
