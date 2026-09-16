import prisma from '../lib/prisma';
import { isVipStatusActive } from './vipBenefitsService';
import {
  RLD_COUNTRY_SLUGS,
  RLD_EVENT_CATALOG,
  getTierConfig,
  normalizeRldCountry,
} from './rldConfig';

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
  vipOnly: boolean;
  eventKey: string | null;
  createdAt: Date;
}

interface ParticipationResult {
  success: boolean;
  message: string;
  earnings?: number;
}

function mapEvent(event: any): VipEventData {
  return {
    ...event,
    bonusMultiplier: Number(event.bonusMultiplier),
    vipOnly: !!event.vipOnly,
    eventKey: event.eventKey ?? event.eventType ?? null,
  };
}

function catalogForKey(eventKey: string) {
  return RLD_EVENT_CATALOG.find((e) => e.eventKey === eventKey);
}

export const vipEventService = {
  async getActiveEvents(countryCode: string): Promise<VipEventData[]> {
    const now = new Date();
    const slug = normalizeRldCountry(countryCode);
    const events = await prisma.vipEvent.findMany({
      where: {
        countryCode: slug,
        startTime: { lte: now },
        endTime: { gte: now },
      },
      orderBy: { endTime: 'asc' },
    });
    return events.map(mapEvent);
  },

  async getUpcomingEvents(countryCode?: string): Promise<VipEventData[]> {
    const now = new Date();
    const future = new Date(now.getTime() + 24 * 60 * 60 * 1000);
    const where: any = {
      startTime: { gt: now, lte: future },
      endTime: { gte: now },
    };
    if (countryCode) {
      where.countryCode = normalizeRldCountry(countryCode);
    }
    const events = await prisma.vipEvent.findMany({
      where,
      orderBy: { startTime: 'asc' },
    });
    return events.map(mapEvent);
  },

  async getEventById(eventId: number) {
    const event = await prisma.vipEvent.findUnique({
      where: { id: eventId },
      include: {
        participations: {
          include: {
            prostitute: true,
            player: { select: { id: true, username: true } },
          },
        },
      },
    });
    if (!event) return null;
    return mapEvent(event);
  },

  async participateInEvent(
    playerId: number,
    prostituteId: number,
    eventId: number
  ): Promise<ParticipationResult> {
    const event = await prisma.vipEvent.findUnique({ where: { id: eventId } });
    if (!event) {
      return { success: false, message: 'Event niet gevonden' };
    }

    const now = new Date();
    if (now < event.startTime) {
      return { success: false, message: 'Dit event is nog niet begonnen' };
    }
    if (now > event.endTime) {
      return { success: false, message: 'Dit event is afgelopen' };
    }
    if (event.currentParticipants >= event.maxParticipants) {
      return { success: false, message: 'Dit event is vol' };
    }

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { currentCountry: true, isVip: true, vipExpiresAt: true },
    });
    if (!player) return { success: false, message: 'Speler niet gevonden' };

    const eventCountry = normalizeRldCountry(event.countryCode);
    if (normalizeRldCountry(player.currentCountry) !== eventCountry) {
      return { success: false, message: 'Je moet in hetzelfde land zijn als het event' };
    }

    if (event.vipOnly && !isVipStatusActive(player)) {
      return { success: false, message: 'Dit salon-event is alleen voor VIP-leden' };
    }

    const prostitute = await prisma.prostitute.findUnique({
      where: { id: prostituteId },
      include: { redLightRoom: { include: { redLightDistrict: true } } },
    });

    if (!prostitute || prostitute.playerId !== playerId) {
      return { success: false, message: 'Recruit niet gevonden' };
    }
    if (prostitute.isBusted && prostitute.bustedUntil && prostitute.bustedUntil > now) {
      return { success: false, message: 'Deze recruit is gearresteerd' };
    }
    if (prostitute.level < event.minLevelRequired) {
      return {
        success: false,
        message: `Deze recruit moet minstens level ${event.minLevelRequired} zijn`,
      };
    }

    if (prostitute.location === 'redlight') {
      const district = prostitute.redLightRoom?.redLightDistrict;
      if (!district || normalizeRldCountry(district.countryCode) !== eventCountry) {
        return { success: false, message: 'Deze recruit moet in hetzelfde land werken' };
      }
    } else if (prostitute.location === 'nightclub') {
      return { success: false, message: 'Haal haar eerst uit de nachtclub' };
    }

    const existingParticipation = await prisma.eventParticipation.findUnique({
      where: { prostituteId_eventId: { prostituteId, eventId } },
    });
    if (existingParticipation) {
      return { success: false, message: 'Deze recruit doet al mee' };
    }

    await prisma.$transaction(async (tx) => {
      await tx.eventParticipation.create({
        data: { eventId, playerId, prostituteId, status: 'active' },
      });
      await tx.vipEvent.update({
        where: { id: eventId },
        data: { currentParticipants: { increment: 1 } },
      });
    });

    return { success: true, message: 'Je doet mee aan het event' };
  },

  async leaveEvent(
    playerId: number,
    eventId: number,
    prostituteId: number
  ): Promise<ParticipationResult> {
    const participation = await prisma.eventParticipation.findUnique({
      where: { prostituteId_eventId: { prostituteId, eventId } },
    });
    if (!participation) {
      return { success: false, message: 'Je doet niet mee' };
    }
    if (participation.playerId !== playerId) {
      return { success: false, message: 'Niet toegestaan' };
    }
    if (participation.status !== 'active') {
      return { success: false, message: 'Deelname is al afgelopen' };
    }

    await prisma.$transaction(async (tx) => {
      await tx.eventParticipation.update({
        where: { id: participation.id },
        data: { status: 'cancelled', completedAt: new Date() },
      });
      await tx.vipEvent.update({
        where: { id: eventId },
        data: { currentParticipants: { decrement: 1 } },
      });
    });

    return { success: true, message: 'Je hebt het event verlaten' };
  },

  async getPlayerParticipations(playerId: number) {
    const participations = await prisma.eventParticipation.findMany({
      where: { playerId, status: 'active' },
      include: { event: true, prostitute: true },
      orderBy: { participatedAt: 'desc' },
    });
    return participations.map((p) => ({
      ...p,
      event: mapEvent(p.event),
    }));
  },

  async settleEventEarnings(): Promise<number> {
    const now = new Date();
    let totalSettled = 0;
    const activeParticipations = await prisma.eventParticipation.findMany({
      where: { status: 'active' },
      include: {
        event: true,
        prostitute: {
          include: {
            redLightRoom: { include: { redLightDistrict: true } },
          },
        },
        player: true,
      },
    });

    for (const participation of activeParticipations) {
      const { event, prostitute, player } = participation;
      if (now < event.startTime) continue;
      if (now > event.endTime) {
        await prisma.eventParticipation.update({
          where: { id: participation.id },
          data: { status: 'completed', completedAt: now },
        });
        continue;
      }

      let baseRate = 40;
      if (prostitute.location === 'redlight' && prostitute.redLightRoom) {
        const tier = prostitute.redLightRoom.redLightDistrict.tier;
        baseRate = getTierConfig(tier).gross;
      }
      const levelBonus = 1 + (prostitute.level - 1) * 0.05;
      baseRate *= levelBonus;
      const eventRate = baseRate * Number(event.bonusMultiplier);
      const lastEarnings = participation.participatedAt;
      const hoursPassed = Math.min(
        (now.getTime() - lastEarnings.getTime()) / (1000 * 60 * 60),
        (event.endTime.getTime() - lastEarnings.getTime()) / (1000 * 60 * 60)
      );
      if (hoursPassed > 0) {
        const earnings = Math.floor(eventRate * hoursPassed);
        await prisma.$transaction(async (tx) => {
          await tx.player.update({
            where: { id: player.id },
            data: { money: { increment: earnings } },
          });
          await tx.eventParticipation.update({
            where: { id: participation.id },
            data: { earnings: { increment: earnings }, participatedAt: now },
          });
        });
        totalSettled += earnings;
      }
      if (now >= event.endTime) {
        await prisma.eventParticipation.update({
          where: { id: participation.id },
          data: { status: 'completed', completedAt: now },
        });
      }
    }
    return totalSettled;
  },

  async endExpiredEvents(): Promise<number> {
    const now = new Date();
    const expiredEvents = await prisma.vipEvent.findMany({
      where: { endTime: { lt: now }, currentParticipants: { gt: 0 } },
    });
    for (const event of expiredEvents) {
      await prisma.eventParticipation.updateMany({
        where: { eventId: event.id, status: 'active' },
        data: { status: 'completed', completedAt: now },
      });
      await prisma.vipEvent.update({
        where: { id: event.id },
        data: { currentParticipants: 0 },
      });
    }
    return expiredEvents.length;
  },

  async scheduleCountryEvents(): Promise<number> {
    const now = new Date();
    let created = 0;
    const streetCatalog = RLD_EVENT_CATALOG.filter((e) => !e.vipOnly);
    const vipCatalog = RLD_EVENT_CATALOG.filter((e) => e.vipOnly);

    for (const country of RLD_COUNTRY_SLUGS) {
      const active = await prisma.vipEvent.findMany({
        where: { countryCode: country, endTime: { gte: now } },
        orderBy: { startTime: 'asc' },
      });
      const live = active.filter((e) => e.startTime <= now);
      const upcoming = active.filter((e) => e.startTime > now);
      if (live.length === 0) {
        const pick = streetCatalog[Math.floor(Math.random() * streetCatalog.length)];
        await this.createCatalogEvent(country, pick, now);
        created += 1;
      }
      if (upcoming.length === 0) {
        const liveEnd =
          live[0]?.endTime ??
          active.find((e) => e.startTime <= now)?.endTime ??
          now;
        const useVip = Math.random() < 0.35;
        const pick = useVip
          ? vipCatalog[Math.floor(Math.random() * vipCatalog.length)]
          : streetCatalog[Math.floor(Math.random() * streetCatalog.length)];
        await this.createCatalogEvent(country, pick, liveEnd);
        created += 1;
      }
    }
    return created;
  },

  async createCatalogEvent(
    country: string,
    pick: (typeof RLD_EVENT_CATALOG)[number],
    start: Date
  ) {
    const startTime = new Date(Math.max(start.getTime(), Date.now()));
    const endTime = new Date(startTime.getTime() + pick.durationHours * 60 * 60 * 1000);
    return prisma.vipEvent.create({
      data: {
        title: pick.titleNl,
        description: pick.descriptionNl,
        eventType: pick.eventType,
        eventKey: pick.eventKey,
        countryCode: country,
        startTime,
        endTime,
        bonusMultiplier: pick.bonusMultiplier,
        minLevelRequired: pick.minLevelRequired,
        maxParticipants: pick.maxParticipants,
        vipOnly: pick.vipOnly,
      },
    });
  },
};
