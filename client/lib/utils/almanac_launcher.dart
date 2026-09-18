import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../services/api_client.dart';

/// Opens the public Almanac without rotating the game session.
///
/// Logged-in players get a short-lived Almanac-only token in the URL hash
/// (`#tms=…`). Wiki login via password is not used: that would bump
/// `lastSessionAt` and kick the player out of the game.
class AlmanacLauncher {
  AlmanacLauncher._();

  static final ApiClient _api = ApiClient();

  static Future<void> open({
    required String languageCode,
    bool guide = false,
  }) async {
    final base = guide
        ? AppConfig.wikiGuideUrl(languageCode)
        : AppConfig.wikiHomeUrl(languageCode);
    var url = base;
    try {
      final gameToken = await _api.getToken();
      if (gameToken != null && gameToken.isNotEmpty) {
        final res = await http
            .post(
              Uri.parse('${AppConfig.apiBaseUrl}/almanac/handoff'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $gameToken',
              },
              body: '{}',
            )
            .timeout(AppConfig.apiTimeout);
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final handoff = data is Map ? data['token'] : null;
          if (handoff is String && handoff.isNotEmpty) {
            url = '$base#tms=${Uri.encodeComponent(handoff)}';
          }
        }
      }
    } catch (_) {
      // Catalogue still works without identity.
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
