import 'package:flutter/material.dart';

/// Player-facing UI languages (base BCP-47 codes). Must match:
/// - ARB files: `app_<code>.arb` in lib/l10n/
/// - [backend/src/config/supportedLanguages.ts](../../../../backend/src/config/supportedLanguages.ts)
class SupportedLanguages {
  SupportedLanguages._();

  /// Order: default market first, then English, then other European locales (expand with care).
  static const List<String> codes = [
    'nl',
    'en',
    'de',
    'fr',
    'es',
    'it',
    'pl',
    'pt',
  ];

  static final Set<String> _codeSet = codes.toSet();

  static const Map<String, String> flagEmoji = {
    'nl': '🇳🇱',
    'en': '🇬🇧',
    'de': '🇩🇪',
    'fr': '🇫🇷',
    'es': '🇪🇸',
    'it': '🇮🇹',
    'pl': '🇵🇱',
    'pt': '🇵🇹',
  };

  /// Autonym (native) display names for language pickers.
  static const Map<String, String> nativeLabels = {
    'nl': 'Nederlands',
    'en': 'English',
    'de': 'Deutsch',
    'fr': 'Français',
    'es': 'Español',
    'it': 'Italiano',
    'pl': 'Polski',
    'pt': 'Português',
  };

  static bool isSupportedCode(String? code) {
    if (code == null || code.isEmpty) return false;
    final primary = code.toLowerCase().trim().split(RegExp(r'[-_]')).first;
    return _codeSet.contains(primary);
  }

  /// Map device / browser locale to a supported code (fallback [fallbackCode]).
  static String resolveFromDeviceLanguage(String? languageCode, {String fallbackCode = 'en'}) {
    if (languageCode == null || languageCode.isEmpty) return fallbackCode;
    final primary = languageCode.toLowerCase().split(RegExp(r'[-_]')).first;
    if (_codeSet.contains(primary)) return primary;
    return fallbackCode;
  }

  static String labelFor(String code) {
    final p = code.toLowerCase().split(RegExp(r'[-_]')).first;
    return nativeLabels[p] ?? p.toUpperCase();
  }

  static String? flagFor(String code) {
    final p = code.toLowerCase().split(RegExp(r'[-_]')).first;
    return flagEmoji[p];
  }

  static String menuSubtitle(String code) {
    final f = flagFor(code) ?? '🌐';
    return '$f ${labelFor(code)}';
  }

  static List<Locale> get materialLocales =>
      codes.map((c) => Locale(c)).toList(growable: false);
}
