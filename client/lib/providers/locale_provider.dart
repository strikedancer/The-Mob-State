import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../config/app_config.dart';
import '../config/supported_languages.dart';

class LocaleProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _guestPrefsKey = 'guest_ui_language_code';

  Locale _locale = const Locale('nl'); // Default to Dutch

  Locale get locale => _locale;

  String _primary(String? code) =>
      (code ?? '').toLowerCase().trim().split(RegExp(r'[-_]')).first;

  /// Guest / marketing: restore saved choice, else browser/device language (no auth).
  Future<void> initGuestLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_guestPrefsKey);
      if (saved != null && SupportedLanguages.isSupportedCode(saved)) {
        _applyLocaleCode(saved);
        return;
      }
      final dispatcher = WidgetsBinding.instance.platformDispatcher;
      final code = SupportedLanguages.resolveFromDeviceLanguage(
        dispatcher.locale.languageCode,
        fallbackCode: 'en',
      );
      _applyLocaleCode(code);
    } catch (e) {
      // ignore: avoid_print
      print('[LocaleProvider] initGuestLocale error: $e');
    }
  }

  /// Persist guest UI language (footer on landing / legal pages). Does not call the server.
  Future<void> persistGuestLocale(String languageCode) async {
    if (!SupportedLanguages.isSupportedCode(languageCode)) return;
    final code = _primary(languageCode);
    _applyLocaleCode(code);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_guestPrefsKey, code);
    } catch (e) {
      // ignore: avoid_print
      print('[LocaleProvider] persistGuestLocale error: $e');
    }
  }

  void _applyLocaleCode(String code) {
    _locale = Locale(_primary(code));
    notifyListeners();
  }

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

        if (lang != null && SupportedLanguages.isSupportedCode(lang)) {
          _locale = Locale(_primary(lang));
          notifyListeners();
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('[LocaleProvider] Error loading locale: $e');
    }
  }

  /// Update the locale (when user changes language in settings)
  void setLocale(String languageCode) {
    if (SupportedLanguages.isSupportedCode(languageCode)) {
      _locale = Locale(_primary(languageCode));
      notifyListeners();
      // ignore: avoid_print
      print('[LocaleProvider] Set locale to: $_locale');
    }
  }

  /// Reset to default locale (on logout)
  void reset() {
    _locale = const Locale('nl');
    notifyListeners();
  }
}
