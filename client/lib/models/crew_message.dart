import 'package:json_annotation/json_annotation.dart';

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

  String get formattedTime {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Nu';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}u';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d';
      } else {
        return '${dateTime.day}/${dateTime.month}';
      }
    } catch (e) {
      return '';
    }
  }
}

@JsonSerializable()
class MessageSender {
  final int id;
  final String username;
  final int rank;

  MessageSender({
    required this.id,
    required this.username,
    required this.rank,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) =>
      _$MessageSenderFromJson(json);
  Map<String, dynamic> toJson() => _$MessageSenderToJson(this);
}
