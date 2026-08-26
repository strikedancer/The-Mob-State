/// Keys excluded from the personal dashboard activity feed.
const _personalFeedExcludedExact = <String>{
  'player.activity',
  'auth.session.login',
  'connection.established',
};

/// Chat keys stay on SSE (badges/chat) but not in Mijn activiteit.
const _personalFeedExcludedPrefixes = <String>[
  'direct_message.',
];

bool isPersonalDashboardFeedEvent(String eventKey) {
  if (eventKey.isEmpty) return false;
  if (_personalFeedExcludedExact.contains(eventKey)) return false;
  for (final prefix in _personalFeedExcludedPrefixes) {
    if (eventKey.startsWith(prefix)) return false;
  }
  return true;
}

/// Backward-compatible alias.
bool isPublicWorldFeedEvent(String eventKey) =>
    isPersonalDashboardFeedEvent(eventKey);
