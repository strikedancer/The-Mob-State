import 'package:json_annotation/json_annotation.dart';

part 'friendship.g.dart';

@JsonSerializable()
class PlayerSearchResult {
  final int id;
  final String username;
  final int rank;
  final String? currentCountry;
  final String? avatar;
  final String? crewName;
  final String friendStatus; // 'none', 'pending_sent', 'pending_received', 'friends'
  final int? friendshipId;

  PlayerSearchResult({
    required this.id,
    required this.username,
    required this.rank,
    this.currentCountry,
    this.avatar,
    this.crewName,
    required this.friendStatus,
    this.friendshipId,
  });

  factory PlayerSearchResult.fromJson(Map<String, dynamic> json) =>
      _$PlayerSearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerSearchResultToJson(this);

  bool get canSendRequest => friendStatus == 'none';
  bool get isPendingSent => friendStatus == 'pending_sent';
  bool get isPendingReceived => friendStatus == 'pending_received';
  bool get isFriend => friendStatus == 'friends';
}

@JsonSerializable()
class FriendInfo {
  final int id;
  final String username;
  final int rank;
  final int health;
  final String currentCountry;
  final String? avatar;

  FriendInfo({
    required this.id,
    required this.username,
    required this.rank,
    required this.health,
    required this.currentCountry,
    this.avatar,
  });

  factory FriendInfo.fromJson(Map<String, dynamic> json) =>
      _$FriendInfoFromJson(json);
  Map<String, dynamic> toJson() => _$FriendInfoToJson(this);
}

@JsonSerializable()
class Friend {
  final int friendshipId;
  final FriendInfo friend;
  final String since;

  Friend({
    required this.friendshipId,
    required this.friend,
    required this.since,
  });

  factory Friend.fromJson(Map<String, dynamic> json) =>
      _$FriendFromJson(json);
  Map<String, dynamic> toJson() => _$FriendToJson(this);
}

@JsonSerializable()
class FriendRequest {
  final int friendshipId;
  @JsonKey(name: 'requester')
  final RequesterInfo requesterInfo;
  final String createdAt;

  FriendRequest({
    required this.friendshipId,
    required this.requesterInfo,
    required this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}

@JsonSerializable()
class RequesterInfo {
  final int id;
  final String username;
  final int rank;
  final String? avatar;

  RequesterInfo({
    required this.id,
    required this.username,
    required this.rank,
    this.avatar,
  });

  factory RequesterInfo.fromJson(Map<String, dynamic> json) =>
      _$RequesterInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RequesterInfoToJson(this);
}
