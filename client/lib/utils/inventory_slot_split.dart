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

class SlotFillPlan {
  final int currentQty;
  final int incoming;
  final int unitsPerSlot;
  final int roomInPartial;
  final int overflow;

  const SlotFillPlan({
    required this.currentQty,
    required this.incoming,
    required this.unitsPerSlot,
    required this.roomInPartial,
    required this.overflow,
  });

  bool get hasPartial => roomInPartial > 0;
}

/// How an incoming amount fills a stack: leftover cell first, then new cells.
SlotFillPlan planSlotFill({
  required int currentQty,
  required int incoming,
  required int unitsPerSlot,
}) {
  final safeCurrent = currentQty < 0 ? 0 : currentQty;
  final safeIncoming = incoming < 0 ? 0 : incoming;
  final per = unitsPerSlot <= 0 ? 1 : unitsPerSlot;
  final remainder = safeCurrent % per;
  final room = remainder == 0 ? 0 : per - remainder;
  final fill = safeIncoming < room ? safeIncoming : room;
  return SlotFillPlan(
    currentQty: safeCurrent,
    incoming: safeIncoming,
    unitsPerSlot: per,
    roomInPartial: room,
    overflow: safeIncoming - fill,
  );
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
