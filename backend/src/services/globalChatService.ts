import prisma from '../lib/prisma';
import { eventBroadcaster } from './eventBroadcaster';
import { filterProfanity, parseExtraBlocklist } from '../utils/profanityFilter';
import { getGlobalChatSticker, isGlobalChatStickerId } from '../data/globalChatStickers';
import { globalChatDiscordBridge } from './globalChatDiscordBridge';

const MAX_BODY = 200;
const HISTORY_LIMIT = 100;
const MIN_INTERVAL_MS = 3000;
const MAX_PER_MINUTE = 10;
const PLAYER_DELETE_WINDOW_MS = 10 * 60 * 1000;

const RATE_KEY_ENABLED = 'GLOBAL_CHAT_ENABLED';
const RATE_KEY_BLOCKLIST = 'GLOBAL_CHAT_EXTRA_BLOCKLIST';

type ChatSource = 'game' | 'discord';

export type GlobalChatPublicMessage = {
  id: number;
  playerId: number | null;
  displayName: string;
  source: ChatSource;
  message: string;
  stickerId: string | null;
  stickerEmoji: string | null;
  createdAt: string;
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

function toPublic(row: {
  id: number;
  playerId: number | null;
  displayName: string;
  source: string;
  message: string;
  stickerId: string | null;
  createdAt: Date;
}): GlobalChatPublicMessage {
  const sticker = getGlobalChatSticker(row.stickerId);
  return {
    id: row.id,
    playerId: row.playerId,
    displayName: row.displayName,
    source: row.source === 'discord' ? 'discord' : 'game',
    message: row.message,
    stickerId: row.stickerId,
    stickerEmoji: sticker?.emoji ?? null,
    createdAt: row.createdAt.toISOString(),
  };
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
  const publicMessage = toPublic(row);
  broadcastMessage(publicMessage);
  if (input.mirrorToDiscord) {
    void globalChatDiscordBridge.mirrorGameMessage(publicMessage);
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
    return rows.reverse().map(toPublic);
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
      displayName: player?.username || input.displayName,
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
    if (row.playerId === reporterId) {
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
      messages: messages.map(toPublic),
      reports,
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
