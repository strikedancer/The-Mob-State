import 'package:flutter/material.dart';

import '../models/inventory_grid_item.dart';
import '../utils/web_asset_helper.dart';

class InventorySlot extends StatelessWidget {
  final InventoryGridItem? item;
  final bool selected;
  final bool highlighted;
  final VoidCallback? onTap;
  final bool acceptDrop;
  final void Function(InventoryDragPayload payload)? onAccept;
  final bool enableDrag;

  const InventorySlot({
    super.key,
    this.item,
    this.selected = false,
    this.highlighted = false,
    this.onTap,
    this.acceptDrop = false,
    this.onAccept,
    this.enableDrag = true,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<InventoryDragPayload>(
      onWillAcceptWithDetails: (_) => acceptDrop && onAccept != null,
      onAcceptWithDetails: (details) {
        if (onAccept != null) onAccept!(details.data);
      },
      builder: (context, candidate, rejected) {
        final hover = highlighted || candidate.isNotEmpty;
        final tile = _tile(context, hover);
        final tappable = GestureDetector(onTap: onTap, child: tile);
        if (item == null || !enableDrag) return tappable;
        return Draggable<InventoryDragPayload>(
          data: InventoryDragPayload(item!),
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(width: 56, height: 56, child: _tile(context, true)),
          ),
          childWhenDragging: Opacity(opacity: 0.35, child: tappable),
          child: tappable,
        );
      },
    );
  }

  Widget _tile(BuildContext context, bool hover) {
    final borderColor = selected
        ? const Color(0xFFD4AF37)
        : hover
        ? Colors.greenAccent
        : const Color(0xFF3A3A3A);
    return Tooltip(
      message: item == null ? '' : item!.name,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor,
            width: selected || hover ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: item == null
            ? const SizedBox.expand()
            : Stack(
                children: [
                  Center(
                    child: item!.imagePath == null
                        ? Icon(
                            _fallbackIcon(item!.kind),
                            size: 22,
                            color: Colors.white70,
                          )
                        : WebAssetHelper.image(
                            item!.imagePath!,
                            width: 36,
                            height: 36,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => Icon(
                              _fallbackIcon(item!.kind),
                              size: 22,
                              color: Colors.white70,
                            ),
                          ),
                  ),
                  if (item!.quantity > 1)
                    Positioned(
                      right: 3,
                      bottom: 2,
                      child: Text(
                        '${item!.quantity}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (item!.condition != null)
                    Positioned(
                      left: 3,
                      top: 2,
                      child: Text(
                        '${item!.condition}%',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: (item!.condition ?? 100) < 50
                              ? Colors.redAccent
                              : Colors.white70,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  IconData _fallbackIcon(InventoryItemKind kind) {
    switch (kind) {
      case InventoryItemKind.weapon:
        return Icons.gps_fixed;
      case InventoryItemKind.tool:
        return Icons.handyman;
      case InventoryItemKind.ammo:
        return Icons.bolt;
      case InventoryItemKind.material:
        return Icons.science;
      case InventoryItemKind.armor:
        return Icons.shield;
    }
  }
}
