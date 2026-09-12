import '../models/inventory_grid_item.dart';

const kDrugGramsPerSlot = 100;
const kMaterialUnitsPerSlot = 5;
const kAmmoRoundsPerSlot = 50;

int unitsPerPropertySlot(InventoryItemKind kind) {
  switch (kind) {
    case InventoryItemKind.drug:
      return kDrugGramsPerSlot;
    case InventoryItemKind.material:
      return kMaterialUnitsPerSlot;
    case InventoryItemKind.ammo:
      return kAmmoRoundsPerSlot;
    case InventoryItemKind.weapon:
    case InventoryItemKind.tool:
    case InventoryItemKind.armor:
    case InventoryItemKind.trade:
      return 1;
  }
}

/// Splits one stored stack into physical slot cells (e.g. 145g → 100 + 45).
List<InventoryGridItem> expandToSlotCells(List<InventoryGridItem> items) {
  final cells = <InventoryGridItem>[];
  for (final item in items) {
    if (item.quantity <= 0) continue;
    final perSlot = unitsPerPropertySlot(item.kind);
    var remaining = item.quantity;
    while (remaining > 0) {
      final chunk = remaining > perSlot ? perSlot : remaining;
      cells.add(item.copyWith(quantity: chunk));
      remaining -= chunk;
    }
  }
  return cells;
}
