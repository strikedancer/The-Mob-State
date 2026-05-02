import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class RouteInfo {
  @JsonKey(defaultValue: <String>[])
  final List<String> path;
  @JsonKey(defaultValue: 0)
  final int stops;
  @JsonKey(defaultValue: true)
  final bool isDirect;
  @JsonKey(defaultValue: 1.0)
  final double costMultiplier;
  @JsonKey(defaultValue: 0)
  final int timeDelay;

  RouteInfo({
    required this.path,
    required this.stops,
    required this.isDirect,
    required this.costMultiplier,
    required this.timeDelay,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) =>
      _$RouteInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RouteInfoToJson(this);
}

@JsonSerializable()
class Country {
  final String id;
  final String name;
  @JsonKey(name: 'travelCost')
  final int flightCost;
  final String? description;
  final Map<String, dynamic>? tradeBonuses;
  final RouteInfo? route;
  final int? totalCost;
  final int? totalTime;

  Country({
    required this.id,
    required this.name,
    required this.flightCost,
    this.description,
    this.tradeBonuses,
    this.route,
    this.totalCost,
    this.totalTime,
  });

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
