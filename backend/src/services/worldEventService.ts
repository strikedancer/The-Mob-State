import prisma from '../lib/prisma';
import { eventBroadcaster } from './eventBroadcaster';

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
    await prisma.worldEvent.create({
      data: {
        eventKey,
        params: safeStringify(params),
        playerId,
      },
    });

    // Broadcast to all connected SSE clients
    eventBroadcaster.broadcast({
      event: eventKey,
      params,
    });
  },

  /**
   * Get recent world events (paginated)
   */
  async getRecentEvents(
    limit = 50,
    offset = 0
  ): Promise<
    Array<{
      id: number;
      eventKey: string;
      params: unknown;
      playerId: number | null;
      createdAt: Date;
    }>
  > {
    const events = await prisma.worldEvent.findMany({
      orderBy: {
        createdAt: 'desc',
      },
      take: limit,
      skip: offset,
      select: {
        id: true,
        eventKey: true,
        params: true,
        playerId: true,
        createdAt: true,
      },
    });

    return events.map((event) => ({
      ...event,
      params: safeParse(event.params),
    }));
  },

  /**
   * Get total count of world events
   */
  async getEventCount(): Promise<number> {
    return await prisma.worldEvent.count();
  },
};
