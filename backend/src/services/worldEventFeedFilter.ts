/**
 * Keys that are stored/broadcast for other channels but should not clutter
 * the player's personal dashboard activity feed.
 */
export const PERSONAL_FEED_EXACT_EXCLUDE = [
  'player.activity',
  'auth.session.login',
  'connection.established',
] as const;

export function isPersonalDashboardFeedEvent(eventKey: string): boolean {
  if (!eventKey) return false;
  if ((PERSONAL_FEED_EXACT_EXCLUDE as readonly string[]).includes(eventKey)) {
    return false;
  }
  return true;
}

/** @deprecated Use isPersonalDashboardFeedEvent — public world feed removed. */
export function isPublicWorldFeedEvent(eventKey: string): boolean {
  return isPersonalDashboardFeedEvent(eventKey);
}

/** @deprecated */
export const PUBLIC_FEED_EXACT_EXCLUDE = PERSONAL_FEED_EXACT_EXCLUDE;
