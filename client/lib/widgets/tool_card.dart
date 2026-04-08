import 'package:flutter/material.dart';
import '../models/carried_tool.dart';
import '../l10n/app_localizations.dart';

class ToolCard extends StatelessWidget {
  final CarriedTool tool;
  final VoidCallback? onTransfer;
  final bool showLocation;

  const ToolCard({
    super.key,
    required this.tool,
    this.onTransfer,
    this.showLocation = false,
  });

  Color _getDurabilityColor(double percentage) {
    if (percentage >= 70) return Colors.green;
    if (percentage >= 30) return Colors.orange;
    return Colors.red;
  }

  String _getToolIcon(String type) {
    switch (type.toUpperCase()) {
      case 'BOLT_CUTTER':
        return '✂️';
      case 'CROWBAR':
        return '🔧';
      case 'LOCKPICK':
        return '🔑';
      case 'BURGLARY_KIT':
        return '🧰';
      case 'SPRAY_PAINT':
        return '🎨';
      case 'GLASS_CUTTER':
        return '🪟';
      case 'HACKING_LAPTOP':
        return '💻';
      case 'TOOLBOX':
        return '🧰';
      case 'CAR_THEFT_TOOLS':
        return '🚗';
      case 'JERRY_CAN':
        return '⛽';
      default:
        return '🔨';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: Colors.grey[850],
      child: InkWell(
        onTap: onTransfer != null ? () {
          // Show tool details dialog
          _showToolDetails(context);
        } : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Tool icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getToolIcon(tool.type),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tool info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tool.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (tool.quantity > 1)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'x${tool.quantity}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (tool.slotSize != null) ...[
                              Icon(Icons.inventory_2, size: 14, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                '${tool.slotSize} ${l10n.slots}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Icon(Icons.euro, size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(
                              '€${tool.basePrice}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Transfer button
                  if (onTransfer != null)
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      color: Colors.amber,
                      onPressed: onTransfer,
                      tooltip: l10n.transfer,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Durability bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.durability,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        '${tool.durability}/${tool.maxDurability}',
                        style: TextStyle(
                          fontSize: 12,
                          color: _getDurabilityColor(tool.durabilityPercentage),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: tool.durability / tool.maxDurability,
                    backgroundColor: Colors.grey[700],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getDurabilityColor(tool.durabilityPercentage),
                    ),
                  ),
                  if (tool.isLowDurability)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '⚠️ ${l10n.lowDurability}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                ],
              ),

              // Location (if shown)
              if (showLocation)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '📍 ${tool.location}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToolDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Row(
          children: [
            Text(_getToolIcon(tool.type), style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tool.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow(l10n.durability, '${tool.durability}/${tool.maxDurability}'),
              _buildInfoRow(l10n.quantity, tool.quantity.toString()),
              if (tool.slotSize != null)
                _buildInfoRow(l10n.slotSize, tool.slotSize.toString()),
              _buildInfoRow(l10n.price, '€${tool.basePrice}'),
              _buildInfoRow(l10n.repairCost, '€${tool.repairCost}'),
              _buildInfoRow(l10n.wearPerUse, '${tool.wearPerUse}%'),
              _buildInfoRow(l10n.loseChance, '${(tool.loseChance * 100).toStringAsFixed(0)}%'),
              if (tool.requiredFor.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.requiredFor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 4),
                ...tool.requiredFor.map((crime) => Text(
                  '• $crime',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close, style: const TextStyle(color: Colors.grey)),
          ),
          if (onTransfer != null)
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onTransfer!();
              },
              icon: const Icon(Icons.swap_horiz),
              label: Text(l10n.transfer),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
