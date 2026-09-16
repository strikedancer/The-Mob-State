export type DiscordStaffParsed =
  | { kind: 'help' }
  | { kind: 'delete' }
  | {
      kind: 'mute';
      minutes: number;
      mentionId: string | null;
      username: string | null;
    }
  | {
      kind: 'unmute';
      mentionId: string | null;
      username: string | null;
    };

function firstMentionId(text: string): string | null {
  const match = /<@!?(\d+)>/.exec(text);
  return match?.[1] ?? null;
}

function clampMuteMinutes(raw: number): number {
  if (!Number.isFinite(raw)) return 15;
  return Math.min(10080, Math.max(1, Math.trunc(raw)));
}

export function parseDiscordStaffCommand(raw: string): DiscordStaffParsed | null {
  const text = (raw || '').trim();
  if (!text.startsWith('!')) return null;
  const mentionId = firstMentionId(text);
  const withoutMentions = text.replace(/<@!?\d+>/g, ' ').replace(/\s+/g, ' ').trim();
  const parts = withoutMentions.slice(1).split(' ').filter(Boolean);
  const cmd = (parts[0] || '').toLowerCase();
  if (!cmd) return null;

  if (cmd === 'hulp' || cmd === 'help' || cmd === 'modhulp') {
    return { kind: 'help' };
  }
  if (cmd === 'wis' || cmd === 'delete' || cmd === 'del') {
    return { kind: 'delete' };
  }
  if (cmd === 'mute' || cmd === 'demp') {
    const minutesToken = parts.find((part, index) => index > 0 && /^\d+$/.test(part));
    const nameParts = parts.slice(1).filter((part) => !/^\d+$/.test(part));
    return {
      kind: 'mute',
      minutes: clampMuteMinutes(minutesToken ? Number(minutesToken) : 15),
      mentionId,
      username: nameParts.join(' ') || null,
    };
  }
  if (cmd === 'unmute' || cmd === 'ontdemp') {
    const nameParts = parts.slice(1).filter((part) => !/^\d+$/.test(part));
    return {
      kind: 'unmute',
      mentionId,
      username: nameParts.join(' ') || null,
    };
  }
  return null;
}

export function staffDiscordUsername(
  displayName: string,
  staffRole: 'MOD' | 'OPS' | null | undefined,
): string {
  const name = String(displayName || '').trim();
  if (/^\[(ops|mod)\]\s/i.test(name)) return name;
  const tag = staffRole === 'OPS' ? '[Ops] ' : staffRole === 'MOD' ? '[Mod] ' : '';
  return `${tag}${name}`.trim();
}
