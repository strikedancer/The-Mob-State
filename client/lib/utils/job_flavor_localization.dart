import '../l10n/app_localizations.dart';

/// Resolves backend [flavorKey] values to localized player copy.
String? jobFlavorText(AppLocalizations l10n, String? flavorKey) {
  if (flavorKey == null || flavorKey.isEmpty) return null;
  switch (flavorKey) {
    case 'jobFlavorRegularShift':
      return l10n.jobFlavorRegularShift;
    case 'jobFlavorOvertimeShift':
      return l10n.jobFlavorOvertimeShift;
    case 'jobFlavorCashTip':
      return l10n.jobFlavorCashTip;
    case 'jobFlavorBigClient':
      return l10n.jobFlavorBigClient;
    case 'jobFlavorUnderCounterTip':
      return l10n.jobFlavorUnderCounterTip;
    case 'jobFlavorTaxiNightFare':
      return l10n.jobFlavorTaxiNightFare;
    case 'jobFlavorSecuritySideGig':
      return l10n.jobFlavorSecuritySideGig;
    case 'jobFlavorWarehouseFind':
      return l10n.jobFlavorWarehouseFind;
    case 'jobFlavorIntelPickup':
      return l10n.jobFlavorIntelPickup;
    case 'jobFlavorClientStiffed':
      return l10n.jobFlavorClientStiffed;
    case 'jobFlavorBossCaughtSlacking':
      return l10n.jobFlavorBossCaughtSlacking;
    case 'jobFlavorRegisterShort':
      return l10n.jobFlavorRegisterShort;
    case 'jobFlavorEquipmentFailure':
      return l10n.jobFlavorEquipmentFailure;
    case 'jobFlavorShiftCutShort':
      return l10n.jobFlavorShiftCutShort;
    default:
      return null;
  }
}
