// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleStats _$VehicleStatsFromJson(Map<String, dynamic> json) => VehicleStats(
  speed: (json['speed'] as num?)?.toInt(),
  armor: (json['armor'] as num?)?.toInt(),
  cargo: (json['cargo'] as num?)?.toInt(),
  stealth: (json['stealth'] as num?)?.toInt(),
);

Map<String, dynamic> _$VehicleStatsToJson(VehicleStats instance) =>
    <String, dynamic>{
      'speed': instance.speed,
      'armor': instance.armor,
      'cargo': instance.cargo,
      'stealth': instance.stealth,
    };

VehicleDefinition _$VehicleDefinitionFromJson(Map<String, dynamic> json) =>
    VehicleDefinition(
      id: json['id'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      image: json['image'] as String?,
      imageNew: json['imageNew'] as String?,
      imageDirty: json['imageDirty'] as String?,
      imageDamaged: json['imageDamaged'] as String?,
      stats: json['stats'] == null
          ? null
          : VehicleStats.fromJson(json['stats'] as Map<String, dynamic>),
      description: json['description'] as String?,
      availableInCountries: (json['availableInCountries'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      baseValue: (json['baseValue'] as num?)?.toInt(),
      marketValue: (json['marketValue'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      fuelCapacity: (json['fuelCapacity'] as num?)?.toInt(),
      requiredRank: (json['requiredRank'] as num?)?.toInt(),
      vehicleCategory: json['vehicleCategory'] as String?,
      rarity: json['rarity'] as String?,
      maxGameAvailability: (json['maxGameAvailability'] as num?)?.toInt(),
      currentWorldCount: (json['currentWorldCount'] as num?)?.toInt(),
      remainingWorldAvailability: (json['remainingWorldAvailability'] as num?)
          ?.toInt(),
    );

Map<String, dynamic> _$VehicleDefinitionToJson(VehicleDefinition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'image': instance.image,
      'imageNew': instance.imageNew,
      'imageDirty': instance.imageDirty,
      'imageDamaged': instance.imageDamaged,
      'stats': instance.stats,
      'description': instance.description,
      'availableInCountries': instance.availableInCountries,
      'baseValue': instance.baseValue,
      'marketValue': instance.marketValue,
      'fuelCapacity': instance.fuelCapacity,
      'requiredRank': instance.requiredRank,
      'vehicleCategory': instance.vehicleCategory,
      'rarity': instance.rarity,
      'maxGameAvailability': instance.maxGameAvailability,
      'currentWorldCount': instance.currentWorldCount,
      'remainingWorldAvailability': instance.remainingWorldAvailability,
    };

VehicleInventoryItem _$VehicleInventoryItemFromJson(
  Map<String, dynamic> json,
) => VehicleInventoryItem(
  id: (json['id'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  vehicleType: json['vehicleType'] as String?,
  vehicleId: json['vehicleId'] as String?,
  stolenInCountry: json['stolenInCountry'] as String?,
  currentLocation: json['currentLocation'] as String?,
  condition: (json['condition'] as num).toInt(),
  fuelLevel: (json['fuelLevel'] as num).toInt(),
  marketListing: json['marketListing'] as bool,
  askingPrice: (json['askingPrice'] as num?)?.toInt(),
  definition: json['definition'] == null
      ? null
      : VehicleDefinition.fromJson(json['definition'] as Map<String, dynamic>),
  transportStatus: json['transportStatus'] as String?,
  transportArrivalTime: json['transportArrivalTime'] == null
      ? null
      : DateTime.parse(json['transportArrivalTime'] as String),
  transportDestination: json['transportDestination'] as String?,
  repairInProgress: json['repairInProgress'] as bool? ?? false,
  repairStatus: json['repairStatus'] as String?,
  repairStartedAt: json['repairStartedAt'] == null
      ? null
      : DateTime.parse(json['repairStartedAt'] as String),
  repairCompletesAt: json['repairCompletesAt'] == null
      ? null
      : DateTime.parse(json['repairCompletesAt'] as String),
  repairCost: (json['repairCost'] as num?)?.toInt(),
  repairTargetCondition: (json['repairTargetCondition'] as num?)?.toInt(),
  createdAt: json['stolenAt'] == null
      ? null
      : DateTime.parse(json['stolenAt'] as String),
);

Map<String, dynamic> _$VehicleInventoryItemToJson(
  VehicleInventoryItem instance,
) => <String, dynamic>{
  'id': instance.id,
  'playerId': instance.playerId,
  'vehicleType': instance.vehicleType,
  'vehicleId': instance.vehicleId,
  'stolenInCountry': instance.stolenInCountry,
  'currentLocation': instance.currentLocation,
  'condition': instance.condition,
  'fuelLevel': instance.fuelLevel,
  'marketListing': instance.marketListing,
  'askingPrice': instance.askingPrice,
  'definition': instance.definition,
  'transportStatus': instance.transportStatus,
  'transportArrivalTime': instance.transportArrivalTime?.toIso8601String(),
  'transportDestination': instance.transportDestination,
  'repairInProgress': instance.repairInProgress,
  'repairStatus': instance.repairStatus,
  'repairStartedAt': instance.repairStartedAt?.toIso8601String(),
  'repairCompletesAt': instance.repairCompletesAt?.toIso8601String(),
  'repairCost': instance.repairCost,
  'repairTargetCondition': instance.repairTargetCondition,
  'stolenAt': instance.createdAt?.toIso8601String(),
};

GarageStatus _$GarageStatusFromJson(Map<String, dynamic> json) => GarageStatus(
  garageId: (json['garageId'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
  totalCapacity: (json['totalCapacity'] as num).toInt(),
  currentUpgradeLevel: (json['currentUpgradeLevel'] as num).toInt(),
  storedCount: (json['storedCount'] as num).toInt(),
  storedVehicles: (json['storedVehicles'] as List<dynamic>)
      .map((e) => VehicleInventoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GarageStatusToJson(GarageStatus instance) =>
    <String, dynamic>{
      'garageId': instance.garageId,
      'capacity': instance.capacity,
      'totalCapacity': instance.totalCapacity,
      'currentUpgradeLevel': instance.currentUpgradeLevel,
      'storedCount': instance.storedCount,
      'storedVehicles': instance.storedVehicles,
    };

MarinaStatus _$MarinaStatusFromJson(Map<String, dynamic> json) => MarinaStatus(
  marinaId: (json['marinaId'] as num).toInt(),
  capacity: (json['capacity'] as num).toInt(),
  totalCapacity: (json['totalCapacity'] as num).toInt(),
  currentUpgradeLevel: (json['currentUpgradeLevel'] as num).toInt(),
  storedCount: (json['storedCount'] as num).toInt(),
  storedBoats: (json['storedBoats'] as List<dynamic>)
      .map((e) => VehicleInventoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MarinaStatusToJson(MarinaStatus instance) =>
    <String, dynamic>{
      'marinaId': instance.marinaId,
      'capacity': instance.capacity,
      'totalCapacity': instance.totalCapacity,
      'currentUpgradeLevel': instance.currentUpgradeLevel,
      'storedCount': instance.storedCount,
      'storedBoats': instance.storedBoats,
    };

MarketListing _$MarketListingFromJson(Map<String, dynamic> json) =>
    MarketListing(
      id: (json['id'] as num).toInt(),
      vehicle: VehicleInventoryItem.fromJson(
        json['vehicle'] as Map<String, dynamic>,
      ),
      sellerUsername: json['sellerUsername'] as String,
      sellerId: (json['sellerId'] as num).toInt(),
    );

Map<String, dynamic> _$MarketListingToJson(MarketListing instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicle': instance.vehicle,
      'sellerUsername': instance.sellerUsername,
      'sellerId': instance.sellerId,
    };
