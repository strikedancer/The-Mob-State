// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  money: (json['money'] as num).toInt(),
  health: (json['health'] as num).toInt(),
  rank: (json['rank'] as num).toInt(),
  xp: (json['xp'] as num).toInt(),
  wantedLevel: (json['wantedLevel'] as num?)?.toInt(),
  fbiHeat: (json['fbiHeat'] as num?)?.toInt(),
  currentCountry: json['currentCountry'] as String?,
  avatar: json['avatar'] as String?,
  isVip: json['isVip'] as bool?,
  preferredLanguage: json['preferredLanguage'] as String?,
  wealthStatus: json['wealthStatus'] as String?,
  wealthIcon: json['wealthIcon'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  lastTickAt: json['lastTickAt'] == null
      ? null
      : DateTime.parse(json['lastTickAt'] as String),
);

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'money': instance.money,
  'health': instance.health,
  'rank': instance.rank,
  'xp': instance.xp,
  'wantedLevel': instance.wantedLevel,
  'fbiHeat': instance.fbiHeat,
  'currentCountry': instance.currentCountry,
  'avatar': instance.avatar,
  'isVip': instance.isVip,
  'preferredLanguage': instance.preferredLanguage,
  'wealthStatus': instance.wealthStatus,
  'wealthIcon': instance.wealthIcon,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'lastTickAt': instance.lastTickAt?.toIso8601String(),
};
