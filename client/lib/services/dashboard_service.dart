import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'api_client.dart';

class CrewWarDashboardSummary {
  final bool hasActiveWar;
  final bool canDeclare;
  final String? status;
  final String? warType;
  final String? opponentCrewName;
  final int myCrewPoints;
  final int? myCrewRank;
  final int? seasonRank;
  final int availableTargetsCount;
  final int phaseEndsInSeconds;

  CrewWarDashboardSummary({
    required this.hasActiveWar,
    required this.canDeclare,
    this.status,
    this.warType,
    this.opponentCrewName,
    required this.myCrewPoints,
    this.myCrewRank,
    this.seasonRank,
    required this.availableTargetsCount,
    required this.phaseEndsInSeconds,
  });

  factory CrewWarDashboardSummary.fromJson(Map<String, dynamic> json) {
    return CrewWarDashboardSummary(
      hasActiveWar: json['hasActiveWar'] as bool? ?? false,
      canDeclare: json['canDeclare'] as bool? ?? false,
      status: json['status'] as String?,
      warType: json['warType'] as String?,
      opponentCrewName: json['opponentCrewName'] as String?,
      myCrewPoints: json['myCrewPoints'] as int? ?? 0,
      myCrewRank: json['myCrewRank'] as int?,
      seasonRank: json['seasonRank'] as int?,
      availableTargetsCount: json['availableTargetsCount'] as int? ?? 0,
      phaseEndsInSeconds: json['phaseEndsInSeconds'] as int? ?? 0,
    );
  }

  CrewWarDashboardSummary copyWith({int? phaseEndsInSeconds}) {
    return CrewWarDashboardSummary(
      hasActiveWar: hasActiveWar,
      canDeclare: canDeclare,
      status: status,
      warType: warType,
      opponentCrewName: opponentCrewName,
      myCrewPoints: myCrewPoints,
      myCrewRank: myCrewRank,
      seasonRank: seasonRank,
      availableTargetsCount: availableTargetsCount,
      phaseEndsInSeconds: phaseEndsInSeconds ?? this.phaseEndsInSeconds,
    );
  }
}

class TerritoryLeaderDashboardSummary {
  final int regionsOwned;
  final int countriesOwned;
  final int incomeIntervalMinutes;
  final int passiveIncomePerInterval;
  final int passiveIncomePerHour;
  final int passiveIncomePerDay;
  final int totalPassiveIncomeEarned;
  final int crewBankBalance;

  TerritoryLeaderDashboardSummary({
    required this.regionsOwned,
    required this.countriesOwned,
    required this.incomeIntervalMinutes,
    required this.passiveIncomePerInterval,
    required this.passiveIncomePerHour,
    required this.passiveIncomePerDay,
    required this.totalPassiveIncomeEarned,
    required this.crewBankBalance,
  });

  factory TerritoryLeaderDashboardSummary.fromJson(Map<String, dynamic> json) {
    return TerritoryLeaderDashboardSummary(
      regionsOwned: json['regionsOwned'] as int? ?? 0,
      countriesOwned: json['countriesOwned'] as int? ?? 0,
      incomeIntervalMinutes: json['incomeIntervalMinutes'] as int? ?? 0,
      passiveIncomePerInterval: json['passiveIncomePerInterval'] as int? ?? 0,
      passiveIncomePerHour: json['passiveIncomePerHour'] as int? ?? 0,
      passiveIncomePerDay: json['passiveIncomePerDay'] as int? ?? 0,
      totalPassiveIncomeEarned: json['totalPassiveIncomeEarned'] as int? ?? 0,
      crewBankBalance: json['crewBankBalance'] as int? ?? 0,
    );
  }
}

class DashboardStats {
  final int crimeAttempts;
  final int breakoutCount;
  final int killCount;
  final int hitsPlacedCount;
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
  final int travelCount;
  final List<WeaponInfo> weapons;
  final String? selectedWeaponName;
  final VehicleInfo? activeVehicle;
  final bool jailed;
  final int jailTimeRemaining;
  final int bankBalance;
  final CrewWarDashboardSummary? crewWar;
  final TerritoryLeaderDashboardSummary? territoryLeaderStats;
  final Map<String, int> cooldowns;

  DashboardStats({
    required this.crimeAttempts,
    required this.breakoutCount,
    required this.killCount,
    required this.hitsPlacedCount,
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
    required this.travelCount,
    required this.weapons,
    this.selectedWeaponName,
    this.activeVehicle,
    required this.jailed,
    required this.jailTimeRemaining,
    required this.bankBalance,
    this.crewWar,
    this.territoryLeaderStats,
    required this.cooldowns,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      crimeAttempts: json['crimeAttempts'] as int,
      breakoutCount: json['breakoutCount'] as int? ?? 0,
      killCount: json['killCount'] as int? ?? 0,
      hitsPlacedCount: json['hitsPlacedCount'] as int? ?? 0,
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
      travelCount: json['travelCount'] as int? ?? 0,
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
      crewWar: json['crewWar'] != null
          ? CrewWarDashboardSummary.fromJson(
              json['crewWar'] as Map<String, dynamic>,
            )
          : null,
      territoryLeaderStats: json['territoryLeaderStats'] != null
          ? TerritoryLeaderDashboardSummary.fromJson(
              json['territoryLeaderStats'] as Map<String, dynamic>,
            )
          : null,
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
