import { Router } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { gameEventService } from '../services/gameEventService';

const router = Router();

router.get('/overview', authenticate, async (req: AuthRequest, res) => {
  try {
    const overview = await gameEventService.getOverview(req.player?.id);

    return res.status(200).json({
      event: 'game_events.overview',
      params: {},
      ...overview,
    });
  } catch (error) {
    console.error('[Game Events] Failed to fetch overview', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/active', authenticate, async (req: AuthRequest, res) => {
  try {
    const overview = await gameEventService.getOverview(req.player?.id);

    return res.status(200).json({
      event: 'game_events.active',
      params: {
        count: overview.active.length,
      },
      events: overview.active,
      myProgress: overview.myProgress,
      serverTime: overview.serverTime,
    });
  } catch (error) {
    console.error('[Game Events] Failed to fetch active events', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/upcoming', authenticate, async (req: AuthRequest, res) => {
  try {
    const overview = await gameEventService.getOverview(req.player?.id);

    return res.status(200).json({
      event: 'game_events.upcoming',
      params: {
        count: overview.upcoming.length,
      },
      events: overview.upcoming,
      serverTime: overview.serverTime,
    });
  } catch (error) {
    console.error('[Game Events] Failed to fetch upcoming events', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/modifiers', authenticate, async (req: AuthRequest, res) => {
  try {
    const targetSystem = typeof req.query.targetSystem === 'string'
      ? req.query.targetSystem
      : undefined;
    const modifiers = await gameEventService.getActiveModifiers(targetSystem);

    return res.status(200).json({
      event: 'game_events.modifiers',
      params: {
        targetSystem: targetSystem ?? null,
        count: modifiers.length,
      },
      modifiers,
    });
  } catch (error) {
    console.error('[Game Events] Failed to fetch modifiers', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

router.get('/:id', authenticate, async (req: AuthRequest, res) => {
  try {
    const liveEventId = parseInt(req.params.id as string, 10);

    if (!Number.isFinite(liveEventId)) {
      return res.status(400).json({
        event: 'error.invalid_event_id',
        params: {},
      });
    }

    const eventDetails = await gameEventService.getEventDetails(liveEventId, req.player?.id);

    if (!eventDetails) {
      return res.status(404).json({
        event: 'error.event_not_found',
        params: {},
      });
    }

    return res.status(200).json({
      event: 'game_events.detail',
      params: {},
      gameEvent: eventDetails,
    });
  } catch (error) {
    console.error('[Game Events] Failed to fetch event detail', error);
    return res.status(500).json({
      event: 'error.internal',
      params: {},
    });
  }
});

export default router;