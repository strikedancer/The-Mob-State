import 'package:json_annotation/json_annotation.dart';

part 'vehicle_crime.g.dart';

/// Vehicle model for crime system
/// Used by /garage/vehicles and /garage/crime-vehicle endpoints
@JsonSerializable()
class Vehicle {
  final int id;
  final int playerId;
  final String? vehicleType;
  final int? speed; // 1-100
  final int? armor; // 1-100
  final int? stealth; // 1-100
  final int? cargo; // 1-100
  final double? condition; // 0-100%
  final int? fuel;
  final int? maxFuel;
  final bool? isBroken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Vehicle({
    required this.id,
    required this.playerId,
    this.vehicleType,
    this.speed,
    this.armor,
    this.stealth,
    this.cargo,
    this.condition,
    this.fuel,
    this.maxFuel,
    this.isBroken,
    this.createdAt,
    this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) =>
      _$VehicleFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleToJson(this);

  /// Get overall vehicle quality score (0-100)
  int getQualityScore() {
    int score = 0;

    if (speed != null) score += speed! ~/ 5;
    if (armor != null) score += armor! ~/ 5;
    if (stealth != null) score += stealth! ~/ 5;
    if (cargo != null) score += cargo! ~/ 5;
    if (condition != null) score += (condition! * 0.2).toInt();

    return (score / 5).round().clamp(0, 100);
  }

  /// Check if vehicle is suitable for crimes
  bool isSuitableForCrime() {
    return !isBroken! && condition! > 10 && fuel! > 5;
  }

  /// Get repair cost for this vehicle
  /// $500 per 1% condition restored
  int getRepairCost(double targetCondition) {
    if (condition == null) return 0;
    final pointsToRestore = targetCondition - condition!;
    return (pointsToRestore * 500).toInt();
  }

  /// Get refuel cost for this vehicle
  /// $2 per liter
  int getRefuelCost(int litersToAdd) {
    return litersToAdd * 2;
  }
}
