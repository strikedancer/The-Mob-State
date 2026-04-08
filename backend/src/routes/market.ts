/**
 * Phase 12.4: Black Market Routes
 * API endpoints for vehicle marketplace
 */

import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { blackMarketService } from '../services/blackMarketService';

const router = Router();

/**
 * GET /market/vehicles
 * Get all vehicles for sale on the market
 */
router.get('/vehicles', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { country } = req.query;
    const listings = await blackMarketService.getMarketListings(
      country as string | undefined
    );

    return res.status(200).json({
      event: 'market.listings',
      params: { country: country || 'all' },
      listings,
    });
  } catch (error) {
    console.error('Get market listings error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /market/my-listings
 * Get player's own market listings
 */
router.get('/my-listings', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const listings = await blackMarketService.getPlayerListings(req.player!.id);

    return res.status(200).json({
      event: 'market.my_listings',
      params: {},
      listings,
    });
  } catch (error) {
    console.error('Get player listings error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /market/list/:inventoryId
 * List a vehicle for sale on the market
 */
router.post('/list/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);
    const { askingPrice } = req.body;

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (!askingPrice || typeof askingPrice !== 'number' || askingPrice <= 0) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_ASKING_PRICE' },
      });
    }

    const result = await blackMarketService.listVehicle(
      req.player!.id,
      inventoryId,
      askingPrice
    );

    if (!result.success) {
      return res.status(400).json({
        event: 'market.list_failed',
        params: {
          reason: result.message,
        },
      });
    }

    return res.status(200).json({
      event: 'market.listed',
      params: {
        inventoryId,
        askingPrice,
        message: result.message,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'market.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'market.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'ALREADY_LISTED') {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: 'ALREADY_LISTED' },
        });
      }

      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: 'INVALID_VEHICLE' },
        });
      }
    }

    console.error('List vehicle error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /market/delist/:inventoryId
 * Remove vehicle from market listing
 */
router.post('/delist/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    const result = await blackMarketService.delistVehicle(req.player!.id, inventoryId);

    return res.status(200).json({
      event: 'market.delisted',
      params: {
        inventoryId,
        message: result.message,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'market.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'market.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'NOT_LISTED') {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: 'NOT_LISTED' },
        });
      }
    }

    console.error('Delist vehicle error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /market/buy/:inventoryId
 * Buy a vehicle from the market
 */
router.post('/buy/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    const result = await blackMarketService.buyVehicle(req.player!.id, inventoryId);

    return res.status(200).json({
      event: 'market.purchased',
      params: {
        inventoryId,
        purchasePrice: result.purchasePrice,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'market.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_FOR_SALE') {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: 'NOT_FOR_SALE' },
        });
      }

      if (error.message === 'CANNOT_BUY_OWN_VEHICLE') {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: 'CANNOT_BUY_OWN_VEHICLE' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'market.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    console.error('Buy vehicle error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

// Get all market listings for a specific player
router.get('/player/:playerId/listings', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = parseInt(req.params.playerId as string, 10);

    const listings = await blackMarketService.getPlayerListings(playerId);

    return res.status(200).json({
      event: 'market.player_listings',
      params: {},
      listings,
    });
  } catch (error) {
    console.error('Get player listings error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
