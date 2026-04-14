import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/authenticate';
import { z } from 'zod';
import { supportTicketService } from '../services/supportTicketService';

const router = Router();

const createTicketSchema = z.object({
  category: z.enum(['bug', 'question', 'feedback', 'other']),
  subject: z.string().trim().min(3).max(120),
  message: z.string().trim().min(3).max(2000),
});

const replySchema = z.object({
  message: z.string().trim().min(1).max(2000),
});

router.get('/my', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const tickets = await supportTicketService.listPlayerTickets(playerId);
  return res.json({ event: 'tickets.list', params: { tickets } });
});

router.post('/', authenticate, async (req: AuthRequest, res: Response) => {
  const playerId = req.player!.id;
  const parsed = createTicketSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ event: 'tickets.invalid_input', params: { errors: parsed.error.flatten() } });
  }

  const { category, subject, message } = parsed.data;
  const ticketId = await supportTicketService.createTicket(playerId, category, subject, message);
  return res.status(201).json({ event: 'tickets.created', params: { ticketId } });
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

export default router;
