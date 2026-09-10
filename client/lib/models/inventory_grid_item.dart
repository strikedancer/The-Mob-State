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
}

class InventoryDragPayload {
  final InventoryGridItem item;

  const InventoryDragPayload(this.item);
}
