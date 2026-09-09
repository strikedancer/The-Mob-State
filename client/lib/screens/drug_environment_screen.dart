import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/drug_models.dart';
import '../services/drug_service.dart';
import '../utils/drug_localizations.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';
import '../widgets/game_page_info.dart';
import 'black_market_screen.dart';
import 'drug_facility_screen.dart';
import 'drug_inventory_screen.dart';
import 'drug_production_screen.dart';

const Color _drugGold = Color(0xFFFFB347);
const Color _drugBgStart = Color(0xFF160707);
const Color _drugBgMid = Color(0xFF261010);
const Color _drugBgEnd = Color(0xFF100505);
const Color _drugPanelDark = Color(0xFF1B1212);
const Color _drugPanelLight = Color(0xFF2A1A1A);

class DrugEnvironmentScreen extends StatefulWidget {
  const DrugEnvironmentScreen({
    super.key,
    this.embedded = false,
    this.onOpenBlackMarket,
  });

  /// When true (web dashboard), omit AppBar.
  final bool embedded;
  final VoidCallback? onOpenBlackMarket;

  @override
  State<DrugEnvironmentScreen> createState() => _DrugEnvironmentScreenState();
}

class _DrugEnvironmentScreenState extends State<DrugEnvironmentScreen>
    with SingleTickerProviderStateMixin {
  static const _heroAsset =
      'assets/images/backgrounds/drug_environment_desktop.png';

  final DrugService _drugService = DrugService();
  late final TabController _tabs;
  bool _isLoadingStats = true;
  bool _busy = false;
  int _refreshSeed = 0;
  List<DrugProduction> _activeProductions = const [];
  List<DrugFacilityInfo> _facilities = const [];
  List<DrugInventory> _inventory = const [];
  DrugHeatInfo? _heatInfo;
  List<DrugWholesaleShipment> _wholesaleShipments = const [];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(_onTabSettled);
    _loadDashboardStats();
  }

  @override
  void dispose() {
    _tabs.removeListener(_onTabSettled);
    _tabs.dispose();
    super.dispose();
  }

  void _onTabSettled() {
    if (_tabs.indexIsChanging) return;
    _loadDashboardStats(quiet: true);
  }

  Future<void> _reloadAll() async {
    setState(() => _refreshSeed++);
    await _loadDashboardStats();
  }

  Future<void> _loadDashboardStats({bool quiet = false}) async {
    if (!quiet) {
      setState(() => _isLoadingStats = true);
    }
    try {
      final results = await Future.wait([
        _drugService.getActiveProductions(),
        _drugService.getMyFacilities(),
        _drugService.getDrugInventory(),
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
        _heatInfo = heatInfo;
        _wholesaleShipments = wholesale;
        _isLoadingStats = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingStats = false);
    }
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
    setState(() => _busy = true);
    final result = await _drugService.coolDrugHeat(action);
    if (!mounted) return;
    setState(() => _busy = false);
    final t = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          (result['message'] as String?) ??
              (result['success'] == true
                  ? t.drugsHeatCoolDone
                  : t.drugsHeatCoolFailed),
        ),
        backgroundColor: result['success'] == true ? Colors.green : Colors.red,
      ),
    );
    if (result['success'] == true) _loadDashboardStats(quiet: true);
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [_drugPanelLight, _drugPanelDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _drugGold.withValues(alpha: 0.45)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.28),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _drugImage(String asset, {IconData fallback = Icons.local_pharmacy}) {
    return WebAssetHelper.image(
      asset,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: Colors.black26,
        child: Icon(
          fallback,
          color: _drugGold.withValues(alpha: 0.55),
          size: 36,
        ),
      ),
    );
  }

  Widget _statChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _drugGold.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: _drugGold),
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

  Widget _buildHero(AppLocalizations t) {
    final wide = MediaQuery.sizeOf(context).width >= 720;
    final height = wide ? 168.0 : 148.0;
    final usedSlots = _usedSlots();
    final totalSlots = _totalSlots();
    final grams = _totalInventoryGrams();
    final heat = _heatInfo;
    return Container(
      decoration: _panelDecoration(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _drugImage(_heroAsset),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.82),
                    Colors.black.withValues(alpha: 0.42),
                    Colors.black.withValues(alpha: 0.18),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          t.drugsEmpireTitle,
                          style: const TextStyle(
                            color: _drugGold,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const GamePageInfoButton(topicId: 'drugs'),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: _isLoadingStats ? null : _reloadAll,
                        color: _drugGold,
                        tooltip: t.retry,
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _statChip(
                        icon: Icons.timelapse,
                        label:
                            '${t.drugsMetricActiveBatches}: ${_activeProductions.length}',
                      ),
                      _statChip(
                        icon: Icons.grid_view_rounded,
                        label: totalSlots > 0
                            ? '$usedSlots/$totalSlots'
                            : '0/0',
                      ),
                      _statChip(
                        icon: Icons.inventory_2,
                        label: '$grams g',
                      ),
                      if (heat != null)
                        _statChip(
                          icon: Icons.local_fire_department,
                          label:
                              '${heat.heat} – ${drugHeatLevelLabel(t, heat.level)}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionStrip(AppLocalizations t) {
    final heat = _heatInfo;
    final raidPct = heat == null ? 0 : (heat.raidChance * 100).round();
    final rows = _wholesaleShipments.take(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: _openMaterials,
                icon: const Icon(Icons.science_outlined, size: 16),
                label: Text(t.drugsOpenMaterials),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _drugGold,
                  side: BorderSide(color: _drugGold.withValues(alpha: 0.75)),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              if (heat != null) ...[
                OutlinedButton(
                  onPressed: () => _coolHeat('low_profile'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: _drugGold.withValues(alpha: 0.4)),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(t.drugsHeatLowProfile),
                ),
                OutlinedButton(
                  onPressed: heat.cashCoolCost > 0
                      ? () => _coolHeat('cash')
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white70,
                    side: BorderSide(color: _drugGold.withValues(alpha: 0.4)),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(
                    t.drugsHeatCashCool(formatCurrency(heat.cashCoolCost)),
                  ),
                ),
                if (heat.shieldActive)
                  _statChip(
                    icon: Icons.shield,
                    label: t.drugsHeatShieldActive,
                  ),
                if (heat.lowProfileActive)
                  _statChip(
                    icon: Icons.visibility_off,
                    label: t.drugsHeatLowProfileActive,
                  ),
              ],
            ],
          ),
          if (heat != null) ...[
            const SizedBox(height: 6),
            Text(
              t.drugsHeatRaidHint(raidPct.toString()),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.72),
                fontSize: 12,
              ),
            ),
          ],
          if (rows.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              t.drugsHubExportsTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            for (final row in rows)
              Text(
                '${row.crewWholesale ? '${t.drugsHubExportCrewPrefix} · ' : ''}${t.drugsHubExportLine('${row.quantity}', drugCountryDisplayName(t, row.destinationCountry), row.status == 'seized' ? t.drugsHubExportSeized : (row.status == 'claimed' || row.settled) ? t.drugsHubExportSold : t.drugsHubExportInTransit)}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 12,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _keepAlive(Widget child) {
    return _KeepAliveTab(child: child);
  }

  Widget _buildBody(AppLocalizations t) {
    final tabBar = TabBar(
      controller: _tabs,
      isScrollable: true,
      labelColor: _drugGold,
      unselectedLabelColor: Colors.white70,
      indicatorColor: _drugGold,
      dividerColor: _drugGold.withValues(alpha: 0.22),
      tabs: [
        Tab(text: t.drugsCardFacilitiesTitle),
        Tab(text: t.drugsCardProductionTitle),
        Tab(text: t.drugsCardInventoryTitle),
      ],
    );

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: _buildHero(t),
          ),
        ),
        if (_busy || _isLoadingStats)
          const SliverToBoxAdapter(
            child: LinearProgressIndicator(
              minHeight: 2,
              color: _drugGold,
              backgroundColor: Color(0x33FFB347),
            ),
          ),
        SliverToBoxAdapter(child: _buildActionStrip(t)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedTabBarDelegate(
            tabBar: tabBar,
            background: _drugBgMid,
          ),
        ),
      ],
      body: TabBarView(
        controller: _tabs,
        children: [
          _keepAlive(
            DrugFacilityScreen(
              key: ValueKey('drug-fac-$_refreshSeed'),
              showAppBar: false,
            ),
          ),
          _keepAlive(
            DrugProductionScreen(
              key: ValueKey('drug-prod-$_refreshSeed'),
              showAppBar: false,
              onOpenFacilitiesRequested: () => _tabs.animateTo(0),
              onOpenBlackMarket: _openMaterials,
            ),
          ),
          _keepAlive(
            DrugInventoryScreen(
              key: ValueKey('drug-inv-$_refreshSeed'),
              showAppBar: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shell({required Widget child}) {
    final painted = DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_drugBgStart, _drugBgMid, _drugBgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
    if (widget.embedded) return painted;
    return Scaffold(
      backgroundColor: _drugBgEnd,
      appBar: AppBar(
        backgroundColor: _drugBgStart,
        foregroundColor: _drugGold,
        title: Text(AppLocalizations.of(context)!.drugsHubTitle),
      ),
      body: painted,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return GamePageInfoHost(
      topicId: 'drugs',
      showOverlay: false,
      child: _shell(child: _buildBody(t)),
    );
  }
}

class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.child});

  final Widget child;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

class _PinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  _PinnedTabBarDelegate({
    required this.tabBar,
    required this.background,
  });

  final TabBar tabBar;
  final Color background;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: background,
      elevation: overlapsContent ? 2 : 0,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || background != oldDelegate.background;
  }
}
