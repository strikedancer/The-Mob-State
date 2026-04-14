import prisma from '../lib/prisma';
import { directMessageService } from './directMessageService';

type TicketStatus = 'open' | 'in_progress' | 'waiting_player' | 'resolved' | 'closed';

interface TicketRow {
  id: number;
  playerId: number;
  category: string;
  subject: string;
  status: TicketStatus;
  priority: string;
  createdAt: Date;
  updatedAt: Date;
  closedAt: Date | null;
  closedByAdminId: number | null;
  lastPlayerMessageAt: Date | null;
  lastAdminMessageAt: Date | null;
}

interface TicketMessageRow {
  id: number;
  ticketId: number;
  senderType: 'player' | 'admin' | 'system';
  playerId: number | null;
  adminId: number | null;
  message: string;
  isInternal: number;
  createdAt: Date;
}

interface TicketTodoRow {
  id: number;
  ticketId: number;
  title: string;
  description: string | null;
  status: 'open' | 'done';
  createdByAdminId: number;
  assignedAdminId: number | null;
  resolvedByAdminId: number | null;
  createdAt: Date;
  updatedAt: Date;
  resolvedAt: Date | null;
}

async function getPlayerLanguage(playerId: number): Promise<'nl' | 'en'> {
  const row = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  return row?.preferredLanguage === 'en' ? 'en' : 'nl';
}

function normalizeTicketStatus(status: string): TicketStatus {
  if (status === 'in_progress' || status === 'waiting_player' || status === 'resolved' || status === 'closed') {
    return status;
  }
  return 'open';
}

export const supportTicketService = {
  async createTicket(playerId: number, category: string, subject: string, message: string) {
    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_tickets (playerId, category, subject, status, priority, lastPlayerMessageAt)
      VALUES (?, ?, ?, 'open', 'normal', NOW())
      `,
      playerId,
      category,
      subject
    );

    const idRows = await prisma.$queryRawUnsafe<Array<{ id: number }>>('SELECT LAST_INSERT_ID() AS id');
    const ticketId = Number(idRows?.[0]?.id || 0);

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_messages (ticketId, senderType, playerId, message, isInternal)
      VALUES (?, 'player', ?, ?, 0)
      `,
      ticketId,
      playerId,
      message
    );

    return ticketId;
  },

  async listPlayerTickets(playerId: number) {
    const tickets = await prisma.$queryRawUnsafe<Array<TicketRow>>(
      `
      SELECT id, playerId, category, subject, status, priority, createdAt, updatedAt,
             closedAt, closedByAdminId, lastPlayerMessageAt, lastAdminMessageAt
      FROM support_tickets
      WHERE playerId = ?
      ORDER BY updatedAt DESC
      `,
      playerId
    );

    return tickets.map((ticket) => ({
      ...ticket,
      status: normalizeTicketStatus(ticket.status),
    }));
  },

  async getTicketWithMessagesForPlayer(playerId: number, ticketId: number) {
    const tickets = await prisma.$queryRawUnsafe<Array<TicketRow>>(
      `
      SELECT id, playerId, category, subject, status, priority, createdAt, updatedAt,
             closedAt, closedByAdminId, lastPlayerMessageAt, lastAdminMessageAt
      FROM support_tickets
      WHERE id = ? AND playerId = ?
      LIMIT 1
      `,
      ticketId,
      playerId
    );

    if (!tickets.length) {
      return null;
    }

    const messages = await prisma.$queryRawUnsafe<Array<TicketMessageRow>>(
      `
      SELECT id, ticketId, senderType, playerId, adminId, message, isInternal, createdAt
      FROM support_ticket_messages
      WHERE ticketId = ? AND isInternal = 0
      ORDER BY createdAt ASC
      `,
      ticketId
    );

    const todos = await prisma.$queryRawUnsafe<Array<TicketTodoRow>>(
      `
      SELECT id, ticketId, title, description, status, createdByAdminId, assignedAdminId,
             resolvedByAdminId, createdAt, updatedAt, resolvedAt
      FROM support_ticket_todos
      WHERE ticketId = ?
      ORDER BY createdAt DESC
      `,
      ticketId
    );

    return {
      ticket: {
        ...tickets[0],
        status: normalizeTicketStatus(tickets[0].status),
      },
      messages,
      todos,
    };
  },

  async addPlayerReply(playerId: number, ticketId: number, message: string) {
    const ticket = await this.getTicketWithMessagesForPlayer(playerId, ticketId);
    if (!ticket) {
      throw new Error('TICKET_NOT_FOUND');
    }

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_messages (ticketId, senderType, playerId, message, isInternal)
      VALUES (?, 'player', ?, ?, 0)
      `,
      ticketId,
      playerId,
      message
    );

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_tickets
      SET status = 'open',
          closedAt = NULL,
          closedByAdminId = NULL,
          lastPlayerMessageAt = NOW(),
          updatedAt = NOW()
      WHERE id = ?
      `,
      ticketId
    );
  },

  async listAdminTickets(status?: string) {
    const sql = status && status !== 'all'
      ? `
        SELECT t.id, t.playerId, t.category, t.subject, t.status, t.priority, t.createdAt, t.updatedAt,
               t.closedAt, t.closedByAdminId, t.lastPlayerMessageAt, t.lastAdminMessageAt,
               p.username,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'player') AS playerMessageCount,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'admin') AS adminMessageCount,
               (SELECT COUNT(*) FROM support_ticket_todos td WHERE td.ticketId = t.id AND td.status = 'open') AS openTodoCount
        FROM support_tickets t
        JOIN players p ON p.id = t.playerId
        WHERE t.status = ?
        ORDER BY t.updatedAt DESC
      `
      : `
        SELECT t.id, t.playerId, t.category, t.subject, t.status, t.priority, t.createdAt, t.updatedAt,
               t.closedAt, t.closedByAdminId, t.lastPlayerMessageAt, t.lastAdminMessageAt,
               p.username,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'player') AS playerMessageCount,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'admin') AS adminMessageCount,
               (SELECT COUNT(*) FROM support_ticket_todos td WHERE td.ticketId = t.id AND td.status = 'open') AS openTodoCount
        FROM support_tickets t
        JOIN players p ON p.id = t.playerId
        ORDER BY t.updatedAt DESC
      `;

    const rows = status && status !== 'all'
      ? await prisma.$queryRawUnsafe<Array<any>>(sql, status)
      : await prisma.$queryRawUnsafe<Array<any>>(sql);

    return rows.map((row) => ({ ...row, status: normalizeTicketStatus(row.status) }));
  },

  async getAdminTicketDetail(ticketId: number) {
    const ticketRows = await prisma.$queryRawUnsafe<Array<any>>(
      `
      SELECT t.id, t.playerId, t.category, t.subject, t.status, t.priority, t.createdAt, t.updatedAt,
             t.closedAt, t.closedByAdminId, t.lastPlayerMessageAt, t.lastAdminMessageAt,
             p.username
      FROM support_tickets t
      JOIN players p ON p.id = t.playerId
      WHERE t.id = ?
      LIMIT 1
      `,
      ticketId
    );

    if (!ticketRows.length) {
      return null;
    }

    const messages = await prisma.$queryRawUnsafe<Array<TicketMessageRow>>(
      `
      SELECT id, ticketId, senderType, playerId, adminId, message, isInternal, createdAt
      FROM support_ticket_messages
      WHERE ticketId = ?
      ORDER BY createdAt ASC
      `,
      ticketId
    );

    const todos = await prisma.$queryRawUnsafe<Array<TicketTodoRow>>(
      `
      SELECT id, ticketId, title, description, status, createdByAdminId, assignedAdminId,
             resolvedByAdminId, createdAt, updatedAt, resolvedAt
      FROM support_ticket_todos
      WHERE ticketId = ?
      ORDER BY createdAt DESC
      `,
      ticketId
    );

    return {
      ticket: {
        ...ticketRows[0],
        status: normalizeTicketStatus(ticketRows[0].status),
      },
      messages,
      todos,
    };
  },

  async addAdminReply(adminId: number, ticketId: number, message: string, status?: TicketStatus) {
    const detail = await this.getAdminTicketDetail(ticketId);
    if (!detail) {
      throw new Error('TICKET_NOT_FOUND');
    }

    const nextStatus = status || 'waiting_player';

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_messages (ticketId, senderType, adminId, message, isInternal)
      VALUES (?, 'admin', ?, ?, 0)
      `,
      ticketId,
      adminId,
      message
    );

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_tickets
      SET status = ?,
          closedAt = CASE WHEN ? IN ('resolved', 'closed') THEN NOW() ELSE NULL END,
          closedByAdminId = CASE WHEN ? IN ('resolved', 'closed') THEN ? ELSE NULL END,
          lastAdminMessageAt = NOW(),
          updatedAt = NOW()
      WHERE id = ?
      `,
      nextStatus,
      nextStatus,
      nextStatus,
      adminId,
      ticketId
    );

    const language = await getPlayerLanguage(detail.ticket.playerId);
    const inboxMessage = language === 'nl'
      ? `[Ticket #${ticketId}] Reactie van support: ${message}`
      : `[Ticket #${ticketId}] Support reply: ${message}`;

    await directMessageService.sendSystemMessage(detail.ticket.playerId, inboxMessage, { sendPush: true });
  },

  async addTodo(adminId: number, ticketId: number, title: string, description?: string) {
    const detail = await this.getAdminTicketDetail(ticketId);
    if (!detail) {
      throw new Error('TICKET_NOT_FOUND');
    }

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_todos (ticketId, title, description, status, createdByAdminId)
      VALUES (?, ?, ?, 'open', ?)
      `,
      ticketId,
      title,
      description || null,
      adminId
    );

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_tickets
      SET updatedAt = NOW(),
          status = CASE WHEN status = 'open' THEN 'in_progress' ELSE status END
      WHERE id = ?
      `,
      ticketId
    );
  },

  async updateTodoStatus(adminId: number, todoId: number, status: 'open' | 'done') {
    await prisma.$executeRawUnsafe(
      `
      UPDATE support_ticket_todos
      SET status = ?,
          resolvedByAdminId = CASE WHEN ? = 'done' THEN ? ELSE NULL END,
          resolvedAt = CASE WHEN ? = 'done' THEN NOW() ELSE NULL END,
          updatedAt = NOW()
      WHERE id = ?
      `,
      status,
      status,
      adminId,
      status,
      todoId
    );
  },
};
