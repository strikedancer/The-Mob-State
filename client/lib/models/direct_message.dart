import 'package:json_annotation/json_annotation.dart';

part 'direct_message.g.dart';

@JsonSerializable()
class DirectMessage {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final bool read;
  final String createdAt;
  @JsonKey(name: 'sender')
  final MessageSender? senderInfo;

  DirectMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.read,
    required this.createdAt,
    this.senderInfo,
  });

  factory DirectMessage.fromJson(Map<String, dynamic> json) =>
      _$DirectMessageFromJson(json);
  Map<String, dynamic> toJson() => _$DirectMessageToJson(this);

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

  String get formattedDateTime {
    try {
      final dateTime = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays < 1) {
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays < 7) {
        final weekdays = ['Ma', 'Di', 'Wo', 'Do', 'Vr', 'Za', 'Zo'];
        return weekdays[dateTime.weekday - 1];
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
  final String? avatar;

  MessageSender({
    required this.id,
    required this.username,
    required this.rank,
    this.avatar,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) =>
      _$MessageSenderFromJson(json);
  Map<String, dynamic> toJson() => _$MessageSenderToJson(this);
}

@JsonSerializable()
class Conversation {
  final int friendId;
  final String username;
  final int rank;
  final String? avatar;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;

  Conversation({
    required this.friendId,
    required this.username,
    required this.rank,
    this.avatar,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
  Map<String, dynamic> toJson() => _$ConversationToJson(this);

  String get formattedTime {
    if (lastMessageTime == null) return '';
    
    try {
      final dateTime = DateTime.parse(lastMessageTime!);
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
