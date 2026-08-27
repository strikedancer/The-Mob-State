import 'package:json_annotation/json_annotation.dart';

part 'crime.g.dart';

@JsonSerializable()
class Crime {
  final String id;
  final String name;
  final String? description;

  @JsonKey(name: 'minLevel')
  final int requiredRank;

  @JsonKey(name: 'minReward')
  final int minPay;

  @JsonKey(name: 'maxReward')
  final int maxPay;

  final int xpReward;
  final double? baseSuccessChance;
  final int? playerSuccessChance;
  final int? jailTime;

  @JsonKey(name: 'requiredVehicle')
  final bool requiresVehicle;

  final double? breakdownChance;

  // Required tools for the crime
  final List<String>? requiredTools;

  // Required drugs for the crime
  final List<String>? requiredDrugs;
  final int? minDrugQuantity;

  // Required weapon for the crime
  final bool? requiredWeapon;

  /// Server-evaluated: rank + vehicle/drugs/tools/weapon requirements met.
  final bool? canAttempt;

  /// Show under "Beschikbaar" filter (rank OK; tools/weapons buyable; drugs/vehicles need rank unlock).
  final bool? isAvailable;

  /// Primary blocker when [canAttempt] is false (e.g. tools, rank, vehicle).
  final String? readinessBlocker;

  /// Required tools the player does not carry (and not in storage).
  final List<String>? missingToolIds;

  /// Required tools owned but only in property storage.
  final List<String>? toolsInStorageIds;

  /// All required tools are carried on the player.
  final bool? toolsReady;

  // Computed properties (not from JSON)
  final bool isFederalCrime;

  Crime({
    required this.id,
    required this.name,
    this.description,
    required this.requiredRank,
    required this.minPay,
    required this.maxPay,
    required this.xpReward,
    this.baseSuccessChance,
    this.playerSuccessChance,
    this.jailTime,
    required this.requiresVehicle,
    this.breakdownChance,
    this.requiredTools,
    this.requiredDrugs,
    this.minDrugQuantity,
    this.requiredWeapon,
    this.canAttempt,
    this.isAvailable,
    this.readinessBlocker,
    this.missingToolIds,
    this.toolsInStorageIds,
    this.toolsReady,
    this.isFederalCrime = false,
  });

  factory Crime.fromJson(Map<String, dynamic> json) => _$CrimeFromJson(json);
  Map<String, dynamic> toJson() => _$CrimeToJson(this);
}
