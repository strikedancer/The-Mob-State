// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) => RouteInfo(
      path: (json['path'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
      stops: (json['stops'] as num?)?.toInt() ?? 0,
      isDirect: json['isDirect'] as bool? ?? true,
      costMultiplier: (json['costMultiplier'] as num?)?.toDouble() ?? 1.0,
      timeDelay: (json['timeDelay'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RouteInfoToJson(RouteInfo instance) => <String, dynamic>{
      'path': instance.path,
      'stops': instance.stops,
      'isDirect': instance.isDirect,
      'costMultiplier': instance.costMultiplier,
      'timeDelay': instance.timeDelay,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as String,
      name: json['name'] as String,
      flightCost: (json['travelCost'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      tradeBonuses: json['tradeBonuses'] as Map<String, dynamic>?,
      route: json['route'] == null
          ? null
          : RouteInfo.fromJson(json['route'] as Map<String, dynamic>),
      totalCost: (json['totalCost'] as num?)?.toInt(),
      totalTime: (json['totalTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'travelCost': instance.flightCost,
      'description': instance.description,
      'tradeBonuses': instance.tradeBonuses,
      'route': instance.route != null ? _$RouteInfoToJson(instance.route!) : null,
      'totalCost': instance.totalCost,
      'totalTime': instance.totalTime,
    };
