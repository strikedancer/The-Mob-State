import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  // Use 10.0.2.2 for Android emulator to access localhost on host machine
  static String get apiBaseUrl {
    if (kIsWeb) {
      const webApiOverride = String.fromEnvironment('WEB_API_BASE_URL');
      if (webApiOverride.isNotEmpty) {
        return webApiOverride;
      }
      final base = Uri.base;
      return '${base.scheme}://${base.host}:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000'; // iOS simulator
    }
  }
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String defaultLocale = 'nl';
}
