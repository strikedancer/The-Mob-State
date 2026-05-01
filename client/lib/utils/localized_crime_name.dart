import '../l10n/app_localizations.dart';

/// Localized display title for a backend crime id (`snake_case`, e.g. `car_theft`).
/// Falls back to [crimeIdRaw] trimmed if the id is unknown.
String localizedCrimeName(AppLocalizations l10n, String crimeIdRaw) {
  final id = crimeIdRaw.trim().toLowerCase();
  switch (id) {
    case 'pickpocket':
      return l10n.crimePickpocketName;
    case 'shoplift':
      return l10n.crimeShopliftName;
    case 'steal_bike':
      return l10n.crimeStealBikeName;
    case 'car_theft':
      return l10n.crimeCarTheftName;
    case 'burglary':
      return l10n.crimeBurglaryName;
    case 'rob_store':
      return l10n.crimeRobStoreName;
    case 'mug_person':
      return l10n.crimeMugPersonName;
    case 'steal_car_parts':
      return l10n.crimeStealCarPartsName;
    case 'hijack_truck':
      return l10n.crimeHijackTruckName;
    case 'atm_theft':
      return l10n.crimeAtmTheftName;
    case 'jewelry_heist':
      return l10n.crimeJewelryHeistName;
    case 'vandalism':
      return l10n.crimeVandalismName;
    case 'graffiti':
      return l10n.crimeGraffitiName;
    case 'drug_deal_small':
      return l10n.crimeDrugDealSmallName;
    case 'drug_deal_large':
      return l10n.crimeDrugDealLargeName;
    case 'extortion':
      return l10n.crimeExtortionName;
    case 'kidnapping':
      return l10n.crimeKidnappingName;
    case 'arson':
      return l10n.crimeArsonName;
    case 'smuggling':
      return l10n.crimeSmugglingName;
    case 'assassination':
      return l10n.crimeAssassinationName;
    case 'eliminate_witness':
      return l10n.crimeEliminateWitnessName;
    case 'diamond_heist':
      return l10n.crimeDiamondHeistName;
    case 'evidence_room_heist':
      return l10n.crimeEvidenceRoomHeistName;
    case 'hack_account':
      return l10n.crimeHackAccountName;
    case 'counterfeit_money':
      return l10n.crimeCounterfeitMoneyName;
    case 'identity_theft':
      return l10n.crimeIdentityTheftName;
    case 'rob_armored_truck':
      return l10n.crimeRobArmoredTruckName;
    case 'art_theft':
      return l10n.crimeArtTheftName;
    case 'protection_racket':
      return l10n.crimeProtectionRacketName;
    case 'casino_heist':
      return l10n.crimeCasinoHeistName;
    case 'bank_robbery':
      return l10n.crimeBankRobberyName;
    case 'museum_heist':
      return l10n.crimeMuseumHeistName;
    case 'boss_assassination':
      return l10n.crimeBossAssassinationName;
    case 'steal_yacht':
      return l10n.crimeStealYachtName;
    case 'corrupt_official':
      return l10n.crimeCorruptOfficialName;
    case 'criminal_record_wipe':
      return l10n.crimeCriminalRecordWipeName;
    default:
      return crimeIdRaw.trim();
  }
}
