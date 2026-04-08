// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crime_tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrimeTool _$CrimeToolFromJson(Map<String, dynamic> json) => CrimeTool(
  id: json['id'] as String,
  name: json['name'] as String,
  type: json['type'] as String,
  basePrice: (json['basePrice'] as num).toInt(),
  maxDurability: (json['maxDurability'] as num).toInt(),
  loseChance: (json['loseChance'] as num).toDouble(),
  wearPerUse: (json['wearPerUse'] as num).toInt(),
  requiredFor: (json['requiredFor'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CrimeToolToJson(CrimeTool instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'type': instance.type,
  'basePrice': instance.basePrice,
  'maxDurability': instance.maxDurability,
  'loseChance': instance.loseChance,
  'wearPerUse': instance.wearPerUse,
  'requiredFor': instance.requiredFor,
};
