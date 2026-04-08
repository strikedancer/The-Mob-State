import express from 'express';
import { authenticate } from '../middleware/authenticate';
import backpackService from '../services/backpackService';
import { worldEventService } from '../services/worldEventService';

const router = express.Router();

/**
 * GET /backpacks/all
 * Get all backpacks (catalog)
 */
router.get('/all', authenticate, async (req, res) => {
  try {
    const backpacks = backpackService.getAllBackpacks();
    res.json({ success: true, backpacks });
  } catch (error) {
    console.error('Error fetching backpacks:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Fout bij ophalen van rugzakken' 
    });
  }
});

/**
 * GET /backpacks/mine
 * Get player's current backpack
 */
router.get('/mine', authenticate, async (req, res) => {
  try {
    const playerId = (req as any).player.id;
    const playerBackpack = await backpackService.getPlayerBackpack(playerId);
    
    res.json({ 
      success: true, 
      backpack: playerBackpack?.backpack || null,
      purchasedAt: playerBackpack?.purchasedAt || null
    });
  } catch (error) {
    console.error('Error fetching player backpack:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Fout bij ophalen van je rugzak' 
    });
  }
});

/**
 * GET /backpacks/available
 * Get backpacks available for player to purchase/upgrade
 */
router.get('/available', authenticate, async (req, res) => {
  try {
    const playerId = (req as any).player.id;
    const result = await backpackService.getAvailableBackpacks(playerId);
    
    res.json({ 
      success: true, 
      ...result
    });
  } catch (error) {
    console.error('Error fetching available backpacks:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Fout bij ophalen van beschikbare rugzakken' 
    });
  }
});

/**
 * GET /backpacks/capacity
 * Get player's total carrying capacity
 */
router.get('/capacity', authenticate, async (req, res) => {
  try {
    const playerId = (req as any).player.id;
    const capacity = await backpackService.getPlayerCarryingCapacity(playerId);
    
    res.json({ 
      success: true, 
      capacity,
      base: 5,
      bonus: capacity - 5
    });
  } catch (error) {
    console.error('Error fetching player capacity:', error);
    res.status(500).json({ 
      success: false, 
      message: 'Fout bij ophalen van draagcapaciteit' 
    });
  }
});

/**
 * POST /backpacks/purchase/:backpackId
 * Purchase a backpack
 */
router.post('/purchase/:backpackId', authenticate, async (req, res) => {
  try {
    const playerId = (req as any).player.id;
    const backpackId = req.params.backpackId;

    const result = await backpackService.purchaseBackpack(playerId, backpackId);
    
    // Create world event for this action
    if (result.event) {
      await worldEventService.createEvent(result.event, result.params || {}, playerId);
    }
    
    if (result.success) {
      res.json({ 
        success: true,
        event: result.event,
        params: result.params,
        backpack: result.backpack
      });
    } else {
      res.status(400).json({ 
        success: false,
        event: result.event,
        params: result.params
      });
    }
  } catch (error) {
    console.error('Error purchasing backpack:', error);
    res.status(500).json({ 
      success: false, 
      event: 'backpack.purchase_failed',
      params: { reason: 'server_error' }
    });
  }
});

/**
 * POST /backpacks/upgrade/:backpackId
 * Upgrade to a better backpack
 */
router.post('/upgrade/:backpackId', authenticate, async (req, res) => {
  try {
    const playerId = (req as any).player.id;
    const backpackId = req.params.backpackId;

    const result = await backpackService.upgradeBackpack(playerId, backpackId);
    
    // Create world event for this action
    if (result.event) {
      await worldEventService.createEvent(result.event, result.params || {}, playerId);
    }
    
    if (result.success) {
      res.json({ 
        success: true,
        event: result.event,
        params: result.params,
        backpack: result.backpack
      });
    } else {
      res.status(400).json({ 
        success: false,
        event: result.event,
        params: result.params
      });
    }
  } catch (error) {
    console.error('Error upgrading backpack:', error);
    res.status(500).json({ 
      success: false, 
      event: 'backpack.upgrade_failed',
      params: { reason: 'server_error' }
    });
  }
});

export default router;
