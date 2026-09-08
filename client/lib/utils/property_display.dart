import '../l10n/app_localizations.dart';

const kPublicPropertyTypeOrder = [
  'house',
  'apartment',
  'warehouse',
  'nightclub',
  'casino',
  'car_showroom',
  'motorcycle_showroom',
  'boat_harbor',
];

String? propertyCatalogAssetPath(String? propertyType) {
  switch (propertyType) {
    case 'house':
    case 'apartment':
    case 'warehouse':
    case 'nightclub':
    case 'casino':
    case 'car_showroom':
    case 'motorcycle_showroom':
    case 'boat_harbor':
      return 'assets/images/properties/$propertyType.png';
    default:
      return null;
  }
}

String localizedPropertyName(AppLocalizations l10n, String? propertyType) {
  switch (propertyType) {
    case 'warehouse':
      return l10n.propertyWarehouseName;
    case 'nightclub':
      return l10n.propertyNightclubName;
    case 'house':
      return l10n.propertyHouseName;
    case 'apartment':
      return l10n.propertyApartmentName;
    case 'casino':
      return l10n.propertyCasinoName;
    case 'car_showroom':
      return l10n.propertyCarShowroomName;
    case 'motorcycle_showroom':
      return l10n.propertyMotorcycleShowroomName;
    case 'boat_harbor':
      return l10n.propertyBoatHarborName;
    case 'shop':
      return l10n.propertyShopName;
    default:
      return propertyType ?? l10n.unknown;
  }
}
