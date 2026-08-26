import prisma from '../lib/prisma';
import { eventBroadcaster } from './eventBroadcaster';
import {
  isPersonalDashboardFeedEvent,
  shouldPushPlayerActivitySSE,
} from './worldEventFeedFilter';

const safeStringify = (value: unknown): string => {
  try {
    return JSON.stringify(value ?? {});
  } catch {
    return '{}';
  }
};

const safeParse = (value: string): unknown => {
  try {
    return JSON.parse(value);
  } catch {
    return value;
  }
};

export const worldEventService = {
  /**
   * Create a world/player event. When playerId is set, live SSE goes only to that player
   * (dashboard shows personal activity, not a global feed).
   */
  async createEvent(
    eventKey: string,
    params: Record<string, unknown> = {},
    playerId?: number
  ): Promise<void> {
    const enrichedParams: Record<string, unknown> = { ...params };
    if (playerId != null && enrichedParams.username == null) {
      const player = await prisma.player.findUnique({
        where: { id: playerId },
        select: { username: true },
      });
      if (player?.username) {
        enrichedParams.username = player.username;
      }
    }

    await prisma.worldEvent.create({
      data: {
        eventKey,
        params: safeStringify(enrichedParams),
        playerId,
      },
    });

    if (!shouldPushPlayerActivitySSE(eventKey)) {
      return;
    }

    const payload = {
      event: eventKey,
      params: enrichedParams,
      playerId: playerId ?? null,
    };

    if (playerId != null) {
      eventBroadcaster.sendToPlayer(playerId, payload);
      return;
    }

    // Events without a player (rare system notices) are not pushed to personal feeds.
  },

  /**
   * Recent events for one player (dashboard personal activity feed).
   */
  async getRecentEvents(
    limit = 50,
    offset = 0,
    options?: { playerId?: number }
  ): Promise<
    Array<{
      id: number;
      eventKey: string;
      params: unknown;
      playerId: number | null;
      createdAt: Date;
    }>
  > {
    const playerId = options?.playerId;
    if (playerId == null) {
      return [];
    }

    const events = await prisma.worldEvent.findMany({
      where: { playerId },
      orderBy: { createdAt: 'desc' },
      take: Math.min(Math.max(1, limit) * 2, 100),
      skip: Math.max(0, offset),
      select: {
        id: true,
        eventKey: true,
        params: true,
        playerId: true,
        createdAt: true,
      },
    });

    const filtered = events
      .filter((event) => isPersonalDashboardFeedEvent(event.eventKey))
      .slice(0, limit);

    const player = await prisma.player.findUnique({
      where: { id: playerId },
      select: { username: true },
    });

    return filtered.map((event) => {
      const parsed = safeParse(event.params);
      const params =
        parsed && typeof parsed === 'object' && !Array.isArray(parsed)
          ? {
              ...(parsed as Record<string, unknown>),
              username:
                (parsed as Record<string, unknown>).username ??
                player?.username ??
                undefined,
            }
          : parsed;
      return {
        id: event.id,
        eventKey: event.eventKey,
        params,
        playerId: event.playerId,
        createdAt: event.createdAt,
      };
    });
  },

  async getEventCount(playerId?: number): Promise<number> {
    if (playerId == null) return 0;
    return prisma.worldEvent.count({ where: { playerId } });
  },
};
