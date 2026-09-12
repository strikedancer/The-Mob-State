enum InventoryItemKind { weapon, tool, ammo, material, armor, drug, trade }

enum InventoryZone {
  backpack,
  property,
  depot,
  equippedWeapon,
  equippedSecondary,
  equippedArmor,
}

class InventoryGridItem {
  final InventoryItemKind kind;
  final String id;
  final String name;
  final int quantity;
  final int? condition;
  final InventoryZone zone;
  final String? imagePath;
  final String? quality;

  const InventoryGridItem({
    required this.kind,
    required this.id,
    required this.name,
    required this.quantity,
    required this.zone,
    this.condition,
    this.imagePath,
    this.quality,
  });

  InventoryGridItem copyWith({
    InventoryItemKind? kind,
    String? id,
    String? name,
    int? quantity,
    int? condition,
    InventoryZone? zone,
    String? imagePath,
    String? quality,
  }) {
    return InventoryGridItem(
      kind: kind ?? this.kind,
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      condition: condition ?? this.condition,
      zone: zone ?? this.zone,
      imagePath: imagePath ?? this.imagePath,
      quality: quality ?? this.quality,
    );
  }
}

class InventoryDragPayload {
  final InventoryGridItem item;

  const InventoryDragPayload(this.item);
}
