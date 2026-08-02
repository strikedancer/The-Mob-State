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
  final String? theaterRegionKey;
  final List<String> hotRegionKeys;

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
    this.theaterRegionKey,
    this.hotRegionKeys = const [],
  });

  factory CrewWarDashboardSummary.fromJson(Map<String, dynamic> json) {
    final hot = json['hotRegionKeys'];
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
      theaterRegionKey: json['theaterRegionKey'] as String?,
      hotRegionKeys: hot is List
          ? hot.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
          : const [],
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
      theaterRegionKey: theaterRegionKey,
      hotRegionKeys: hotRegionKeys,
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

class TerritoryDramaDashboardSummary {
  final List<String> hottestContestLines;
  final List<String> recentCaptureLines;
  final List<String> risingCrewLines;
  final List<String> warTheaterLines;
  final List<String> regionEventLines;

  TerritoryDramaDashboardSummary({
    this.hottestContestLines = const [],
    this.recentCaptureLines = const [],
    this.risingCrewLines = const [],
    this.warTheaterLines = const [],
    this.regionEventLines = const [],
  });

  bool get hasContent =>
      hottestContestLines.isNotEmpty ||
      recentCaptureLines.isNotEmpty ||
      risingCrewLines.isNotEmpty ||
      warTheaterLines.isNotEmpty ||
      regionEventLines.isNotEmpty;

  factory TerritoryDramaDashboardSummary.fromJson(Map<String, dynamic> json) {
    String contestLine(Map<String, dynamic> c) {
      final region = c['regionKey']?.toString() ?? '-';
      final status = c['status']?.toString() ?? '';
      final attacker = c['attackerCrewName']?.toString();
      final defender = c['defenderCrewName']?.toString();
      final vs = [
        if (attacker != null && attacker.isNotEmpty) attacker,
        if (defender != null && defender.isNotEmpty) defender,
      ].join(' vs ');
      return vs.isEmpty ? '$region ($status)' : '$region · $vs';
    }

    String captureLine(Map<String, dynamic> c) {
      final region = c['regionKey']?.toString() ?? '-';
      final winner = c['winnerCrewName']?.toString() ?? '-';
      return '$winner → $region';
    }

    String risingLine(Map<String, dynamic> c) {
      final name = c['crewName']?.toString() ?? '-';
      final captures = c['captures'] ?? 0;
      return '$name ($captures)';
    }

    String theaterLine(Map<String, dynamic> c) {
      final region = c['theaterRegionKey']?.toString() ?? '-';
      final attacker = c['attackerCrewName']?.toString();
      final defender = c['defenderCrewName']?.toString();
      final vs = [
        if (attacker != null && attacker.isNotEmpty) attacker,
        if (defender != null && defender.isNotEmpty) defender,
      ].join(' vs ');
      return vs.isEmpty ? region : '$region · $vs';
    }

    String eventLine(Map<String, dynamic> c) {
      final region = c['regionKey']?.toString() ?? '-';
      final key = c['eventKey']?.toString() ?? 'event';
      return '$region · $key';
    }

    List<String> mapList(dynamic raw, String Function(Map<String, dynamic>) mapFn) {
      if (raw is! List) return const [];
      return raw
          .whereType<Map>()
          .map((e) => mapFn(e.cast<String, dynamic>()))
          .where((e) => e.trim().isNotEmpty)
          .take(3)
          .toList(growable: false);
    }

    return TerritoryDramaDashboardSummary(
      hottestContestLines: mapList(json['hottestContests'], contestLine),
      recentCaptureLines: mapList(json['recentCaptures'], captureLine),
      risingCrewLines: mapList(json['risingCrews'], risingLine),
      warTheaterLines: mapList(json['activeWarTheaters'], theaterLine),
      regionEventLines: mapList(json['activeRegionEvents'], eventLine),
    );
  }
}

class VehicleOpsCategoryDashboardSummary {
  final int heatCurrent;
  final String heatLevel;
  final int reputationValue;
  final int reputationLevel;
  final String partsTrend;
  final bool blacklistActive;
  final bool crewAvailable;
  final String? crewName;
  final int contractsAvailable;
  final int openInsuranceClaims;
  final int seasonPoints;
  final int seasonWins;
  final int seasonLosses;
  final Map<String, int> cooldowns;

  VehicleOpsCategoryDashboardSummary({
    required this.heatCurrent,
    required this.heatLevel,
    required this.reputationValue,
    required this.reputationLevel,
    required this.partsTrend,
    required this.blacklistActive,
    required this.crewAvailable,
    this.crewName,
    required this.contractsAvailable,
    required this.openInsuranceClaims,
    required this.seasonPoints,
    required this.seasonWins,
    required this.seasonLosses,
    required this.cooldowns,
  });

  factory VehicleOpsCategoryDashboardSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return VehicleOpsCategoryDashboardSummary(
      heatCurrent: json['heatCurrent'] as int? ?? 0,
      heatLevel: (json['heatLevel'] ?? 'LOW').toString(),
      reputationValue: json['reputationValue'] as int? ?? 0,
      reputationLevel: json['reputationLevel'] as int? ?? 0,
      partsTrend: (json['partsTrend'] ?? 'flat').toString(),
      blacklistActive: json['blacklistActive'] as bool? ?? false,
      crewAvailable: json['crewAvailable'] as bool? ?? false,
      crewName: json['crewName'] as String?,
      contractsAvailable: json['contractsAvailable'] as int? ?? 0,
      openInsuranceClaims: json['openInsuranceClaims'] as int? ?? 0,
      seasonPoints: json['seasonPoints'] as int? ?? 0,
      seasonWins: json['seasonWins'] as int? ?? 0,
      seasonLosses: json['seasonLosses'] as int? ?? 0,
      cooldowns: Map<String, int>.from(json['cooldowns'] as Map? ?? const {}),
    );
  }

  VehicleOpsCategoryDashboardSummary copyWith({Map<String, int>? cooldowns}) {
    return VehicleOpsCategoryDashboardSummary(
      heatCurrent: heatCurrent,
      heatLevel: heatLevel,
      reputationValue: reputationValue,
      reputationLevel: reputationLevel,
      partsTrend: partsTrend,
      blacklistActive: blacklistActive,
      crewAvailable: crewAvailable,
      crewName: crewName,
      contractsAvailable: contractsAvailable,
      openInsuranceClaims: openInsuranceClaims,
      seasonPoints: seasonPoints,
      seasonWins: seasonWins,
      seasonLosses: seasonLosses,
      cooldowns: cooldowns ?? this.cooldowns,
    );
  }
}

class VehicleOpsDashboardSummary {
  final bool hasCrew;
  final String? crewRole;
  final VehicleOpsCategoryDashboardSummary? car;
  final VehicleOpsCategoryDashboardSummary? motorcycle;
  final VehicleOpsCategoryDashboardSummary? boat;

  VehicleOpsDashboardSummary({
    required this.hasCrew,
    this.crewRole,
    this.car,
    this.motorcycle,
    this.boat,
  });

  factory VehicleOpsDashboardSummary.fromJson(Map<String, dynamic> json) {
    return VehicleOpsDashboardSummary(
      hasCrew: json['hasCrew'] as bool? ?? false,
      crewRole: json['crewRole'] as String?,
      car: json['car'] is Map<String, dynamic>
          ? VehicleOpsCategoryDashboardSummary.fromJson(
              json['car'] as Map<String, dynamic>,
            )
          : null,
      motorcycle: json['motorcycle'] is Map<String, dynamic>
          ? VehicleOpsCategoryDashboardSummary.fromJson(
              json['motorcycle'] as Map<String, dynamic>,
            )
          : null,
      boat: json['boat'] is Map<String, dynamic>
          ? VehicleOpsCategoryDashboardSummary.fromJson(
              json['boat'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  VehicleOpsDashboardSummary copyWith({
    VehicleOpsCategoryDashboardSummary? car,
    VehicleOpsCategoryDashboardSummary? motorcycle,
    VehicleOpsCategoryDashboardSummary? boat,
  }) {
    return VehicleOpsDashboardSummary(
      hasCrew: hasCrew,
      crewRole: crewRole,
      car: car ?? this.car,
      motorcycle: motorcycle ?? this.motorcycle,
      boat: boat ?? this.boat,
    );
  }
}

class DashboardEconomySummary {
  final int cashBalance;
  final int bankBalance;
  final int cryptoPortfolioValue;
  final int propertyPortfolioValue;
  final int vehiclePortfolioValue;
  final int netWorth;

  DashboardEconomySummary({
    required this.cashBalance,
    required this.bankBalance,
    required this.cryptoPortfolioValue,
    required this.propertyPortfolioValue,
    required this.vehiclePortfolioValue,
    required this.netWorth,
  });

  factory DashboardEconomySummary.fromJson(Map<String, dynamic> json) {
    return DashboardEconomySummary(
      cashBalance: json['cashBalance'] as int? ?? 0,
      bankBalance: json['bankBalance'] as int? ?? 0,
      cryptoPortfolioValue: json['cryptoPortfolioValue'] as int? ?? 0,
      propertyPortfolioValue: json['propertyPortfolioValue'] as int? ?? 0,
      vehiclePortfolioValue: json['vehiclePortfolioValue'] as int? ?? 0,
      netWorth: json['netWorth'] as int? ?? 0,
    );
  }
}

class DashboardEconomy24hSummary {
  final int crimeIncome;
  final int jobIncome;
  final int nightclubIncome;
  final int propertySpend;
  final int grossIncome;
  final int netCashflow;
  final int trendVsPreviousPct;

  DashboardEconomy24hSummary({
    required this.crimeIncome,
    required this.jobIncome,
    required this.nightclubIncome,
    required this.propertySpend,
    required this.grossIncome,
    required this.netCashflow,
    required this.trendVsPreviousPct,
  });

  factory DashboardEconomy24hSummary.fromJson(Map<String, dynamic> json) {
    return DashboardEconomy24hSummary(
      crimeIncome: json['crimeIncome'] as int? ?? 0,
      jobIncome: json['jobIncome'] as int? ?? 0,
      nightclubIncome: json['nightclubIncome'] as int? ?? 0,
      propertySpend: json['propertySpend'] as int? ?? 0,
      grossIncome: json['grossIncome'] as int? ?? 0,
      netCashflow: json['netCashflow'] as int? ?? 0,
      trendVsPreviousPct: json['trendVsPreviousPct'] as int? ?? 0,
    );
  }
}

class DashboardActivity7dSummary {
  final int crimeAttempts;
  final int jobAttempts;
  final int vehicleThefts;
  final int travels;

  DashboardActivity7dSummary({
    required this.crimeAttempts,
    required this.jobAttempts,
    required this.vehicleThefts,
    required this.travels,
  });

  factory DashboardActivity7dSummary.fromJson(Map<String, dynamic> json) {
    return DashboardActivity7dSummary(
      crimeAttempts: json['crimeAttempts'] as int? ?? 0,
      jobAttempts: json['jobAttempts'] as int? ?? 0,
      vehicleThefts: json['vehicleThefts'] as int? ?? 0,
      travels: json['travels'] as int? ?? 0,
    );
  }
}

class DashboardOperationsSummary {
  final int activeCooldownCount;
  final int longestCooldownSeconds;
  final int activeDrugProductionsCount;
  final int nextDrugProductionEndsInSeconds;
  final int activeNightclubEventsCount;
  final int nextNightclubEventStartsInSeconds;
  final int activeVehicleCount;
  final int listedVehicleCount;
  final int inTransitVehicleCount;

  DashboardOperationsSummary({
    required this.activeCooldownCount,
    required this.longestCooldownSeconds,
    required this.activeDrugProductionsCount,
    required this.nextDrugProductionEndsInSeconds,
    required this.activeNightclubEventsCount,
    required this.nextNightclubEventStartsInSeconds,
    required this.activeVehicleCount,
    required this.listedVehicleCount,
    required this.inTransitVehicleCount,
  });

  factory DashboardOperationsSummary.fromJson(Map<String, dynamic> json) {
    return DashboardOperationsSummary(
      activeCooldownCount: json['activeCooldownCount'] as int? ?? 0,
      longestCooldownSeconds: json['longestCooldownSeconds'] as int? ?? 0,
      activeDrugProductionsCount: json['activeDrugProductionsCount'] as int? ?? 0,
      nextDrugProductionEndsInSeconds:
          json['nextDrugProductionEndsInSeconds'] as int? ?? 0,
      activeNightclubEventsCount:
          json['activeNightclubEventsCount'] as int? ?? 0,
      nextNightclubEventStartsInSeconds:
          json['nextNightclubEventStartsInSeconds'] as int? ?? 0,
      activeVehicleCount: json['activeVehicleCount'] as int? ?? 0,
      listedVehicleCount: json['listedVehicleCount'] as int? ?? 0,
      inTransitVehicleCount: json['inTransitVehicleCount'] as int? ?? 0,
    );
  }
}

class DashboardNotificationsSummary {
  final int unreadDirectMessages;
  final int supportNeedsReply;
  final int eventsLast24h;

  DashboardNotificationsSummary({
    required this.unreadDirectMessages,
    required this.supportNeedsReply,
    required this.eventsLast24h,
  });

  factory DashboardNotificationsSummary.fromJson(Map<String, dynamic> json) {
    return DashboardNotificationsSummary(
      unreadDirectMessages: json['unreadDirectMessages'] as int? ?? 0,
      supportNeedsReply: json['supportNeedsReply'] as int? ?? 0,
      eventsLast24h: json['eventsLast24h'] as int? ?? 0,
    );
  }
}

class DashboardRiskSummary {
  final int wantedLevel;
  final int fbiHeat;
  final int score;

  DashboardRiskSummary({
    required this.wantedLevel,
    required this.fbiHeat,
    required this.score,
  });

  factory DashboardRiskSummary.fromJson(Map<String, dynamic> json) {
    return DashboardRiskSummary(
      wantedLevel: json['wantedLevel'] as int? ?? 0,
      fbiHeat: json['fbiHeat'] as int? ?? 0,
      score: json['score'] as int? ?? 0,
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
  final DashboardEconomySummary? economy;
  final DashboardEconomy24hSummary? economy24h;
  final DashboardActivity7dSummary? activity7d;
  final DashboardOperationsSummary? operations;
  final DashboardNotificationsSummary? notifications;
  final DashboardRiskSummary? risk;
  final CrewWarDashboardSummary? crewWar;
  final TerritoryLeaderDashboardSummary? territoryLeaderStats;
  final TerritoryDramaDashboardSummary? territoryDrama;
  final VehicleOpsDashboardSummary? vehicleOps;
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
    this.economy,
    this.economy24h,
    this.activity7d,
    this.operations,
    this.notifications,
    this.risk,
    this.crewWar,
    this.territoryLeaderStats,
    this.territoryDrama,
    this.vehicleOps,
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
      economy: json['economy'] is Map<String, dynamic>
          ? DashboardEconomySummary.fromJson(
              json['economy'] as Map<String, dynamic>,
            )
          : null,
      economy24h: json['economy24h'] is Map<String, dynamic>
          ? DashboardEconomy24hSummary.fromJson(
              json['economy24h'] as Map<String, dynamic>,
            )
          : null,
      activity7d: json['activity7d'] is Map<String, dynamic>
          ? DashboardActivity7dSummary.fromJson(
              json['activity7d'] as Map<String, dynamic>,
            )
          : null,
      operations: json['operations'] is Map<String, dynamic>
          ? DashboardOperationsSummary.fromJson(
              json['operations'] as Map<String, dynamic>,
            )
          : null,
      notifications: json['notifications'] is Map<String, dynamic>
          ? DashboardNotificationsSummary.fromJson(
              json['notifications'] as Map<String, dynamic>,
            )
          : null,
      risk: json['risk'] is Map<String, dynamic>
          ? DashboardRiskSummary.fromJson(json['risk'] as Map<String, dynamic>)
          : null,
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
      territoryDrama: json['territoryDrama'] != null
          ? TerritoryDramaDashboardSummary.fromJson(
              json['territoryDrama'] as Map<String, dynamic>,
            )
          : null,
      vehicleOps: json['vehicleOps'] != null
          ? VehicleOpsDashboardSummary.fromJson(
              json['vehicleOps'] as Map<String, dynamic>,
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
