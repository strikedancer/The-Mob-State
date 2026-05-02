import 'package:http/http.dart' as http;

import 'portrait_download_impl_stub.dart'
    if (dart.library.html) 'portrait_download_impl_web.dart'
    if (dart.library.io) 'portrait_download_impl_io.dart' as impl;

/// Fetches the portrait PNG and triggers a browser download (web) or share sheet (mobile/desktop).
Future<void> fetchAndSavePortraitPng(String absoluteUrl, String filename) async {
  final uri = Uri.parse(absoluteUrl);
  final response = await http.get(uri);
  if (response.statusCode != 200) {
    throw Exception('HTTP ${response.statusCode}');
  }
  await impl.savePortraitPngBytes(response.bodyBytes, filename);
}
