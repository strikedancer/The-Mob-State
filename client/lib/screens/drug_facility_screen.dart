import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../utils/drug_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/education_requirements_dialog.dart';

class DrugFacilityScreen extends StatefulWidget {
  final bool showAppBar;

  const DrugFacilityScreen({super.key, this.showAppBar = true});

  @override
  State<DrugFacilityScreen> createState() => _DrugFacilityScreenState();
}

class _DrugFacilityScreenState extends State<DrugFacilityScreen> {
  final DrugService _drugService = DrugService();

  bool _isLoading = true;
  Map<String, dynamic> _config = const {};
  List<DrugFacilityInfo> _facilities = const [];
  List<DrugProduction> _activeProductions = const [];

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
      final t = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(t.drugsFacilitiesErrorLoading('$e')),
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

  IconData _equipmentIconData(String rawIcon) {
    switch (rawIcon) {
      case 'lightbulb':
        return Icons.lightbulb_outline;
      case 'soil':
      case 'compost':
        return Icons.compost;
      case 'thermostat':
        return Icons.thermostat;
      case 'biotech':
        return Icons.biotech;
      case 'medication':
        return Icons.medication_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'inventory_2':
        return Icons.inventory_2_outlined;
      case 'speed':
        return Icons.speed;
      case 'security':
        return Icons.security;
      case 'route':
        return Icons.route;
      case 'currency_bitcoin':
        return Icons.currency_bitcoin;
      case 'public':
        return Icons.public;
      case 'greenhouse':
        return Icons.yard_outlined;
      case 'eco':
        return Icons.eco_outlined;
      case 'local_fire_department':
        return Icons.local_fire_department;
      default:
        return Icons.tune;
    }
  }

  String _equipmentImageFileName(String facilityType, String upgradeId) {
    return '${facilityType}_$upgradeId.png';
  }

  List<String> _equipmentExternalImageCandidates(
    String facilityType,
    String upgradeId,
  ) {
    final fileName = _equipmentImageFileName(facilityType, upgradeId);
    final candidates = <String>[];

    void addBase(String base) {
      var normalizedBase = base.trim();
      if (normalizedBase.isEmpty) return;
      if (normalizedBase.endsWith('/')) {
        normalizedBase = normalizedBase.substring(0, normalizedBase.length - 1);
      }
      final url = '$normalizedBase/equipment/$fileName';
      if (!candidates.contains(url)) {
        candidates.add(url);
      }
    }

    final base = AppConfig.drugFacilityImageBaseUrl;
    addBase(base);

    final runtimeBase = Uri.base;
    addBase('${runtimeBase.scheme}://${runtimeBase.host}/images/facilities');
    addBase('${runtimeBase.scheme}://${runtimeBase.host}/game-assets/facilities');

    return candidates;
  }

  Widget _buildEquipmentNetworkImage(
    List<String> urls,
    int index,
    Widget fallback,
  ) {
    if (index >= urls.length) {
      return fallback;
    }

    return Image.network(
      urls[index],
      width: 36,
      height: 36,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => _buildEquipmentNetworkImage(
        urls,
        index + 1,
        fallback,
      ),
    );
  }

  Widget _buildEquipmentAvatar(String facilityType, String upgradeId, String iconName) {
    final imageUrls = _equipmentExternalImageCandidates(facilityType, upgradeId);

    Widget iconFallback() {
      return Icon(
        _equipmentIconData(iconName),
        color: Colors.white,
        size: 20,
      );
    }

    if (imageUrls.isEmpty) {
      return iconFallback();
    }

    return ClipOval(
      child: _buildEquipmentNetworkImage(imageUrls, 0, iconFallback()),
    );
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

  String _facilityNameById(AppLocalizations t, int? facilityId) {
    if (facilityId == null) {
      return t.drugsFacUnknownFacility;
    }
    for (final facility in _facilities) {
      if (facility.id == facilityId) {
        return facility.displayName;
      }
    }
    return t.drugsFacUnknownFacility;
  }

  Future<void> _buyFacility(String facilityType) async {
    final t = AppLocalizations.of(context)!;
    final result = await _drugService.buyFacility(facilityType);
    if (!mounted) return;
    final raw = result['message'] as String?;
    final msg = raw != null && raw.isNotEmpty
        ? localizeDrugClientMessage(t, raw)
        : t.drugsFacUnknownMessage;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(msg),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) {
      await _loadData();
    }
  }

  Future<void> _upgradeSlots(DrugFacilityInfo facility) async {
    final t = AppLocalizations.of(context)!;
    final result = await _drugService.upgradeSlots(facility.id);
    if (!mounted) return;

    if (result['success'] != true &&
        (result['error'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            result['reason'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            (result['reasonKey']?.toString() ?? '').contains(
              'education_requirements_not_met',
            ))) {
      await EducationRequirementsDialog.show(
        context,
        title: t.drugsFacUpgradeLockedTitle,
        subtitle: t.drugsFacUpgradeLockedBody,
        missingRequirements: (result['missing'] as List?) ?? const [],
      );
      return;
    }

    final raw = result['message'] as String?;
    final msg = raw != null && raw.isNotEmpty
        ? localizeDrugClientMessage(t, raw)
        : t.drugsFacUnknownMessage;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(msg),
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
    final t = AppLocalizations.of(context)!;
    final result = await _drugService.upgradeEquipment(
      facility.id,
      upgradeType,
    );
    if (!mounted) return;

    if (result['success'] != true &&
        (result['error'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            result['reason'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            (result['reasonKey']?.toString() ?? '').contains(
              'education_requirements_not_met',
            ))) {
      await EducationRequirementsDialog.show(
        context,
        title: t.drugsFacEquipLockedTitle,
        subtitle: t.drugsFacEquipLockedBody,
        missingRequirements: (result['missing'] as List?) ?? const [],
      );
      return;
    }

    final rawEq = result['message'] as String?;
    final msgEq = rawEq != null && rawEq.isNotEmpty
        ? localizeDrugClientMessage(t, rawEq)
        : t.drugsFacUnknownMessage;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(msgEq),
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
        final t = AppLocalizations.of(context)!;
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final padding = isMobile ? 12.0 : 20.0;

        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  backgroundColor: const Color(0xCC111111),
                  title: Text(t.drugsFacilitiesTitle),
                  actions: [
                    if (!_isLoading && _facilities.isNotEmpty)
                      _KpiChip(
                        value:
                            '${_facilities.fold(0, (s, f) => s + f.activeProductions)}/${_facilities.fold(0, (s, f) => s + f.slots)}',
                        label: t.drugsSlotsLabel,
                        icon: Icons.grid_view_rounded,
                        color: const Color(0xFF48B8FF),
                      ),
                    IconButton(
                      onPressed: _loadData,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                )
              : null,
          body: Stack(
            children: [
              Positioned.fill(
                child: WebAssetHelper.image(
                  _backgroundAsset(width),
                  fit: BoxFit.cover,
                  alignment: isMobile
                      ? Alignment.topCenter
                      : Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) => WebAssetHelper.image(
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
                                    t.drugsFacilitiesHeroTitle,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    t.drugsFacilitiesHeroBody,
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
                                      t.drugsFacCurrentProductions,
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
                                                  '${production.drugName} • ${production.quantity}g • ${_facilityNameById(t, production.facilityId)}',
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
                                t,
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
    AppLocalizations t,
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
                    child: WebAssetHelper.image(
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
                    child: Text(t.drugsFacBuy),
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
                      t.drugsFacOwned,
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
                  t.drugsFacPrice,
                  '€${purchasePrice.toString()}',
                ),
                _buildStatChip(t.drugsFacRank, '$requiredRank'),
                _buildStatChip(t.drugsFacDrugTypes, drugTypes.join(', ')),
              ],
            ),
            if (owned != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildBonusCard(
                      t.drugsFacSlots,
                      '${owned.activeProductions}/${owned.slots}',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBonusCard(
                      t.drugsFacQuality,
                      '+${(owned.qualityBonus * 100).round()}%',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBonusCard(
                      t.drugsFacYield,
                      '+${(owned.yieldBonus * 100).round()}%',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildBonusCard(
                      t.drugsFacSpeed,
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
                            ? t.drugsFacMaxSlots
                            : t.drugsFacUpgradeSlots(
                                '${owned.nextSlotCost}',
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                t.drugsFacEquipmentUpgrades,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...equipment.map((rawUpgrade) {
                final upgrade = rawUpgrade;
                final upgradeId = (upgrade['id'] ?? '').toString();
                final iconName = (upgrade['icon'] ?? '').toString();
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
                    child: _buildEquipmentAvatar(
                      facilityType,
                      upgradeId,
                      iconName,
                    ),
                  ),
                  title: Text((upgrade['name'] ?? upgradeId).toString()),
                  subtitle: Text('${t.level} $current'),
                  trailing: ElevatedButton(
                    onPressed: nextLevel == null
                        ? null
                        : () => _upgradeEquipment(owned, upgradeId),
                    child: Text(
                      nextLevel == null
                          ? t.drugsFacMax
                          : t.drugsFacLvlPrice(
                              '${nextLevel['level']}',
                              '${nextLevel['price']}',
                            ),
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
