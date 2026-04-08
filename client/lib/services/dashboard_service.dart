import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_client.dart';

class DashboardStats {
  final int crimeAttempts;
  final int successfulCrimes;
  final int jobAttempts;
  final int vehicleThieves;
  final int boatThieves;
  final int streetProstitutes;
  final int redLightProstitutes;
  final int totalAmmo;
  final int drugsTotalQuantity;
  final int nightclubVenues;
  final int nightclubRevenueAllTime;
  final List<WeaponInfo> weapons;
  final String? selectedWeaponName;
  final VehicleInfo? activeVehicle;
  final bool jailed;
  final int jailTimeRemaining;
  final int bankBalance;
  final Map<String, int> cooldowns;

  DashboardStats({
    required this.crimeAttempts,
    required this.successfulCrimes,
    required this.jobAttempts,
    required this.vehicleThieves,
    required this.boatThieves,
    required this.streetProstitutes,
    required this.redLightProstitutes,
    required this.totalAmmo,
    required this.drugsTotalQuantity,
    required this.nightclubVenues,
    required this.nightclubRevenueAllTime,
    required this.weapons,
    this.selectedWeaponName,
    this.activeVehicle,
    required this.jailed,
    required this.jailTimeRemaining,
    required this.bankBalance,
    required this.cooldowns,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      crimeAttempts: json['crimeAttempts'] as int,
      successfulCrimes: json['successfulCrimes'] as int,
      jobAttempts: json['jobAttempts'] as int,
      vehicleThieves: json['vehicleThieves'] as int? ?? 0,
      boatThieves: json['boatThieves'] as int? ?? 0,
      streetProstitutes: json['streetProstitutes'] as int? ?? 0,
      redLightProstitutes: json['redLightProstitutes'] as int? ?? 0,
      totalAmmo: json['totalAmmo'] as int,
        drugsTotalQuantity: json['drugsTotalQuantity'] as int? ?? 0,
        nightclubVenues: json['nightclubVenues'] as int? ?? 0,
        nightclubRevenueAllTime: json['nightclubRevenueAllTime'] as int? ?? 0,
      weapons: (json['weapons'] as List<dynamic>)
          .map((w) => WeaponInfo.fromJson(w as Map<String, dynamic>))
          .toList(),
      selectedWeaponName: json['selectedWeaponName'] as String?,
      activeVehicle: json['activeVehicle'] != null
          ? VehicleInfo.fromJson(json['activeVehicle'] as Map<String, dynamic>)
          : null,
      jailed: json['jailed'] as bool,
      jailTimeRemaining: json['jailTimeRemaining'] as int,
      bankBalance: json['bankBalance'] as int,
      cooldowns: Map<String, int>.from(json['cooldowns'] as Map),
    );
  }

  int getCooldownSeconds(String actionType) {
    return cooldowns[actionType] ?? 0;
  }

  bool canDoAction(String actionType) {
    return getCooldownSeconds(actionType) == 0;
  }
}

class WeaponInfo {
  final int id;
  final String name;
  final int condition;

  WeaponInfo({required this.id, required this.name, required this.condition});

  factory WeaponInfo.fromJson(Map<String, dynamic> json) {
    return WeaponInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      condition: json['condition'] as int? ?? 100,
    );
  }
}

class VehicleInfo {
  final int id;
  final String name;
  final String type;
  final String location;
  final int fuel;

  VehicleInfo({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.fuel,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      fuel: json['fuel'] as int? ?? 100,
    );
  }
}

class DashboardService {
  static final _apiClient = ApiClient();

  static Future<DashboardStats> getDashboardStats() async {
    final token = await _apiClient.getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('${AppConfig.apiBaseUrl}/player/dashboard-stats'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      print('[DashboardService] Response: ${json.encode(data)}');
      final stats = DashboardStats.fromJson(
        data['stats'] as Map<String, dynamic>,
      );
      print(
        '[DashboardService] Parsed stats - Crimes: ${stats.crimeAttempts}, Cooldowns: ${stats.cooldowns}',
      );
      return stats;
    } else {
      print('[DashboardService] API Error: ${response.statusCode}');
      throw Exception('Failed to load dashboard stats: ${response.statusCode}');
    }
  }
}
