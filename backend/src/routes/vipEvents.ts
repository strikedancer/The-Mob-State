import { Router } from 'express';
import { vipEventService } from '../services/vipEventService';
import { authenticate, AuthRequest } from '../middleware/authenticate';

const router = Router();

/**
 * GET /vip-events/active/:countryCode
 * Get all active events in a country
 */
router.get('/active/:countryCode', authenticate, async (req: AuthRequest, res) => {
  try {
    const { countryCode } = req.params;
    const events = await vipEventService.getActiveEvents(countryCode as string);
    
    res.json({
      success: true,
      events
    });
  } catch (error) {
    console.error('[VIP Events] Error fetching active events:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch active events'
    });
  }
});

/**
 * GET /vip-events/upcoming
 * Get upcoming events (starting within 24 hours)
 */
router.get('/upcoming', authenticate, async (req: AuthRequest, res) => {
  try {
    const { countryCode } = req.query;
    const events = await vipEventService.getUpcomingEvents(countryCode as string);
    
    res.json({
      success: true,
      events
    });
  } catch (error) {
    console.error('[VIP Events] Error fetching upcoming events:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch upcoming events'
    });
  }
});

/**
 * GET /vip-events/:id
 * Get specific event details
 */
router.get('/:id', authenticate, async (req: AuthRequest, res) => {
  try {
    const eventId = parseInt(req.params.id as string);
    const event = await vipEventService.getEventById(eventId);
    
    if (!event) {
      return res.status(404).json({
        success: false,
        message: 'Event not found'
      });
    }
    
    res.json({
      success: true,
      event
    });
  } catch (error) {
    console.error('[VIP Events] Error fetching event:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch event'
    });
  }
});

/**
 * POST /vip-events/:id/participate
 * Participate in an event with a prostitute
 */
router.post('/:id/participate', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const eventId = parseInt(req.params.id as string);
    const { prostituteId } = req.body;
    
    if (!prostituteId) {
      return res.status(400).json({
        success: false,
        message: 'Prostitute ID is required'
      });
    }
    
    const result = await vipEventService.participateInEvent(
      playerId,
      parseInt(prostituteId),
      eventId
    );
    
    res.json(result);
  } catch (error) {
    console.error('[VIP Events] Error participating in event:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to participate in event'
    });
  }
});

/**
 * POST /vip-events/:id/leave
 * Leave an event
 */
router.post('/:id/leave', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const eventId = parseInt(req.params.id as string);
    const { prostituteId } = req.body;
    
    if (!prostituteId) {
      return res.status(400).json({
        success: false,
        message: 'Prostitute ID is required'
      });
    }
    
    const result = await vipEventService.leaveEvent(
      playerId,
      eventId,
      parseInt(prostituteId)
    );
    
    res.json(result);
  } catch (error) {
    console.error('[VIP Events] Error leaving event:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to leave event'
    });
  }
});

/**
 * GET /vip-events/my-participations
 * Get player's active event participations
 */
router.get('/my/participations', authenticate, async (req: AuthRequest, res) => {
  try {
    const playerId = req.player!.id;
    const participations = await vipEventService.getPlayerParticipations(playerId);
    
    res.json({
      success: true,
      participations
    });
  } catch (error) {
    console.error('[VIP Events] Error fetching participations:', error);
    res.status(500).json({
      success: false,
      message: 'Failed to fetch participations'
    });
  }
});

export default router;
