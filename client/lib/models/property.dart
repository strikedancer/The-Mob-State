class PropertyDefinition {
  final String id;
  final String name;
  final String description;
  final String type;
  final int basePrice;
  final int baseIncome;
  final int minLevel;
  final int maxLevel;
  final int upgradeMultiplier;
  final bool unique; // Casino = true (1 per country)
  final List<int> storageCapacity; // Tool storage slots per level (0 = no storage)
  final String? imagePath;

  PropertyDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.basePrice,
    required this.baseIncome,
    required this.minLevel,
    required this.maxLevel,
    required this.upgradeMultiplier,
    this.unique = false,
    this.storageCapacity = const [0],
    this.imagePath,
  });

  factory PropertyDefinition.fromJson(Map<String, dynamic> json) {
    return PropertyDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      basePrice: json['basePrice'] as int? ?? 0,
      baseIncome: json['baseIncome'] as int? ?? 0,
      minLevel: json['minLevel'] as int? ?? 1,
      maxLevel: json['maxLevel'] as int? ?? 3,
      upgradeMultiplier: json['upgradeMultiplier'] as int? ?? 2,
      unique: json['unique'] as bool? ?? false,
      storageCapacity: (json['storageCapacity'] is List)
          ? List<int>.from(json['storageCapacity'])
          : [json['storageCapacity'] as int? ?? 0],
      imagePath: json['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'basePrice': basePrice,
      'baseIncome': baseIncome,
      'minLevel': minLevel,
      'maxLevel': maxLevel,
      'upgradeMultiplier': upgradeMultiplier,
      'unique': unique,
      'storageCapacity': storageCapacity,
      'imagePath': imagePath,
    };
  }
}

class Property {
  final int id;
  final int playerId;
  final String propertyId;
  final String countryId;
  final int level;
  final DateTime? lastIncomeCollected;
  final DateTime createdAt;
  
  // Joined data from definition
  final String? name;
  final String? type;
  final int? baseIncome;
  final String? imagePath;
  final int? incomeInterval;
  final List<String>? overlayKeys;
  final int? nextUpgradeCost;

  Property({
    required this.id,
    required this.playerId,
    required this.propertyId,
    required this.countryId,
    required this.level,
    this.lastIncomeCollected,
    required this.createdAt,
    this.name,
    this.type,
    this.baseIncome,
    this.imagePath,
    this.incomeInterval,
    this.overlayKeys,
    this.nextUpgradeCost,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as int,
      playerId: json['playerId'] as int,
      propertyId: json['propertyId'] as String,
      countryId: json['countryId'] as String,
      level: json['upgradeLevel'] as int? ?? 1, // Backend uses 'upgradeLevel'
      lastIncomeCollected: json['lastIncomeAt'] != null
          ? DateTime.parse(json['lastIncomeAt'])
          : null,
      createdAt: json['purchasedAt'] != null
          ? DateTime.parse(json['purchasedAt'])
          : DateTime.now(),
      name: json['name'] as String?,
      type: json['propertyType'] as String?,
      baseIncome: json['baseIncome'] as int?,
      imagePath: json['imagePath'] as String?,
      incomeInterval: json['incomeInterval'] as int?,
      overlayKeys: json['overlayKeys'] != null
          ? List<String>.from(json['overlayKeys'])
          : null,
      nextUpgradeCost: json['nextUpgradeCost'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'propertyId': propertyId,
      'countryId': countryId,
      'level': level,
      'lastIncomeCollected': lastIncomeCollected?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'type': type,
      'baseIncome': baseIncome,
      'imagePath': imagePath,
    };
  }

  // Calculate current income based on level
  int get currentIncome {
    if (baseIncome == null) return 0;
    return (baseIncome! * (1 + (level - 1) * 0.5)).round();
  }

  // Check if income is ready to collect
  bool get canCollectIncome {
    if (lastIncomeCollected == null) return true;
    final minutesSinceLastCollection = 
        DateTime.now().difference(lastIncomeCollected!).inMinutes;
    final intervalMinutes = incomeInterval ?? 60;
    return minutesSinceLastCollection >= intervalMinutes;
  }

  // Time until next collection
  Duration? get timeUntilNextCollection {
    if (lastIncomeCollected == null) return null;
    final intervalMinutes = incomeInterval ?? 60;
    final nextCollection = lastIncomeCollected!.add(Duration(minutes: intervalMinutes));
    final now = DateTime.now();
    if (nextCollection.isBefore(now)) return null;
    return nextCollection.difference(now);
  }
}
