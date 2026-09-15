import axios from 'axios';

export type CrewWarDiscordEvent =
  | 'war_declared'
  | 'war_started'
  | 'war_lockdown'
  | 'war_resolved';

export type CrewWarDiscordPayload = {
  warId: number;
  attackerName: string;
  defenderName: string;
  warTypeLabel: string;
  theaterName?: string | null;
  winnerName?: string | null;
  attackerPoints?: number | null;
  defenderPoints?: number | null;
  endsAt?: Date | string | null;
  viaAdmin?: boolean;
};

const CREW_WAR_DISCORD_EVENTS: CrewWarDiscordEvent[] = [
  'war_declared',
  'war_started',
  'war_lockdown',
  'war_resolved',
];

const DEFAULT_MIN_INTERVAL_MS = 15_000;
const EMBED_COLORS: Record<CrewWarDiscordEvent, number> = {
  war_declared: 0xe67e22,
  war_started: 0x3498db,
  war_lockdown: 0xf1c40f,
  war_resolved: 0x2ecc71,
};

function asText(value: unknown, fallback = '—'): string {
  const text = String(value ?? '').trim();
  return (text || fallback).slice(0, 1024);
}

function formatAmsterdam(value: Date | string | null | undefined): string | null {
  if (!value) return null;
  const date = value instanceof Date ? value : new Date(value);
  if (Number.isNaN(date.getTime())) return null;
  return new Intl.DateTimeFormat('nl-NL', {
    dateStyle: 'short',
    timeStyle: 'short',
    timeZone: 'Europe/Amsterdam',
  }).format(date);
}

function field(name: string, value: unknown, inline = true) {
  return {
    name: asText(name, 'Info').slice(0, 256),
    value: asText(value),
    inline,
  };
}

function buildMessage(eventType: CrewWarDiscordEvent, payload: CrewWarDiscordPayload) {
  const attacker = asText(payload.attackerName, 'Onbekende crew');
  const defender = asText(payload.defenderName, 'Onbekende crew');
  const vs = `**${attacker}** vs **${defender}**`;
  const adminNote = payload.viaAdmin ? ' (via staf)' : '';

  if (eventType === 'war_declared') {
    return {
      content: `${vs} — oorlog verklaard`,
      title: 'Oorlog verklaard',
      description: `**${attacker}** heeft **${defender}** de oorlog verklaard${adminNote}.`,
    };
  }
  if (eventType === 'war_started') {
    return {
      content: `${vs} — oorlog begonnen`,
      title: 'Oorlog begonnen',
      description: `${vs} is nu live${adminNote}.`,
    };
  }
  if (eventType === 'war_lockdown') {
    return {
      content: `${vs} — lockdown`,
      title: 'Lockdown',
      description: `${vs} zit in lockdown. Geen nieuwe aanvallen meer.`,
    };
  }
  const winner = payload.winnerName?.trim();
  return {
    content: winner ? `**${winner}** wint: ${attacker} vs ${defender}` : `${vs} — oorlog afgelopen`,
    title: 'Oorlog afgelopen',
    description: winner
      ? `**${winner}** wint van ${winner === attacker ? defender : attacker}.`
      : `${vs} is afgelopen zonder duidelijke winnaar.`,
  };
}

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

  private canSend(eventType: CrewWarDiscordEvent, warId: number): boolean {
    if (!this.enabledEvents.has(eventType)) {
      return false;
    }

    const now = Date.now();
    const rateLimitKey = `${eventType}:${warId}`;
    const lastSent = this.lastSentAt.get(rateLimitKey) ?? 0;
    if (now - lastSent < this.minIntervalMs) {
      return false;
    }

    this.lastSentAt.set(rateLimitKey, now);
    return true;
  }

  async sendCrewWarEvent(eventType: CrewWarDiscordEvent, payload: CrewWarDiscordPayload): Promise<void> {
    if (!this.webhookUrl) {
      return;
    }

    const warId = Number(payload.warId);
    if (!Number.isFinite(warId) || !this.canSend(eventType, warId)) {
      return;
    }

    const message = buildMessage(eventType, payload);
    const fields = [
      field('Aanvaller', payload.attackerName),
      field('Verdediger', payload.defenderName),
      field('Type', payload.warTypeLabel),
    ];
    if (payload.theaterName?.trim()) {
      fields.push(field('Theater', payload.theaterName.trim()));
    }
    const endsAt = formatAmsterdam(payload.endsAt ?? null);
    if (endsAt && eventType !== 'war_resolved') {
      fields.push(field('Live tot', endsAt));
    }
    if (eventType === 'war_resolved') {
      fields.push(field('Winnaar', payload.winnerName?.trim() || 'Geen winnaar'));
      if (payload.attackerPoints != null || payload.defenderPoints != null) {
        fields.push(
          field(
            'Stand',
            `${asText(payload.attackerName)} ${payload.attackerPoints ?? 0} – ${payload.defenderPoints ?? 0} ${asText(payload.defenderName)}`,
            false,
          ),
        );
      }
    }

    try {
      await axios.post(
        this.webhookUrl,
        {
          content: message.content,
          embeds: [
            {
              title: message.title,
              description: message.description,
              color: EMBED_COLORS[eventType],
              fields,
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
