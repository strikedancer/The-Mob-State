import prisma from '../lib/prisma';
import { emailService } from './emailService';
import { notificationService } from './notificationService';
import { type Language } from './translationService';

export const friendService = {
  /**
   * Send a friend request
   */
  async sendFriendRequest(requesterId: number, addresseeId: number) {
    // Check if trying to friend yourself
    if (requesterId === addresseeId) {
      throw new Error('Cannot send friend request to yourself');
    }

    // Check if addressee exists
    const addressee = await prisma.player.findUnique({
      where: { id: addresseeId },
      select: { id: true, username: true },
    });

    if (!addressee) {
      throw new Error('Player not found');
    }

    // Check if friendship already exists (in either direction)
    const existingFriendship = await prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId, addresseeId },
          { requesterId: addresseeId, addresseeId: requesterId },
        ],
      },
    });

    if (existingFriendship) {
      if (existingFriendship.status === 'accepted') {
        throw new Error('Already friends');
      } else if (existingFriendship.status === 'pending') {
        throw new Error('Friend request already pending');
      } else {
        // If rejected, allow sending a new request
        await prisma.friendship.delete({ where: { id: existingFriendship.id } });
      }
    }

    // Create friend request
    const friendship = await prisma.friendship.create({
      data: {
        requesterId,
        addresseeId,
        status: 'pending',
      },
      include: {
        requester: { select: { id: true, username: true, rank: true } },
        addressee: { select: { id: true, username: true, rank: true, email: true, notifyFriendRequest: true, emailFriendRequest: true, preferredLanguage: true } },
      },
    });

    // Send email notification if enabled
    if (friendship.addressee.email && friendship.addressee.emailFriendRequest) {
      try {
        await emailService.sendFriendRequestEmail(
          friendship.addressee.email,
          friendship.addressee.username,
          friendship.requester.username,
          (friendship.addressee.preferredLanguage as Language) || 'en'
        );
      } catch (error) {
        console.error('[FriendService] Failed to send friend request email:', error);
        // Don't fail the request if email fails
      }
    }

    // Send push notification if enabled
    if (friendship.addressee.notifyFriendRequest) {
      try {
        await notificationService.sendFriendRequestNotification(
          friendship.addressee.id,
          friendship.requester.username,
          (friendship.addressee.preferredLanguage as Language) || 'en'
        );
      } catch (error) {
        console.error('[FriendService] Failed to send friend request push notification:', error);
        // Don't fail the request if notification fails
      }
    }

    // Note: Real-time events handled via SSE or polling
    // No need to send event here

    return friendship;
  },

  /**
   * Accept a friend request
   */
  async acceptFriendRequest(friendshipId: number, playerId: number) {
    const friendship = await prisma.friendship.findUnique({
      where: { id: friendshipId },
      include: {
        requester: { select: { id: true, username: true, rank: true } },
        addressee: { select: { id: true, username: true, rank: true } },
      },
    });

    if (!friendship) {
      throw new Error('Friend request not found');
    }

    // Only the addressee can accept
    if (friendship.addresseeId !== playerId) {
      throw new Error('Not authorized to accept this request');
    }

    if (friendship.status !== 'pending') {
      throw new Error('Friend request is not pending');
    }

    // Update status
    const updated = await prisma.friendship.update({
      where: { id: friendshipId },
      data: { status: 'accepted' },
      include: {
        requester: { select: { id: true, username: true, rank: true, email: true, notifyFriendAccepted: true, emailFriendAccepted: true, preferredLanguage: true } },
        addressee: { select: { id: true, username: true, rank: true } },
      },
    });

    // Send email notification to requester if enabled
    if (updated.requester.email && updated.requester.emailFriendAccepted) {
      try {
        await emailService.sendFriendAcceptedEmail(
          updated.requester.email,
          updated.requester.username,
          updated.addressee.username,
          (updated.requester.preferredLanguage as Language) || 'en'
        );
      } catch (error) {
        console.error('[FriendService] Failed to send friend accepted email:', error);
        // Don't fail the request if email fails
      }
    }

    // Send push notification to requester if enabled
    if (updated.requester.notifyFriendAccepted) {
      try {
        await notificationService.sendFriendAcceptedNotification(
          updated.requester.id,
          updated.addressee.username,
          (updated.requester.preferredLanguage as Language) || 'en'
        );
      } catch (error) {
        console.error('[FriendService] Failed to send friend accepted push notification:', error);
        // Don't fail the request if notification fails
      }
    }

    // Note: Real-time events handled via SSE or polling
    // No need to send event here

    return updated;
  },

  /**
   * Reject a friend request
   */
  async rejectFriendRequest(friendshipId: number, playerId: number) {
    const friendship = await prisma.friendship.findUnique({
      where: { id: friendshipId },
    });

    if (!friendship) {
      throw new Error('Friend request not found');
    }

    // Only the addressee can reject
    if (friendship.addresseeId !== playerId) {
      throw new Error('Not authorized to reject this request');
    }

    if (friendship.status !== 'pending') {
      throw new Error('Friend request is not pending');
    }

    // Delete the friendship (or update to 'rejected' if you want to keep history)
    await prisma.friendship.delete({
      where: { id: friendshipId },
    });

    return { success: true };
  },

  /**
   * Remove a friend (unfriend)
   */
  async removeFriend(friendshipId: number, playerId: number) {
    const friendship = await prisma.friendship.findUnique({
      where: { id: friendshipId },
    });

    if (!friendship) {
      throw new Error('Friendship not found');
    }

    // Either party can remove the friendship
    if (friendship.requesterId !== playerId && friendship.addresseeId !== playerId) {
      throw new Error('Not authorized to remove this friendship');
    }

    if (friendship.status !== 'accepted') {
      throw new Error('Not friends');
    }

    await prisma.friendship.delete({
      where: { id: friendshipId },
    });

    // Notify the other person
    // Note: Real-time events handled via SSE or polling
    // No need to send event here

    return { success: true };
  },

  /**
   * Get all friends (accepted friendships)
   */
  async getFriends(playerId: number) {
    const friendships = await prisma.friendship.findMany({
      where: {
        OR: [
          { requesterId: playerId },
          { addresseeId: playerId },
        ],
        status: 'accepted',
      },
      include: {
        requester: { 
          select: { 
            id: true, 
            username: true, 
            rank: true,
            health: true,
            currentCountry: true,
            avatar: true,
          } 
        },
        addressee: { 
          select: { 
            id: true, 
            username: true, 
            rank: true,
            health: true,
            currentCountry: true,
            avatar: true,
          } 
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    // Map to return the friend info (the other player)
    return friendships.map(f => ({
      friendshipId: f.id,
      friend: f.requesterId === playerId ? f.addressee : f.requester,
      since: f.createdAt,
    }));
  },

  /**
   * Get pending friend requests (received)
   */
  async getPendingRequests(playerId: number) {
    const requests = await prisma.friendship.findMany({
      where: {
        addresseeId: playerId,
        status: 'pending',
      },
      include: {
        requester: { 
          select: { 
            id: true, 
            username: true, 
            rank: true,
            avatar: true,
          } 
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return requests.map(r => ({
      friendshipId: r.id,
      requester: r.requester,
      createdAt: r.createdAt,
    }));
  },

  /**
   * Get sent friend requests (still pending)
   */
  async getSentRequests(playerId: number) {
    const requests = await prisma.friendship.findMany({
      where: {
        requesterId: playerId,
        status: 'pending',
      },
      include: {
        addressee: { 
          select: { 
            id: true, 
            username: true, 
            rank: true,
            avatar: true,
          } 
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return requests.map(r => ({
      friendshipId: r.id,
      addressee: r.addressee,
      createdAt: r.createdAt,
    }));
  },

  /**
   * Search players by username
   */
  async searchPlayers(query: string, requesterId: number, limit = 20) {
    console.log(`🔍 [friendService] searchPlayers called - query: "${query}", requesterId: ${requesterId}`);
    
    if (!query || query.length < 2) {
      throw new Error('Search query must be at least 2 characters');
    }

    // Use raw SQL for case-insensitive LIKE with MariaDB
    const searchPattern = `%${query.toLowerCase()}%`;
    console.log(`🔍 [friendService] Search pattern: "${searchPattern}"`);
    
    const players = await prisma.$queryRaw<Array<{
      id: number;
      username: string;
      rank: number;
      currentCountry: string;
      avatar: string | null;
      crewId: number | null;
      crewName: string | null;
    }>>`
      SELECT 
        p.id, 
        p.username, 
        p.rank, 
        p.currentCountry,
        p.avatar,
        cm.crewId,
        c.name as crewName
      FROM players p
      LEFT JOIN crew_members cm ON p.id = cm.playerId
      LEFT JOIN crews c ON cm.crewId = c.id
      WHERE LOWER(p.username) LIKE ${searchPattern}
        AND p.id != ${requesterId}
      ORDER BY p.username ASC
      LIMIT ${limit}
    `;
    
    console.log(`🔍 [friendService] Found ${players.length} players:`, players);

    // Get friendship status for each player
    const playersWithFriendStatus = await Promise.all(
      players.map(async (player) => {
        const friendship = await prisma.friendship.findFirst({
          where: {
            OR: [
              { requesterId, addresseeId: player.id },
              { requesterId: player.id, addresseeId: requesterId },
            ],
          },
        });

        let friendStatus: 'none' | 'pending_sent' | 'pending_received' | 'friends' = 'none';
        let friendshipId: number | null = null;

        if (friendship) {
          friendshipId = friendship.id;
          if (friendship.status === 'accepted') {
            friendStatus = 'friends';
          } else if (friendship.status === 'pending') {
            friendStatus = friendship.requesterId === requesterId ? 'pending_sent' : 'pending_received';
          }
        }

        return {
          id: player.id,
          username: player.username,
          rank: player.rank,
          currentCountry: player.currentCountry,
          avatar: player.avatar,
          crewName: player.crewName,
          friendStatus,
          friendshipId,
        };
      })
    );

    return playersWithFriendStatus;
  },

  /**
   * Block a player
   */
  async blockPlayer(requesterId: number, addresseeId: number) {
    // Check if trying to block yourself
    if (requesterId === addresseeId) {
      throw new Error('Cannot block yourself');
    }

    // Check if addressee exists
    const addressee = await prisma.player.findUnique({
      where: { id: addresseeId },
      select: { id: true },
    });

    if (!addressee) {
      throw new Error('Player not found');
    }

    // Check if friendship exists
    const existingFriendship = await prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId, addresseeId },
          { requesterId: addresseeId, addresseeId: requesterId },
        ],
      },
    });

    if (existingFriendship) {
      // Update existing friendship to blocked
      const friendship = await prisma.friendship.update({
        where: { id: existingFriendship.id },
        data: {
          status: 'blocked',
          requesterId, // Make sure blocker is always requester
          addresseeId,
        },
      });
      return friendship;
    } else {
      // Create new blocked entry
      const friendship = await prisma.friendship.create({
        data: {
          requesterId,
          addresseeId,
          status: 'blocked',
        },
      });
      return friendship;
    }
  },

  /**
   * Unblock a player
   */
  async unblockPlayer(requesterId: number, addresseeId: number) {
    const friendship = await prisma.friendship.findFirst({
      where: {
        requesterId,
        addresseeId,
        status: 'blocked',
      },
    });

    if (!friendship) {
      throw new Error('Player is not blocked');
    }

    // Delete the blocked relationship
    await prisma.friendship.delete({
      where: { id: friendship.id },
    });

    return true;
  },

  /**
   * Get list of blocked players
   */
  async getBlockedPlayers(playerId: number) {
    const blocked = await prisma.friendship.findMany({
      where: {
        requesterId: playerId,
        status: 'blocked',
      },
      include: {
        addressee: {
          select: {
            id: true,
            username: true,
            rank: true,
            avatar: true,
          },
        },
      },
    });

    return blocked.map((b) => ({
      id: b.id,
      player: b.addressee,
      blockedAt: b.createdAt,
    }));
  },
};
