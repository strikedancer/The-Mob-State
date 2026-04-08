import { Router, Response, NextFunction } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { directMessageService } from '../services/directMessageService';
import { z } from 'zod';

const router = Router();

// Validation schemas
const sendMessageSchema = z.object({
  message: z.string().min(1).max(1000),
});

/**
 * POST /messages/:receiverId
 * Send a direct message to a friend
 */
router.post(
  '/:receiverId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const senderId = req.player!.id;
      const receiverId = parseInt(req.params.receiverId);
      const { message } = sendMessageSchema.parse(req.body);

      if (isNaN(receiverId)) {
        return res.status(400).json({
          event: 'error.invalid_receiver_id',
          params: {},
        });
      }

      if (receiverId === 0) {
        return res.status(403).json({
          event: 'error.system_thread_read_only',
          params: {},
        });
      }

      if (senderId === receiverId) {
        return res.status(400).json({
          event: 'error.cannot_message_yourself',
          params: {},
        });
      }

      const directMessage = await directMessageService.sendMessage(
        senderId,
        receiverId,
        message
      );

      return res.status(201).json({
        event: 'message.sent',
        params: { message: directMessage },
      });
    } catch (error: any) {
      if (error.message === 'Message cannot be empty') {
        return res.status(400).json({
          event: 'error.empty_message',
          params: {},
        });
      }
      if (error.message === 'Message too long (max 1000 characters)') {
        return res.status(400).json({
          event: 'error.message_too_long',
          params: {},
        });
      }
      if (error.message === 'You can only message friends') {
        return res.status(403).json({
          event: 'error.not_friends',
          params: {},
        });
      }
      if (error.message === 'Receiver not found') {
        return res.status(404).json({
          event: 'error.receiver_not_found',
          params: {},
        });
      }
      if (error.message === 'This player has disabled direct messages') {
        return res.status(403).json({
          event: 'error.messages_disabled',
          params: {},
        });
      }
      return next(error);
    }
  }
);

/**
 * GET /messages/conversation/:otherPlayerId
 * Get conversation with a specific friend
 */
router.get(
  '/conversation/:otherPlayerId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;
      const otherPlayerId = parseInt(req.params.otherPlayerId);
      const limit = req.query.limit
        ? parseInt(req.query.limit as string)
        : 50;

      if (isNaN(otherPlayerId)) {
        return res.status(400).json({
          event: 'error.invalid_player_id',
          params: {},
        });
      }

      const messages = await directMessageService.getConversation(
        playerId,
        otherPlayerId,
        limit
      );

      return res.json({
        event: 'conversation.loaded',
        params: { messages },
      });
    } catch (error: any) {
      if (error.message === 'You can only view conversations with friends') {
        return res.status(403).json({
          event: 'error.not_friends',
          params: {},
        });
      }
      return next(error);
    }
  }
);

/**
 * GET /messages/conversations
 * Get all conversations for the authenticated player
 */
router.get(
  '/conversations',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;

      const conversations = await directMessageService.getConversations(
        playerId
      );

      // Transform to match Flutter Conversation model
      const transformedConversations = conversations.map((conv) => ({
        friendId: conv.friend.id,
        username: conv.friend.username,
        rank: conv.friend.rank,
        avatar: conv.friend.avatar,
        lastMessage: conv.lastMessage?.message || null,
        lastMessageTime: conv.lastMessage?.createdAt.toISOString() || null,
        unreadCount: conv.unreadCount,
      }));

      return res.json({
        event: 'conversations.loaded',
        params: { conversations: transformedConversations },
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * GET /messages/unread
 * Get unread message count
 */
router.get(
  '/unread',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;

      const count = await directMessageService.getUnreadCount(playerId);

      return res.json({
        event: 'unread_count.loaded',
        params: {
          count,
          unreadCount: count,
        },
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * POST /messages/mark-read/:otherPlayerId
 * Mark messages as read
 */
router.post(
  '/mark-read/:otherPlayerId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;
      const otherPlayerId = parseInt(req.params.otherPlayerId);

      if (isNaN(otherPlayerId)) {
        return res.status(400).json({
          event: 'error.invalid_player_id',
          params: {},
        });
      }

      await directMessageService.markAsRead(playerId, otherPlayerId);

      return res.json({
        event: 'messages.marked_read',
        params: {},
      });
    } catch (error) {
      return next(error);
    }
  }
);

/**
 * DELETE /messages/:messageId
 * Delete a message
 */
router.delete(
  '/:messageId',
  authenticate,
  async (req: AuthRequest, res: Response, next: NextFunction) => {
    try {
      const playerId = req.player!.id;
      const messageId = parseInt(req.params.messageId);

      if (isNaN(messageId)) {
        return res.status(400).json({
          event: 'error.invalid_message_id',
          params: {},
        });
      }

      await directMessageService.deleteMessage(messageId, playerId);

      return res.json({
        event: 'message.deleted',
        params: { messageId },
      });
    } catch (error: any) {
      if (error.message === 'Message not found') {
        return res.status(404).json({
          event: 'error.message_not_found',
          params: {},
        });
      }
      if (error.message === 'You can only delete your own messages') {
        return res.status(403).json({
          event: 'error.not_authorized',
          params: {},
        });
      }
      return next(error);
    }
  }
);

export default router;
