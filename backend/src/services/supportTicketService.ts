import prisma from '../lib/prisma';
import { createAuditLog } from '../middleware/auditLog';
import { NotificationService } from './notificationService';

type TicketStatus = 'new' | 'open' | 'triage' | 'in_progress' | 'waiting_player' | 'blocked' | 'resolved' | 'closed' | 'archived';
type TicketPriority = 'low' | 'normal' | 'high' | 'urgent';
type TicketMessageType = 'public_reply' | 'internal_note';
type TodoStatus = 'open' | 'in_progress' | 'blocked' | 'done';
type TodoPriority = 'low' | 'normal' | 'high' | 'urgent';

const TERMINAL_TICKET_STATUSES: TicketStatus[] = ['resolved', 'closed', 'archived'];

interface TicketRow {
  id: number;
  playerId: number;
  category: string;
  subject: string;
  status: TicketStatus;
  priority: TicketPriority;
  sourceModule: string | null;
  referenceCode: string | null;
  metadataJson: string | null;
  assignedAdminId: number | null;
  createdAt: Date;
  updatedAt: Date;
  firstResponseAt: Date | null;
  resolvedAt: Date | null;
  archivedAt: Date | null;
  archivedByAdminId: number | null;
  closedAt: Date | null;
  closedByAdminId: number | null;
  lastPlayerMessageAt: Date | null;
  lastAdminMessageAt: Date | null;
}

interface TicketMessageRow {
  id: number;
  ticketId: number;
  senderType: 'player' | 'admin' | 'system';
  messageType: TicketMessageType;
  playerId: number | null;
  adminId: number | null;
  adminUsername?: string | null;
  message: string;
  isInternal: number;
  createdAt: Date;
}

interface TicketTodoRow {
  id: number;
  ticketId: number | null;
  title: string;
  description: string | null;
  status: TodoStatus;
  priority: TodoPriority;
  moduleKey: string | null;
  dueAt: Date | null;
  createdByAdminId: number;
  assignedAdminId: number | null;
  assignedAdminUsername?: string | null;
  resolvedByAdminId: number | null;
  createdAt: Date;
  updatedAt: Date;
  resolvedAt: Date | null;
}

interface TicketTodoCommentRow {
  id: number;
  todoId: number;
  adminId: number;
  adminUsername: string | null;
  comment: string;
  createdAt: Date;
  updatedAt: Date;
}

interface TicketAttachmentRow {
  id: number;
  ticketId: number;
  playerId: number;
  originalName: string;
  mimeType: string;
  fileSize: number;
  createdAt: Date;
  base64Data?: string | null;
}

interface TicketAttachmentInput {
  originalName: string;
  mimeType: string;
  fileSize: number;
  data: Buffer;
}

interface SupportTodoListRow extends TicketTodoRow {
  ticketSubject: string | null;
  ticketStatus: string | null;
  playerUsername: string | null;
}

interface SupportReplyTemplate {
  key: string;
  labelNl: string;
  labelEn: string;
  bodyNl: string;
  bodyEn: string;
  suggestedStatus: TicketStatus;
}

const SUPPORT_REPLY_TEMPLATES: SupportReplyTemplate[] = [
  {
    key: 'need_more_info',
    labelNl: 'Vraag extra informatie',
    labelEn: 'Request more information',
    bodyNl: 'Bedankt voor je melding. Kun je extra informatie, stappen of een screenshot delen zodat we dit sneller kunnen onderzoeken?',
    bodyEn: 'Thanks for your report. Could you share additional details, steps or a screenshot so we can investigate this faster?',
    suggestedStatus: 'waiting_player',
  },
  {
    key: 'investigating',
    labelNl: 'In onderzoek',
    labelEn: 'Under investigation',
    bodyNl: 'We hebben je melding in behandeling genomen en onderzoeken dit momenteel. Zodra er een update is, krijg je bericht via je inbox.',
    bodyEn: 'We have picked up your report and are currently investigating it. As soon as there is an update, you will receive a message in your inbox.',
    suggestedStatus: 'in_progress',
  },
  {
    key: 'resolved',
    labelNl: 'Opgelost',
    labelEn: 'Resolved',
    bodyNl: 'We hebben deze melding afgehandeld. Als het probleem toch nog terugkomt, stuur dan gerust een nieuwe update of screenshot mee.',
    bodyEn: 'We have handled this report. If the problem returns, feel free to send a new update or include a screenshot.',
    suggestedStatus: 'resolved',
  },
];

async function getPlayerLanguage(playerId: number): Promise<'nl' | 'en'> {
  const row = await prisma.player.findUnique({
    where: { id: playerId },
    select: { preferredLanguage: true },
  });
  const lang = row?.preferredLanguage?.toLowerCase() ?? '';
  return lang.startsWith('nl') ? 'nl' : 'en';
}

function normalizeTicketStatus(status: string): TicketStatus {
  if (status === 'new' || status === 'triage' || status === 'in_progress' || status === 'waiting_player' || status === 'blocked' || status === 'resolved' || status === 'closed' || status === 'archived') {
    return status;
  }
  return 'open';
}

function normalizeTicketPriority(priority: string): TicketPriority {
  if (priority === 'low' || priority === 'high' || priority === 'urgent') {
    return priority;
  }
  return 'normal';
}

function normalizeTodoStatus(status: string): TodoStatus {
  if (status === 'in_progress' || status === 'blocked' || status === 'done') {
    return status;
  }
  return 'open';
}

function normalizeTodoPriority(priority: string): TodoPriority {
  if (priority === 'low' || priority === 'high' || priority === 'urgent') {
    return priority;
  }
  return 'normal';
}

function toSafeNumber(value: unknown): number {
  if (typeof value === 'bigint') {
    return Number(value);
  }
  if (typeof value === 'number') {
    return value;
  }
  if (typeof value === 'string') {
    const parsed = Number.parseFloat(value);
    return Number.isFinite(parsed) ? parsed : 0;
  }
  if (value && typeof value === 'object') {
    const maybeNumber = value as { toNumber?: () => number; toString(): string };
    if (typeof maybeNumber.toNumber === 'function') {
      const parsed = maybeNumber.toNumber();
      return Number.isFinite(parsed) ? parsed : 0;
    }

    const parsed = Number.parseFloat(maybeNumber.toString());
    return Number.isFinite(parsed) ? parsed : 0;
  }
  return 0;
}

function mapAttachmentRow(row: TicketAttachmentRow, urlPrefix: string) {
  return {
    id: row.id,
    ticketId: row.ticketId,
    playerId: row.playerId,
    originalName: row.originalName,
    mimeType: row.mimeType,
    fileSize: row.fileSize,
    createdAt: row.createdAt,
    url: `${urlPrefix}/${row.id}`,
    previewDataUrl: row.base64Data ? `data:${row.mimeType};base64,${row.base64Data}` : null,
  };
}

function mapTodoRow<T extends TicketTodoRow>(row: T): T {
  return {
    ...row,
    status: normalizeTodoStatus(row.status),
    priority: normalizeTodoPriority(row.priority),
  };
}

function getLastMessageBy(row: TicketRow): 'player' | 'admin' | 'none' {
  if (!row.lastAdminMessageAt && !row.lastPlayerMessageAt) return 'none';
  if (row.lastAdminMessageAt && (!row.lastPlayerMessageAt || row.lastAdminMessageAt >= row.lastPlayerMessageAt)) {
    return 'admin';
  }
  return 'player';
}

async function resolveReplyBody(playerId: number, message?: string, templateKey?: string): Promise<{ message: string; suggestedStatus?: TicketStatus }> {
  if (message?.trim()) {
    return { message: message.trim() };
  }

  const template = SUPPORT_REPLY_TEMPLATES.find((item) => item.key === templateKey);
  if (!template) {
    throw new Error('REPLY_TEMPLATE_NOT_FOUND');
  }

  const language = await getPlayerLanguage(playerId);
  return {
    message: language === 'nl' ? template.bodyNl : template.bodyEn,
    suggestedStatus: template.suggestedStatus,
  };
}

async function autoArchiveExpiredClosedTickets() {
  await prisma.$executeRawUnsafe(
    `
    UPDATE support_tickets
    SET status = 'archived',
        archivedAt = COALESCE(archivedAt, NOW()),
        archivedByAdminId = NULL,
        updatedAt = NOW()
    WHERE status = 'closed'
      AND archivedAt IS NULL
      AND closedAt IS NOT NULL
      AND NOT EXISTS (
        SELECT 1
        FROM support_ticket_todos td
        WHERE td.ticketId = support_tickets.id
          AND td.status IN ('open', 'in_progress', 'blocked')
      )
      AND closedAt <= DATE_SUB(NOW(), INTERVAL 3 DAY)
    `,
  );
}

async function ensureTicketCanEnterTerminalStatus(ticketId: number, nextStatus: TicketStatus | null) {
  if (!nextStatus || !TERMINAL_TICKET_STATUSES.includes(nextStatus)) {
    return;
  }

  const rows = await prisma.$queryRawUnsafe<Array<{ total: bigint | number | string }>>(
    `
    SELECT COUNT(*) AS total
    FROM support_ticket_todos
    WHERE ticketId = ?
      AND status IN ('open', 'in_progress', 'blocked')
    `,
    ticketId,
  );

  if (toSafeNumber(rows[0]?.total) > 0) {
    throw new Error('TICKET_HAS_OPEN_TODOS');
  }
}

export const supportTicketService = {
  getReplyTemplates() {
    return SUPPORT_REPLY_TEMPLATES;
  },

  async createTicket(
    playerId: number,
    payload: {
      category: string;
      subject: string;
      message: string;
      sourceModule?: string | null;
      referenceCode?: string | null;
      metadataJson?: string | null;
      attachments?: TicketAttachmentInput[];
    }
  ) {
    const attachments = payload.attachments || [];
    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_tickets (playerId, category, subject, status, priority, sourceModule, referenceCode, metadataJson, lastPlayerMessageAt)
      VALUES (?, ?, ?, 'new', 'normal', ?, ?, ?, NOW())
      `,
      playerId,
      payload.category,
      payload.subject,
      payload.sourceModule || null,
      payload.referenceCode || null,
      payload.metadataJson || null,
    );

    const idRows = await prisma.$queryRawUnsafe<Array<{ id: number }>>('SELECT LAST_INSERT_ID() AS id');
    const ticketId = Number(idRows?.[0]?.id || 0);

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_messages (ticketId, senderType, messageType, playerId, message, isInternal)
      VALUES (?, 'player', 'public_reply', ?, ?, 0)
      `,
      ticketId,
      playerId,
      payload.message
    );

    for (const attachment of attachments) {
      await prisma.$executeRawUnsafe(
        `
        INSERT INTO support_ticket_attachments (ticketId, playerId, originalName, mimeType, fileSize, data)
        VALUES (?, ?, ?, ?, ?, ?)
        `,
        ticketId,
        playerId,
        attachment.originalName,
        attachment.mimeType,
        attachment.fileSize,
        attachment.data
      );
    }

    return ticketId;
  },

  async listPlayerTickets(playerId: number) {
    await autoArchiveExpiredClosedTickets();

    const tickets = await prisma.$queryRawUnsafe<Array<TicketRow>>(
      `
        SELECT id, playerId, category, subject, status, priority, sourceModule, referenceCode, metadataJson,
          assignedAdminId, createdAt, updatedAt, firstResponseAt, resolvedAt, archivedAt, archivedByAdminId,
          closedAt, closedByAdminId, lastPlayerMessageAt, lastAdminMessageAt
      FROM support_tickets
      WHERE playerId = ? AND status <> 'archived'
      ORDER BY updatedAt DESC
      `,
      playerId
    );

    return tickets.map((ticket) => ({
      ...ticket,
      status: normalizeTicketStatus(ticket.status),
      priority: normalizeTicketPriority(ticket.priority),
      lastMessageBy: getLastMessageBy(ticket),
    }));
  },

  async getTicketWithMessagesForPlayer(playerId: number, ticketId: number) {
    await autoArchiveExpiredClosedTickets();

    const tickets = await prisma.$queryRawUnsafe<Array<TicketRow>>(
      `
      SELECT id, playerId, category, subject, status, priority, sourceModule, referenceCode, metadataJson,
             assignedAdminId, createdAt, updatedAt, firstResponseAt, resolvedAt, archivedAt, archivedByAdminId,
             closedAt, closedByAdminId, lastPlayerMessageAt, lastAdminMessageAt
      FROM support_tickets
      WHERE id = ? AND playerId = ? AND status <> 'archived'
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
      SELECT id, ticketId, senderType, messageType, playerId, adminId, message, isInternal, createdAt
      FROM support_ticket_messages
      WHERE ticketId = ? AND isInternal = 0
      ORDER BY createdAt ASC
      `,
      ticketId
    );

    const todos = await prisma.$queryRawUnsafe<Array<TicketTodoRow>>(
      `
            SELECT id, ticketId, title, description, status, priority, moduleKey, dueAt, createdByAdminId, assignedAdminId,
              resolvedByAdminId, createdAt, updatedAt, resolvedAt
      FROM support_ticket_todos
      WHERE ticketId = ?
      ORDER BY createdAt DESC
      `,
      ticketId
    );

    const attachments = await prisma.$queryRawUnsafe<Array<TicketAttachmentRow>>(
      `
      SELECT id, ticketId, playerId, originalName, mimeType, fileSize, createdAt,
             TO_BASE64(data) AS base64Data
      FROM support_ticket_attachments
      WHERE ticketId = ?
      ORDER BY createdAt ASC
      `,
      ticketId
    );

    return {
      ticket: {
        ...tickets[0],
        status: normalizeTicketStatus(tickets[0].status),
        priority: normalizeTicketPriority(tickets[0].priority),
        lastMessageBy: getLastMessageBy(tickets[0]),
      },
      messages,
      todos: todos.map((todo) => mapTodoRow(todo)),
      attachments: attachments.map((attachment) => mapAttachmentRow(attachment, '/tickets/attachments')),
    };
  },

  async addPlayerReply(playerId: number, ticketId: number, message: string) {
    const ticket = await this.getTicketWithMessagesForPlayer(playerId, ticketId);
    if (!ticket) {
      throw new Error('TICKET_NOT_FOUND');
    }

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_messages (ticketId, senderType, messageType, playerId, message, isInternal)
      VALUES (?, 'player', 'public_reply', ?, ?, 0)
      `,
      ticketId,
      playerId,
      message
    );

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_tickets
        SET status = CASE WHEN status IN ('waiting_player', 'new', 'open') THEN 'triage' ELSE status END,
          closedAt = NULL,
          resolvedAt = NULL,
          closedByAdminId = NULL,
          lastPlayerMessageAt = NOW(),
          updatedAt = NOW()
      WHERE id = ?
      `,
      ticketId
    );
  },

  async deleteTicketForPlayer(playerId: number, ticketId: number) {
    const ticket = await this.getTicketWithMessagesForPlayer(playerId, ticketId);
    if (!ticket) {
      throw new Error('TICKET_NOT_FOUND');
    }

    await prisma.$transaction([
      prisma.$executeRawUnsafe(
        'DELETE FROM support_ticket_attachments WHERE ticketId = ?',
        ticketId
      ),
      prisma.$executeRawUnsafe(
        'DELETE FROM support_ticket_todos WHERE ticketId = ?',
        ticketId
      ),
      prisma.$executeRawUnsafe(
        'DELETE FROM support_ticket_messages WHERE ticketId = ?',
        ticketId
      ),
      prisma.$executeRawUnsafe(
        'DELETE FROM support_tickets WHERE id = ? AND playerId = ?',
        ticketId,
        playerId
      ),
    ]);
  },

  async listAdminTickets(status?: string) {
    await autoArchiveExpiredClosedTickets();

    const sql = status && status !== 'all'
      ? `
     SELECT t.id, t.playerId, t.category, t.subject, t.status, t.priority, t.sourceModule, t.referenceCode,
       t.metadataJson, t.assignedAdminId, t.createdAt, t.updatedAt, t.firstResponseAt, t.resolvedAt,
       t.archivedAt, t.archivedByAdminId, t.closedAt, t.closedByAdminId, t.lastPlayerMessageAt, t.lastAdminMessageAt,
               p.username,
       a.username AS assignedAdminUsername,
               (SELECT COUNT(*) FROM support_ticket_attachments a WHERE a.ticketId = t.id) AS attachmentCount,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'player') AS playerMessageCount,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'admin') AS adminMessageCount,
       (SELECT COUNT(*) FROM support_ticket_todos td WHERE td.ticketId = t.id AND td.status IN ('open', 'in_progress', 'blocked')) AS openTodoCount,
       TIMESTAMPDIFF(HOUR, t.createdAt, NOW()) AS ageHours
        FROM support_tickets t
        JOIN players p ON p.id = t.playerId
     LEFT JOIN admins a ON a.id = t.assignedAdminId
        WHERE t.status = ?
        ORDER BY t.updatedAt DESC
      `
      : `
     SELECT t.id, t.playerId, t.category, t.subject, t.status, t.priority, t.sourceModule, t.referenceCode,
       t.metadataJson, t.assignedAdminId, t.createdAt, t.updatedAt, t.firstResponseAt, t.resolvedAt,
       t.archivedAt, t.archivedByAdminId, t.closedAt, t.closedByAdminId, t.lastPlayerMessageAt, t.lastAdminMessageAt,
               p.username,
       a.username AS assignedAdminUsername,
               (SELECT COUNT(*) FROM support_ticket_attachments a WHERE a.ticketId = t.id) AS attachmentCount,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'player') AS playerMessageCount,
               (SELECT COUNT(*) FROM support_ticket_messages m WHERE m.ticketId = t.id AND m.senderType = 'admin') AS adminMessageCount,
       (SELECT COUNT(*) FROM support_ticket_todos td WHERE td.ticketId = t.id AND td.status IN ('open', 'in_progress', 'blocked')) AS openTodoCount,
       TIMESTAMPDIFF(HOUR, t.createdAt, NOW()) AS ageHours
        FROM support_tickets t
        JOIN players p ON p.id = t.playerId
     LEFT JOIN admins a ON a.id = t.assignedAdminId
        ORDER BY t.updatedAt DESC
      `;

    const rows = status && status !== 'all'
      ? await prisma.$queryRawUnsafe<Array<any>>(sql, status)
      : await prisma.$queryRawUnsafe<Array<any>>(sql);

    return rows.map((row) => ({
      ...row,
      status: normalizeTicketStatus(row.status),
      priority: normalizeTicketPriority(row.priority),
      attachmentCount: toSafeNumber(row.attachmentCount),
      playerMessageCount: toSafeNumber(row.playerMessageCount),
      adminMessageCount: toSafeNumber(row.adminMessageCount),
      openTodoCount: toSafeNumber(row.openTodoCount),
      ageHours: toSafeNumber(row.ageHours),
      lastMessageBy: getLastMessageBy(row),
    }));
  },

  async getAdminTicketDetail(ticketId: number) {
    await autoArchiveExpiredClosedTickets();

    const ticketRows = await prisma.$queryRawUnsafe<Array<any>>(
      `
      SELECT t.id, t.playerId, t.category, t.subject, t.status, t.priority, t.sourceModule, t.referenceCode,
             t.metadataJson, t.assignedAdminId, t.createdAt, t.updatedAt, t.firstResponseAt, t.resolvedAt,
             t.archivedAt, t.archivedByAdminId, t.closedAt, t.closedByAdminId, t.lastPlayerMessageAt, t.lastAdminMessageAt,
             p.username, a.username AS assignedAdminUsername,
             TIMESTAMPDIFF(HOUR, t.createdAt, NOW()) AS ageHours
      FROM support_tickets t
      JOIN players p ON p.id = t.playerId
      LEFT JOIN admins a ON a.id = t.assignedAdminId
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
          SELECT m.id, m.ticketId, m.senderType, m.messageType, m.playerId, m.adminId, m.message, m.isInternal, m.createdAt,
            a.username AS adminUsername
          FROM support_ticket_messages m
          LEFT JOIN admins a ON a.id = m.adminId
      WHERE ticketId = ?
      ORDER BY createdAt ASC
      `,
      ticketId
    );

    const todos = await prisma.$queryRawUnsafe<Array<TicketTodoRow>>(
      `
          SELECT td.id, td.ticketId, td.title, td.description, td.status, td.priority, td.moduleKey, td.dueAt,
            td.createdByAdminId, td.assignedAdminId, a.username AS assignedAdminUsername,
            td.resolvedByAdminId, td.createdAt, td.updatedAt, td.resolvedAt
          FROM support_ticket_todos td
          LEFT JOIN admins a ON a.id = td.assignedAdminId
      WHERE ticketId = ?
      ORDER BY createdAt DESC
      `,
      ticketId
    );

    const attachments = await prisma.$queryRawUnsafe<Array<TicketAttachmentRow>>(
      `
      SELECT id, ticketId, playerId, originalName, mimeType, fileSize, createdAt,
             TO_BASE64(data) AS base64Data
      FROM support_ticket_attachments
      WHERE ticketId = ?
      ORDER BY createdAt ASC
      `,
      ticketId
    );

    const todoComments = await prisma.$queryRawUnsafe<Array<TicketTodoCommentRow>>(
      `
      SELECT c.id, c.todoId, c.adminId, a.username AS adminUsername, c.comment, c.createdAt, c.updatedAt
      FROM support_ticket_todo_comments c
      LEFT JOIN admins a ON a.id = c.adminId
      WHERE c.todoId IN (SELECT id FROM support_ticket_todos WHERE ticketId = ?)
      ORDER BY c.createdAt ASC
      `,
      ticketId
    );

    return {
      ticket: {
        ...ticketRows[0],
        status: normalizeTicketStatus(ticketRows[0].status),
        priority: normalizeTicketPriority(ticketRows[0].priority),
        attachmentCount: attachments.length,
        ageHours: toSafeNumber(ticketRows[0].ageHours),
        lastMessageBy: getLastMessageBy(ticketRows[0]),
      },
      messages,
      todos: todos.map((todo) => ({
        ...mapTodoRow(todo),
        comments: todoComments.filter((comment) => comment.todoId === todo.id),
      })),
      attachments: attachments.map((attachment) => mapAttachmentRow(attachment, '/admin/tickets/attachments')),
    };
  },

  async deleteTicketAsAdmin(ticketId: number) {
    const detail = await this.getAdminTicketDetail(ticketId);
    if (!detail) {
      throw new Error('TICKET_NOT_FOUND');
    }

    await prisma.$transaction([
      prisma.$executeRawUnsafe(
        'DELETE FROM support_ticket_attachments WHERE ticketId = ?',
        ticketId
      ),
      prisma.$executeRawUnsafe(
        'DELETE FROM support_ticket_todos WHERE ticketId = ?',
        ticketId
      ),
      prisma.$executeRawUnsafe(
        'DELETE FROM support_ticket_messages WHERE ticketId = ?',
        ticketId
      ),
      prisma.$executeRawUnsafe(
        'DELETE FROM support_tickets WHERE id = ?',
        ticketId
      ),
    ]);
  },

  async addAdminReply(
    adminId: number,
    ticketId: number,
    payload: { message?: string; templateKey?: string; status?: TicketStatus; messageType?: TicketMessageType }
  ) {
    const detail = await this.getAdminTicketDetail(ticketId);
    if (!detail) {
      throw new Error('TICKET_NOT_FOUND');
    }

    const messageType = payload.messageType === 'internal_note' ? 'internal_note' : 'public_reply';
    const resolvedReply = await resolveReplyBody(detail.ticket.playerId, payload.message, payload.templateKey);
    const nextStatus = payload.status || resolvedReply.suggestedStatus || (messageType === 'internal_note' ? detail.ticket.status : 'waiting_player');

    await ensureTicketCanEnterTerminalStatus(ticketId, nextStatus);

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_messages (ticketId, senderType, messageType, adminId, message, isInternal)
      VALUES (?, 'admin', ?, ?, ?, ?)
      `,
      ticketId,
      messageType,
      adminId,
      resolvedReply.message,
      messageType === 'internal_note' ? 1 : 0,
    );

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_tickets
      SET status = ?,
          firstResponseAt = CASE WHEN firstResponseAt IS NULL AND ? = 'public_reply' THEN NOW() ELSE firstResponseAt END,
          resolvedAt = CASE WHEN ? = 'resolved' THEN NOW() ELSE resolvedAt END,
          archivedAt = CASE WHEN ? = 'archived' THEN NOW() ELSE archivedAt END,
          archivedByAdminId = CASE WHEN ? = 'archived' THEN ? ELSE archivedByAdminId END,
          closedAt = CASE WHEN ? IN ('resolved', 'closed') THEN NOW() ELSE NULL END,
          closedByAdminId = CASE WHEN ? IN ('resolved', 'closed') THEN ? ELSE NULL END,
          lastAdminMessageAt = CASE WHEN ? = 'public_reply' THEN NOW() ELSE lastAdminMessageAt END,
          assignedAdminId = COALESCE(assignedAdminId, ?),
          updatedAt = NOW()
      WHERE id = ?
      `,
      nextStatus,
      messageType,
      nextStatus,
      nextStatus,
      nextStatus,
      adminId,
      nextStatus,
      nextStatus,
      adminId,
      messageType,
      adminId,
      ticketId,
    );

    await createAuditLog({
      adminId,
      action: messageType === 'internal_note' ? 'SUPPORT_INTERNAL_NOTE' : 'SUPPORT_REPLY',
      targetType: 'SupportTicket',
      targetId: String(ticketId),
      details: { status: nextStatus, templateKey: payload.templateKey || null },
    });

    if (messageType === 'public_reply') {
      const language = await getPlayerLanguage(detail.ticket.playerId);
      const notificationService = NotificationService.getInstance();
      await notificationService.sendSupportTicketUpdateNotification(
        detail.ticket.playerId,
        ticketId,
        detail.ticket.subject,
        language,
      );
    }
  },

  async addTodo(
    adminId: number,
    payload: {
      title: string;
      description?: string;
      ticketId?: number | null;
      assignedAdminId?: number | null;
      priority?: TodoPriority;
      dueAt?: string | null;
      moduleKey?: string | null;
    }
  ) {
    const ticketId = payload.ticketId ?? null;

    if (ticketId) {
      const detail = await this.getAdminTicketDetail(ticketId);
      if (!detail) {
        throw new Error('TICKET_NOT_FOUND');
      }
    }

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_todos (ticketId, title, description, status, priority, moduleKey, dueAt, createdByAdminId, assignedAdminId)
      VALUES (?, ?, ?, 'open', ?, ?, ?, ?, ?)
      `,
      ticketId ?? null,
      payload.title,
      payload.description || null,
      payload.priority || 'normal',
      payload.moduleKey || null,
      payload.dueAt || null,
      adminId,
      payload.assignedAdminId ?? null,
    );

    if (ticketId) {
      await prisma.$executeRawUnsafe(
        `
        UPDATE support_tickets
        SET updatedAt = NOW(),
            assignedAdminId = COALESCE(assignedAdminId, ?),
            status = CASE WHEN status IN ('new', 'open', 'triage') THEN 'in_progress' ELSE status END
        WHERE id = ?
        `,
        payload.assignedAdminId ?? adminId,
        ticketId
      );
    }

    await createAuditLog({
      adminId,
      action: 'SUPPORT_TODO_CREATED',
      targetType: 'SupportTicket',
      targetId: ticketId ? String(ticketId) : undefined,
      details: { ticketId, title: payload.title, assignedAdminId: payload.assignedAdminId ?? null },
    });
  },

  async listTodos(status?: 'all' | TodoStatus) {
    const rows = status && status !== 'all'
      ? await prisma.$queryRawUnsafe<Array<SupportTodoListRow>>(
          `
          SELECT td.id, td.ticketId, td.title, td.description, td.status, td.priority, td.moduleKey, td.dueAt, td.createdByAdminId,
                 td.assignedAdminId, a.username AS assignedAdminUsername, td.resolvedByAdminId, td.createdAt, td.updatedAt, td.resolvedAt,
                 t.subject AS ticketSubject, t.status AS ticketStatus, p.username AS playerUsername
          FROM support_ticket_todos td
          LEFT JOIN support_tickets t ON t.id = td.ticketId
          LEFT JOIN players p ON p.id = t.playerId
          LEFT JOIN admins a ON a.id = td.assignedAdminId
          WHERE td.status = ?
          ORDER BY CASE WHEN td.status = 'open' THEN 0 WHEN td.status = 'in_progress' THEN 1 WHEN td.status = 'blocked' THEN 2 ELSE 3 END, td.updatedAt DESC, td.createdAt DESC
          `,
          status
        )
      : await prisma.$queryRawUnsafe<Array<SupportTodoListRow>>(
          `
          SELECT td.id, td.ticketId, td.title, td.description, td.status, td.priority, td.moduleKey, td.dueAt, td.createdByAdminId,
                 td.assignedAdminId, a.username AS assignedAdminUsername, td.resolvedByAdminId, td.createdAt, td.updatedAt, td.resolvedAt,
                 t.subject AS ticketSubject, t.status AS ticketStatus, p.username AS playerUsername
          FROM support_ticket_todos td
          LEFT JOIN support_tickets t ON t.id = td.ticketId
          LEFT JOIN players p ON p.id = t.playerId
          LEFT JOIN admins a ON a.id = td.assignedAdminId
          ORDER BY CASE WHEN td.status = 'open' THEN 0 WHEN td.status = 'in_progress' THEN 1 WHEN td.status = 'blocked' THEN 2 ELSE 3 END, td.updatedAt DESC, td.createdAt DESC
          `
        );

    return rows.map((row) => ({
      ...mapTodoRow(row),
      ticketStatus: row.ticketStatus ? normalizeTicketStatus(row.ticketStatus) : null,
    }));
  },

  async updateTodo(
    adminId: number,
    todoId: number,
    updates: {
      title?: string;
      description?: string | null;
      status?: TodoStatus;
      assignedAdminId?: number | null;
      priority?: TodoPriority;
      dueAt?: string | null;
      moduleKey?: string | null;
    }
  ) {
    const rows = await prisma.$queryRawUnsafe<Array<{ id: number; ticketId: number | null }>>(
      'SELECT id, ticketId FROM support_ticket_todos WHERE id = ? LIMIT 1',
      todoId
    );

    const existingTodo = rows[0] || null;
    if (!existingTodo) {
      throw new Error('TODO_NOT_FOUND');
    }

    const hasTitleUpdate = typeof updates.title === 'string';
    const hasDescriptionUpdate = Object.prototype.hasOwnProperty.call(updates, 'description');
    const nextStatus = updates.status ?? null;
    const hasAssignedAdminUpdate = Object.prototype.hasOwnProperty.call(updates, 'assignedAdminId');
    const hasPriorityUpdate = Object.prototype.hasOwnProperty.call(updates, 'priority');
    const hasDueAtUpdate = Object.prototype.hasOwnProperty.call(updates, 'dueAt');
    const hasModuleKeyUpdate = Object.prototype.hasOwnProperty.call(updates, 'moduleKey');

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_ticket_todos
      SET title = CASE WHEN ? = 1 THEN ? ELSE title END,
          description = CASE WHEN ? = 1 THEN ? ELSE description END,
          status = COALESCE(?, status),
          assignedAdminId = CASE WHEN ? = 1 THEN ? ELSE assignedAdminId END,
          priority = CASE WHEN ? = 1 THEN ? ELSE priority END,
          dueAt = CASE WHEN ? = 1 THEN ? ELSE dueAt END,
          moduleKey = CASE WHEN ? = 1 THEN ? ELSE moduleKey END,
          resolvedByAdminId = CASE
            WHEN ? = 'done' THEN ?
            WHEN ? IN ('open', 'in_progress', 'blocked') THEN NULL
            ELSE resolvedByAdminId
          END,
          resolvedAt = CASE
            WHEN ? = 'done' THEN COALESCE(resolvedAt, NOW())
            WHEN ? IN ('open', 'in_progress', 'blocked') THEN NULL
            ELSE resolvedAt
          END,
          updatedAt = NOW()
      WHERE id = ?
      `,
      hasTitleUpdate ? 1 : 0,
      updates.title ?? null,
      hasDescriptionUpdate ? 1 : 0,
      hasDescriptionUpdate ? (updates.description ?? null) : null,
      nextStatus,
      hasAssignedAdminUpdate ? 1 : 0,
      hasAssignedAdminUpdate ? (updates.assignedAdminId ?? null) : null,
      hasPriorityUpdate ? 1 : 0,
      hasPriorityUpdate ? (updates.priority ?? null) : null,
      hasDueAtUpdate ? 1 : 0,
      hasDueAtUpdate ? (updates.dueAt ?? null) : null,
      hasModuleKeyUpdate ? 1 : 0,
      hasModuleKeyUpdate ? (updates.moduleKey ?? null) : null,
      nextStatus,
      adminId,
      nextStatus,
      nextStatus,
      nextStatus,
      todoId
    );

    const ticketId = existingTodo.ticketId ?? null;
    if (ticketId) {
      await prisma.$executeRawUnsafe(
        `
        UPDATE support_tickets
        SET updatedAt = NOW(),
            assignedAdminId = CASE WHEN ? IS NOT NULL THEN ? ELSE assignedAdminId END,
            status = CASE WHEN ? = 'done' AND status NOT IN ('resolved', 'archived', 'closed') THEN 'in_progress' ELSE status END
        WHERE id = ?
        `,
        hasAssignedAdminUpdate ? (updates.assignedAdminId ?? null) : null,
        hasAssignedAdminUpdate ? (updates.assignedAdminId ?? null) : null,
        nextStatus,
        ticketId
      );
    }

    await createAuditLog({
      adminId,
      action: 'SUPPORT_TODO_UPDATED',
      targetType: 'SupportTodo',
      targetId: String(todoId),
      details: updates,
    });
  },

  async updateTodoStatus(adminId: number, todoId: number, status: TodoStatus) {
    await this.updateTodo(adminId, todoId, { status });
  },

  async deleteTodo(todoId: number, adminId?: number) {
    const rows = await prisma.$queryRawUnsafe<Array<{ id: number; ticketId: number | null }>>(
      'SELECT id, ticketId FROM support_ticket_todos WHERE id = ? LIMIT 1',
      todoId
    );

    const existingTodo = rows[0] || null;
    if (!existingTodo) {
      throw new Error('TODO_NOT_FOUND');
    }

    await prisma.$executeRawUnsafe('DELETE FROM support_ticket_todo_comments WHERE todoId = ?', todoId);
    await prisma.$executeRawUnsafe('DELETE FROM support_ticket_todos WHERE id = ?', todoId);

    if (existingTodo.ticketId) {
      await prisma.$executeRawUnsafe(
        `
        UPDATE support_tickets
        SET updatedAt = NOW()
        WHERE id = ?
        `,
        existingTodo.ticketId
      );
    }

    if (adminId) {
      await createAuditLog({
        adminId,
        action: 'SUPPORT_TODO_DELETED',
        targetType: 'SupportTodo',
        targetId: String(todoId),
        details: { ticketId: existingTodo.ticketId ?? null },
      });
    }
  },

  async addTodoComment(adminId: number, todoId: number, comment: string) {
    const rows = await prisma.$queryRawUnsafe<Array<{ id: number; ticketId: number | null }>>(
      'SELECT id, ticketId FROM support_ticket_todos WHERE id = ? LIMIT 1',
      todoId
    );

    const existingTodo = rows[0] || null;
    if (!existingTodo) {
      throw new Error('TODO_NOT_FOUND');
    }

    await prisma.$executeRawUnsafe(
      `
      INSERT INTO support_ticket_todo_comments (todoId, adminId, comment)
      VALUES (?, ?, ?)
      `,
      todoId,
      adminId,
      comment,
    );

    await prisma.$executeRawUnsafe('UPDATE support_ticket_todos SET updatedAt = NOW() WHERE id = ?', todoId);

    if (existingTodo.ticketId) {
      await prisma.$executeRawUnsafe('UPDATE support_tickets SET updatedAt = NOW() WHERE id = ?', existingTodo.ticketId);
    }

    await createAuditLog({
      adminId,
      action: 'SUPPORT_TODO_COMMENT_ADDED',
      targetType: 'SupportTodo',
      targetId: String(todoId),
      details: { ticketId: existingTodo.ticketId ?? null },
    });
  },

  async listTodoComments(todoId: number) {
    return prisma.$queryRawUnsafe<Array<TicketTodoCommentRow>>(
      `
      SELECT c.id, c.todoId, c.adminId, a.username AS adminUsername, c.comment, c.createdAt, c.updatedAt
      FROM support_ticket_todo_comments c
      LEFT JOIN admins a ON a.id = c.adminId
      WHERE c.todoId = ?
      ORDER BY c.createdAt ASC
      `,
      todoId,
    );
  },

  async updateTicket(adminId: number, ticketId: number, updates: {
    assignedAdminId?: number | null;
    priority?: TicketPriority;
    status?: TicketStatus;
    archive?: boolean;
  }) {
    const detail = await this.getAdminTicketDetail(ticketId);
    if (!detail) {
      throw new Error('TICKET_NOT_FOUND');
    }

    const hasAssignedAdminUpdate = Object.prototype.hasOwnProperty.call(updates, 'assignedAdminId');
    const hasPriorityUpdate = Object.prototype.hasOwnProperty.call(updates, 'priority');
    const nextStatus = updates.archive ? 'archived' : (updates.status ?? null);

    await ensureTicketCanEnterTerminalStatus(ticketId, nextStatus);

    await prisma.$executeRawUnsafe(
      `
      UPDATE support_tickets
      SET assignedAdminId = CASE WHEN ? = 1 THEN ? ELSE assignedAdminId END,
          priority = CASE WHEN ? = 1 THEN ? ELSE priority END,
          status = COALESCE(?, status),
          resolvedAt = CASE WHEN ? = 'resolved' THEN COALESCE(resolvedAt, NOW()) WHEN ? IS NOT NULL AND ? <> 'resolved' THEN NULL ELSE resolvedAt END,
          archivedAt = CASE WHEN ? = 'archived' THEN NOW() WHEN ? IS NOT NULL AND ? <> 'archived' THEN NULL ELSE archivedAt END,
          archivedByAdminId = CASE WHEN ? = 'archived' THEN ? WHEN ? IS NOT NULL AND ? <> 'archived' THEN NULL ELSE archivedByAdminId END,
          closedAt = CASE WHEN ? IN ('resolved', 'closed') THEN COALESCE(closedAt, NOW()) WHEN ? IS NOT NULL AND ? NOT IN ('resolved', 'closed') THEN NULL ELSE closedAt END,
          closedByAdminId = CASE WHEN ? IN ('resolved', 'closed') THEN ? WHEN ? IS NOT NULL AND ? NOT IN ('resolved', 'closed') THEN NULL ELSE closedByAdminId END,
          updatedAt = NOW()
      WHERE id = ?
      `,
      hasAssignedAdminUpdate ? 1 : 0,
      hasAssignedAdminUpdate ? (updates.assignedAdminId ?? null) : null,
      hasPriorityUpdate ? 1 : 0,
      hasPriorityUpdate ? (updates.priority ?? null) : null,
      nextStatus,
      nextStatus,
        nextStatus,
        nextStatus,
      nextStatus,
      nextStatus,
      nextStatus,
      nextStatus,
      adminId,
      nextStatus,
      nextStatus,
      nextStatus,
        nextStatus,
        nextStatus,
      nextStatus,
      adminId,
        nextStatus,
        nextStatus,
      ticketId,
    );

    await createAuditLog({
      adminId,
      action: 'SUPPORT_TICKET_UPDATED',
      targetType: 'SupportTicket',
      targetId: String(ticketId),
      details: updates,
    });
  },

  async getAnalytics() {
    await autoArchiveExpiredClosedTickets();

    const [summaryRows, categoryRows, assigneeRows] = await Promise.all([
      prisma.$queryRawUnsafe<Array<any>>(
        `
        SELECT
          COUNT(*) AS totalTickets,
          SUM(CASE WHEN status IN ('new', 'triage', 'in_progress', 'waiting_player', 'blocked', 'open') THEN 1 ELSE 0 END) AS activeTickets,
          SUM(CASE WHEN priority = 'urgent' THEN 1 ELSE 0 END) AS urgentTickets,
          ROUND(AVG(CASE WHEN firstResponseAt IS NOT NULL THEN TIMESTAMPDIFF(MINUTE, createdAt, firstResponseAt) END), 1) AS avgFirstResponseMinutes,
          ROUND(AVG(CASE WHEN resolvedAt IS NOT NULL THEN TIMESTAMPDIFF(MINUTE, createdAt, resolvedAt) END), 1) AS avgResolutionMinutes
        FROM support_tickets
        `,
      ),
      prisma.$queryRawUnsafe<Array<any>>(
        `
        SELECT category, COUNT(*) AS total
        FROM support_tickets
        GROUP BY category
        ORDER BY total DESC, category ASC
        `,
      ),
      prisma.$queryRawUnsafe<Array<any>>(
        `
        SELECT COALESCE(a.username, 'Unassigned') AS label,
               COUNT(*) AS total
        FROM support_tickets t
        LEFT JOIN admins a ON a.id = t.assignedAdminId
        WHERE t.status IN ('new', 'triage', 'in_progress', 'waiting_player', 'blocked', 'open')
        GROUP BY COALESCE(a.username, 'Unassigned')
        ORDER BY total DESC, label ASC
        `,
      ),
    ]);

    return {
      totals: {
        totalTickets: toSafeNumber(summaryRows[0]?.totalTickets),
        activeTickets: toSafeNumber(summaryRows[0]?.activeTickets),
        urgentTickets: toSafeNumber(summaryRows[0]?.urgentTickets),
        avgFirstResponseMinutes: toSafeNumber(summaryRows[0]?.avgFirstResponseMinutes),
        avgResolutionMinutes: toSafeNumber(summaryRows[0]?.avgResolutionMinutes),
      },
      byCategory: categoryRows.map((row) => ({ category: row.category, total: toSafeNumber(row.total) })),
      byAssignee: assigneeRows.map((row) => ({ label: row.label, total: toSafeNumber(row.total) })),
    };
  },

  async getAttachmentForPlayer(playerId: number, attachmentId: number) {
    const rows = await prisma.$queryRawUnsafe<Array<any>>(
      `
      SELECT a.id, a.ticketId, a.playerId, a.originalName, a.mimeType, a.fileSize, a.data, a.createdAt
      FROM support_ticket_attachments a
      JOIN support_tickets t ON t.id = a.ticketId
      WHERE a.id = ? AND t.playerId = ?
      LIMIT 1
      `,
      attachmentId,
      playerId
    );

    return rows[0] || null;
  },

  async getAttachmentAsAdmin(attachmentId: number) {
    const rows = await prisma.$queryRawUnsafe<Array<any>>(
      `
      SELECT id, ticketId, playerId, originalName, mimeType, fileSize, data, createdAt
      FROM support_ticket_attachments
      WHERE id = ?
      LIMIT 1
      `,
      attachmentId
    );

    return rows[0] || null;
  },
};
