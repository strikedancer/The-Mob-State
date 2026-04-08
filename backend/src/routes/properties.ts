import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { propertyService } from '../services/propertyService';
import { propertyStorageService } from '../services/propertyStorageService';
import { prostituteService } from '../services/prostituteService';

const router = Router();

/**
 * GET /properties
 * Get all property definitions
 */
router.get('/', async (_, res: Response) => {
  const properties = propertyService.getAllProperties().map((prop) => ({
    ...prop,
    imagePath: prop.image,
  }));

  return res.status(200).json({
    event: 'properties.list',
    params: {},
    properties,
  });
});

/**
 * GET /properties/available/:countryId
 * Get available properties for a specific country with ownership status
 */
router.get('/available/:countryId', authenticate, async (req: AuthRequest, res: Response) => {
  const { countryId } = req.params;

  const availableProperties = await propertyService.getAvailableProperties(String(countryId));

  return res.status(200).json({
    event: 'properties.available',
    params: { countryId },
    properties: availableProperties,
  });
});

/**
 * GET /properties/mine
 * Get player's owned properties
 */
router.get('/mine', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const ownedProperties = await propertyService.getOwnedProperties(playerId);
  const housingCapacity = await prostituteService.getHousingCapacity(playerId);

  return res.status(200).json({
    event: 'properties.mine',
    params: {},
    properties: ownedProperties,
    vipHousingBonusPerProperty: housingCapacity.vipBonusPerProperty,
    playerIsVip: housingCapacity.isVip,
  });
});

router.get('/storage-overview', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const storage = await propertyStorageService.getPropertyStorageOverview(req.player!.id);
    return res.status(200).json({
      event: 'properties.storage_overview',
      params: {},
      storage,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/storage/:propertyId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.propertyId), 10);
    if (isNaN(propertyId)) {
      return res.status(400).json({
        event: 'error.invalid_property_id',
        params: {},
      });
    }

    const detail = await propertyStorageService.getPropertyStorageDetail(
      req.player!.id,
      propertyId,
    );

    return res.status(200).json({
      event: 'properties.storage_detail',
      params: {},
      storage: detail,
    });
  } catch (error) {
    if (error instanceof Error && error.message === 'WRONG_COUNTRY') {
      return res.status(403).json({
        event: 'properties.storage_denied',
        params: { reason: 'WRONG_COUNTRY' },
      });
    }

    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.post('/storage/:propertyId/weapons/deposit', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.propertyId), 10);
    const weaponId = String(req.body?.weaponId || '');
    const quantity = Number(req.body?.quantity || 1);

    if (isNaN(propertyId) || !weaponId || quantity <= 0) {
      return res.status(400).json({
        event: 'error.validation',
        params: {},
      });
    }

    await propertyStorageService.depositWeapon(req.player!.id, propertyId, weaponId, quantity);

    return res.status(200).json({
      event: 'properties.weapon_deposited',
      params: { propertyId, weaponId, quantity },
    });
  } catch (error) {
    const reason = error instanceof Error ? error.message : 'UNKNOWN';
    return res.status(reason === 'WRONG_COUNTRY' || reason === 'STORAGE_TYPE_NOT_ALLOWED' ? 403 : 400).json({
      event: 'properties.weapon_deposit_failed',
      params: { reason },
    });
  }
});

router.post('/storage/:propertyId/weapons/withdraw', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.propertyId), 10);
    const weaponId = String(req.body?.weaponId || '');
    const quantity = Number(req.body?.quantity || 1);

    if (isNaN(propertyId) || !weaponId || quantity <= 0) {
      return res.status(400).json({
        event: 'error.validation',
        params: {},
      });
    }

    await propertyStorageService.withdrawWeapon(req.player!.id, propertyId, weaponId, quantity);

    return res.status(200).json({
      event: 'properties.weapon_withdrawn',
      params: { propertyId, weaponId, quantity },
    });
  } catch (error) {
    const reason = error instanceof Error ? error.message : 'UNKNOWN';
    return res.status(reason === 'WRONG_COUNTRY' || reason === 'STORAGE_TYPE_NOT_ALLOWED' ? 403 : 400).json({
      event: 'properties.weapon_withdraw_failed',
      params: { reason },
    });
  }
});

router.post('/storage/:propertyId/cash/deposit', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.propertyId), 10);
    const amount = Number(req.body?.amount || 0);

    if (isNaN(propertyId) || amount <= 0) {
      return res.status(400).json({
        event: 'error.validation',
        params: {},
      });
    }

    await propertyStorageService.depositCash(req.player!.id, propertyId, amount);

    return res.status(200).json({
      event: 'properties.cash_deposited',
      params: { propertyId, amount },
    });
  } catch (error) {
    const reason = error instanceof Error ? error.message : 'UNKNOWN';
    return res.status(reason === 'WRONG_COUNTRY' || reason === 'STORAGE_TYPE_NOT_ALLOWED' ? 403 : 400).json({
      event: 'properties.cash_deposit_failed',
      params: { reason },
    });
  }
});

router.post('/storage/:propertyId/cash/withdraw', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.propertyId), 10);
    const amount = Number(req.body?.amount || 0);

    if (isNaN(propertyId) || amount <= 0) {
      return res.status(400).json({
        event: 'error.validation',
        params: {},
      });
    }

    await propertyStorageService.withdrawCash(req.player!.id, propertyId, amount);

    return res.status(200).json({
      event: 'properties.cash_withdrawn',
      params: { propertyId, amount },
    });
  } catch (error) {
    const reason = error instanceof Error ? error.message : 'UNKNOWN';
    return res.status(reason === 'WRONG_COUNTRY' || reason === 'STORAGE_TYPE_NOT_ALLOWED' ? 403 : 400).json({
      event: 'properties.cash_withdraw_failed',
      params: { reason },
    });
  }
});

/**
 * POST /properties/claim/:propertyId
 * Claim a property in the current country
 */
router.post('/claim/:propertyId', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const { propertyId } = req.params;
    const { slotNumber } = req.body;

    // Get player with currentCountry
    if (!req.player) {
      return res.status(401).json({
        event: 'error.unauthorized',
        params: {},
      });
    }

    const result = await propertyService.claimProperty(
      req.player.id,
      String(propertyId),
      req.player.currentCountry || 'netherlands',
      slotNumber
    );

    if (!result.success) {
      let message = 'Kon eigendom niet claimen';
      let statusCode = 400;

      switch (result.error) {
        case 'PROPERTY_NOT_FOUND':
          message = 'Eigendomstype niet gevonden';
          statusCode = 404;
          break;
        case 'LEVEL_TOO_LOW':
          message = 'Je level is te laag om dit eigendom te claimen';
          statusCode = 403;
          break;
        case 'INSUFFICIENT_MONEY':
          message = 'Je hebt niet genoeg geld om dit eigendom te kopen';
          statusCode = 403;
          break;
        case 'WRONG_COUNTRY':
          message = 'Je moet in het juiste land zijn om dit eigendom te claimen';
          statusCode = 403;
          break;
        case 'ALREADY_OWNED':
        case 'SLOT_TAKEN':
        case 'ALL_SLOTS_TAKEN':
          message = 'Dit eigendom is al in bezit';
          statusCode = 409;
          break;
        case 'PROPERTY_ALREADY_CLAIMED':
          message = 'Eigendom is al door iemand anders geclaimd';
          statusCode = 409;
          break;
      }

      return res.status(statusCode).json({
        event: 'property.claim_failed',
        params: {
          reason: result.error,
          message,
        },
      });
    }

    return res.status(201).json({
      event: 'property.claimed',
      params: {
        property: result.property,
      },
    });
  } catch (error: any) {
    console.error('Error claiming property:', error);
    return res.status(500).json({
      event: 'error.server',
      params: {
        message: error.message,
      },
    });
  }
});

/**
 * POST /properties/:id/forfeit
 * Forfeit (abandon) a property
 */
router.post('/:id/forfeit', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.id), 10);

    if (isNaN(propertyId)) {
      return res.status(400).json({
        event: 'error.invalid_property_id',
        params: {},
      });
    }

    await propertyService.forfeitProperty(req.player!.id, propertyId);

    return res.status(200).json({
      event: 'property.forfeited',
      params: { propertyId },
    });
  } catch (error: any) {
    if (error.message === 'PROPERTY_NOT_FOUND') {
      return res.status(404).json({
        event: 'error.property_not_found',
        params: {},
      });
    }

    if (error.message === 'NOT_PROPERTY_OWNER') {
      return res.status(403).json({
        event: 'error.not_property_owner',
        params: {},
      });
    }

    console.error('Error forfeiting property:', error);
    return res.status(500).json({
      event: 'error.server',
      params: {
        message: error.message,
      },
    });
  }
});

/**
 * POST /properties/:id/collect
 * Collect income from a property
 */
router.post('/:id/collect', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.id), 10);

    if (isNaN(propertyId)) {
      return res.status(400).json({
        event: 'error.invalid_property_id',
        params: {},
      });
    }

    const result = await propertyService.collectIncome(req.player!.id, propertyId);

    if (!result.success) {
      let message = 'Kon inkomen niet verzamelen';
      let statusCode = 400;

      switch (result.error) {
        case 'PROPERTY_NOT_FOUND':
          message = 'Eigendom niet gevonden';
          statusCode = 404;
          break;
        case 'NOT_PROPERTY_OWNER':
          message = 'Je bent niet de eigenaar van dit eigendom';
          statusCode = 403;
          break;
        case 'PROPERTY_DEFINITION_NOT_FOUND':
          message = 'Eigendomsconfiguratie fout';
          statusCode = 500;
          break;
        case 'TOO_SOON':
          message = 'Er is nog niet genoeg tijd verstreken om inkomen te verzamelen';
          statusCode = 429;
          break;
      }

      return res.status(statusCode).json({
        event: 'property.collect_failed',
        params: {
          reason: result.error,
          message,
        },
      });
    }

    return res.status(200).json({
      event: 'property.income_collected',
      params: {
        income: result.income,
        newMoney: result.newMoney,
      },
    });
  } catch (error: any) {
    console.error('Error collecting property income:', error);
    return res.status(500).json({
      event: 'error.server',
      params: {
        message: error.message,
      },
    });
  }
});

/**
 * POST /properties/:id/upgrade
 * Upgrade a property to the next level
 */
router.post('/:id/upgrade', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const propertyId = parseInt(String(req.params.id), 10);

    if (isNaN(propertyId)) {
      return res.status(400).json({
        event: 'error.invalid_property_id',
        params: {},
      });
    }

    const result = await propertyService.upgradeProperty(req.player!.id, propertyId);

    if (!result.success) {
      let message = 'Kon eigendom niet upgraden';
      let statusCode = 400;

      switch (result.error) {
        case 'PROPERTY_NOT_FOUND':
          message = 'Eigendom niet gevonden';
          statusCode = 404;
          break;
        case 'NOT_PROPERTY_OWNER':
          message = 'Je bent niet de eigenaar van dit eigendom';
          statusCode = 403;
          break;
        case 'PROPERTY_DEFINITION_NOT_FOUND':
          message = 'Eigendomsconfiguratie fout';
          statusCode = 500;
          break;
        case 'MAX_LEVEL_REACHED':
          message = 'Eigendom heeft al het maximale level bereikt';
          statusCode = 400;
          break;
        case 'UPGRADE_NOT_AVAILABLE':
          message = 'Upgrade niet beschikbaar voor dit eigendom';
          statusCode = 400;
          break;
        case 'INSUFFICIENT_MONEY':
          message = 'Je hebt niet genoeg geld om te upgraden';
          statusCode = 403;
          break;
      }

      return res.status(statusCode).json({
        event: 'property.upgrade_failed',
        params: {
          reason: result.error,
          message,
        },
      });
    }

    return res.status(200).json({
      event: 'property.upgraded',
      params: {
        newLevel: result.newLevel,
        cost: result.cost,
        newIncome: result.newIncome,
      },
    });
  } catch (error: any) {
    console.error('Error upgrading property:', error);
    return res.status(500).json({
      event: 'error.server',
      params: {
        message: error.message,
      },
    });
  }
});

export default router;
