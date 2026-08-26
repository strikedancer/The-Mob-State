/**
 * Keys that are stored/broadcast for other channels but should not clutter
 * the player's personal dashboard activity feed.
 */
export const PERSONAL_FEED_EXACT_EXCLUDE = [
  'player.activity',
  'auth.session.login',
  'connection.established',
] as const;

/** Chat/SSE-only keys — live push yes, dashboard feed no. */
export const PERSONAL_FEED_PREFIX_EXCLUDE = ['direct_message.'] as const;

export function isPersonalDashboardFeedEvent(eventKey: string): boolean {
  if (!eventKey) return false;
  if ((PERSONAL_FEED_EXACT_EXCLUDE as readonly string[]).includes(eventKey)) {
    return false;
  }
  if (
    (PERSONAL_FEED_PREFIX_EXCLUDE as readonly string[]).some((prefix) =>
      eventKey.startsWith(prefix)
    )
  ) {
    return false;
  }
  return true;
}

/** Whether a player-scoped event should still arrive over SSE (badges, chat). */
export function shouldPushPlayerActivitySSE(eventKey: string): boolean {
  if (!eventKey) return false;
  return !(PERSONAL_FEED_EXACT_EXCLUDE as readonly string[]).includes(eventKey);
}

/** @deprecated Use isPersonalDashboardFeedEvent — public world feed removed. */
export function isPublicWorldFeedEvent(eventKey: string): boolean {
  return isPersonalDashboardFeedEvent(eventKey);
}

/** @deprecated */
export const PUBLIC_FEED_EXACT_EXCLUDE = PERSONAL_FEED_EXACT_EXCLUDE;
