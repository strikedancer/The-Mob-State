import '../l10n/app_localizations.dart';

/// Utility class for country-related helper functions
class CountryHelper {
  static const Map<String, String> _countryFlags = {
    'netherlands': '🇳🇱',
    'belgium': '🇧🇪',
    'germany': '🇩🇪',
    'france': '🇫🇷',
    'spain': '🇪🇸',
    'italy': '🇮🇹',
    'uk': '🇬🇧',
    'united_kingdom': '🇬🇧',
    'switzerland': '🇨🇭',
    'usa': '🇺🇸',
    'united_states': '🇺🇸',
    'mexico': '🇲🇽',
    'colombia': '🇨🇴',
    'brazil': '🇧🇷',
    'argentina': '🇦🇷',
    'japan': '🇯🇵',
    'china': '🇨🇳',
    'russia': '🇷🇺',
    'turkey': '🇹🇷',
    'united_arab_emirates': '🇦🇪',
    'uae': '🇦🇪',
    'south_africa': '🇿🇦',
    'australia': '🇦🇺',
  };

  static String getCountryFlag(String? countryId, {String fallback = '🏳️'}) {
    final id = (countryId ?? '').trim().toLowerCase();
    if (id.isEmpty) return fallback;
    return _countryFlags[id] ?? fallback;
  }

  /// Returns the localized country name based on the country ID
  ///
  /// [countryId] - The country identifier (e.g., 'netherlands', 'belgium')
  /// [l10n] - The app localizations instance for translations
  /// [fallbackName] - Optional fallback name if country is not found
  static String getLocalizedCountryName(
    String? countryId,
    AppLocalizations l10n, {
    String? fallbackName,
  }) {
    final id = (countryId ?? '').toLowerCase();

    switch (id) {
      case 'netherlands':
        return l10n.countryNetherlands;
      case 'belgium':
        return l10n.countryBelgium;
      case 'germany':
        return l10n.countryGermany;
      case 'france':
        return l10n.countryFrance;
      case 'spain':
        return l10n.countrySpain;
      case 'italy':
        return l10n.countryItaly;
      case 'uk':
      case 'united_kingdom':
        return l10n.countryUk;
      case 'switzerland':
        return l10n.countrySwitzerland;
      case 'usa':
      case 'united_states':
        return fallbackName ?? 'Verenigde Staten';
      case 'mexico':
        return fallbackName ?? 'Mexico';
      case 'colombia':
        return fallbackName ?? 'Colombia';
      case 'brazil':
        return fallbackName ?? 'Brazilië';
      case 'argentina':
        return fallbackName ?? 'Argentinië';
      case 'japan':
        return fallbackName ?? 'Japan';
      case 'china':
        return fallbackName ?? 'China';
      case 'russia':
        return fallbackName ?? 'Rusland';
      case 'turkey':
        return fallbackName ?? 'Turkije';
      case 'united_arab_emirates':
      case 'uae':
        return fallbackName ?? 'Verenigde Arabische Emiraten';
      case 'south_africa':
        return fallbackName ?? 'Zuid-Afrika';
      case 'australia':
        return fallbackName ?? 'Australië';
      default:
        return fallbackName ?? countryId ?? '-';
    }
  }
}
