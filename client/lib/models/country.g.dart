// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) => RouteInfo(
  path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
  stops: (json['stops'] as num).toInt(),
  isDirect: json['isDirect'] as bool,
  costMultiplier: (json['costMultiplier'] as num).toDouble(),
  timeDelay: (json['timeDelay'] as num).toInt(),
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
  flightCost: (json['flightCost'] as num).toInt(),
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
  'flightCost': instance.flightCost,
  'description': instance.description,
  'tradeBonuses': instance.tradeBonuses,
  'route': instance.route,
  'totalCost': instance.totalCost,
  'totalTime': instance.totalTime,
};
