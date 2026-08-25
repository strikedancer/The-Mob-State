import prisma from '../lib/prisma';
import { eventBroadcaster } from './eventBroadcaster';
import {
  isPublicWorldFeedEvent,
  PUBLIC_FEED_EXACT_EXCLUDE,
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
   * Create a new world event
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

    // Private / noisy keys stay in DB for debugging/history but are not
    // pushed to every client's public "world feed" SSE channel.
    if (!isPublicWorldFeedEvent(eventKey)) {
      return;
    }

    eventBroadcaster.broadcast({
      event: eventKey,
      params: enrichedParams,
    });
  },

  /**
   * Get recent world events (paginated).
   * Default: public dashboard feed only (excludes DMs, crew chat, job fails, …).
   */
  async getRecentEvents(
    limit = 50,
    offset = 0,
    options?: { publicFeedOnly?: boolean }
  ): Promise<
    Array<{
      id: number;
      eventKey: string;
      params: unknown;
      playerId: number | null;
      createdAt: Date;
    }>
  > {
    const publicFeedOnly = options?.publicFeedOnly !== false;
    // Over-fetch a bit so prefix filters still leave enough rows for the page.
    const fetchTake = publicFeedOnly ? Math.min(limit * 3, 150) : limit;

    const events = await prisma.worldEvent.findMany({
      where: publicFeedOnly
        ? {
            NOT: {
              eventKey: { in: [...PUBLIC_FEED_EXACT_EXCLUDE] },
            },
          }
        : undefined,
      orderBy: {
        createdAt: 'desc',
      },
      take: fetchTake,
      skip: offset,
      select: {
        id: true,
        eventKey: true,
        params: true,
        playerId: true,
        createdAt: true,
      },
    });

    const filtered = publicFeedOnly
      ? events.filter((event) => isPublicWorldFeedEvent(event.eventKey)).slice(0, limit)
      : events;

    const playerIds = [
      ...new Set(
        filtered
          .map((event) => event.playerId)
          .filter((id): id is number => typeof id === 'number'),
      ),
    ];
    const players =
      playerIds.length > 0
        ? await prisma.player.findMany({
            where: { id: { in: playerIds } },
            select: { id: true, username: true },
          })
        : [];
    const usernameById = new Map(players.map((p) => [p.id, p.username]));

    return filtered.map((event) => {
      const parsed = safeParse(event.params);
      const params =
        parsed && typeof parsed === 'object' && !Array.isArray(parsed)
          ? {
              ...(parsed as Record<string, unknown>),
              username:
                (parsed as Record<string, unknown>).username ??
                (event.playerId != null
                  ? usernameById.get(event.playerId)
                  : undefined),
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

  /**
   * Get total count of world events
   */
  async getEventCount(): Promise<number> {
    return await prisma.worldEvent.count();
  },
};
