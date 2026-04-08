import { Router, Request, Response } from 'express';
import { worldEventService } from '../services/worldEventService';
import { eventBroadcaster } from '../services/eventBroadcaster';
import { randomUUID } from 'crypto';

const router = Router();

/**
 * GET /events
 * Get recent world events (paginated)
 */
router.get('/', async (req: Request, res: Response) => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const offset = parseInt(req.query.offset as string) || 0;

    // Validate limit (max 100)
    const validLimit = Math.min(Math.max(1, limit), 100);
    const validOffset = Math.max(0, offset);

    const events = await worldEventService.getRecentEvents(validLimit, validOffset);
    const total = await worldEventService.getEventCount();

    return res.status(200).json({
      event: 'events.list',
      params: {
        limit: validLimit,
        offset: validOffset,
        total,
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
 * Server-Sent Events endpoint for live world events
 */
router.get('/stream', (req: Request, res: Response) => {
  const clientId = randomUUID();

  // Set SSE headers
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.setHeader('X-Accel-Buffering', 'no'); // Disable nginx buffering

  // Add client to broadcaster
  eventBroadcaster.addClient(clientId, res);

  // Handle client disconnect
  req.on('close', () => {
    eventBroadcaster.removeClient(clientId);
  });
});

export default router;
