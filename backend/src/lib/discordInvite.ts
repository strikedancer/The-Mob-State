const DISCORD_INVITE_RE =
  /^https:\/\/(?:discord\.gg|discord(?:app)?\.com\/invite)\/[A-Za-z0-9-]+\/?(?:\?.*)?$/i;

export function getDiscordInviteUrl(): string | null {
  const raw = (process.env.DISCORD_INVITE_URL ?? '').trim();
  if (!raw) return null;
  if (!DISCORD_INVITE_RE.test(raw)) {
    console.warn('[Discord] DISCORD_INVITE_URL rejected (expected discord.gg or discord.com/invite)');
    return null;
  }
  return raw.replace(/\/+$/, '');
}
