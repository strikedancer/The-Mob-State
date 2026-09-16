import 'package:json_annotation/json_annotation.dart';

import '../utils/chat_relative_time.dart';

part 'crew_message.g.dart';

@JsonSerializable()
class CrewMessage {
  final int id;
  final int crewId;
  final int playerId;
  final String message;
  final String createdAt;
  @JsonKey(name: 'player')
  final MessageSender? sender;

  CrewMessage({
    required this.id,
    required this.crewId,
    required this.playerId,
    required this.message,
    required this.createdAt,
    this.sender,
  });

  factory CrewMessage.fromJson(Map<String, dynamic> json) =>
      _$CrewMessageFromJson(json);
  Map<String, dynamic> toJson() => _$CrewMessageToJson(this);

  String get formattedTime =>
      formatChatRelativeTime(createdAt, style: ChatRelativeStyle.thread);
}

@JsonSerializable()
class MessageSender {
  final int id;
  final String username;
  final int rank;

  MessageSender({required this.id, required this.username, required this.rank});

  factory MessageSender.fromJson(Map<String, dynamic> json) =>
      _$MessageSenderFromJson(json);
  Map<String, dynamic> toJson() => _$MessageSenderToJson(this);
}
