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

  const CarriedInventoryTab({super.key, required this.playerId});

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
    _loadInventory();
  }

  Future<void> _loadInventory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _inventoryService.getCarriedTools();

    List<Map<String, dynamic>> weapons = [];
    List<Map<String, dynamic>> ammo = [];

    try {
      final weaponsResponse = await _apiClient.get('/weapons/inventory');
      if (weaponsResponse.statusCode == 200) {
        final data = json.decode(weaponsResponse.body) as Map<String, dynamic>;
        weapons = (data['weapons'] as List<dynamic>? ?? [])
            .map((w) => w as Map<String, dynamic>)
            .toList();
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
                          'Je draagt momenteel geen tools, wapens of munitie.',
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
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Gereedschap',
                            style: TextStyle(
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
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Wapens',
                            style: TextStyle(
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
                                        'Wapen')
                                    .toString(),
                              ),
                              subtitle: Text(
                                'Conditie: ${weapon['condition'] ?? 100}% • Aantal: ${weapon['quantity'] ?? 1}',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      if (_ammo.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Munitie',
                            style: TextStyle(
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
                                        'Munitie')
                                    .toString(),
                              ),
                              subtitle: Text(
                                'Aantal: ${ammoItem['quantity'] ?? 0}',
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
