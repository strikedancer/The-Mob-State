import 'package:json_annotation/json_annotation.dart';

part 'crime_tool.g.dart';

@JsonSerializable()
class CrimeTool {
  final String id;
  final String name;
  final String type;
  final int basePrice;
  final int maxDurability;
  final double loseChance;
  final int wearPerUse;
  final List<String> requiredFor;

  CrimeTool({
    required this.id,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.maxDurability,
    required this.loseChance,
    required this.wearPerUse,
    required this.requiredFor,
  });

  factory CrimeTool.fromJson(Map<String, dynamic> json) => _$CrimeToolFromJson(json);
  Map<String, dynamic> toJson() => _$CrimeToolToJson(this);
}
