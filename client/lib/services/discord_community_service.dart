import 'dart:convert';

import 'api_client.dart';

/// Cached public Discord invite. Empty/null when the server has no URL.
class DiscordCommunityService {
  DiscordCommunityService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;
  static String? _cachedInvite;
  static bool _loaded = false;

  static void clearCache() {
    _cachedInvite = null;
    _loaded = false;
  }

  Future<String?> fetchInviteUrl() async {
    if (_loaded) return _cachedInvite;
    try {
      final response = await _apiClient.get(
        '/public/community',
        includeAuth: false,
      );
      if (response.statusCode != 200) {
        _loaded = true;
        _cachedInvite = null;
        return null;
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        _loaded = true;
        _cachedInvite = null;
        return null;
      }
      final data = decoded['data'];
      String? raw;
      if (data is Map<String, dynamic>) {
        raw = data['discordInviteUrl']?.toString();
      } else {
        raw = decoded['discordInviteUrl']?.toString();
      }
      final invite = (raw ?? '').trim();
      _cachedInvite = invite.isEmpty ? null : invite;
      _loaded = true;
      return _cachedInvite;
    } catch (_) {
      _loaded = true;
      _cachedInvite = null;
      return null;
    }
  }
}
