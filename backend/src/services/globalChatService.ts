import prisma from '../lib/prisma';
import { eventBroadcaster } from './eventBroadcaster';
import { filterProfanity, parseExtraBlocklist } from '../utils/profanityFilter';
import { getGlobalChatSticker, isGlobalChatStickerId } from '../data/globalChatStickers';
import { globalChatDiscordBridge } from './globalChatDiscordBridge';
import { isPlayerStaff, normalizeStaffRole, asPlayerId, type PlayerStaffRole } from '../utils/staffRole';
import { readPlayerStaffRole } from '../middleware/requirePlayerStaff';

const MAX_BODY = 200;
const HISTORY_LIMIT = 100;
const MIN_INTERVAL_MS = 3000;
const MAX_PER_MINUTE = 10;
const PLAYER_DELETE_WINDOW_MS = 10 * 60 * 1000;

const RATE_KEY_ENABLED = 'GLOBAL_CHAT_ENABLED';
const RATE_KEY_BLOCKLIST = 'GLOBAL_CHAT_EXTRA_BLOCKLIST';

type ChatSource = 'game' | 'discord' | 'system';

export type GlobalChatPublicMessage = {
  id: number;
  playerId: number | null;
  displayName: string;
  source: ChatSource;
  message: string;
  stickerId: string | null;
  stickerEmoji: string | null;
  createdAt: string;
  staffRole: 'MOD' | 'OPS' | null;
};

const sendTimes = new Map<number, number[]>();

function clampLimit(raw: number | undefined): number {
  if (!Number.isFinite(raw)) return HISTORY_LIMIT;
  return Math.min(HISTORY_LIMIT, Math.max(1, Math.trunc(raw as number)));
}

async function readRuntime(key: string): Promise<string> {
  const rows = await prisma.$queryRawUnsafe<Array<{ configValue: string }>>(
    'SELECT configValue FROM runtime_config WHERE configKey = ? LIMIT 1',
    key,
  );
  return rows?.[0]?.configValue ?? '';
}

async function extraWords(): Promise<string[]> {
  return parseExtraBlocklist(await readRuntime(RATE_KEY_BLOCKLIST));
}

export async function isGlobalChatEnabled(): Promise<boolean> {
  const value = (await readRuntime(RATE_KEY_ENABLED)).trim();
  if (!value) return true;
  return value !== '0';
}

function checkRateLimit(playerId: number): boolean {
  const now = Date.now();
  const recent = (sendTimes.get(playerId) ?? []).filter((ts) => now - ts < 60_000);
  if (recent.length >= MAX_PER_MINUTE) return false;
  const last = recent[recent.length - 1];
  if (last != null && now - last < MIN_INTERVAL_MS) return false;
  recent.push(now);
  sendTimes.set(playerId, recent);
  return true;
}

function publicStaffRole(raw: unknown): 'MOD' | 'OPS' | null {
  const role = normalizeStaffRole(raw);
  return isPlayerStaff(role) ? role : null;
}

function staffRoleOf(
  roles: Map<number, PlayerStaffRole>,
  playerId: unknown,
): PlayerStaffRole | undefined {
  const id = asPlayerId(playerId);
  return id == null ? undefined : roles.get(id);
}

function toPublic(
  row: {
    id: number;
    playerId: number | null;
    displayName: string;
    source: string;
    message: string;
    stickerId: string | null;
    createdAt: Date;
  },
  staffRole?: unknown,
): GlobalChatPublicMessage {
  const sticker = getGlobalChatSticker(row.stickerId);
  return {
    id: row.id,
    playerId: row.playerId,
    displayName: row.displayName,
    source: row.source === 'discord' ? 'discord' : row.source === 'system' ? 'system' : 'game',
    message: row.message,
    stickerId: row.stickerId,
    stickerEmoji: sticker?.emoji ?? null,
    createdAt: row.createdAt.toISOString(),
    staffRole: publicStaffRole(staffRole),
  };
}

async function staffRolesByPlayerIds(playerIds: Array<number | null | undefined>): Promise<Map<number, PlayerStaffRole>> {
  const ids = [...new Set(playerIds.map(asPlayerId).filter((id): id is number => id != null))];
  const roles = new Map<number, PlayerStaffRole>();
  if (ids.length === 0) return roles;
  const rows = await prisma.$queryRawUnsafe<Array<{ id: unknown; staffRole: unknown }>>(
    `SELECT id, staffRole FROM players WHERE id IN (${ids.map(() => '?').join(',')})`,
    ...ids,
  );
  for (const row of rows) {
    const id = asPlayerId(row.id);
    if (id == null) continue;
    roles.set(id, normalizeStaffRole(row.staffRole));
  }
  return roles;
}

function broadcastMessage(message: GlobalChatPublicMessage): void {
  eventBroadcaster.broadcast({
    event: 'global_chat.message',
    params: { message },
  });
}

function broadcastDeleted(messageId: number): void {
  eventBroadcaster.broadcast({
    event: 'global_chat.message_deleted',
    params: { messageId },
  });
}

export async function isPlayerMuted(playerId: number): Promise<boolean> {
  const mute = await prisma.globalChatMute.findUnique({ where: { playerId } });
  if (!mute) return false;
  if (mute.mutedUntil && mute.mutedUntil.getTime() <= Date.now()) {
    await prisma.globalChatMute.delete({ where: { playerId } }).catch(() => undefined);
    return false;
  }
  return true;
}

async function persistAndFanout(input: {
  playerId: number | null;
  discordUserId?: string | null;
  discordMessageId?: string | null;
  displayName: string;
  source: ChatSource;
  message: string;
  stickerId: string | null;
  filtered: boolean;
  mirrorToDiscord: boolean;
}): Promise<GlobalChatPublicMessage> {
  const row = await prisma.globalChatMessage.create({
    data: {
      playerId: input.playerId,
      discordUserId: input.discordUserId ?? null,
      discordMessageId: input.discordMessageId ?? null,
      displayName: input.displayName.slice(0, 64),
      source: input.source,
      message: input.message,
      stickerId: input.stickerId,
      filtered: input.filtered,
    },
  });
  const roles = await staffRolesByPlayerIds([input.playerId]);
  const publicMessage = toPublic(row, staffRoleOf(roles, input.playerId));
  broadcastMessage(publicMessage);
  if (input.mirrorToDiscord) {
    void globalChatDiscordBridge.mirrorGameMessage(publicMessage).then((mirroredId) => {
      if (!mirroredId || mirroredId === row.discordMessageId) return;
      return prisma.globalChatMessage
        .update({
          where: { id: row.id },
          data: { discordMessageId: mirroredId },
        })
        .catch(() => undefined);
    });
  }
  return publicMessage;
}

export const globalChatService = {
  async getMessages(limit?: number): Promise<GlobalChatPublicMessage[]> {
    const take = clampLimit(limit);
    const rows = await prisma.globalChatMessage.findMany({
      where: { deletedAt: null },
      orderBy: { createdAt: 'desc' },
      take,
    });
    const roles = await staffRolesByPlayerIds(rows.map((row) => row.playerId));
    return rows.reverse().map((row) => toPublic(row, staffRoleOf(roles, row.playerId)));
  },

  async sendFromPlayer(
    playerId: number,
    username: string,
    rawMessage: string,
    stickerId?: string | null,
  ): Promise<GlobalChatPublicMessage> {
    if (!(await isGlobalChatEnabled())) {
      throw Object.assign(new Error('GLOBAL_CHAT_DISABLED'), { code: 'GLOBAL_CHAT_DISABLED' });
    }

    if (await isPlayerMuted(playerId)) {
      throw Object.assign(new Error('GLOBAL_CHAT_MUTED'), { code: 'GLOBAL_CHAT_MUTED' });
    }

    if (!checkRateLimit(playerId)) {
      throw Object.assign(new Error('GLOBAL_CHAT_RATE_LIMIT'), { code: 'GLOBAL_CHAT_RATE_LIMIT' });
    }

    const sticker = isGlobalChatStickerId(stickerId ?? null) ? (stickerId as string) : null;
    const trimmed = (rawMessage ?? '').trim();
    if (!sticker && !trimmed) {
      throw Object.assign(new Error('GLOBAL_CHAT_EMPTY'), { code: 'GLOBAL_CHAT_EMPTY' });
    }
    if (trimmed.length > MAX_BODY) {
      throw Object.assign(new Error('GLOBAL_CHAT_TOO_LONG'), { code: 'GLOBAL_CHAT_TOO_LONG' });
    }

    const { text, filtered } = filterProfanity(trimmed, await extraWords());
    const body = sticker && !text ? getGlobalChatSticker(sticker)?.emoji ?? '' : text;

    return persistAndFanout({
      playerId,
      displayName: username,
      source: 'game',
      message: body,
      stickerId: sticker,
      filtered,
      mirrorToDiscord: true,
    });
  },

  async sendSystemAnnouncement(
    displayName: string,
    message: string,
  ): Promise<GlobalChatPublicMessage | null> {
    if (!(await isGlobalChatEnabled())) {
      return null;
    }
    const body = message.trim().slice(0, MAX_BODY);
    if (!body) {
      return null;
    }
    return persistAndFanout({
      playerId: null,
      displayName: displayName.trim().slice(0, 64) || 'The Mob State',
      source: 'system',
      message: body,
      stickerId: null,
      filtered: false,
      mirrorToDiscord: true,
    });
  },

  async ingestDiscordMessage(input: {
    discordUserId: string;
    discordMessageId: string;
    displayName: string;
    message: string;
    stickerId?: string | null;
  }): Promise<GlobalChatPublicMessage | null> {
    if (!(await isGlobalChatEnabled())) return null;

    const existing = await prisma.globalChatMessage.findUnique({
      where: { discordMessageId: input.discordMessageId },
    });
    if (existing) return null;

    const player = await prisma.player.findFirst({
      where: { discordId: input.discordUserId },
      select: { id: true, username: true, isBanned: true },
    });
    if (player?.isBanned) return null;
    if (player) {
      if (await isPlayerMuted(player.id)) return null;
    }

    const sticker = isGlobalChatStickerId(input.stickerId ?? null) ? (input.stickerId as string) : null;
    const trimmed = (input.message ?? '').trim().slice(0, MAX_BODY);
    if (!sticker && !trimmed) return null;

    const { text, filtered } = filterProfanity(trimmed, await extraWords());
    const body = sticker && !text ? getGlobalChatSticker(sticker)?.emoji ?? '' : text;

    return persistAndFanout({
      playerId: player?.id ?? null,
      discordUserId: input.discordUserId,
      discordMessageId: input.discordMessageId,
      displayName: (player?.username || input.displayName.trim() || 'Discord').slice(0, 64),
      source: 'discord',
      message: body,
      stickerId: sticker,
      filtered,
      mirrorToDiscord: false,
    });
  },

  async deleteOwn(messageId: number, playerId: number): Promise<void> {
    const row = await prisma.globalChatMessage.findUnique({ where: { id: messageId } });
    if (!row || row.deletedAt) {
      throw Object.assign(new Error('GLOBAL_CHAT_NOT_FOUND'), { code: 'GLOBAL_CHAT_NOT_FOUND' });
    }
    if (row.playerId !== playerId) {
      throw Object.assign(new Error('GLOBAL_CHAT_FORBIDDEN'), { code: 'GLOBAL_CHAT_FORBIDDEN' });
    }
    if (Date.now() - row.createdAt.getTime() > PLAYER_DELETE_WINDOW_MS) {
      throw Object.assign(new Error('GLOBAL_CHAT_DELETE_EXPIRED'), {
        code: 'GLOBAL_CHAT_DELETE_EXPIRED',
      });
    }
    await prisma.globalChatMessage.update({
      where: { id: messageId },
      data: { deletedAt: new Date() },
    });
    broadcastDeleted(messageId);
    void globalChatDiscordBridge.deleteMirroredMessage(row.discordMessageId);
  },

  async adminDelete(messageId: number): Promise<void> {
    const row = await prisma.globalChatMessage.findUnique({ where: { id: messageId } });
    if (!row || row.deletedAt) {
      throw Object.assign(new Error('GLOBAL_CHAT_NOT_FOUND'), { code: 'GLOBAL_CHAT_NOT_FOUND' });
    }
    await prisma.globalChatMessage.update({
      where: { id: messageId },
      data: { deletedAt: new Date() },
    });
    broadcastDeleted(messageId);
    void globalChatDiscordBridge.deleteMirroredMessage(row.discordMessageId);
  },

  async report(messageId: number, reporterId: number): Promise<void> {
    const row = await prisma.globalChatMessage.findUnique({ where: { id: messageId } });
    if (!row || row.deletedAt) {
      throw Object.assign(new Error('GLOBAL_CHAT_NOT_FOUND'), { code: 'GLOBAL_CHAT_NOT_FOUND' });
    }
    if (row.playerId === reporterId || row.source === 'system') {
      throw Object.assign(new Error('GLOBAL_CHAT_FORBIDDEN'), { code: 'GLOBAL_CHAT_FORBIDDEN' });
    }
    await prisma.globalChatReport.create({
      data: { messageId, reporterId },
    });
  },

  async mutePlayer(playerId: number, minutes: number, reason?: string): Promise<void> {
    const until = minutes <= 0 ? null : new Date(Date.now() + minutes * 60_000);
    await prisma.globalChatMute.upsert({
      where: { playerId },
      create: { playerId, mutedUntil: until, reason: reason?.slice(0, 255) ?? null },
      update: { mutedUntil: until, reason: reason?.slice(0, 255) ?? null },
    });
  },

  async unmutePlayer(playerId: number): Promise<void> {
    await prisma.globalChatMute.delete({ where: { playerId } }).catch(() => undefined);
  },

  async getLinkedStaffByDiscordId(
    discordUserId: string,
  ): Promise<{ id: number; username: string; staffRole: 'MOD' | 'OPS' } | null> {
    const id = String(discordUserId || '').trim();
    if (!id) return null;
    const player = await prisma.player.findFirst({
      where: { discordId: id },
      select: { id: true, username: true, isBanned: true },
    });
    if (!player || player.isBanned) return null;
    const staffRole = publicStaffRole(await readPlayerStaffRole(player.id));
    if (!staffRole) return null;
    return { id: player.id, username: player.username, staffRole };
  },

  async findPlayerForStaffTarget(input: {
    mentionDiscordId?: string | null;
    username?: string | null;
  }): Promise<{ id: number; username: string } | null> {
    const mention = String(input.mentionDiscordId || '').trim();
    if (mention) {
      const byDiscord = await prisma.player.findFirst({
        where: { discordId: mention },
        select: { id: true, username: true },
      });
      if (byDiscord) return byDiscord;
    }
    const name = String(input.username || '').trim();
    if (!name) return null;
    const rows = await prisma.$queryRawUnsafe<Array<{ id: unknown; username: string }>>(
      'SELECT id, username FROM players WHERE username = ? LIMIT 1',
      name,
    );
    const id = asPlayerId(rows?.[0]?.id);
    if (id == null) return null;
    return { id, username: rows[0].username };
  },

  async deleteByDiscordMessageId(discordMessageId: string): Promise<boolean> {
    const key = String(discordMessageId || '').trim();
    if (!key) return false;
    const row = await prisma.globalChatMessage.findUnique({
      where: { discordMessageId: key },
    });
    if (!row || row.deletedAt) return false;
    await this.adminDelete(row.id);
    return true;
  },

  async isPlayerStaffMember(playerId: number): Promise<boolean> {
    return isPlayerStaff(await readPlayerStaffRole(playerId));
  },

  async getAdminOverview() {
    const [messages, reports, mutes, extraBlocklist, enabled] = await Promise.all([
      prisma.globalChatMessage.findMany({
        where: { deletedAt: null },
        orderBy: { createdAt: 'desc' },
        take: 80,
      }),
      prisma.globalChatReport.findMany({
        orderBy: { createdAt: 'desc' },
        take: 40,
      }),
      prisma.globalChatMute.findMany({
        include: { player: { select: { id: true, username: true } } },
        orderBy: { createdAt: 'desc' },
        take: 40,
      }),
      extraWords(),
      isGlobalChatEnabled(),
    ]);
    return {
      enabled,
      extraBlocklist: extraBlocklist.join('\n'),
      discord: globalChatDiscordBridge.status(),
      messages: await (async () => {
        const roles = await staffRolesByPlayerIds(messages.map((row) => row.playerId));
        return messages.map((row) => toPublic(row, staffRoleOf(roles, row.playerId)));
      })(),
      reports,
      mutes: mutes.map((mute) => ({
        playerId: mute.playerId,
        username: mute.player.username,
        mutedUntil: mute.mutedUntil?.toISOString() ?? null,
        reason: mute.reason,
      })),
    };
  },

  async getStaffTools() {
    const [reports, mutes] = await Promise.all([
      prisma.globalChatReport.findMany({
        orderBy: { createdAt: 'desc' },
        take: 40,
      }),
      prisma.globalChatMute.findMany({
        include: { player: { select: { id: true, username: true } } },
        orderBy: { createdAt: 'desc' },
        take: 40,
      }),
    ]);
    const messageIds = [...new Set(reports.map((row) => row.messageId))];
    const messages = messageIds.length
      ? await prisma.globalChatMessage.findMany({ where: { id: { in: messageIds } } })
      : [];
    const roles = await staffRolesByPlayerIds(messages.map((row) => row.playerId));
    const byId = new Map(messages.map((row) => [row.id, row]));
    return {
      reports: reports.map((row) => {
        const message = byId.get(row.messageId);
        return {
          id: row.id,
          messageId: row.messageId,
          reporterId: row.reporterId,
          createdAt: row.createdAt.toISOString(),
          message: message
            ? toPublic(message, staffRoleOf(roles, message.playerId))
            : null,
        };
      }),
      mutes: mutes.map((mute) => ({
        playerId: mute.playerId,
        username: mute.player.username,
        mutedUntil: mute.mutedUntil?.toISOString() ?? null,
        reason: mute.reason,
      })),
    };
  },

  async setEnabled(enabled: boolean): Promise<void> {
    await prisma.$executeRawUnsafe(
      `INSERT INTO runtime_config (configKey, configValue)
       VALUES (?, ?)
       ON DUPLICATE KEY UPDATE configValue = VALUES(configValue)`,
      RATE_KEY_ENABLED,
      enabled ? '1' : '0',
    );
  },

  async setExtraBlocklist(raw: string): Promise<void> {
    await prisma.$executeRawUnsafe(
      `INSERT INTO runtime_config (configKey, configValue)
       VALUES (?, ?)
       ON DUPLICATE KEY UPDATE configValue = VALUES(configValue)`,
      RATE_KEY_BLOCKLIST,
      parseExtraBlocklist(raw).join('\n'),
    );
  },
};
