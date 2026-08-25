/** Exact event keys excluded from the public dashboard world feed. */
export const PUBLIC_FEED_EXACT_EXCLUDE = [
  'player.activity',
  'job.failed',
  'crew.message',
  'direct_message.received',
  'direct_message.sent',
  'direct_message.read',
  'direct_message.deleted',
] as const;

/**
 * Event keys that must not appear on the public dashboard world feed.
 * Private messaging / crew chat use worldEvent + SSE today but are not public news.
 */
export function isPublicWorldFeedEvent(eventKey: string): boolean {
  if (!eventKey) return false;
  if ((PUBLIC_FEED_EXACT_EXCLUDE as readonly string[]).includes(eventKey)) {
    return false;
  }
  if (eventKey.startsWith('direct_message.')) return false;
  if (eventKey.startsWith('job.error')) return false;
  return true;
}
