// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  requiredRank: (json['minLevel'] as num).toInt(),
  minPay: (json['minEarnings'] as num).toInt(),
  maxPay: (json['maxEarnings'] as num).toInt(),
  xpReward: (json['xpReward'] as num).toInt(),
  cooldownMinutes: (json['cooldownMinutes'] as num?)?.toInt(),
  image: json['image'] as String?,
);

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'minLevel': instance.requiredRank,
  'minEarnings': instance.minPay,
  'maxEarnings': instance.maxPay,
  'xpReward': instance.xpReward,
  'cooldownMinutes': instance.cooldownMinutes,
  'image': instance.image,
};
