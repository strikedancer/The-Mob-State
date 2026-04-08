import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import prisma from '../lib/prisma';
import { ammoFactoryService } from '../services/ammoFactoryService';

const router = Router();

/**
 * GET /ammo-factories
 * List factories for all countries
 */
router.get('/', authenticate, async (_req: AuthRequest, res: Response) => {
  const factories = await ammoFactoryService.listFactories();

  return res.status(200).json({
    success: true,
    factories,
  });
});

/**
 * GET /ammo-factories/my
 * Get current player's factory
 */
router.get('/my', authenticate, async (req: AuthRequest, res: Response) => {
  const factory = await ammoFactoryService.getPlayerFactory(req.player!.id);

  return res.status(200).json({
    success: true,
    factory,
  });
});

/**
 * POST /ammo-factories/buy
 * Body: { countryId }
 */
router.post('/buy', authenticate, async (req: AuthRequest, res: Response) => {
  const { countryId } = req.body;

  if (!countryId) {
    return res.status(400).json({
      success: false,
      error: 'MISSING_COUNTRY',
      message: 'Country is required',
    });
  }

  const player = await prisma.player.findUnique({
    where: { id: req.player!.id },
    select: { currentCountry: true },
  });

  if (!player) {
    return res.status(404).json({
      success: false,
      error: 'PLAYER_NOT_FOUND',
      message: 'Player not found',
    });
  }

  if (player.currentCountry !== countryId) {
    return res.status(400).json({
      success: false,
      error: 'WRONG_COUNTRY',
      message: 'You must be in the same country to buy this factory',
    });
  }

  const result = await ammoFactoryService.purchaseFactory(req.player!.id, countryId);

  if (!result.success) {
    let message = 'Could not purchase factory';
    let statusCode = 400;
    let reasonKey: string | undefined;

    switch (result.error) {
      case 'FACTORY_OWNED':
        message = 'Factory is already owned';
        statusCode = 409;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'Not enough money to buy factory';
        statusCode = 403;
        break;
      case 'EDUCATION_REQUIREMENTS_NOT_MET':
        message = 'Education requirements not met';
        statusCode = 403;
        reasonKey = (result as any).reasonKey ?? 'ammoFactory.error.education_requirements_not_met';
        break;
    }

    return res.status(statusCode).json({
      success: false,
      error: result.error,
      message,
      reasonKey,
      gateId: (result as any).gateId,
      gateLabelKey: (result as any).gateLabelKey,
      missing: (result as any).missing,
      cost: (result as any).cost,
    });
  }

  return res.status(200).json({
    success: true,
    factory: result.factory,
    cost: (result as any).cost,
  });
});

/**
 * POST /ammo-factories/produce
 */
router.post('/produce', authenticate, async (req: AuthRequest, res: Response) => {
  const result = await ammoFactoryService.produce(req.player!.id);

  if (!result.success) {
    let message = 'Could not produce ammo';
    let statusCode = 400;

    switch (result.error) {
      case 'FACTORY_NOT_OWNED':
        message = 'You do not own a factory';
        statusCode = 403;
        break;
      case 'COOLDOWN':
        message = 'Factory is on cooldown';
        statusCode = 429;
        break;
      case 'FACTORY_INACTIVE':
        message = 'Factory ownership lost due to inactivity';
        statusCode = 410;
        break;
    }

    return res.status(statusCode).json({
      success: false,
      error: result.error,
      message,
      nextProduction: (result as any).nextProduction,
    });
  }

  return res.status(200).json({
    success: true,
    factory: result.factory,
    processedTicks: (result as any).processedTicks ?? 0,
    sessionStarted: (result as any).sessionStarted ?? false,
  });
});

/**
 * POST /ammo-factories/upgrade
 * Body: { type: 'output' | 'quality' }
 */
router.post('/upgrade', authenticate, async (req: AuthRequest, res: Response) => {
  const { type } = req.body;

  if (type !== 'output' && type !== 'quality') {
    return res.status(400).json({
      success: false,
      error: 'INVALID_UPGRADE_TYPE',
      message: 'Upgrade type must be output or quality',
    });
  }

  const result = await ammoFactoryService.upgradeFactory(req.player!.id, type);

  if (!result.success) {
    let message = 'Could not upgrade factory';
    let statusCode = 400;
    let reasonKey: string | undefined;

    switch (result.error) {
      case 'FACTORY_NOT_OWNED':
        message = 'You do not own a factory';
        statusCode = 403;
        break;
      case 'INSUFFICIENT_MONEY':
        message = 'Not enough money to upgrade factory';
        statusCode = 403;
        break;
      case 'MAX_LEVEL':
        message = 'Factory is already max level';
        statusCode = 400;
        break;
      case 'FACTORY_INACTIVE':
        message = 'Factory ownership lost due to inactivity';
        statusCode = 410;
        break;
      case 'EDUCATION_REQUIREMENTS_NOT_MET':
        message = 'Education requirements not met';
        statusCode = 403;
        reasonKey = (result as any).reasonKey ?? 'ammoFactory.error.education_requirements_not_met';
        break;
    }

    return res.status(statusCode).json({
      success: false,
      error: result.error,
      message,
      reasonKey,
      gateId: (result as any).gateId,
      gateLabelKey: (result as any).gateLabelKey,
      missing: (result as any).missing,
      cost: (result as any).cost,
    });
  }

  return res.status(200).json({
    success: true,
    factory: result.factory,
    cost: (result as any).cost,
  });
});

export default router;
