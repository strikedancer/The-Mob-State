import 'package:flutter/material.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'black_market_screen.dart';
import 'drug_facility_screen.dart';
import '../utils/drug_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

class DrugProductionScreen extends StatefulWidget {
  final VoidCallback? onOpenFacilitiesRequested;
  final VoidCallback? onOpenBlackMarket;

  const DrugProductionScreen({
    super.key,
    this.onOpenFacilitiesRequested,
    this.onOpenBlackMarket,
  });

  @override
  State<DrugProductionScreen> createState() => _DrugProductionScreenState();
}

class _DrugProductionScreenState extends State<DrugProductionScreen>
    with TickerProviderStateMixin {
  static const _legendPrefKey = 'drug_production_incident_legend_visible';
  final DrugService _drugService = DrugService();
  List<DrugDefinition> _drugs = [];
  List<MaterialDefinition> _materialDefinitions = [];
  PlayerMaterialsSnapshot _materialsSnapshot = PlayerMaterialsSnapshot.empty();
  List<DrugProduction> _activeProductions = [];
  List<DrugFacilityInfo> _facilities = [];
  bool _isLoading = true;
  Timer? _productionTimer;
  DrugStats? _stats;
  bool _togglingAutoCollect = false;
  bool _showIncidentLegend = true;
  String? _vipQuickBuyingDrugId;
  bool _speedupBusy = false;
  int? _speedupBusyProductionId;

  String _backgroundAsset(double width) {
    return 'assets/images/backgrounds/drug_production_bg.png';
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
      boxShadow: const [
        BoxShadow(
          color: Color(0x44000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    );
  }

  Widget _buildLegendItem(IconData icon, Color color, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadLegendPreference();
    _loadData();
    _startProductionTimer();
  }

  Future<void> _loadLegendPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(_legendPrefKey);
      if (!mounted || value == null) return;
      setState(() {
        _showIncidentLegend = value;
      });
    } catch (_) {
      // Keep default value when preferences are unavailable.
    }
  }

  Future<void> _setLegendPreference(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_legendPrefKey, value);
    } catch (_) {
      // Non-blocking preference save.
    }
  }

  @override
  void dispose() {
    _productionTimer?.cancel();
    super.dispose();
  }

  Future<void> _openFacilities() async {
    if (widget.onOpenFacilitiesRequested != null) {
      widget.onOpenFacilitiesRequested!.call();
      return;
    }

    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DrugFacilityScreen()));
    _loadData();
  }

  Future<void> _openMaterials() async {
    if (widget.onOpenBlackMarket != null) {
      widget.onOpenBlackMarket!.call();
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const BlackMarketScreen(initialTabIndex: 4),
      ),
    );
    _loadData();
  }

  Future<bool> _resolveRaidDialog(DrugProduction production) async {
    final t = AppLocalizations.of(context)!;
    final choice = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(t.drugsRaidTitle),
        content: Text(
          t.drugsRaidBody(
            '${production.raidLossPercent ?? 25}',
            '${production.raidDowntimeHours ?? 4}',
            '${production.raidCashFine ?? 0}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'lose'),
            child: Text(t.drugsRaidLose),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'downtime'),
            child: Text(t.drugsRaidDowntime),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cash'),
            child: Text(t.drugsRaidCash),
          ),
        ],
      ),
    );
    if (choice == null) return false;
    final result = await _drugService.resolveRaid(production.id, choice);
    if (!mounted) return false;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          (result['message'] as String?) ??
              (result['success'] == true ? t.drugsRaidResolved : t.drugsRaidFailed),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    return result['success'] == true;
  }

  void _startProductionTimer() {
    _productionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_activeProductions.isNotEmpty) {
        _loadActiveProductions();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _drugService.getDrugCatalog(),
        _drugService.getMaterials(),
        _drugService.getPlayerMaterials(),
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugStats(),
      ]);

      setState(() {
        _drugs = results[0] as List<DrugDefinition>;
        _materialDefinitions = results[1] as List<MaterialDefinition>;
        _materialsSnapshot = results[2] as PlayerMaterialsSnapshot;
        _activeProductions = results[3] as List<DrugProduction>;
        _facilities = results[4] as List<DrugFacilityInfo>;
        _stats = results[5] as DrugStats?;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(t.drugsClientErrorLoading('$e')),
          ),
        );
      }
    }
  }

  String? _getFacilityTypeForDrug(String drugId) {
    const greenhouseDrugs = {'white_widow', 'amnesia_haze', 'og_kush', 'hash'};
    const labDrugs = {'cocaine', 'speed', 'heroin', 'xtc'};
    const crackKitchenDrugs = {'crystal_meth', 'fentanyl'};
    const darkwebDrugs = {'lsd'};
    const mushroomDrugs = {'magic_mushrooms'};
    if (greenhouseDrugs.contains(drugId)) return 'greenhouse';
    if (labDrugs.contains(drugId)) return 'drug_lab';
    if (crackKitchenDrugs.contains(drugId)) return 'crack_kitchen';
    if (darkwebDrugs.contains(drugId)) return 'darkweb_storefront';
    if (mushroomDrugs.contains(drugId)) return 'mushroom_farm';
    return null;
  }

  DrugFacilityInfo? _getFacilityForDrug(String drugId) {
    final facilityType = _getFacilityTypeForDrug(drugId);
    if (facilityType == null) return null;
    for (final facility in _facilities) {
      if (facility.facilityType == facilityType) return facility;
    }
    return null;
  }

  int _getAdjustedProductionMinutes(
    DrugDefinition drug,
    DrugFacilityInfo? facility,
  ) {
    final speedBonus = facility?.speedBonus ?? 0.0;
    final multiplier = (1 - speedBonus).clamp(0.05, 1.0);
    return (drug.productionTime * multiplier).round();
  }

  String _getAdjustedTimeFormatted(
    DrugDefinition drug,
    DrugFacilityInfo? facility,
    AppLocalizations t,
  ) {
    return formatDrugDuration(
      t,
      _getAdjustedProductionMinutes(drug, facility),
    );
  }

  String _getAdjustedYieldFormatted(
    DrugDefinition drug,
    DrugFacilityInfo? facility,
  ) {
    final yieldBonus = facility?.yieldBonus ?? 0.0;
    final minYield = (drug.yieldMin * (1 + yieldBonus)).round();
    final maxYield = (drug.yieldMax * (1 + yieldBonus)).round();
    return '$minYield-$maxYield';
  }

  String _getFacilityDisplayName(String facilityType, AppLocalizations t) {
    switch (facilityType) {
      case 'greenhouse':
        return t.drugsFacilityGreenhouse;
      case 'crack_kitchen':
        return t.drugsFacilityCrackKitchen;
      case 'darkweb_storefront':
        return t.drugsFacilityDarkweb;
      case 'mushroom_farm':
        return t.drugsFacilityMushroomFarm;
      default:
        return t.drugsFacilityDrugLab;
    }
  }

  Future<void> _loadActiveProductions() async {
    try {
      final productions = await _drugService.getActiveProductions();
      if (mounted) {
        setState(() {
          _activeProductions = productions;
        });
      }
    } catch (e) {
      // Silent fail for background updates
    }
  }

  String _getMaterialName(String materialId) {
    // Look up the Dutch name from material definitions
    final materialDef = _materialDefinitions.firstWhere(
      (m) => m.id == materialId,
      orElse: () => MaterialDefinition(
        id: materialId,
        name: '',
        description: '',
        price: 0,
        category: '',
      ),
    );

    // Return Dutch name if found, otherwise format the materialId
    if (materialDef.name.isNotEmpty && !materialDef.name.contains('_')) {
      return materialDef.name;
    }

    // Fallback: Convert "grow_lamp" to "Grow Lamp"
    return materialId
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  bool _hasRequiredMaterials(DrugDefinition drug) {
    for (final entry in drug.materials.entries) {
      if (_materialsSnapshot.availableForProduction(entry.key) < entry.value) {
        return false;
      }
    }
    return true;
  }

  String _getMissingMaterials(DrugDefinition drug, AppLocalizations t) {
    List<String> missing = [];

    for (final entry in drug.materials.entries) {
      final materialId = entry.key;
      final required = entry.value;
      final have = _materialsSnapshot.availableForProduction(materialId);

      if (have < required) {
        final shortage = required - have;
        final displayName = _getMaterialName(materialId);
        missing.add('$displayName: $shortage');
      }
    }

    return missing.isEmpty
        ? ''
        : '${t.drugsProdMissingPrefix}: ${missing.join(', ')}';
  }

  List<_MissingMaterialLine> _getMissingMaterialLines(DrugDefinition drug) {
    final lines = <_MissingMaterialLine>[];

    for (final entry in drug.materials.entries) {
      final materialId = entry.key;
      final required = entry.value;
      final have = _materialsSnapshot.availableForProduction(materialId);
      final missing = required - have;
      if (missing <= 0) continue;

      final materialDef = _materialDefinitions.firstWhere(
        (m) => m.id == materialId,
        orElse: () => MaterialDefinition(
          id: materialId,
          name: _getMaterialName(materialId),
          description: '',
          price: 0,
          category: '',
        ),
      );

      lines.add(
        _MissingMaterialLine(
          name: _getMaterialName(materialId),
          quantity: missing,
          unitPrice: materialDef.price,
        ),
      );
    }

    return lines;
  }

  Future<void> _handleVipQuickBuyMaterials(DrugDefinition drug) async {
    if (_stats?.isVip != true) return;
    final t = AppLocalizations.of(context)!;

    final missingLines = _getMissingMaterialLines(drug);
    if (missingLines.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(t.drugsVipAlreadyEnough(drug.displayName)),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final totalCost = missingLines.fold<int>(
      0,
      (sum, line) => sum + line.lineCost,
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(t.drugsVipQuickBuyTitle),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520, maxHeight: 420),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.drugsVipBuyPrompt(drug.displayName),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  ...missingLines.map(
                    (line) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${line.quantity}x ${line.name} • €${line.lineCost.toString()}',
                      ),
                    ),
                  ),
                  const Divider(height: 18),
                  Text(
                    t.drugsVipTotal(totalCost.toString()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(t.cancel),
            ),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.flash_on),
              label: Text(t.drugsFacBuy),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _vipQuickBuyingDrugId = drug.id;
    });
    try {
      final result = await _drugService.buyMissingMaterialsForDrug(drug.id);
      if (!mounted) return;

      final success = result['success'] == true;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            (result['message'] as String?) ??
                (success
                    ? t.drugsPurchaseCompleted
                    : t.drugsPurchaseFailed),
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      if (success) {
        await _loadData();
      }
    } finally {
      if (mounted) {
        setState(() {
          _vipQuickBuyingDrugId = null;
        });
      }
    }
  }

  Future<void> _startProduction(DrugDefinition drug) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final t = AppLocalizations.of(context)!;

    if (authProvider.currentPlayer!.rank < drug.requiredRank) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              t.drugsProdNeedRank('${drug.requiredRank}'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (!_hasRequiredMaterials(drug)) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_getMissingMaterials(drug, t)),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final facility = _getFacilityForDrug(drug.id);
    final timeStr = _getAdjustedTimeFormatted(drug, facility, t);
    final yieldStr = _getAdjustedYieldFormatted(drug, facility);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.drugsProdConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.drugsProdConfirmBody(drug.displayName),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(t.drugsProdTimeLine(timeStr)),
            Text(t.drugsProdYieldLine(yieldStr)),
            const SizedBox(height: 10),
            Text(
              t.drugsProdRiskNote,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.drugsProdRequiredMaterialsHeader,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ...drug.materials.entries.map((entry) {
              final displayName = _getMaterialName(entry.key);
              return Text('${entry.value}x $displayName');
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(t.drugsProdStartProductionButton),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await _drugService.startProduction(drug.id, null);

    if (mounted) {
      if (result['success'] == true) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      } else {
        final loc = AppLocalizations.of(context)!;
        final raw = result['message'] as String?;
        final msg = raw != null && raw.isNotEmpty
            ? localizeDrugClientMessage(loc, raw)
            : loc.drugsProdFailed;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _collectProduction(DrugProduction production) async {
    if (production.raidPending) {
      final resolved = await _resolveRaidDialog(production);
      if (resolved && mounted) {
        _applyCollectedProductionLocally(production);
        unawaited(_syncProductionContextAfterCollect());
      }
      return;
    }
    final result = await _drugService.collectProduction(
      production.id.toString(),
    );

    if (mounted) {
      if (result['raidPending'] == true || result['error'] == 'RAID_PENDING') {
        final raid = result['raid'] as Map<String, dynamic>? ?? {};
        final pending = DrugProduction(
          id: production.id,
          drugType: production.drugType,
          drugName: production.drugName,
          quantity: production.quantity,
          startedAt: production.startedAt,
          finishesAt: production.finishesAt,
          isReady: true,
          timeRemaining: 0,
          quality: production.quality,
          qualityLabel: production.qualityLabel,
          qualityColor: production.qualityColor,
          qualityMultiplier: production.qualityMultiplier,
          facilityId: production.facilityId,
          raidPending: true,
          raidLossPercent: (raid['lossPercent'] as num?)?.toInt(),
          raidCashFine: (raid['cashFine'] as num?)?.toInt(),
          raidDowntimeHours: (raid['downtimeHours'] as num?)?.toInt(),
        );
        final resolved = await _resolveRaidDialog(pending);
        if (resolved) {
          _applyCollectedProductionLocally(production);
          unawaited(_syncProductionContextAfterCollect());
        }
      } else if (result['success'] == true) {
        _applyCollectedProductionLocally(production);
        unawaited(_syncProductionContextAfterCollect());

        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final loc = AppLocalizations.of(context)!;
        final raw = result['message'] as String?;
        final msg = raw != null && raw.isNotEmpty
            ? localizeDrugClientMessage(loc, raw)
            : loc.drugsProdCollectFailed;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _speedupErrorMessage(AppLocalizations t, String? error) {
    switch (error) {
      case 'INSUFFICIENT_CREDITS':
        return t.drugsProdSpeedupInsufficientCredits;
      case 'PRODUCTION_ALREADY_READY':
        return t.drugsProdSpeedupAlreadyReady;
      case 'PRODUCTION_NOT_FOUND':
      case 'NOT_OWNER':
      case 'ALREADY_COLLECTED':
        return t.drugsProdSpeedupUnavailable;
      default:
        return t.drugsProdSpeedupFailed;
    }
  }

  Future<void> _confirmSpeedupProduction(DrugProduction production) async {
    if (_speedupBusy || production.isReady) return;

    setState(() {
      _speedupBusy = true;
      _speedupBusyProductionId = production.id;
    });

    final t = AppLocalizations.of(context)!;
    try {
      final quote = await _drugService.getProductionSpeedupQuote(production.id);
      if (!mounted) return;

      if (quote['success'] != true) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _speedupErrorMessage(t, quote['error']?.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final credits = (quote['credits'] as num?)?.toInt() ?? 0;
      final minutes = (quote['remainingMinutes'] as num?)?.toInt() ?? 0;
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1B1212),
          title: Text(
            t.drugsProdSpeedupTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            t.drugsProdSpeedupBody(credits, minutes),
            style: TextStyle(color: Colors.white.withOpacity(0.85)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(t.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2B94B),
                foregroundColor: Colors.black,
              ),
              child: Text(t.drugsProdSpeedupConfirm),
            ),
          ],
        ),
      );

      if (confirmed != true || !mounted) return;

      final result = await _drugService.speedupProduction(production.id);
      if (!mounted) return;

      if (result['success'] == true) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        await auth.refreshPlayer();
        await _loadData();
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              t.drugsProdSpeedupSuccess(
                (result['creditsSpent'] as num?)?.toInt() ?? credits,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _speedupErrorMessage(t, result['error']?.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _speedupBusy = false;
          _speedupBusyProductionId = null;
        });
      }
    }
  }

  void _applyCollectedProductionLocally(DrugProduction production) {
    setState(() {
      _activeProductions = _activeProductions
          .where((p) => p.id != production.id)
          .toList();

      final facilityId = production.facilityId;
      if (facilityId != null) {
        _facilities = _facilities.map((facility) {
          if (facility.id != facilityId) return facility;

          final nextActive = facility.activeProductions > 0
              ? facility.activeProductions - 1
              : 0;

          return DrugFacilityInfo(
            id: facility.id,
            facilityType: facility.facilityType,
            displayName: facility.displayName,
            slots: facility.slots,
            activeProductions: nextActive,
            purchasedAt: facility.purchasedAt,
            upgrades: facility.upgrades,
            qualityBonus: facility.qualityBonus,
            yieldBonus: facility.yieldBonus,
            speedBonus: facility.speedBonus,
            nextSlotCost: facility.nextSlotCost,
            isMaxSlots: facility.isMaxSlots,
          );
        }).toList();
      }
    });
  }

  Future<void> _syncProductionContextAfterCollect() async {
    try {
      final results = await Future.wait([
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugStats(),
      ]);

      if (!mounted) return;

      setState(() {
        _activeProductions = results[0] as List<DrugProduction>;
        _facilities = results[1] as List<DrugFacilityInfo>;
        _stats = results[2] as DrugStats?;
      });
    } catch (_) {
      // Local optimistic state already applied; ignore sync failures.
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final t = AppLocalizations.of(context)!;
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final padding = isMobile ? 12.0 : 20.0;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xCC111111),
            title: Text(t.drugsProdTitle),
            actions: [
              if (!_isLoading) ..._buildProductionKpis(t),
              if (_stats?.isVip == true)
                Tooltip(
                  message: _stats?.autoCollectEnabled == true
                      ? t.drugsProdAutoCollectOn
                      : t.drugsProdAutoCollectOff,
                  child: IconButton(
                    icon: Icon(
                      Icons.autorenew,
                      color: _stats?.autoCollectEnabled == true
                          ? Colors.greenAccent
                          : Colors.grey,
                    ),
                    onPressed: _togglingAutoCollect ? null : _toggleAutoCollect,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.factory_outlined),
                onPressed: _openFacilities,
              ),
              IconButton(
                icon: const Icon(Icons.science_outlined),
                tooltip: t.drugsOpenMaterials,
                onPressed: _openMaterials,
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: WebAssetHelper.image(
                  _backgroundAsset(width),
                  fit: BoxFit.cover,
                  alignment: isMobile
                      ? Alignment.topCenter
                      : Alignment.centerRight,
                  errorBuilder: (context, error, stackTrace) =>
                      WebAssetHelper.image(
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
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(isMobile ? 16 : 20),
                                decoration: _glassPanelDecoration(
                                  borderColor: const Color(0x5535C46A),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      t.drugsProdLineTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      t.drugsProdLineSubtitle,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.74),
                                        fontSize: isMobile ? 13 : 14,
                                      ),
                                    ),
                                    if (_stats != null) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        t.drugsHeatRaidHint(
                                          '${(_stats!.raidChance * 100).round()}',
                                        ),
                                        style: TextStyle(
                                          color: Colors.orangeAccent.withOpacity(0.9),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 18),
                              // Active Productions
                              if (_activeProductions.isNotEmpty) ...[
                                Text(
                                  t.drugsProdActiveProductions,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: () {
                                    final nextValue = !_showIncidentLegend;
                                    setState(
                                      () => _showIncidentLegend = nextValue,
                                    );
                                    _setLegendPreference(nextValue);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x33FFFFFF),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _showIncidentLegend
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.white70,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            t.drugsProdIncidentLegend,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _showIncidentLegend
                                              ? t.drugsProdHide
                                              : t.drugsProdShow,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_showIncidentLegend)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.42),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0x33FFFFFF),
                                      ),
                                    ),
                                    child: Wrap(
                                      spacing: 10,
                                      runSpacing: 8,
                                      children: [
                                        _buildLegendItem(
                                          Icons.schedule,
                                          Colors.amberAccent,
                                          t.drugsProdLegendDelay,
                                        ),
                                        _buildLegendItem(
                                          Icons.bug_report_outlined,
                                          const Color(0xFF81C784),
                                          t.drugsProdLegendContamination,
                                        ),
                                        _buildLegendItem(
                                          Icons.inventory_2_outlined,
                                          Colors.deepOrangeAccent,
                                          t.drugsProdLegendYieldLoss,
                                        ),
                                        _buildLegendItem(
                                          Icons.science_outlined,
                                          const Color(0xFFD1C4E9),
                                          t.drugsProdLegendInstability,
                                        ),
                                        _buildLegendItem(
                                          Icons.warning_amber_rounded,
                                          Colors.redAccent,
                                          t.drugsProdLegendCombined,
                                        ),
                                      ],
                                    ),
                                  ),
                                LayoutBuilder(
                                  builder: (context, sectionConstraints) {
                                    final maxWidth =
                                        sectionConstraints.maxWidth;
                                    final cardWidth = maxWidth < 760
                                        ? maxWidth
                                        : (maxWidth >= 1200
                                              ? (maxWidth - 24) / 3
                                              : (maxWidth - 12) / 2);

                                    return Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: _activeProductions.map((
                                        production,
                                      ) {
                                        return SizedBox(
                                          width: cardWidth,
                                          child: Card(
                                            color: Colors.black.withOpacity(
                                              0.58,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: const BorderSide(
                                                color: Color(0x33FFFFFF),
                                              ),
                                            ),
                                            margin: EdgeInsets.zero,
                                            child: Padding(
                                              padding: const EdgeInsets.all(14),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 21,
                                                        backgroundColor:
                                                            Colors.grey[200],
                                                        child: WebAssetHelper.image(
                                                          production
                                                              .getImagePath(),
                                                          width: 26,
                                                          height: 26,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => const Icon(
                                                                Icons.science,
                                                                size: 22,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          production.drugName,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    t.drugsProdYieldGrams(
                                                      '${production.quantity}',
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 3,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Color(
                                                        int.parse(
                                                          production
                                                              .qualityColor
                                                              .replaceFirst(
                                                                '#',
                                                                '0xff',
                                                              ),
                                                        ),
                                                      ).withOpacity(0.18),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            999,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      production.qualityLabel,
                                                      style: TextStyle(
                                                        color: Color(
                                                          int.parse(
                                                            production
                                                                .qualityColor
                                                                .replaceFirst(
                                                                  '#',
                                                                  '0xff',
                                                                ),
                                                          ),
                                                        ),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  if (production.incidentNote !=
                                                          null &&
                                                      production
                                                          .incidentNote!
                                                          .isNotEmpty) ...[
                                                    const SizedBox(height: 10),
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 8,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            production
                                                                    .incidentType ==
                                                                'contamination'
                                                            ? const Color(
                                                                0xFF2E7D32,
                                                              ).withOpacity(
                                                                0.20,
                                                              )
                                                            : production
                                                                      .incidentType ==
                                                                  'yield_loss'
                                                            ? Colors.deepOrange
                                                                  .withOpacity(
                                                                    0.18,
                                                                  )
                                                            : production
                                                                      .incidentType ==
                                                                  'instability'
                                                            ? Colors.purple
                                                                  .withOpacity(
                                                                    0.18,
                                                                  )
                                                            : production
                                                                      .incidentType ==
                                                                  'mixed'
                                                            ? Colors.red
                                                                  .withOpacity(
                                                                    0.17,
                                                                  )
                                                            : Colors.amber
                                                                  .withOpacity(
                                                                    0.14,
                                                                  ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        border: Border.all(
                                                          color:
                                                              production
                                                                      .incidentType ==
                                                                  'contamination'
                                                              ? const Color(
                                                                  0xFF43A047,
                                                                ).withOpacity(
                                                                  0.55,
                                                                )
                                                              : production
                                                                        .incidentType ==
                                                                    'yield_loss'
                                                              ? Colors
                                                                    .deepOrange
                                                                    .withOpacity(
                                                                      0.55,
                                                                    )
                                                              : production
                                                                        .incidentType ==
                                                                    'instability'
                                                              ? Colors.purple
                                                                    .withOpacity(
                                                                      0.55,
                                                                    )
                                                              : production
                                                                        .incidentType ==
                                                                    'mixed'
                                                              ? Colors.red
                                                                    .withOpacity(
                                                                      0.55,
                                                                    )
                                                              : Colors.amber
                                                                    .withOpacity(
                                                                      0.4,
                                                                    ),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        production
                                                            .incidentNote!,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 10),
                                                  if (production.isReady)
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: ElevatedButton(
                                                        onPressed: () =>
                                                            _collectProduction(
                                                              production,
                                                            ),
                                                        style:
                                                            ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.green,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                        child: Text(
                                                          t.drugsProdCollect,
                                                        ),
                                                      ),
                                                    )
                                                  else ...[
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .hourglass_bottom,
                                                          color: Colors.orange,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            production
                                                                .getTimeRemainingFormatted(),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .orange,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    LinearProgressIndicator(
                                                      value: production
                                                          .getProgress(),
                                                      backgroundColor:
                                                          Colors.grey[300],
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.green),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: OutlinedButton.icon(
                                                        onPressed:
                                                            _speedupBusy &&
                                                                _speedupBusyProductionId ==
                                                                    production
                                                                        .id
                                                            ? null
                                                            : () =>
                                                                  _confirmSpeedupProduction(
                                                                    production,
                                                                  ),
                                                        icon: _speedupBusy &&
                                                                _speedupBusyProductionId ==
                                                                    production
                                                                        .id
                                                            ? const SizedBox(
                                                                width: 16,
                                                                height: 16,
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons.bolt,
                                                                size: 18,
                                                              ),
                                                        label: Text(
                                                          t.drugsProdSpeedupAction,
                                                        ),
                                                        style:
                                                            OutlinedButton.styleFrom(
                                                          foregroundColor:
                                                              const Color(
                                                                0xFFF2B94B,
                                                              ),
                                                          side: BorderSide(
                                                            color: const Color(
                                                              0xFFF2B94B,
                                                            ).withOpacity(0.65),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 24),
                              ],

                              // Available Drugs
                              Text(
                                t.drugsProdAvailableDrugs,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),

                              if (_drugs.isEmpty)
                                Center(
                                  child: Text(
                                    t.drugsProdNoDrugs,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )
                              else
                                LayoutBuilder(
                                  builder: (context, sectionConstraints) {
                                    final maxWidth =
                                        sectionConstraints.maxWidth;
                                    final cardWidth = maxWidth < 760
                                        ? maxWidth
                                        : (maxWidth >= 1200
                                              ? (maxWidth - 24) / 3
                                              : (maxWidth - 12) / 2);

                                    return Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: _drugs.map((drug) {
                                        final hasRank =
                                            authProvider.currentPlayer!.rank >=
                                            drug.requiredRank;
                                        final hasMaterials =
                                            _hasRequiredMaterials(drug);
                                        final facilityType =
                                            _getFacilityTypeForDrug(drug.id);
                                        final facility = _getFacilityForDrug(
                                          drug.id,
                                        );
                                        final adjustedTime =
                                            _getAdjustedTimeFormatted(
                                              drug,
                                              facility,
                                              t,
                                            );
                                        final adjustedYield =
                                            _getAdjustedYieldFormatted(
                                              drug,
                                              facility,
                                            );
                                        final hasFacility =
                                            facilityType == null ||
                                            facility != null;
                                        final hasFreeSlot =
                                            facility == null ||
                                            facility.activeProductions <
                                                facility.slots;
                                        final canProduce =
                                            hasRank &&
                                            hasMaterials &&
                                            hasFacility &&
                                            hasFreeSlot;

                                        return SizedBox(
                                          width: cardWidth,
                                          child: Card(
                                            color: Colors.black.withOpacity(
                                              0.58,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              side: const BorderSide(
                                                color: Color(0x33FFFFFF),
                                              ),
                                            ),
                                            margin: EdgeInsets.zero,
                                            child: Padding(
                                              padding: const EdgeInsets.all(14),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 21,
                                                        backgroundColor:
                                                            Colors.grey[200],
                                                        child: WebAssetHelper.image(
                                                          drug.getImagePath(),
                                                          width: 26,
                                                          height: 26,
                                                          errorBuilder:
                                                              (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) => const Icon(
                                                                Icons.science,
                                                              ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Expanded(
                                                        child: Text(
                                                          drug.displayName,
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                      if (_stats?.isVip == true)
                                                        Tooltip(
                                                          message: hasMaterials
                                                              ? t
                                                                    .drugsProdVipMaterialsOk
                                                              : t
                                                                    .drugsProdVipBuyMissing,
                                                          child: IconButton(
                                                            visualDensity:
                                                                VisualDensity
                                                                    .compact,
                                                            icon: Icon(
                                                              Icons.flash_on,
                                                              color:
                                                                  hasMaterials
                                                                  ? Colors
                                                                        .greenAccent
                                                                  : Colors
                                                                        .amberAccent,
                                                            ),
                                                            onPressed:
                                                                hasMaterials ||
                                                                    _vipQuickBuyingDrugId ==
                                                                        drug.id
                                                                ? null
                                                                : () =>
                                                                      _handleVipQuickBuyMaterials(
                                                                        drug,
                                                                      ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    Localizations.localeOf(
                                                                  context,
                                                                ).languageCode ==
                                                                'nl'
                                                        ? drug.description
                                                        : drug.descriptionEn,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.85),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    t.drugsProdTimeYieldLine(
                                                      adjustedTime,
                                                      adjustedYield,
                                                    ),
                                                    style: TextStyle(
                                                      color: Colors.grey[300],
                                                    ),
                                                  ),
                                                  if (facilityType != null) ...[
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      hasFacility
                                                          ? t.drugsProdSlotsUsedLine(
                                                              _getFacilityDisplayName(
                                                                facilityType,
                                                                t,
                                                              ),
                                                              '${facility!.activeProductions}',
                                                              '${facility.slots}',
                                                            )
                                                          : t.drugsProdFacilityRequired(
                                                              _getFacilityDisplayName(
                                                                facilityType,
                                                                t,
                                                              ),
                                                            ),
                                                      style: TextStyle(
                                                        color: hasFacility
                                                            ? Colors
                                                                  .lightBlueAccent
                                                            : Colors.orange,
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 8),
                                                  Wrap(
                                                    spacing: 6,
                                                    runSpacing: 6,
                                                    children: drug.materials.entries.map((
                                                      entry,
                                                    ) {
                                                      final have =
                                                          _materialsSnapshot
                                                              .availableForProduction(
                                                        entry.key,
                                                      );
                                                      final hasEnough =
                                                          have >= entry.value;
                                                      return Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8,
                                                              vertical: 4,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color:
                                                              (hasEnough
                                                                      ? Colors
                                                                            .green
                                                                      : Colors
                                                                            .red)
                                                                  .withOpacity(
                                                                    0.14,
                                                                  ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                999,
                                                              ),
                                                          border: Border.all(
                                                            color:
                                                                (hasEnough
                                                                        ? Colors
                                                                              .green
                                                                        : Colors
                                                                              .red)
                                                                    .withOpacity(
                                                                      0.35,
                                                                    ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          '${_getMaterialName(entry.key)} $have/${entry.value}',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: hasEnough
                                                                ? Colors
                                                                      .lightGreenAccent
                                                                : Colors
                                                                      .orangeAccent,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  if (!hasRank)
                                                    Text(
                                                      t.drugsProdRankRequired(
                                                        '${drug.requiredRank}',
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  if (hasFacility &&
                                                      !hasFreeSlot)
                                                    Text(
                                                      t.drugsProdNoFreeSlot,
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.orangeAccent,
                                                      ),
                                                    ),
                                                  if (!hasMaterials)
                                                    Text(
                                                      _getMissingMaterials(
                                                        drug,
                                                        t,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        color:
                                                            Colors.orangeAccent,
                                                      ),
                                                    ),
                                                  if (facilityType != null &&
                                                      !hasFacility) ...[
                                                    const SizedBox(height: 8),
                                                    SizedBox(
                                                      width: double.infinity,
                                                      child: OutlinedButton.icon(
                                                        onPressed:
                                                            _openFacilities,
                                                        icon: const Icon(
                                                          Icons
                                                              .factory_outlined,
                                                          size: 16,
                                                        ),
                                                        label: Text(
                                                          t.drugsProdOpenFacilities,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                  const SizedBox(height: 8),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: ElevatedButton(
                                                      onPressed: canProduce
                                                          ? () =>
                                                                _startProduction(
                                                                  drug,
                                                                )
                                                          : null,
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        foregroundColor:
                                                            Colors.white,
                                                        disabledBackgroundColor:
                                                            Colors.white24,
                                                        disabledForegroundColor:
                                                            Colors.white54,
                                                      ),
                                                      child: Text(
                                                        t.drugsProdStartProduction,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _toggleAutoCollect() async {
    setState(() => _togglingAutoCollect = true);
    try {
      final loc = AppLocalizations.of(context)!;
      final result = await _drugService.toggleAutoCollect();
      if (mounted) {
        final raw = result['message'] as String?;
        final msg = raw != null && raw.isNotEmpty
            ? localizeDrugClientMessage(loc, raw)
            : loc.drugsProdAutoCollectUpdated;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(msg),
            backgroundColor: result['success'] == true
                ? Colors.green
                : Colors.red,
          ),
        );
        _loadData();
      }
    } catch (_) {
      setState(() => _togglingAutoCollect = false);
    }
  }

  List<Widget> _buildProductionKpis(AppLocalizations t) {
    final readyCount = _activeProductions.where((p) => p.isReady).length;
    return [
      _KpiChip(
        value: '${_activeProductions.length}',
        label: t.drugsProdKpiActive,
        icon: Icons.timelapse,
        color: const Color(0xFF35C46A),
      ),
      if (readyCount > 0)
        _KpiChip(
          value: '$readyCount',
          label: t.drugsProdKpiReady,
          icon: Icons.check_circle_outline,
          color: Colors.amber,
        ),
    ];
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

class _MissingMaterialLine {
  final String name;
  final int quantity;
  final int unitPrice;

  const _MissingMaterialLine({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  int get lineCost => quantity * unitPrice;
}
