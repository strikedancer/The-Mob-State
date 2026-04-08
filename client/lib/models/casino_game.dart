class CasinoGame {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int minBet;
  final int maxBet;
  final String difficulty;

  CasinoGame({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.minBet,
    required this.maxBet,
    required this.difficulty,
  });

  factory CasinoGame.fromJson(Map<String, dynamic> json) {
    return CasinoGame(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      minBet: json['minBet'] as int,
      maxBet: json['maxBet'] as int,
      difficulty: json['difficulty'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'minBet': minBet,
      'maxBet': maxBet,
      'difficulty': difficulty,
    };
  }
}

class CasinoGameResult {
  final String gameId;
  final int betAmount;
  final bool won;
  final int payout;
  final Map<String, dynamic> gameData;
  final DateTime timestamp;

  CasinoGameResult({
    required this.gameId,
    required this.betAmount,
    required this.won,
    required this.payout,
    required this.gameData,
    required this.timestamp,
  });

  factory CasinoGameResult.fromJson(Map<String, dynamic> json) {
    return CasinoGameResult(
      gameId: json['gameId'] as String,
      betAmount: json['betAmount'] as int,
      won: json['won'] as bool,
      payout: json['payout'] as int,
      gameData: json['gameData'] as Map<String, dynamic>,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  int get profit => payout - betAmount;
}
