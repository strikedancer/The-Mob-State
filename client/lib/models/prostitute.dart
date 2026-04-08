import 'dart:convert';

class Prostitute {
  final int id;
  final int playerId;
  final String name;
  final int variant; // 1-10 for different images (6-10 = VIP)
  final DateTime recruitedAt;
  final DateTime lastEarningsAt;
  final String location; // 'street' or 'redlight'
  final int? redLightRoomId;
  final RedLightRoom? redLightRoom;

  // Leveling System
  final int experience;
  final int level;

  // Raid System
  final bool isBusted;
  final DateTime? bustedUntil;

  // Housing upkeep
  final int housingTier;
  final int housingRentPerDay;
  final DateTime? housingPaidUntil;
  final DateTime? lastWorkedAt;

  // Housing quality -> happiness
  final int happinessScore;
  final String happinessLabel;
  final double happinessEarningsMultiplier;

  Prostitute({
    required this.id,
    required this.playerId,
    required this.name,
    required this.variant,
    required this.recruitedAt,
    required this.lastEarningsAt,
    required this.location,
    this.redLightRoomId,
    this.redLightRoom,
    this.experience = 0,
    this.level = 1,
    this.isBusted = false,
    this.bustedUntil,
    this.housingTier = 1,
    this.housingRentPerDay = 35,
    this.housingPaidUntil,
    this.lastWorkedAt,
    this.happinessScore = 50,
    this.happinessLabel = 'stable',
    this.happinessEarningsMultiplier = 1.0,
  });

  factory Prostitute.fromJson(Map<String, dynamic> json) {
    return Prostitute(
      id: json['id'] as int,
      playerId: json['playerId'] as int,
      name: json['name'] as String,
      variant: json['variant'] as int,
      recruitedAt: DateTime.parse(json['recruitedAt'] as String),
      lastEarningsAt: DateTime.parse(json['lastEarningsAt'] as String),
      location: json['location'] as String,
      redLightRoomId: json['redLightRoomId'] as int?,
      redLightRoom: json['redLightRoom'] != null
          ? RedLightRoom.fromJson(json['redLightRoom'] as Map<String, dynamic>)
          : null,
      experience: json['experience'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      isBusted: json['isBusted'] as bool? ?? false,
      bustedUntil: json['bustedUntil'] != null
          ? DateTime.parse(json['bustedUntil'] as String)
          : null,
      housingTier: json['housingTier'] as int? ?? 1,
      housingRentPerDay: json['housingRentPerDay'] as int? ?? 35,
      housingPaidUntil: json['housingPaidUntil'] != null
          ? DateTime.parse(json['housingPaidUntil'] as String)
          : null,
      lastWorkedAt: json['lastWorkedAt'] != null
          ? DateTime.parse(json['lastWorkedAt'] as String)
          : null,
      happinessScore: json['happinessScore'] as int? ?? 50,
      happinessLabel: json['happinessLabel'] as String? ?? 'stable',
      happinessEarningsMultiplier:
          (json['happinessEarningsMultiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'name': name,
      'variant': variant,
      'recruitedAt': recruitedAt.toIso8601String(),
      'lastEarningsAt': lastEarningsAt.toIso8601String(),
      'location': location,
      'redLightRoomId': redLightRoomId,
      'redLightRoom': redLightRoom?.toJson(),
      'experience': experience,
      'level': level,
      'isBusted': isBusted,
      'bustedUntil': bustedUntil?.toIso8601String(),
      'housingTier': housingTier,
      'housingRentPerDay': housingRentPerDay,
      'housingPaidUntil': housingPaidUntil?.toIso8601String(),
      'lastWorkedAt': lastWorkedAt?.toIso8601String(),
      'happinessScore': happinessScore,
      'happinessLabel': happinessLabel,
      'happinessEarningsMultiplier': happinessEarningsMultiplier,
    };
  }

  bool get isOnStreet => location == 'street';
  bool get isInRedLight => location == 'redlight';
  bool get isVipProstitute => variant >= 6 && variant <= 10;

  // Leveling helpers
  double get levelProgress {
    const xpPerLevel = 100;
    final xpInCurrentLevel = experience % xpPerLevel;
    return xpInCurrentLevel / xpPerLevel;
  }

  int get xpToNextLevel {
    const xpPerLevel = 100;
    return xpPerLevel - (experience % xpPerLevel);
  }

  double get earningsMultiplier {
    return 1.0 + ((level - 1) * 0.05); // 5% boost per level
  }

  double get vipEarningsMultiplier {
    return isVipProstitute ? 1.5 : 1.0;
  }

  // Raid helpers
  bool get isCurrentlyBusted {
    if (!isBusted) return false;
    if (bustedUntil == null) return false;
    return DateTime.now().isBefore(bustedUntil!);
  }

  Duration? get bustTimeRemaining {
    if (!isCurrentlyBusted || bustedUntil == null) return null;
    return bustedUntil!.difference(DateTime.now());
  }

  Duration? get housingTimeRemaining {
    if (housingPaidUntil == null) return null;
    return housingPaidUntil!.difference(DateTime.now());
  }

  bool get isHousingExpired {
    final remaining = housingTimeRemaining;
    return remaining == null || remaining.isNegative;
  }

  bool get isHousingAtRisk {
    final remaining = housingTimeRemaining;
    if (remaining == null || remaining.isNegative) return true;
    return remaining.inDays <= 2;
  }

  int get weeklyHousingCost => housingRentPerDay * 7;

  int get happinessEarningsBonusPercent =>
      ((happinessEarningsMultiplier - 1) * 100).round();

  // Calculates hourly rate based on location, level, and tier
  double calculateHourlyRate({int tier = 1}) {
    if (isCurrentlyBusted) return 0;

    double baseRate;
    if (isOnStreet) {
      baseRate = 40; // €40 on street
    } else {
      // Red light earnings based on tier
      switch (tier) {
        case 2:
          baseRate = 100 - 30; // €100 gross - €30 rent = €70 net
          break;
        case 3:
          baseRate = 150 - 50; // €150 gross - €50 rent = €100 net
          break;
        default:
          baseRate = 75 - 20; // €75 gross - €20 rent = €55 net
      }
    }

    return baseRate * earningsMultiplier * vipEarningsMultiplier;
  }

  String getImagePath() {
    switch (variant) {
      case 1:
        return 'assets/images/prostitution/portraits/prostitute_blonde_red_dress.png';
      case 2:
        return 'assets/images/prostitution/portraits/prostitute_brunette_black_lingerie.png';
      case 3:
        return 'assets/images/prostitution/portraits/prostitute_redhead_purple_latex.png';
      case 4:
        return 'assets/images/prostitution/portraits/prostitute_asian_cheongsam.png';
      case 5:
        return 'assets/images/prostitution/portraits/prostitute_latina_green_dress.png';
      case 6:
        return 'assets/images/prostitution/vip_portraits/vip_prostitute_platinum_gala.png';
      case 7:
        return 'assets/images/prostitution/vip_portraits/vip_prostitute_velvet_executive.png';
      case 8:
        return 'assets/images/prostitution/vip_portraits/vip_prostitute_redcarpet_icon.png';
      case 9:
        return 'assets/images/prostitution/vip_portraits/vip_prostitute_eastern_luxe.png';
      case 10:
        return 'assets/images/prostitution/vip_portraits/vip_prostitute_emerald_penthouse.png';
      default:
        return 'assets/images/prostitution/portraits/prostitute_blonde_red_dress.png';
    }
  }
}

class ProstituteStats {
  final int totalCount;
  final int streetCount;
  final int redlightCount;
  final int bustedCount;
  final int potentialEarnings;
  final Map<String, int> hourlyRate;

  ProstituteStats({
    required this.totalCount,
    required this.streetCount,
    required this.redlightCount,
    this.bustedCount = 0,
    required this.potentialEarnings,
    required this.hourlyRate,
  });

  factory ProstituteStats.fromJson(Map<String, dynamic> json) {
    return ProstituteStats(
      totalCount: json['totalCount'] as int,
      streetCount: json['streetCount'] as int,
      redlightCount: json['redlightCount'] as int,
      bustedCount: json['bustedCount'] as int? ?? 0,
      potentialEarnings: json['potentialEarnings'] as int,
      hourlyRate: Map<String, int>.from(json['hourlyRate'] as Map),
    );
  }

  int get streetHourlyRate => hourlyRate['street'] ?? 40;
  int get redlightHourlyRate => hourlyRate['redlight'] ?? 55;
}

class ProstituteHousingSummary {
  final int totalWeeklyRent;
  final int atRiskCount;
  final int safeCount;
  final int graceDays;
  final int totalCapacity;
  final int occupiedSlots;
  final int freeSlots;
  final int residentialProperties;
  final double averageResidentialUpgrade;
  final int housingHappinessBonusPercent;
  final bool betrayalTriggered;
  final String? betrayalMessage;
  final int seizedDrugsGrams;
  final int nightclubLicensesRevoked;

  ProstituteHousingSummary({
    required this.totalWeeklyRent,
    required this.atRiskCount,
    required this.safeCount,
    required this.graceDays,
    required this.totalCapacity,
    required this.occupiedSlots,
    required this.freeSlots,
    required this.residentialProperties,
    required this.averageResidentialUpgrade,
    required this.housingHappinessBonusPercent,
    this.betrayalTriggered = false,
    this.betrayalMessage,
    this.seizedDrugsGrams = 0,
    this.nightclubLicensesRevoked = 0,
  });

  factory ProstituteHousingSummary.fromJson(Map<String, dynamic> json) {
    return ProstituteHousingSummary(
      totalWeeklyRent: json['totalWeeklyRent'] as int? ?? 0,
      atRiskCount: json['atRiskCount'] as int? ?? 0,
      safeCount: json['safeCount'] as int? ?? 0,
      graceDays: json['graceDays'] as int? ?? 7,
      totalCapacity: json['totalCapacity'] as int? ?? 0,
      occupiedSlots: json['occupiedSlots'] as int? ?? 0,
      freeSlots: json['freeSlots'] as int? ?? 0,
      residentialProperties: json['residentialProperties'] as int? ?? 0,
      averageResidentialUpgrade:
          (json['averageResidentialUpgrade'] as num?)?.toDouble() ?? 0,
      housingHappinessBonusPercent:
          json['housingHappinessBonusPercent'] as int? ?? 0,
      betrayalTriggered: json['betrayalTriggered'] as bool? ?? false,
      betrayalMessage: json['betrayalMessage'] as String?,
      seizedDrugsGrams: json['seizedDrugsGrams'] as int? ?? 0,
      nightclubLicensesRevoked: json['nightclubLicensesRevoked'] as int? ?? 0,
    );
  }
}

class RedLightDistrict {
  final int id;
  final String countryCode;
  final int? ownerId;
  final int purchasePrice;
  final DateTime? purchasedAt;
  final int roomCount;
  final int tier;
  final int securityLevel;
  final Map<String, dynamic>? owner;
  final List<RedLightRoom>? rooms;
  final DistrictStats? stats;

  RedLightDistrict({
    required this.id,
    required this.countryCode,
    this.ownerId,
    required this.purchasePrice,
    this.purchasedAt,
    required this.roomCount,
    this.tier = 1,
    this.securityLevel = 0,
    this.owner,
    this.rooms,
    this.stats,
  });

  factory RedLightDistrict.fromJson(Map<String, dynamic> json) {
    return RedLightDistrict(
      id: json['id'] as int,
      countryCode: json['countryCode'] as String,
      ownerId: json['ownerId'] as int?,
      purchasePrice: json['purchasePrice'] as int,
      purchasedAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'] as String)
          : null,
      roomCount: json['roomCount'] as int,
      tier: json['tier'] as int? ?? 1,
      securityLevel: json['securityLevel'] as int? ?? 0,
      owner: json['owner'] as Map<String, dynamic>?,
      rooms: json['rooms'] != null
          ? (json['rooms'] as List)
                .map(
                  (room) => RedLightRoom.fromJson(room as Map<String, dynamic>),
                )
                .toList()
          : null,
      stats: json['stats'] != null
          ? DistrictStats.fromJson(json['stats'] as Map<String, dynamic>)
          : null,
    );
  }

  String get tierName {
    switch (tier) {
      case 2:
        return 'Luxury';
      case 3:
        return 'VIP';
      default:
        return 'Basic';
    }
  }

  bool get canUpgradeTier => tier < 3;
  bool get canUpgradeSecurity => securityLevel < 3;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'countryCode': countryCode,
      'ownerId': ownerId,
      'purchasePrice': purchasePrice,
      'purchasedAt': purchasedAt?.toIso8601String(),
      'roomCount': roomCount,
      'tier': tier,
      'securityLevel': securityLevel,
      'owner': owner,
      'rooms': rooms?.map((r) => r.toJson()).toList(),
      'stats': stats?.toJson(),
    };
  }

  bool get isAvailable => ownerId == null;
  bool get isOwned => ownerId != null;
}

class RedLightRoom {
  final int id;
  final int redLightDistrictId;
  final int roomNumber;
  final bool occupied;
  final DateTime lastEarningsAt;
  final int tier;
  final Prostitute? prostitute;

  RedLightRoom({
    required this.id,
    required this.redLightDistrictId,
    required this.roomNumber,
    required this.occupied,
    required this.lastEarningsAt,
    this.tier = 1,
    this.prostitute,
  });

  factory RedLightRoom.fromJson(Map<String, dynamic> json) {
    return RedLightRoom(
      id: json['id'] as int,
      redLightDistrictId: json['redLightDistrictId'] as int,
      roomNumber: json['roomNumber'] as int,
      occupied: json['occupied'] as bool,
      lastEarningsAt: DateTime.parse(json['lastEarningsAt'] as String),
      tier: json['tier'] as int? ?? 1,
      prostitute: json['prostitute'] != null
          ? Prostitute.fromJson(json['prostitute'] as Map<String, dynamic>)
          : null,
    );
  }

  String get tierName {
    switch (tier) {
      case 2:
        return 'Luxury';
      case 3:
        return 'VIP';
      default:
        return 'Basic';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'redLightDistrictId': redLightDistrictId,
      'roomNumber': roomNumber,
      'occupied': occupied,
      'lastEarningsAt': lastEarningsAt.toIso8601String(),
      'tier': tier,
      'prostitute': prostitute?.toJson(),
    };
  }
}

class DistrictStats {
  final int districtId;
  final String countryCode;
  final int totalRooms;
  final int occupiedRooms;
  final int availableRooms;
  final int occupancyRate;
  final int hourlyIncome;
  final int tenantCount;
  final List<String> tenants;

  DistrictStats({
    required this.districtId,
    required this.countryCode,
    required this.totalRooms,
    required this.occupiedRooms,
    required this.availableRooms,
    required this.occupancyRate,
    required this.hourlyIncome,
    required this.tenantCount,
    required this.tenants,
  });

  factory DistrictStats.fromJson(Map<String, dynamic> json) {
    return DistrictStats(
      districtId: json['districtId'] as int,
      countryCode: json['countryCode'] as String,
      totalRooms: json['totalRooms'] as int,
      occupiedRooms: json['occupiedRooms'] as int,
      availableRooms: json['availableRooms'] as int,
      occupancyRate: json['occupancyRate'] as int,
      hourlyIncome: json['hourlyIncome'] as int,
      tenantCount: json['tenantCount'] as int,
      tenants: List<String>.from(json['tenants'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'districtId': districtId,
      'countryCode': countryCode,
      'totalRooms': totalRooms,
      'occupiedRooms': occupiedRooms,
      'availableRooms': availableRooms,
      'occupancyRate': occupancyRate,
      'hourlyIncome': hourlyIncome,
      'tenantCount': tenantCount,
      'tenants': tenants,
    };
  }
}

// ============================================================================
// VIP EVENTS SYSTEM (Phase 2)
// ============================================================================

class VipEvent {
  final int id;
  final String title;
  final String? description;
  final String
  eventType; // celebrity_visit, bachelor_party, convention, festival
  final String countryCode;
  final DateTime startTime;
  final DateTime endTime;
  final double bonusMultiplier;
  final int minLevelRequired;
  final int maxParticipants;
  final int currentParticipants;
  final DateTime createdAt;

  VipEvent({
    required this.id,
    required this.title,
    this.description,
    required this.eventType,
    required this.countryCode,
    required this.startTime,
    required this.endTime,
    required this.bonusMultiplier,
    required this.minLevelRequired,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.createdAt,
  });

  factory VipEvent.fromJson(Map<String, dynamic> json) {
    return VipEvent(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventType: json['eventType'] as String,
      countryCode: json['countryCode'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      bonusMultiplier: (json['bonusMultiplier'] as num).toDouble(),
      minLevelRequired: json['minLevelRequired'] as int,
      maxParticipants: json['maxParticipants'] as int,
      currentParticipants: json['currentParticipants'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventType': eventType,
      'countryCode': countryCode,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'bonusMultiplier': bonusMultiplier,
      'minLevelRequired': minLevelRequired,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Helper: Is event currently active?
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  // Helper: Is event upcoming (not started)?
  bool get isUpcoming {
    return DateTime.now().isBefore(startTime);
  }

  // Helper: Has event ended?
  bool get isEnded {
    return DateTime.now().isAfter(endTime);
  }

  // Helper: Is event full?
  bool get isFull {
    return currentParticipants >= maxParticipants;
  }

  // Helper: Time remaining until event starts or ends
  Duration? get timeRemaining {
    final now = DateTime.now();
    if (isUpcoming) {
      return startTime.difference(now);
    } else if (isActive) {
      return endTime.difference(now);
    }
    return null;
  }

  // Helper: Event type name for display
  String get eventTypeName {
    switch (eventType) {
      case 'celebrity_visit':
        return 'Celebrity Visit';
      case 'bachelor_party':
        return 'Bachelor Party';
      case 'convention':
        return 'Convention';
      case 'festival':
        return 'Festival';
      default:
        return eventType;
    }
  }

  // Helper: Event type icon
  String get eventTypeIcon {
    switch (eventType) {
      case 'celebrity_visit':
        return '⭐';
      case 'bachelor_party':
        return '🎉';
      case 'convention':
        return '💼';
      case 'festival':
        return '🎵';
      default:
        return '📅';
    }
  }

  // Helper: Formatted bonus (e.g., "2.5x")
  String get bonusText {
    return '${bonusMultiplier.toStringAsFixed(1)}x';
  }
}

class EventParticipation {
  final int id;
  final int eventId;
  final int playerId;
  final int prostituteId;
  final double earnings;
  final String status; // active, completed, cancelled
  final DateTime participatedAt;
  final DateTime? completedAt;
  final VipEvent? event;
  final Prostitute? prostitute;

  EventParticipation({
    required this.id,
    required this.eventId,
    required this.playerId,
    required this.prostituteId,
    required this.earnings,
    required this.status,
    required this.participatedAt,
    this.completedAt,
    this.event,
    this.prostitute,
  });

  factory EventParticipation.fromJson(Map<String, dynamic> json) {
    return EventParticipation(
      id: json['id'] as int,
      eventId: json['eventId'] as int,
      playerId: json['playerId'] as int,
      prostituteId: json['prostituteId'] as int,
      earnings: (json['earnings'] as num).toDouble(),
      status: json['status'] as String,
      participatedAt: DateTime.parse(json['participatedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      event: json['event'] != null
          ? VipEvent.fromJson(json['event'] as Map<String, dynamic>)
          : null,
      prostitute: json['prostitute'] != null
          ? Prostitute.fromJson(json['prostitute'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'playerId': playerId,
      'prostituteId': prostituteId,
      'earnings': earnings,
      'status': status,
      'participatedAt': participatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'event': event?.toJson(),
      'prostitute': prostitute?.toJson(),
    };
  }

  // Helper: Is participation active?
  bool get isActive {
    return status == 'active';
  }

  // Helper: Is participation completed?
  bool get isCompleted {
    return status == 'completed';
  }

  // Helper: Is participation cancelled?
  bool get isCancelled {
    return status == 'cancelled';
  }

  // Helper: Formatted earnings
  String get earningsText {
    return '€${earnings.toStringAsFixed(0)}';
  }
}

class LeaderboardEntry {
  final int rank;
  final int playerId;
  final String username;
  final double totalEarnings;
  final int totalProstitutes;
  final int totalDistricts;
  final int highestLevel;
  final bool isCurrentPlayer;

  LeaderboardEntry({
    required this.rank,
    required this.playerId,
    required this.username,
    required this.totalEarnings,
    required this.totalProstitutes,
    required this.totalDistricts,
    required this.highestLevel,
    required this.isCurrentPlayer,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      rank: json['rank'] as int,
      playerId: json['playerId'] as int,
      username: json['username'] as String,
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      totalProstitutes: json['totalProstitutes'] as int,
      totalDistricts: json['totalDistricts'] as int,
      highestLevel: json['highestLevel'] as int,
      isCurrentPlayer: json['isCurrentPlayer'] as bool? ?? false,
    );
  }

  String get earningsText => '€${totalEarnings.toStringAsFixed(0)}';
}

class ProstitutionAchievement {
  final int id;
  final String achievementType;
  final Map<String, dynamic>? achievementData;
  final DateTime unlockedAt;

  ProstitutionAchievement({
    required this.id,
    required this.achievementType,
    required this.achievementData,
    required this.unlockedAt,
  });

  factory ProstitutionAchievement.fromJson(Map<String, dynamic> json) {
    return ProstitutionAchievement(
      id: json['id'] as int,
      achievementType: json['achievementType'] as String,
      achievementData: _parseAchievementData(json['achievementData']),
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
    );
  }

  static Map<String, dynamic>? _parseAchievementData(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map((key, value) => MapEntry('$key', value));
    }
    if (raw is String && raw.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) {
          return decoded.map((key, value) => MapEntry('$key', value));
        }
      } catch (_) {
        // Keep backward compatibility by treating invalid JSON metadata as absent.
      }
    }
    return null;
  }

  String get displayName {
    switch (achievementType) {
      case 'first_steps':
        return 'First Steps';
      case 'empire_builder':
        return 'Empire Builder';
      case 'leveling_master':
        return 'Leveling Master';
      case 'millionaire':
        return 'Millionaire';
      case 'vip_service':
        return 'VIP Service';
      default:
        return achievementType;
    }
  }
}

class Rivalry {
  final int id;
  final int playerId;
  final int rivalPlayerId;
  final int rivalryScore;
  final DateTime startedAt;
  final DateTime? lastAttackAt;
  final String rivalUsername;
  final int rivalRank;

  Rivalry({
    required this.id,
    required this.playerId,
    required this.rivalPlayerId,
    required this.rivalryScore,
    required this.startedAt,
    required this.lastAttackAt,
    required this.rivalUsername,
    required this.rivalRank,
  });

  factory Rivalry.fromJson(Map<String, dynamic> json) {
    final rivalPlayer = (json['rivalPlayer'] as Map<String, dynamic>? ?? {});

    return Rivalry(
      id: json['id'] as int,
      playerId: json['playerId'] as int,
      rivalPlayerId: json['rivalPlayerId'] as int,
      rivalryScore: json['rivalryScore'] as int? ?? 0,
      startedAt: DateTime.parse(json['startedAt'] as String),
      lastAttackAt: json['lastAttackAt'] != null
          ? DateTime.parse(json['lastAttackAt'] as String)
          : null,
      rivalUsername: rivalPlayer['username'] as String? ?? 'Unknown',
      rivalRank: rivalPlayer['rank'] as int? ?? 1,
    );
  }
}

class SabotageHistoryItem {
  final int id;
  final int attackerId;
  final int victimId;
  final String actionType;
  final bool success;
  final double cost;
  final String? impactDescription;
  final DateTime createdAt;
  final String attackerUsername;
  final String victimUsername;

  SabotageHistoryItem({
    required this.id,
    required this.attackerId,
    required this.victimId,
    required this.actionType,
    required this.success,
    required this.cost,
    required this.impactDescription,
    required this.createdAt,
    required this.attackerUsername,
    required this.victimUsername,
  });

  factory SabotageHistoryItem.fromJson(Map<String, dynamic> json) {
    final attacker = (json['attacker'] as Map<String, dynamic>? ?? {});
    final victim = (json['victim'] as Map<String, dynamic>? ?? {});

    return SabotageHistoryItem(
      id: json['id'] as int,
      attackerId: json['attackerId'] as int,
      victimId: json['victimId'] as int,
      actionType: json['actionType'] as String,
      success: json['success'] as bool? ?? false,
      cost: (json['cost'] as num).toDouble(),
      impactDescription: json['impactDescription'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      attackerUsername: attacker['username'] as String? ?? 'Unknown',
      victimUsername: victim['username'] as String? ?? 'Unknown',
    );
  }
}
