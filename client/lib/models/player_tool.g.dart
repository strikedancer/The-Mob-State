// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerTool _$PlayerToolFromJson(Map<String, dynamic> json) => PlayerTool(
  id: (json['id'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  toolId: json['toolId'] as String,
  durability: (json['durability'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  name: json['name'] as String?,
  type: json['type'] as String?,
  basePrice: (json['basePrice'] as num?)?.toInt(),
  maxDurability: (json['maxDurability'] as num?)?.toInt(),
  loseChance: (json['loseChance'] as num?)?.toDouble(),
  wearPerUse: (json['wearPerUse'] as num?)?.toInt(),
  isBroken: json['isBroken'] as bool?,
  needsRepair: json['needsRepair'] as bool?,
);

Map<String, dynamic> _$PlayerToolToJson(PlayerTool instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'toolId': instance.toolId,
      'durability': instance.durability,
      'createdAt': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'type': instance.type,
      'basePrice': instance.basePrice,
      'maxDurability': instance.maxDurability,
      'loseChance': instance.loseChance,
      'wearPerUse': instance.wearPerUse,
      'isBroken': instance.isBroken,
      'needsRepair': instance.needsRepair,
    };
