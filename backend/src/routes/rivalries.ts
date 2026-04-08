import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { rivalryService } from '../services/rivalryService';

const router = Router();

router.get('/active', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const rivals = await rivalryService.getActiveRivals(playerId);
    return res.json({ success: true, rivals });
  } catch (error) {
    console.error('[Rivalries] Error getting active rivals:', error);
    return res.status(500).json({ success: false, message: 'Failed to fetch rivals' });
  }
});

router.post('/start', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const rivalPlayerId = Number(req.body.rivalPlayerId);

    if (!rivalPlayerId) {
      return res.status(400).json({ success: false, message: 'rivalPlayerId is required' });
    }

    const result = await rivalryService.startRivalry(playerId, rivalPlayerId);
    return res.status(result.success ? 200 : 400).json(result);
  } catch (error) {
    console.error('[Rivalries] Error starting rivalry:', error);
    return res.status(500).json({ success: false, message: 'Failed to start rivalry' });
  }
});

router.post('/sabotage', authenticate, async (req: AuthRequest, res) => {
  try {
    const attackerId = req.player!.id;
    const victimId = Number(req.body.victimId);
    const actionType = String(req.body.actionType ?? '');

    if (!victimId || !actionType) {
      return res.status(400).json({
        success: false,
        message: 'victimId and actionType are required',
      });
    }

    const result = await rivalryService.executeSabotage(attackerId, victimId, actionType);
    return res.status(result.success ? 200 : 400).json(result);
  } catch (error) {
    console.error('[Rivalries] Error executing sabotage:', error);
    return res.status(500).json({ success: false, message: 'Failed to execute sabotage' });
  }
});

router.get('/history', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const limit = Math.min(Math.max(Number(req.query.limit) || 20, 1), 100);
    const history = await rivalryService.getHistory(playerId, limit);
    return res.json({ success: true, history });
  } catch (error) {
    console.error('[Rivalries] Error getting history:', error);
    return res.status(500).json({ success: false, message: 'Failed to fetch rivalry history' });
  }
});

router.get('/protection/status', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const protection = await rivalryService.getProtectionStatus(playerId);
    return res.json({ success: true, protection });
  } catch (error) {
    console.error('[Rivalries] Error getting protection status:', error);
    return res.status(500).json({ success: false, message: 'Failed to fetch protection status' });
  }
});

router.post('/protection/buy', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const result = await rivalryService.buyProtectionInsurance(playerId);
    return res.status(result.success ? 200 : 400).json(result);
  } catch (error) {
    console.error('[Rivalries] Error buying protection insurance:', error);
    return res.status(500).json({ success: false, message: 'Failed to buy protection insurance' });
  }
});

export default router;
