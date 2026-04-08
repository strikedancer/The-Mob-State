import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { vehicleService } from '../services/vehicleService';
import { checkIfJailed } from '../services/policeService';
import { gameEventService } from '../services/gameEventService';

const router = Router();

/**
 * GET /vehicles
 * Get all available vehicle types
 */
router.get('/', (_req, res: Response) => {
  const vehicles = vehicleService.getAvailableVehicles();

  return res.status(200).json({
    event: 'vehicles.list',
    params: {},
    vehicles,
  });
});

/**
 * GET /vehicles/mine
 * Get player's owned vehicles
 */
router.get('/mine', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicles = await vehicleService.getPlayerInventory(req.player!.id);

    return res.status(200).json({
      event: 'vehicles.owned',
      params: {},
      vehicles,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /vehicles/buy
 * Buy a vehicle
 */
// Temporarily disabled - service method not implemented
/*
router.post('/buy', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { vehicleType } = req.body;

    if (!vehicleType) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'MISSING_VEHICLE_TYPE' },
      });
    }

    const result = await vehicleService.buyVehicle(req.player!.id, vehicleType);

    const vehicleDef = vehicleService.getVehicleDefinition(vehicleType);

    return res.status(200).json({
      event: 'vehicles.purchased',
      params: {
        vehicleId: result.vehicleId,
        vehicleType,
        name: vehicleDef?.name,
        cost: vehicleDef?.cost,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    console.error('[VehiclesRoute] /scrap failed:', error);
    if (error instanceof Error) {
      if (error.message === 'INVALID_VEHICLE_TYPE') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INVALID_VEHICLE_TYPE' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});
*/

/**
 * DELETE /vehicles/:id
 * Sell a vehicle
 */
router.delete('/:id', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicleId = parseInt(req.params.id as string);

    if (isNaN(vehicleId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_VEHICLE_ID' },
      });
    }

    const result = await vehicleService.sellVehicle(req.player!.id, vehicleId);

    return res.status(200).json({
      event: 'vehicles.sold',
      params: {
        vehicleId,
        sellPrice: result.sellPrice,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    console.error('[VehiclesRoute] /scrap failed:', error);
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'vehicles.error',
          params: { reason: 'NOT_OWNER' },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/:id/refuel', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicleId = parseInt(req.params.id as string);
    const { amount } = req.body;

    if (isNaN(vehicleId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_VEHICLE_ID' },
      });
    }

    if (!amount || typeof amount !== 'number') {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_AMOUNT' },
      });
    }

    const result = await vehicleService.refuelVehicle(req.player!.id, vehicleId, amount);

    return res.status(200).json({
      event: 'vehicles.refueled',
      params: {
        vehicleId,
        fuelAdded: result.fuelAdded,
        totalCost: result.totalCost,
        newFuel: result.newFuel,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    console.error('[VehiclesRoute] /scrap failed:', error);
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'vehicles.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'FUEL_TANK_FULL') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'FUEL_TANK_FULL' },
        });
      }

      if (error.message === 'VEHICLE_NO_FUEL_NEEDED') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NO_FUEL_NEEDED' },
        });
      }

      if (error.message === 'INVALID_AMOUNT') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INVALID_AMOUNT' },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/:id/repair', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const vehicleId = parseInt(req.params.id as string);

    if (isNaN(vehicleId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_VEHICLE_ID' },
      });
    }

    const result = await vehicleService.repairVehicle(req.player!.id, vehicleId);

    return res.status(200).json({
      event: 'vehicles.repair_started',
      params: {
        vehicleId,
        repairCost: result.repairCost,
        repairDurationSeconds: result.repairDurationSeconds,
        repairCompletesAt: result.repairCompletesAt,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'vehicles.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'VEHICLE_NOT_BROKEN') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_BROKEN' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }

      if (error.message === 'VEHICLE_REPAIR_IN_PROGRESS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_REPAIR_IN_PROGRESS' },
        });
      }

      if (error.message.startsWith('REPAIR_CONCURRENCY_LIMIT_REACHED')) {
        const [, maxConcurrentRaw, activeConcurrentRaw, vipRaw] = error.message.split(':');
        const maxConcurrent = Number(maxConcurrentRaw ?? 0);
        const activeConcurrent = Number(activeConcurrentRaw ?? 0);
        const isVipActive = vipRaw === '1';
        return res.status(400).json({
          event: 'vehicles.error',
          params: {
            reason: 'REPAIR_CONCURRENCY_LIMIT_REACHED',
            maxConcurrent: Number.isFinite(maxConcurrent) ? Math.max(0, maxConcurrent) : 0,
            activeConcurrent: Number.isFinite(activeConcurrent) ? Math.max(0, activeConcurrent) : 0,
            isVipActive,
          },
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
 * =========================================
 * PHASE 12: VEHICLE STEALING & TRADING
 * =========================================
 */

/**
 * GET /vehicles/available/:country
 * Get vehicles available in a specific country for stealing
 * Returns all vehicles - success is based on rarity/price, not rank
 */
router.get('/available/:country', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { country } = req.params;
    const vehicles = await vehicleService.getVehiclesInCountry(country as string);
    const policeVehicleEvent = vehicleService.getPoliceVehicleEventStatus();

    return res.status(200).json({
      event: 'vehicles.available_in_country',
      params: { country },
      vehicles,
      policeVehicleEvent,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /vehicles/steal/:vehicleId
 * Steal a vehicle from the streets
 */
router.post('/steal/:vehicleId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { vehicleId } = req.params;

    const remainingJailTime = await checkIfJailed(req.player!.id);
    if (remainingJailTime > 0) {
      return res.status(403).json({
        event: 'error.jailed',
        params: {
          remainingTime: remainingJailTime,
        },
      });
    }

    const result = await vehicleService.stealVehicle(req.player!.id, vehicleId as string);

    if (!result.success) {
      return res.status(200).json({
        event: 'vehicles.steal_failed',
        params: {
          vehicleId,
          reason: result.message,
          message: result.message,
          arrested: result.arrested ?? false,
          jailTime: result.jailTime ?? 0,
          bail: result.bail ?? 0,
          wantedLevel: result.wantedLevel ?? 0,
          cooldownRemainingSeconds: result.cooldownRemainingSeconds ?? 0,
        },
      });
    }

    // Record event contribution (fire-and-forget)
    gameEventService.recordContribution(req.player!.id, 'vehicles', 1).catch(() => {});

    return res.status(200).json({
      event: 'vehicles.stolen',
      params: {
        vehicleId,
        message: result.message,
        arrested: result.arrested ?? false,
        arrestedAfterTheft: result.arrestedAfterTheft ?? false,
        jailTime: result.jailTime ?? 0,
        bail: result.bail ?? 0,
        wantedLevel: result.wantedLevel ?? 0,
        xpGained: result.xpGained ?? 0,
      },
      player: {
        xp: result.newXp ?? null,
        rank: result.newRank ?? null,
        wantedLevel: result.wantedLevel ?? 0,
      },
      vehicle: result.vehicle,
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INVALID_VEHICLE' },
        });
      }

      return res.status(500).json({
        event: 'vehicles.error',
        params: { reason: error.message || 'SCRAP_FAILED' },
      });
    }

    return res.status(500).json({
      event: 'vehicles.error',
      params: { reason: 'UNKNOWN_ERROR' },
    });
  }
});


/**
 * GET /vehicles/inventory
 * Get player's stolen vehicle inventory
 */
router.get('/inventory', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventory = await vehicleService.getPlayerInventory(req.player!.id);

    return res.status(200).json({
      event: 'vehicles.inventory',
      params: {},
      inventory,
    });
  } catch (error) {
    console.error('[VehiclesRoute] /inventory failed:', error);
    return res.status(500).json({
      event: 'error.internal',
      params: { reason: 'INVENTORY_LOAD_FAILED' },
    });
  }
});

/**
 * POST /vehicles/scrap/:inventoryId
 * Scrap a vehicle for salvage value
 */
router.post('/scrap/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    const result = await vehicleService.scrapVehicle(req.player!.id, inventoryId);

    return res.status(200).json({
      event: 'vehicles.scrapped',
      params: {
        inventoryId,
        scrapPrice: result.scrapPrice,
        partsType: result.partsType,
        partsGained: result.partsGained,
      },
      parts: result.parts,
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'vehicles.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'VEHICLE_REPAIR_IN_PROGRESS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'Dit voertuig wordt gerepareerd' },
        });
      }

      if (error.message === 'VEHICLE_IN_TRANSIT') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'Dit voertuig is onderweg' },
        });
      }

      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INVALID_VEHICLE' },
        });
      }

      const detail = error.message || 'UNKNOWN_ERROR';
      return res.status(500).json({
        event: 'vehicles.error',
        params: { reason: `SCRAP_ERROR:${detail}` },
      });
    }

    const nonErrorReason = (() => {
      const t = typeof error;
      if (error == null) return `SCRAP_NON_ERROR:${t}:nullish`;
      if (t === 'string' || t === 'number' || t === 'boolean' || t === 'bigint') {
        return `SCRAP_NON_ERROR:${t}:${String(error)}`;
      }
      try {
        return `SCRAP_NON_ERROR:${t}:${JSON.stringify(error)}`;
      } catch {
        return `SCRAP_NON_ERROR:${t}:unserializable`;
      }
    })();

    return res.status(500).json({
      event: 'vehicles.error',
      params: { reason: nonErrorReason },
    });
  }
});

/**
 * GET /vehicles/tuning/overview
 * Get parts inventory and tunable vehicles overview
 */
router.get('/tuning/overview', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const overview = await vehicleService.getTuningOverview(req.player!.id);
    return res.status(200).json({
      event: 'vehicles.tuning_overview',
      params: {},
      ...overview,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /vehicles/tuning/:inventoryId/upgrade
 * Upgrade speed/stealth/armor for a vehicle
 */
router.post('/tuning/:inventoryId/upgrade', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string, 10);
    const stat = (req.body?.stat as string | undefined)?.toLowerCase();

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (!stat || !['speed', 'stealth', 'armor'].includes(stat)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_TUNE_STAT' },
      });
    }

    const result = await vehicleService.upgradeVehicleTuning(
      req.player!.id,
      inventoryId,
      stat as 'speed' | 'stealth' | 'armor'
    );

    return res.status(200).json({
      event: 'vehicles.tuning_upgraded',
      params: {
        inventoryId,
        stat,
        ...result.upgradeCost,
      },
      parts: result.parts,
      tuningLevels: result.tuningLevels,
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({ event: 'vehicles.error', params: { reason: 'VEHICLE_NOT_FOUND' } });
      }
      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({ event: 'vehicles.error', params: { reason: 'NOT_OWNER' } });
      }
      if (error.message === 'VEHICLE_IN_TRANSIT') {
        return res.status(400).json({ event: 'vehicles.error', params: { reason: 'VEHICLE_IN_TRANSIT' } });
      }
      if (error.message === 'VEHICLE_REPAIR_IN_PROGRESS') {
        return res.status(400).json({ event: 'vehicles.error', params: { reason: 'VEHICLE_REPAIR_IN_PROGRESS' } });
      }
      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({ event: 'vehicles.error', params: { reason: 'INSUFFICIENT_FUNDS' } });
      }
      if (error.message === 'INSUFFICIENT_PARTS') {
        return res.status(400).json({ event: 'vehicles.error', params: { reason: 'INSUFFICIENT_PARTS' } });
      }
      if (error.message === 'TUNE_STAT_MAXED') {
        return res.status(400).json({ event: 'vehicles.error', params: { reason: 'TUNE_STAT_MAXED' } });
      }
      if (error.message.startsWith('TUNE_COOLDOWN_ACTIVE')) {
        const seconds = Number(error.message.split(':')[1] ?? 0);
        return res.status(400).json({
          event: 'vehicles.error',
          params: {
            reason: 'TUNE_COOLDOWN_ACTIVE',
            cooldownRemainingSeconds: Number.isFinite(seconds) ? Math.max(0, seconds) : 0,
          },
        });
      }
      if (error.message.startsWith('TUNE_CONCURRENCY_LIMIT_REACHED')) {
        const [, maxConcurrentRaw, activeConcurrentRaw, vipRaw] = error.message.split(':');
        const maxConcurrent = Number(maxConcurrentRaw ?? 0);
        const activeConcurrent = Number(activeConcurrentRaw ?? 0);
        const isVipActive = vipRaw === '1';
        return res.status(400).json({
          event: 'vehicles.error',
          params: {
            reason: 'TUNE_CONCURRENCY_LIMIT_REACHED',
            maxConcurrent: Number.isFinite(maxConcurrent) ? Math.max(0, maxConcurrent) : 0,
            activeConcurrent: Number.isFinite(activeConcurrent) ? Math.max(0, activeConcurrent) : 0,
            isVipActive,
          },
        });
      }
      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({ event: 'vehicles.error', params: { reason: 'INVALID_VEHICLE' } });
      }
    }

    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

/**
 * POST /vehicles/sell-stolen/:inventoryId
 * Sell a stolen vehicle on the black market
 */
router.post('/sell-stolen/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    const result = await vehicleService.sellVehicle(req.player!.id, inventoryId);

    return res.status(200).json({
      event: 'vehicles.stolen_sold',
      params: {
        inventoryId,
        sellPrice: result.sellPrice,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'vehicles.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'VEHICLE_IN_TRANSIT') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'Dit voertuig is onderweg en kan niet verkocht worden' },
        });
      }

      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INVALID_VEHICLE' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
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
 * POST /vehicles/transport/:inventoryId
 * Transport vehicle to another country
 */
router.post('/transport/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const inventoryId = parseInt(req.params.inventoryId as string);
    const { destinationCountry } = req.body;

    if (isNaN(inventoryId)) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'INVALID_INVENTORY_ID' },
      });
    }

    if (!destinationCountry) {
      return res.status(400).json({
        event: 'vehicles.error',
        params: { reason: 'MISSING_DESTINATION' },
      });
    }

    const result = await vehicleService.transportVehicle(
      req.player!.id,
      inventoryId,
      destinationCountry
    );

    return res.status(200).json({
      event: 'vehicles.transported',
      params: {
        inventoryId,
        destinationCountry,
        transportCost: result.transportCost,
      },
      player: {
        money: result.newMoney,
      },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'VEHICLE_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_NOT_FOUND' },
        });
      }

      if (error.message === 'NOT_OWNER') {
        return res.status(403).json({
          event: 'vehicles.error',
          params: { reason: 'NOT_OWNER' },
        });
      }

      if (error.message === 'INVALID_VEHICLE') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INVALID_VEHICLE' },
        });
      }

      if (error.message === 'PLAYER_NOT_FOUND') {
        return res.status(404).json({
          event: 'vehicles.error',
          params: { reason: 'PLAYER_NOT_FOUND' },
        });
      }

      if (error.message === 'USE_SMUGGLING_HUB') {
        return res.status(410).json({
          event: 'vehicles.transport_disabled',
          params: {
            reason: 'USE_SMUGGLING_HUB',
            message: 'Direct transport is verwijderd. Gebruik de Smokkel Hub voor voertuigverplaatsing.',
          },
        });
      }

      if (error.message === 'VEHICLE_REPAIR_IN_PROGRESS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'VEHICLE_REPAIR_IN_PROGRESS' },
        });
      }

      if (error.message === 'INSUFFICIENT_FUNDS') {
        return res.status(400).json({
          event: 'vehicles.error',
          params: { reason: 'INSUFFICIENT_FUNDS' },
        });
      }
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;
