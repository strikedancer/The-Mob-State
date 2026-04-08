import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { NotificationService } from './notificationService';
import { translationService } from './translationService';

export const crewChatService = {
  /**
   * Send a message to crew chat
   */
  async sendMessage(crewId: number, playerId: number, message: string) {
    // Validate message
    if (!message || message.trim().length === 0) {
      throw new Error('Message cannot be empty');
    }

    if (message.length > 500) {
      throw new Error('Message too long (max 500 characters)');
    }

    // Check if player is in the crew
    const membership = await prisma.crewMember.findFirst({
      where: {
        crewId,
        playerId,
      },
    });

    if (!membership) {
      throw new Error('You are not a member of this crew');
    }

    // Create the message
    const crewMessage = await prisma.crewMessage.create({
      data: {
        crewId,
        playerId,
        message: message.trim(),
      },
      include: {
        player: {
          select: {
            id: true,
            username: true,
            rank: true,
          },
        },
      },
    });

    // Send SSE event to all crew members
    const crewMembers = await prisma.crewMember.findMany({
      where: { crewId },
      select: { playerId: true },
    });

    // Get crew name for notifications
    const crew = await prisma.crew.findUnique({
      where: { id: crewId },
      select: { name: true },
    });

    const notificationService = NotificationService.getInstance();

    for (const member of crewMembers) {
      // Don't send to the sender
      if (member.playerId !== playerId) {
        // Send SSE event
        await worldEventService.createEvent(
          'crew.message',
          {
            crewId,
            messageId: crewMessage.id,
            sender: crewMessage.player,
            message: crewMessage.message,
            createdAt: crewMessage.createdAt,
          },
          member.playerId
        );

        // Send push notification
        try {
          const memberPlayer = await prisma.player.findUnique({
            where: { id: member.playerId },
            select: { preferredLanguage: true },
          });
          const language = translationService.getPlayerLanguage({ preferredLanguage: memberPlayer?.preferredLanguage });
          await notificationService.sendCrewMessageNotification(
            member.playerId,
            crew?.name || 'Crew',
            crewMessage.player.username,
            crewMessage.message,
            language
          );
        } catch (error) {
          console.error('[CrewChatService] Failed to send push notification:', error);
          // Don't throw - notification failures should not block message sending
        }
      }
    }

    return crewMessage;
  },

  /**
   * Get messages for a crew
   */
  async getMessages(crewId: number, playerId: number, limit = 50) {
    // Check if player is in the crew
    const membership = await prisma.crewMember.findFirst({
      where: {
        crewId,
        playerId,
      },
    });

    if (!membership) {
      throw new Error('You are not a member of this crew');
    }

    const messages = await prisma.crewMessage.findMany({
      where: { crewId },
      include: {
        player: {
          select: {
            id: true,
            username: true,
            rank: true,
          },
        },
      },
      orderBy: { createdAt: 'desc' },
      take: limit,
    });

    // Return in ascending order (oldest first)
    return messages.reverse();
  },

  /**
   * Delete a message (only sender or crew leader can delete)
   */
  async deleteMessage(messageId: number, playerId: number) {
    const message = await prisma.crewMessage.findUnique({
      where: { id: messageId },
      include: {
        crew: {
          include: {
            members: {
              where: { playerId },
            },
          },
        },
      },
    });

    if (!message) {
      throw new Error('Message not found');
    }

    // Check if player is the sender or crew leader
    const membership = message.crew.members[0];
    if (!membership) {
      throw new Error('You are not a member of this crew');
    }

    const isSender = message.playerId === playerId;
    const isLeader = membership.role === 'leader';

    if (!isSender && !isLeader) {
      throw new Error('Only the message sender or crew leader can delete messages');
    }

    await prisma.crewMessage.delete({
      where: { id: messageId },
    });

    // Notify crew members
    const crewMembers = await prisma.crewMember.findMany({
      where: { crewId: message.crewId },
      select: { playerId: true },
    });

    for (const member of crewMembers) {
      await worldEventService.createEvent(
        'crew.message_deleted',
        {
          crewId: message.crewId,
          messageId,
        },
        member.playerId
      );
    }

    return { success: true };
  },

  /**
   * Get unread message count for a crew
   */
  async getUnreadCount(crewId: number, playerId: number, since?: Date) {
    const membership = await prisma.crewMember.findFirst({
      where: {
        crewId,
        playerId,
      },
    });

    if (!membership) {
      return 0;
    }

    const count = await prisma.crewMessage.count({
      where: {
        crewId,
        playerId: { not: playerId }, // Don't count own messages
        createdAt: since ? { gt: since } : undefined,
      },
    });

    return count;
  },
};
