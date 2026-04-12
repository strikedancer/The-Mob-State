import 'package:flutter/material.dart';
import '../models/player_tool.dart';

class InventoryToolCard extends StatefulWidget {
  final PlayerTool tool;
  final bool canAffordRepair;
  final VoidCallback? onRepair;

  const InventoryToolCard({
    super.key,
    required this.tool,
    required this.canAffordRepair,
    this.onRepair,
  });

  @override
  State<InventoryToolCard> createState() => _InventoryToolCardState();
}

class _InventoryToolCardState extends State<InventoryToolCard> {
  bool _isHovered = false;

  Color _getDurabilityColor(double percentage) {
    if (percentage > 70) return Colors.green;
    if (percentage > 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;  // Unused
    final imageAsset = 'assets/images/tools/${widget.tool.toolId}_tool.png';
    final durabilityPercent = widget.tool.durabilityPercent;
    final durabilityColor = _getDurabilityColor(durabilityPercent);
    final repairCost = ((widget.tool.basePrice ?? 0) * 0.5).floor();
    final needsRepair =
        widget.tool.needsRepair == true || widget.tool.isBroken == true;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.22),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : const [],
        ),
        child: Card(
          elevation: _isHovered ? 4 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: _isHovered
                  ? const Color(0xFFFFC107).withOpacity(0.75)
                  : Colors.transparent,
              width: _isHovered ? 1.2 : 0,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap:
                needsRepair && widget.canAffordRepair && widget.onRepair != null
                ? widget.onRepair
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 120),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          image: DecorationImage(
                            image: AssetImage(imageAsset),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            onError: (exception, stackTrace) {},
                          ),
                          color: Colors.grey[850],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.35),
                            ],
                          ),
                        ),
                      ),
                      // Durability badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: durabilityColor.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${durabilityPercent.toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Broken indicator
                      if (widget.tool.isBroken == true)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.broken_image,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'KAPOT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Needs repair indicator
                      if (widget.tool.needsRepair == true &&
                          widget.tool.isBroken != true)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'REPAREER',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.tool.name ?? widget.tool.toolId,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.build,
                                  size: 12,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    widget.tool.type ?? '',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[400],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Durability bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: durabilityPercent / 100,
                                backgroundColor: Colors.grey[700],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  durabilityColor,
                                ),
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Durability text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${widget.tool.durability}/${widget.tool.maxDurability}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[400],
                                  ),
                                ),
                                if (needsRepair)
                                  Text(
                                    '€$repairCost',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: widget.canAffordRepair
                                          ? Colors.blue
                                          : Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
