import '../l10n/app_localizations.dart';

/// Utility class for country-related helper functions
class CountryHelper {
  /// Country IDs a private aircraft can fly to (`backend/content/countries.json`).
  static const List<String> aviationDestinations = [
    'netherlands',
    'belgium',
    'germany',
    'france',
    'spain',
    'italy',
    'uk',
    'switzerland',
    'usa',
    'mexico',
    'colombia',
    'brazil',
    'argentina',
    'japan',
    'china',
    'russia',
    'turkey',
    'united_arab_emirates',
    'south_africa',
    'australia',
  ];

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

  /// ISO 3166-1 alpha-2 → internal slug used by [getLocalizedCountryName].
  static const Map<String, String> _iso2ToSlug = {
    'NL': 'netherlands',
    'BE': 'belgium',
    'DE': 'germany',
    'FR': 'france',
    'ES': 'spain',
    'IT': 'italy',
    'PT': 'portugal',
    'GB': 'uk',
    'UK': 'uk',
    'IE': 'ireland',
    'LU': 'luxembourg',
    'CH': 'switzerland',
    'AT': 'austria',
    'DK': 'denmark',
    'SE': 'sweden',
    'NO': 'norway',
    'FI': 'finland',
    'PL': 'poland',
    'CZ': 'czechia',
    'GR': 'greece',
    'TR': 'turkey',
    'AE': 'uae',
    'US': 'usa',
    'MX': 'mexico',
    'CO': 'colombia',
    'BR': 'brazil',
    'AR': 'argentina',
    'JP': 'japan',
    'CN': 'china',
    'RU': 'russia',
    'ZA': 'south_africa',
    'AU': 'australia',
    'CA': 'canada',
    'IN': 'india',
  };

  static String getCountryFlag(String? countryId, {String fallback = '🏳️'}) {
    final id = (countryId ?? '').trim().toLowerCase();
    if (id.isEmpty) return fallback;
    return _countryFlags[id] ?? fallback;
  }

  /// Normalizes API values: ISO2 (NL, de), lowercase slug (netherlands), or [normalizeCountryId].
  static String normalizeCountryId(String? raw) {
    final t = (raw ?? '').trim();
    if (t.isEmpty) return '';
    if (t.length == 2) {
      final slug = _iso2ToSlug[t.toUpperCase()];
      if (slug != null) return slug;
      return t.toLowerCase();
    }
    return t.toLowerCase();
  }

  /// Returns the localized country name based on the country ID
  ///
  /// [countryId] - Slug (e.g. [netherlands]), ISO2 (e.g. NL), or legacy id.
  /// [l10n] - The app localizations instance for translations
  /// [fallbackName] - Optional fallback name if country is not found
  static String getLocalizedCountryName(
    String? countryId,
    AppLocalizations l10n, {
    String? fallbackName,
  }) {
    final id = normalizeCountryId(countryId);

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
      case 'portugal':
        return l10n.countryPortugal;
      case 'uk':
      case 'united_kingdom':
        return l10n.countryUk;
      case 'ireland':
        return l10n.countryIreland;
      case 'luxembourg':
        return l10n.countryLuxembourg;
      case 'switzerland':
        return l10n.countrySwitzerland;
      case 'austria':
        return l10n.countryAustria;
      case 'denmark':
        return l10n.countryDenmark;
      case 'sweden':
        return l10n.countrySweden;
      case 'norway':
        return l10n.countryNorway;
      case 'finland':
        return l10n.countryFinland;
      case 'poland':
        return l10n.countryPoland;
      case 'czechia':
        return l10n.countryCzechia;
      case 'greece':
        return l10n.countryGreece;
      case 'turkey':
        return l10n.countryTurkey;
      case 'uae':
      case 'united_arab_emirates':
        return l10n.countryUae;
      case 'dubai':
        return l10n.countryDubai;
      case 'usa':
      case 'united_states':
        return l10n.countryUsa;
      case 'mexico':
        return l10n.countryMexico;
      case 'colombia':
        return l10n.countryColombia;
      case 'brazil':
        return l10n.countryBrazil;
      case 'argentina':
        return l10n.countryArgentina;
      case 'japan':
        return l10n.countryJapan;
      case 'china':
        return l10n.countryChina;
      case 'russia':
        return l10n.countryRussia;
      case 'india':
        return l10n.countryIndia;
      case 'south_africa':
        return l10n.countrySouthAfrica;
      case 'australia':
        return l10n.countryAustralia;
      case 'canada':
        return l10n.countryCanada;
      default:
        return fallbackName ?? countryId?.trim() ?? '-';
    }
  }
}
