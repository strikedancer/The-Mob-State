import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/app_config.dart';

class LocaleProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  Locale _locale = const Locale('nl'); // Default to Dutch

  Locale get locale => _locale;

  /// Load the user's preferred language from the server
  Future<void> loadLocale() async {
    try {
      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        // Not logged in, use default
        return;
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/settings'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final lang = data['preferredLanguage'] as String?;
        
        if (lang != null && (lang == 'en' || lang == 'nl')) {
          _locale = Locale(lang);
          notifyListeners();
          print('[LocaleProvider] Loaded locale: $lang');
        }
      }
    } catch (e) {
      print('[LocaleProvider] Error loading locale: $e');
    }
  }

  /// Update the locale (when user changes language in settings)
  void setLocale(String languageCode) {
    if (languageCode == 'en' || languageCode == 'nl') {
      _locale = Locale(languageCode);
      notifyListeners();
      print('[LocaleProvider] Set locale to: $languageCode');
    }
  }

  /// Reset to default locale (on logout)
  void reset() {
    _locale = const Locale('nl');
    notifyListeners();
  }
}
