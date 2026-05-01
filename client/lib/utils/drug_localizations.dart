import '../l10n/app_localizations.dart';

/// Localized country label for drug pricing keys (matches [DrugDefinition] country ids).
String drugCountryDisplayName(AppLocalizations t, String countryId) {
  switch (countryId) {
    case 'netherlands':
      return t.countryNetherlands;
    case 'belgium':
      return t.countryBelgium;
    case 'germany':
      return t.countryGermany;
    case 'spain':
      return t.countrySpain;
    case 'france':
      return t.countryFrance;
    case 'uk':
    case 'united_kingdom':
      return t.countryUk;
    case 'italy':
      return t.countryItaly;
    case 'usa':
      return t.countryUsa;
    case 'mexico':
      return t.countryMexico;
    case 'colombia':
      return t.countryColombia;
    case 'brazil':
      return t.countryBrazil;
    case 'argentina':
      return t.countryArgentina;
    case 'japan':
      return t.countryJapan;
    case 'china':
      return t.countryChina;
    case 'russia':
      return t.countryRussia;
    case 'turkey':
      return t.countryTurkey;
    case 'united_arab_emirates':
      return t.countryUae;
    case 'south_africa':
      return t.countrySouthAfrica;
    case 'australia':
      return t.countryAustralia;
    case 'switzerland':
      return t.countrySwitzerland;
    default:
      return countryId;
  }
}

/// Maps API / fallback heat level strings to ARB labels.
String drugHeatLevelLabel(AppLocalizations t, String raw) {
  final s = raw.trim().toLowerCase();
  if (s == 'low' || s == 'laag') return t.drugsHeatLevelLow;
  if (s == 'medium' || s == 'gemiddeld') return t.drugsHeatLevelMedium;
  if (s == 'high' || s == 'hoog') return t.drugsHeatLevelHigh;
  if (s == 'critical' || s == 'kritiek') return t.drugsHeatLevelCritical;
  return raw;
}

/// Maps client [DrugService] English/Dutch fallback messages to the user locale.
String localizeDrugClientMessage(AppLocalizations t, String message) {
  if (message == 'Failed to buy material') return t.drugsApiFailedBuyMaterial;
  if (message == 'Failed to start production') {
    return t.drugsApiFailedStartProduction;
  }
  if (message == 'Failed to collect production') {
    return t.drugsApiFailedCollect;
  }
  if (message == 'Failed to sell drugs') return t.drugsApiFailedSell;
  if (message == 'Failed to cut drugs') return t.drugsApiFailedCut;
  if (message == 'Failed to send shipment') return t.drugsApiFailedShipment;
  if (message == 'Failed to claim depot shipments') {
    return t.drugsApiFailedClaim;
  }
  if (message == 'Failed' || message == 'Fout') {
    return t.drugsServiceErrorGeneric;
  }
  if (message.startsWith('Error:')) {
    final rest = message.substring(6).trim();
    return '${t.drugsServiceErrorGeneric}: $rest';
  }
  return message;
}

String formatDrugDuration(AppLocalizations t, int minutes) {
  if (minutes < 60) {
    return t.drugsFmtMinutes('$minutes');
  }
  final hours = minutes ~/ 60;
  final mins = minutes % 60;
  final hStr = '$hours';
  if (mins == 0) return t.drugsFmtHoursOnly(hStr);
  return t.drugsFmtHoursMinutes(hStr, '$mins');
}
