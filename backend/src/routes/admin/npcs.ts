import express, { Request, Response } from 'express';
import { NPCService } from '../../services/npcService';
import { adminAuthMiddleware } from '../../middleware/adminAuth';

const router = express.Router();

/**
 * Create a new NPC
 * POST /api/admin/npcs
 */
router.post('/', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const { username, activityLevel, npcType } = req.body;
    
    // Accept both activityLevel (from frontend) and npcType (legacy)
    const type = activityLevel || npcType;

    if (!username || !type) {
      return res.status(400).json({ 
        error: 'missing_fields',
        message: 'Username and activityLevel are required' 
      });
    }

    if (!['MATIG', 'GEMIDDELD', 'CONTINU'].includes(type)) {
      return res.status(400).json({ 
        error: 'invalid_npc_type',
        message: 'activityLevel must be MATIG, GEMIDDELD, or CONTINU' 
      });
    }

    const result = await NPCService.createNPC({ username, npcType: type });

    res.status(201).json({
      success: true,
      npc: result.npc,
      player: {
        id: result.player.id,
        username: result.player.username,
        money: result.player.money,
        rank: result.player.rank,
        xp: result.player.xp,
      },
    });
  } catch (error: any) {
    console.error('Error creating NPC:', error);
    res.status(500).json({ 
      error: 'creation_failed',
      message: error.message 
    });
  }
});

/**
 * Get all NPCs
 * GET /api/admin/npcs
 */
router.get('/', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const npcs = await NPCService.getAllNPCs();

    res.json({
      success: true,
      npcs,
      count: npcs.length,
    });
  } catch (error: any) {
    console.error('Error fetching NPCs:', error);
    res.status(500).json({ 
      error: 'fetch_failed',
      message: error.message 
    });
  }
});

/**
 * Get NPC statistics
 * GET /api/admin/npcs/:npcId/stats
 */
router.get('/:npcId/stats', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const npcId = parseInt(req.params.npcId);

    if (isNaN(npcId)) {
      return res.status(400).json({ 
        error: 'invalid_id',
        message: 'Invalid NPC ID' 
      });
    }

    const stats = await NPCService.getNPCStats(npcId);

    res.json({
      success: true,
      ...stats,
    });
  } catch (error: any) {
    console.error('Error fetching NPC stats:', error);
    res.status(500).json({ 
      error: 'fetch_failed',
      message: error.message 
    });
  }
});

/**
 * Simulate NPC activity
 * POST /api/admin/npcs/:npcId/simulate
 */
router.post('/:npcId/simulate', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const npcId = parseInt(req.params.npcId);
    const hours = parseFloat(req.body.hours) || 1;

    if (isNaN(npcId)) {
      return res.status(400).json({ 
        error: 'invalid_id',
        message: 'Invalid NPC ID' 
      });
    }

    if (hours <= 0 || hours > 24) {
      return res.status(400).json({ 
        error: 'invalid_hours',
        message: 'Hours must be between 0 and 24' 
      });
    }

    const result = await NPCService.simulateActivity(npcId, hours);

    res.json({
      success: true,
      result,
    });
  } catch (error: any) {
    console.error('Error simulating NPC activity:', error);
    res.status(500).json({ 
      error: 'simulation_failed',
      message: error.message 
    });
  }
});

/**
 * Simulate all active NPCs
 * POST /api/admin/npcs/simulate-all
 */
router.post('/simulate-all/run', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const hours = parseFloat(req.body.hours) || 1;

    if (hours <= 0 || hours > 24) {
      return res.status(400).json({ 
        error: 'invalid_hours',
        message: 'Hours must be between 0 and 24' 
      });
    }

    const result = await NPCService.simulateAllNPCs(hours);

    res.json({
      success: true,
      ...result,
    });
  } catch (error: any) {
    console.error('Error simulating all NPCs:', error);
    res.status(500).json({ 
      error: 'simulation_failed',
      message: error.message 
    });
  }
});

/**
 * Activate NPC
 * POST /api/admin/npcs/:npcId/activate
 */
router.post('/:npcId/activate', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const npcId = parseInt(req.params.npcId);

    if (isNaN(npcId)) {
      return res.status(400).json({ 
        error: 'invalid_id',
        message: 'Invalid NPC ID' 
      });
    }

    await NPCService.activateNPC(npcId);

    res.json({
      success: true,
      message: 'NPC activated',
    });
  } catch (error: any) {
    console.error('Error activating NPC:', error);
    res.status(500).json({ 
      error: 'activation_failed',
      message: error.message 
    });
  }
});

/**
 * Deactivate NPC
 * POST /api/admin/npcs/:npcId/deactivate
 */
router.post('/:npcId/deactivate', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const npcId = parseInt(req.params.npcId);

    if (isNaN(npcId)) {
      return res.status(400).json({ 
        error: 'invalid_id',
        message: 'Invalid NPC ID' 
      });
    }

    await NPCService.deactivateNPC(npcId);

    res.json({
      success: true,
      message: 'NPC deactivated',
    });
  } catch (error: any) {
    console.error('Error deactivating NPC:', error);
    res.status(500).json({ 
      error: 'deactivation_failed',
      message: error.message 
    });
  }
});

/**
 * Delete NPC
 * DELETE /api/admin/npcs/:npcId
 */
router.delete('/:npcId', adminAuthMiddleware, async (req: Request, res: Response) => {
  try {
    const npcId = parseInt(req.params.npcId);

    if (isNaN(npcId)) {
      return res.status(400).json({ 
        error: 'invalid_id',
        message: 'Invalid NPC ID' 
      });
    }

    await NPCService.deleteNPC(npcId);

    res.json({
      success: true,
      message: 'NPC deleted',
    });
  } catch (error: any) {
    console.error('Error deleting NPC:', error);
    res.status(500).json({ 
      error: 'deletion_failed',
      message: error.message 
    });
  }
});

export default router;
