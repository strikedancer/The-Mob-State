// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Crew _$CrewFromJson(Map<String, dynamic> json) => Crew(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  bankBalance: (json['bankBalance'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  hqStyle: json['hqStyle'] as String?,
  hqLevel: (json['hqLevel'] as num?)?.toInt(),
  isVip: json['isVip'] as bool? ?? false,
  vipExpiresAt: json['vipExpiresAt'] as String?,
  members: (json['members'] as List<dynamic>)
      .map((e) => CrewMember.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CrewToJson(Crew instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'bankBalance': instance.bankBalance,
  'createdAt': instance.createdAt,
  'hqStyle': instance.hqStyle,
  'hqLevel': instance.hqLevel,
  'isVip': instance.isVip,
  'vipExpiresAt': instance.vipExpiresAt,
  'members': instance.members,
};
