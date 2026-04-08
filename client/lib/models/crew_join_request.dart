class CrewJoinRequest {
  final int id;
  final int crewId;
  final int playerId;
  final String status;
  final String createdAt;
  final CrewJoinRequestPlayer player;

  CrewJoinRequest({
    required this.id,
    required this.crewId,
    required this.playerId,
    required this.status,
    required this.createdAt,
    required this.player,
  });

  factory CrewJoinRequest.fromJson(Map<String, dynamic> json) {
    return CrewJoinRequest(
      id: json['id'] as int,
      crewId: json['crewId'] as int,
      playerId: json['playerId'] as int,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      player: CrewJoinRequestPlayer.fromJson(json['player'] as Map<String, dynamic>),
    );
  }
}

class CrewJoinRequestPlayer {
  final int id;
  final String username;
  final int rank;

  CrewJoinRequestPlayer({
    required this.id,
    required this.username,
    required this.rank,
  });

  factory CrewJoinRequestPlayer.fromJson(Map<String, dynamic> json) {
    return CrewJoinRequestPlayer(
      id: json['id'] as int,
      username: json['username'] as String,
      rank: json['rank'] as int,
    );
  }
}
