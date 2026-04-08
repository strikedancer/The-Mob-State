import 'package:flutter/material.dart';
import '../models/loadout.dart';
import '../l10n/app_localizations.dart';

class LoadoutCard extends StatelessWidget {
  final Loadout loadout;
  final VoidCallback onEquip;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LoadoutCard({
    super.key,
    required this.loadout,
    required this.onEquip,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: loadout.isActive ? Colors.amber.withOpacity(0.2) : Colors.grey[850],
      child: InkWell(
        onTap: loadout.isActive ? null : onEquip,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Active indicator
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: loadout.isActive ? Colors.amber : Colors.grey[700],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      loadout.isActive ? Icons.check_circle : Icons.dashboard_customize,
                      color: loadout.isActive ? Colors.black : Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Loadout name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                loadout.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: loadout.isActive ? Colors.amber : Colors.white,
                                ),
                              ),
                            ),
                            if (loadout.isActive)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  l10n.active,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (loadout.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            loadout.description!,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Tools preview
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: loadout.tools.map((tool) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.build, size: 14, color: Colors.amber),
                        const SizedBox(width: 6),
                        Text(
                          tool.toolId,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 12),

              // Actions
              Row(
                children: [
                  // Tool count
                  Expanded(
                    child: Text(
                      '${loadout.toolCount} ${l10n.tools}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  // Edit button
                  IconButton(
                    icon: const Icon(Icons.edit),
                    color: Colors.blue,
                    iconSize: 20,
                    onPressed: onEdit,
                    tooltip: l10n.edit,
                  ),

                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    iconSize: 20,
                    onPressed: onDelete,
                    tooltip: l10n.delete,
                  ),

                  // Equip button
                  if (!loadout.isActive)
                    ElevatedButton.icon(
                      onPressed: onEquip,
                      icon: const Icon(Icons.check_circle, size: 16),
                      label: Text(l10n.equipLoadout),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
