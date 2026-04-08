// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crew_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrewMessage _$CrewMessageFromJson(Map<String, dynamic> json) => CrewMessage(
  id: (json['id'] as num).toInt(),
  crewId: (json['crewId'] as num).toInt(),
  playerId: (json['playerId'] as num).toInt(),
  message: json['message'] as String,
  createdAt: json['createdAt'] as String,
  sender: json['player'] == null
      ? null
      : MessageSender.fromJson(json['player'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CrewMessageToJson(CrewMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'crewId': instance.crewId,
      'playerId': instance.playerId,
      'message': instance.message,
      'createdAt': instance.createdAt,
      'player': instance.sender,
    };

MessageSender _$MessageSenderFromJson(Map<String, dynamic> json) =>
    MessageSender(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$MessageSenderToJson(MessageSender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'rank': instance.rank,
    };
