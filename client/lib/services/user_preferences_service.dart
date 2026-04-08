import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserPreferencesService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _showVideosKey = 'show_videos_enabled';

  static Future<bool> getShowVideosEnabled() async {
    final raw = await _storage.read(key: _showVideosKey);
    if (raw == null) {
      return true;
    }
    return raw == 'true';
  }

  static Future<void> setShowVideosEnabled(bool value) async {
    await _storage.write(key: _showVideosKey, value: value ? 'true' : 'false');
  }
}
