import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { seasonPassService } from '../services/seasonPassService';

const router = Router();

router.get('/status', authenticate, async (req: AuthRequest, res) => {
  try {
    const status = await seasonPassService.getSeasonPassStatus(req.player!.id);
    return res.status(200).json({
      event: 'season_pass.status',
      params: {},
      ...status,
    });
  } catch (error) {
    console.error('[SeasonPass] status failed', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

router.post('/claim', authenticate, async (req: AuthRequest, res) => {
  try {
    const level = Number(req.body?.level);
    const trackRaw = String(req.body?.track || '').toLowerCase();
    const track = trackRaw === 'premium' ? 'premium' : trackRaw === 'free' ? 'free' : null;
    if (!Number.isFinite(level) || level <= 0 || !track) {
      return res.status(400).json({
        event: 'season_pass.claim_invalid',
        params: { reason: 'INVALID_INPUT' },
      });
    }

    const result = await seasonPassService.claimSeasonPassReward(
      req.player!.id,
      Math.floor(level),
      track,
    );

    if (!result.ok) {
      return res.status(400).json({
        event: 'season_pass.claim_denied',
        params: { reason: result.reason },
      });
    }

    const status = await seasonPassService.getSeasonPassStatus(req.player!.id);
    return res.status(200).json({
      event: 'season_pass.claimed',
      params: {},
      rewards: result.rewards,
      ...status,
    });
  } catch (error) {
    console.error('[SeasonPass] claim failed', error);
    return res.status(500).json({ event: 'error.internal', params: {} });
  }
});

export default router;
