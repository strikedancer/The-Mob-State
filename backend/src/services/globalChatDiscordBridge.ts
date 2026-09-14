import axios from 'axios';
import { getGlobalChatSticker } from '../data/globalChatStickers';
import type { GlobalChatPublicMessage } from './globalChatService';

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
  stickers?: Array<{ name?: string }>;
  sticker_items?: Array<{ name?: string }>;
};

const POLL_MS = 4000;
const DISCORD_API = 'https://discord.com/api/v10';

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

  async mirrorGameMessage(message: GlobalChatPublicMessage): Promise<void> {
    const url = webhookUrl();
    if (!url) return;
    const sticker = getGlobalChatSticker(message.stickerId);
    const content = sticker && !message.message.trim()
      ? sticker.emoji
      : [message.message, sticker && message.message.trim() !== sticker.emoji ? sticker.emoji : '']
          .filter(Boolean)
          .join(' ')
          .slice(0, 1800);
    if (!content.trim()) return;
    try {
      await axios.post(
        `${url}?wait=false`,
        {
          username: safeWebhookUsername(message.displayName),
          content,
          allowed_mentions: { parse: [] },
        },
        { timeout: 8000 },
      );
    } catch (error) {
      console.warn('[GlobalChat] Discord outbound failed', error instanceof Error ? error.message : error);
    }
  }

  async deleteMirroredMessage(_discordMessageId: string | null): Promise<void> {
    // Game-originated posts go out as webhooks without storing Discord's copy id.
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
          headers: { Authorization: `Bot ${token}` },
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
        const stickerName = item.sticker_items?.[0]?.name ?? item.stickers?.[0]?.name;
        const ingested = await globalChatService.ingestDiscordMessage({
          discordUserId: item.author?.id ?? '0',
          discordMessageId: item.id,
          displayName: item.author?.global_name || item.author?.username || 'Discord',
          message: item.content ?? '',
          stickerId: stickerNameToId(stickerName),
        });
        if (ingested) {
          // already fanned out
        }
      }
    } catch (error) {
      const status = axios.isAxiosError(error) ? error.response?.status : undefined;
      if (status === 401 || status === 403) {
        console.warn('[GlobalChat] Discord inbound auth failed; check bot token and channel access');
        this.stop();
        return;
      }
      console.warn('[GlobalChat] Discord poll failed', error instanceof Error ? error.message : error);
    }
  }
}

export const globalChatDiscordBridge = new GlobalChatDiscordBridge();
