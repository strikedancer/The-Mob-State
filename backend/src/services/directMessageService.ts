import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { NotificationService } from './notificationService';
import { translationService } from './translationService';
const SYSTEM_THREAD_ID = 0;
const SYSTEM_SENDER = {
  id: SYSTEM_THREAD_ID,
  username: 'The Mob State',
  rank: 0,
  avatar: null,
};

export const directMessageService = {
  formatSystemMessage(directMessage: {
    id: number;
    message: string;
    read: boolean;
    createdAt: Date;
    receiverId: number;
  }) {
    return {
      id: directMessage.id,
      senderId: SYSTEM_THREAD_ID,
      receiverId: directMessage.receiverId,
      message: directMessage.message,
      read: directMessage.read,
      createdAt: directMessage.createdAt,
      sender: SYSTEM_SENDER,
    };
  },

  async sendSystemMessage(
    receiverId: number,
    message: string,
    options?: {
      sendPush?: boolean;
    }
  ) {
    if (!message || message.trim().length === 0) {
      throw new Error('Message cannot be empty');
    }

    if (message.length > 1000) {
      throw new Error('Message too long (max 1000 characters)');
    }

    const directMessage = await prisma.directMessage.create({
      data: {
        senderId: receiverId,
        receiverId,
        message: message.trim(),
      },
    });

    const payload = this.formatSystemMessage(directMessage);

    await worldEventService.createEvent(
      'direct_message.received',
      {
        messageId: payload.id,
        senderId: payload.senderId,
        receiverId: payload.receiverId,
        sender: payload.sender,
        message: payload.message,
        read: payload.read,
        createdAt: payload.createdAt,
      },
      receiverId
    );

    if (options?.sendPush ?? true) {
      try {
        const receiverData = await prisma.player.findUnique({
          where: { id: receiverId },
          select: { preferredLanguage: true },
        });
        const language = translationService.getPlayerLanguage({
          preferredLanguage: receiverData?.preferredLanguage,
        });
        const notificationService = NotificationService.getInstance();
        await notificationService.sendDirectMessageNotification(
          receiverId,
          SYSTEM_SENDER.username,
          directMessage.message,
          language
        );
      } catch (error) {
        console.error('[DirectMessageService] Failed to send system push notification:', error);
      }
    }

    return payload;
  },

  /**
   * Send a direct message to a friend
   */
  async sendMessage(senderId: number, receiverId: number, message: string) {
    // Validate message
    if (!message || message.trim().length === 0) {
      throw new Error('Message cannot be empty');
    }

    if (message.length > 1000) {
      throw new Error('Message too long (max 1000 characters)');
    }

    // Check if sender and receiver are friends
    const friendship = await prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId: senderId, addresseeId: receiverId, status: 'accepted' },
          { requesterId: receiverId, addresseeId: senderId, status: 'accepted' },
        ],
      },
    });

    if (!friendship) {
      throw new Error('You can only message friends');
    }

    // Check if either player has blocked the other
    const blockedRelationship = await prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId: senderId, addresseeId: receiverId, status: 'blocked' },
          { requesterId: receiverId, addresseeId: senderId, status: 'blocked' },
        ],
      },
    });

    if (blockedRelationship) {
      throw new Error('Cannot send message - player is blocked');
    }

    // Check if receiver exists and allows messages
    const receiver = await prisma.player.findUnique({
      where: { id: receiverId },
      select: { id: true, username: true, allowMessages: true },
    });

    if (!receiver) {
      throw new Error('Receiver not found');
    }

    if (!receiver.allowMessages) {
      throw new Error('This player has disabled direct messages');
    }

    // Create the message
    const directMessage = await prisma.directMessage.create({
      data: {
        senderId,
        receiverId,
        message: message.trim(),
      },
      include: {
        sender: {
          select: {
            id: true,
            username: true,
            rank: true,
            avatar: true,
          },
        },
        receiver: {
          select: {
            id: true,
            username: true,
          },
        },
      },
    });

    // Send SSE event to receiver for real-time notification
    await worldEventService.createEvent(
      'direct_message.received',
      {
        messageId: directMessage.id,
        senderId: directMessage.senderId,
        receiverId: directMessage.receiverId,
        sender: directMessage.sender,
        message: directMessage.message,
        read: directMessage.read,
        createdAt: directMessage.createdAt,
      },
      receiverId
    );

    // Also send event to sender so they see their own message
    await worldEventService.createEvent(
      'direct_message.received',
      {
        messageId: directMessage.id,
        senderId: directMessage.senderId,
        receiverId: directMessage.receiverId,
        sender: directMessage.sender,
        message: directMessage.message,
        read: directMessage.read,
        createdAt: directMessage.createdAt,
      },
      senderId
    );

    // Send push notification to receiver
    try {
      const receiverData = await prisma.player.findUnique({
        where: { id: receiverId },
        select: { preferredLanguage: true }
      });
      const language = translationService.getPlayerLanguage({ preferredLanguage: receiverData?.preferredLanguage });
      const notificationService = NotificationService.getInstance();
      await notificationService.sendDirectMessageNotification(
        receiverId,
        directMessage.sender.username,
        directMessage.message,
        language
      );
    } catch (error) {
      console.error('[DirectMessageService] Failed to send push notification:', error);
      // Don't throw - notification failures should not block message sending
    }

    return directMessage;
  },

  /**
   * Get conversation between two players
   */
  async getConversation(playerId: number, otherPlayerId: number, limit = 50) {
    if (otherPlayerId === SYSTEM_THREAD_ID) {
      const messages = await prisma.directMessage.findMany({
        where: {
          senderId: playerId,
          receiverId: playerId,
        },
        orderBy: { createdAt: 'desc' },
        take: limit,
      });

      await prisma.directMessage.updateMany({
        where: {
          senderId: playerId,
          receiverId: playerId,
          read: false,
        },
        data: {
          read: true,
        },
      });

      return messages
        .reverse()
        .map((message) => this.formatSystemMessage(message));
    }

    // Check if they are friends
    const friendship = await prisma.friendship.findFirst({
      where: {
        OR: [
          { requesterId: playerId, addresseeId: otherPlayerId, status: 'accepted' },
          { requesterId: otherPlayerId, addresseeId: playerId, status: 'accepted' },
        ],
      },
    });

    if (!friendship) {
      throw new Error('You can only view conversations with friends');
    }

    const messages = await prisma.directMessage.findMany({
      where: {
        OR: [
          { senderId: playerId, receiverId: otherPlayerId },
          { senderId: otherPlayerId, receiverId: playerId },
        ],
      },
      include: {
        sender: {
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

    // Mark messages as read
    await prisma.directMessage.updateMany({
      where: {
        senderId: otherPlayerId,
        receiverId: playerId,
        read: false,
      },
      data: {
        read: true,
      },
    });

    // Return in ascending order (oldest first)
    return messages.reverse();
  },

  /**
   * Get all conversations for a player
   */
  async getConversations(playerId: number) {
    // Get all friends
    const friendships = await prisma.friendship.findMany({
      where: {
        OR: [
          { requesterId: playerId, status: 'accepted' },
          { addresseeId: playerId, status: 'accepted' },
        ],
      },
      include: {
        requester: {
          select: {
            id: true,
            username: true,
            rank: true,
            avatar: true,
          },
        },
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

    // For each friend, get the last message and unread count
    const conversations = await Promise.all(
      friendships.map(async (friendship) => {
        const friend =
          friendship.requesterId === playerId
            ? friendship.addressee
            : friendship.requester;

        // Get last message
        const lastMessage = await prisma.directMessage.findFirst({
          where: {
            OR: [
              { senderId: playerId, receiverId: friend.id },
              { senderId: friend.id, receiverId: playerId },
            ],
          },
          orderBy: { createdAt: 'desc' },
        });

        // Get unread count
        const unreadCount = await prisma.directMessage.count({
          where: {
            senderId: friend.id,
            receiverId: playerId,
            read: false,
          },
        });

        return {
          friend,
          lastMessage,
          unreadCount,
        };
      })
    );

    const systemLastMessage = await prisma.directMessage.findFirst({
      where: {
        senderId: playerId,
        receiverId: playerId,
      },
      orderBy: { createdAt: 'desc' },
    });

    if (systemLastMessage) {
      const systemUnreadCount = await prisma.directMessage.count({
        where: {
          senderId: playerId,
          receiverId: playerId,
          read: false,
        },
      });

      conversations.push({
        friend: SYSTEM_SENDER,
        lastMessage: systemLastMessage,
        unreadCount: systemUnreadCount,
      });
    }

    // Sort by last message timestamp (most recent first)
    return conversations.sort((a, b) => {
      if (!a.lastMessage) return 1;
      if (!b.lastMessage) return -1;
      return b.lastMessage.createdAt.getTime() - a.lastMessage.createdAt.getTime();
    });
  },

  /**
   * Get unread message count for a player
   */
  async getUnreadCount(playerId: number) {
    const count = await prisma.directMessage.count({
      where: {
        receiverId: playerId,
        read: false,
      },
    });

    return count;
  },

  /**
   * Mark messages as read
   */
  async markAsRead(playerId: number, otherPlayerId: number) {
    if (otherPlayerId === SYSTEM_THREAD_ID) {
      const updatedMessages = await prisma.directMessage.updateMany({
        where: {
          senderId: playerId,
          receiverId: playerId,
          read: false,
        },
        data: {
          read: true,
        },
      });

      if (updatedMessages.count > 0) {
        await worldEventService.createEvent(
          'direct_message.read',
          {
            senderId: playerId,
            receiverId: playerId,
            count: updatedMessages.count,
          },
          playerId
        );
      }

      return { success: true };
    }

    const updatedMessages = await prisma.directMessage.updateMany({
      where: {
        senderId: otherPlayerId,
        receiverId: playerId,
        read: false,
      },
      data: {
        read: true,
      },
    });

    // Notify sender that their messages have been read (blue checkmarks)
    if (updatedMessages.count > 0) {
      await worldEventService.createEvent(
        'direct_message.read',
        {
          senderId: otherPlayerId, // Who sent the messages (will see blue checkmarks)
          receiverId: playerId,    // Who read the messages
          count: updatedMessages.count,
        },
        otherPlayerId
      );

      await worldEventService.createEvent(
        'direct_message.read',
        {
          senderId: otherPlayerId,
          receiverId: playerId,
          count: updatedMessages.count,
        },
        playerId
      );
    }

    return { success: true };
  },

  /**
   * Delete a message (only sender can delete)
   */
  async deleteMessage(messageId: number, playerId: number) {
    const message = await prisma.directMessage.findUnique({
      where: { id: messageId },
    });

    if (!message) {
      throw new Error('Message not found');
    }

    // Only sender can delete
    if (message.senderId !== playerId) {
      throw new Error('You can only delete your own messages');
    }

    await prisma.directMessage.delete({
      where: { id: messageId },
    });

    // Notify receiver
    await worldEventService.createEvent(
      'direct_message.deleted',
      {
        messageId,
      },
      message.receiverId
    );

    return { success: true };
  },
};
