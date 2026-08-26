import '../l10n/app_localizations.dart';

/// Localized names/descriptions for contraband goods (server ids).
class TradeGoodL10n {
  TradeGoodL10n._();

  static String name(AppLocalizations l10n, String id) {
    switch (id) {
      case 'contraband_flowers':
        return l10n.contrabandFlowersName;
      case 'contraband_spices':
        return l10n.contrabandSpicesName;
      case 'contraband_tobacco':
        return l10n.contrabandTobaccoName;
      case 'contraband_coffee':
        return l10n.contrabandCoffeeName;
      case 'contraband_electronics':
        return l10n.contrabandElectronicsName;
      case 'contraband_fur_leather':
        return l10n.contrabandFurLeatherName;
      case 'contraband_perfume':
        return l10n.contrabandPerfumeName;
      case 'contraband_pharmaceuticals':
        return l10n.contrabandPharmaceuticalsName;
      case 'contraband_counterfeit_cash':
        return l10n.contrabandCounterfeitCashName;
      case 'contraband_spirits':
        return l10n.contrabandSpiritsName;
      case 'contraband_weapons':
        return l10n.contrabandWeaponsName;
      case 'contraband_rare_wine':
        return l10n.contrabandRareWineName;
      case 'contraband_luxury_watches':
        return l10n.contrabandLuxuryWatchesName;
      case 'contraband_art':
        return l10n.contrabandArtName;
      case 'contraband_diamonds':
        return l10n.contrabandDiamondsName;
      case 'contraband_gold':
        return l10n.contrabandGoldName;
      default:
        return id.replaceAll('contraband_', '').replaceAll('_', ' ');
    }
  }

  static String description(AppLocalizations l10n, String id) {
    switch (id) {
      case 'contraband_flowers':
        return l10n.contrabandFlowersDesc;
      case 'contraband_spices':
        return l10n.contrabandSpicesDesc;
      case 'contraband_tobacco':
        return l10n.contrabandTobaccoDesc;
      case 'contraband_coffee':
        return l10n.contrabandCoffeeDesc;
      case 'contraband_electronics':
        return l10n.contrabandElectronicsDesc;
      case 'contraband_fur_leather':
        return l10n.contrabandFurLeatherDesc;
      case 'contraband_perfume':
        return l10n.contrabandPerfumeDesc;
      case 'contraband_pharmaceuticals':
        return l10n.contrabandPharmaceuticalsDesc;
      case 'contraband_counterfeit_cash':
        return l10n.contrabandCounterfeitCashDesc;
      case 'contraband_spirits':
        return l10n.contrabandSpiritsDesc;
      case 'contraband_weapons':
        return l10n.contrabandWeaponsDesc;
      case 'contraband_rare_wine':
        return l10n.contrabandRareWineDesc;
      case 'contraband_luxury_watches':
        return l10n.contrabandLuxuryWatchesDesc;
      case 'contraband_art':
        return l10n.contrabandArtDesc;
      case 'contraband_diamonds':
        return l10n.contrabandDiamondsDesc;
      case 'contraband_gold':
        return l10n.contrabandGoldDesc;
      default:
        return '';
    }
  }

  static String categoryLabel(AppLocalizations l10n, String? category) {
    switch (category) {
      case 'starter':
        return l10n.tradeCategoryStarter;
      case 'bulk':
        return l10n.tradeCategoryBulk;
      case 'luxury':
        return l10n.tradeCategoryLuxury;
      case 'dangerous':
        return l10n.tradeCategoryDangerous;
      default:
        return l10n.tradeCategoryAll;
    }
  }
}
