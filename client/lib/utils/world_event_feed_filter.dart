/// Keys excluded from the public dashboard world feed (andermans DMs/fails/noise).
const _publicFeedExcludedExact = <String>{
  'player.activity',
  'job.failed',
  'crew.message',
  'direct_message.received',
  'direct_message.sent',
  'direct_message.read',
  'direct_message.deleted',
};

bool isPublicWorldFeedEvent(String eventKey) {
  if (eventKey.isEmpty) return false;
  if (_publicFeedExcludedExact.contains(eventKey)) return false;
  if (eventKey.startsWith('direct_message.')) return false;
  if (eventKey.startsWith('job.error')) return false;
  return true;
}
