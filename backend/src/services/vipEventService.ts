import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export interface VipEventData {
  id: number;
  title: string;
  description: string | null;
  eventType: string;
  countryCode: string;
  startTime: Date;
  endTime: Date;
  bonusMultiplier: number;
  minLevelRequired: number;
  maxParticipants: number;
  currentParticipants: number;
  createdAt: Date;
}

interface ParticipationResult {
  success: boolean;
  message: string;
  earnings?: number;
}

export const vipEventService = {
  /**
   * Get all active events in a specific country
   */
  async getActiveEvents(countryCode: string): Promise<VipEventData[]> {
    const now = new Date();
    
    const events = await prisma.vipEvent.findMany({
      where: {
        countryCode,
        startTime: { lte: now },
        endTime: { gte: now }
      },
      orderBy: { endTime: 'asc' }
    });
    
    return events.map(event => ({
      ...event,
      bonusMultiplier: Number(event.bonusMultiplier)
    }));
  },

  /**
   * Get all upcoming events (starting within 24 hours)
   */
  async getUpcomingEvents(countryCode?: string): Promise<VipEventData[]> {
    const now = new Date();
    const future = new Date(now.getTime() + 24 * 60 * 60 * 1000);
    
    const where: any = {
      startTime: {
        gt: now,
        lte: future
      },
      endTime: { gte: now }
    };
    
    if (countryCode) {
      where.countryCode = countryCode;
    }
    
    const events = await prisma.vipEvent.findMany({
      where,
      orderBy: { startTime: 'asc' }
    });
    
    return events.map(event => ({
      ...event,
      bonusMultiplier: Number(event.bonusMultiplier)
    }));
  },

  /**
   * Get event by ID with participation details
   */
  async getEventById(eventId: number) {
    const event = await prisma.vipEvent.findUnique({
      where: { id: eventId },
      include: {
        participations: {
          include: {
            prostitute: true,
            player: {
              select: {
                id: true,
                username: true
              }
            }
          }
        }
      }
    });
    
    if (!event) return null;
    
    return {
      ...event,
      bonusMultiplier: Number(event.bonusMultiplier)
    };
  },

  /**
   * Participate in an event with a prostitute
   */
  async participateInEvent(
    playerId: number,
    prostituteId: number,
    eventId: number
  ): Promise<ParticipationResult> {
    // Check if event exists and is active
    const event = await prisma.vipEvent.findUnique({
      where: { id: eventId }
    });
    
    if (!event) {
      return { success: false, message: 'Event not found' };
    }
    
    const now = new Date();
    if (now < event.startTime) {
      return { success: false, message: 'Event has not started yet' };
    }
    
    if (now > event.endTime) {
      return { success: false, message: 'Event has ended' };
    }
    
    // Check if event is full
    if (event.currentParticipants >= event.maxParticipants) {
      return {success: false, message: 'Event is full' };
    }
    
    // Check if prostitute belongs to player
    const prostitute = await prisma.prostitute.findUnique({
      where: { id: prostituteId },
      include: { redLightRoom: { include: { redLightDistrict: true } } }
    });
    
    if (!prostitute || prostitute.playerId !== playerId) {
      return { success: false, message: 'Prostitute not found or does not belong to you' };
    }
    
    // Check if prostitute is busted
    if (prostitute.isBusted && prostitute.bustedUntil && prostitute.bustedUntil > now) {
      return { success: false, message: 'This prostitute is currently busted' };
    }
    
    // Check if prostitute meets level requirement
    if (prostitute.level < event.minLevelRequired) {
      return {
        success: false,
        message: `This prostitute must be level ${event.minLevelRequired} or higher`
      };
    }
    
    // Check if prostitute is in same country as event
    if (prostitute.location === 'redlight') {
      const district = prostitute.redLightRoom?.redLightDistrict;
      if (!district || district.countryCode !== event.countryCode) {
        return { success: false, message: 'Prostitute must be in the same country as the event' };
      }
    }
    
    // Check if prostitute is already participating in this event
    const existingParticipation = await prisma.eventParticipation.findUnique({
      where: {
        prostituteId_eventId: {
          prostituteId,
          eventId
        }
      }
    });
    
    if (existingParticipation) {
      return { success: false, message: 'This prostitute is already participating in this event' };
    }
    
    // Create participation and update event participant count
    const participation = await prisma.$transaction(async (tx) => {
      // Create participation
      const p = await tx.eventParticipation.create({
        data: {
          eventId,
          playerId,
          prostituteId,
          status: 'active'
        }
      });
      
      // Increment participant count
      await tx.vipEvent.update({
        where: { id: eventId },
        data: { currentParticipants: { increment: 1 } }
      });
      
      return p;
    });
    
    return {
      success: true,
      message: 'Successfully joined the event!'
    };
  },

  /**
   * Leave an event
   */
  async leaveEvent(playerId: number, eventId: number, prostituteId: number): Promise<ParticipationResult> {
    const participation = await prisma.eventParticipation.findUnique({
      where: {
        prostituteId_eventId: {
          prostituteId,
          eventId
        }
      }
    });
    
    if (!participation) {
      return { success: false, message: 'Participation not found' };
    }
    
    if (participation.playerId !== playerId) {
      return { success: false, message: 'Not authorized' };
    }
    
    if (participation.status !== 'active') {
      return { success: false, message: 'Participation is not active' };
    }
    
    await prisma.$transaction(async (tx) => {
      // Update participation status
      await tx.eventParticipation.update({
        where: { id: participation.id },
        data: {
          status: 'cancelled',
          completedAt: new Date()
        }
      });
      
      // Decrement participant count
      await tx.vipEvent.update({
        where: { id: eventId },
        data: { currentParticipants: { decrement: 1 } }
      });
    });
    
    return {
      success: true,
      message: 'Left the event'
    };
  },

  /**
   * Get player's active event participations
   */
  async getPlayerParticipations(playerId: number) {
    const participations = await prisma.eventParticipation.findMany({
      where: {
        playerId,
        status: 'active'
      },
      include: {
        event: true,
        prostitute: true
      },
      orderBy: { participatedAt: 'desc' }
    });
    
    return participations.map(p => ({
      ...p,
      event: {
        ...p.event,
        bonusMultiplier: Number(p.event.bonusMultiplier)
      }
    }));
  },

  /**
   * Calculate and settle earnings for event participations
   * Called by cron job every hour or when event ends
   */
  async settleEventEarnings(): Promise<number> {
    const now = new Date();
    let totalSettled = 0;
    
    // Get all active participations for events that are currently running
    const activeParticipations = await prisma.eventParticipation.findMany({
      where: {
        status: 'active'
      },
      include: {
        event: true,
        prostitute: {
          include: {
            redLightRoom: {
              include: {
                redLightDistrict: true
              }
            }
          }
        },
        player: true
      }
    });
    
    for (const participation of activeParticipations) {
      const { event, prostitute, player } = participation;
      
      // Skip if event not started or already ended
      if (now < event.startTime || now > event.endTime) {
        // If ended, complete the participation
        if (now > event.endTime) {
          await prisma.eventParticipation.update({
            where: { id: participation.id },
            data: {
              status: 'completed',
              completedAt: now
            }
          });
        }
        continue;
      }
      
      // Calculate base hourly rate
      let baseRate = 40; // Street rate
      if (prostitute.location === 'redlight' && prostitute.redLightRoom) {
        const tier = prostitute.redLightRoom.redLightDistrict.tier;
        if (tier === 2) baseRate = 100;
        else if (tier === 3) baseRate = 150;
        else baseRate = 75;
      }
      
      // Apply level bonus
      const levelBonus = 1 + (prostitute.level - 1) * 0.05;
      baseRate *= levelBonus;
      
      // Apply event bonus multiplier
      const eventRate = baseRate * Number(event.bonusMultiplier);
      
      // Calculate hours since last earnings calculation
      const lastEarnings = participation.participatedAt;
      const hoursPassed = Math.min(
        (now.getTime() - lastEarnings.getTime()) / (1000 * 60 * 60),
        (event.endTime.getTime() - lastEarnings.getTime()) / (1000 * 60 * 60)
      );
      
      if (hoursPassed > 0) {
        const earnings = Math.floor(eventRate * hoursPassed);
        
        // Update player money and participation earnings
        await prisma.$transaction(async (tx) => {
          await tx.player.update({
            where: { id: player.id },
            data: { money: { increment: earnings } }
          });
          
          await tx.eventParticipation.update({
            where: { id: participation.id },
            data: { earnings: { increment: earnings } }
          });
        });
        
        totalSettled += earnings;
      }
      
      // If event just ended, complete the participation
      if (now >= event.endTime) {
        await prisma.eventParticipation.update({
          where: { id: participation.id },
          data: {
            status: 'completed',
            completedAt: now
          }
        });
      }
    }
    
    return totalSettled;
  },

  /**
   * End expired events and update participant counts
   */
  async endExpiredEvents(): Promise<number> {
    const now = new Date();
    
    // Find all events that have ended but still have active participations
    const expiredEvents = await prisma.vipEvent.findMany({
      where: {
        endTime: { lt: now },
        currentParticipants: { gt: 0 }
      }
    });
    
    for (const event of expiredEvents) {
      // Complete all active participations
      await prisma.eventParticipation.updateMany({
        where: {
          eventId: event.id,
          status: 'active'
        },
        data: {
          status: 'completed',
          completedAt: now
        }
      });
      
      // Reset participant count
      await prisma.vipEvent.update({
        where: { id: event.id },
        data: { currentParticipants: 0 }
      });
    }
    
    return expiredEvents.length;
  }
};
