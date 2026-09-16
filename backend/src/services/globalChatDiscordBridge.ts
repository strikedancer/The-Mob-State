import axios from 'axios';
import { getGlobalChatSticker } from '../data/globalChatStickers';
import type { GlobalChatPublicMessage } from './globalChatService';
import { parseDiscordStaffCommand, staffDiscordUsername } from '../utils/globalChatDiscordStaff';
import { createAuditLog } from '../middleware/auditLog';

type DiscordChannelMessage = {
  id: string;
  content?: string;
  webhook_id?: string;
  author?: {
    id: string;
    username?: string;
    global_name?: string | null;
    bot?: boolean;
  };
  member?: {
    nick?: string | null;
  };
  message_reference?: {
    message_id?: string | null;
  };
  referenced_message?: {
    id?: string | null;
  };
  mentions?: Array<{ id: string }>;
  stickers?: Array<{ name?: string }>;
  sticker_items?: Array<{ name?: string }>;
};

const STAFF_HELP =
  'Mod/Ops in dit kanaal: berichten uit de game tonen [Ops] of [Mod] bij de naam. Beantwoord een bericht met !wis om het in game en Discord te wissen. !mute @naam 15 of 60 dempt de wereldchat. !unmute @naam haalt dat weg. Discord moet in het spel gekoppeld zijn.';

function discordDisplayName(item: DiscordChannelMessage): string {
  const username = item.author?.username?.trim();
  const globalName = item.author?.global_name?.trim();
  const nick = item.member?.nick?.trim();
  return (username || globalName || nick || 'Discord').slice(0, 64);
}

const POLL_MS = 4000;
const DISCORD_API = 'https://discord.com/api/v10';
const DISCORD_USER_AGENT = 'TheMobState (https://themobstate.com, 1.0)';
const AUTH_WARN_MS = 60_000;

function webhookUrl(): string | null {
  return process.env.GLOBAL_CHAT_DISCORD_WEBHOOK_URL?.trim() || null;
}

function botToken(): string | null {
  return process.env.GLOBAL_CHAT_DISCORD_BOT_TOKEN?.trim() || null;
}

function channelId(): string | null {
  return process.env.GLOBAL_CHAT_DISCORD_CHANNEL_ID?.trim() || null;
}

function webhookIdFromUrl(url: string): string | null {
  const match = url.match(/\/webhooks\/(\d+)\//);
  return match?.[1] ?? null;
}

function currentSnowflake(): string {
  const discordEpoch = 1_420_070_400_000n;
  return ((BigInt(Date.now()) - discordEpoch) << 22n).toString();
}

function safeWebhookUsername(name: string): string {
  const trimmed = name.replace(/discord/gi, 'player').trim().slice(0, 80);
  if (!trimmed || /^clyde$/i.test(trimmed)) return 'The Mob State';
  return trimmed;
}

function stickerNameToId(name: string | undefined): string | null {
  if (!name) return null;
  const folded = name.toLowerCase().replace(/[^a-z0-9]+/g, '');
  const catalog = [
    'cash',
    'gun',
    'skull',
    'fire',
    'car',
    'plane',
    'crown',
    'dice',
    'heart',
    'laugh',
    'cool',
    'angry',
    'thumbs',
    'clap',
    'cop',
    'lock',
    'bomb',
    'diamond',
    'cheers',
    'rose',
    'smoke',
    'night',
    'wolf',
    'eye',
  ];
  return catalog.find((id) => folded.includes(id)) ?? null;
}

class GlobalChatDiscordBridge {
  private timer: ReturnType<typeof setInterval> | null = null;
  private lastMessageId = currentSnowflake();
  private started = false;
  private lastAuthWarnAt = 0;

  status(): {
    outbound: boolean;
    inbound: boolean;
  } {
    return {
      outbound: Boolean(webhookUrl()),
      inbound: Boolean(botToken() && channelId()),
    };
  }

  start(): void {
    if (this.started) return;
    this.started = true;
    this.lastMessageId = currentSnowflake();
    if (!botToken() || !channelId()) {
      console.log('[GlobalChat] Discord inbound off (bot token or channel missing)');
      return;
    }
    console.log('[GlobalChat] Discord inbound polling started');
    void this.poll();
    this.timer = setInterval(() => {
      void this.poll();
    }, POLL_MS);
  }

  stop(): void {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
    this.started = false;
  }

  async mirrorGameMessage(message: GlobalChatPublicMessage): Promise<string | null> {
    const url = webhookUrl();
    if (!url) return null;
    const sticker = getGlobalChatSticker(message.stickerId);
    const content = sticker && !message.message.trim()
      ? sticker.emoji
      : [message.message, sticker && message.message.trim() !== sticker.emoji ? sticker.emoji : '']
          .filter(Boolean)
          .join(' ')
          .slice(0, 1800);
    if (!content.trim()) return null;
    try {
      const response = await axios.post<{ id?: string }>(
        `${url}?wait=true`,
        {
          username: safeWebhookUsername(
            staffDiscordUsername(message.displayName, message.staffRole),
          ),
          content,
          allowed_mentions: { parse: [] },
        },
        { timeout: 8000 },
      );
      return String(response.data?.id || '').trim() || null;
    } catch (error) {
      console.warn('[GlobalChat] Discord outbound failed', error instanceof Error ? error.message : error);
      return null;
    }
  }

  async deleteMirroredMessage(discordMessageId: string | null): Promise<void> {
    const id = String(discordMessageId || '').trim();
    if (!id) return;
    const url = webhookUrl();
    if (url) {
      try {
        await axios.delete(`${url}/messages/${id}`, { timeout: 8000 });
        return;
      } catch {
        // Webhook can only delete its own copies; user messages use the bot token.
      }
    }
    await this.deleteChannelMessage(id);
  }

  private async poll(): Promise<void> {
    const token = botToken();
    const channel = channelId();
    if (!token || !channel) return;
    try {
      const response = await axios.get<DiscordChannelMessage[]>(
        `${DISCORD_API}/channels/${channel}/messages`,
        {
          params: { after: this.lastMessageId, limit: 20 },
          headers: {
            Authorization: `Bot ${token}`,
            'User-Agent': DISCORD_USER_AGENT,
          },
          timeout: 8000,
        },
      );
      const batch = Array.isArray(response.data) ? [...response.data].reverse() : [];
      const ownWebhookId = webhookUrl() ? webhookIdFromUrl(webhookUrl() as string) : null;
      const { globalChatService } = await import('./globalChatService');
      for (const item of batch) {
        this.lastMessageId = item.id;
        if (item.webhook_id && (!ownWebhookId || item.webhook_id === ownWebhookId)) {
          continue;
        }
        if (item.author?.bot) continue;
        const handled = await this.handleStaffCommand(item, globalChatService);
        if (handled) continue;
        const stickerName = item.sticker_items?.[0]?.name ?? item.stickers?.[0]?.name;
        const ingested = await globalChatService.ingestDiscordMessage({
          discordUserId: item.author?.id ?? '0',
          discordMessageId: item.id,
          displayName: discordDisplayName(item),
          message: item.content ?? '',
          stickerId: stickerNameToId(stickerName),
        });
        if (ingested?.staffRole) {
          void this.addStaffReaction(item.id, ingested.staffRole);
        }
      }
    } catch (error) {
      const status = axios.isAxiosError(error) ? error.response?.status : undefined;
      if (status === 401) {
        console.warn('[GlobalChat] Discord inbound token rejected');
        this.stop();
        return;
      }
      if (status === 403) {
        const now = Date.now();
        if (now - this.lastAuthWarnAt > AUTH_WARN_MS) {
          this.lastAuthWarnAt = now;
          console.warn(
            '[GlobalChat] Discord inbound missing channel access; invite the bot and let it see #wereldchat',
          );
        }
        return;
      }
      console.warn('[GlobalChat] Discord poll failed', error instanceof Error ? error.message : error);
    }
  }

  private botHeaders(): Record<string, string> {
    return {
      Authorization: `Bot ${botToken()}`,
      'User-Agent': DISCORD_USER_AGENT,
    };
  }

  private async deleteChannelMessage(messageId: string): Promise<void> {
    const token = botToken();
    const channel = channelId();
    if (!token || !channel || !messageId) return;
    try {
      await axios.delete(`${DISCORD_API}/channels/${channel}/messages/${messageId}`, {
        headers: this.botHeaders(),
        timeout: 8000,
      });
    } catch {
      // Missing Manage Messages is expected until the bot invite is refreshed.
    }
  }

  private async postStaffReply(content: string): Promise<void> {
    const token = botToken();
    const channel = channelId();
    if (!token || !channel || !content.trim()) return;
    try {
      await axios.post(
        `${DISCORD_API}/channels/${channel}/messages`,
        { content: content.slice(0, 1800), allowed_mentions: { parse: [] } },
        { headers: this.botHeaders(), timeout: 8000 },
      );
    } catch (error) {
      console.warn('[GlobalChat] Discord staff reply failed', error instanceof Error ? error.message : error);
    }
  }

  private async addStaffReaction(messageId: string, role: 'MOD' | 'OPS'): Promise<void> {
    const token = botToken();
    const channel = channelId();
    if (!token || !channel || !messageId) return;
    const emoji = role === 'OPS' ? encodeURIComponent('🛡️') : encodeURIComponent('🔨');
    try {
      await axios.put(
        `${DISCORD_API}/channels/${channel}/messages/${messageId}/reactions/${emoji}/@me`,
        {},
        { headers: this.botHeaders(), timeout: 8000 },
      );
    } catch {
      // Add Reactions is optional until the bot invite is refreshed.
    }
  }

  private async handleStaffCommand(
    item: DiscordChannelMessage,
    globalChatService: typeof import('./globalChatService').globalChatService,
  ): Promise<boolean> {
    const parsed = parseDiscordStaffCommand(item.content ?? '');
    if (!parsed) return false;
    const staff = await globalChatService.getLinkedStaffByDiscordId(item.author?.id ?? '');
    if (!staff) return false;

    const replyId =
      item.message_reference?.message_id || item.referenced_message?.id || null;
    const mentionId = parsed.kind === 'mute' || parsed.kind === 'unmute'
      ? parsed.mentionId || item.mentions?.[0]?.id || null
      : null;

    if (parsed.kind === 'help') {
      await this.postStaffReply(STAFF_HELP);
      await this.deleteChannelMessage(item.id);
      return true;
    }

    if (parsed.kind === 'delete') {
      if (!replyId) {
        await this.postStaffReply('Beantwoord het bericht dat je wilt wissen met !wis.');
        return true;
      }
      const deleted = await globalChatService.deleteByDiscordMessageId(replyId);
      await this.deleteChannelMessage(replyId);
      await this.deleteChannelMessage(item.id);
      void createAuditLog({
        action: 'GLOBAL_CHAT_DELETE',
        targetType: 'GlobalChatMessage',
        targetId: replyId,
        actorPlayerId: staff.id,
        actorStaffRole: staff.staffRole,
        details: { source: 'discord', actorPlayerId: staff.id, actorStaffRole: staff.staffRole },
      });
      await this.postStaffReply(
        deleted
          ? `Bericht gewist door ${staff.staffRole === 'OPS' ? 'Ops' : 'Mod'} ${staff.username}.`
          : 'Dat bericht stond niet (meer) in de wereldchat; ik heb de Discord-regel wel weggehaald als dat mocht.',
      );
      return true;
    }

    const target = await globalChatService.findPlayerForStaffTarget({
      mentionDiscordId: mentionId,
      username: parsed.kind === 'mute' || parsed.kind === 'unmute' ? parsed.username : null,
    });
    if (!target) {
      await this.postStaffReply('Geen gekoppeld spelaccount gevonden. Tag iemand of gebruik de in-game naam.');
      return true;
    }
    if (target.id === staff.id) {
      await this.postStaffReply('Je kunt jezelf niet muten.');
      return true;
    }
    if (await globalChatService.isPlayerStaffMember(target.id)) {
      await this.postStaffReply('Mods en Ops kun je niet muten.');
      return true;
    }

    if (parsed.kind === 'mute') {
      await globalChatService.mutePlayer(target.id, parsed.minutes, `discord:${staff.username}`);
      void createAuditLog({
        action: 'GLOBAL_CHAT_MUTE',
        targetType: 'Player',
        targetId: String(target.id),
        actorPlayerId: staff.id,
        actorStaffRole: staff.staffRole,
        details: {
          source: 'discord',
          actorPlayerId: staff.id,
          actorStaffRole: staff.staffRole,
          minutes: parsed.minutes,
        },
      });
      await this.deleteChannelMessage(item.id);
      await this.postStaffReply(
        `${target.username} is ${parsed.minutes} minuten gedempt in de wereldchat.`,
      );
      return true;
    }

    await globalChatService.unmutePlayer(target.id);
    void createAuditLog({
      action: 'GLOBAL_CHAT_UNMUTE',
      targetType: 'Player',
      targetId: String(target.id),
      actorPlayerId: staff.id,
      actorStaffRole: staff.staffRole,
      details: { source: 'discord', actorPlayerId: staff.id, actorStaffRole: staff.staffRole },
    });
    await this.deleteChannelMessage(item.id);
    await this.postStaffReply(`${target.username} mag weer in de wereldchat.`);
    return true;
  }
}

export const globalChatDiscordBridge = new GlobalChatDiscordBridge();
