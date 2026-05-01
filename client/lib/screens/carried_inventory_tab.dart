import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/carried_tool.dart';
import '../models/storage_info.dart';
import '../services/api_client.dart';
import '../services/inventory_service.dart';
import '../widgets/tool_card.dart';
import '../widgets/transfer_dialog.dart';
import '../l10n/app_localizations.dart';

class CarriedInventoryTab extends StatefulWidget {
  final int playerId;
  final List<Map<String, dynamic>> weaponInventory;

  const CarriedInventoryTab({
    super.key,
    required this.playerId,
    required this.weaponInventory,
  });

  @override
  State<CarriedInventoryTab> createState() => _CarriedInventoryTabState();
}

class _CarriedInventoryTabState extends State<CarriedInventoryTab> {
  final InventoryService _inventoryService = InventoryService();
  final ApiClient _apiClient = ApiClient();
  List<CarriedTool> _tools = [];
  List<Map<String, dynamic>> _weapons = [];
  List<Map<String, dynamic>> _ammo = [];
  InventorySlots? _slots;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _weapons = List<Map<String, dynamic>>.from(widget.weaponInventory);
    _loadInventory();
  }

  @override
  void didUpdateWidget(covariant CarriedInventoryTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weaponInventory != widget.weaponInventory) {
      setState(() {
        _weapons = List<Map<String, dynamic>>.from(widget.weaponInventory);
      });
    }
  }

  List<Map<String, dynamic>> _parseWeaponInventory(String body) {
    try {
      final raw = (body.isEmpty
          ? {}
          : (jsonDecode(body) as Map<String, dynamic>));

      final dynamic candidates =
          raw['weapons'] ?? raw['inventory'] ?? raw['weaponInventory'];

      final list = (candidates is List ? candidates : <dynamic>[])
          .map((entry) => Map<String, dynamic>.from(entry as Map))
          .where((entry) => ((entry['quantity'] as num?)?.toInt() ?? 1) > 0)
          .toList();

      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> _loadInventory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _inventoryService.getCarriedTools();

    List<Map<String, dynamic>> weapons = List<Map<String, dynamic>>.from(
      widget.weaponInventory,
    );
    List<Map<String, dynamic>> ammo = [];

    try {
      final weaponsResponse = await _apiClient.get('/weapons/inventory');
      if (weaponsResponse.statusCode == 200) {
        final parsed = _parseWeaponInventory(weaponsResponse.body);
        if (parsed.isNotEmpty) {
          weapons = parsed;
        }
      }
    } catch (_) {}

    try {
      final ammoResponse = await _apiClient.get('/ammo/inventory');
      if (ammoResponse.statusCode == 200) {
        final data = json.decode(ammoResponse.body) as Map<String, dynamic>;
        ammo = (data['ammo'] as List<dynamic>? ?? [])
            .map((a) => a as Map<String, dynamic>)
            .toList();
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _tools = result['tools'];
          _weapons = weapons;
          _ammo = ammo;
          _slots = result['slots'];
        } else {
          _error = result['error'];
        }
      });
    }
  }

  void _showTransferDialog(CarriedTool tool) {
    showDialog(
      context: context,
      builder: (context) => TransferDialog(
        tool: tool,
        fromLocation: 'carried',
        onTransferSuccess: _loadInventory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: _loadInventory,
      child: Column(
        children: [
          // Inventory capacity bar
          if (_slots != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                border: Border(bottom: BorderSide(color: Colors.grey[700]!)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.inventorySlots(_slots!.used, _slots!.max),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _slots!.isFull ? Colors.red : Colors.white,
                        ),
                      ),
                      Text(
                        '${_slots!.percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: _slots!.isNearlyFull
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: _slots!.used / _slots!.max,
                    backgroundColor: Colors.grey[700],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _slots!.isFull
                          ? Colors.red
                          : _slots!.isNearlyFull
                          ? Colors.orange
                          : Colors.amber,
                    ),
                  ),
                  if (_slots!.isFull)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        l10n.inventoryFull,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),

          // Tools list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
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
                          onPressed: _loadInventory,
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
                : _tools.isEmpty && _weapons.isEmpty && _ammo.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.inventoryCarriedEmpty,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.visitShopToBuyTools,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(8),
                    children: [
                      if (_tools.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.inventorySectionTools,
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._tools.map(
                          (tool) => ToolCard(
                            tool: tool,
                            onTransfer: () => _showTransferDialog(tool),
                            showLocation: false,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_weapons.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.inventorySectionWeapons,
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._weapons.map(
                          (weapon) => Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.gps_fixed,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                (weapon['name'] ??
                                        weapon['weaponId'] ??
                                        l10n.inventoryWeaponFallbackName)
                                    .toString(),
                              ),
                              subtitle: Text(
                                l10n.inventoryWeaponSubtitle(
                                  '${weapon['condition'] ?? 100}',
                                  '${weapon['quantity'] ?? 1}',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_ammo.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            l10n.inventorySectionAmmo,
                            style: const TextStyle(
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ..._ammo.map(
                          (ammoItem) => Card(
                            child: ListTile(
                              leading: const Icon(
                                Icons.bolt,
                                color: Colors.orangeAccent,
                              ),
                              title: Text(
                                (ammoItem['displayName'] ??
                                        ammoItem['ammoType'] ??
                                        l10n.inventoryAmmoFallbackName)
                                    .toString(),
                              ),
                              subtitle: Text(
                                l10n.inventoryAmmoQuantity(
                                  '${ammoItem['quantity'] ?? 0}',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
