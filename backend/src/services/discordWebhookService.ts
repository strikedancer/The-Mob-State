import axios from 'axios';

type CrewWarDiscordEvent =
  | 'war_declared'
  | 'war_started'
  | 'war_lockdown'
  | 'war_resolved';

const CREW_WAR_DISCORD_EVENTS: CrewWarDiscordEvent[] = [
  'war_declared',
  'war_started',
  'war_lockdown',
  'war_resolved',
];

const DEFAULT_MIN_INTERVAL_MS = 15_000;

class DiscordWebhookService {
  private readonly lastSentAt = new Map<string, number>();

  private get webhookUrl(): string | null {
    return process.env.CREW_WAR_DISCORD_WEBHOOK_URL?.trim() || null;
  }

  private get enabledEvents(): Set<CrewWarDiscordEvent> {
    const configured = process.env.CREW_WAR_DISCORD_ENABLED_EVENTS?.trim();
    if (!configured) {
      return new Set(CREW_WAR_DISCORD_EVENTS);
    }

    const enabled = configured
      .split(',')
      .map((entry) => entry.trim())
      .filter((entry): entry is CrewWarDiscordEvent => CREW_WAR_DISCORD_EVENTS.includes(entry as CrewWarDiscordEvent));

    return new Set(enabled);
  }

  private get minIntervalMs(): number {
    const raw = Number(process.env.CREW_WAR_DISCORD_MIN_INTERVAL_MS ?? DEFAULT_MIN_INTERVAL_MS);
    if (!Number.isFinite(raw) || raw < 0) {
      return DEFAULT_MIN_INTERVAL_MS;
    }
    return raw;
  }

  private buildRateLimitKey(eventType: CrewWarDiscordEvent, payload: Record<string, unknown>): string {
    const warId = payload.warId ?? 'global';
    return `${eventType}:${String(warId)}`;
  }

  private canSend(eventType: CrewWarDiscordEvent, payload: Record<string, unknown>): boolean {
    if (!this.enabledEvents.has(eventType)) {
      return false;
    }

    const now = Date.now();
    const rateLimitKey = this.buildRateLimitKey(eventType, payload);
    const lastSent = this.lastSentAt.get(rateLimitKey) ?? 0;
    if (now - lastSent < this.minIntervalMs) {
      return false;
    }

    this.lastSentAt.set(rateLimitKey, now);
    return true;
  }

  async sendCrewWarEvent(eventType: CrewWarDiscordEvent, payload: Record<string, unknown>): Promise<void> {
    if (!this.webhookUrl) {
      return;
    }

    if (!this.canSend(eventType, payload)) {
      return;
    }

    const contentByEvent: Record<CrewWarDiscordEvent, string> = {
      war_declared: 'Crew war declared',
      war_started: 'Crew war started',
      war_lockdown: 'Crew war entered lockdown',
      war_resolved: 'Crew war resolved',
    };

    try {
      await axios.post(
        this.webhookUrl,
        {
          content: contentByEvent[eventType],
          embeds: [
            {
              title: contentByEvent[eventType],
              description: 'Crew war system update',
              color: eventType === 'war_resolved' ? 0x2ecc71 : 0xe67e22,
              fields: Object.entries(payload).map(([key, value]) => ({
                name: key,
                value: String(value ?? '-'),
                inline: true,
              })),
              timestamp: new Date().toISOString(),
            },
          ],
        },
        {
          timeout: 4000,
          headers: { 'Content-Type': 'application/json' },
        },
      );
    } catch (error) {
      console.warn('[DiscordWebhookService] Failed to send crew war webhook:', error);
    }
  }
}

export const discordWebhookService = new DiscordWebhookService();