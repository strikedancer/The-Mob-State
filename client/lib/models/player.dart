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
  /// `male` | `female` from server; null for legacy accounts.
  final String? gender;
  final bool? isVip;
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
    this.gender,
    this.isVip,
    this.preferredLanguage,
    this.wealthStatus,
    this.wealthIcon,
    this.createdAt,
    this.updatedAt,
    this.lastTickAt,
  });

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
