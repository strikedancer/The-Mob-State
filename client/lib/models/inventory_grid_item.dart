enum InventoryItemKind { weapon, tool, ammo, material, armor }

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

  const InventoryGridItem({
    required this.kind,
    required this.id,
    required this.name,
    required this.quantity,
    required this.zone,
    this.condition,
    this.imagePath,
  });
}

class InventoryDragPayload {
  final InventoryGridItem item;

  const InventoryDragPayload(this.item);
}
