import 'package:flutter/material.dart';

import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../utils/top_right_notification.dart';

class DrugFacilityScreen extends StatefulWidget {
  const DrugFacilityScreen({super.key});

  @override
  State<DrugFacilityScreen> createState() => _DrugFacilityScreenState();
}

class _DrugFacilityScreenState extends State<DrugFacilityScreen> {
  final DrugService _drugService = DrugService();

  bool _isLoading = true;
  Map<String, dynamic> _config = const {};
  List<DrugFacilityInfo> _facilities = const [];
  List<DrugProduction> _activeProductions = const [];

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  String _backgroundAsset(double width) {
    return 'assets/images/backgrounds/drug_facility_bg.png';
  }

  BoxDecoration _glassPanelDecoration({Color borderColor = Colors.white24}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.black.withOpacity(0.58),
          const Color(0xFF111111).withOpacity(0.72),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _drugService.getFacilityConfig(),
        _drugService.getMyFacilities(),
        _drugService.getActiveProductions(),
      ]);

      final config = results[0] as Map<String, dynamic>;
      final facilities = results[1] as List<DrugFacilityInfo>;
      final productions = results[2] as List<DrugProduction>;

      if (!mounted) return;
      setState(() {
        _config = config['config'] as Map<String, dynamic>? ?? const {};
        _facilities = facilities;
        _activeProductions = productions;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Fout bij laden van faciliteiten: $e',
              'Error while loading facilities: $e',
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DrugFacilityInfo? _getOwnedFacility(String facilityType) {
    for (final facility in _facilities) {
      if (facility.facilityType == facilityType) {
        return facility;
      }
    }
    return null;
  }

  String _facilityImagePath(String facilityType) {
    switch (facilityType) {
      case 'greenhouse':
        return 'assets/images/facilities/facility_greenhouse.png';
      case 'mushroom_farm':
        return 'assets/images/facilities/facility_mushroom_farm.png';
      case 'crack_kitchen':
        return 'assets/images/facilities/facility_crack_kitchen.png';
      case 'darkweb_storefront':
        return 'assets/images/facilities/facility_darkweb_storefront.png';
      default:
        return 'assets/images/facilities/facility_drug_lab.png';
    }
  }

  String _facilityEmoji(String facilityType) {
    switch (facilityType) {
      case 'greenhouse':
        return '🌿';
      case 'mushroom_farm':
        return '🍄';
      case 'crack_kitchen':
        return '🔥';
      case 'darkweb_storefront':
        return '🕸️';
      default:
        return '🔬';
    }
  }

  Color _facilityAccent(String facilityType) {
    switch (facilityType) {
      case 'greenhouse':
        return Colors.green;
      case 'mushroom_farm':
        return Colors.deepPurple;
      case 'crack_kitchen':
        return Colors.deepOrange;
      case 'darkweb_storefront':
        return Colors.indigo;
      default:
        return Colors.blue;
    }
  }

  int _facilityOrder(String facilityType) {
    switch (facilityType) {
      case 'greenhouse':
        return 0;
      case 'mushroom_farm':
        return 1;
      case 'drug_lab':
        return 2;
      case 'crack_kitchen':
        return 3;
      case 'darkweb_storefront':
        return 4;
      default:
        return 999;
    }
  }

  String _facilityNameById(int? facilityId) {
    if (facilityId == null)
      return _tr('Onbekende faciliteit', 'Unknown facility');
    for (final facility in _facilities) {
      if (facility.id == facilityId) {
        return facility.displayName;
      }
    }
    return _tr('Onbekende faciliteit', 'Unknown facility');
  }

  Future<void> _buyFacility(String facilityType) async {
    final result = await _drugService.buyFacility(facilityType);
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message'] ?? _tr('Onbekende melding', 'Unknown message'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _upgradeSlots(DrugFacilityInfo facility) async {
    final result = await _drugService.upgradeSlots(facility.id);
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message'] ?? _tr('Onbekende melding', 'Unknown message'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _upgradeEquipment(
    DrugFacilityInfo facility,
    String upgradeType,
  ) async {
    final result = await _drugService.upgradeEquipment(
      facility.id,
      upgradeType,
    );
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          result['message'] ?? _tr('Onbekende melding', 'Unknown message'),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final facilitiesConfig =
        _config['facilities'] as Map<String, dynamic>? ?? const {};
    final orderedEntries = facilitiesConfig.entries.toList()
      ..sort((a, b) {
        final orderA = _facilityOrder(a.key);
        final orderB = _facilityOrder(b.key);
        if (orderA != orderB) return orderA.compareTo(orderB);
        return a.key.compareTo(b.key);
      });

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final padding = isMobile ? 12.0 : 20.0;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xCC111111),
            title: Text(_tr('Drug Faciliteiten', 'Drug Facilities')),
            actions: [
              if (!_isLoading && _facilities.isNotEmpty)
                _KpiChip(
                  value:
                      '${_facilities.fold(0, (s, f) => s + f.activeProductions)}/${_facilities.fold(0, (s, f) => s + f.slots)}',
                  label: _tr('slots', 'slots'),
                  icon: Icons.grid_view_rounded,
                  color: const Color(0xFF48B8FF),
                ),
              IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh)),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _backgroundAsset(width),
                  fit: BoxFit.cover,
                  alignment: isMobile
                      ? Alignment.topCenter
                      : Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/backgrounds/crime_background.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.34),
                        Colors.black.withOpacity(0.62),
                        Colors.black.withOpacity(0.82),
                      ],
                    ),
                  ),
                ),
              ),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SafeArea(
                      child: RefreshIndicator(
                        onRefresh: _loadData,
                        child: ListView(
                          padding: EdgeInsets.all(padding),
                          children: [
                            Container(
                              padding: EdgeInsets.all(isMobile ? 16 : 20),
                              decoration: _glassPanelDecoration(
                                borderColor: const Color(0x5548B8FF),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _tr(
                                      'Beheer je drug faciliteiten',
                                      'Manage your drug facilities',
                                    ),
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _tr(
                                      'Faciliteiten zoals kas, paddenstoelenkwekerij, drugslab, crack kitchen en darkweb storefront bepalen welke drugs je kunt produceren, hoeveel plekken je hebt en hoe sterk je kwaliteit, opbrengst en snelheid zijn.',
                                      'Facilities such as greenhouse, mushroom farm, drug lab, crack kitchen and darkweb storefront determine which drugs you can produce, how many slots you have and how strong your quality, yield and speed are.',
                                    ),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.74),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_activeProductions.isNotEmpty) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
                                decoration: _glassPanelDecoration(
                                  borderColor: const Color(0x5535C46A),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _tr(
                                        'Huidige Producties',
                                        'Current Productions',
                                      ),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ..._activeProductions.map(
                                      (production) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(
                                              0.45,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: const Color(0x33FFFFFF),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.timelapse,
                                                color: Color(0xFF35C46A),
                                                size: 18,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  '${production.drugName} • ${production.quantity}g • ${_facilityNameById(production.facilityId)}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                production
                                                    .getTimeRemainingFormatted(),
                                                style: const TextStyle(
                                                  color: Colors.orangeAccent,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                            ...orderedEntries.map((entry) {
                              final facilityType = entry.key;
                              final config =
                                  entry.value as Map<String, dynamic>;
                              final owned = _getOwnedFacility(facilityType);
                              return _buildFacilityCard(
                                facilityType,
                                config,
                                owned,
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFacilityCard(
    String facilityType,
    Map<String, dynamic> config,
    DrugFacilityInfo? owned,
  ) {
    final purchasePrice = (config['purchasePrice'] ?? 0) as int;
    final requiredRank = (config['requiredRank'] ?? 0) as int;
    final drugTypes = (config['forDrugTypes'] as List<dynamic>? ?? const [])
        .map((e) => e.toString())
        .toList();
    final equipment =
        (config['equipmentUpgrades'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>();

    return Card(
      color: Colors.black.withOpacity(0.58),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0x33FFFFFF)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: _facilityAccent(
                    facilityType,
                  ).withOpacity(0.18),
                  child: ClipOval(
                    child: Image.asset(
                      _facilityImagePath(facilityType),
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Text(
                        _facilityEmoji(facilityType),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (config['displayName'] ?? facilityType).toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (config['description'] ?? '').toString(),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                if (owned == null)
                  ElevatedButton(
                    onPressed: () => _buyFacility(facilityType),
                    child: Text(_tr('Kopen', 'Buy')),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _tr('In bezit', 'Owned'),
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildStatChip(
                  _tr('Prijs', 'Price'),
                  '€${purchasePrice.toString()}',
                ),
                _buildStatChip(_tr('Rank', 'Rank'), '$requiredRank'),
                _buildStatChip(_tr('Drugs', 'Drugs'), drugTypes.join(', ')),
              ],
            ),
            if (owned != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBonusCard(
                      _tr('Plekken', 'Slots'),
                      '${owned.activeProductions}/${owned.slots}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBonusCard(
                      _tr('Kwaliteit', 'Quality'),
                      '+${(owned.qualityBonus * 100).round()}%',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBonusCard(
                      _tr('Opbrengst', 'Yield'),
                      '+${(owned.yieldBonus * 100).round()}%',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBonusCard(
                      _tr('Snelheid', 'Speed'),
                      '-${(owned.speedBonus * 100).round()}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: owned.isMaxSlots
                          ? null
                          : () => _upgradeSlots(owned),
                      icon: const Icon(Icons.add_box_outlined),
                      label: Text(
                        owned.isMaxSlots
                            ? _tr('Max slots', 'Max slots')
                            : _tr(
                                'Upgrade slots (€${owned.nextSlotCost})',
                                'Upgrade slots (€${owned.nextSlotCost})',
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _tr('Apparatuur upgrades', 'Equipment upgrades'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...equipment.map((rawUpgrade) {
                final upgrade = rawUpgrade;
                final upgradeId = (upgrade['id'] ?? '').toString();
                final current = owned.upgrades[upgradeId] ?? 1;
                final levels =
                    (upgrade['levels'] as List<dynamic>? ?? const []);
                final nextLevelIndex = current;
                final nextLevel = nextLevelIndex < levels.length
                    ? levels[nextLevelIndex] as Map<String, dynamic>
                    : null;

                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.white10,
                    child: Text((upgrade['icon'] ?? '⚙️').toString()),
                  ),
                  title: Text((upgrade['name'] ?? upgradeId).toString()),
                  subtitle: Text('${_tr('Level', 'Level')} $current'),
                  trailing: ElevatedButton(
                    onPressed: nextLevel == null
                        ? null
                        : () => _upgradeEquipment(owned, upgradeId),
                    child: Text(
                      nextLevel == null
                          ? _tr('Max', 'Max')
                          : '${_tr('Lvl', 'Lvl')} ${nextLevel['level']} (€${nextLevel['price']})',
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text('$label: $value'),
    );
  }

  Widget _buildBonusCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _KpiChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _KpiChip({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.38)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 9,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
