import prisma from '../lib/prisma';
import { worldEventService } from './worldEventService';
import { NotificationService } from './notificationService';
import { translationService } from './translationService';
import { activePortraitPathFromRow } from '../utils/avatarDisplay';

const SYSTEM_THREAD_ID = 0;
const SYSTEM_NOTICE_INBOX_LIMIT = 50;
const SYSTEM_SENDER = {
  id: SYSTEM_THREAD_ID,
  username: 'The Mob State',
  rank: 0,
  avatar: null,
  activePortraitPath: null as string | null,
};

/** One inbox row per system notice. Negative so it never collides with a player id. */
export function systemNoticeThreadId(messageId: number): number {
  return -messageId;
}

export function systemNoticeMessageId(threadId: number): number | null {
  if (threadId >= 0) {
    return null;
  }
  return -threadId;
}

export function systemNoticeLines(body: string): { title: string; preview: string } {
  const cleaned = body.replace(/\[\[[^\]]*\]\]/g, '').trim();
  const lines = cleaned
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0);
  const title = (lines[0] ?? SYSTEM_SENDER.username).slice(0, 80);
  const preview = lines.length > 1 ? lines.slice(1).join(' ') : title;
  return { title, preview };
}

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
    const noticeId = systemNoticeMessageId(otherPlayerId);
    if (noticeId != null) {
      const message = await prisma.directMessage.findFirst({
        where: {
          id: noticeId,
          senderId: playerId,
          receiverId: playerId,
          hiddenForReceiver: false,
        },
      });

      if (!message) {
        return [];
      }

      if (!message.read) {
        await prisma.directMessage.update({
          where: { id: message.id },
          data: { read: true },
        });
      }

      return [this.formatSystemMessage({ ...message, read: true })];
    }

    if (otherPlayerId === SYSTEM_THREAD_ID) {
      const messages = await prisma.directMessage.findMany({
        where: {
          senderId: playerId,
          receiverId: playerId,
          hiddenForReceiver: false,
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
          { senderId: playerId, receiverId: otherPlayerId, hiddenForSender: false },
          { senderId: otherPlayerId, receiverId: playerId, hiddenForReceiver: false },
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
   * Player DMs stay one grouped query. Each system notice is its own inbox row
   * (thread id = -messageId) so badges and payouts do not pile into one chat.
   */
  async getConversations(playerId: number) {
    const threadRows = await prisma.$queryRaw<
      Array<{ threadId: number | bigint; lastId: number | bigint; unreadCount: number | bigint }>
    >`
      SELECT
        CASE
          WHEN senderId = ${playerId} THEN receiverId
          ELSE senderId
        END AS threadId,
        MAX(id) AS lastId,
        SUM(CASE WHEN receiverId = ${playerId} AND \`read\` = 0 THEN 1 ELSE 0 END) AS unreadCount
      FROM direct_messages
      WHERE (senderId = ${playerId} OR receiverId = ${playerId})
        AND senderId <> receiverId
        AND NOT (
          (senderId = ${playerId} AND hiddenForSender = 1)
          OR (receiverId = ${playerId} AND hiddenForReceiver = 1)
        )
      GROUP BY threadId
      ORDER BY MAX(createdAt) DESC
      LIMIT 40
    `;

    const systemMessages = await prisma.directMessage.findMany({
      where: {
        senderId: playerId,
        receiverId: playerId,
        hiddenForReceiver: false,
      },
      orderBy: { createdAt: 'desc' },
      take: SYSTEM_NOTICE_INBOX_LIMIT,
    });

    const lastIds = threadRows.map((row) => Number(row.lastId));
    const lastMessages = lastIds.length
      ? await prisma.directMessage.findMany({
          where: { id: { in: lastIds } },
        })
      : [];
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

    const playerConversations = threadRows
      .map((row) => {
        const threadId = Number(row.threadId);
        const lastMessage = lastById.get(Number(row.lastId)) ?? null;
        const friend = playerById.get(threadId);
        if (!friend || !lastMessage) {
          return null;
        }
        return {
          friend,
          lastMessage,
          unreadCount: Number(row.unreadCount ?? 0),
          lastAt: lastMessage.createdAt,
        };
      })
      .filter((row): row is NonNullable<typeof row> => row != null);

    const systemConversations = systemMessages.map((message) => {
      const { title, preview } = systemNoticeLines(message.message);
      return {
        friend: {
          ...SYSTEM_SENDER,
          id: systemNoticeThreadId(message.id),
          username: title,
        },
        lastMessage: {
          ...message,
          message: preview,
        },
        unreadCount: message.read ? 0 : 1,
        lastAt: message.createdAt,
      };
    });

    return [...playerConversations, ...systemConversations]
      .sort((a, b) => b.lastAt.getTime() - a.lastAt.getTime())
      .map(({ lastAt: _lastAt, ...conversation }) => conversation);
  },

  /**
   * Get unread message count for a player
   */
  async getUnreadCount(playerId: number) {
    const count = await prisma.directMessage.count({
      where: {
        receiverId: playerId,
        read: false,
        hiddenForReceiver: false,
      },
    });

    return count;
  },

  /**
   * Mark messages as read
   */
  async markAsRead(playerId: number, otherPlayerId: number) {
    const noticeId = systemNoticeMessageId(otherPlayerId);
    if (noticeId != null) {
      const updatedMessages = await prisma.directMessage.updateMany({
        where: {
          id: noticeId,
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
   * Mark every visible unread inbox message as read for this player.
   */
  async markAllAsRead(playerId: number) {
    const unreadSenders = await prisma.directMessage.findMany({
      where: {
        receiverId: playerId,
        read: false,
        hiddenForReceiver: false,
      },
      distinct: ['senderId'],
      select: { senderId: true },
    });

    const updated = await prisma.directMessage.updateMany({
      where: {
        receiverId: playerId,
        read: false,
        hiddenForReceiver: false,
      },
      data: { read: true },
    });

    if (updated.count > 0) {
      await worldEventService.createEvent(
        'direct_message.read',
        {
          receiverId: playerId,
          count: updated.count,
        },
        playerId,
      );

      for (const row of unreadSenders) {
        if (row.senderId === playerId) continue;
        await worldEventService.createEvent(
          'direct_message.read',
          {
            senderId: row.senderId,
            receiverId: playerId,
            count: updated.count,
          },
          row.senderId,
        );
      }
    }

    return { marked: updated.count };
  },

  /**
   * Hide an inbox thread for this player only.
   * Unread threads are marked read first. New messages after this are not hidden.
   */
  async hideReadConversation(playerId: number, otherPlayerId: number) {
    const noticeId = systemNoticeMessageId(otherPlayerId);
    if (noticeId != null) {
      const message = await prisma.directMessage.findFirst({
        where: {
          id: noticeId,
          senderId: playerId,
          receiverId: playerId,
        },
      });
      if (!message) {
        throw new Error('MESSAGE_NOT_FOUND');
      }
      if (message.hiddenForReceiver) {
        return { hidden: 0 };
      }
      await prisma.directMessage.update({
        where: { id: noticeId },
        data: { read: true, hiddenForReceiver: true },
      });
      if (!message.read) {
        await worldEventService.createEvent(
          'direct_message.read',
          { receiverId: playerId, count: 1 },
          playerId,
        );
      }
      return { hidden: 1 };
    }

    if (otherPlayerId === SYSTEM_THREAD_ID) {
      const updated = await prisma.directMessage.updateMany({
        where: {
          senderId: playerId,
          receiverId: playerId,
          hiddenForReceiver: false,
        },
        data: { read: true, hiddenForReceiver: true },
      });
      if (updated.count > 0) {
        await worldEventService.createEvent(
          'direct_message.read',
          { receiverId: playerId, count: updated.count },
          playerId,
        );
      }
      return { hidden: updated.count };
    }

    if (otherPlayerId <= 0) {
      throw new Error('INVALID_THREAD');
    }

    await this.markAsRead(playerId, otherPlayerId);

    const [received, sent] = await prisma.$transaction([
      prisma.directMessage.updateMany({
        where: {
          senderId: otherPlayerId,
          receiverId: playerId,
          hiddenForReceiver: false,
        },
        data: { hiddenForReceiver: true },
      }),
      prisma.directMessage.updateMany({
        where: {
          senderId: playerId,
          receiverId: otherPlayerId,
          hiddenForSender: false,
        },
        data: { hiddenForSender: true },
      }),
    ]);

    return { hidden: received.count + sent.count };
  },

  /** Hide every fully-read inbox thread (system notices + player chats). */
  async hideAllReadConversations(playerId: number) {
    const conversations = await this.getConversations(playerId);
    let hidden = 0;
    for (const conversation of conversations) {
      if (conversation.unreadCount > 0) {
        continue;
      }
      const result = await this.hideReadConversation(playerId, conversation.friend.id);
      hidden += result.hidden;
    }
    return { hidden };
  },

  /** Hide selected inbox threads, or every visible thread when `all` is set. */
  async hideConversations(
    playerId: number,
    options: { all?: boolean; friendIds?: number[] },
  ) {
    const ids = options.all
      ? (await this.getConversations(playerId)).map((conversation) => conversation.friend.id)
      : [...new Set((options.friendIds ?? []).filter((id) => Number.isFinite(id)))].slice(0, 200);

    let hidden = 0;
    for (const friendId of ids) {
      try {
        const result = await this.hideReadConversation(playerId, friendId);
        hidden += result.hidden;
      } catch (error) {
        if (error instanceof Error && error.message === 'MESSAGE_NOT_FOUND') {
          continue;
        }
        throw error;
      }
    }
    return { hidden };
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
