import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehicle.dart';
import '../providers/auth_provider.dart';
import '../providers/vehicle_provider.dart';
import '../utils/formatters.dart';
import '../widgets/overlay_image.dart';
import 'garage_screen.dart';
import 'marina_screen.dart';

class VehicleHeistScreen extends StatefulWidget {
  const VehicleHeistScreen({
    super.key,
    this.initialTabIndex = 0,
    this.embedded = false,
  });

  final int initialTabIndex;
  final bool embedded;

  @override
  State<VehicleHeistScreen> createState() => _VehicleHeistScreenState();
}

class _VehicleHeistScreenState extends State<VehicleHeistScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _activeTabIndex = 0;
  bool _opsActionInProgress = false;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    final safeInitialIndex = widget.initialTabIndex.clamp(0, 2);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: safeInitialIndex,
    );
    _activeTabIndex = safeInitialIndex;
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging &&
          _activeTabIndex != _tabController.index) {
        setState(() {
          _activeTabIndex = _tabController.index;
        });
        _refreshOpsIntelligence();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshOpsIntelligence();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int _countForTab(VehicleProvider provider, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return provider.inventory.where((v) => v.vehicleType == 'car').length;
      case 1:
        return provider.inventory
            .where((v) => v.vehicleType == 'motorcycle')
            .length;
      case 2:
        return provider.inventory.where((v) => v.vehicleType == 'boat').length;
      default:
        return 0;
    }
  }

  String _tabTitle(int index) {
    switch (index) {
      case 0:
        return _tr('Auto', 'Car');
      case 1:
        return _tr('Motor', 'Motorcycle');
      case 2:
        return _tr('Boot', 'Boat');
      default:
        return '';
    }
  }

  String _tabSubtitle(int index) {
    switch (index) {
      case 0:
        return _tr(
          'Steel en beheer snelle straatwagens voor dagelijkse jobs.',
          'Steal and manage fast street vehicles for daily jobs.',
        );
      case 1:
        return _tr(
          'Motoren zijn flexibel, stealthy en ideaal voor snelle raids.',
          'Motorcycles are agile, stealthy and ideal for quick raids.',
        );
      case 2:
        return _tr(
          'Boten leveren vaak hogere marges, met zwaarder onderhoud.',
          'Boats often yield higher margins, with heavier maintenance.',
        );
      default:
        return '';
    }
  }

  IconData _tabIcon(int index) {
    switch (index) {
      case 0:
        return Icons.directions_car;
      case 1:
        return Icons.two_wheeler;
      case 2:
        return Icons.directions_boat;
      default:
        return Icons.directions_car;
    }
  }

  Color _tabAccentColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF4FC3F7);
      case 1:
        return const Color(0xFFFFB74D);
      case 2:
        return const Color(0xFF4DD0A6);
      default:
        return const Color(0xFFD4AF37);
    }
  }

  String _catalogCategoryForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'car';
      case 1:
        return 'motorcycle';
      case 2:
      default:
        return 'boat';
    }
  }

  String _opsVehicleTypeForTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 'motorcycle';
      case 2:
        return 'boat';
      case 0:
      default:
        return 'car';
    }
  }

  Future<void> _refreshOpsIntelligence() async {
    if (!mounted) return;
    final provider = context.read<VehicleProvider>();
    await provider.fetchVehicleOpsIntelligence(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
  }

  void _showTopMessage(String message, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.orange,
      ),
    );
  }

  int _requiredRankForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 5;
      case 1:
        return 7;
      case 2:
      default:
        return 10;
    }
  }

  String _storageLabelForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _tr('Garage', 'Garage');
      case 1:
        return _tr('Motorstalling', 'Motor Storage');
      case 2:
      default:
        return _tr('Marina', 'Marina');
    }
  }

  String _capacityPolicyForTab(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return _tr(
          'Eigen autogarage-capaciteit',
          'Dedicated car garage capacity',
        );
      case 1:
        return _tr(
          'Eigen motor-capaciteit (gescheiden van auto)',
          'Dedicated motorcycle capacity (separate from cars)',
        );
      case 2:
      default:
        return _tr('Eigen marina-capaciteit', 'Dedicated marina capacity');
    }
  }

  Future<void> _showCatalogForActiveTab(VehicleProvider provider) async {
    final authProvider = context.read<AuthProvider>();
    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';
    final category = _catalogCategoryForTab(_activeTabIndex);

    await provider.fetchStealableCatalog(category: category);
    if (!mounted) return;

    final vehicles = [...provider.availableVehicles]
      ..sort((a, b) {
        final aIsPoliceEvent = (a.id ?? '').startsWith('event_politie_');
        final bIsPoliceEvent = (b.id ?? '').startsWith('event_politie_');
        if (aIsPoliceEvent != bIsPoliceEvent) {
          return aIsPoliceEvent ? -1 : 1;
        }
        return (a.baseValue ?? 0).compareTo(b.baseValue ?? 0);
      });

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            _activeTabIndex == 0
                ? _tr('Beschikbare auto\'s', 'Available cars')
                : _activeTabIndex == 1
                ? _tr('Beschikbare motoren', 'Available motorcycles')
                : _tr('Beschikbare boten', 'Available boats'),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width < 700
                ? double.maxFinite
                : 720,
            child: vehicles.isEmpty
                ? Text(
                    _tr(
                      'Er zijn nu geen voertuigen beschikbaar in dit segment.',
                      'There are currently no vehicles available in this segment.',
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: vehicles.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return _buildCatalogCard(vehicle, currentCountry);
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_tr('Sluiten', 'Close')),
            ),
          ],
        );
      },
    );
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
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

  String _rarityLabel(String rarity) {
    switch (rarity) {
      case 'common':
        return _tr('Gewoon', 'Common');
      case 'uncommon':
        return _tr('Ongewoon', 'Uncommon');
      case 'rare':
        return _tr('Zeldzaam', 'Rare');
      case 'epic':
        return _tr('Episch', 'Epic');
      case 'legendary':
        return _tr('Legendarisch', 'Legendary');
      default:
        return rarity;
    }
  }

  Widget _buildCatalogCard(VehicleDefinition vehicle, String currentCountry) {
    final image = vehicle.imageNew ?? vehicle.image;
    final rarity = (vehicle.rarity ?? 'common').toLowerCase();
    final marketValue =
        vehicle.marketValue?[currentCountry] ?? vehicle.baseValue ?? 0;
    final countries = vehicle.availableInCountries ?? const <String>[];
    final primaryCountry = countries.isNotEmpty ? countries.first : '-';
    final isPoliceEventVehicle = (vehicle.id ?? '').startsWith(
      'event_politie_',
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
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
                            color: _rarityColor(rarity).withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: _rarityColor(rarity)),
                          ),
                          child: Text(
                            _rarityLabel(rarity),
                            style: TextStyle(
                              color: _rarityColor(rarity),
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
                              color: Colors.redAccent.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.redAccent.withOpacity(0.7),
                              ),
                            ),
                            child: Text(
                              _tr('Event-only', 'Event-only'),
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        Text(
                          _tr(
                            'Waarde: ${formatCurrency(marketValue)}',
                            'Value: ${formatCurrency(marketValue)}',
                          ),
                        ),
                        Text(
                          _tr(
                            'Rank: ${vehicle.requiredRank ?? '-'}',
                            'Rank: ${vehicle.requiredRank ?? '-'}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(vehicle.description ?? ''),
          const SizedBox(height: 8),
          Text(
            _tr(
              'In spel: ${vehicle.currentWorldCount ?? 0}/${vehicle.maxGameAvailability ?? '-'} beschikbaar',
              'In game: ${vehicle.currentWorldCount ?? 0}/${vehicle.maxGameAvailability ?? '-'} available',
            ),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            _tr(
              'Meest voorkomend in: $primaryCountry',
              'Most common in: $primaryCountry',
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            _tr(
              'Landen: ${countries.join(', ')}',
              'Countries: ${countries.join(', ')}',
            ),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBadge(VehicleProvider provider, int tabIndex) {
    final count = _countForTab(provider, tabIndex);
    final accent = _tabAccentColor(tabIndex);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withOpacity(0.45)),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTabIndex) {
      case 0:
        return const GarageScreen(
          key: ValueKey<String>('vehicle-tab-car'),
          embedded: true,
          vehicleType: 'car',
        );
      case 1:
        return const GarageScreen(
          key: ValueKey<String>('vehicle-tab-motorcycle'),
          embedded: true,
          vehicleType: 'motorcycle',
        );
      case 2:
      default:
        return const MarinaScreen(
          key: ValueKey<String>('vehicle-tab-boat'),
          embedded: true,
        );
    }
  }

  Widget _buildTabLabel(VehicleProvider provider, int tabIndex) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_tabIcon(tabIndex), size: 18),
        const SizedBox(width: 6),
        Text(_tabTitle(tabIndex)),
        const SizedBox(width: 6),
        _buildTabBadge(provider, tabIndex),
      ],
    );
  }

  Widget _buildOperationLaneCard(VehicleProvider provider, int tabIndex) {
    final accent = _tabAccentColor(tabIndex);
    final isActive = _activeTabIndex == tabIndex;
    final count = _countForTab(provider, tabIndex);
    final requiredRank = _requiredRankForTab(tabIndex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          if (_activeTabIndex == tabIndex) return;
          _tabController.animateTo(tabIndex);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isActive
                  ? [accent.withOpacity(0.26), Colors.black.withOpacity(0.24)]
                  : [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.15),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive ? accent.withOpacity(0.75) : Colors.white12,
              width: isActive ? 1.2 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: accent.withOpacity(0.24),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_tabIcon(tabIndex), color: accent, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _tabTitle(tabIndex),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: accent.withOpacity(0.45)),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _tabSubtitle(tabIndex),
                style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      '${_tr('Rank', 'Rank')} $requiredRank+',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Text(
                      _storageLabelForTab(tabIndex),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _capacityPolicyForTab(tabIndex),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOpsPill(String text, {Color? color}) {
    final base = color ?? Colors.white70;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: base.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: base.withOpacity(0.4)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: base,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _runHotspotOp(VehicleProvider provider) async {
    if (_opsActionInProgress) return;
    setState(() {
      _opsActionInProgress = true;
    });
    final result = await provider.runVehicleHotspotOp(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    if (!mounted) return;
    setState(() {
      _opsActionInProgress = false;
    });
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    final success = result['success'] == true;
    if (success) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Hotspot geslaagd: +${formatCurrency(reward)}',
          'Hotspot success: +${formatCurrency(reward)}',
        ),
        success: true,
      );
    } else {
      final reason = params['message']?.toString() ?? 'FAILED';
      if (reason == 'HOTSPOT_COOLDOWN') {
        final sec = (params['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
        _showTopMessage(
          _tr(
            'Hotspot cooldown actief (${formatAdaptiveDurationFromSeconds(sec, localeName: Localizations.localeOf(context).languageCode)})',
            'Hotspot cooldown active (${formatAdaptiveDurationFromSeconds(sec, localeName: Localizations.localeOf(context).languageCode)})',
          ),
        );
      } else {
        _showTopMessage(
          _tr(
            'Hotspot run mislukt, heat is verhoogd.',
            'Hotspot run failed, heat increased.',
          ),
        );
      }
    }
  }

  Future<void> _runCrewOp(VehicleProvider provider) async {
    if (_opsActionInProgress) return;
    setState(() {
      _opsActionInProgress = true;
    });
    final result = await provider.runVehicleCrewOp(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    if (!mounted) return;
    setState(() {
      _opsActionInProgress = false;
    });
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    final success = result['success'] == true;
    if (success) {
      final personal = (params['personalShare'] as num?)?.toInt() ?? 0;
      final crewBank = (params['crewBankShare'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Crew-op geslaagd: jij +${formatCurrency(personal)}, crewbank +${formatCurrency(crewBank)}',
          'Crew op success: you +${formatCurrency(personal)}, crew bank +${formatCurrency(crewBank)}',
        ),
        success: true,
      );
      return;
    }
    final reason = params['message']?.toString() ?? 'FAILED';
    if (reason == 'CREW_REQUIRED') {
      _showTopMessage(
        _tr(
          'Je moet in een crew zitten voor deze actie.',
          'You must be in a crew for this action.',
        ),
      );
    } else if (reason == 'CREW_OP_COOLDOWN') {
      final sec = (params['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Crew-op cooldown actief (${formatAdaptiveDurationFromSeconds(sec, localeName: Localizations.localeOf(context).languageCode)})',
          'Crew op cooldown active (${formatAdaptiveDurationFromSeconds(sec, localeName: Localizations.localeOf(context).languageCode)})',
        ),
      );
    } else {
      _showTopMessage(_tr('Crew-op mislukt.', 'Crew op failed.'));
    }
  }

  Future<void> _buyOpsParts(VehicleProvider provider) async {
    final partsType = _opsVehicleTypeForTab(_activeTabIndex);
    final qtyController = TextEditingController(text: '5');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Koop onderdelen', 'Buy parts')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr(
                'Aantal $partsType onderdelen:',
                'Amount of $partsType parts:',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(_tr('Kopen', 'Buy')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final qty = int.tryParse(qtyController.text.trim()) ?? 1;
    final result = await provider.buyOpsVehicleParts(
      partsType: partsType,
      quantity: qty,
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    final success = result['success'] == true;
    if (success) {
      final totalCost = (params['totalCost'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Onderdelen gekocht voor ${formatCurrency(totalCost)}.',
          'Parts purchased for ${formatCurrency(totalCost)}.',
        ),
        success: true,
      );
      return;
    }
    _showTopMessage(
      _tr(
        'Aankoop mislukt of te weinig geld.',
        'Purchase failed or insufficient funds.',
      ),
    );
  }

  Future<void> _claimChopContract(VehicleProvider provider) async {
    final result = await provider.claimVehicleChopContract(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    final success = result['success'] == true;
    if (success) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Contract afgerond: +${formatCurrency(reward)}',
          'Contract completed: +${formatCurrency(reward)}',
        ),
        success: true,
      );
      return;
    }
    final reason = params['message']?.toString() ?? 'FAILED';
    if (reason == 'NO_ELIGIBLE_VEHICLE') {
      _showTopMessage(
        _tr(
          'Geen geschikt voertuig in inventory voor dit contract.',
          'No eligible vehicle in inventory for this contract.',
        ),
      );
    } else if (reason == 'CHOP_CONTRACT_COOLDOWN') {
      final sec = (params['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Contract cooldown actief (${formatAdaptiveDurationFromSeconds(sec, localeName: Localizations.localeOf(context).languageCode)})',
          'Contract cooldown active (${formatAdaptiveDurationFromSeconds(sec, localeName: Localizations.localeOf(context).languageCode)})',
        ),
      );
    } else {
      _showTopMessage(_tr('Contract claim mislukt.', 'Contract claim failed.'));
    }
  }

  Future<void> _purchaseInsurance(VehicleProvider provider) async {
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Contraband Insurance', 'Contraband Insurance')),
        content: Text(
          _tr(
            'Kies een dekking voor deze voertuigcategorie.',
            'Choose a coverage tier for this vehicle category.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop('basic'),
            child: const Text('Basic'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop('pro'),
            child: const Text('Pro'),
          ),
        ],
      ),
    );
    if (choice == null) return;
    final result = await provider.purchaseOpsInsurance(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
      tier: choice,
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final price = (params['price'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Insurance actief (${choice.toUpperCase()}) voor ${formatCurrency(price)}.',
          'Insurance active (${choice.toUpperCase()}) for ${formatCurrency(price)}.',
        ),
        success: true,
      );
      return;
    }
    _showTopMessage(
      _tr('Insurance aankoop mislukt.', 'Insurance purchase failed.'),
    );
  }

  Future<void> _runCrewMatch(VehicleProvider provider) async {
    final result = await provider.runVehicleCrewMatch(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      final msg = (params['message']?.toString() == 'CREW_MATCH_WON')
          ? _tr(
              'Crew match gewonnen: +${formatCurrency(reward)}',
              'Crew match won: +${formatCurrency(reward)}',
            )
          : _tr(
              'Crew match verloren: +${formatCurrency(reward)} troost',
              'Crew match lost: +${formatCurrency(reward)} consolation',
            );
      _showTopMessage(msg, success: true);
      return;
    }
    _showTopMessage(
      _tr('Crew matchmaking mislukt.', 'Crew matchmaking failed.'),
    );
  }

  Future<void> _runCounterIntercept(VehicleProvider provider) async {
    final result = await provider.runVehicleCounterIntercept(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Counter-intercept geslaagd: +${formatCurrency(reward)}',
          'Counter-intercept success: +${formatCurrency(reward)}',
        ),
        success: true,
      );
      return;
    }
    _showTopMessage(
      _tr(
        'Counter-intercept niet beschikbaar of mislukt.',
        'Counter-intercept unavailable or failed.',
      ),
    );
  }

  Future<void> _runOpsContract(VehicleProvider provider) async {
    final intel = provider.vehicleOpsIntelligence;
    final board =
        (intel?['contractsBoard'] as Map<String, dynamic>?) ?? const {};
    final contracts = (board['contracts'] as List<dynamic>? ?? const []);
    String? selectedContractId;
    if (contracts.isNotEmpty && contracts.first is Map<String, dynamic>) {
      selectedContractId =
          ((contracts.first as Map<String, dynamic>)['contractId'])?.toString();
    }
    final result = await provider.runVehicleOpsContract(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
      contractId: selectedContractId,
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        _tr(
          'Ops contract afgerond: +${formatCurrency(reward)}',
          'Ops contract completed: +${formatCurrency(reward)}',
        ),
        success: true,
      );
      return;
    }
    _showTopMessage(
      _tr(
        'Ops contract mislukt of op cooldown.',
        'Ops contract failed or on cooldown.',
      ),
    );
  }

  Future<void> _resolveInsuranceClaim(VehicleProvider provider) async {
    final intel = provider.vehicleOpsIntelligence;
    final insurance =
        (intel?['contrabandInsurance'] as Map<String, dynamic>?) ?? const {};
    final claims = (insurance['openClaims'] as List<dynamic>? ?? const []);
    if (claims.isEmpty || claims.first is! Map<String, dynamic>) {
      _showTopMessage(
        _tr('Geen open insurance claims.', 'No open insurance claims.'),
      );
      return;
    }
    final claimId =
        ((claims.first as Map<String, dynamic>)['id'] as num?)?.toInt() ?? 0;
    if (claimId <= 0) {
      _showTopMessage(
        _tr('Geen geldige claim gevonden.', 'No valid claim found.'),
      );
      return;
    }
    final result = await provider.resolveVehicleInsuranceClaim(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
      claimId: claimId,
      action: 'contest',
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final bonus = (params['bonus'] as num?)?.toInt() ?? 0;
      final fine = (params['fine'] as num?)?.toInt() ?? 0;
      final message = bonus > 0
          ? _tr(
              'Claim goedgekeurd: +${formatCurrency(bonus)}',
              'Claim approved: +${formatCurrency(bonus)}',
            )
          : _tr(
              'Claim afgewezen: -${formatCurrency(fine)}',
              'Claim rejected: -${formatCurrency(fine)}',
            );
      _showTopMessage(message, success: bonus > 0);
      return;
    }
    _showTopMessage(
      _tr('Claim-afhandeling mislukt.', 'Claim resolution failed.'),
    );
  }

  Widget _buildOpsIntelligencePanel(VehicleProvider provider) {
    final intel = provider.vehicleOpsIntelligence;
    final heat = (intel?['categoryHeat'] as Map<String, dynamic>?) ?? const {};
    final pattern =
        (intel?['policePattern'] as Map<String, dynamic>?) ?? const {};
    final crewOp = (intel?['crewOp'] as Map<String, dynamic>?) ?? const {};
    final partsMarket =
        (intel?['partsMarket'] as Map<String, dynamic>?) ?? const {};
    final prices = (partsMarket['prices'] as Map<String, dynamic>?) ?? const {};
    final chop = (intel?['chopContract'] as Map<String, dynamic>?) ?? const {};
    final rep = (intel?['opsReputation'] as Map<String, dynamic>?) ?? const {};
    final blacklist =
        (intel?['regionalBlacklist'] as Map<String, dynamic>?) ?? const {};
    final interception =
        (intel?['hotspotInterception'] as Map<String, dynamic>?) ?? const {};
    final insurance =
        (intel?['contrabandInsurance'] as Map<String, dynamic>?) ?? const {};
    final countryModifier =
        (intel?['countryModifier'] as Map<String, dynamic>?) ?? const {};
    final contractsBoard =
        (intel?['contractsBoard'] as Map<String, dynamic>?) ?? const {};
    final crewMatchmaking =
        (intel?['crewMatchmaking'] as Map<String, dynamic>?) ?? const {};
    final counterIntercept =
        (intel?['counterIntercept'] as Map<String, dynamic>?) ?? const {};
    final openClaims =
        (insurance['openClaims'] as List<dynamic>? ?? const <dynamic>[]);
    final hotspots = (intel?['hotspots'] as List<dynamic>? ?? const []);
    final hotspot =
        hotspots.isNotEmpty && hotspots.first is Map<String, dynamic>
        ? hotspots.first as Map<String, dynamic>
        : const <String, dynamic>{};
    final isLoading = provider.vehicleOpsLoading;

    Color heatColor;
    final heatLevel = (heat['level'] ?? 'LOW').toString().toUpperCase();
    switch (heatLevel) {
      case 'CRITICAL':
        heatColor = Colors.redAccent;
        break;
      case 'HIGH':
        heatColor = Colors.orangeAccent;
        break;
      case 'MEDIUM':
        heatColor = Colors.amberAccent;
        break;
      case 'LOW':
      default:
        heatColor = Colors.lightGreenAccent;
        break;
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 2),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF151515).withOpacity(0.94),
            const Color(0xFF101820).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.radar, color: Color(0xFFD4AF37), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _tr('Vehicle Ops Intelligence', 'Vehicle Ops Intelligence'),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                IconButton(
                  onPressed: _refreshOpsIntelligence,
                  icon: const Icon(Icons.refresh, size: 18),
                  tooltip: _tr('Ververs intelligence', 'Refresh intelligence'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildOpsPill(
                _tr(
                  'Heat ${heat['current'] ?? 0} ($heatLevel)',
                  'Heat ${heat['current'] ?? 0} ($heatLevel)',
                ),
                color: heatColor,
              ),
              _buildOpsPill(
                _tr(
                  'Politie: ${pattern['nameNl'] ?? '-'}',
                  'Police: ${pattern['nameEn'] ?? '-'}',
                ),
                color: Colors.lightBlueAccent,
              ),
              _buildOpsPill(
                _tr(
                  'Rep lvl ${rep['level'] ?? 0}',
                  'Rep lvl ${rep['level'] ?? 0}',
                ),
                color: Colors.purpleAccent,
              ),
              if (blacklist['active'] == true)
                _buildOpsPill(
                  _tr('Blacklist actief', 'Blacklist active'),
                  color: Colors.redAccent,
                ),
              _buildOpsPill(
                _tr(
                  'Onderdelenmarkt ${partsMarket['trend'] ?? '-'}',
                  'Parts market ${partsMarket['trend'] ?? '-'}',
                ),
                color: Colors.cyanAccent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 820;
              final controls = Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _runHotspotOp(provider),
                    icon: const Icon(Icons.local_police, size: 16),
                    label: Text(_tr('Run Hotspot', 'Run Hotspot')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _runCrewOp(provider),
                    icon: const Icon(Icons.groups, size: 16),
                    label: Text(_tr('Crew Op', 'Crew Op')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _buyOpsParts(provider),
                    icon: const Icon(Icons.precision_manufacturing, size: 16),
                    label: Text(_tr('Koop Parts', 'Buy Parts')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _claimChopContract(provider),
                    icon: const Icon(Icons.build_circle, size: 16),
                    label: Text(_tr('Claim Contract', 'Claim Contract')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _purchaseInsurance(provider),
                    icon: const Icon(Icons.verified_user, size: 16),
                    label: Text(_tr('Insurance', 'Insurance')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _runCrewMatch(provider),
                    icon: const Icon(Icons.emoji_events, size: 16),
                    label: Text(_tr('Crew Match', 'Crew Match')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _runCounterIntercept(provider),
                    icon: const Icon(Icons.swap_horiz, size: 16),
                    label: Text(_tr('Counter', 'Counter')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _runOpsContract(provider),
                    icon: const Icon(Icons.assignment_turned_in, size: 16),
                    label: Text(_tr('Ops Contract', 'Ops Contract')),
                  ),
                  OutlinedButton.icon(
                    onPressed: isLoading || _opsActionInProgress
                        ? null
                        : () => _resolveInsuranceClaim(provider),
                    icon: const Icon(Icons.gavel, size: 16),
                    label: Text(_tr('Claim dispute', 'Claim dispute')),
                  ),
                ],
              );

              final stats = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tr(
                      'Hotspot: ${hotspot['nameNl'] ?? '-'}',
                      'Hotspot: ${hotspot['nameEn'] ?? '-'}',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _tr(
                      'Reward: ${formatCurrency((hotspot['rewardMin'] as num?)?.toInt() ?? 0)} - ${formatCurrency((hotspot['rewardMax'] as num?)?.toInt() ?? 0)}',
                      'Reward: ${formatCurrency((hotspot['rewardMin'] as num?)?.toInt() ?? 0)} - ${formatCurrency((hotspot['rewardMax'] as num?)?.toInt() ?? 0)}',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Partsprijzen (auto/motor/boot): ${prices['car'] ?? '-'} / ${prices['motorcycle'] ?? '-'} / ${prices['boat'] ?? '-'}',
                      'Part prices (car/motorcycle/boat): ${prices['car'] ?? '-'} / ${prices['motorcycle'] ?? '-'} / ${prices['boat'] ?? '-'}',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Crew: ${crewOp['crewName'] ?? '-'} (${crewOp['crewSize'] ?? 0} leden)',
                      'Crew: ${crewOp['crewName'] ?? '-'} (${crewOp['crewSize'] ?? 0} members)',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Chop contract reward: ${formatCurrency((chop['rewardMoney'] as num?)?.toInt() ?? 0)}',
                      'Chop contract reward: ${formatCurrency((chop['rewardMoney'] as num?)?.toInt() ?? 0)}',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Intercept window: ${interception['activeWindow'] == true ? 'ACTIEF' : 'uit'}',
                      'Intercept window: ${interception['activeWindow'] == true ? 'ACTIVE' : 'off'}',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      blacklist['active'] == true
                          ? 'Blacklist: ${blacklist['reasonNl'] ?? '-'}'
                          : 'Blacklist: geen',
                      blacklist['active'] == true
                          ? 'Blacklist: ${blacklist['reasonEn'] ?? '-'}'
                          : 'Blacklist: none',
                    ),
                    style: TextStyle(
                      color: blacklist['active'] == true
                          ? Colors.redAccent
                          : Colors.white70,
                    ),
                  ),
                  Text(
                    _tr(
                      insurance['active'] == true
                          ? 'Insurance: ${insurance['tier'] ?? '-'} actief'
                          : 'Insurance: niet actief',
                      insurance['active'] == true
                          ? 'Insurance: ${insurance['tier'] ?? '-'} active'
                          : 'Insurance: inactive',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Country modifier: ${countryModifier['nameNl'] ?? '-'} (${countryModifier['payoutMultiplier'] ?? 1}x)',
                      'Country modifier: ${countryModifier['nameEn'] ?? '-'} (${countryModifier['payoutMultiplier'] ?? 1}x)',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Crew season: ${crewMatchmaking['seasonKey'] ?? '-'} | punten ${((crewMatchmaking['current'] as Map<String, dynamic>?)?['points'] ?? 0)}',
                      'Crew season: ${crewMatchmaking['seasonKey'] ?? '-'} | points ${((crewMatchmaking['current'] as Map<String, dynamic>?)?['points'] ?? 0)}',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Contracts: ${(contractsBoard['contracts'] as List<dynamic>? ?? const []).length} | cooldown ${contractsBoard['cooldownRemainingSeconds'] ?? 0}s',
                      'Contracts: ${(contractsBoard['contracts'] as List<dynamic>? ?? const []).length} | cooldown ${contractsBoard['cooldownRemainingSeconds'] ?? 0}s',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    _tr(
                      'Counter cooldown: ${counterIntercept['cooldownRemainingSeconds'] ?? 0}s | open claims: ${openClaims.length}',
                      'Counter cooldown: ${counterIntercept['cooldownRemainingSeconds'] ?? 0}s | open claims: ${openClaims.length}',
                    ),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [stats, const SizedBox(height: 10), controls],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: stats),
                  const SizedBox(width: 10),
                  Expanded(child: controls),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Consumer<VehicleProvider>(
      builder: (context, provider, _) {
        final header = Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.2),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Column(
              key: ValueKey<int>(_activeTabIndex),
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.35),
                        ),
                      ),
                      child: Icon(
                        _tabIcon(_activeTabIndex),
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _tr('Voertuig Stelen', 'Vehicle Heist'),
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _tabSubtitle(_activeTabIndex),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: provider.isLoading
                          ? null
                          : () => _showCatalogForActiveTab(provider),
                      icon: const Icon(Icons.menu_book, size: 18),
                      label: Text(_tr('Catalogus', 'Catalog')),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withOpacity(0.28)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isStacked = constraints.maxWidth < 900;
                    if (isStacked) {
                      return Column(
                        children: [
                          _buildOperationLaneCard(provider, 0),
                          const SizedBox(height: 10),
                          _buildOperationLaneCard(provider, 1),
                          const SizedBox(height: 10),
                          _buildOperationLaneCard(provider, 2),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: _buildOperationLaneCard(provider, 0)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildOperationLaneCard(provider, 1)),
                        const SizedBox(width: 10),
                        Expanded(child: _buildOperationLaneCard(provider, 2)),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                _buildOpsIntelligencePanel(provider),
              ],
            ),
          ),
        );

        final tabs = Container(
          color: Colors.black.withOpacity(0.25),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: const Color(0xFFD4AF37),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(child: _buildTabLabel(provider, 0)),
              Tab(child: _buildTabLabel(provider, 1)),
              Tab(child: _buildTabLabel(provider, 2)),
            ],
          ),
        );

        final tabBody = AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.02, 0),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_activeTabIndex),
            child: _buildTabContent(),
          ),
        );

        if (widget.embedded) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: header),
              SliverToBoxAdapter(child: tabs),
              const SliverToBoxAdapter(child: Divider(height: 1)),
            ],
            body: tabBody,
          );
        }

        return Column(
          children: [
            header,
            tabs,
            const Divider(height: 1),
            Expanded(child: tabBody),
          ],
        );
      },
    );

    return widget.embedded
        ? content
        : Scaffold(
            appBar: AppBar(
              title: Text(_tr('Voertuig Stelen', 'Vehicle Heist')),
            ),
            body: content,
          );
  }
}
