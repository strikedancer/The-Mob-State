/**
 * Hit List Routes - Phase C.4
 * 
 * API endpoints for hit list system, bounties, and combat
 */

import express, { Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import * as hitlistService from '../services/hitlistService';
import { applyReputationAction } from '../services/reputationService';

const router = express.Router();

/**
 * POST /hitlist/place/:targetId
 * Place a hit on a player (requires bounty)
 */
router.post(
  '/place/:targetId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const targetId = parseInt(req.params.targetId);
      const { bounty } = req.body;

      if (!bounty) {
        return res.status(400).json({
          success: false,
          error: 'MISSING_BOUNTY',
          message: 'Bounty bedrag is vereist',
        });
      }

      const hit = await hitlistService.placeHit(playerId, targetId, bounty);

      return res.json({
        success: true,
        hit,
        message: `Hit geplaatst op speler voor €${bounty}`,
      });
    } catch (error: any) {
      if (error.message === 'BOUNTY_TOO_LOW') {
        return res.status(400).json({
          success: false,
          error: 'BOUNTY_TOO_LOW',
          message: 'Minimale bounty is €50,000',
        });
      }

      if (error.message === 'CANNOT_HIT_YOURSELF') {
        return res.status(400).json({
          success: false,
          error: 'CANNOT_HIT_YOURSELF',
          message: 'Je kunt jezelf niet op de moordlijst zetten',
        });
      }

      if (error.message === 'HIT_ALREADY_EXISTS') {
        return res.status(400).json({
          success: false,
          error: 'HIT_ALREADY_EXISTS',
          message: 'Je hebt al een actieve hit op deze speler',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor deze bounty',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /hitlist/counter-bounty/:hitId
 * Place a counter bounty on a hit (only target can do this)
 */
router.post(
  '/counter-bounty/:hitId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const hitId = parseInt(req.params.hitId);
      const { counterBounty } = req.body;

      if (!counterBounty) {
        return res.status(400).json({
          success: false,
          error: 'MISSING_COUNTER_BOUNTY',
          message: 'Tegen-bod bedrag is vereist',
        });
      }

      const hit = await hitlistService.placeCounterBounty(
        playerId,
        hitId,
        counterBounty
      );

      return res.json({
        success: true,
        hit,
        message: `Tegen-bod van €${counterBounty} geplaatst`,
      });
    } catch (error: any) {
      if (error.message === 'HIT_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'HIT_NOT_FOUND',
          message: 'Hit niet gevonden',
        });
      }

      if (error.message === 'NOT_TARGET') {
        return res.status(403).json({
          success: false,
          error: 'NOT_TARGET',
          message: 'Alleen het doelwit kan een tegen-bod plaatsen',
        });
      }

      if (error.message === 'HIT_NOT_ACTIVE') {
        return res.status(400).json({
          success: false,
          error: 'HIT_NOT_ACTIVE',
          message: 'Hit is niet actief',
        });
      }

      if (error.message === 'COUNTER_BOUNTY_MUST_BE_HIGHER') {
        return res.status(400).json({
          success: false,
          error: 'COUNTER_BOUNTY_MUST_BE_HIGHER',
          message: 'Tegen-bod moet hoger zijn dan originele bounty',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor dit tegen-bod',
        });
      }

      return next(error);
    }
  }
);

/**
 * GET /hitlist/active
 * Get all active hits
 */
router.get('/active', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const page = parseInt(req.query.page as string) || 0;
    const pageSize = 20;
    const offset = page * pageSize;

    const hits = await hitlistService.getActiveHits(pageSize, offset);

    return res.json({
      success: true,
      hits,
      page,
    });
  } catch (error) {
    return next(error);
  }
});

/**
 * POST /hitlist/attempt/:hitId
 * Attempt to complete a hit (combat mechanic)
 */
router.post(
  '/attempt/:hitId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const hitId = parseInt(req.params.hitId);
      const { weaponId, ammoQuantity } = req.body;

      if (!weaponId) {
        return res.status(400).json({
          success: false,
          error: 'MISSING_WEAPON',
          message: 'Wapen is vereist',
        });
      }

      const result = await hitlistService.attemptHit(
        playerId,
        hitId,
        weaponId,
        ammoQuantity
      );

      const reputation = result.success
        ? await applyReputationAction(playerId, 'hit_claim_success', true)
        : undefined;

      return res.json({
        success: result.success,
        reputation,
        ...result,
      });
    } catch (error: any) {
      if (error.message === 'HIT_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'HIT_NOT_FOUND',
          message: 'Hit niet gevonden',
        });
      }

      if (error.message === 'HIT_NOT_ACTIVE') {
        return res.status(400).json({
          success: false,
          error: 'HIT_NOT_ACTIVE',
          message: 'Hit is niet actief',
        });
      }

      if (error.message === 'WEAPON_NOT_FOUND') {
        return res.status(400).json({
          success: false,
          error: 'WEAPON_NOT_FOUND',
          message: 'Wapen niet gevonden',
        });
      }

      if (error.message === 'WEAPON_NOT_OWNED') {
        return res.status(400).json({
          success: false,
          error: 'WEAPON_NOT_OWNED',
          message: 'Je bezit dit wapen niet of het is kapot',
        });
      }

      if (error.message === 'INSUFFICIENT_AMMO') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_AMMO',
          message: 'Je hebt niet genoeg munitie',
        });
      }

      if (error.message === 'INVALID_AMMO') {
        return res.status(400).json({
          success: false,
          error: 'INVALID_AMMO',
          message: 'Ongeldige hoeveelheid munitie',
        });
      }

      if (error.message === 'DIFFERENT_COUNTRY') {
        return res.status(400).json({
          success: false,
          error: 'DIFFERENT_COUNTRY',
          message: 'Je moet in hetzelfde land zijn als het doelwit',
        });
      }

      if (error.message === 'TARGET_UNDER_HIT_PROTECTION') {
        return res.status(400).json({
          success: false,
          error: 'TARGET_UNDER_HIT_PROTECTION',
          message: 'Doelwit heeft actieve moordbescherming',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /hitlist/investigate/:hitId
 * Purchase an investigation report for an active hit target.
 */
router.post(
  '/investigate/:hitId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const hitId = parseInt(req.params.hitId);
      const tier = String(req.body?.tier || 'standard');

      if (!['quick', 'standard', 'deep'].includes(tier)) {
        return res.status(400).json({
          success: false,
          error: 'INVALID_INVESTIGATION_TIER',
          message: 'Ongeldig onderzoekstype',
        });
      }

      const result = await hitlistService.investigateHit(
        playerId,
        hitId,
        tier as 'quick' | 'standard' | 'deep'
      );

      return res.json(result);
    } catch (error: any) {
      if (error.message === 'HIT_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'HIT_NOT_FOUND',
          message: 'Hit niet gevonden',
        });
      }

      if (error.message === 'HIT_NOT_ACTIVE') {
        return res.status(400).json({
          success: false,
          error: 'HIT_NOT_ACTIVE',
          message: 'Hit is niet actief',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld voor dit onderzoek',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /hitlist/cancel/:hitId
 * Cancel a hit (only placer can do this)
 */
router.post(
  '/cancel/:hitId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const hitId = parseInt(req.params.hitId);
      const result = await hitlistService.cancelHit(playerId, hitId);

      return res.json({
        success: true,
        message: 'Hit geannuleerd. Bounty terugbetaald.',
      });
    } catch (error: any) {
      if (error.message === 'HIT_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'HIT_NOT_FOUND',
          message: 'Hit niet gevonden',
        });
      }

      if (error.message === 'NOT_PLACER') {
        return res.status(403).json({
          success: false,
          error: 'NOT_PLACER',
          message: 'Alleen de plaatser kan hit annuleren',
        });
      }

      if (error.message === 'HIT_NOT_ACTIVE') {
        return res.status(400).json({
          success: false,
          error: 'HIT_NOT_ACTIVE',
          message: 'Hit is niet actief',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /security/buy-bodyguards
 * Buy bodyguards for protection
 */
router.post(
  '/buy-bodyguards',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const { quantity } = req.body;

      if (!quantity || quantity < 1) {
        return res.status(400).json({
          success: false,
          error: 'INVALID_QUANTITY',
          message: 'Hoeveelheid moet minimaal 1 zijn',
        });
      }

      const result = await hitlistService.buyBodyguards(playerId, quantity);

      return res.json(result);
    } catch (error: any) {
      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld',
        });
      }

      return next(error);
    }
  }
);

/**
 * POST /security/buy-armor/:armorId
 * Buy armor for protection
 */
router.post(
  '/buy-armor/:armorId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player?.id;
      if (!playerId) {
        return res.status(401).json({ error: 'Not authenticated' });
      }

      const armorId = req.params.armorId;
      const result = await hitlistService.buyArmor(playerId, armorId);

      return res.json(result);
    } catch (error: any) {
      if (error.message === 'ARMOR_NOT_FOUND') {
        return res.status(404).json({
          success: false,
          error: 'ARMOR_NOT_FOUND',
          message: 'Armor niet gevonden',
        });
      }

      if (error.message === 'INSUFFICIENT_MONEY') {
        return res.status(400).json({
          success: false,
          error: 'INSUFFICIENT_MONEY',
          message: 'Je hebt niet genoeg geld',
        });
      }

      return next(error);
    }
  }
);

/**
 * GET /security/status
 * Get player's security status
 */
router.get('/status', authenticate, async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const playerId = req.player?.id;
    if (!playerId) {
      return res.status(401).json({ error: 'Not authenticated' });
    }

    const security = await hitlistService.getSecurityStatus(playerId);

    return res.json({
      success: true,
      security,
    });
  } catch (error) {
    return next(error);
  }
});

export default router;
