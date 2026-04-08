import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { weaponService } from '../services/weaponService';
import { weaponSelectionService } from '../services/weaponSelectionService';

const router = Router();

/**
 * GET /weapons
 * Get all weapon type definitions
 */
router.get('/', async (_, res: Response) => {
  const weapons = weaponService.getAllWeapons();

  return res.status(200).json({
    event: 'weapons.list',
    params: {},
    weapons,
  });
});

/**
 * GET /weapons/inventory
 * Get player's weapon inventory
 */
router.get('/inventory', authenticate, async (req: AuthRequest, res: Response) => {
  const weapons = await weaponService.getPlayerWeapons(req.player!.id);

  return res.status(200).json({
    event: 'weapons.inventory',
    params: {},
    weapons,
  });
});

/**
 * GET /weapons/crime-weapon
 * Get selected weapon for crimes
 */
router.get('/crime-weapon', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const selectedWeapon = await weaponSelectionService.getSelectedCrimeWeapon(req.player!.id);

    return res.status(200).json({
      event: 'weapons.crimeWeapon',
      params: {},
      weapon: selectedWeapon,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /weapons/crime-weapon
 * Set selected weapon for crimes
 */
router.post('/crime-weapon', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { weaponId } = req.body as { weaponId?: string };

    if (!weaponId) {
      return res.status(400).json({
        event: 'error.validation',
        params: { message: 'weaponId is required' },
      });
    }

    await weaponSelectionService.setSelectedCrimeWeapon(req.player!.id, weaponId);

    return res.status(200).json({
      event: 'weapons.crimeWeaponSet',
      params: { weaponId },
    });
  } catch (error) {
    if (error instanceof Error) {
      if (error.message === 'WEAPON_NOT_FOUND') {
        return res.status(404).json({
          event: 'error.weapon',
          params: { reason: 'WEAPON_NOT_FOUND' },
        });
      }
      if (error.message === 'WEAPON_BROKEN') {
        return res.status(400).json({
          event: 'error.weapon',
          params: { reason: 'WEAPON_BROKEN' },
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
 * DELETE /weapons/crime-weapon
 * Clear selected weapon for crimes
 */
router.delete('/crime-weapon', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    await weaponSelectionService.clearSelectedCrimeWeapon(req.player!.id);

    return res.status(200).json({
      event: 'weapons.crimeWeaponCleared',
      params: {},
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * POST /weapons/buy/:weaponId
 * Buy a weapon from the black market
 */
router.post('/buy/:weaponId', authenticate, async (req: AuthRequest, res: Response) => {
  const { weaponId } = req.params;

  const result = await weaponService.buyWeapon(req.player!.id, String(weaponId));

  if (!result.success) {
    let message = 'Could not buy weapon';
    let statusCode = 400;

    switch (result.error) {
      case 'WEAPON_NOT_FOUND':
        message = 'Weapon type not found';
        statusCode = 404;
        break;
      case 'RANK_TOO_LOW':
        message = 'Your rank is too low to buy this weapon';
        statusCode = 403;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'You don\'t have enough money to buy this weapon';
        statusCode = 403;
        break;
      case 'INVENTORY_FULL':
        message = 'Your inventory is full. Upgrade your backpack or free slots.';
        statusCode = 403;
        break;
      case 'VIP_ONLY':
        message = 'This weapon is only available for VIP members';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.weapon_purchase',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'weapons.purchased',
    params: {
      weaponId,
    },
    weapon: result.weapon,
  });
});

/**
 * POST /weapons/sell/:inventoryId
 * Sell a weapon
 */
router.post('/sell/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  const inventoryId = parseInt(req.params.inventoryId as string);

  if (isNaN(inventoryId)) {
    return res.status(400).json({
      event: 'error.invalid_id',
      params: {},
    });
  }

  const result = await weaponService.sellWeapon(req.player!.id, inventoryId);

  if (!result.success) {
    let message = 'Could not sell weapon';
    let statusCode = 400;

    switch (result.error) {
      case 'WEAPON_NOT_FOUND':
        message = 'Weapon not found in inventory';
        statusCode = 404;
        break;
      case 'NOT_YOUR_WEAPON':
        message = 'This weapon does not belong to you';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.weapon_sale',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'weapons.sold',
    params: {
      sellPrice: result.sellPrice,
    },
  });
});

/**
 * POST /weapons/repair/:inventoryId
 * Repair a weapon
 */
router.post('/repair/:inventoryId', authenticate, async (req: AuthRequest, res: Response) => {
  const inventoryId = parseInt(req.params.inventoryId as string);

  if (isNaN(inventoryId)) {
    return res.status(400).json({
      event: 'error.invalid_id',
      params: {},
    });
  }

  const result = await weaponService.repairWeapon(req.player!.id, inventoryId);

  if (!result.success) {
    let message = 'Could not repair weapon';
    let statusCode = 400;

    switch (result.error) {
      case 'WEAPON_NOT_FOUND':
        message = 'Weapon not found in inventory';
        statusCode = 404;
        break;
      case 'NOT_YOUR_WEAPON':
        message = 'This weapon does not belong to you';
        statusCode = 403;
        break;
      case 'WEAPON_ALREADY_PERFECT':
        message = 'This weapon is already in perfect condition';
        statusCode = 400;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'You don\'t have enough money to repair this weapon';
        statusCode = 403;
        break;
    }

    return res.status(statusCode).json({
      event: 'error.weapon_repair',
      params: {
        reason: result.error,
        message,
      },
    });
  }

  return res.status(200).json({
    event: 'weapons.repaired',
    params: {
      repairCost: result.repairCost,
    },
  });
});

export default router;
