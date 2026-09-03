import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../providers/auth_provider.dart';
import '../services/drug_service.dart';
import '../utils/drug_localizations.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import 'black_market_screen.dart';
import 'drug_facility_screen.dart';
import 'drug_inventory_screen.dart';
import 'drug_production_screen.dart';

class DrugEnvironmentScreen extends StatefulWidget {
  const DrugEnvironmentScreen({
    super.key,
    this.embedded = false,
    this.onOpenBlackMarket,
  });

  /// When true (web dashboard), omit AppBar and keep subviews in-place.
  final bool embedded;
  final VoidCallback? onOpenBlackMarket;

  @override
  State<DrugEnvironmentScreen> createState() => _DrugEnvironmentScreenState();
}

class _DrugEnvironmentScreenState extends State<DrugEnvironmentScreen> {
  final DrugService _drugService = DrugService();
  _DrugWebSubview _webSubview = _DrugWebSubview.hub;
  bool _isLoadingStats = true;
  List<DrugProduction> _activeProductions = const [];
  List<DrugFacilityInfo> _facilities = const [];
  List<DrugInventory> _inventory = const [];
  List<DrugDefinition> _drugCatalog = const [];
  DrugHeatInfo? _heatInfo;
  List<DrugWholesaleShipment> _wholesaleShipments = const [];

  @override
  void initState() {
    super.initState();
    _loadDashboardStats();
  }

  String _backgroundAsset(double width) {
    if (width < 700) {
      return 'assets/images/backgrounds/drug_environment_mobile.png';
    }
    if (width < 1100) {
      return 'assets/images/backgrounds/drug_environment_tablet.png';
    }
    return 'assets/images/backgrounds/drug_environment_desktop.png';
  }

  void _openScreen(
    BuildContext context,
    Widget screen,
    _DrugWebSubview webSubview,
  ) {
    if (kIsWeb || widget.embedded) {
      setState(() => _webSubview = webSubview);
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen)).then((
      _,
    ) {
      if (mounted) {
        _loadDashboardStats();
      }
    });
  }

  Future<void> _loadDashboardStats() async {
    setState(() => _isLoadingStats = true);
    try {
      final results = await Future.wait([
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugInventory(),
        _drugService.getDrugCatalog(),
      ]);
      DrugHeatInfo? heatInfo;
      List<DrugWholesaleShipment> wholesale = const [];
      try {
        heatInfo = await _drugService.getDrugHeat();
      } catch (_) {}
      try {
        wholesale = await _drugService.getWholesaleShipments();
      } catch (_) {}
      if (!mounted) return;
      setState(() {
        _activeProductions = results[0] as List<DrugProduction>;
        _facilities = results[1] as List<DrugFacilityInfo>;
        _inventory = results[2] as List<DrugInventory>;
        _drugCatalog = results[3] as List<DrugDefinition>;
        _heatInfo = heatInfo;
        _wholesaleShipments = wholesale;
        _isLoadingStats = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingStats = false);
    }
  }

  int _inventoryValueForCountry(String country) {
    final catalogById = {for (final drug in _drugCatalog) drug.id: drug};
    var total = 0;
    for (final row in _inventory) {
      final drug = catalogById[row.drugType];
      if (drug == null) continue;
      final base = drug.getPriceForCountry(country);
      total += (base * row.qualityMultiplier).round() * row.quantity;
    }
    return total;
  }

  int _totalSlots() {
    return _facilities.fold(0, (sum, item) => sum + item.slots);
  }

  int _usedSlots() {
    return _facilities.fold(0, (sum, item) => sum + item.activeProductions);
  }

  int _totalInventoryGrams() {
    return _inventory.fold(0, (sum, item) => sum + item.quantity);
  }

  double _efficiencyScore() {
    if (_facilities.isEmpty) return 0;
    final totalSlots = _totalSlots();
    final usedSlots = _usedSlots();
    final slotUsage = totalSlots > 0 ? usedSlots / totalSlots : 0.0;
    int totalUpgrades = 0;
    int upgradeCount = 0;
    for (final f in _facilities) {
      for (final level in f.upgrades.values) {
        totalUpgrades += level;
        upgradeCount++;
      }
    }
    final avgUpgrade = upgradeCount > 0 ? totalUpgrades / upgradeCount : 0.0;
    final upgradeRatio = (avgUpgrade / 5.0).clamp(0.0, 1.0);
    return ((slotUsage * 0.6) + (upgradeRatio * 0.4)) * 100;
  }

  Map<String, int> _qualityGramsByGrade() {
    final result = <String, int>{};
    for (final item in _inventory) {
      result[item.quality] = (result[item.quality] ?? 0) + item.quantity;
    }
    return result;
  }

  String _webSubviewTitle(BuildContext context, _DrugWebSubview section) {
    final t = AppLocalizations.of(context)!;
    switch (section) {
      case _DrugWebSubview.hub:
        return t.drugsHubTitle;
      case _DrugWebSubview.production:
        return t.drugsProdTitle;
      case _DrugWebSubview.facilities:
        return t.drugsFacilitiesTitle;
      case _DrugWebSubview.inventory:
        return t.drugsInvTitle;
    }
  }

  String _facilitiesBadge(AppLocalizations t) {
    if (_facilities.isEmpty) {
      return t.drugsCardFacilitiesBadgeNone;
    }
    return t.drugsCardFacilitiesBadgeCount(_facilities.length);
  }

  String _productionBadge(AppLocalizations t) {
    if (_activeProductions.isEmpty) {
      return t.drugsCardProductionBadgeNone;
    }
    return t.drugsCardProductionBadgeCount(_activeProductions.length);
  }

  String _inventoryBadge(AppLocalizations t, int grams, int value) {
    if (grams <= 0) {
      return t.drugsCardInventoryBadgeNone;
    }
    return t.drugsCardInventoryBadgeSummary(
      grams,
      _formatCompactMoney(value),
    );
  }

  Widget _buildSubviewHeader(BuildContext context, _DrugWebSubview section) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () {
              setState(() => _webSubview = _DrugWebSubview.hub);
              _loadDashboardStats();
            },
          ),
          Expanded(
            child: Text(
              _webSubviewTitle(context, section),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubviewBody(_DrugWebSubview section) {
    return switch (section) {
      _DrugWebSubview.production => DrugProductionScreen(
        onOpenFacilitiesRequested: () {
          setState(() => _webSubview = _DrugWebSubview.facilities);
        },
        onOpenBlackMarket: _openMaterials,
      ),
      _DrugWebSubview.facilities =>
        const DrugFacilityScreen(showAppBar: false),
      _DrugWebSubview.inventory => const DrugInventoryScreen(),
      _DrugWebSubview.hub => const SizedBox.shrink(),
    };
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
  }

  Future<void> _coolHeat(String action) async {
    final result = await _drugService.coolDrugHeat(action);
    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          (result['message'] as String?) ??
              (result['success'] == true ? t.drugsHeatCoolDone : t.drugsHeatCoolFailed),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) _loadDashboardStats();
  }

  List<Widget> _buildOperationCards(
    BuildContext context,
    AppLocalizations t,
    int inventoryGrams,
    int inventoryValue,
  ) {
    return [
      _DrugOperationCard(
        step: 1,
        icon: Icons.factory_outlined,
        eyebrow: t.drugsCardFacilitiesEyebrow,
        title: t.drugsCardFacilitiesTitle,
        subtitle: t.drugsCardFacilitiesBody,
        status: _facilitiesBadge(t),
        actionLabel: t.drugsCardOpenAction,
        color: const Color(0xFF48B8FF),
        onTap: () => _openScreen(
          context,
          const DrugFacilityScreen(showAppBar: false),
          _DrugWebSubview.facilities,
        ),
      ),
      _DrugOperationCard(
        step: 2,
        icon: Icons.precision_manufacturing_outlined,
        eyebrow: t.drugsCardProductionEyebrow,
        title: t.drugsCardProductionTitle,
        subtitle: t.drugsCardProductionBody,
        status: _productionBadge(t),
        actionLabel: t.drugsCardOpenAction,
        color: const Color(0xFF35C46A),
        onTap: () => _openScreen(
          context,
          DrugProductionScreen(
            onOpenFacilitiesRequested: () {
              setState(() => _webSubview = _DrugWebSubview.facilities);
            },
            onOpenBlackMarket: _openMaterials,
          ),
          _DrugWebSubview.production,
        ),
      ),
      _DrugOperationCard(
        step: 3,
        icon: Icons.inventory_2_outlined,
        eyebrow: t.drugsCardInventoryEyebrow,
        title: t.drugsCardInventoryTitle,
        subtitle: t.drugsCardInventoryBody,
        status: _inventoryBadge(t, inventoryGrams, inventoryValue),
        actionLabel: t.drugsCardOpenAction,
        color: const Color(0xFFF2B94B),
        onTap: () => _openScreen(
          context,
          const DrugInventoryScreen(),
          _DrugWebSubview.inventory,
        ),
      ),
    ];
  }

  Widget _buildOperationsLayout(
    BuildContext context,
    AppLocalizations t,
    bool isMobile,
    int inventoryGrams,
    int inventoryValue,
  ) {
    final cards = _buildOperationCards(
      context,
      t,
      inventoryGrams,
      inventoryValue,
    );

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            cards[i],
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }

  Widget _buildMetricsSection(AppLocalizations t, int usedSlots, int totalSlots,
      int inventoryValue, int inventoryGrams) {
    if (_isLoadingStats) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: LinearProgressIndicator(minHeight: 3),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 900
            ? (constraints.maxWidth - 50) / 6
            : constraints.maxWidth >= 560
            ? (constraints.maxWidth - 24) / 3
            : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _DashboardMetricCard(
              width: cardWidth.clamp(140, 220),
              label: t.drugsMetricActiveBatches,
              value: '${_activeProductions.length}',
              icon: Icons.timelapse,
              color: const Color(0xFF35C46A),
            ),
            _DashboardMetricCard(
              width: cardWidth.clamp(140, 220),
              label: t.drugsMetricSlotUsage,
              value: totalSlots > 0 ? '$usedSlots/$totalSlots' : '0/0',
              icon: Icons.grid_view_rounded,
              color: const Color(0xFF48B8FF),
            ),
            _DashboardMetricCard(
              width: cardWidth.clamp(140, 220),
              label: t.drugsMetricInventoryValue,
              value: '€${_formatCompactMoney(inventoryValue)}',
              icon: Icons.euro,
              color: const Color(0xFFF2B94B),
            ),
            _DashboardMetricCard(
              width: cardWidth.clamp(140, 220),
              label: t.drugsMetricInventoryGrams,
              value: '$inventoryGrams g',
              icon: Icons.inventory_2,
              color: const Color(0xFFC16CFF),
            ),
            _DashboardMetricCard(
              width: cardWidth.clamp(140, 220),
              label: t.drugsMetricEfficiency,
              value: '${_efficiencyScore().round()}%',
              icon: Icons.auto_graph,
              color: const Color(0xFFFF6B6B),
            ),
            if (_heatInfo != null)
              _DashboardMetricCard(
                width: cardWidth.clamp(140, 220),
                label: t.drugsMetricPoliceHeat,
                value:
                    '${_heatInfo!.heat} – ${drugHeatLevelLabel(t, _heatInfo!.level)}',
                icon: Icons.local_fire_department,
                color: _heatInfo!.color,
              ),
          ],
        );
      },
    );
  }

  Widget _buildWholesaleStrip(AppLocalizations t) {
    final rows = _wholesaleShipments.take(5).toList();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
        color: Colors.black.withOpacity(0.42),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.drugsHubExportsTitle,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (rows.isEmpty)
            Text(
              t.drugsHubExportEmpty,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
            )
          else
            ...rows.map((row) {
              final dest = drugCountryDisplayName(t, row.destinationCountry);
              final status = row.status == 'seized'
                  ? t.drugsHubExportSeized
                  : (row.status == 'claimed' || row.settled)
                      ? t.drugsHubExportSold
                      : t.drugsHubExportInTransit;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '${row.crewWholesale ? '${t.drugsHubExportCrewPrefix} · ' : ''}${t.drugsHubExportLine('${row.quantity}', dest, status)}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.86),
                    fontSize: 13,
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildHeatAndMaterials(AppLocalizations t) {
    final heat = _heatInfo;
    final raidPct = heat == null ? 0 : (heat.raidChance * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _openMaterials,
          icon: const Icon(Icons.science_outlined),
          label: Text(t.drugsOpenMaterials),
        ),
        if (heat != null) ...[
          const SizedBox(height: 10),
          Text(
            t.drugsHeatRaidHint(raidPct.toString()),
            style: TextStyle(color: Colors.white.withOpacity(0.78), fontSize: 13),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => _coolHeat('low_profile'),
                child: Text(t.drugsHeatLowProfile),
              ),
              OutlinedButton(
                onPressed: heat.cashCoolCost > 0
                    ? () => _coolHeat('cash')
                    : null,
                child: Text(
                  t.drugsHeatCashCool(formatCurrency(heat.cashCoolCost)),
                ),
              ),
              if (heat.shieldActive)
                Chip(label: Text(t.drugsHeatShieldActive)),
              if (heat.lowProfileActive)
                Chip(label: Text(t.drugsHeatLowProfileActive)),
            ],
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_webSubview != _DrugWebSubview.hub && (kIsWeb || widget.embedded)) {
      if (widget.embedded) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSubviewHeader(context, _webSubview),
            Expanded(child: _buildSubviewBody(_webSubview)),
          ],
        );
      }

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              setState(() => _webSubview = _DrugWebSubview.hub);
              _loadDashboardStats();
            },
          ),
          title: Text(_webSubviewTitle(context, _webSubview)),
        ),
        body: _buildSubviewBody(_webSubview),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 700;
        final isTablet = width >= 700 && width < 1100;
        final backgroundAsset = _backgroundAsset(width);
        final headerPadding = isMobile ? 18.0 : (isTablet ? 22.0 : 28.0);
        final titleSize = isMobile ? 28.0 : (isTablet ? 34.0 : 40.0);
        final horizontalPadding = isMobile ? 12.0 : (isTablet ? 20.0 : 28.0);
        final currentCountry =
            authProvider.currentPlayer?.currentCountry ?? 'netherlands';
        final inventoryValue = _inventoryValueForCountry(currentCountry);
        final usedSlots = _usedSlots();
        final totalSlots = _totalSlots();
        final inventoryGrams = _totalInventoryGrams();
        final t = AppLocalizations.of(context)!;

        return Scaffold(
          appBar: widget.embedded
              ? null
              : AppBar(
                  title: Text(t.drugsHubTitle),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: _loadDashboardStats,
                      tooltip: t.retry,
                    ),
                  ],
                ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  backgroundAsset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/images/backgrounds/crime_background.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
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
                        Colors.black.withOpacity(0.28),
                        Colors.black.withOpacity(0.58),
                        Colors.black.withOpacity(0.82),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: -60,
                right: -40,
                child: _AmbientOrb(size: 220, color: Color(0x6635C46A)),
              ),
              const Positioned(
                bottom: 40,
                left: -30,
                child: _AmbientOrb(size: 180, color: Color(0x4448B8FF)),
              ),
              const Positioned(
                top: 180,
                left: 40,
                child: _AmbientOrb(size: 100, color: Color(0x33F2B94B)),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 22 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(headerPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0.54),
                                const Color(0xFF121212).withOpacity(0.72),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x55000000),
                                blurRadius: 28,
                                offset: Offset(0, 16),
                              ),
                            ],
                          ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _TopTag(
                                        label: t.drugsTagUndergroundOps,
                                        color: const Color(0xFF35C46A),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        t.drugsEmpireTitle,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: titleSize,
                                          height: 0.95,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        t.drugsHubIntro,
                                        style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.78),
                                          fontSize: isMobile ? 13 : 14,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (!isMobile)
                                  IconButton(
                                    onPressed: _loadDashboardStats,
                                    tooltip: t.retry,
                                    icon: Icon(
                                      Icons.refresh,
                                      color: Colors.white.withOpacity(0.75),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _SectionLabel(
                              title: t.drugsSectionOperations,
                              subtitle: t.drugsSectionOperationsSubtitle,
                            ),
                            const SizedBox(height: 10),
                            _buildOperationsLayout(
                              context,
                              t,
                              isMobile,
                              inventoryGrams,
                              inventoryValue,
                            ),
                            const SizedBox(height: 12),
                            _buildHeatAndMaterials(t),
                            const SizedBox(height: 12),
                            _buildWholesaleStrip(t),
                            const SizedBox(height: 18),
                            Text(
                              t.drugsHubStatsTitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.82),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildMetricsSection(
                              t,
                              usedSlots,
                              totalSlots,
                              inventoryValue,
                              inventoryGrams,
                            ),
                            if (!_isLoadingStats &&
                                _inventory.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              _QualityDistributionSection(
                                inventory: _inventory,
                                gramsByGrade: _qualityGramsByGrade(),
                              ),
                            ],
                          ],
                        ),
                        ),
                      ),
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

  String _formatCompactMoney(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    }
    return '$value';
  }
}

enum _DrugWebSubview { hub, production, facilities, inventory }

class _TopTag extends StatelessWidget {
  final String label;
  final Color color;

  const _TopTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.42)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionLabel({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(color: Colors.white.withOpacity(0.68), fontSize: 13),
        ),
      ],
    );
  }
}

class _AmbientOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _AmbientOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withOpacity(0.0)]),
        ),
      ),
    );
  }
}

class _DrugOperationCard extends StatelessWidget {
  final int step;
  final IconData icon;
  final String eyebrow;
  final String title;
  final String subtitle;
  final String status;
  final String actionLabel;
  final Color color;
  final VoidCallback onTap;

  const _DrugOperationCard({
    required this.step,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.actionLabel,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withOpacity(0.42),
            border: Border.all(color: color.withOpacity(0.42)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(17),
                  ),
                  border: Border(
                    bottom: BorderSide(color: color.withOpacity(0.28)),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.45)),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.drugsCardStepLabel(step),
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            eyebrow,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.62),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 13,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onTap,
                        icon: Icon(Icons.arrow_forward, color: color, size: 18),
                        label: Text(
                          actionLabel,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: color.withOpacity(0.55)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double width;

  const _DashboardMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.16),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.66),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Quality grades ordered best → worst
const _kQualityOrder = ['S', 'A', 'B', 'C', 'D'];
final _kQualityColors = <String, Color>{
  'S': const Color(0xFFFFD700),
  'A': const Color(0xFF35C46A),
  'B': const Color(0xFF48B8FF),
  'C': const Color(0xFF888888),
  'D': const Color(0xFFFF6B6B),
};
class _QualityDistributionSection extends StatelessWidget {
  final List<DrugInventory> inventory;
  final Map<String, int> gramsByGrade;

  const _QualityDistributionSection({
    required this.inventory,
    required this.gramsByGrade,
  });

  String _gradeLabel(AppLocalizations t, String grade) {
    switch (grade) {
      case 'S':
        return t.drugsQualityGradeSuperior;
      case 'A':
        return t.drugsQualityGradeHigh;
      case 'B':
        return t.drugsQualityGradeStandardPlus;
      case 'C':
        return t.drugsQualityGradeStandard;
      case 'D':
        return t.drugsQualityGradeLow;
      default:
        return grade;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final totalGrams = gramsByGrade.values.fold(0, (a, b) => a + b);
    if (totalGrams == 0) return const SizedBox.shrink();

    final presentGrades = _kQualityOrder
        .where((g) => gramsByGrade.containsKey(g))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.drugsQualityDistribution,
          style: TextStyle(
            color: Colors.white.withOpacity(0.68),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        // Segmented bar
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 8,
            child: Row(
              children: presentGrades.map((grade) {
                final frac = gramsByGrade[grade]! / totalGrams;
                final color = _kQualityColors[grade] ?? Colors.grey;
                return Expanded(
                  flex: (frac * 1000).round(),
                  child: ColoredBox(color: color),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Pill row
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presentGrades.map((grade) {
            final grams = gramsByGrade[grade]!;
            final color = _kQualityColors[grade] ?? Colors.grey;
            final label = _gradeLabel(t, grade);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: color.withOpacity(0.36)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$grade · $label  $grams g',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
