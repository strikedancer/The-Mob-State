import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { z } from 'zod';
import multer from 'multer';
import { supportTicketService } from '../services/supportTicketService';

const router = Router();
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 5 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    cb(null, file.mimetype.startsWith('image/'));
  },
});

const createTicketSchema = z.object({
  category: z.enum(['bug', 'question', 'feedback', 'other']),
  subject: z.string().trim().min(3).max(120),
  message: z.string().trim().min(3).max(2000),
  sourceModule: z.string().trim().max(80).optional(),
  referenceCode: z.string().trim().max(120).optional(),
  clientPlatform: z.string().trim().max(40).optional(),
  appLocale: z.string().trim().max(10).optional(),
});

const replySchema = z.object({
  message: z.string().trim().min(1).max(2000),
});

router.get('/my', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const tickets = await supportTicketService.listPlayerTickets(playerId);
  return res.json({ event: 'tickets.list', params: { tickets } });
});

router.post('/', authenticate, upload.single('attachment'), async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const parsed = createTicketSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ event: 'tickets.invalid_input', params: { errors: parsed.error.flatten() } });
  }

  const { category, subject, message, sourceModule, referenceCode, clientPlatform, appLocale } = parsed.data;
  const attachment = req.file
    ? [{
        originalName: req.file.originalname,
        mimeType: req.file.mimetype,
        fileSize: req.file.size,
        data: req.file.buffer,
      }]
    : [];

  const ticketId = await supportTicketService.createTicket(playerId, {
    category,
    subject,
    message,
    sourceModule: sourceModule || 'support_screen',
    referenceCode: referenceCode || null,
    metadataJson: JSON.stringify({
      clientPlatform: clientPlatform || req.get('user-agent') || null,
      appLocale: appLocale || null,
      hasAttachment: attachment.length > 0,
    }),
    attachments: attachment,
  });
  return res.status(201).json({ event: 'tickets.created', params: { ticketId } });
});

router.get('/attachments/:attachmentId', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const attachmentId = Number(req.params.attachmentId);
  if (!Number.isFinite(attachmentId) || attachmentId <= 0) {
    return res.status(400).json({ event: 'tickets.invalid_id', params: {} });
  }

  const attachment = await supportTicketService.getAttachmentForPlayer(playerId, attachmentId);
  if (!attachment) {
    return res.status(404).json({ event: 'tickets.not_found', params: {} });
  }

  res.setHeader('Content-Type', attachment.mimeType);
  res.setHeader('Content-Length', String(attachment.fileSize));
  res.setHeader('Content-Disposition', `inline; filename="${attachment.originalName}"`);
  return res.send(attachment.data);
});

router.get('/:ticketId', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const ticketId = Number(req.params.ticketId);
  if (!Number.isFinite(ticketId) || ticketId <= 0) {
    return res.status(400).json({ event: 'tickets.invalid_id', params: {} });
  }

  const detail = await supportTicketService.getTicketWithMessagesForPlayer(playerId, ticketId);
  if (!detail) {
    return res.status(404).json({ event: 'tickets.not_found', params: {} });
  }

  return res.json({ event: 'tickets.detail', params: detail });
});

router.post('/:ticketId/reply', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const ticketId = Number(req.params.ticketId);
  if (!Number.isFinite(ticketId) || ticketId <= 0) {
    return res.status(400).json({ event: 'tickets.invalid_id', params: {} });
  }

  const parsed = replySchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ event: 'tickets.invalid_input', params: { errors: parsed.error.flatten() } });
  }

  try {
    await supportTicketService.addPlayerReply(playerId, ticketId, parsed.data.message);
    return res.json({ event: 'tickets.reply_sent', params: { ticketId } });
  } catch (error: any) {
    if (error?.message === 'TICKET_NOT_FOUND') {
      return res.status(404).json({ event: 'tickets.not_found', params: {} });
    }
    throw error;
  }
});

router.delete('/:ticketId', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const ticketId = Number(req.params.ticketId);
  if (!Number.isFinite(ticketId) || ticketId <= 0) {
    return res.status(400).json({ event: 'tickets.invalid_id', params: {} });
  }

  try {
    await supportTicketService.deleteTicketForPlayer(playerId, ticketId);
    return res.json({ event: 'tickets.deleted', params: { ticketId } });
  } catch (error: any) {
    if (error?.message === 'TICKET_NOT_FOUND') {
      return res.status(404).json({ event: 'tickets.not_found', params: {} });
    }
    throw error;
  }
});

export default router;
