import express, { Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { createRateLimiter } from '../middleware/rateLimit';
import { vaultService } from '../services/vaultService';

const router = express.Router();

const vaultRateLimiter = createRateLimiter({
  windowMs: 60 * 1000,
  maxRequests: 25,
  message: 'VAULT_RATE_LIMIT_EXCEEDED',
  keyGenerator: (req) => {
    // @ts-expect-error - player from auth middleware
    const userId = req.player?.id || 'anonymous';
    return `vault:${userId}`;
  },
});

router.get('/status', authenticate, vaultRateLimiter, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  try {
    const data = await vaultService.getStatus(playerId);
    return res.json({ success: true, data });
  } catch (error) {
    console.error('[vault] status error:', error);
    return res.status(500).json({ success: false, event: 'vault.status_failed' });
  }
});

router.post('/attempt', authenticate, vaultRateLimiter, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const guess = String(req.body?.guess ?? '');
  const stakeTier = Number(req.body?.stakeTier ?? 0);

  try {
    const result = await vaultService.attempt(playerId, guess, stakeTier);
    if (!result.success) {
      return res.status(400).json({
        success: false,
        event: 'vault.invalid_request',
        params: { messageNl: result.messageNl, messageEn: result.messageEn },
      });
    }
    return res.json({ success: true, data: result });
  } catch (error: any) {
    const msg = String(error?.message ?? '');
    if (msg === 'INSUFFICIENT_CREDITS') {
      return res.status(400).json({
        success: false,
        event: 'error.insufficient_credits',
        params: {},
      });
    }
    console.error('[vault] attempt error:', error);
    return res.status(500).json({ success: false, event: 'vault.attempt_failed' });
  }
});

export default router;

