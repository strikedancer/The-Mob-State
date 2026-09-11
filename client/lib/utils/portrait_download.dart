import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import 'portrait_download_impl_stub.dart'
    if (dart.library.html) 'portrait_download_impl_web.dart'
    if (dart.library.io) 'portrait_download_impl_io.dart' as impl;

/// Downloads an owned custom portrait via the authenticated API.
///
/// Uses `GET /settings/portraits/:id/file` so later downloads work without
/// relying on a public `/images/...` fetch (CORS / hotlink issues).
Future<void> downloadOwnedPortraitPng(int portraitId) async {
  const storage = FlutterSecureStorage();
  final token = await storage.read(key: 'auth_token');
  if (token == null) {
    throw Exception('not logged in');
  }

  final response = await http.get(
    Uri.parse('${AppConfig.apiBaseUrl}/settings/portraits/$portraitId/file'),
    headers: {'Authorization': 'Bearer $token'},
  );
  if (response.statusCode != 200) {
    throw Exception('HTTP ${response.statusCode}');
  }

  await impl.savePortraitPngBytes(
    response.bodyBytes,
    'mob_state_portrait_$portraitId.png',
  );
}
