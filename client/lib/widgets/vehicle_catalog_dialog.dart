import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/vehicle.dart';
import '../utils/formatters.dart';
import 'overlay_image.dart';

enum VehicleCatalogFilter { all, available, eventOnly }

enum VehicleCatalogSort { value, rank, rarity, name }

const Color _gold = Color(0xFFD4AF37);
const Color _panelBg = Color(0xFF151B28);
const Color _panelBorder = Color(0xFF2A3344);

int _rarityOrder(String? rarity) {
  switch ((rarity ?? 'common').toLowerCase()) {
    case 'legendary':
      return 5;
    case 'epic':
      return 4;
    case 'rare':
      return 3;
    case 'uncommon':
      return 2;
    default:
      return 1;
  }
}

Color rarityColor(String rarity) {
  switch (rarity.toLowerCase()) {
    case 'common':
      return Colors.greenAccent.shade100;
    case 'uncommon':
      return Colors.lightBlueAccent.shade100;
    case 'rare':
      return Colors.deepPurpleAccent.shade100;
    case 'epic':
      return Colors.purple.shade300;
    case 'legendary':
      return Colors.amber.shade300;
    default:
      return Colors.white70;
  }
}

String rarityLabel(AppLocalizations l10n, String rarity) {
  switch (rarity.toLowerCase()) {
    case 'common':
      return l10n.vehicleHeistRarityCommon;
    case 'uncommon':
      return l10n.vehicleHeistRarityUncommon;
    case 'rare':
      return l10n.vehicleHeistRarityRare;
    case 'epic':
      return l10n.vehicleHeistRarityEpic;
    case 'legendary':
      return l10n.vehicleHeistRarityLegendary;
    default:
      return rarity;
  }
}

bool _isPoliceEventVehicle(VehicleDefinition vehicle) {
  return (vehicle.id ?? '').startsWith('event_politie_');
}

bool _hasWorldStock(VehicleDefinition vehicle) {
  final remaining = vehicle.remainingWorldAvailability;
  if (remaining != null) return remaining > 0;
  final max = vehicle.maxGameAvailability;
  final current = vehicle.currentWorldCount ?? 0;
  if (max == null || max <= 0) return true;
  return current < max;
}

List<VehicleDefinition> filterAndSortCatalogVehicles(
  List<VehicleDefinition> source, {
  required VehicleCatalogFilter filter,
  required VehicleCatalogSort sort,
}) {
  final filtered = source.where((vehicle) {
    switch (filter) {
      case VehicleCatalogFilter.available:
        return _hasWorldStock(vehicle);
      case VehicleCatalogFilter.eventOnly:
        return _isPoliceEventVehicle(vehicle);
      case VehicleCatalogFilter.all:
        return true;
    }
  }).toList();

  filtered.sort((a, b) {
    final aEvent = _isPoliceEventVehicle(a);
    final bEvent = _isPoliceEventVehicle(b);
    if (aEvent != bEvent) return aEvent ? -1 : 1;

    switch (sort) {
      case VehicleCatalogSort.rank:
        final rankCmp =
            (a.requiredRank ?? 0).compareTo(b.requiredRank ?? 0);
        if (rankCmp != 0) return rankCmp;
        return (b.baseValue ?? 0).compareTo(a.baseValue ?? 0);
      case VehicleCatalogSort.rarity:
        final rarityCmp =
            _rarityOrder(b.rarity).compareTo(_rarityOrder(a.rarity));
        if (rarityCmp != 0) return rarityCmp;
        return (b.baseValue ?? 0).compareTo(a.baseValue ?? 0);
      case VehicleCatalogSort.name:
        return (a.name ?? '').compareTo(b.name ?? '');
      case VehicleCatalogSort.value:
        return (b.baseValue ?? 0).compareTo(a.baseValue ?? 0);
    }
  });

  return filtered;
}

class VehicleCatalogDialog extends StatefulWidget {
  const VehicleCatalogDialog({
    super.key,
    required this.title,
    required this.vehicles,
    required this.currentCountry,
    this.headerBanner,
  });

  final String title;
  final List<VehicleDefinition> vehicles;
  final String currentCountry;
  final Widget? headerBanner;

  @override
  State<VehicleCatalogDialog> createState() => _VehicleCatalogDialogState();
}

class _VehicleCatalogDialogState extends State<VehicleCatalogDialog> {
  VehicleCatalogFilter _filter = VehicleCatalogFilter.all;
  VehicleCatalogSort _sort = VehicleCatalogSort.value;

  List<VehicleDefinition> get _visibleVehicles => filterAndSortCatalogVehicles(
        widget.vehicles,
        filter: _filter,
        sort: _sort,
      );

  Widget _buildFilterSortBar(AppLocalizations l10n) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ChoiceChip(
          label: Text(l10n.vehicleHeistCatalogFilterAll),
          selected: _filter == VehicleCatalogFilter.all,
          onSelected: (_) =>
              setState(() => _filter = VehicleCatalogFilter.all),
          selectedColor: _gold.withValues(alpha: 0.22),
          labelStyle: TextStyle(
            color: _filter == VehicleCatalogFilter.all
                ? _gold
                : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: _filter == VehicleCatalogFilter.all
                ? _gold.withValues(alpha: 0.55)
                : _panelBorder,
          ),
        ),
        ChoiceChip(
          label: Text(l10n.vehicleHeistCatalogFilterAvailable),
          selected: _filter == VehicleCatalogFilter.available,
          onSelected: (_) =>
              setState(() => _filter = VehicleCatalogFilter.available),
          selectedColor: Colors.greenAccent.withValues(alpha: 0.18),
          labelStyle: TextStyle(
            color: _filter == VehicleCatalogFilter.available
                ? Colors.greenAccent
                : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: _filter == VehicleCatalogFilter.available
                ? Colors.greenAccent.withValues(alpha: 0.55)
                : _panelBorder,
          ),
        ),
        ChoiceChip(
          label: Text(l10n.vehicleHeistCatalogFilterEvent),
          selected: _filter == VehicleCatalogFilter.eventOnly,
          onSelected: (_) =>
              setState(() => _filter = VehicleCatalogFilter.eventOnly),
          selectedColor: Colors.redAccent.withValues(alpha: 0.18),
          labelStyle: TextStyle(
            color: _filter == VehicleCatalogFilter.eventOnly
                ? Colors.redAccent
                : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
          side: BorderSide(
            color: _filter == VehicleCatalogFilter.eventOnly
                ? Colors.redAccent.withValues(alpha: 0.55)
                : _panelBorder,
          ),
        ),
        Text(
          l10n.vehicleHeistCatalogSortLabel,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        DropdownButton<VehicleCatalogSort>(
          value: _sort,
          dropdownColor: _panelBg,
          underline: const SizedBox.shrink(),
          iconEnabledColor: _gold,
          style: const TextStyle(color: Colors.white, fontSize: 12.5),
          items: [
            DropdownMenuItem(
              value: VehicleCatalogSort.value,
              child: Text(l10n.vehicleHeistCatalogSortValue),
            ),
            DropdownMenuItem(
              value: VehicleCatalogSort.rank,
              child: Text(l10n.vehicleHeistCatalogSortRank),
            ),
            DropdownMenuItem(
              value: VehicleCatalogSort.rarity,
              child: Text(l10n.vehicleHeistCatalogSortRarity),
            ),
            DropdownMenuItem(
              value: VehicleCatalogSort.name,
              child: Text(l10n.vehicleHeistCatalogSortName),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;
            setState(() => _sort = value);
          },
        ),
      ],
    );
  }

  Widget _buildCatalogCard(AppLocalizations l10n, VehicleDefinition vehicle) {
    final image = vehicle.imageNew ?? vehicle.image;
    final rarity = (vehicle.rarity ?? 'common').toLowerCase();
    final marketValue =
        vehicle.marketValue?[widget.currentCountry] ?? vehicle.baseValue ?? 0;
    final countries = vehicle.availableInCountries ?? const <String>[];
    final primaryCountry = countries.isNotEmpty ? countries.first : '-';
    final isPoliceEventVehicle = _isPoliceEventVehicle(vehicle);
    final availabilityLabel =
        '${vehicle.currentWorldCount ?? 0}/${vehicle.maxGameAvailability ?? '-'}';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPoliceEventVehicle
              ? Colors.redAccent.withValues(alpha: 0.45)
              : _panelBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: OverlayImageBuilder()
                      .base('assets/images/vehicles/$image')
                      .width(90)
                      .height(64)
                      .fit(BoxFit.contain)
                      .build(),
                )
              else
                const SizedBox(width: 90, height: 64),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.name ?? '-',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: rarityColor(rarity).withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: rarityColor(rarity)),
                          ),
                          child: Text(
                            rarityLabel(l10n, rarity),
                            style: TextStyle(
                              color: rarityColor(rarity),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (isPoliceEventVehicle)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.redAccent.withValues(alpha: 0.7),
                              ),
                            ),
                            child: Text(
                              l10n.vehicleHeistEventOnlyTag,
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        Text(
                          l10n.vehicleHeistCatalogValue(
                            formatCurrency(marketValue),
                          ),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          l10n.vehicleHeistCatalogRank(
                            (vehicle.requiredRank ?? '-').toString(),
                          ),
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if ((vehicle.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              vehicle.description!,
              style: const TextStyle(color: Colors.white60, height: 1.3),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            l10n.vehicleHeistCatalogInGameAvailability(availabilityLabel),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.vehicleHeistCatalogMostCommonIn(primaryCountry),
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.vehicleHeistCatalogCountries(countries.join(', ')),
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dialogWidth = MediaQuery.sizeOf(context).width < 700
        ? MediaQuery.sizeOf(context).width - 32
        : 760.0;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;
    final visible = _visibleVehicles;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: dialogWidth,
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1210), Color(0xFF151B28)],
          ),
          border: Border.all(color: _gold.withValues(alpha: 0.45)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.headerBanner != null) ...[
                    widget.headerBanner!,
                    const SizedBox(height: 10),
                  ],
                  _buildFilterSortBar(l10n),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              child: visible.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.vehicleHeistCatalogEmpty,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                      shrinkWrap: true,
                      itemCount: visible.length,
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _buildCatalogCard(l10n, visible[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showVehicleCatalogDialog(
  BuildContext context, {
  required String title,
  required List<VehicleDefinition> vehicles,
  required String currentCountry,
  Widget? headerBanner,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => VehicleCatalogDialog(
      title: title,
      vehicles: vehicles,
      currentCountry: currentCountry,
      headerBanner: headerBanner,
    ),
  );
}
