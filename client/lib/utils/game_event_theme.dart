import 'package:flutter/material.dart';

class GameEventTheme {
  const GameEventTheme({
    required this.asset,
    required this.icon,
    required this.accent,
  });

  final String asset;
  final IconData icon;
  final Color accent;
}

String? gameEventTemplateKey(Map<String, dynamic>? event) {
  final template = event?['template'];
  if (template is Map) {
    return template['key']?.toString();
  }
  return null;
}

String? gameEventCategory(Map<String, dynamic>? event) {
  final template = event?['template'];
  if (template is Map) {
    return template['category']?.toString();
  }
  return null;
}

bool isMonthlyEmpireEvent(Map<String, dynamic>? event) {
  final key = gameEventTemplateKey(event);
  final category = (gameEventCategory(event) ?? '').toLowerCase();
  return key == 'monthly_empire_showdown' || category == 'allround';
}

GameEventTheme gameEventThemeForCategory(String? category) {
  switch ((category ?? '').toLowerCase()) {
    case 'crime':
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/crime_background.png',
        icon: Icons.warning_amber_rounded,
        accent: Color(0xFFE85D4C),
      );
    case 'drugs':
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/drug_production_bg.png',
        icon: Icons.science,
        accent: Color(0xFF5CC8A0),
      );
    case 'smuggling':
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/smuggling_hub_bg.png',
        icon: Icons.local_shipping,
        accent: Color(0xFF5B9BD5),
      );
    case 'vehicles':
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/garage_background.png',
        icon: Icons.directions_car,
        accent: Color(0xFFF0A04B),
      );
    case 'trade':
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/weapon_shop_bg.png',
        icon: Icons.storefront,
        accent: Color(0xFFD4AF37),
      );
    case 'allround':
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/nightclub_hub_bg_desktop.png',
        icon: Icons.emoji_events,
        accent: Color(0xFFB388FF),
      );
    default:
      return const GameEventTheme(
        asset: 'assets/images/backgrounds/crime_background.png',
        icon: Icons.event,
        accent: Color(0xFFD4AF37),
      );
  }
}

GameEventTheme gameEventThemeForEvent(Map<String, dynamic>? event) {
  return gameEventThemeForCategory(gameEventCategory(event));
}

/// Active events first, with Monthly Empire pinned, plus the monthly
/// preview/upcoming row when it is not already live.
List<Map<String, dynamic>> buildLiveEventRailItems({
  required List<Map<String, dynamic>> active,
  List<Map<String, dynamic>> upcoming = const [],
  List<Map<String, dynamic>> upcomingPreview = const [],
}) {
  Map<String, dynamic>? monthly;
  for (final pool in [active, upcoming, upcomingPreview]) {
    for (final event in pool) {
      if (isMonthlyEmpireEvent(event)) {
        monthly = event;
        break;
      }
    }
    if (monthly != null) break;
  }

  final others = active.where((event) => !isMonthlyEmpireEvent(event)).toList();
  return [
    if (monthly != null) monthly,
    ...others,
  ];
}
