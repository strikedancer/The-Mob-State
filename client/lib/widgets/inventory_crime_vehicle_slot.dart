import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/vehicle.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/top_right_notification.dart';
import 'overlay_image.dart';

/// Paper-doll slot that assigns a garage car as the crime getaway vehicle.
class InventoryCrimeVehicleSlot extends StatefulWidget {
  const InventoryCrimeVehicleSlot({super.key});

  @override
  State<InventoryCrimeVehicleSlot> createState() =>
      _InventoryCrimeVehicleSlotState();
}

class _InventoryCrimeVehicleSlotState extends State<InventoryCrimeVehicleSlot> {
  final ApiClient _api = ApiClient();
  bool _loading = true;
  bool _busy = false;
  VehicleInventoryItem? _selected;

  String get _playerCountry {
    return Provider.of<AuthProvider>(
          context,
          listen: false,
        ).currentPlayer?.currentCountry ??
        'netherlands';
  }

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    try {
      final crimeRes = await _api.get('/garage/crime-vehicle');
      final invRes = await _api.get('/vehicles/inventory');
      if (!mounted) return;

      VehicleInventoryItem? selected;
      final inventory = <VehicleInventoryItem>[];
      if (invRes.statusCode == 200) {
        final data = jsonDecode(invRes.body) as Map<String, dynamic>;
        inventory.addAll(
          ((data['inventory'] as List?) ?? [])
              .whereType<Map>()
              .map(
                (row) => VehicleInventoryItem.fromJson(
                  Map<String, dynamic>.from(row),
                ),
              ),
        );
      }

      int? inventoryId;
      if (crimeRes.statusCode == 200) {
        final data = jsonDecode(crimeRes.body) as Map<String, dynamic>;
        inventoryId = (data['vehicleInventoryId'] as num?)?.toInt();
      }

      if (inventoryId != null) {
        for (final item in inventory) {
          if (item.id == inventoryId) {
            selected = item;
            break;
          }
        }
      }

      setState(() {
        _selected = selected;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _selected = null;
        _loading = false;
      });
    }
  }

  List<VehicleInventoryItem> _eligibleCars(List<VehicleInventoryItem> all) {
    final country = _playerCountry;
    return all.where((item) {
      if (item.vehicleType != 'car') return false;
      if (item.marketListing) return false;
      if (item.isBusy) return false;
      final location = item.currentLocation ?? item.stolenInCountry;
      return location == country;
    }).toList()
      ..sort((a, b) {
        final nameA = a.definition?.name ?? '';
        final nameB = b.definition?.name ?? '';
        return nameA.compareTo(nameB);
      });
  }

  Future<List<VehicleInventoryItem>> _loadInventory() async {
    final invRes = await _api.get('/vehicles/inventory');
    if (invRes.statusCode != 200) return const [];
    final data = jsonDecode(invRes.body) as Map<String, dynamic>;
    return ((data['inventory'] as List?) ?? [])
        .whereType<Map>()
        .map(
          (row) =>
              VehicleInventoryItem.fromJson(Map<String, dynamic>.from(row)),
        )
        .toList();
  }

  Future<void> _selectCar(VehicleInventoryItem vehicle) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post('/garage/crime-vehicle', {
        'vehicleId': vehicle.id.toString(),
      });
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      if (response.statusCode == 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.vehicleSelectedForCrimes),
            backgroundColor: Colors.green,
          ),
        );
        await _reload();
      } else {
        var message = l10n.failedSelectVehicle;
        try {
          final data = jsonDecode(response.body);
          message = data['params']?['message']?.toString() ?? message;
        } catch (_) {}
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _unequip() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.delete('/garage/crime-vehicle');
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      if (response.statusCode == 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.vehicleDeselectedForCrimes),
            backgroundColor: Colors.green,
          ),
        );
        await _reload();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.failedDeselectVehicle),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openPicker() async {
    final l10n = AppLocalizations.of(context)!;
    final cars = _eligibleCars(await _loadInventory());
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final maxHeight = MediaQuery.of(sheetContext).size.height * 0.7;
        return SafeArea(
          child: SizedBox(
            height: cars.isEmpty ? null : maxHeight,
            child: Column(
              mainAxisSize: cars.isEmpty ? MainAxisSize.min : MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.inventorySelectCrimeCarTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      if (_selected != null)
                        TextButton(
                          onPressed: () {
                            Navigator.pop(sheetContext);
                            _unequip();
                          },
                          child: Text(l10n.inventoryUnequipVehicle),
                        ),
                      IconButton(
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (cars.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Text(
                      l10n.inventoryNoCrimeCars,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                      itemCount: cars.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final car = cars[index];
                        final name = car.definition?.name ?? l10n.selectVehicle;
                        final image = car.conditionImage;
                        final isCurrent = _selected?.id == car.id;
                        return ListTile(
                          selected: isCurrent,
                          selectedTileColor: const Color(0x22D4AF37),
                          leading: SizedBox(
                            width: 48,
                            height: 48,
                            child: image == null
                                ? const Icon(
                                    Icons.directions_car,
                                    color: Colors.white54,
                                  )
                                : OverlayImageBuilder()
                                    .base('assets/images/vehicles/$image')
                                    .width(48.0)
                                    .height(48.0)
                                    .fit(BoxFit.contain)
                                    .build(),
                          ),
                          title: Text(name),
                          subtitle: Text(
                            '${l10n.vehicleCondition} ${car.condition}% · ${l10n.vehicleFuel} ${car.fuelLevel}%',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: isCurrent
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFFD4AF37),
                                )
                              : null,
                          onTap: () {
                            Navigator.pop(sheetContext);
                            if (!isCurrent) _selectCar(car);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = _selected?.definition?.name;
    final image = _selected?.conditionImage;
    final selected = _selected != null;

    return Column(
      children: [
        Tooltip(
          message: name ?? l10n.inventoryEmptySlot,
          child: GestureDetector(
            onTap: _busy || _loading ? null : _openPicker,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFD4AF37)
                      : const Color(0xFF3A3A3A),
                  width: selected ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: _loading || _busy
                  ? const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : image == null
                  ? Icon(
                      Icons.directions_car,
                      size: 22,
                      color: selected ? Colors.white70 : Colors.white38,
                    )
                  : OverlayImageBuilder()
                      .base('assets/images/vehicles/$image')
                      .width(64.0)
                      .height(64.0)
                      .fit(BoxFit.contain)
                      .build(),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 76,
          child: Text(
            l10n.inventoryEquipVehicle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.white54),
          ),
        ),
      ],
    );
  }
}
