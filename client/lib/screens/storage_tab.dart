import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/carried_tool.dart';
import '../models/storage_info.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/inventory_service.dart';
import '../widgets/tool_card.dart';
import '../widgets/transfer_dialog.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class StorageTab extends StatefulWidget {
  final int playerId;

  const StorageTab({super.key, required this.playerId});

  @override
  State<StorageTab> createState() => _StorageTabState();
}

class _StorageTabState extends State<StorageTab> {
  final InventoryService _inventoryService = InventoryService();
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _weaponQtyController = TextEditingController(
    text: '1',
  );
  final TextEditingController _cashAmountController = TextEditingController();
  List<StorageInfo> _storageList = [];
  List<Map<String, dynamic>> _playerWeapons = [];
  Map<String, dynamic>? _storageDetail;
  StorageInfo? _selectedStorage;
  bool _isLoading = true;
  bool _isActionLoading = false;
  String? _error;
  String? _selectedPlayerWeaponId;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadStorage();
  }

  @override
  void dispose() {
    _weaponQtyController.dispose();
    _cashAmountController.dispose();
    super.dispose();
  }

  Future<void> _loadStorage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _inventoryService.getStorageOverview();

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _storageList = result['storage'];
          if (_storageList.isNotEmpty && _selectedStorage == null) {
            _selectedStorage = _storageList[0];
          }
        } else {
          _error = result['error'];
        }
      });

      if (result['success'] && _selectedStorage != null) {
        await _loadSelectedStorageDetail();
      }
    }
  }

  Future<void> _loadSelectedStorageDetail() async {
    if (_selectedStorage == null) return;

    final detailResult = await _inventoryService.getPropertyStorageDetail(
      _selectedStorage!.propertyId,
    );
    final weaponsResponse = await _apiClient.get('/weapons/inventory');

    if (!mounted) return;

    final weaponData = _parseWeaponInventory(weaponsResponse.body);
    setState(() {
      if (detailResult['success']) {
        _storageDetail = detailResult['storage'] as Map<String, dynamic>;
      }
      _playerWeapons = weaponData;
      if (_selectedPlayerWeaponId == null && _playerWeapons.isNotEmpty) {
        _selectedPlayerWeaponId = _playerWeapons.first['weaponId']?.toString();
      }
    });
  }

  List<Map<String, dynamic>> _parseWeaponInventory(String body) {
    try {
      final raw = (body.isEmpty
          ? {}
          : (jsonDecode(body) as Map<String, dynamic>));
      final list = (raw['weapons'] as List<dynamic>? ?? [])
          .map((entry) => Map<String, dynamic>.from(entry as Map))
          .where((entry) => ((entry['quantity'] as num?)?.toInt() ?? 1) > 0)
          .toList();
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> _depositWeapon() async {
    if (_selectedStorage == null || _selectedPlayerWeaponId == null) return;
    final quantity = int.tryParse(_weaponQtyController.text.trim()) ?? 0;
    if (quantity <= 0) return;

    setState(() => _isActionLoading = true);
    final result = await _inventoryService.depositWeaponToProperty(
      propertyId: _selectedStorage!.propertyId,
      weaponId: _selectedPlayerWeaponId!,
      quantity: quantity,
    );
    await _handleActionResult(result, 'Wapen opgeslagen');
  }

  Future<void> _withdrawWeapon(String weaponId) async {
    if (_selectedStorage == null) return;

    setState(() => _isActionLoading = true);
    final result = await _inventoryService.withdrawWeaponFromProperty(
      propertyId: _selectedStorage!.propertyId,
      weaponId: weaponId,
      quantity: 1,
    );
    await _handleActionResult(result, 'Wapen opgenomen');
  }

  Future<void> _depositCash() async {
    if (_selectedStorage == null) return;
    final amount = int.tryParse(_cashAmountController.text.trim()) ?? 0;
    if (amount <= 0) return;

    setState(() => _isActionLoading = true);
    final result = await _inventoryService.depositCashToProperty(
      propertyId: _selectedStorage!.propertyId,
      amount: amount,
    );
    await _handleActionResult(result, 'Cash opgeslagen');
  }

  Future<void> _withdrawCash() async {
    if (_selectedStorage == null) return;
    final amount = int.tryParse(_cashAmountController.text.trim()) ?? 0;
    if (amount <= 0) return;

    setState(() => _isActionLoading = true);
    final result = await _inventoryService.withdrawCashFromProperty(
      propertyId: _selectedStorage!.propertyId,
      amount: amount,
    );
    await _handleActionResult(result, 'Cash opgenomen');
  }

  Future<int?> _askQuantity({required int max, required String itemName}) async {
    final controller = TextEditingController(text: '1');
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_tr('Neem uit opslag', 'Withdraw from storage')}: $itemName'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _tr('Aantal', 'Quantity'),
            border: const OutlineInputBorder(),
            helperText: '${_tr('Max', 'Max')}: $max',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final qty = int.tryParse(controller.text.trim()) ?? 0;
              if (qty <= 0 || qty > max) {
                showTopRightFromSnackBar(
                  context,
                  SnackBar(content: Text(_tr('Ongeldige hoeveelheid', 'Invalid quantity'))),
                );
                return;
              }
              Navigator.of(context).pop(qty);
            },
            child: Text(_tr('Opnemen', 'Withdraw')),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _withdrawDrug(String drugType, int maxQuantity) async {
    if (_selectedStorage == null || maxQuantity <= 0) return;

    final quantity = await _askQuantity(max: maxQuantity, itemName: drugType);
    if (quantity == null || quantity <= 0) return;

    setState(() => _isActionLoading = true);
    final result = await _inventoryService.withdrawDrugsFromProperty(
      propertyId: _selectedStorage!.propertyId,
      drugType: drugType,
      quantity: quantity,
    );
    await _handleActionResult(result, _tr('Drugs opgenomen', 'Drugs withdrawn'));
  }

  Future<void> _handleActionResult(
    Map<String, dynamic> result,
    String successMessage,
  ) async {
    if (!mounted) return;

    if (result['success'] == true) {
      await Provider.of<AuthProvider>(context, listen: false).refreshPlayer();
      await _loadStorage();
      _cashAmountController.clear();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(successMessage)));
      }
    } else {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(result['error']?.toString() ?? 'Actie mislukt'),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isActionLoading = false);
    }
  }

  void _showTransferDialog(CarriedTool tool) {
    if (_selectedStorage == null) return;

    showDialog(
      context: context,
      builder: (context) => TransferDialog(
        tool: tool,
        fromLocation: 'property_${_selectedStorage!.propertyId}',
        onTransferSuccess: _loadStorage,
      ),
    );
  }

  String _getPropertyIcon(String propertyType) {
    switch (propertyType.toLowerCase()) {
      case 'apartment':
        return '🏢';
      case 'house':
        return '🏠';
      case 'villa':
        return '🏰';
      case 'warehouse':
        return '🏭';
      case 'safehouse':
        return '🔒';
      case 'penthouse':
        return '🌆';
      default:
        return '🏗️';
    }
  }

  String _getPropertyName(String propertyType) {
    return propertyType[0].toUpperCase() + propertyType.substring(1);
  }

  String _formatCategory(String category) {
    switch (category) {
      case 'tools':
        return 'Gereedschap';
      case 'drugs':
        return 'Drugs';
      case 'weapons':
        return 'Wapens';
      case 'cash':
        return 'Contant geld';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: _loadStorage,
      child: _isLoading
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
                    onPressed: _loadStorage,
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
          : _storageList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, size: 80, color: Colors.grey[600]),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noProperties,
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.buyPropertyForStorage,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Property selector
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]!),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.selectProperty,
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<StorageInfo>(
                        value: _selectedStorage,
                        isExpanded: true,
                        dropdownColor: Colors.grey[850],
                        items: _storageList.map((storage) {
                          return DropdownMenuItem<StorageInfo>(
                            value: storage,
                            child: Row(
                              children: [
                                Text(
                                  _getPropertyIcon(storage.propertyType),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _getPropertyName(storage.propertyType),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${storage.usage}/${storage.capacity} slots (${storage.percentFull}%)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                      Text(
                                        storage.accessibleInCurrentCountry
                                            ? 'Toegankelijk in huidig land'
                                            : 'Niet toegankelijk in dit land',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color:
                                              storage.accessibleInCurrentCountry
                                              ? Colors.greenAccent
                                              : Colors.orangeAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (newStorage) {
                          setState(() {
                            _selectedStorage = newStorage;
                          });
                          _loadSelectedStorageDetail();
                        },
                      ),
                      if (_selectedStorage != null) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: _selectedStorage!.allowedCategories.isEmpty
                              ? [
                                  Chip(
                                    label: Text(_tr('Geen opslagtype', 'No storage type')),
                                    backgroundColor: Colors.grey.shade800,
                                    labelStyle: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ]
                              : _selectedStorage!.allowedCategories
                                    .map(
                                      (category) => Chip(
                                        label: Text(_formatCategory(category)),
                                        backgroundColor: Colors.grey.shade800,
                                        labelStyle: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                        ),
                                      ),
                                    )
                                    .toList(),
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: _selectedStorage!.capacity > 0
                              ? _selectedStorage!.usage /
                                    _selectedStorage!.capacity
                              : 0,
                          backgroundColor: Colors.grey[700],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _selectedStorage!.isFull
                                ? Colors.red
                                : _selectedStorage!.isNearlyFull
                                ? Colors.orange
                                : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_selectedStorage!.toolCount} ${l10n.tools} • ${_selectedStorage!.slotsRemaining} ${l10n.slotsRemaining}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_tr('Wapens', 'Weapons')}: ${_selectedStorage!.weaponCount} • Drugs: ${_selectedStorage!.drugCount} • Cash: €${_selectedStorage!.cashAmount}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Storage actions + tools list
                Expanded(
                  child: _selectedStorage == null
                      ? const SizedBox.shrink()
                      : !_selectedStorage!.accessibleInCurrentCountry
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _tr('Je bent in een ander land. Je kunt deze opslag hier niet openen.', 'You are in another country. You cannot access this storage here.'),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(8),
                          children: [
                            if (_selectedStorage!.allowedCategories.contains(
                              'weapons',
                            ))
                              Card(
                                color: Colors.grey.shade900,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tr('Wapenopslag', 'Weapon storage'),
                                        style: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      DropdownButtonFormField<String>(
                                        value: _selectedPlayerWeaponId,
                                        isExpanded: true,
                                        dropdownColor: Colors.grey.shade900,
                                        items: _playerWeapons
                                            .map(
                                              (
                                                weapon,
                                              ) => DropdownMenuItem<String>(
                                                value: weapon['weaponId']
                                                    ?.toString(),
                                                child: Text(
                                                  '${weapon['name'] ?? weapon['weaponId']} (${weapon['quantity'] ?? 1})',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: _isActionLoading
                                            ? null
                                            : (value) {
                                                setState(
                                                  () =>
                                                      _selectedPlayerWeaponId =
                                                          value,
                                                );
                                              },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.grey.shade800,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: TextField(
                                              controller: _weaponQtyController,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              decoration: InputDecoration(
                                                labelText: _tr('Aantal', 'Quantity'),
                                                labelStyle: TextStyle(
                                                  color: Colors.grey.shade300,
                                                ),
                                                filled: true,
                                                fillColor: Colors.grey.shade800,
                                                border:
                                                    const OutlineInputBorder(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton.icon(
                                              onPressed: _isActionLoading
                                                  ? null
                                                  : _depositWeapon,
                                              icon: const Icon(
                                                Icons.inventory_2,
                                              ),
                                              label: Text(_tr('Opslaan', 'Store')),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _tr('In opslag', 'In storage'),
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      const SizedBox(height: 6),
                                      ...((_storageDetail?['weapons']
                                                  as List<dynamic>? ??
                                              [])
                                          .map((entry) {
                                            final weapon =
                                                entry as Map<String, dynamic>;
                                            final weaponId =
                                                weapon['weaponId']
                                                    ?.toString() ??
                                                '';
                                            final name =
                                                weapon['name']?.toString() ??
                                                weaponId;
                                            final quantity =
                                                (weapon['quantity'] as num?)
                                                    ?.toInt() ??
                                                0;
                                            return ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              subtitle: Text(
                                                '${_tr('Aantal', 'Quantity')}: $quantity',
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              trailing: TextButton(
                                                onPressed:
                                                    _isActionLoading ||
                                                        quantity <= 0
                                                    ? null
                                                    : () => _withdrawWeapon(
                                                        weaponId,
                                                      ),
                                                child: Text(_tr('Neem 1', 'Take 1')),
                                              ),
                                            );
                                          })
                                          .toList()),
                                    ],
                                  ),
                                ),
                              ),
                            if (_selectedStorage!.allowedCategories.contains(
                              'cash',
                            ))
                              Card(
                                color: Colors.grey.shade900,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tr('Cashopslag', 'Cash storage'),
                                        style: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: _cashAmountController,
                                        keyboardType: TextInputType.number,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          labelText: _tr('Bedrag', 'Amount'),
                                          labelStyle: TextStyle(
                                            color: Colors.grey.shade300,
                                          ),
                                          filled: true,
                                          fillColor: Colors.grey.shade800,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isActionLoading
                                                  ? null
                                                  : _depositCash,
                                              child: Text(_tr('Cash opslaan', 'Deposit cash')),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isActionLoading
                                                  ? null
                                                  : _withdrawCash,
                                              child: Text(_tr('Cash opnemen', 'Withdraw cash')),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_selectedStorage!.allowedCategories.contains(
                              'drugs',
                            ))
                              Card(
                                color: Colors.grey.shade900,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _tr('Drugopslag', 'Drug storage'),
                                        style: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ...((_storageDetail?['drugs']
                                                  as List<dynamic>? ??
                                              [])
                                          .map((entry) {
                                            final item =
                                                entry as Map<String, dynamic>;
                                            final drugType =
                                                item['drugType']?.toString() ??
                                                '';
                                            final quantity =
                                                (item['quantity'] as num?)
                                                    ?.toInt() ??
                                                0;
                                            return ListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                drugType,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              subtitle: Text(
                                                '${_tr('Aantal', 'Quantity')}: $quantity',
                                                style: TextStyle(
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                              trailing: TextButton(
                                                onPressed:
                                                    _isActionLoading ||
                                                        quantity <= 0
                                                    ? null
                                                    : () => _withdrawDrug(
                                                        drugType,
                                                        quantity,
                                                      ),
                                                child: Text(_tr('Opnemen', 'Withdraw')),
                                              ),
                                            );
                                          })
                                          .toList()),
                                      if (((_storageDetail?['drugs']
                                                      as List<dynamic>? ??
                                                  [])
                                              .isEmpty))
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          child: Text(
                                            _tr('Geen drugs in opslag.', 'No drugs in storage.'),
                                            style: TextStyle(
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            if (!_selectedStorage!.allowedCategories.contains(
                              'tools',
                            ))
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  _tr('Dit pand is niet voor gereedschap-opslag. Gebruik een magazijn voor tools.', 'This property is not for tool storage. Use a warehouse for tools.'),
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            else if (_selectedStorage!.tools.isEmpty)
                              Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 80,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    l10n.noToolsInStorage,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              )
                            else
                              ..._selectedStorage!.tools.map(
                                (tool) => ToolCard(
                                  tool: tool,
                                  onTransfer: () => _showTransferDialog(tool),
                                  showLocation: false,
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
