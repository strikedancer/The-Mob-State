import 'carried_tool.dart';

class StorageInfo {
  final int propertyId;
  final String propertyType;
  final int usage;
  final int capacity;
  final int percentFull;
  final List<String> allowedCategories;
  final int toolCount;
  final int weaponCount;
  final int drugCount;
  final int cashAmount;
  final bool accessibleInCurrentCountry;
  final List<CarriedTool> tools;

  StorageInfo({
    required this.propertyId,
    required this.propertyType,
    required this.usage,
    required this.capacity,
    required this.percentFull,
    required this.allowedCategories,
    required this.toolCount,
    required this.weaponCount,
    required this.drugCount,
    required this.cashAmount,
    required this.accessibleInCurrentCountry,
    required this.tools,
  });

  factory StorageInfo.fromJson(Map<String, dynamic> json) {
    return StorageInfo(
      propertyId: json['propertyId'] as int,
      propertyType: json['propertyType'] as String,
      usage: json['usage'] as int,
      capacity: json['capacity'] as int,
      percentFull: json['percentFull'] as int,
      allowedCategories: (json['allowedCategories'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      toolCount: json['toolCount'] as int,
      weaponCount: json['weaponCount'] as int? ?? 0,
      drugCount: json['drugCount'] as int? ?? 0,
      cashAmount: json['cashAmount'] as int? ?? 0,
      accessibleInCurrentCountry:
          json['accessibleInCurrentCountry'] as bool? ?? true,
      tools: (json['tools'] as List)
          .map((tool) => CarriedTool.fromJson(tool))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'propertyId': propertyId,
      'propertyType': propertyType,
      'usage': usage,
      'capacity': capacity,
      'percentFull': percentFull,
      'allowedCategories': allowedCategories,
      'toolCount': toolCount,
      'weaponCount': weaponCount,
      'drugCount': drugCount,
      'cashAmount': cashAmount,
      'accessibleInCurrentCountry': accessibleInCurrentCountry,
      'tools': tools.map((t) => t.toJson()).toList(),
    };
  }

  int get slotsRemaining => capacity - usage;

  bool get isFull => usage >= capacity;

  bool get isNearlyFull => percentFull >= 80;
}

class InventorySlots {
  final int used;
  final int max;

  InventorySlots({required this.used, required this.max});

  factory InventorySlots.fromJson(Map<String, dynamic> json) {
    return InventorySlots(
      used: json['slotsUsed'] as int,
      max: json['maxSlots'] as int,
    );
  }

  int get remaining => max - used;

  bool get isFull => used >= max;

  bool get isNearlyFull => (used / max) >= 0.8;

  double get percentage => (used / max) * 100;
}
