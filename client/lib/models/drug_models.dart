import 'package:flutter/material.dart';

class DrugDefinition {
  final String id;
  final String name;
  final String displayName;
  final String type;
  final String description;
  final String descriptionEn;
  final int productionTime; // in minutes
  final Map<String, int> materials;
  final int yieldMin;
  final int yieldMax;
  final int basePrice;
  final int requiredRank;
  final Map<String, int> countryPricing;

  DrugDefinition({
    required this.id,
    required this.name,
    required this.displayName,
    required this.type,
    required this.description,
    required this.descriptionEn,
    required this.productionTime,
    required this.materials,
    required this.yieldMin,
    required this.yieldMax,
    required this.basePrice,
    required this.requiredRank,
    required this.countryPricing,
  });

  factory DrugDefinition.fromJson(Map<String, dynamic> json) {
    return DrugDefinition(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      displayName: json['displayName'] ?? '',
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      descriptionEn: json['descriptionEn'] ?? json['description'] ?? '',
      productionTime: json['productionTime'] ?? 0,
      materials: Map<String, int>.from(json['materials'] ?? {}),
      yieldMin: json['yieldMin'] ?? 0,
      yieldMax: json['yieldMax'] ?? 0,
      basePrice: json['basePrice'] ?? 0,
      requiredRank: json['requiredRank'] ?? 0,
      countryPricing: Map<String, int>.from(json['countryPricing'] ?? {}),
    );
  }

  String getImagePath() {
    return 'assets/images/drugs/$id.png';
  }

  int getPriceForCountry(String country) {
    return countryPricing[country] ?? basePrice;
  }

  String getProductionTimeFormatted({bool nl = true}) {
    final hourWord = nl ? 'uur' : 'hr';
    if (productionTime < 60) {
      return '$productionTime min';
    } else {
      final hours = (productionTime / 60).floor();
      final mins = productionTime % 60;
      if (mins == 0) {
        return '$hours $hourWord';
      }
      return '$hours $hourWord $mins min';
    }
  }
}

class MaterialDefinition {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category;

  MaterialDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  factory MaterialDefinition.fromJson(Map<String, dynamic> json) {
    return MaterialDefinition(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      category: json['category'] ?? '',
    );
  }

  String getImagePath() {
    return 'assets/images/materials/$id.png';
  }
}

class PlayerMaterial {
  final int id;
  final String materialId;
  final String name;
  final String description;
  final int quantity;
  final int price;
  final String country;
  final String location; // depot | carried
  final int slots;

  PlayerMaterial({
    required this.id,
    required this.materialId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    this.country = '',
    this.location = 'depot',
    this.slots = 0,
  });

  bool get isCarried => location == 'carried';

  factory PlayerMaterial.fromJson(Map<String, dynamic> json) {
    return PlayerMaterial(
      id: json['id'] ?? 0,
      materialId: json['materialId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      country: (json['country'] ?? '').toString(),
      location: (json['location'] ?? 'depot').toString(),
      slots: (json['slots'] as num?)?.toInt() ?? 0,
    );
  }

  String getImagePath() {
    return 'assets/images/materials/$materialId.png';
  }
}

class PlayerMaterialsSnapshot {
  final String currentCountry;
  final List<PlayerMaterial> materials;
  final List<PlayerMaterial> depot;
  final List<PlayerMaterial> carried;
  final int backpackCapacity;
  final int backpackUsed;
  final int materialSlots;
  final int unitsPerSlot;

  PlayerMaterialsSnapshot({
    required this.currentCountry,
    required this.materials,
    required this.depot,
    required this.carried,
    required this.backpackCapacity,
    required this.backpackUsed,
    required this.materialSlots,
    required this.unitsPerSlot,
  });

  factory PlayerMaterialsSnapshot.empty() => PlayerMaterialsSnapshot(
        currentCountry: '',
        materials: const [],
        depot: const [],
        carried: const [],
        backpackCapacity: 5,
        backpackUsed: 0,
        materialSlots: 0,
        unitsPerSlot: 5,
      );

  factory PlayerMaterialsSnapshot.fromJson(Map<String, dynamic> json) {
    final materialsJson = (json['materials'] as List?) ?? const [];
    final materials = materialsJson
        .whereType<Map>()
        .map((e) => PlayerMaterial.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    final backpack = (json['backpack'] as Map?)?.cast<String, dynamic>() ?? {};
    return PlayerMaterialsSnapshot(
      currentCountry: (json['currentCountry'] ?? '').toString(),
      materials: materials,
      depot: materials.where((m) => !m.isCarried).toList(),
      carried: materials.where((m) => m.isCarried).toList(),
      backpackCapacity: (backpack['capacity'] as num?)?.toInt() ?? 5,
      backpackUsed: (backpack['used'] as num?)?.toInt() ?? 0,
      materialSlots: (backpack['materialSlots'] as num?)?.toInt() ?? 0,
      unitsPerSlot: (backpack['unitsPerSlot'] as num?)?.toInt() ?? 5,
    );
  }

  int depotQty(String materialId, {String? country}) {
    final c = country ?? currentCountry;
    return materials
        .where((m) => !m.isCarried && m.materialId == materialId && m.country == c)
        .fold<int>(0, (sum, m) => sum + m.quantity);
  }

  int carriedQty(String materialId) {
    return materials
        .where((m) => m.isCarried && m.materialId == materialId)
        .fold<int>(0, (sum, m) => sum + m.quantity);
  }

  /// Materials usable for production here: local depot + backpack.
  int availableForProduction(String materialId) {
    return depotQty(materialId) + carriedQty(materialId);
  }
}

class DrugProduction {
  final int id;
  final String drugType;
  final String drugName;
  final int quantity;
  final DateTime startedAt;
  final DateTime finishesAt;
  final bool isReady;
  final int timeRemaining; // in milliseconds
  final String quality;
  final String qualityLabel;
  final String qualityColor;
  final double qualityMultiplier;
  final int? facilityId;
  final String? incidentNote;
  final String? incidentSeverity;
  final String? incidentType;
  final bool raidPending;
  final int? raidLossPercent;
  final int? raidCashFine;
  final int? raidDowntimeHours;

  DrugProduction({
    required this.id,
    required this.drugType,
    required this.drugName,
    required this.quantity,
    required this.startedAt,
    required this.finishesAt,
    required this.isReady,
    required this.timeRemaining,
    this.quality = 'C',
    this.qualityLabel = 'Normaal',
    this.qualityColor = '#888888',
    this.qualityMultiplier = 1.0,
    this.facilityId,
    this.incidentNote,
    this.incidentSeverity,
    this.incidentType,
    this.raidPending = false,
    this.raidLossPercent,
    this.raidCashFine,
    this.raidDowntimeHours,
  });

  factory DrugProduction.fromJson(Map<String, dynamic> json) {
    return DrugProduction(
      id: json['id'] ?? 0,
      drugType: json['drugType'] ?? '',
      drugName: json['drugName'] ?? '',
      quantity: json['quantity'] ?? 0,
      startedAt: DateTime.parse(json['startedAt']),
      finishesAt: DateTime.parse(json['finishesAt']),
      isReady: json['isReady'] ?? false,
      timeRemaining: json['timeRemaining'] ?? 0,
      quality: json['quality'] ?? 'C',
      qualityLabel: json['qualityLabel'] ?? 'Normaal',
      qualityColor: json['qualityColor'] ?? '#888888',
      qualityMultiplier: (json['qualityMultiplier'] ?? 1.0).toDouble(),
      facilityId: json['facilityId'],
      incidentNote: json['incidentNote'],
      incidentSeverity: json['incidentSeverity'],
      incidentType: json['incidentType'],
      raidPending: json['raidPending'] == true,
      raidLossPercent: (json['raid'] is Map)
          ? (json['raid']['lossPercent'] as num?)?.toInt()
          : null,
      raidCashFine: (json['raid'] is Map)
          ? (json['raid']['cashFine'] as num?)?.toInt()
          : null,
      raidDowntimeHours: (json['raid'] is Map)
          ? (json['raid']['downtimeHours'] as num?)?.toInt()
          : null,
    );
  }

  String getImagePath() {
    return 'assets/images/drugs/$drugType.png';
  }

  String getTimeRemainingFormatted() {
    if (isReady) return 'Klaar!';

    final duration = Duration(milliseconds: timeRemaining);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}u ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  double getProgress() {
    final total = finishesAt.difference(startedAt).inMilliseconds;
    final elapsed = total - timeRemaining;
    return elapsed / total;
  }
}

class DrugInventory {
  final int id;
  final String drugType;
  final String drugName;
  final String quality;
  final String qualityLabel;
  final String qualityColor;
  final double qualityMultiplier;
  final int quantity;
  final int basePrice;
  final int effectivePrice;
  final bool ownProduction;
  final int nightclubBonusPercent;
  final String? bestCountry;
  final String? bestCountryLabel;
  final int bestCountryPrice;
  final int bestCountryPct;

  DrugInventory({
    required this.id,
    required this.drugType,
    required this.drugName,
    this.quality = 'C',
    this.qualityLabel = 'Normaal',
    this.qualityColor = '#888888',
    this.qualityMultiplier = 1.0,
    required this.quantity,
    required this.basePrice,
    int? effectivePrice,
    this.ownProduction = false,
    this.nightclubBonusPercent = 0,
    this.bestCountry,
    this.bestCountryLabel,
    this.bestCountryPrice = 0,
    this.bestCountryPct = 0,
  }) : effectivePrice = effectivePrice ?? basePrice;

  factory DrugInventory.fromJson(Map<String, dynamic> json) {
    return DrugInventory(
      id: json['id'] ?? 0,
      drugType: json['drugType'] ?? '',
      drugName: json['drugName'] ?? '',
      quality: json['quality'] ?? 'C',
      qualityLabel: json['qualityLabel'] ?? 'Normaal',
      qualityColor: json['qualityColor'] ?? '#888888',
      qualityMultiplier: (json['qualityMultiplier'] ?? 1.0).toDouble(),
      quantity: json['quantity'] ?? 0,
      basePrice: json['basePrice'] ?? 0,
      effectivePrice: json['effectivePrice'] ?? json['basePrice'] ?? 0,
      ownProduction: json['ownProduction'] == true,
      nightclubBonusPercent: json['nightclubBonusPercent'] ?? 0,
      bestCountry: json['bestCountry'] as String?,
      bestCountryLabel: json['bestCountryLabel'] as String?,
      bestCountryPrice: json['bestCountryPrice'] ?? 0,
      bestCountryPct: json['bestCountryPct'] ?? 0,
    );
  }

  String getImagePath() {
    return 'assets/images/drugs/$drugType.png';
  }
}

class DrugFacilityUpgradeInfo {
  final String upgradeType;
  final int level;
  final String label;
  final double qualityBonus;
  final double yieldBonus;
  final double speedBonus;
  final int nextLevelCost;
  final bool isMaxLevel;

  DrugFacilityUpgradeInfo({
    required this.upgradeType,
    required this.level,
    required this.label,
    required this.qualityBonus,
    required this.yieldBonus,
    required this.speedBonus,
    required this.nextLevelCost,
    required this.isMaxLevel,
  });

  factory DrugFacilityUpgradeInfo.fromJson(Map<String, dynamic> json) {
    return DrugFacilityUpgradeInfo(
      upgradeType: json['upgradeType'] ?? '',
      level: json['level'] ?? 1,
      label: json['label'] ?? '',
      qualityBonus: (json['qualityBonus'] ?? 0.0).toDouble(),
      yieldBonus: (json['yieldBonus'] ?? 0.0).toDouble(),
      speedBonus: (json['speedBonus'] ?? 0.0).toDouble(),
      nextLevelCost: json['nextLevelCost'] ?? 0,
      isMaxLevel: json['isMaxLevel'] ?? false,
    );
  }
}

class DrugFacilityInfo {
  final int id;
  final String facilityType;
  final String displayName;
  final int slots;
  final int activeProductions;
  final DateTime purchasedAt;
  final Map<String, int> upgrades;
  final double qualityBonus;
  final double yieldBonus;
  final double speedBonus;
  final int nextSlotCost;
  final bool isMaxSlots;
  final bool autoSaleEnabled;
  final DateTime? downtimeUntil;
  final Map<String, dynamic>? nextSlotEducation;

  DrugFacilityInfo({
    required this.id,
    required this.facilityType,
    required this.displayName,
    required this.slots,
    required this.activeProductions,
    required this.purchasedAt,
    required this.upgrades,
    required this.qualityBonus,
    required this.yieldBonus,
    required this.speedBonus,
    required this.nextSlotCost,
    required this.isMaxSlots,
    this.autoSaleEnabled = false,
    this.downtimeUntil,
    this.nextSlotEducation,
  });

  factory DrugFacilityInfo.fromJson(Map<String, dynamic> json) {
    final multipliers = json['multipliers'] as Map<String, dynamic>? ?? const {};
    final slots = json['slots'] ?? 1;
    final maxSlots = json['maxSlots'] ?? slots;
    return DrugFacilityInfo(
      id: json['id'] ?? 0,
      facilityType: json['facilityType'] ?? '',
      displayName: json['displayName'] ?? '',
      slots: slots,
      activeProductions: json['activeProductions'] ?? 0,
      purchasedAt: DateTime.tryParse(json['purchasedAt'] ?? '') ?? DateTime.now(),
      upgrades: Map<String, int>.from(json['upgrades'] ?? const {}),
      qualityBonus: (multipliers['qualityBonus'] ?? 0.0).toDouble(),
      yieldBonus: (multipliers['yieldBonus'] ?? 1.0).toDouble(),
      speedBonus: (multipliers['speedBonus'] ?? 0.0).toDouble(),
      nextSlotCost: json['nextSlotCost'] ?? 0,
      isMaxSlots: slots >= maxSlots,
      autoSaleEnabled: json['autoSaleEnabled'] == true,
      downtimeUntil: json['downtimeUntil'] != null
          ? DateTime.tryParse(json['downtimeUntil'].toString())
          : null,
      nextSlotEducation: json['nextSlotEducation'] as Map<String, dynamic>?,
    );
  }

  String get emoji {
    switch (facilityType) {
      case 'greenhouse': return '🌿';
      case 'mushroom_farm': return '🍄';
      case 'crack_kitchen': return '🔥';
      case 'darkweb_storefront': return '🕸️';
      default: return '🔬';
    }
  }
}

// ─── Market prices ────────────────────────────────────────────────────────────

class DrugMarketPrice {
  final String drugId;
  final double multiplier;
  final String trend; // 'up' | 'down' | 'stable'

  DrugMarketPrice({required this.drugId, required this.multiplier, required this.trend});

  factory DrugMarketPrice.fromJson(String id, Map<String, dynamic> json) {
    return DrugMarketPrice(
      drugId: id,
      multiplier: (json['multiplier'] ?? 1.0).toDouble(),
      trend: json['trend'] ?? 'stable',
    );
  }

  String get trendEmoji => trend == 'up' ? '📈' : trend == 'down' ? '📉' : '➡️';
}

// ─── Drug heat ────────────────────────────────────────────────────────────────

class DrugFacilityCatalogItem {
  final String facilityType;
  final String displayName;
  final int purchasePrice;
  final int requiredRank;
  final bool owned;
  final int playerRank;
  final bool rankOk;
  final Map<String, dynamic>? nextSlotEducation;

  DrugFacilityCatalogItem({
    required this.facilityType,
    required this.displayName,
    required this.purchasePrice,
    required this.requiredRank,
    required this.owned,
    required this.playerRank,
    required this.rankOk,
    this.nextSlotEducation,
  });

  factory DrugFacilityCatalogItem.fromJson(Map<String, dynamic> json) {
    return DrugFacilityCatalogItem(
      facilityType: json['facilityType'] ?? '',
      displayName: json['displayName'] ?? '',
      purchasePrice: json['purchasePrice'] ?? 0,
      requiredRank: json['requiredRank'] ?? 0,
      owned: json['owned'] == true,
      playerRank: json['playerRank'] ?? 0,
      rankOk: json['rankOk'] != false,
      nextSlotEducation: json['nextSlotEducation'] as Map<String, dynamic>?,
    );
  }
}

class DrugHeatInfo {
  final int heat;
  final String level;
  final double raidChance;
  final bool shieldActive;
  final bool lowProfileActive;
  final int cashCoolCost;
  final int cashCoolPoints;
  final int lowProfileHours;
  final DateTime? lowProfileReadyAt;

  DrugHeatInfo({
    required this.heat,
    required this.level,
    required this.raidChance,
    this.shieldActive = false,
    this.lowProfileActive = false,
    this.cashCoolCost = 0,
    this.cashCoolPoints = 25,
    this.lowProfileHours = 4,
    this.lowProfileReadyAt,
  });

  factory DrugHeatInfo.fromJson(Map<String, dynamic> json) {
    return DrugHeatInfo(
      heat: json['heat'] ?? 0,
      level: json['level'] ?? 'Low',
      raidChance: (json['raidChance'] ?? 0.0).toDouble(),
      shieldActive: json['shieldActive'] == true,
      lowProfileActive: json['lowProfileActive'] == true,
      cashCoolCost: json['cashCoolCost'] ?? 0,
      cashCoolPoints: json['cashCoolPoints'] ?? 25,
      lowProfileHours: json['lowProfileHours'] ?? 4,
      lowProfileReadyAt: json['lowProfileReadyAt'] != null
          ? DateTime.tryParse(json['lowProfileReadyAt'].toString())
          : null,
    );
  }

  Color get color {
    if (heat < 20) return const Color(0xFF4CAF50);
    if (heat < 40) return const Color(0xFF8BC34A);
    if (heat < 60) return const Color(0xFFFF9800);
    if (heat < 80) return const Color(0xFFFF5722);
    return const Color(0xFFE53935);
  }
}

// ─── Drug stats ───────────────────────────────────────────────────────────────

class DrugStats {
  final int totalProduced;
  final int totalInStock;
  final String? bestDrug;
  final String? bestDrugName;
  final int activeProductions;
  final int facilityCount;
  final int totalSlots;
  final int efficiency;
  final int heat;
  final String heatLevel;
  final double raidChance;
  final bool isVip;
  final bool autoCollectEnabled;

  DrugStats({
    required this.totalProduced,
    required this.totalInStock,
    this.bestDrug,
    this.bestDrugName,
    required this.activeProductions,
    required this.facilityCount,
    required this.totalSlots,
    required this.efficiency,
    required this.heat,
    required this.heatLevel,
    required this.raidChance,
    required this.isVip,
    required this.autoCollectEnabled,
  });

  factory DrugStats.fromJson(Map<String, dynamic> json) {
    return DrugStats(
      totalProduced: json['totalProduced'] ?? 0,
      totalInStock: json['totalInStock'] ?? 0,
      bestDrug: json['bestDrug'],
      bestDrugName: json['bestDrugName'],
      activeProductions: json['activeProductions'] ?? 0,
      facilityCount: json['facilityCount'] ?? 0,
      totalSlots: json['totalSlots'] ?? 0,
      efficiency: json['efficiency'] ?? 0,
      heat: json['heat'] ?? 0,
      heatLevel: json['heatLevel'] ?? 'Low',
      raidChance: (json['raidChance'] ?? 0.0).toDouble(),
      isVip: json['isVip'] ?? false,
      autoCollectEnabled: json['autoCollectEnabled'] ?? false,
    );
  }
}

class DrugWholesaleDestination {
  final String id;
  final String labelNl;
  final String labelEn;
  final int streetUnit;

  DrugWholesaleDestination({
    required this.id,
    required this.labelNl,
    required this.labelEn,
    required this.streetUnit,
  });

  factory DrugWholesaleDestination.fromJson(Map<String, dynamic> json) {
    return DrugWholesaleDestination(
      id: json['id']?.toString() ?? '',
      labelNl: json['labelNl']?.toString() ?? json['id']?.toString() ?? '',
      labelEn: json['labelEn']?.toString() ?? json['id']?.toString() ?? '',
      streetUnit: (json['streetUnit'] as num?)?.toInt() ?? 0,
    );
  }
}

class DrugWholesaleShipment {
  final int id;
  final String label;
  final int quantity;
  final String originCountry;
  final String destinationCountry;
  final String status;
  final int payout;
  final DateTime? etaAt;
  final bool settled;

  DrugWholesaleShipment({
    required this.id,
    required this.label,
    required this.quantity,
    required this.originCountry,
    required this.destinationCountry,
    required this.status,
    required this.payout,
    this.etaAt,
    required this.settled,
  });

  factory DrugWholesaleShipment.fromJson(Map<String, dynamic> json) {
    return DrugWholesaleShipment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      label: json['label']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      originCountry: json['originCountry']?.toString() ?? '',
      destinationCountry: json['destinationCountry']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      payout: (json['payout'] as num?)?.toInt() ?? 0,
      etaAt: json['etaAt'] != null ? DateTime.tryParse(json['etaAt'].toString()) : null,
      settled: json['settled'] == true,
    );
  }
}
