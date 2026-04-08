import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class RouteInfo {
  final List<String> path;
  final int stops;
  final bool isDirect;
  final double costMultiplier;
  final int timeDelay;

  RouteInfo({
    required this.path,
    required this.stops,
    required this.isDirect,
    required this.costMultiplier,
    required this.timeDelay,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      path: (json['path'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      stops: json['stops'] as int? ?? 0,
      isDirect: json['isDirect'] as bool? ?? true,
      costMultiplier: (json['costMultiplier'] as num?)?.toDouble() ?? 1.0,
      timeDelay: json['timeDelay'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$RouteInfoToJson(this);
}

@JsonSerializable()
class Country {
  final String id;
  final String name;
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

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      flightCost: json['travelCost'] as int? ?? 0,
      description: json['description'] as String?,
      tradeBonuses: json['tradeBonuses'] as Map<String, dynamic>?,
      route: json['route'] != null ? RouteInfo.fromJson(json['route'] as Map<String, dynamic>) : null,
      totalCost: json['totalCost'] as int?,
      totalTime: json['totalTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
