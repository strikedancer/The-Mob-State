import 'package:flutter/material.dart';
import '../models/loadout.dart';
import '../models/carried_tool.dart';
import '../services/loadout_service.dart';
import '../services/inventory_service.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class CreateLoadoutScreen extends StatefulWidget {
  final int playerId;
  final Loadout? loadout; // If editing

  const CreateLoadoutScreen({
    super.key,
    required this.playerId,
    this.loadout,
  });

  @override
  State<CreateLoadoutScreen> createState() => _CreateLoadoutScreenState();
}

class _CreateLoadoutScreenState extends State<CreateLoadoutScreen> {
  final LoadoutService _loadoutService = LoadoutService();
  final InventoryService _inventoryService = InventoryService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<CarriedTool> _availableTools = [];
  Set<String> _selectedToolIds = {};
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.loadout != null) {
      _nameController.text = widget.loadout!.name;
      _descriptionController.text = widget.loadout!.description ?? '';
      _selectedToolIds = widget.loadout!.tools.map((t) => t.toolId).toSet();
    }
    _loadAvailableTools();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableTools() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Load both carried and storage tools
    final carriedResult = await _inventoryService.getCarriedTools();
    final storageResult = await _inventoryService.getStorageOverview();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (carriedResult['success'] && storageResult['success']) {
          // Combine tools from carried and storage
          _availableTools = List<CarriedTool>.from(carriedResult['tools']);
          for (var storage in storageResult['storage']) {
            _availableTools.addAll(storage.tools);
          }
          // Remove duplicates (same toolId)
          _availableTools = _availableTools.fold<Map<String, CarriedTool>>(
            {},
            (map, tool) {
              if (!map.containsKey(tool.toolId)) {
                map[tool.toolId] = tool;
              }
              return map;
            },
          ).values.toList();
        } else {
          _error = carriedResult['error'] ?? storageResult['error'];
        }
      });
    }
  }

  Future<void> _saveLoadout() async {
    final l10n = AppLocalizations.of(context)!;

    if (_nameController.text.trim().isEmpty) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.pleaseEnterName),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedToolIds.isEmpty) {
      showTopRightFromSnackBar(context, 
        SnackBar(
          content: Text(l10n.pleaseSelectTools),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _error = null;
    });

    final result = widget.loadout == null
        ? await _loadoutService.createLoadout(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty 
                ? null 
                : _descriptionController.text.trim(),
            toolIds: _selectedToolIds.toList(),
          )
        : await _loadoutService.updateLoadout(
            loadoutId: widget.loadout!.id,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty 
                ? null 
                : _descriptionController.text.trim(),
            toolIds: _selectedToolIds.toList(),
          );

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      if (result['success']) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(
              widget.loadout == null ? l10n.loadoutCreated : l10n.loadoutUpdated,
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          _error = result['error'];
        });
        if (result['missingTools'] != null) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n.loadoutMissingTools((result['missingTools'] as List).join(', '))),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.loadout == null ? l10n.createLoadout : l10n.editLoadout,
        ),
        backgroundColor: Colors.grey[900],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadAvailableTools,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retry),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Form
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[850],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name field
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: l10n.loadoutName,
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLength: 50,
                          ),
                          const SizedBox(height: 16),

                          // Description field
                          TextField(
                            controller: _descriptionController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: '${l10n.description} (${l10n.optional})',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            maxLines: 2,
                            maxLength: 200,
                          ),

                          const SizedBox(height: 8),

                          // Selected count
                          Text(
                            '${l10n.selectedTools}: ${_selectedToolIds.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tools list
                    Expanded(
                      child: _availableTools.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[600]),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noToolsAvailable,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: _availableTools.length,
                              itemBuilder: (context, index) {
                                final tool = _availableTools[index];
                                final isSelected = _selectedToolIds.contains(tool.toolId);

                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  color: isSelected 
                                      ? Colors.amber.withOpacity(0.2) 
                                      : Colors.grey[850],
                                  child: CheckboxListTile(
                                    value: isSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedToolIds.add(tool.toolId);
                                        } else {
                                          _selectedToolIds.remove(tool.toolId);
                                        }
                                      });
                                    },
                                    activeColor: Colors.amber,
                                    checkColor: Colors.black,
                                    title: Row(
                                      children: [
                                        Text(
                                          _getToolIcon(tool.type),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            tool.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.amber : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 36),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${l10n.location}: ${tool.location}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          Text(
                                            '${l10n.durability}: ${tool.durability}/${tool.maxDurability}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),

                    // Save button
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey[850],
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _saveLoadout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  widget.loadout == null ? l10n.create : l10n.save,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
