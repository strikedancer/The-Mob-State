class CarriedTool {
  final int id;
  final String toolId;
  final String name;
  final String type;
  final int basePrice;
  final int maxDurability;
  final int durability;
  final double loseChance;
  final int wearPerUse;
  final String location;
  final int quantity;
  final List<String> requiredFor;
  final DateTime createdAt;
  final bool isBroken;
  final bool needsRepair;
  final int? slotSize;

  CarriedTool({
    required this.id,
    required this.toolId,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.maxDurability,
    required this.durability,
    required this.loseChance,
    required this.wearPerUse,
    required this.location,
    required this.quantity,
    required this.requiredFor,
    required this.createdAt,
    required this.isBroken,
    required this.needsRepair,
    this.slotSize,
  });

  factory CarriedTool.fromJson(Map<String, dynamic> json) {
    return CarriedTool(
      id: json['id'] as int,
      toolId: json['toolId'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      basePrice: json['basePrice'] as int,
      maxDurability: json['maxDurability'] as int,
      durability: json['durability'] as int,
      loseChance: (json['loseChance'] as num).toDouble(),
      wearPerUse: json['wearPerUse'] as int,
      location: json['location'] as String,
      quantity: json['quantity'] as int,
      requiredFor: List<String>.from(json['requiredFor'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isBroken: json['isBroken'] as bool,
      needsRepair: json['needsRepair'] as bool,
      slotSize: json['slotSize'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'toolId': toolId,
      'name': name,
      'type': type,
      'basePrice': basePrice,
      'maxDurability': maxDurability,
      'durability': durability,
      'loseChance': loseChance,
      'wearPerUse': wearPerUse,
      'location': location,
      'quantity': quantity,
      'requiredFor': requiredFor,
      'createdAt': createdAt.toIso8601String(),
      'isBroken': isBroken,
      'needsRepair': needsRepair,
      'slotSize': slotSize,
    };
  }

  double get durabilityPercentage => (durability / maxDurability) * 100;
  
  bool get isLowDurability => durabilityPercentage < 30;
  
  int get repairCost => (basePrice * 0.5).round();
}
