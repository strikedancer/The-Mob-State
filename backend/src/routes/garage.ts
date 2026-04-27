/**
 * Phase 12: Garage & Marina Routes
 * API endpoints for garage and marina management
 */

import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import prisma from '../lib/prisma';
import { garageService } from '../services/garageService';
import {
  clearPlayerCrimeVehicle,
  repairVehicle,
  refuelVehicle,
  resolveSelectedCrimeVehicle,
  setPlayerCrimeVehicleFromInventory,
} from '../services/vehicleToolService';

const router = Router();

/**
 * GET /garage/status/:location
 * Get garage status for a specific location
 */
router.get('/status/:location', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { location } = req.params;
    const requestedVehicleType = req.query.vehicleType?.toString();
    const status = await garageService.getGarageStatus(
      req.player!.id,
      location as string,
      requestedVehicleType,
    );

    return res.status(200).json({
      event: 'garage.status',
      params: { location, vehicleType: requestedVehicleType ?? 'car' },
      status,
    });
  } catch (error) {
    console.error('Get garage status error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /garage/upgrade
 * Upgrade garage capacity
 */
router.post('/upgrade', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { location, garageTrack: rawTrack } = req.body;

    if (!location) {
      return res.status(400).json({
        event: 'garage.error',
        params: { reason: 'MISSING_LOCATION' },
      });
    }

    const normalized =
      typeof rawTrack === 'string' && rawTrack.toLowerCase() === 'motorcycle'
        ? 'motorcycle'
        : 'car';

    const result = await garageService.upgradeGarage(req.player!.id, location, normalized);

    return res.status(200).json({
      event: 'garage.upgraded',
      params: {
        location,
        garageTrack: result.garageTrack,
        newLevel: result.newLevel,
        capacityBonus: result.capacityBonus,
        upgradeCost: result.upgradeCost,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.startsWith('RANK_REQUIRED:')) {
        const requiredRank = parseInt(error.message.split(':')[1] ?? '0', 10) || 0;
        return res.status(400).json({
          event: 'garage.error',
          params: { reason: 'RANK_REQUIRED', requiredRank },
        });
      }
      if (error.message === 'MAX_UPGRADE_LEVEL') {
        return res.status(400).json({
          event: 'garage.error',
          params: { reason: 'MAX_UPGRADE_LEVEL' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'garage.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'garage.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    console.error('Upgrade garage error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /marina/status/:location
 * Get marina status for a specific location
 */
router.get('/marina/status/:location', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { location } = req.params;
    const status = await garageService.getMarinaStatus(req.player!.id, location as string);

    return res.status(200).json({
      event: 'marina.status',
      params: { location },
      status,
    });
  } catch (error) {
    console.error('Get marina status error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /marina/upgrade
 * Upgrade marina capacity
 */
router.post('/marina/upgrade', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { location } = req.body;

    if (!location) {
      return res.status(400).json({
        event: 'marina.error',
        params: { reason: 'MISSING_LOCATION' },
      });
    }

    const result = await garageService.upgradeMarina(req.player!.id, location);

    return res.status(200).json({
      event: 'marina.upgraded',
      params: {
        location,
        newLevel: result.newLevel,
        capacityBonus: result.capacityBonus,
        upgradeCost: result.upgradeCost,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message.startsWith('RANK_REQUIRED:')) {
        const requiredRank = parseInt(error.message.split(':')[1] ?? '0', 10) || 0;
        return res.status(400).json({
          event: 'marina.error',
          params: { reason: 'RANK_REQUIRED', requiredRank },
        });
      }
      if (error.message === 'MAX_UPGRADE_LEVEL') {
        return res.status(400).json({
          event: 'marina.error',
          params: { reason: 'MAX_UPGRADE_LEVEL' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'marina.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'marina.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    console.error('Upgrade marina error:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /garage/crime-vehicle
 * Get currently selected vehicle for crimes
 */
router.get('/crime-vehicle', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const resolvedVehicle = await resolveSelectedCrimeVehicle(
      req.player!.id,
      req.player!.currentCountry,
    );

    if (!resolvedVehicle) {
      return res.status(200).json({
        event: 'garage.crimeVehicle',
        params: {},
        vehicle: null,
      });
    }

    return res.status(200).json({
      event: 'garage.crimeVehicle',
      params: {},
      vehicle: resolvedVehicle.vehicle,
      vehicleInventoryId: resolvedVehicle.inventory.id,
    });
  } catch (error) {
    console.error('[Garage Route] Error getting crime vehicle:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /garage/crime-vehicle
 * Set vehicle for crimes
 */
router.post('/crime-vehicle', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { vehicleId } = req.body;

    if (!vehicleId) {
      return res.status(400).json({
        event: 'error.validation',
        params: { message: 'vehicleId is required' },
      });
    }

    const parsedVehicleId = parseInt(vehicleId, 10);
    const selectedVehicle = await setPlayerCrimeVehicleFromInventory(
      req.player!.id,
      parsedVehicleId,
    );

    const resolvedVehicle = await resolveSelectedCrimeVehicle(
      req.player!.id,
      req.player!.currentCountry,
    );

    if (!resolvedVehicle) {
      return res.status(400).json({
        event: 'error.vehicleLocation',
        params: { 
          message: 'Vehicle must be in the same country as you',
          vehicleCountry: null,
          playerCountry: req.player!.currentCountry,
        },
      });
    }

    return res.status(200).json({
      event: 'garage.crimeVehicleSet',
      params: { 
        vehicleId: selectedVehicle.vehicleId,
        vehicleInventoryId: selectedVehicle.vehicleInventoryId,
      },
    });
  } catch (error) {
    console.error('[Garage Route] Error setting crime vehicle:', error);
    
    if (error instanceof Error && error.message === 'Vehicle not found or does not belong to player') {
      return res.status(404).json({
        event: 'error.vehicle',
        params: { message: error.message },
      });
    }

    if (error instanceof Error && error.message === 'VEHICLE_UNAVAILABLE') {
      return res.status(400).json({
        event: 'error.vehicleLocation',
        params: {
          message: 'Vehicle is currently unavailable for crimes',
          playerCountry: req.player!.currentCountry,
        },
      });
    }
    
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * DELETE /garage/crime-vehicle
 * Clear selected vehicle for crimes
 */
router.delete('/crime-vehicle', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    await clearPlayerCrimeVehicle(req.player!.id);

    return res.status(200).json({
      event: 'garage.crimeVehicleCleared',
      params: {},
    });
  } catch (error) {
    console.error('[Garage Route] Error clearing crime vehicle:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /garage/vehicles
 * Get all player's vehicles with stats
 */
router.get('/vehicles', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicles = await prisma.vehicle.findMany({
      where: { playerId: req.player!.id },
      orderBy: { createdAt: 'desc' },
    });

    return res.status(200).json({
      event: 'garage.vehicles',
      params: {},
      vehicles,
    });
  } catch (error) {
    console.error('[Garage Route] Error getting vehicles:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /garage/repair/:vehicleId
 * Repair vehicle
 */
router.post('/repair/:vehicleId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicleId = parseInt(req.params.vehicleId, 10);
    const { repairPercent = 100 } = req.body;

    // Check if vehicle belongs to player
    const vehicle = await prisma.vehicle.findFirst({
      where: {
        id: vehicleId,
        playerId: req.player!.id,
      },
    });

    if (!vehicle) {
      return res.status(404).json({
        event: 'error.vehicle',
        params: { message: 'Vehicle not found' },
      });
    }

    const result = await repairVehicle(vehicleId, repairPercent);

    // Deduct money from player
    const player = await prisma.player.findUnique({
      where: { id: req.player!.id },
    });

    if (!player || player.money < result.cost) {
      return res.status(400).json({
        event: 'error.insufficientFunds',
        params: { cost: result.cost },
      });
    }

    await prisma.player.update({
      where: { id: req.player!.id },
      data: { money: player.money - result.cost },
    });

    return res.status(200).json({
      event: 'garage.repaired',
      params: {
        vehicleId,
        cost: result.cost,
        newCondition: result.newCondition,
        newMoney: player.money - result.cost,
      },
    });
  } catch (error) {
    console.error('[Garage Route] Error repairing vehicle:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /garage/refuel/:vehicleId
 * Refuel vehicle
 */
router.post('/refuel/:vehicleId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicleId = parseInt(req.params.vehicleId, 10);
    const { fuelAmount = 100 } = req.body;

    // Check if vehicle belongs to player
    const vehicle = await prisma.vehicle.findFirst({
      where: {
        id: vehicleId,
        playerId: req.player!.id,
      },
    });

    if (!vehicle) {
      return res.status(404).json({
        event: 'error.vehicle',
        params: { message: 'Vehicle not found' },
      });
    }

    const result = await refuelVehicle(vehicleId, fuelAmount);

    // Deduct money from player
    const player = await prisma.player.findUnique({
      where: { id: req.player!.id },
    });

    if (!player || player.money < result.cost) {
      return res.status(400).json({
        event: 'error.insufficientFunds',
        params: { cost: result.cost },
      });
    }

    await prisma.player.update({
      where: { id: req.player!.id },
      data: { money: player.money - result.cost },
    });

    return res.status(200).json({
      event: 'garage.refueled',
      params: {
        vehicleId,
        cost: result.cost,
        newFuel: result.newFuel,
        newMoney: player.money - result.cost,
      },
    });
  } catch (error) {
    console.error('[Garage Route] Error refueling vehicle:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
