import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/carried_tool.dart';
import '../models/drug_models.dart';
import '../models/inventory_grid_item.dart';
import '../models/storage_info.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/drug_service.dart';
import '../services/inventory_service.dart';
import '../utils/avatar_helper.dart';
import '../utils/top_right_notification.dart';
import '../widgets/inventory_slot.dart';

const _storageKinds = {
  InventoryItemKind.weapon,
  InventoryItemKind.tool,
  InventoryItemKind.ammo,
  InventoryItemKind.armor,
  InventoryItemKind.material,
};

class InventoryPaperDollTab extends StatefulWidget {
  final int? initialPropertyId;

  const InventoryPaperDollTab({super.key, this.initialPropertyId});

  @override
  State<InventoryPaperDollTab> createState() => _InventoryPaperDollTabState();
}

class _InventoryPaperDollTabState extends State<InventoryPaperDollTab> {
  final InventoryService _inventory = InventoryService();
  final DrugService _drugs = DrugService();
  final ApiClient _api = ApiClient();
  final TextEditingController _cashController = TextEditingController();

  bool _loading = true;
  InventorySlots _slots = InventorySlots(used: 0, max: 5);
  List<InventoryGridItem> _backpack = [];
  List<InventoryGridItem> _contextItems = [];
  List<StorageInfo> _properties = [];
  String _contextKey = 'depot';
  InventoryGridItem? _selected;
  String? _crimeWeaponId;
  String? _secondaryWeaponId;
  InventoryGridItem? _equippedWeapon;
  InventoryGridItem? _equippedSecondary;
  InventoryGridItem? _equippedArmor;
  bool _busy = false;

  static const _paperDollTypes = {
    'warehouse',
    'house',
    'apartment',
    'mansion',
    'penthouse',
    'safehouse',
  };

  String _toolAssetPath(String toolId) {
    // Asset naming convention is usually: <toolId>_tool.png
    // One legacy asset is produced with an extra .png suffix.
    if (toolId == 'thermal_drill') {
      return 'assets/images/tools/thermal_drill_tool.png.png';
    }
    if (toolId.endsWith('_tool')) {
      return 'assets/images/tools/$toolId.png';
    }
    return 'assets/images/tools/${toolId}_tool.png';
  }

  int? get _selectedPropertyId {
    if (_contextKey.startsWith('property_')) {
      return int.tryParse(_contextKey.substring('property_'.length));
    }
    return null;
  }

  StorageInfo? get _selectedStorage {
    final id = _selectedPropertyId;
    if (id == null) return null;
    for (final property in _properties) {
      if (property.propertyId == id) return property;
    }
    return null;
  }

  List<StorageInfo> get _selectableProperties => _properties
      .where((p) => _paperDollTypes.contains(p.propertyType))
      .toList();

  @override
  void initState() {
    super.initState();
    if (widget.initialPropertyId != null) {
      _contextKey = 'property_${widget.initialPropertyId}';
    }
    _reload();
  }

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    try {
      final toolsResult = await _inventory.getCarriedTools();
      final overview = await _inventory.getStorageOverview();
      final weaponsRes = await _api.get('/weapons/inventory');
      final ammoRes = await _api.get('/ammo/inventory');
      final crimeRes = await _api.get('/weapons/crime-weapon');
      final secondaryRes = await _api.get('/weapons/secondary-weapon');
      final securityRes = await _api.get('/security/status');
      final materials = await _drugs.getPlayerMaterials();

      final tools = (toolsResult['success'] == true)
          ? (toolsResult['tools'] as List<CarriedTool>)
          : <CarriedTool>[];
      if (toolsResult['slots'] is InventorySlots) {
        _slots = toolsResult['slots'] as InventorySlots;
      }

      final weapons = <Map<String, dynamic>>[];
      if (weaponsRes.statusCode == 200) {
        final data = jsonDecode(weaponsRes.body);
        weapons.addAll(
          ((data['weapons'] as List?) ?? []).whereType<Map>().map(
            (w) => Map<String, dynamic>.from(w),
          ),
        );
      }
      final ammo = <Map<String, dynamic>>[];
      if (ammoRes.statusCode == 200) {
        final data = jsonDecode(ammoRes.body);
        ammo.addAll(
          ((data['ammo'] as List?) ?? []).whereType<Map>().map(
            (a) => Map<String, dynamic>.from(a),
          ),
        );
      }

      _crimeWeaponId = null;
      _secondaryWeaponId = null;
      if (crimeRes.statusCode == 200) {
        final data = jsonDecode(crimeRes.body);
        _crimeWeaponId = data['weapon']?['weaponId']?.toString();
      }
      if (secondaryRes.statusCode == 200) {
        final data = jsonDecode(secondaryRes.body);
        _secondaryWeaponId = data['weapon']?['weaponId']?.toString();
      }

      InventoryGridItem? armor;
      if (securityRes.statusCode == 200) {
        final data = jsonDecode(securityRes.body);
        final security = data['security'] ?? data;
        final armorType = security['armorType']?.toString();
        if (armorType != null &&
            armorType.isNotEmpty &&
            ((security['baseArmor'] as num?)?.toInt() ??
                    (security['armor'] as num?)?.toInt() ??
                    0) >
                0) {
          armor = InventoryGridItem(
            kind: InventoryItemKind.armor,
            id: armorType,
            name: armorType,
            quantity: 1,
            condition: (security['armorCondition'] as num?)?.toInt(),
            zone: InventoryZone.equippedArmor,
            imagePath: 'assets/images/security/$armorType.png',
          );
        }
      }

      final backpack = <InventoryGridItem>[
        ...tools.map(
          (t) => InventoryGridItem(
            kind: InventoryItemKind.tool,
            id: t.toolId,
            name: t.name,
            quantity: t.quantity,
            condition: t.maxDurability > 0
                ? ((t.durability / t.maxDurability) * 100).round()
                : null,
            zone: InventoryZone.backpack,
            imagePath: _toolAssetPath(t.toolId),
          ),
        ),
        ...weapons.map(
          (w) => InventoryGridItem(
            kind: InventoryItemKind.weapon,
            id: '${w['weaponId']}',
            name: '${w['name'] ?? w['weaponId']}',
            quantity: (w['quantity'] as num?)?.toInt() ?? 1,
            condition: (w['condition'] as num?)?.toInt(),
            zone: InventoryZone.backpack,
            imagePath: 'assets/images/weapons/${w['weaponId']}.png',
          ),
        ),
        ...ammo.map(
          (a) => InventoryGridItem(
            kind: InventoryItemKind.ammo,
            id: '${a['ammoType'] ?? a['type']}',
            name: '${a['name'] ?? a['ammoType'] ?? a['type']}',
            quantity: (a['quantity'] as num?)?.toInt() ?? 0,
            zone: InventoryZone.backpack,
            imagePath: 'assets/images/ammo/${a['ammoType'] ?? a['type']}.png',
          ),
        ),
        ...materials.carried.map(
          (m) => InventoryGridItem(
            kind: InventoryItemKind.material,
            id: m.materialId,
            name: m.name,
            quantity: m.quantity,
            zone: InventoryZone.backpack,
            imagePath: m.getImagePath(),
          ),
        ),
      ].where((item) => item.quantity > 0).toList();

      _equippedWeapon = _weaponFromInventory(
        backpack,
        _crimeWeaponId,
        InventoryZone.equippedWeapon,
      );
      _equippedSecondary = _weaponFromInventory(
        backpack,
        _secondaryWeaponId,
        InventoryZone.equippedSecondary,
      );

      _properties = overview['success'] == true
          ? (overview['storage'] as List<StorageInfo>)
          : <StorageInfo>[];

      if (_contextKey.startsWith('property_')) {
        final exists = _selectableProperties.any(
          (p) => p.propertyId == _selectedPropertyId,
        );
        if (!exists) _contextKey = 'depot';
      }

      _backpack = backpack;
      _equippedArmor = armor;
      await _loadContextItems(materials);
    } catch (_) {
      // Keep last successful snapshot; loading flag drops below.
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _loadContextItems(PlayerMaterialsSnapshot materials) async {
    if (_contextKey == 'depot') {
      _contextItems = materials.depot
          .where((m) => m.quantity > 0)
          .map(
            (m) => InventoryGridItem(
              kind: InventoryItemKind.material,
              id: m.materialId,
              name: m.name,
              quantity: m.quantity,
              zone: InventoryZone.depot,
              imagePath: m.getImagePath(),
            ),
          )
          .toList();
      return;
    }

    final info = _selectedStorage;
    if (info == null || !info.accessibleInCurrentCountry) {
      _contextItems = [];
      return;
    }

    if (info.allowedCategories.contains('tools')) {
      _contextItems = info.tools
          .where((t) => t.quantity > 0)
          .map(
            (t) => InventoryGridItem(
              kind: InventoryItemKind.tool,
              id: t.toolId,
              name: t.name,
              quantity: t.quantity,
              zone: InventoryZone.property,
              imagePath: _toolAssetPath(t.toolId),
            ),
          )
          .toList();
      return;
    }

    final detail = await _inventory.getPropertyStorageDetail(info.propertyId);
    if (detail['success'] != true) {
      _contextItems = [];
      return;
    }
    final storage = detail['storage'] as Map<String, dynamic>;
    final items = <InventoryGridItem>[];
    for (final w in (storage['weapons'] as List? ?? [])) {
      final row = Map<String, dynamic>.from(w as Map);
      items.add(
        InventoryGridItem(
          kind: InventoryItemKind.weapon,
          id: '${row['weaponId']}',
          name: '${row['name'] ?? row['weaponId']}',
          quantity: (row['quantity'] as num?)?.toInt() ?? 1,
          zone: InventoryZone.property,
          imagePath: 'assets/images/weapons/${row['weaponId']}.png',
        ),
      );
    }
    for (final a in (storage['ammo'] as List? ?? [])) {
      final row = Map<String, dynamic>.from(a as Map);
      items.add(
        InventoryGridItem(
          kind: InventoryItemKind.ammo,
          id: '${row['ammoType']}',
          name: '${row['name'] ?? row['ammoType']}',
          quantity: (row['quantity'] as num?)?.toInt() ?? 0,
          zone: InventoryZone.property,
          imagePath: 'assets/images/ammo/${row['ammoType']}.png',
        ),
      );
    }
    for (final v in (storage['armor'] as List? ?? [])) {
      final row = Map<String, dynamic>.from(v as Map);
      items.add(
        InventoryGridItem(
          kind: InventoryItemKind.armor,
          id: '${row['armorId']}',
          name: '${row['name'] ?? row['armorId']}',
          quantity: (row['quantity'] as num?)?.toInt() ?? 1,
          condition: (row['condition'] as num?)?.toInt(),
          zone: InventoryZone.property,
          imagePath: 'assets/images/security/${row['armorId']}.png',
        ),
      );
    }
    _contextItems = items.where((i) => i.quantity > 0).toList();
  }

  bool _isWeaponEquipZone(InventoryZone zone) {
    return zone == InventoryZone.equippedWeapon ||
        zone == InventoryZone.equippedSecondary;
  }

  InventoryGridItem? _weaponFromInventory(
    List<InventoryGridItem> backpack,
    String? weaponId,
    InventoryZone zone,
  ) {
    if (weaponId == null) return null;
    for (final item in backpack) {
      if (item.kind == InventoryItemKind.weapon && item.id == weaponId) {
        return InventoryGridItem(
          kind: InventoryItemKind.weapon,
          id: item.id,
          name: item.name,
          quantity: 1,
          condition: item.condition,
          zone: zone,
          imagePath: item.imagePath,
        );
      }
    }
    return null;
  }

  List<InventoryGridItem> _backpackGridItems() {
    final hidden = <String, int>{};
    void hide(InventoryGridItem? item) {
      if (item == null) return;
      hidden[item.id] = (hidden[item.id] ?? 0) + 1;
    }

    hide(_equippedWeapon);
    hide(_equippedSecondary);

    return _backpack
        .map((item) {
          if (item.kind != InventoryItemKind.weapon) return item;
          final worn = hidden[item.id] ?? 0;
          if (worn <= 0) return item;
          final remaining = item.quantity - worn;
          if (remaining <= 0) return null;
          return InventoryGridItem(
            kind: item.kind,
            id: item.id,
            name: item.name,
            quantity: remaining,
            condition: item.condition,
            zone: item.zone,
            imagePath: item.imagePath,
          );
        })
        .whereType<InventoryGridItem>()
        .toList();
  }

  Future<bool> _setWeaponSlot(InventoryZone zone, String weaponId) async {
    if (zone == InventoryZone.equippedWeapon) {
      return _setCrimeWeapon(weaponId);
    }
    return _setSecondaryWeapon(weaponId);
  }

  Future<bool> _clearWeaponSlot(InventoryZone zone) async {
    if (zone == InventoryZone.equippedWeapon) {
      return _clearCrimeWeapon();
    }
    return _clearSecondaryWeapon();
  }

  Future<bool> _setCrimeWeapon(String weaponId) async {
    final response = await _api.post('/weapons/crime-weapon', {
      'weaponId': weaponId,
    });
    if (response.statusCode == 200) {
      _crimeWeaponId = weaponId;
      if (_secondaryWeaponId == weaponId) {
        _secondaryWeaponId = null;
      }
      return true;
    }
    return false;
  }

  Future<bool> _clearCrimeWeapon() async {
    final response = await _api.delete('/weapons/crime-weapon');
    if (response.statusCode == 200) {
      _crimeWeaponId = null;
      return true;
    }
    return false;
  }

  Future<bool> _setSecondaryWeapon(String weaponId) async {
    final response = await _api.post('/weapons/secondary-weapon', {
      'weaponId': weaponId,
    });
    if (response.statusCode == 200) {
      _secondaryWeaponId = weaponId;
      if (_crimeWeaponId == weaponId) {
        _crimeWeaponId = null;
      }
      return true;
    }
    return false;
  }

  Future<bool> _clearSecondaryWeapon() async {
    final response = await _api.delete('/weapons/secondary-weapon');
    if (response.statusCode == 200) {
      _secondaryWeaponId = null;
      return true;
    }
    return false;
  }

  bool _isStackableMove(InventoryGridItem source, InventoryZone target) {
    if (source.quantity <= 1) return false;
    if (_isWeaponEquipZone(source.zone) ||
        _isWeaponEquipZone(target) ||
        target == InventoryZone.equippedArmor) {
      return false;
    }
    switch (source.kind) {
      case InventoryItemKind.ammo:
      case InventoryItemKind.material:
      case InventoryItemKind.weapon:
      case InventoryItemKind.tool:
        return true;
      case InventoryItemKind.armor:
        return false;
    }
  }

  Future<int?> _askTransferQuantity(InventoryGridItem source) async {
    final controller = TextEditingController(text: '${source.quantity}');
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        final dlgL10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(dlgL10n.selectQuantity),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: dlgL10n.quantity,
              helperText: dlgL10n.inventoryMaxShort(source.quantity),
              filled: true,
              fillColor: const Color(0xFF151515),
              border: const OutlineInputBorder(),
            ),
          ),
          actionsOverflowButtonSpacing: 8,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(dlgL10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(1),
              child: Text(dlgL10n.inventoryMoveOne),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(source.quantity),
              child: Text(dlgL10n.inventoryMoveAll),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = int.tryParse(controller.text.trim()) ?? 0;
                if (qty <= 0 || qty > source.quantity) {
                  showTopRightFromSnackBar(
                    dialogContext,
                    SnackBar(content: Text(dlgL10n.inventoryInvalidQuantity)),
                  );
                  return;
                }
                Navigator.of(dialogContext).pop(qty);
              },
              child: Text(dlgL10n.inventoryTransferOk),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result;
  }

  void _onTapItem(InventoryGridItem item) {
    if (_selected == null) {
      setState(() => _selected = item);
      return;
    }
    if (_selected!.id == item.id && _selected!.zone == item.zone) {
      setState(() => _selected = null);
      return;
    }
    _transfer(_selected!, item.zone);
  }

  void _onTapZone(InventoryZone zone) {
    if (_selected == null) return;
    _transfer(_selected!, zone);
  }

  Future<void> _transfer(InventoryGridItem source, InventoryZone target) async {
    if (_busy) return;
    if (source.zone == target) {
      setState(() => _selected = null);
      return;
    }
    if (!_storageKinds.contains(source.kind)) {
      setState(() => _selected = null);
      return;
    }

    var quantity = 1;
    if (_isStackableMove(source, target)) {
      final chosen = await _askTransferQuantity(source);
      if (!mounted) return;
      if (chosen == null) {
        setState(() => _selected = null);
        return;
      }
      quantity = chosen;
    }

    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context)!;
    Map<String, dynamic> result = {
      'success': false,
      'error': l10n.inventoryWrongDrop,
    };

    try {
      final propertyId = _selectedPropertyId;
      if (source.kind == InventoryItemKind.weapon &&
          _isWeaponEquipZone(target) &&
          source.zone == InventoryZone.backpack) {
        final ok = await _setWeaponSlot(target, source.id);
        result = {
          'success': ok,
          'error': ok ? null : l10n.inventoryWrongDrop,
        };
      } else if (source.kind == InventoryItemKind.weapon &&
          _isWeaponEquipZone(source.zone) &&
          target == InventoryZone.backpack) {
        final ok = await _clearWeaponSlot(source.zone);
        result = {
          'success': ok,
          'error': ok ? null : l10n.inventoryWrongDrop,
        };
      } else if (source.kind == InventoryItemKind.weapon &&
          _isWeaponEquipZone(source.zone) &&
          _isWeaponEquipZone(target)) {
        final ok = await _setWeaponSlot(target, source.id);
        result = {
          'success': ok,
          'error': ok ? null : l10n.inventoryWrongDrop,
        };
      } else if (source.kind == InventoryItemKind.weapon &&
          _isWeaponEquipZone(source.zone) &&
          target == InventoryZone.property &&
          propertyId != null) {
        result = await _inventory.depositWeaponToProperty(
          propertyId: propertyId,
          weaponId: source.id,
          quantity: 1,
        );
        if (result['success'] == true) {
          await _clearWeaponSlot(source.zone);
        }
      } else if (source.kind == InventoryItemKind.armor &&
          source.zone == InventoryZone.equippedArmor &&
          target == InventoryZone.property &&
          propertyId != null) {
        result = await _inventory.depositArmorToProperty(propertyId: propertyId);
      } else if (source.kind == InventoryItemKind.armor &&
          source.zone == InventoryZone.property &&
          target == InventoryZone.equippedArmor &&
          propertyId != null) {
        result = await _inventory.withdrawArmorFromProperty(
          propertyId: propertyId,
          armorId: source.id,
        );
      } else if (source.kind == InventoryItemKind.weapon &&
          source.zone == InventoryZone.backpack &&
          target == InventoryZone.property &&
          propertyId != null) {
        result = await _inventory.depositWeaponToProperty(
          propertyId: propertyId,
          weaponId: source.id,
          quantity: quantity,
        );
      } else if (source.kind == InventoryItemKind.weapon &&
          source.zone == InventoryZone.property &&
          (target == InventoryZone.backpack || _isWeaponEquipZone(target)) &&
          propertyId != null) {
        final toEquip = _isWeaponEquipZone(target);
        result = await _inventory.withdrawWeaponFromProperty(
          propertyId: propertyId,
          weaponId: source.id,
          quantity: toEquip ? 1 : quantity,
          equip: toEquip,
        );
        if (result['success'] == true && toEquip) {
          await _setWeaponSlot(target, source.id);
        }
      } else if (source.kind == InventoryItemKind.tool &&
          source.zone == InventoryZone.backpack &&
          target == InventoryZone.property &&
          propertyId != null) {
        result = await _inventory.transferTool(
          toolId: source.id,
          fromLocation: 'carried',
          toLocation: 'property_$propertyId',
          quantity: quantity,
        );
      } else if (source.kind == InventoryItemKind.tool &&
          source.zone == InventoryZone.property &&
          target == InventoryZone.backpack &&
          propertyId != null) {
        result = await _inventory.transferTool(
          toolId: source.id,
          fromLocation: 'property_$propertyId',
          toLocation: 'carried',
          quantity: quantity,
        );
      } else if (source.kind == InventoryItemKind.ammo &&
          source.zone == InventoryZone.backpack &&
          target == InventoryZone.property &&
          propertyId != null) {
        result = await _inventory.depositAmmoToProperty(
          propertyId: propertyId,
          ammoType: source.id,
          quantity: quantity,
        );
      } else if (source.kind == InventoryItemKind.ammo &&
          source.zone == InventoryZone.property &&
          target == InventoryZone.backpack &&
          propertyId != null) {
        result = await _inventory.withdrawAmmoFromProperty(
          propertyId: propertyId,
          ammoType: source.id,
          quantity: quantity,
        );
      } else if (source.kind == InventoryItemKind.material &&
          source.zone == InventoryZone.backpack &&
          target == InventoryZone.depot) {
        result = await _drugs.transferMaterial(
          materialId: source.id,
          quantity: quantity,
          direction: 'to_depot',
        );
      } else if (source.kind == InventoryItemKind.material &&
          source.zone == InventoryZone.depot &&
          target == InventoryZone.backpack) {
        result = await _drugs.transferMaterial(
          materialId: source.id,
          quantity: quantity,
          direction: 'to_backpack',
        );
      }
    } catch (e) {
      result = {'success': false, 'error': '$e'};
    }

    if (!mounted) return;
    final ok = result['success'] == true;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          ok
              ? l10n.inventoryTransferOk
              : '${l10n.inventoryTransferFailed}: ${result['error'] ?? result['reason'] ?? result['message'] ?? ''}',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    setState(() {
      _selected = null;
      _busy = false;
    });
    await _reload();
  }

  Future<void> _moveCash({required bool deposit}) async {
    final property = _selectedStorage;
    if (property == null || _busy) return;
    final amount = int.tryParse(_cashController.text.trim()) ?? 0;
    if (amount <= 0) return;
    setState(() => _busy = true);
    final l10n = AppLocalizations.of(context)!;
    final result = deposit
        ? await _inventory.depositCashToProperty(
            propertyId: property.propertyId,
            amount: amount,
          )
        : await _inventory.withdrawCashFromProperty(
            propertyId: property.propertyId,
            amount: amount,
          );
    if (!mounted) return;
    final ok = result['success'] == true;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          ok
              ? (deposit
                    ? l10n.inventorySnackCashStored
                    : l10n.inventorySnackCashWithdrawn)
              : '${l10n.inventoryTransferFailed}: ${result['error'] ?? ''}',
        ),
        backgroundColor: ok ? Colors.green : Colors.red,
      ),
    );
    setState(() => _busy = false);
    if (ok) _cashController.clear();
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final player = Provider.of<AuthProvider>(context).currentPlayer;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final wide = MediaQuery.sizeOf(context).width >= 900;
    final doll = _buildDoll(l10n, player?.avatar, player?.activePortraitPath);
    final pack = _buildGrid(
      title: l10n.inventorySlotUsage(_slots.used, _slots.max),
      items: _backpackGridItems(),
      emptySlots: _slots.max,
      zone: InventoryZone.backpack,
    );
    final stash = _buildContextPanel(l10n);

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        children: [
          if (_selected != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.inventorySelectHint(_selected!.name),
                style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
              ),
            ),
          if (wide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: doll),
                const SizedBox(width: 12),
                Expanded(flex: 4, child: pack),
                const SizedBox(width: 12),
                Expanded(flex: 4, child: stash),
              ],
            )
          else ...[
            doll,
            const SizedBox(height: 12),
            pack,
            const SizedBox(height: 12),
            stash,
          ],
        ],
      ),
    );
  }

  Widget _labeledEquipSlot({
    required String label,
    required InventoryGridItem? item,
    required InventoryZone zone,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: InventorySlot(
            item: item,
            selected: _selected?.zone == zone && _selected?.id == item?.id,
            acceptDrop: true,
            onAccept: (p) => _transfer(p.item, zone),
            onTap: () {
              if (item != null) {
                _onTapItem(item);
              } else {
                _onTapZone(zone);
              }
            },
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 76,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
        ),
      ],
    );
  }

  Widget _buildDoll(AppLocalizations l10n, String? avatar, String? portrait) {
    return Card(
      color: const Color(0xFF151515),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              l10n.inventoryPaperDoll,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _labeledEquipSlot(
                      label: l10n.inventoryEquipWeapon,
                      item: _equippedWeapon,
                      zone: InventoryZone.equippedWeapon,
                    ),
                    const SizedBox(height: 8),
                    _labeledEquipSlot(
                      label: l10n.inventoryEquipSecondary,
                      item: _equippedSecondary,
                      zone: InventoryZone.equippedSecondary,
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: AvatarHelper.getAvatarImageProvider(
                      avatar,
                      activePortraitPath: portrait,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _labeledEquipSlot(
                  label: l10n.inventoryEquipArmor,
                  item: _equippedArmor,
                  zone: InventoryZone.equippedArmor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextPanel(AppLocalizations l10n) {
    final storage = _selectedStorage;
    final contextValue =
        _contextKey.startsWith('property_') &&
            !_selectableProperties.any((p) => 'property_${p.propertyId}' == _contextKey)
        ? 'depot'
        : _contextKey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: contextValue,
          dropdownColor: const Color(0xFF2A2A2A),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            labelText: l10n.inventoryStorageGrid,
            border: const OutlineInputBorder(),
          ),
          items: [
            DropdownMenuItem(
              value: 'depot',
              child: Text(l10n.inventoryMaterialsDepot),
            ),
            ..._selectableProperties.map(
              (p) => DropdownMenuItem(
                value: 'property_${p.propertyId}',
                enabled: p.accessibleInCurrentCountry,
                child: Text(
                  '${p.propertyType} #${p.propertyId}'
                  '${p.accessibleInCurrentCountry ? '' : ' ✕'}',
                ),
              ),
            ),
          ],
          onChanged: (value) async {
            if (value == null) return;
            setState(() => _contextKey = value);
            final materials = await _drugs.getPlayerMaterials();
            await _loadContextItems(materials);
            if (mounted) setState(() {});
          },
        ),
        const SizedBox(height: 8),
        if (storage != null && !storage.accessibleInCurrentCountry)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.inventoryStorageWrongCountry,
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ),
        if (storage != null && storage.accessibleInCurrentCountry)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l10n.inventoryStorageSlotsDetail(
                storage.usage,
                storage.capacity,
                '${storage.percentFull}',
              ),
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
        _buildGrid(
          title: _contextKey == 'depot'
              ? l10n.inventoryMaterialsDepot
              : l10n.inventoryStorageGrid,
          items: _contextItems,
          emptySlots: storage?.capacity ?? 12,
          zone: _contextKey == 'depot'
              ? InventoryZone.depot
              : InventoryZone.property,
        ),
        if (storage != null &&
            storage.accessibleInCurrentCountry &&
            storage.allowedCategories.contains('cash'))
          _buildCashPanel(l10n, storage),
      ],
    );
  }

  Widget _buildCashPanel(AppLocalizations l10n, StorageInfo storage) {
    return Card(
      color: const Color(0xFF151515),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.inventoryCashStorageTitle} (€${storage.cashAmount})',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.bankScreenAmountLabel,
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _busy ? null : () => _moveCash(deposit: true),
                    child: Text(l10n.inventoryDepositCash),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _busy ? null : () => _moveCash(deposit: false),
                    child: Text(l10n.inventoryWithdrawCash),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid({
    required String title,
    required List<InventoryGridItem> items,
    required int emptySlots,
    required InventoryZone zone,
  }) {
    final cells = <InventoryGridItem?>[...items];
    final minSlots = emptySlots < 8 ? 8 : emptySlots;
    while (cells.length < minSlots) {
      cells.add(null);
    }
    return Card(
      color: const Color(0xFF151515),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            DragTarget<InventoryDragPayload>(
              onWillAcceptWithDetails: (_) => true,
              onAcceptWithDetails: (details) =>
                  _transfer(details.data.item, zone),
              builder: (context, candidate, rejected) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cells.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 72,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = cells[index];
                    return InventorySlot(
                      item: item,
                      selected:
                          item != null &&
                          _selected?.id == item.id &&
                          _selected?.zone == item.zone,
                      highlighted: candidate.isNotEmpty,
                      acceptDrop: true,
                      onAccept: (p) => _transfer(p.item, zone),
                      onTap: item == null
                          ? () => _onTapZone(zone)
                          : () => _onTapItem(item),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
