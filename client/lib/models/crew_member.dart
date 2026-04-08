import 'package:json_annotation/json_annotation.dart';

part 'crew_member.g.dart';

@JsonSerializable()
class CrewMember {
  final int id;
  final int crewId;
  final int playerId;
  final String role;
  final int trustScore;
  final String joinedAt;
  
  // Player info (included in API response)
  @JsonKey(name: 'player')
  final PlayerInfo? playerInfo;

  CrewMember({
    required this.id,
    required this.crewId,
    required this.playerId,
    required this.role,
    required this.trustScore,
    required this.joinedAt,
    this.playerInfo,
  });

  factory CrewMember.fromJson(Map<String, dynamic> json) => _$CrewMemberFromJson(json);
  Map<String, dynamic> toJson() => _$CrewMemberToJson(this);

  bool get isLeader => role == 'leader';
}

@JsonSerializable()
class PlayerInfo {
  final int id;
  final String username;
  final int rank;

  PlayerInfo({
    required this.id,
    required this.username,
    required this.rank,
  });

  factory PlayerInfo.fromJson(Map<String, dynamic> json) => _$PlayerInfoFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerInfoToJson(this);
}
