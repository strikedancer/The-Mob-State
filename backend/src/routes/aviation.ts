/**
 * Aviation Routes - Phase 10.1
 *
 * API endpoints for aviation licensing and aircraft purchases.
 */

import express, { Request, Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as aviationService from '../services/aviationService';

const router = express.Router();

/**
 * GET /aviation/aircraft
 * Get all available aircraft types
 */
router.get('/aircraft', async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const aircraft = aviationService.getAllAircraft();
    return res.json({
      success: true,
      aircraft,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * GET /aviation/licenses
 * Get license pricing and requirements
 */
router.get('/licenses', async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const licenses = aviationService.getLicensePricing();
    return res.json({
      success: true,
      licenses,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * GET /aviation/my-license
 * Get player's aviation license (authenticated)
 */
router.get(
  '/my-license',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const license = await aviationService.getLicense(playerId);

      if (!license) {
        return res.json({
          success: true,
          hasLicense: false,
          license: null,
        });
      }

      return res.json({
        success: true,
        hasLicense: true,
        license: {
          licenseType: license.licenseType,
          purchasePrice: license.purchasePrice,
          issuedAt: license.issuedAt,
        },
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * GET /aviation/my-aircraft
 * Get player's aircraft (authenticated)
 */
router.get(
  '/my-aircraft',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const aircraft = await aviationService.getPlayerAircraft(playerId);
      return res.json({
        success: true,
        aircraft,
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * POST /aviation/buy-license
 * Purchase aviation license (authenticated)
 */
router.post(
  '/buy-license',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const { licenseType = 'basic' } = req.body;

      const result = await aviationService.purchaseLicense(playerId, licenseType);

      return res.json({
        message: `Je hebt een ${licenseType} vlieglicentie gekocht voor €${result.cost.toLocaleString()}!`,
        ...result,
      });
    } catch (error: any) {
      // Handle specific errors
      if (error.message === 'INVALID_LICENSE_TYPE') {
        return res.status(400).json({
          success: false,
          error: 'INVALID_LICENSE_TYPE',
          message: 'Dit type licentie bestaat niet.',
        });
      }

      if (error.message === 'ALREADY_HAS_LICENSE') {
        return res.status(400).json({
          success: false,
          error: 'ALREADY_HAS_LICENSE',
          message: 'Je hebt al een vlieglicentie.',
        });
      }

      if (error.message === 'RANK_TOO_LOW') {
        return res.status(400).json({
          success: false,
          error: 'RANK_TOO_LOW',
          message: 'Je rank is te laag voor deze licentie.',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor deze licentie.',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /aviation/buy-aircraft
 * Purchase aircraft (authenticated)
 */
router.post(
  '/buy-aircraft',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const { aircraftType } = req.body;

      if (!aircraftType) {
        return res.status(400).json({
          success: false,
          error: 'MISSING_AIRCRAFT_TYPE',
          message: 'aircraftType is verplicht.',
        });
      }

      const result = await aviationService.purchaseAircraft(playerId, aircraftType);

      return res.json({
        message: `Je hebt een ${result.aircraftName} gekocht voor €${result.cost.toLocaleString()}!`,
        ...result,
      });
    } catch (error: any) {
      // Handle specific errors
      if (error.message === 'INVALID_AIRCRAFT_TYPE') {
        return res.status(400).json({
          success: false,
          error: 'INVALID_AIRCRAFT_TYPE',
          message: 'Dit type vliegtuig bestaat niet.',
        });
      }

      if (error.message === 'NO_LICENSE') {
        return res.status(400).json({
          success: false,
          error: 'NO_LICENSE',
          message: 'Je hebt een vlieglicentie nodig om een vliegtuig te kopen.',
        });
      }

      if (error.message === 'RANK_TOO_LOW') {
        return res.status(400).json({
          success: false,
          error: 'RANK_TOO_LOW',
          message: 'Je rank is te laag voor dit vliegtuig.',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor dit vliegtuig.',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /aviation/refuel/:aircraftId
 * Refuel aircraft (authenticated)
 */
router.post(
  '/refuel/:aircraftId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const aircraftId = parseInt(req.params.aircraftId as string, 10);
      const { amount } = req.body;

      if (!amount || !Number.isInteger(amount) || amount <= 0) {
        return res.status(400).json({
          success: false,
          error: 'INVALID_AMOUNT',
          message: 'Hoeveelheid moet een positief geheel getal zijn.',
        });
      }

      const result = await aviationService.refuelAircraft(playerId, aircraftId, amount);

      return res.json({
        message: `Je hebt ${result.fuelAdded} liter brandstof getankt voor €${result.cost.toLocaleString()}!`,
        ...result,
      });
    } catch (error: any) {
      if (error.message === 'AIRCRAFT_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'AIRCRAFT_NOT_FOUND',
          message: 'Vliegtuig niet gevonden.',
        });
      }

      if (error.message === 'AIRCRAFT_BROKEN') {
        return res.status(400).json({
          success: false,
          error: 'AIRCRAFT_BROKEN',
          message: 'Dit vliegtuig is kapot en moet gerepareerd worden.',
        });
      }

      if (error.message === 'ALREADY_FULL') {
        return res.status(400).json({
          success: false,
          error: 'ALREADY_FULL',
          message: 'Tank is al vol.',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor brandstof.',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /aviation/fly/:aircraftId
 * Fly to a destination (authenticated)
 */
router.post(
  '/fly/:aircraftId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const aircraftId = parseInt(req.params.aircraftId as string, 10);
      const { destination } = req.body;

      if (!destination) {
        return res.status(400).json({
          success: false,
          error: 'MISSING_DESTINATION',
          message: 'Bestemming is verplicht.',
        });
      }

      const result = await aviationService.flyToDestination(playerId, aircraftId, destination);

      return res.json({
        message: `Je bent aangekomen in ${result.newLocation}!`,
        ...result,
      });
    } catch (error: any) {
      if (error.message === 'AIRCRAFT_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'AIRCRAFT_NOT_FOUND',
          message: 'Vliegtuig niet gevonden.',
        });
      }

      if (error.message === 'AIRCRAFT_BROKEN') {
        return res.status(400).json({
          success: false,
          error: 'AIRCRAFT_BROKEN',
          message: 'Dit vliegtuig is kapot en moet gerepareerd worden.',
        });
      }

      if (error.message === 'INVALID_DESTINATION') {
        return res.status(400).json({
          success: false,
          error: 'INVALID_DESTINATION',
          message: 'Ongeldige bestemming.',
        });
      }

      if (error.message === 'ALREADY_AT_DESTINATION') {
        return res.status(400).json({
          success: false,
          error: 'ALREADY_AT_DESTINATION',
          message: 'Je bent al op deze locatie.',
        });
      }

      if (error.message === 'INSUFFICIENT_FUEL') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_FUEL',
          message: 'Niet genoeg brandstof voor deze vlucht.',
        });
      }

      if (error.message === 'FLIGHT_CAP_REACHED') {
        return res.status(400).json({
          success: false,
          error: 'FLIGHT_CAP_REACHED',
          message: 'Dagelijkse vluchtlimiet bereikt. Probeer morgen opnieuw.',
        });
      }

      return next(error);
    }
  }
);

export default router;
