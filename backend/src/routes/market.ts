/**
 * Phase 12.4: Black Market Routes
 * API endpoints for vehicle marketplace
 */

import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { blackMarketService } from '../services/blackMarketService';
import { playerMarketplaceService } from '../services/playerMarketplaceService';

const router = Router();

/** Failures a player can cause while creating a listing, echoed back as-is. */
const LIST_ERROR_REASONS = new Set([
  'TOOL_NOT_FOUND',
  'TOOL_NOT_CARRIED',
  'TOOL_BROKEN',
  'ALREADY_LISTED',
  'INVALID_TOOL',
  'INVALID_QUANTITY',
  'INSUFFICIENT_QTY',
  'DRUG_NOT_FOUND',
  'CRYPTO_NOT_ENOUGH',
  'CRYPTO_ASSET_NOT_FOUND',
  'TRADE_GOOD_NOT_FOUND',
  'INVALID_GOOD',
  'UNSUPPORTED_KIND',
]);

function handleListError(res: Response, error: unknown, logLabel: string): Response {
  if (error instanceof Error && LIST_ERROR_REASONS.has(error.message)) {
    return res.status(400).json({
      event: 'market.error',
      params: { reason: error.message },
    });
  }
  console.error(`${logLabel}:`, error);
  return res.status(500).json({
    event: 'error.internal',
    params: {},
  });
}

function parsePositiveInt(value: unknown): number | null {
  const parsed = parseInt(String(value ?? ''), 10);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : null;
}

function parsePrice(value: unknown): number | null {
  if (typeof value !== 'number' || !Number.isFinite(value) || value <= 0) {
    return null;
  }
  return Math.floor(value);
}

/**
 * GET /market/unified
 * Vehicles plus all player-item listings (tools, drug lots, crypto lots, trade goods).
 */
router.get('/unified', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { country } = req.query;
    const countryStr = typeof country === 'string' ? country : undefined;
    const [listings, itemListings] = await Promise.all([
      blackMarketService.getMarketListings(countryStr),
      playerMarketplaceService.getActiveItemListings(countryStr),
    ]);

    return res.status(200).json({
      event: 'market.unified_listings',
      params: { country: countryStr || 'all' },
      listings,
      itemListings,
    });
  } catch (error) {
    console.error('Get unified market listings error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

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
    const playerId = req.player!.id;
    const [listings, itemListings] = await Promise.all([
      blackMarketService.getPlayerListings(playerId),
      playerMarketplaceService.getSellerActiveListings(playerId),
    ]);

    return res.status(200).json({
      event: 'market.my_listings',
      params: {},
      listings,
      itemListings,
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
 * POST /market/list-tool
 * Body: { playerToolId: number, price: number }
 */
router.post('/list-tool', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerToolId = parsePositiveInt(req.body?.playerToolId);
    const price = parsePrice(req.body?.price);

    if (playerToolId === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_PLAYER_TOOL_ID' },
      });
    }

    if (price === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_PRICE' },
      });
    }

    const result = await playerMarketplaceService.listPlayerTool(
      req.player!.id,
      playerToolId,
      price,
    );

    if (!result.success) {
      return res.status(400).json({
        event: 'market.list_failed',
        params: { message: result.message },
      });
    }

    return res.status(200).json({
      event: 'market.tool_listed',
      params: { playerToolId, price, listingId: result.listingId },
    });
  } catch (error) {
    return handleListError(res, error, 'List tool error');
  }
});

/**
 * POST /market/list-drug
 * Body: { drugInventoryId: number, quantity: number, price: number }
 * Escrows grams out of the seller's drug inventory until sold or delisted.
 */
router.post('/list-drug', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const drugInventoryId = parsePositiveInt(req.body?.drugInventoryId);
    const quantity = parsePositiveInt(req.body?.quantity);
    const price = parsePrice(req.body?.price);

    if (drugInventoryId === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_DRUG_INVENTORY_ID' },
      });
    }

    if (quantity === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_QUANTITY' },
      });
    }

    if (price === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_PRICE' },
      });
    }

    const result = await playerMarketplaceService.listDrugLot(
      req.player!.id,
      drugInventoryId,
      quantity,
      price,
    );

    if (!result.success) {
      return res.status(400).json({
        event: 'market.list_failed',
        params: { message: result.message },
      });
    }

    return res.status(200).json({
      event: 'market.drug_listed',
      params: { drugInventoryId, quantity, price, listingId: result.listingId },
    });
  } catch (error) {
    return handleListError(res, error, 'List drug lot error');
  }
});

/**
 * POST /market/list-crypto
 * Body: { assetSymbol: string, quantity: number|string, price: number }
 * Escrows a decimal amount out of the seller's holdings until sold or delisted.
 */
router.post('/list-crypto', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const assetSymbol = String(req.body?.assetSymbol ?? '').trim().toUpperCase();
    const quantity = Number(req.body?.quantity);
    const price = parsePrice(req.body?.price);

    if (!assetSymbol) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_ASSET_SYMBOL' },
      });
    }

    if (!Number.isFinite(quantity) || quantity <= 0) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_QUANTITY' },
      });
    }

    if (price === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_PRICE' },
      });
    }

    const result = await playerMarketplaceService.listCryptoLot(
      req.player!.id,
      assetSymbol,
      quantity,
      price,
    );

    if (!result.success) {
      return res.status(400).json({
        event: 'market.list_failed',
        params: { message: result.message },
      });
    }

    return res.status(200).json({
      event: 'market.crypto_listed',
      params: { assetSymbol, quantity, price, listingId: result.listingId },
    });
  } catch (error) {
    return handleListError(res, error, 'List crypto lot error');
  }
});

/**
 * POST /market/list-trade-good
 * Body: { inventoryId: number, quantity: number, price: number }
 * Escrows units out of the seller's trade inventory until sold or delisted.
 */
router.post('/list-trade-good', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parsePositiveInt(req.body?.inventoryId);
    const quantity = parsePositiveInt(req.body?.quantity);
    const price = parsePrice(req.body?.price);

    if (inventoryId === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (quantity === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_QUANTITY' },
      });
    }

    if (price === null) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_PRICE' },
      });
    }

    const result = await playerMarketplaceService.listTradeGoodLot(
      req.player!.id,
      inventoryId,
      quantity,
      price,
    );

    if (!result.success) {
      return res.status(400).json({
        event: 'market.list_failed',
        params: { message: result.message },
      });
    }

    return res.status(200).json({
      event: 'market.trade_good_listed',
      params: { inventoryId, quantity, price, listingId: result.listingId },
    });
  } catch (error) {
    return handleListError(res, error, 'List trade good lot error');
  }
});

/**
 * POST /market/delist-item/:listingId
 * Cancels a player market listing (non-vehicle) and returns any escrow.
 */
router.post('/delist-item/:listingId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const listingId = parseInt(req.params.listingId as string, 10);
    if (!Number.isFinite(listingId)) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_LISTING_ID' },
      });
    }

    await playerMarketplaceService.delist(req.player!.id, listingId);

    return res.status(200).json({
      event: 'market.item_delisted',
      params: { listingId },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'LISTING_NOT_FOUND') {
        return res.status(404).json({
          event: 'market.error',
          params: { reason: 'LISTING_NOT_FOUND' },
        });
      }
      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'market.error',
          params: { reason: 'NOT_OWNER' },
        });
      }
      const bad400: Record<string, string> = {
        NOT_ACTIVE: 'NOT_ACTIVE',
        UNSUPPORTED_KIND: 'UNSUPPORTED_KIND',
        INVALID_GOOD: 'INVALID_GOOD',
      };
      if (bad400[error.message]) {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: bad400[error.message] },
        });
      }
    }
    console.error('Delist item error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /market/buy-item/:listingId
 * Purchase a non-vehicle listing (tool, drug lot, crypto lot or trade good lot).
 */
router.post('/buy-item/:listingId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const listingId = parseInt(req.params.listingId as string, 10);
    if (!Number.isFinite(listingId)) {
      return res.status(400).json({
        event: 'market.error',
        params: { reason: 'INVALID_LISTING_ID' },
      });
    }

    const result = await playerMarketplaceService.buyListing(req.player!.id, listingId);

    return res.status(200).json({
      event: 'market.item_purchased',
      params: {
        listingId,
        purchasePrice: result.purchasePrice,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      const msg = error.message;
      const bad400: Record<string, string> = {
        NOT_FOR_SALE: 'NOT_FOR_SALE',
        CANNOT_BUY_OWN: 'CANNOT_BUY_OWN',
        INSUFFICIENT_FUNDS: 'INSUFFICIENT_FUNDS',
        INVENTORY_FULL: 'INVENTORY_FULL',
        LISTING_STALE: 'LISTING_STALE',
        TRADE_CAPACITY: 'TRADE_CAPACITY',
        INSUFFICIENT_QTY: 'INSUFFICIENT_QTY',
        CRYPTO_NOT_ENOUGH: 'CRYPTO_NOT_ENOUGH',
        INVALID_GOOD: 'INVALID_GOOD',
        INVALID_QUANTITY: 'INVALID_QUANTITY',
        UNSUPPORTED_KIND: 'UNSUPPORTED_KIND',
      };
      if (bad400[msg]) {
        return res.status(400).json({
          event: 'market.error',
          params: { reason: bad400[msg] },
        });
      }
      if (msg === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'market.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }
    }
    console.error('Buy item error:', error);
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
