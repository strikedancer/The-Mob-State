import '../l10n/app_localizations.dart';
import '../models/crime.dart';

/// Localized crime titles and descriptions (API may send English fallbacks).
class CrimeLocalization {
  CrimeLocalization._();

  static String name(Crime crime, AppLocalizations l10n) {
    switch (crime.id) {
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
      case 'steal_yacht':
        return l10n.crimeStealYachtName;
      case 'corrupt_official':
        return l10n.crimeCorruptOfficialName;
      case 'eliminate_witness':
        return l10n.crimeEliminateWitnessName;
      case 'diamond_heist':
        return l10n.crimeDiamondHeistName;
      case 'evidence_room_heist':
        return l10n.crimeEvidenceRoomHeistName;
      case 'museum_heist':
        return l10n.crimeMuseumHeistName;
      case 'boss_assassination':
        return l10n.crimeBossAssassinationName;
      case 'criminal_record_wipe':
        return l10n.crimeCriminalRecordWipeName;
      default:
        return crime.name;
    }
  }

  static String description(Crime crime, AppLocalizations l10n) {
    switch (crime.id) {
      case 'pickpocket':
        return l10n.crimePickpocketDesc;
      case 'shoplift':
        return l10n.crimeShopliftDesc;
      case 'steal_bike':
        return l10n.crimeStealBikeDesc;
      case 'car_theft':
        return l10n.crimeCarTheftDesc;
      case 'burglary':
        return l10n.crimeBurglaryDesc;
      case 'rob_store':
        return l10n.crimeRobStoreDesc;
      case 'mug_person':
        return l10n.crimeMugPersonDesc;
      case 'steal_car_parts':
        return l10n.crimeStealCarPartsDesc;
      case 'hijack_truck':
        return l10n.crimeHijackTruckDesc;
      case 'atm_theft':
        return l10n.crimeAtmTheftDesc;
      case 'jewelry_heist':
        return l10n.crimeJewelryHeistDesc;
      case 'vandalism':
        return l10n.crimeVandalismDesc;
      case 'graffiti':
        return l10n.crimeGraffitiDesc;
      case 'drug_deal_small':
        return l10n.crimeDrugDealSmallDesc;
      case 'drug_deal_large':
        return l10n.crimeDrugDealLargeDesc;
      case 'extortion':
        return l10n.crimeExtortionDesc;
      case 'kidnapping':
        return l10n.crimeKidnappingDesc;
      case 'arson':
        return l10n.crimeArsonDesc;
      case 'smuggling':
        return l10n.crimeSmugglingDesc;
      case 'assassination':
        return l10n.crimeAssassinationDesc;
      case 'hack_account':
        return l10n.crimeHackAccountDesc;
      case 'counterfeit_money':
        return l10n.crimeCounterfeitMoneyDesc;
      case 'identity_theft':
        return l10n.crimeIdentityTheftDesc;
      case 'rob_armored_truck':
        return l10n.crimeRobArmoredTruckDesc;
      case 'art_theft':
        return l10n.crimeArtTheftDesc;
      case 'protection_racket':
        return l10n.crimeProtectionRacketDesc;
      case 'casino_heist':
        return l10n.crimeCasinoHeistDesc;
      case 'bank_robbery':
        return l10n.crimeBankRobberyDesc;
      case 'steal_yacht':
        return l10n.crimeStealYachtDesc;
      case 'corrupt_official':
        return l10n.crimeCorruptOfficialDesc;
      case 'eliminate_witness':
        return l10n.crimeEliminateWitnessDesc;
      case 'diamond_heist':
        return l10n.crimeDiamondHeistDesc;
      case 'evidence_room_heist':
        return l10n.crimeEvidenceRoomHeistDesc;
      case 'museum_heist':
        return l10n.crimeMuseumHeistDesc;
      case 'boss_assassination':
        return l10n.crimeBossAssassinationDesc;
      case 'criminal_record_wipe':
        return l10n.crimeCriminalRecordWipeDesc;
      default:
        return crime.description ?? '';
    }
  }
}
