import { Router } from 'express';
import { authenticate, type AuthRequest } from '../middleware/authenticate';
import { globalChatService } from '../services/globalChatService';
import { GLOBAL_CHAT_STICKERS } from '../data/globalChatStickers';

const router = Router();

function errorStatus(code: string | undefined): number {
  switch (code) {
    case 'GLOBAL_CHAT_DISABLED':
      return 503;
    case 'GLOBAL_CHAT_MUTED':
    case 'GLOBAL_CHAT_FORBIDDEN':
      return 403;
    case 'GLOBAL_CHAT_RATE_LIMIT':
      return 429;
    case 'GLOBAL_CHAT_EMPTY':
    case 'GLOBAL_CHAT_TOO_LONG':
    case 'GLOBAL_CHAT_DELETE_EXPIRED':
      return 400;
    case 'GLOBAL_CHAT_NOT_FOUND':
      return 404;
    default:
      return 500;
  }
}

router.get('/stickers', authenticate, (_req, res) => {
  return res.json({
    event: 'global_chat.stickers',
    params: { stickers: GLOBAL_CHAT_STICKERS },
  });
});

router.get('/messages', authenticate, async (req: AuthRequest, res) => {
  try {
    const limit = Number(req.query.limit);
    const messages = await globalChatService.getMessages(limit);
    return res.json({
      event: 'global_chat.messages',
      params: { messages },
    });
  } catch (error) {
    console.error('[global-chat] list failed', error);
    return res.status(500).json({
      event: 'error.global_chat_failed',
      params: { reason: 'GLOBAL_CHAT_FAILED' },
    });
  }
});

router.post('/messages', authenticate, async (req: AuthRequest, res) => {
  try {
    const player = req.player!;
    const message = typeof req.body?.message === 'string' ? req.body.message : '';
    const stickerId = typeof req.body?.stickerId === 'string' ? req.body.stickerId : null;
    const created = await globalChatService.sendFromPlayer(
      player.id,
      player.username,
      message,
      stickerId,
    );
    return res.status(201).json({
      event: 'global_chat.message_sent',
      params: { message: created },
    });
  } catch (error) {
    const code = (error as { code?: string }).code;
    if (code) {
      return res.status(errorStatus(code)).json({
        event: 'error.global_chat_failed',
        params: { reason: code },
      });
    }
    console.error('[global-chat] send failed', error);
    return res.status(500).json({
      event: 'error.global_chat_failed',
      params: { reason: 'GLOBAL_CHAT_FAILED' },
    });
  }
});

router.delete('/messages/:id', authenticate, async (req: AuthRequest, res) => {
  try {
    const messageId = Number(req.params.id);
    if (!Number.isFinite(messageId) || messageId <= 0) {
      return res.status(400).json({
        event: 'error.global_chat_failed',
        params: { reason: 'GLOBAL_CHAT_NOT_FOUND' },
      });
    }
    await globalChatService.deleteOwn(messageId, req.player!.id);
    return res.json({
      event: 'global_chat.message_deleted',
      params: { messageId },
    });
  } catch (error) {
    const code = (error as { code?: string }).code;
    if (code) {
      return res.status(errorStatus(code)).json({
        event: 'error.global_chat_failed',
        params: { reason: code },
      });
    }
    console.error('[global-chat] delete failed', error);
    return res.status(500).json({
      event: 'error.global_chat_failed',
      params: { reason: 'GLOBAL_CHAT_FAILED' },
    });
  }
});

router.post('/messages/:id/report', authenticate, async (req: AuthRequest, res) => {
  try {
    const messageId = Number(req.params.id);
    if (!Number.isFinite(messageId) || messageId <= 0) {
      return res.status(400).json({
        event: 'error.global_chat_failed',
        params: { reason: 'GLOBAL_CHAT_NOT_FOUND' },
      });
    }
    await globalChatService.report(messageId, req.player!.id);
    return res.json({
      event: 'global_chat.message_reported',
      params: { messageId },
    });
  } catch (error) {
    const code = (error as { code?: string }).code;
    if (code) {
      return res.status(errorStatus(code)).json({
        event: 'error.global_chat_failed',
        params: { reason: code },
      });
    }
    console.error('[global-chat] report failed', error);
    return res.status(500).json({
      event: 'error.global_chat_failed',
      params: { reason: 'GLOBAL_CHAT_FAILED' },
    });
  }
});

export default router;
