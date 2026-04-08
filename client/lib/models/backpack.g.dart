// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backpack.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Backpack _$BackpackFromJson(Map<String, dynamic> json) => Backpack(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  type: json['type'] as String,
  slots: (json['slots'] as num).toInt(),
  price: (json['price'] as num).toInt(),
  requiredRank: (json['requiredRank'] as num).toInt(),
  vipOnly: json['vipOnly'] as bool,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$BackpackToJson(Backpack instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'type': instance.type,
  'slots': instance.slots,
  'price': instance.price,
  'requiredRank': instance.requiredRank,
  'vipOnly': instance.vipOnly,
  'icon': instance.icon,
};

PlayerBackpack _$PlayerBackpackFromJson(Map<String, dynamic> json) =>
    PlayerBackpack(
      id: (json['id'] as num).toInt(),
      playerId: (json['playerId'] as num).toInt(),
      backpackId: json['backpackId'] as String,
      purchasedAt: DateTime.parse(json['purchasedAt'] as String),
      backpack: json['backpack'] == null
          ? null
          : Backpack.fromJson(json['backpack'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlayerBackpackToJson(PlayerBackpack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'backpackId': instance.backpackId,
      'purchasedAt': instance.purchasedAt.toIso8601String(),
      'backpack': instance.backpack,
    };

BackpackCapacity _$BackpackCapacityFromJson(Map<String, dynamic> json) =>
    BackpackCapacity(
      capacity: (json['capacity'] as num).toInt(),
      base: (json['base'] as num).toInt(),
      bonus: (json['bonus'] as num).toInt(),
    );

Map<String, dynamic> _$BackpackCapacityToJson(BackpackCapacity instance) =>
    <String, dynamic>{
      'capacity': instance.capacity,
      'base': instance.base,
      'bonus': instance.bonus,
    };

AvailableBackpacksResponse _$AvailableBackpacksResponseFromJson(
  Map<String, dynamic> json,
) => AvailableBackpacksResponse(
  owned: json['owned'] == null
      ? null
      : Backpack.fromJson(json['owned'] as Map<String, dynamic>),
  available: (json['available'] as List<dynamic>)
      .map((e) => Backpack.fromJson(e as Map<String, dynamic>))
      .toList(),
  canUpgradeTo: (json['canUpgradeTo'] as List<dynamic>)
      .map((e) => Backpack.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AvailableBackpacksResponseToJson(
  AvailableBackpacksResponse instance,
) => <String, dynamic>{
  'owned': instance.owned,
  'available': instance.available,
  'canUpgradeTo': instance.canUpgradeTo,
};
