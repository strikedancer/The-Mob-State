import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  final int id;
  final String username;
  final int money;
  final int health;
  final int rank;
  final int xp;
  final int? wantedLevel;
  final int? fbiHeat;
  final String? currentCountry;
  final String? avatar;
  /// Active custom portrait row id when using a generated portrait as display.
  final int? activePortraitId;
  /// Relative path under `/images/` (e.g. `player_avatars/12/uuid.png`).
  final String? activePortraitPath;
  final int? premiumCredits;
  /// `male` | `female` from server; null for legacy accounts.
  final String? gender;
  final bool? isVip;
  final DateTime? vipExpiresAt;
  final String? preferredLanguage;
  final String? wealthStatus;
  final String? wealthIcon;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastTickAt;

  Player({
    required this.id,
    required this.username,
    required this.money,
    required this.health,
    required this.rank,
    required this.xp,
    this.wantedLevel,
    this.fbiHeat,
    this.currentCountry,
    this.avatar,
    this.activePortraitId,
    this.activePortraitPath,
    this.premiumCredits,
    this.gender,
    this.isVip,
    this.vipExpiresAt,
    this.preferredLanguage,
    this.wealthStatus,
    this.wealthIcon,
    this.createdAt,
    this.updatedAt,
    this.lastTickAt,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  Player copyWith({
    int? money,
    int? health,
    int? rank,
    int? xp,
    int? wantedLevel,
    int? fbiHeat,
    String? currentCountry,
    String? avatar,
    int? activePortraitId,
    String? activePortraitPath,
    int? premiumCredits,
    String? gender,
    bool? isVip,
    DateTime? vipExpiresAt,
    String? preferredLanguage,
    String? wealthStatus,
    String? wealthIcon,
  }) {
    return Player(
      id: id,
      username: username,
      money: money ?? this.money,
      health: health ?? this.health,
      rank: rank ?? this.rank,
      xp: xp ?? this.xp,
      wantedLevel: wantedLevel ?? this.wantedLevel,
      fbiHeat: fbiHeat ?? this.fbiHeat,
      currentCountry: currentCountry ?? this.currentCountry,
      avatar: avatar ?? this.avatar,
      activePortraitId: activePortraitId ?? this.activePortraitId,
      activePortraitPath: activePortraitPath ?? this.activePortraitPath,
      premiumCredits: premiumCredits ?? this.premiumCredits,
      gender: gender ?? this.gender,
      isVip: isVip ?? this.isVip,
      vipExpiresAt: vipExpiresAt ?? this.vipExpiresAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      wealthStatus: wealthStatus ?? this.wealthStatus,
      wealthIcon: wealthIcon ?? this.wealthIcon,
      createdAt: createdAt,
      updatedAt: updatedAt,
      lastTickAt: lastTickAt,
    );
  }

  PlayerHudSnapshot get hudSnapshot => PlayerHudSnapshot.from(this);
}

/// HUD fields only — used so the top bar can rebuild without remounting the page.
class PlayerHudSnapshot {
  const PlayerHudSnapshot({
    required this.money,
    required this.health,
    required this.rank,
    required this.xp,
    required this.wantedLevel,
    required this.fbiHeat,
    required this.premiumCredits,
    required this.currentCountry,
    required this.username,
    required this.avatar,
    required this.activePortraitPath,
    required this.isVip,
    required this.vipExpiresAt,
  });

  factory PlayerHudSnapshot.from(Player player) {
    return PlayerHudSnapshot(
      money: player.money,
      health: player.health,
      rank: player.rank,
      xp: player.xp,
      wantedLevel: player.wantedLevel ?? 0,
      fbiHeat: player.fbiHeat ?? 0,
      premiumCredits: player.premiumCredits ?? 0,
      currentCountry: player.currentCountry,
      username: player.username,
      avatar: player.avatar,
      activePortraitPath: player.activePortraitPath,
      isVip: player.isVip == true,
      vipExpiresAt: player.vipExpiresAt,
    );
  }

  final int money;
  final int health;
  final int rank;
  final int xp;
  final int wantedLevel;
  final int fbiHeat;
  final int premiumCredits;
  final String? currentCountry;
  final String username;
  final String? avatar;
  final String? activePortraitPath;
  final bool isVip;
  final DateTime? vipExpiresAt;

  @override
  bool operator ==(Object other) {
    return other is PlayerHudSnapshot &&
        other.money == money &&
        other.health == health &&
        other.rank == rank &&
        other.xp == xp &&
        other.wantedLevel == wantedLevel &&
        other.fbiHeat == fbiHeat &&
        other.premiumCredits == premiumCredits &&
        other.currentCountry == currentCountry &&
        other.username == username &&
        other.avatar == avatar &&
        other.activePortraitPath == activePortraitPath &&
        other.isVip == isVip &&
        other.vipExpiresAt == vipExpiresAt;
  }

  @override
  int get hashCode => Object.hash(
        money,
        health,
        rank,
        xp,
        wantedLevel,
        fbiHeat,
        premiumCredits,
        currentCountry,
        username,
        avatar,
        activePortraitPath,
        isVip,
        vipExpiresAt,
      );
}
