/**
 * Travel Routes - Phase 9.1
 *
 * API endpoints for international travel.
 */

import express, { Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { checkCooldown } from '../middleware/checkCooldown';
import * as travelService from '../services/travelService';
import * as policeService from '../services/policeService';
import * as cooldownService from '../services/cooldownService';

const router = express.Router();

/**
 * GET /travel
 * Get all available countries with route information (alias for /travel/countries)
 */
router.get('/', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player?.id;
    
    if (!playerId) {
      return res.status(401).json({ error: 'Not authenticated' });
    }
    
    // Check for active cooldown
    const cooldown = await cooldownService.getCooldown(playerId, 'travel');
    if (cooldown && cooldown.remainingSeconds > 0) {
      return res.json({
        event: 'travel.list',
        params: {},
        countries: [],
        cooldown: {
          actionType: 'travel',
          remainingSeconds: cooldown.remainingSeconds,
        },
      });
    }
    
    // Get player's current country to calculate routes
    const currentCountry = await travelService.getPlayerCountry(playerId);
    const countries = travelService.getAllCountriesWithRoutes(currentCountry);
    
    return res.json({
      event: 'travel.list',
      params: {},
      countries,
      currentCountry,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * GET /travel/countries
 * Get all available countries with route information
 */
router.get('/countries', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player?.id;
    
    if (!playerId) {
      return res.status(401).json({ error: 'Not authenticated' });
    }
    
    // Check for active cooldown
    const cooldown = await cooldownService.getCooldown(playerId, 'travel');
    if (cooldown && cooldown.remainingSeconds > 0) {
      return res.json({
        success: true,
        countries: [],
        cooldown: {
          actionType: 'travel',
          remainingSeconds: cooldown.remainingSeconds,
        },
      });
    }
    
    // Get player's current country to calculate routes
    const currentCountry = await travelService.getPlayerCountry(playerId);
    const countries = travelService.getAllCountriesWithRoutes(currentCountry);
    
    return res.json({
      success: true,
      countries,
      currentCountry,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * GET /travel/current
 * Get player's current country (authenticated)
 */
router.get(
  '/current',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const currentCountry = await travelService.getCurrentCountryInfo(playerId);
      return res.json({
        success: true,
        country: currentCountry,
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * GET /travel/status
 * Get current journey status (authenticated)
 */
router.get(
  '/status',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const status = await travelService.getJourneyStatus(playerId);
      return res.json({
        success: true,
        ...status,
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * POST /travel/next
 * Continue to next leg of journey (authenticated)
 */
router.post(
  '/next',
  authenticate,
  checkCooldown('travel'),
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      // Check if player is in jail
      const remainingJailTime = await policeService.checkIfJailed(playerId);
      if (remainingJailTime > 0) {
        return res.status(403).json({
          event: 'error.jailed',
          params: {
            remainingTime: remainingJailTime,
          },
        });
      }

      // Continue journey
      const result = await travelService.continueJourney(playerId);
      
      // Set cooldown after successful travel
      const cooldownInfo = await cooldownService.setCooldown(playerId, 'travel');

      return res.json({
        ...result,
        message: `Je bent aangekomen in ${result.newLocation}!`,
        cooldown: {
          actionType: 'travel',
          remainingSeconds: cooldownInfo.remainingSeconds,
        },
      });
    } catch (error: any) {
      // Handle specific travel errors
      if (error.message === 'NOT_IN_TRANSIT') {
        return res.status(400).json({
          success: false,
          error: 'NOT_IN_TRANSIT',
          message: 'Je bent niet onderweg.',
        });
      }

      if (error.message === 'JOURNEY_COMPLETE') {
        return res.status(400).json({
          success: false,
          error: 'JOURNEY_COMPLETE',
          message: 'Je reis is al compleet! Je bent aangekomen.',
        });
      }

      if (error.message === 'INVALID_ROUTE') {
        return res.status(400).json({
          success: false,
          error: 'INVALID_ROUTE',
          message: 'Ongeldige reisroute. Reis annuleren en opnieuw starten.',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor deze leg.',
        });
      }

      if (error.message === 'COUNTRY_NOT_FOUND') {
        return res.status(400).json({
          success: false,
          error: 'COUNTRY_NOT_FOUND',
          message: 'Land bestaat niet.',
        });
      }

      if (error.message === 'JAILED_IN_TRANSIT') {
        return res.status(403).json({
          event: 'error.jailed',
          params: {
            remainingTime: error.jailTime ?? 0,
          },
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /travel/cancel
 * Cancel current journey (authenticated)
 */
router.post(
  '/cancel',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      // Cancel journey
      const result = await travelService.cancelJourney(playerId);

      return res.json({
        success: true,
        messageKey: 'travelJourneyCanceled',
      });
    } catch (error: any) {
      // Handle specific cancel errors
      if (error.message === 'NOT_IN_TRANSIT') {
        return res.status(400).json({
          success: false,
          error: 'NOT_IN_TRANSIT',
          message: 'Je bent niet onderweg.',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /travel/:countryId
 * Start a multi-leg journey to a country (authenticated)
 */
router.post(
  '/:countryId',
  authenticate,
  checkCooldown('travel'),
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      // Check if player is in jail
      const remainingJailTime = await policeService.checkIfJailed(playerId);
      if (remainingJailTime > 0) {
        return res.status(403).json({
          event: 'error.jailed',
          params: {
            remainingTime: remainingJailTime,
          },
        });
      }

      const countryId = req.params.countryId as string;

      // Start journey
      const result = await travelService.startJourney(playerId, countryId);
      
      // Set cooldown after successful travel
      const cooldownInfo = await cooldownService.setCooldown(playerId, 'travel');

      return res.json({
        ...result,
        message: `Journey started! You are now en route to ${result.destinationCountry}. First stop: ${result.nextLeg}`,
        cooldown: {
          actionType: 'travel',
          remainingSeconds: cooldownInfo.remainingSeconds,
        },
      });
    } catch (error: any) {
      // Handle specific travel errors
      if (error.message === 'INVALID_COUNTRY') {
        return res.status(400).json({
          success: false,
          error: 'INVALID_COUNTRY',
          message: 'Dit land bestaat niet.',
        });
      }

      if (error.message === 'ALREADY_IN_COUNTRY') {
        return res.status(400).json({
          success: false,
          error: 'ALREADY_IN_COUNTRY',
          message: 'Je bent al in dit land.',
        });
      }

      if (error.message === 'ALREADY_IN_TRANSIT') {
        return res.status(400).json({
          success: false,
          error: 'ALREADY_IN_TRANSIT',
          message: 'Je bent al onderweg. Cancel de huidge reis eerst.',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor de eerste leg van deze reis.',
        });
      }

      if (error.message === 'TOO_MANY_DRUGS') {
        return res.status(400).json({
          success: false,
          error: 'TOO_MANY_DRUGS',
          message: error.message || 'Je draagt te veel drugs om te reizen. Max: 1kg.',
        });
      }

      if (error.message === 'JAILED_IN_TRANSIT') {
        return res.status(403).json({
          event: 'error.jailed',
          params: {
            remainingTime: error.jailTime ?? 0,
          },
        });
      }

      return next(error);
    }
  }
);

export default router;
