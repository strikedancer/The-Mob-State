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
      }
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
                      .base('images/vehicles/$image')
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
            child: Row(
              key: ValueKey<int>(_activeTabIndex),
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _tabSubtitle(_activeTabIndex),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white70),
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
          ),
        );

        final tabs = Container(
          color: Colors.black.withOpacity(0.25),
          child: TabBar(
            controller: _tabController,
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

        return Column(
          children: [
            header,
            tabs,
            const Divider(height: 1),
            Expanded(
              child: AnimatedSwitcher(
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
              ),
            ),
          ],
        );
      },
    );

    if (widget.embedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(title: Text(_tr('Voertuig Stelen', 'Vehicle Heist'))),
      body: content,
    );
  }
}
