// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friendship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerSearchResult _$PlayerSearchResultFromJson(Map<String, dynamic> json) =>
    PlayerSearchResult(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      rank: (json['rank'] as num).toInt(),
      currentCountry: json['currentCountry'] as String?,
      avatar: json['avatar'] as String?,
      crewName: json['crewName'] as String?,
      friendStatus: json['friendStatus'] as String,
      friendshipId: (json['friendshipId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlayerSearchResultToJson(PlayerSearchResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'rank': instance.rank,
      'currentCountry': instance.currentCountry,
      'avatar': instance.avatar,
      'crewName': instance.crewName,
      'friendStatus': instance.friendStatus,
      'friendshipId': instance.friendshipId,
    };

FriendInfo _$FriendInfoFromJson(Map<String, dynamic> json) => FriendInfo(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  rank: (json['rank'] as num).toInt(),
  health: (json['health'] as num).toInt(),
  currentCountry: json['currentCountry'] as String,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$FriendInfoToJson(FriendInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'rank': instance.rank,
      'health': instance.health,
      'currentCountry': instance.currentCountry,
      'avatar': instance.avatar,
    };

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
  friendshipId: (json['friendshipId'] as num).toInt(),
  friend: FriendInfo.fromJson(json['friend'] as Map<String, dynamic>),
  since: json['since'] as String,
);

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
  'friendshipId': instance.friendshipId,
  'friend': instance.friend,
  'since': instance.since,
};

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      friendshipId: (json['friendshipId'] as num).toInt(),
      requesterInfo: RequesterInfo.fromJson(
        json['requester'] as Map<String, dynamic>,
      ),
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) =>
    <String, dynamic>{
      'friendshipId': instance.friendshipId,
      'requester': instance.requesterInfo,
      'createdAt': instance.createdAt,
    };

RequesterInfo _$RequesterInfoFromJson(Map<String, dynamic> json) =>
    RequesterInfo(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String,
      rank: (json['rank'] as num).toInt(),
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$RequesterInfoToJson(RequesterInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'rank': instance.rank,
      'avatar': instance.avatar,
    };
