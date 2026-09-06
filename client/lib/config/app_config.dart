import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  // Use 10.0.2.2 for Android emulator to access localhost on host machine
  static String get apiBaseUrl {
    if (kIsWeb) {
      const webApiOverride = String.fromEnvironment('WEB_API_BASE_URL');
      if (webApiOverride.isNotEmpty) {
        return webApiOverride.trim().replaceAll(RegExp(r'/+$'), '');
      }
      final base = Uri.base;
      final host = base.host.toLowerCase();
      // Production site serves the Flutter shell from the apex domain; API lives on a
      // dedicated host (see client Dockerfile WEB_API_BASE_URL). Without a dart-define,
      // falling back to :3000 on the page host breaks public calls (e.g. landing rankings).
      if (host == 'themobstate.com' ||
          host == 'www.themobstate.com' ||
          host == 'themobstate.nl' ||
          host == 'www.themobstate.nl') {
        return '${base.scheme}://api.themobstate.com';
      }
      return '${base.scheme}://${base.host}:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000'; // iOS simulator
    }
  }
  
  static const Duration apiTimeout = Duration(seconds: 30);
  static const String defaultLocale = 'nl';

  static String get schoolImageBaseUrl {
    const raw = String.fromEnvironment('SCHOOL_IMAGE_BASE_URL');
    final trimmed = raw.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }

    if (kIsWeb) {
      final base = Uri.base;
      return '${base.scheme}://${base.host}/game-assets/school';
    }

    return '';
  }

  static String get drugFacilityImageBaseUrl {
    const raw = String.fromEnvironment('DRUG_FACILITY_IMAGE_BASE_URL');
    final trimmed = raw.trim();
    if (trimmed.isNotEmpty) {
      return trimmed;
    }

    if (kIsWeb) {
      final base = Uri.base;
      return '${base.scheme}://${base.host}/images/facilities';
    }

    return '';
  }
}
