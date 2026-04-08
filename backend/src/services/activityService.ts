import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';

const safeStringify = (value: unknown): string => {
  try {
    return JSON.stringify(value ?? {});
  } catch {
    return '{}';
  }
};

const safeParse = (value: string | null | undefined): unknown => {
  if (!value) {
    return {};
  }
  try {
    return JSON.parse(value);
  } catch {
    return value;
  }
};

export const activityService = {
  /**
   * Log a player activity
   */
  async logActivity(
    playerId: number,
    activityType: string,
    description: string,
    details: any = {},
    isPublic: boolean = true
  ) {
    const serializedDetails = safeStringify(details);

    const activity = await prisma.playerActivity.create({
      data: {
        playerId,
        activityType,
        description,
        details: serializedDetails,
        isPublic,
      },
    });

    // Emit SSE event for real-time updates
    await worldEventService.createEvent('player.activity', {
      playerId,
      activityType,
      description,
      details,
    });

    return activity;
  },

  /**
   * Get activity feed for a player's friends
   */
  async getFriendActivityFeed(playerId: number, limit: number = 20) {
    // Get all friends
    const friendships = await prisma.friendship.findMany({
      where: {
        OR: [
          { requesterId: playerId, status: 'accepted' },
          { addresseeId: playerId, status: 'accepted' },
        ],
      },
    });

    // Extract friend IDs
    const friendIds = friendships.map((f) =>
      f.requesterId === playerId ? f.addresseeId : f.requesterId
    );

    // Get recent activities from friends (only public ones)
    const activities = await prisma.playerActivity.findMany({
      where: {
        playerId: { in: friendIds },
        isPublic: true,
      },
      include: {
        player: {
          select: {
            id: true,
            username: true,
            rank: true,
            avatar: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    return activities.map((activity) => ({
      ...activity,
      details: safeParse(activity.details),
    }));
  },

  /**
   * Get a player's own activity history
   */
  async getPlayerActivities(playerId: number, limit: number = 50) {
    const activities = await prisma.playerActivity.findMany({
      where: { playerId },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    return activities.map((activity) => ({
      ...activity,
      details: safeParse(activity.details),
    }));
  },

  /**
   * Delete old activities (cleanup task)
   */
  async cleanupOldActivities(daysToKeep: number = 30) {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysToKeep);

    const result = await prisma.playerActivity.deleteMany({
      where: {
        createdAt: { lt: cutoffDate },
      },
    });

    return result.count;
  },
};
