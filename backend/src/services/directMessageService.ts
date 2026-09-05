import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { NotificationService } from './notificationService';
import { translationService } from './translationService';
import { activePortraitPathFromRow } from '../utils/avatarDisplay';

const SYSTEM_THREAD_ID = 0;
const SYSTEM_SENDER = {
  id: SYSTEM_THREAD_ID,
  username: 'The Mob State',
  rank: 0,
  avatar: null,
  activePortraitPath: null as string | null,
};

function mapMessageSender(s: {
  id: number;
  username: string;
  rank: number;
  avatar: string | null;
  activePortrait?: { imagePath: string } | null;
}) {
  return {
    id: s.id,
    username: s.username,
    rank: s.rank,
    avatar: s.avatar,
    activePortraitPath: activePortraitPathFromRow(s.activePortrait?.imagePath ?? null),
  };
}

export const directMessageService = {
  formatSystemMessage(directMessage: {
    id: number;
    message: string;
    read: boolean;
    createdAt: Date;
    receiverId: number;
  }, senderName?: string) {
    return {
      id: directMessage.id,
      senderId: SYSTEM_THREAD_ID,
      receiverId: directMessage.receiverId,
      message: directMessage.message,
      read: directMessage.read,
      createdAt: directMessage.createdAt,
      sender: {
        ...SYSTEM_SENDER,
        username: senderName || SYSTEM_SENDER.username,
      },
    };
  },

  async sendSystemMessage(
    receiverId: number,
    message: string,
    options?: {
      sendPush?: boolean;
      senderName?: string;
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

    const senderName = options?.senderName || SYSTEM_SENDER.username;
    const payload = this.formatSystemMessage(directMessage, senderName);

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
          senderName,
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
            activePortrait: { select: { imagePath: true } },
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

    const senderPayload = mapMessageSender(directMessage.sender);

    // Send SSE event to receiver for real-time notification
    await worldEventService.createEvent(
      'direct_message.received',
      {
        messageId: directMessage.id,
        senderId: directMessage.senderId,
        receiverId: directMessage.receiverId,
        sender: senderPayload,
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
        sender: senderPayload,
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

    return {
      ...directMessage,
      sender: senderPayload,
    };
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
            activePortrait: { select: { imagePath: true } },
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
    return messages.reverse().map((m) => ({
      ...m,
      sender: mapMessageSender(m.sender),
    }));
  },

  /**
   * Get all conversations for a player.
   * One grouped query — never N+1 over friends or crime-style per-thread counts.
   * Threads come from actual messages (including the system inbox), not only current friends.
   */
  async getConversations(playerId: number) {
    const threadRows = await prisma.$queryRaw<
      Array<{ threadId: number | bigint; lastId: number | bigint; unreadCount: number | bigint }>
    >`
      SELECT
        CASE
          WHEN senderId = receiverId THEN 0
          WHEN senderId = ${playerId} THEN receiverId
          ELSE senderId
        END AS threadId,
        MAX(id) AS lastId,
        SUM(CASE WHEN receiverId = ${playerId} AND \`read\` = 0 THEN 1 ELSE 0 END) AS unreadCount
      FROM direct_messages
      WHERE senderId = ${playerId} OR receiverId = ${playerId}
      GROUP BY threadId
      ORDER BY MAX(createdAt) DESC
      LIMIT 80
    `;

    if (threadRows.length === 0) {
      return [];
    }

    const lastIds = threadRows.map((row) => Number(row.lastId));
    const lastMessages = await prisma.directMessage.findMany({
      where: { id: { in: lastIds } },
    });
    const lastById = new Map(lastMessages.map((message) => [message.id, message]));

    const otherPlayerIds = threadRows
      .map((row) => Number(row.threadId))
      .filter((id) => id > 0);
    const players = otherPlayerIds.length
      ? await prisma.player.findMany({
          where: { id: { in: otherPlayerIds } },
          select: {
            id: true,
            username: true,
            rank: true,
            avatar: true,
            activePortrait: { select: { imagePath: true } },
          },
        })
      : [];
    const playerById = new Map(players.map((player) => [player.id, player]));

    return threadRows
      .map((row) => {
        const threadId = Number(row.threadId);
        const lastMessage = lastById.get(Number(row.lastId)) ?? null;
        const unreadCount = Number(row.unreadCount ?? 0);
        if (threadId === SYSTEM_THREAD_ID) {
          return {
            friend: SYSTEM_SENDER,
            lastMessage,
            unreadCount,
          };
        }
        const friend = playerById.get(threadId);
        if (!friend) {
          return null;
        }
        return {
          friend,
          lastMessage,
          unreadCount,
        };
      })
      .filter((row): row is NonNullable<typeof row> => row != null);
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
