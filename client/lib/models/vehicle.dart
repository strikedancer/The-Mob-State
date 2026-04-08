import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class VehicleStats {
  final int? speed;
  final int? armor;
  final int? cargo;
  final int? stealth;

  VehicleStats({this.speed, this.armor, this.cargo, this.stealth});

  factory VehicleStats.fromJson(Map<String, dynamic> json) =>
      _$VehicleStatsFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleStatsToJson(this);
}

@JsonSerializable()
class VehicleDefinition {
  final String? id;
  final String? name;
  final String? type;
  final String? image;
  final String? imageNew;
  final String? imageDirty;
  final String? imageDamaged;
  final VehicleStats? stats;
  final String? description;
  final List<String>? availableInCountries;
  final int? baseValue;
  final Map<String, int>? marketValue;
  final int? fuelCapacity;
  final int? requiredRank;
  final String? vehicleCategory;
  final String? rarity;
  final int? maxGameAvailability;
  final int? currentWorldCount;
  final int? remainingWorldAvailability;

  VehicleDefinition({
    this.id,
    this.name,
    this.type,
    this.image,
    this.imageNew,
    this.imageDirty,
    this.imageDamaged,
    this.stats,
    this.description,
    this.availableInCountries,
    this.baseValue,
    this.marketValue,
    this.fuelCapacity,
    this.requiredRank,
    this.vehicleCategory,
    this.rarity,
    this.maxGameAvailability,
    this.currentWorldCount,
    this.remainingWorldAvailability,
  });

  factory VehicleDefinition.fromJson(Map<String, dynamic> json) =>
      _$VehicleDefinitionFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleDefinitionToJson(this);

  String? imageForCondition(int condition) {
    if (condition >= 100 && imageNew != null && imageNew!.isNotEmpty) {
      return imageNew;
    }

    if (condition >= 70 && imageDirty != null && imageDirty!.isNotEmpty) {
      return imageDirty;
    }

    if (condition < 70 && imageDamaged != null && imageDamaged!.isNotEmpty) {
      return imageDamaged;
    }

    return imageNew ?? imageDirty ?? imageDamaged ?? image;
  }
}

@JsonSerializable()
class VehicleInventoryItem {
  final int id;
  final int playerId;
  final String? vehicleType; // 'car', 'boat' or 'motorcycle'
  final String? vehicleId;
  final String? stolenInCountry;
  final String? currentLocation;
  final int condition;
  final int fuelLevel;
  final bool marketListing;
  final int? askingPrice;
  final VehicleDefinition? definition;
  final String? transportStatus; // NULL, 'shipping', 'flying', 'driving'
  final DateTime? transportArrivalTime;
  final String? transportDestination; // Destination during transport
  final bool repairInProgress;
  final String? repairStatus;
  final DateTime? repairStartedAt;
  final DateTime? repairCompletesAt;
  final int? repairCost;
  final int? repairTargetCondition;

  @JsonKey(name: 'stolenAt')
  final DateTime? createdAt;

  VehicleInventoryItem({
    required this.id,
    required this.playerId,
    this.vehicleType,
    this.vehicleId,
    this.stolenInCountry,
    this.currentLocation,
    required this.condition,
    required this.fuelLevel,
    required this.marketListing,
    this.askingPrice,
    this.definition,
    this.transportStatus,
    this.transportArrivalTime,
    this.transportDestination,
    this.repairInProgress = false,
    this.repairStatus,
    this.repairStartedAt,
    this.repairCompletesAt,
    this.repairCost,
    this.repairTargetCondition,
    this.createdAt,
  });

  factory VehicleInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$VehicleInventoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleInventoryItemToJson(this);

  // Calculate market value in current location
  int getMarketValue() {
    if (definition == null || currentLocation == null) return 0;
    final marketValue = definition?.marketValue;
    if (marketValue == null) return 0;
    final basePrice =
        marketValue[currentLocation] ?? (definition?.baseValue ?? 0);
    return (basePrice * (condition / 100)).floor();
  }

  // Get condition color (red/orange/green)
  String getConditionColor() {
    if (condition >= 75) return 'green';
    if (condition >= 40) return 'orange';
    return 'red';
  }

  // Get fuel level color
  String getFuelColor() {
    if (fuelLevel >= 50) return 'green';
    if (fuelLevel >= 20) return 'orange';
    return 'red';
  }

  // Check if vehicle can be driven/sailed (needs fuel)
  bool canDrive() {
    return fuelLevel >= 30 && condition >= 20;
  }

  String? get conditionImage => definition?.imageForCondition(condition);

  bool get isBusy => transportStatus != null || repairInProgress;
}

@JsonSerializable()
class GarageStatus {
  final int garageId;
  final int capacity;
  final int totalCapacity;
  final int currentUpgradeLevel;
  final int storedCount;
  final List<VehicleInventoryItem> storedVehicles;

  GarageStatus({
    required this.garageId,
    required this.capacity,
    required this.totalCapacity,
    required this.currentUpgradeLevel,
    required this.storedCount,
    required this.storedVehicles,
  });

  factory GarageStatus.fromJson(Map<String, dynamic> json) =>
      _$GarageStatusFromJson(json);
  Map<String, dynamic> toJson() => _$GarageStatusToJson(this);

  bool isFull() => storedCount >= totalCapacity;
  int getRemainingCapacity() => totalCapacity - storedCount;
  double getUsagePercentage() =>
      totalCapacity > 0 ? (storedCount / totalCapacity) * 100 : 0;
}

@JsonSerializable()
class MarinaStatus {
  final int marinaId;
  final int capacity;
  final int totalCapacity;
  final int currentUpgradeLevel;
  final int storedCount;
  final List<VehicleInventoryItem> storedBoats;

  MarinaStatus({
    required this.marinaId,
    required this.capacity,
    required this.totalCapacity,
    required this.currentUpgradeLevel,
    required this.storedCount,
    required this.storedBoats,
  });

  factory MarinaStatus.fromJson(Map<String, dynamic> json) =>
      _$MarinaStatusFromJson(json);
  Map<String, dynamic> toJson() => _$MarinaStatusToJson(this);

  bool isFull() => storedCount >= totalCapacity;
  int getRemainingCapacity() => totalCapacity - storedCount;
  double getUsagePercentage() =>
      totalCapacity > 0 ? (storedCount / totalCapacity) * 100 : 0;
}

@JsonSerializable()
class MarketListing {
  final int id;
  final VehicleInventoryItem vehicle;
  final String sellerUsername;
  final int sellerId;

  MarketListing({
    required this.id,
    required this.vehicle,
    required this.sellerUsername,
    required this.sellerId,
  });

  factory MarketListing.fromJson(Map<String, dynamic> json) =>
      _$MarketListingFromJson(json);
  Map<String, dynamic> toJson() => _$MarketListingToJson(this);
}
