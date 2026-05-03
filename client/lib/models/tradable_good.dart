class TradableGood {
  final String id;
  final String name;
  final String description;
  final int basePrice;
  final int maxInventory;
  final int weight;
  /// Hours until spoilage (e.g. flowers); server-driven from `tradableGoods.json`.
  final double? spoilageHours;
  final double? damageChancePerTrip;
  final double? confiscationChance;
  final double? priceVolatility;

  TradableGood({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.maxInventory,
    required this.weight,
    this.spoilageHours,
    this.damageChancePerTrip,
    this.confiscationChance,
    this.priceVolatility,
  });

  factory TradableGood.fromJson(Map<String, dynamic> json) {
    double? d(String k) {
      final v = json[k];
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return TradableGood(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      basePrice: (json['basePrice'] as num?)?.toInt() ?? 0,
      maxInventory: (json['maxInventory'] as num?)?.toInt() ?? 100,
      weight: (json['weight'] as num?)?.toInt() ?? 1,
      spoilageHours: d('spoilageHours'),
      damageChancePerTrip: d('damageChancePerTrip'),
      confiscationChance: d('confiscationChance'),
      priceVolatility: d('priceVolatility'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'maxInventory': maxInventory,
      'weight': weight,
      if (spoilageHours != null) 'spoilageHours': spoilageHours,
      if (damageChancePerTrip != null) 'damageChancePerTrip': damageChancePerTrip,
      if (confiscationChance != null) 'confiscationChance': confiscationChance,
      if (priceVolatility != null) 'priceVolatility': priceVolatility,
    };
  }

  String get icon {
    switch (id) {
      case 'contraband_weapons':
        return '🔫';
      case 'contraband_pharmaceuticals':
        return '💊';
      case 'contraband_diamonds':
        return '💎';
      case 'contraband_flowers':
        return '🌷';
      case 'contraband_electronics':
        return '📱';
      default:
        return '📦';
    }
  }
}

class GoodPrice {
  final String goodType;
  final int currentPrice;
  final int sellPrice;
  final double multiplier;

  GoodPrice({
    required this.goodType,
    required this.currentPrice,
    required this.sellPrice,
    required this.multiplier,
  });

  factory GoodPrice.fromJson(Map<String, dynamic> json) {
    return GoodPrice(
      goodType: json['goodType'] as String? ?? '',
      currentPrice: (json['currentPrice'] as num?)?.toInt() ?? 0,
      sellPrice: (json['sellPrice'] as num?)?.toInt() ?? 0,
      multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
    );
  }
}

class InventoryItem {
  final String goodType;
  final int quantity;
  final int purchasePrice;
  final int condition;
  final bool spoiled;
  final String? purchasedAt;

  InventoryItem({
    required this.goodType,
    required this.quantity,
    required this.purchasePrice,
    this.condition = 100,
    this.spoiled = false,
    this.purchasedAt,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      goodType: json['goodType'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      purchasePrice: (json['purchasePrice'] as num?)?.toInt() ?? 0,
      condition: (json['condition'] as num?)?.toInt() ?? 100,
      spoiled: json['spoiled'] as bool? ?? false,
      purchasedAt: json['purchasedAt'] as String?,
    );
  }
}
