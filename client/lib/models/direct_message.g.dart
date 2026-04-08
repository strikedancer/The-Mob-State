// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'direct_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DirectMessage _$DirectMessageFromJson(Map<String, dynamic> json) =>
    DirectMessage(
      id: (json['id'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      receiverId: (json['receiverId'] as num).toInt(),
      message: json['message'] as String,
      read: json['read'] as bool,
      createdAt: json['createdAt'] as String,
      senderInfo: json['sender'] == null
          ? null
          : MessageSender.fromJson(json['sender'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DirectMessageToJson(DirectMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'message': instance.message,
      'read': instance.read,
      'createdAt': instance.createdAt,
      'sender': instance.senderInfo,
    };

MessageSender _$MessageSenderFromJson(Map<String, dynamic> json) =>
    MessageSender(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      rank: (json['rank'] as num).toInt(),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$MessageSenderToJson(MessageSender instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'rank': instance.rank,
      'avatar': instance.avatar,
    };

Conversation _$ConversationFromJson(Map<String, dynamic> json) => Conversation(
  friendId: (json['friendId'] as num).toInt(),
  username: json['username'] as String,
  rank: (json['rank'] as num).toInt(),
  avatar: json['avatar'] as String?,
  lastMessage: json['lastMessage'] as String?,
  lastMessageTime: json['lastMessageTime'] as String?,
  unreadCount: (json['unreadCount'] as num).toInt(),
);

Map<String, dynamic> _$ConversationToJson(Conversation instance) =>
    <String, dynamic>{
      'friendId': instance.friendId,
      'username': instance.username,
      'rank': instance.rank,
      'avatar': instance.avatar,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime,
      'unreadCount': instance.unreadCount,
    };
