class PlayerActivity {
  final int id;
  final int playerId;
  final String activityType;
  final String description;
  final Map<String, dynamic> details;
  final bool isPublic;
  final DateTime createdAt;
  final ActivityPlayer? player; // Only present in friend feed

  PlayerActivity({
    required this.id,
    required this.playerId,
    required this.activityType,
    required this.description,
    required this.details,
    required this.isPublic,
    required this.createdAt,
    this.player,
  });

  factory PlayerActivity.fromJson(Map<String, dynamic> json) {
    return PlayerActivity(
      id: json['id'] as int,
      playerId: json['playerId'] as int,
      activityType: json['activityType'] as String,
      description: json['description'] as String,
      details: Map<String, dynamic>.from(json['details'] as Map),
      isPublic: json['isPublic'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      player: json['player'] != null
          ? ActivityPlayer.fromJson(json['player'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ActivityPlayer {
  final int id;
  final String username;
  final int rank;
  final String? avatar;

  ActivityPlayer({
    required this.id,
    required this.username,
    required this.rank,
    this.avatar,
  });

  factory ActivityPlayer.fromJson(Map<String, dynamic> json) {
    return ActivityPlayer(
      id: json['id'] as int,
      username: json['username'] as String,
      rank: json['rank'] as int,
      avatar: json['avatar'] as String?,
    );
  }
}
