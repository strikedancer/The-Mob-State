import '../l10n/app_localizations.dart';

/// Localized title/short line for a [template] from `/game-events/*` (preset keys
/// in ARB; other templates fall back to API [titleEn]/[shortDescriptionEn]).
String localizedGameEventTitle(
  AppLocalizations l10n,
  Map<String, dynamic>? template,
) {
  if (template == null) {
    return l10n.gameEventDefaultTitle;
  }
  final key = template['key']?.toString();
  if (key != null) {
    switch (key) {
      case 'weekly_vehicle_theft_hunt':
        return l10n.gameEventTmplWeeklyVehicleTheftHuntTitle;
      case 'smuggling_surge':
        return l10n.gameEventTmplSmugglingSurgeTitle;
      case 'lab_output_challenge':
        return l10n.gameEventTmplLabOutputChallengeTitle;
      case 'street_crime_spree':
        return l10n.gameEventTmplStreetCrimeSpreeTitle;
      case 'contraband_rush':
        return l10n.gameEventTmplContrabandRushTitle;
      default:
        break;
    }
  }
  final en = template['titleEn']?.toString().trim() ?? '';
  if (en.isNotEmpty) {
    return en;
  }
  final fromKey = template['key']?.toString();
  if (fromKey != null && fromKey.isNotEmpty) {
    return fromKey;
  }
  return l10n.gameEventDefaultTitle;
}

String localizedGameEventShortDescription(
  AppLocalizations l10n,
  Map<String, dynamic>? template,
) {
  if (template == null) {
    return '';
  }
  final key = template['key']?.toString();
  if (key != null) {
    switch (key) {
      case 'weekly_vehicle_theft_hunt':
        return l10n.gameEventTmplWeeklyVehicleTheftHuntDesc;
      case 'smuggling_surge':
        return l10n.gameEventTmplSmugglingSurgeDesc;
      case 'lab_output_challenge':
        return l10n.gameEventTmplLabOutputChallengeDesc;
      case 'street_crime_spree':
        return l10n.gameEventTmplStreetCrimeSpreeDesc;
      case 'contraband_rush':
        return l10n.gameEventTmplContrabandRushDesc;
      default:
        break;
    }
  }
  final en = template['shortDescriptionEn']?.toString().trim() ?? '';
  if (en.isNotEmpty) {
    return en;
  }
  return '';
}

String localizedGameEventLiveStatus(AppLocalizations l10n, String? raw) {
  switch ((raw ?? '').toLowerCase().trim()) {
    case 'active':
      return l10n.gameEventStatusActive;
    case 'scheduled':
      return l10n.gameEventStatusScheduled;
    case 'completed':
      return l10n.gameEventStatusCompleted;
    case 'draft':
      return l10n.gameEventStatusDraft;
    default:
      if (raw == null || raw.isEmpty) {
        return l10n.gameScreenDash;
      }
      return raw;
  }
}
