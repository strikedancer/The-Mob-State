// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewMember _$CrewMemberFromJson(Map<String, dynamic> json) => CrewMember(
  id: (json['id'] as num).toInt(),
  crewId: (json['crewId'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  role: json['role'] as String,
  trustScore: (json['trustScore'] as num).toInt(),
  joinedAt: json['joinedAt'] as String,
  playerInfo: json['player'] == null
      ? null
      : PlayerInfo.fromJson(json['player'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CrewMemberToJson(CrewMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crewId': instance.crewId,
      'playerId': instance.playerId,
      'role': instance.role,
      'trustScore': instance.trustScore,
      'joinedAt': instance.joinedAt,
      'player': instance.playerInfo,
    };

PlayerInfo _$PlayerInfoFromJson(Map<String, dynamic> json) => PlayerInfo(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  rank: (json['rank'] as num).toInt(),
);

Map<String, dynamic> _$PlayerInfoToJson(PlayerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'rank': instance.rank,
    };
