import 'package:json_annotation/json_annotation.dart';

part 'player_tool.g.dart';

@JsonSerializable()
class PlayerTool {
  final int id;
  final int playerId;
  final String toolId;
  final int durability;
  final DateTime createdAt;
  
  // From tool definition (included in API response)
  final String? name;
  final String? type;
  final int? basePrice;
  final int? maxDurability;
  final double? loseChance;
  final int? wearPerUse;
  final bool? isBroken;
  final bool? needsRepair;

  PlayerTool({
    required this.id,
    required this.playerId,
    required this.toolId,
    required this.durability,
    required this.createdAt,
    this.name,
    this.type,
    this.basePrice,
    this.maxDurability,
    this.loseChance,
    this.wearPerUse,
    this.isBroken,
    this.needsRepair,
  });

  factory PlayerTool.fromJson(Map<String, dynamic> json) => _$PlayerToolFromJson(json);
  Map<String, dynamic> toJson() => _$PlayerToolToJson(this);
  
  // Helper to get durability percentage
  double get durabilityPercent => maxDurability != null && maxDurability! > 0
      ? (durability / maxDurability!) * 100
      : 0;
}
