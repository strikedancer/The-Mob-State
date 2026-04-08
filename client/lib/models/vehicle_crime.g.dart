// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_crime.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vehicle _$VehicleFromJson(Map<String, dynamic> json) => Vehicle(
  id: (json['id'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  vehicleType: json['vehicleType'] as String?,
  speed: (json['speed'] as num?)?.toInt(),
  armor: (json['armor'] as num?)?.toInt(),
  stealth: (json['stealth'] as num?)?.toInt(),
  cargo: (json['cargo'] as num?)?.toInt(),
  condition: (json['condition'] as num?)?.toDouble(),
  fuel: (json['fuel'] as num?)?.toInt(),
  maxFuel: (json['maxFuel'] as num?)?.toInt(),
  isBroken: json['isBroken'] as bool?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$VehicleToJson(Vehicle instance) => <String, dynamic>{
  'id': instance.id,
  'playerId': instance.playerId,
  'vehicleType': instance.vehicleType,
  'speed': instance.speed,
  'armor': instance.armor,
  'stealth': instance.stealth,
  'cargo': instance.cargo,
  'condition': instance.condition,
  'fuel': instance.fuel,
  'maxFuel': instance.maxFuel,
  'isBroken': instance.isBroken,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
