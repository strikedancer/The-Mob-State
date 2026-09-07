import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/property.dart';
import '../services/showroom_service.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

class ShowroomScreen extends StatefulWidget {
  final Property property;

  const ShowroomScreen({super.key, required this.property});

  @override
  State<ShowroomScreen> createState() => _ShowroomScreenState();
}

class _ShowroomScreenState extends State<ShowroomScreen>
    with SingleTickerProviderStateMixin {
  final ShowroomService _service = ShowroomService();
  late final TabController _tabController;
  Map<String, dynamic>? _showroom;
  bool _loading = true;
  String? _error;
  int? _busyInventoryId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _service.getShowroom(widget.property.id);
    if (!mounted) return;
    if (result['event'] == 'showroom.loaded' && result['showroom'] is Map) {
      setState(() {
        _showroom = Map<String, dynamic>.from(result['showroom'] as Map);
        _loading = false;
      });
      return;
    }
    setState(() {
      _loading = false;
      _error = _errorMessage(
        AppLocalizations.of(context)!,
        result['params'] is Map ? (result['params'] as Map)['reason']?.toString() : null,
      );
    });
  }

  String _errorMessage(AppLocalizations l10n, String? reason) {
    switch (reason) {
      case 'WRONG_COUNTRY':
      case 'SHOWROOM_WRONG_COUNTRY':
        return l10n.showroomNeedSameCountry;
      case 'SHOWROOM_CONDITION':
        return l10n.showroomNeedPerfectCondition;
      case 'SHOWROOM_GARAGE_FULL':
        return l10n.showroomNeedGarageSpace;
      case 'SHOWROOM_DUPLICATE_MODEL':
        return l10n.showroomDuplicateModel;
      case 'SHOWROOM_FULL':
        return l10n.showroomFull;
      case 'SHOWROOM_WRONG_TYPE':
        return l10n.showroomWrongType;
      case 'SHOWROOM_VEHICLE_BUSY':
      case 'VEHICLE_IN_SHOWROOM':
        return l10n.showroomVehicleBusy;
      default:
        return l10n.showroomLoadError;
    }
  }

  Future<void> _place(int inventoryId) async {
    setState(() => _busyInventoryId = inventoryId);
    final result = await _service.placeVehicle(
      propertyId: widget.property.id,
      vehicleInventoryId: inventoryId,
    );
    if (!mounted) return;
    setState(() => _busyInventoryId = null);
    if (result['event'] == 'showroom.placed' && result['showroom'] is Map) {
      setState(() {
        _showroom = Map<String, dynamic>.from(result['showroom'] as Map);
      });
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(AppLocalizations.of(context)!.showroomPlaced)),
      );
      return;
    }
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          _errorMessage(
            AppLocalizations.of(context)!,
            result['params'] is Map ? (result['params'] as Map)['reason']?.toString() : null,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _remove(int inventoryId) async {
    setState(() => _busyInventoryId = inventoryId);
    final result = await _service.removeVehicle(
      propertyId: widget.property.id,
      vehicleInventoryId: inventoryId,
    );
    if (!mounted) return;
    setState(() => _busyInventoryId = null);
    if (result['event'] == 'showroom.removed' && result['showroom'] is Map) {
      setState(() {
        _showroom = Map<String, dynamic>.from(result['showroom'] as Map);
      });
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(AppLocalizations.of(context)!.showroomRemoved)),
      );
      return;
    }
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          _errorMessage(
            AppLocalizations.of(context)!,
            result['params'] is Map ? (result['params'] as Map)['reason']?.toString() : null,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.showroomTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.showroomCollectionTab),
            Tab(text: l10n.showroomPlaceTab),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _load, child: Text(l10n.showroomRefresh)),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                _buildHeader(l10n),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildVehicleList(
                        l10n,
                        List<Map<String, dynamic>>.from(
                          (_showroom?['exhibits'] as List?)?.whereType<Map>() ?? const [],
                        ),
                        empty: l10n.showroomEmptyCollection,
                        actionLabel: l10n.showroomRemoveAction,
                        onAction: _remove,
                      ),
                      _buildVehicleList(
                        l10n,
                        List<Map<String, dynamic>>.from(
                          (_showroom?['eligible'] as List?)?.whereType<Map>() ?? const [],
                        ),
                        empty: (_showroom?['canManage'] == true)
                            ? l10n.showroomEmptyEligible
                            : l10n.showroomWrongCountryManage,
                        actionLabel: l10n.showroomPlaceAction,
                        onAction: _place,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    final used = _showroom?['slotsUsed'] ?? 0;
    final max = _showroom?['slotsMax'] ?? 0;
    final country = _showroom?['countryId']?.toString() ?? widget.property.countryId;
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.showroomSlots('$used', '$max'),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              country,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(l10n.showroomRules),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList(
    AppLocalizations l10n,
    List<Map<String, dynamic>> vehicles, {
    required String empty,
    required String actionLabel,
    required Future<void> Function(int inventoryId) onAction,
  }) {
    if (vehicles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(empty, textAlign: TextAlign.center),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: vehicles.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          final inventoryId = (vehicle['inventoryId'] as num?)?.toInt();
          final name = vehicle['name']?.toString() ?? l10n.unknown;
          final condition = (vehicle['condition'] as num?)?.toInt() ?? 0;
          final image = vehicle['image']?.toString();
          final busy = inventoryId != null && _busyInventoryId == inventoryId;
          return Card(
            child: ListTile(
              leading: _vehicleThumb(image),
              title: Text(name),
              subtitle: Text('${l10n.condition}: $condition%'),
              trailing: inventoryId == null
                  ? null
                  : FilledButton(
                      onPressed: busy || _showroom?['canManage'] != true
                          ? null
                          : () => onAction(inventoryId),
                      child: busy
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(actionLabel),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _vehicleThumb(String? image) {
    if (image == null || image.isEmpty) {
      return const CircleAvatar(child: Icon(Icons.directions_car));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: 56,
        height: 40,
        child: WebAssetHelper.image(
          'assets/images/vehicles/$image',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const Icon(Icons.directions_car),
        ),
      ),
    );
  }
}
