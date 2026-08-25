import { Router, Response } from 'express';
import { randomUUID } from 'crypto';
import { worldEventService } from '../services/worldEventService';
import { eventBroadcaster } from '../services/eventBroadcaster';
import { authenticate, AuthRequest } from '../middleware/authenticate';

const router = Router();

/**
 * GET /events
 * Recent activity for the authenticated player (personal dashboard feed).
 */
router.get('/', authenticate, async (req: AuthRequest, res: Response) => {
  try {
    const playerId = req.player!.id;
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;

    const validLimit = Math.min(Math.max(1, limit), 100);
    const validOffset = Math.max(0, offset);

    const events = await worldEventService.getRecentEvents(validLimit, validOffset, {
      playerId,
    });
    const total = await worldEventService.getEventCount(playerId);

    return res.status(200).json({
      event: 'events.list',
      params: {
        limit: validLimit,
        offset: validOffset,
        total,
        scope: 'player',
      },
      events,
    });
  } catch {
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

/**
 * GET /events/stream
 * SSE for the authenticated player's own activity.
 */
router.get('/stream', authenticate, (req: AuthRequest, res: Response) => {
  const clientId = randomUUID();
  const playerId = req.player!.id;

  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no');

  eventBroadcaster.addClient(clientId, res, playerId);

  req.on('close', () => {
    eventBroadcaster.removeClient(clientId);
  });
});

export default router;
