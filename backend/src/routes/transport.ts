/**
 * Phase 12.4: Advanced Transport Routes
 * API endpoints for vehicle transport (ship/fly/drive)
 */

import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { transportService } from '../services/transportService';

const router = Router();

/**
 * POST /transport/ship/:inventoryId
 * Ship a boat to another country (24h delay, €5000)
 */
router.post('/ship/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);
    const { destinationCountry } = req.body;

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'transport.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (!destinationCountry) {
      return res.status(400).json({
        event: 'transport.error',
        params: { reason: 'MISSING_DESTINATION' },
      });
    }

    return res.status(410).json({
      event: 'transport.disabled',
      params: {
        reason: 'USE_SMUGGLING_HUB',
        message: 'Direct transport is uitgeschakeld. Gebruik de Smokkel Hub.',
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'transport.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'transport.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'ONLY_BOATS_CAN_BE_SHIPPED') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'ONLY_BOATS_CAN_BE_SHIPPED' },
        });
      }

      if (error.message === 'ALREADY_AT_DESTINATION') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'ALREADY_AT_DESTINATION' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'transport.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    console.error('Ship vehicle error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /transport/fly/:inventoryId
 * Fly a car to another country (instant, €15000)
 */
router.post('/fly/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);
    const { destinationCountry } = req.body;

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'transport.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (!destinationCountry) {
      return res.status(400).json({
        event: 'transport.error',
        params: { reason: 'MISSING_DESTINATION' },
      });
    }

    return res.status(410).json({
      event: 'transport.disabled',
      params: {
        reason: 'USE_SMUGGLING_HUB',
        message: 'Direct transport is uitgeschakeld. Gebruik de Smokkel Hub.',
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'transport.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'transport.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'ONLY_CARS_CAN_BE_FLOWN') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'ONLY_CARS_CAN_BE_FLOWN' },
        });
      }

      if (error.message === 'ALREADY_AT_DESTINATION') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'ALREADY_AT_DESTINATION' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'transport.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    console.error('Fly vehicle error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /transport/drive/:inventoryId
 * Drive/sail vehicle to another country (free, uses fuel, has risk)
 */
router.post('/drive/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);
    const { destinationCountry } = req.body;

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'transport.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (!destinationCountry) {
      return res.status(400).json({
        event: 'transport.error',
        params: { reason: 'MISSING_DESTINATION' },
      });
    }

    return res.status(410).json({
      event: 'transport.disabled',
      params: {
        reason: 'USE_SMUGGLING_HUB',
        message: 'Direct transport is uitgeschakeld. Gebruik de Smokkel Hub.',
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'transport.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'transport.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'ALREADY_AT_DESTINATION') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'ALREADY_AT_DESTINATION' },
        });
      }

      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'INVALID_VEHICLE' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUEL') {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'INSUFFICIENT_FUEL' },
        });
      }
    }

    console.error('Drive vehicle error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /transport/calculate-arbitrage/:inventoryId
 * Calculate potential profit from arbitrage
 */
router.get(
  '/calculate-arbitrage/:inventoryId',
  authenticate,
  async (req: AuthRequest, res: Response) => {
    try {
      const inventoryId = parseInt(req.params.inventoryId as string);
      const { toCountry, transportMethod } = req.query;

      if (isNaN(inventoryId)) {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'INVALID_INVENTORY_ID' },
        });
      }

      if (!toCountry || !transportMethod) {
        return res.status(400).json({
          event: 'transport.error',
          params: { reason: 'MISSING_PARAMETERS' },
        });
      }

      // Get vehicle from inventory using Prisma
      const { default: prisma } = await import('../lib/prisma');
      const vehicle = await prisma.vehicleInventory.findFirst({
        where: { 
          id: inventoryId,
          playerId: req.player!.id 
        },
      });

      if (!vehicle) {
        return res.status(404).json({
          event: 'transport.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      const calculation = transportService.calculateArbitrageProfit(
        vehicle,
        vehicle.currentLocation,
        toCountry as string,
        transportMethod as 'ship' | 'fly' | 'drive'
      );

      return res.status(200).json({
        event: 'transport.arbitrage_calculated',
        params: {
          inventoryId,
          fromCountry: vehicle.currentLocation,
          toCountry,
          transportMethod,
        },
        calculation,
      });
    } catch (error) {
      console.error('Calculate arbitrage error:', error);
      return res.status(500).json({
        event: 'error.internal',
        params: {},
      });
    }
  }
);

export default router;
