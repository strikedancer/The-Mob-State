/// Keys excluded from the personal dashboard activity feed.
const _personalFeedExcludedExact = <String>{
  'player.activity',
  'auth.session.login',
  'connection.established',
};

bool isPersonalDashboardFeedEvent(String eventKey) {
  if (eventKey.isEmpty) return false;
  if (_personalFeedExcludedExact.contains(eventKey)) return false;
  return true;
}

/// Backward-compatible alias.
bool isPublicWorldFeedEvent(String eventKey) =>
    isPersonalDashboardFeedEvent(eventKey);
