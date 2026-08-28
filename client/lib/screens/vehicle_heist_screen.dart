import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehicle.dart';
import '../providers/auth_provider.dart';
import '../providers/vehicle_provider.dart';
import '../services/api_client.dart';
import '../services/jail_service.dart';
import '../services/theft_cooldown_credit_service.dart';
import '../utils/formatters.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/top_right_notification.dart';
import '../l10n/app_localizations.dart';
import '../widgets/jail_screen.dart';
import '../widgets/stolen_vehicle_dialog.dart';
import '../widgets/theft_cooldown_credit_flow.dart';
import '../widgets/theft_cooldown_steal_control.dart';
import '../widgets/vehicle_catalog_dialog.dart';
import 'events_screen.dart';
import 'garage_screen.dart';
import 'marina_screen.dart';

class VehicleHeistScreen extends StatefulWidget {
  const VehicleHeistScreen({
    super.key,
    this.initialTabIndex = 0,
    this.embedded = false,
    this.onOpenEvents,
  });

  final int initialTabIndex;
  final bool embedded;

  /// When set (e.g. web dashboard), opens the live events section.
  final VoidCallback? onOpenEvents;

  @override
  State<VehicleHeistScreen> createState() => _VehicleHeistScreenState();
}

class _VehicleHeistScreenState extends State<VehicleHeistScreen>
    with SingleTickerProviderStateMixin {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);
  static const Color _vehicleAccent = Color(0xFFF0A04B);

  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();
  late final TabController _tabController;
  int _activeTabIndex = 0;
  bool _opsActionInProgress = false;
  bool _laneActionInProgress = false;
  Timer? _opsTicker;
  DateTime? _opsLastRefreshAt;
  final Map<String, Map<String, int>> _laneCapacities = {};
  int? _embeddedJailSeconds;
  bool _showStealResult = false;
  bool _stealResultSuccess = false;
  String _stealResultTitle = '';
  String? _stealResultMessage;
  int _stealResultXp = 0;
  VehicleInventoryItem? _stealResultVehicle;
  int _jailContentEpoch = 0;
  final Map<int, int> _stealCreditHintByTab = {};
  bool _opsPanelExpanded = false;
  Map<String, dynamic>? _liveVehicleEvent;
  Map<String, dynamic>? _liveVehicleEventProgress;
  DateTime _eventNow = DateTime.now();

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
        // Keep ops collapsed by default when switching vehicle type.
        if (_opsPanelExpanded) {
          setState(() => _opsPanelExpanded = false);
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshOpsIntelligence();
      _refreshLaneCapacities();
      _loadLiveVehicleEvent();
      if (widget.embedded) {
        unawaited(_refreshEmbeddedJailStatus());
      }
    });
    _opsTicker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (timer.tick % 15 == 0 && !_opsActionInProgress) {
        _refreshOpsIntelligence();
      }
      if (widget.embedded && timer.tick % 30 == 0) {
        unawaited(_refreshEmbeddedJailStatus());
      }
      setState(() => _eventNow = DateTime.now());
    });
  }

  @override
  void dispose() {
    _opsTicker?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLiveVehicleEvent() async {
    try {
      final response = await _apiClient.get('/game-events/overview');
      if (response.statusCode != 200 || !mounted) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final activeList = ((data['active'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      final progressList = ((data['myProgress'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      Map<String, dynamic>? vehicleEvent;
      for (final event in activeList) {
        final template = event['template'] is Map
            ? Map<String, dynamic>.from(event['template'] as Map)
            : null;
        if (template?['key']?.toString() == 'weekly_vehicle_theft_hunt') {
          vehicleEvent = event;
          break;
        }
      }

      Map<String, dynamic>? progress;
      if (vehicleEvent != null) {
        final eventId = (vehicleEvent['id'] as num?)?.toInt();
        if (eventId != null) {
          for (final item in progressList) {
            if ((item['liveEventId'] as num?)?.toInt() == eventId) {
              progress = item;
              break;
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _liveVehicleEvent = vehicleEvent;
        _liveVehicleEventProgress = progress;
      });
    } catch (_) {
      // Non-blocking — heist screen works without event data.
    }
  }

  void _openEvents() {
    if (widget.onOpenEvents != null) {
      widget.onOpenEvents!();
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EventsScreen()),
    );
  }

  String _formatEventCountdown(DateTime? endsAt, AppLocalizations l10n) {
    if (endsAt == null) return l10n.gameScreenDash;
    final diff = endsAt.difference(_eventNow);
    if (diff.inSeconds <= 0) return l10n.gameScreenCountdownNow;
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Widget _buildPageHero(AppLocalizations l10n, VehicleProvider provider) {
    final totalOwned = provider.inventory.length;
    final carCount = _countForTab(provider, 0);
    final motorCount = _countForTab(provider, 1);
    final boatCount = _countForTab(provider, 2);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3A2814).withValues(alpha: 0.95),
            _panelBg.withValues(alpha: 0.95),
          ],
        ),
        border: Border.all(color: _gold.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _vehicleAccent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _vehicleAccent.withValues(alpha: 0.45),
                  ),
                ),
                child: const Icon(
                  Icons.directions_car_filled,
                  color: _vehicleAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.vehicleHeistTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.vehicleHeistHeroSubtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
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
                label: Text(l10n.catalog),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _gold,
                  side: BorderSide(color: _gold.withValues(alpha: 0.45)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip('$totalOwned ${l10n.vehicles.toLowerCase()}', _gold),
              _statChip('${l10n.car} $carCount', _tabAccentColor(0)),
              _statChip('${l10n.motorcycle} $motorCount', _tabAccentColor(1)),
              _statChip('${l10n.boat} $boatCount', _tabAccentColor(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildLiveEventBanner(AppLocalizations l10n) {
    final event = _liveVehicleEvent;
    if (event == null) return const SizedBox.shrink();

    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final title = localizedGameEventTitle(l10n, template);
    final endsAt =
        DateTime.tryParse(event['endsAt']?.toString() ?? '')?.toLocal();
    final score = (_liveVehicleEventProgress?['score'] as num?)?.toDouble();
    final rank = (_liveVehicleEventProgress?['rank'] as num?)?.toInt();
    final scoreLabel = score == null
        ? l10n.gameScreenDash
        : score.toStringAsFixed(0);
    final rankLabel =
        rank == null ? l10n.gameScreenDash : rank.toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _openEvents,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  _vehicleAccent.withValues(alpha: 0.28),
                  const Color(0xFF1A1210),
                ],
              ),
              border: Border.all(
                color: _vehicleAccent.withValues(alpha: 0.55),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.emoji_events, color: _gold, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.vehicleHeistLiveEventActive(title),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.vehicleHeistLiveEventProgress(
                    scoreLabel,
                    rankLabel,
                    _formatEventCountdown(endsAt, l10n),
                  ),
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.vehicleHeistOpenEvents,
                  style: TextStyle(
                    color: _gold.withValues(alpha: 0.85),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabQuickSelect(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(3, (index) {
          final accent = _tabAccentColor(index);
          final isActive = _activeTabIndex == index;
          return ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_tabIcon(index), size: 16, color: isActive ? accent : Colors.white70),
                const SizedBox(width: 6),
                Text(_tabTitle(l10n, index)),
              ],
            ),
            selected: isActive,
            onSelected: (_) => _tabController.animateTo(index),
            selectedColor: accent.withValues(alpha: 0.22),
            labelStyle: TextStyle(
              color: isActive ? accent : Colors.white70,
              fontWeight: FontWeight.w700,
            ),
            side: BorderSide(
              color: isActive
                  ? accent.withValues(alpha: 0.65)
                  : _panelBorder,
            ),
          );
        }),
      ),
    );
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

  String _tabTitle(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.car;
      case 1:
        return l10n.motorcycle;
      case 2:
        return l10n.boat;
      default:
        return '';
    }
  }

  String _tabSubtitle(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.vehicleHeistTabSubtitleCar;
      case 1:
        return l10n.vehicleHeistTabSubtitleMotorcycle;
      case 2:
        return l10n.vehicleHeistTabSubtitleBoat;
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

  /// API / subscription `cooldownActionType` for steal cooldown credit reset.
  String _cooldownActionTypeForTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return 'motorcycle_theft';
      case 2:
        return 'boat_theft';
      case 0:
      default:
        return 'vehicle_theft';
    }
  }

  void _prefetchStealCreditHint(int tabIndex) {
    if (_stealCreditHintByTab.containsKey(tabIndex)) return;
    Future<void> load() async {
      final info = await TheftCooldownCreditService.load(
        _cooldownActionTypeForTab(tabIndex),
      );
      if (!mounted || info == null || info.creditCost <= 0) return;
      setState(() {
        _stealCreditHintByTab[tabIndex] = info.creditCost;
      });
    }
    load();
  }

  String _boltTooltipForLane(int tabIndex) {
    final l10n = AppLocalizations.of(context)!;
    final c = _stealCreditHintByTab[tabIndex];
    if (c != null && c > 0) {
      return l10n.vehicleHeistSpeedUpWithCredits(c.toString());
    }
    return l10n.vehicleHeistSpeedUpWithCreditsNextScreen;
  }

  Future<void> _redeemStealCooldownWithCredits(
    VehicleProvider provider,
    int tabIndex,
  ) async {
    if (!mounted) return;
    final action = _cooldownActionTypeForTab(tabIndex);
    await runTheftCooldownCreditRedeem(
      context,
      cooldownActionType: action,
      onAfterSuccess: () async {
        if (!mounted) return;
        await _refreshOpsIntelligence();
        await _refreshLaneCapacities();
        final auth = context.read<AuthProvider>();
        await auth.refreshPlayer();
        if (!mounted) return;
        await provider.fetchInventory();
        final country = auth.currentPlayer?.currentCountry ?? 'netherlands';
        final vehicleType = _opsVehicleTypeForTab(tabIndex);
        if (tabIndex == 2) {
          await provider.fetchMarinaStatus(country);
        } else {
          await provider.fetchGarageStatus(
            country,
            vehicleType: vehicleType,
          );
        }
      },
    );
  }

  Future<void> _refreshOpsIntelligence() async {
    if (!mounted) return;
    final provider = context.read<VehicleProvider>();
    await provider.fetchVehicleOpsIntelligence(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    if (!mounted) return;
    setState(() {
      _opsLastRefreshAt = DateTime.now();
    });
  }

  Future<void> _refreshLaneCapacities() async {
    final authProvider = context.read<AuthProvider>();
    final country = authProvider.currentPlayer?.currentCountry ?? 'netherlands';
    final updated = <String, Map<String, int>>{};

    Future<void> loadGarageType(String type) async {
      final response = await _apiClient.get(
        '/garage/status/$country?vehicleType=$type',
      );
      if (response.statusCode != 200) return;
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final status = (payload['status'] as Map<String, dynamic>? ?? const {});
      updated[type] = {
        'stored': (status['capacity'] as num?)?.toInt() ?? 0,
        'total': (status['totalCapacity'] as num?)?.toInt() ?? 0,
        'level': (status['currentUpgradeLevel'] as num?)?.toInt() ?? 0,
        'nextRank': (status['nextUpgradeRequiredRank'] as num?)?.toInt() ?? 0,
      };
    }

    Future<void> loadMarina() async {
      final response = await _apiClient.get('/garage/marina/status/$country');
      if (response.statusCode != 200) return;
      final payload = jsonDecode(response.body) as Map<String, dynamic>;
      final status = (payload['status'] as Map<String, dynamic>? ?? const {});
      updated['boat'] = {
        'stored': (status['capacity'] as num?)?.toInt() ?? 0,
        'total': (status['totalCapacity'] as num?)?.toInt() ?? 0,
        'level': (status['currentUpgradeLevel'] as num?)?.toInt() ?? 0,
        'nextRank': (status['nextUpgradeRequiredRank'] as num?)?.toInt() ?? 0,
      };
    }

    try {
      await loadGarageType('car');
      await loadGarageType('motorcycle');
      await loadMarina();
    } catch (_) {
      // Keep UI usable when one of the status calls fails temporarily.
    }

    if (!mounted || updated.isEmpty) return;
    setState(() {
      _laneCapacities
        ..clear()
        ..addAll(updated);
    });
  }

  /// When embedded in the dashboard, [JailOverlay] must live here — not inside
  /// the tab [NestedScrollView] body — or it appears below the ops header slivers.
  Future<void> _refreshEmbeddedJailStatus() async {
    if (!widget.embedded) return;
    final jailTime = await _jailService.checkJailStatus();
    if (!mounted) return;
    if (jailTime > 0) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.refreshPlayer();
      if (!mounted) return;
      setState(() {
        _embeddedJailSeconds = jailTime;
      });
      return;
    }
    if (_embeddedJailSeconds != null) {
      setState(() {
        _embeddedJailSeconds = null;
      });
    }
  }

  int _liveCooldownSeconds(dynamic rawSeconds) {
    final base = (rawSeconds as num?)?.toInt() ?? 0;
    if (base <= 0) return 0;
    final refreshedAt = _opsLastRefreshAt;
    if (refreshedAt == null) return base;
    final elapsed = DateTime.now().difference(refreshedAt).inSeconds;
    return math.max(0, base - elapsed);
  }

  int _liveStealCooldownForOperationLane(VehicleProvider provider, int tabIndex) {
    final type = _opsVehicleTypeForTab(tabIndex);
    final intel = provider.vehicleOpsIntelligence;
    final map = intel?['laneTheftCooldowns'] as Map<String, dynamic>?;
    final fromIntel =
        map == null ? 0 : _liveCooldownSeconds(map[type]);
    final fromLastAttempt = provider.liveTheftCooldownSecondsForType(type);
    return math.max(fromIntel, fromLastAttempt);
  }

  String _formatCooldown(int seconds) {
    final l10n = AppLocalizations.of(context)!;
    if (seconds <= 0) return l10n.vehicleHeistReady;
    return formatAdaptiveDurationFromSeconds(
      seconds,
      localeName: l10n.localeName,
    );
  }

  void _showTopMessage(String message, {bool success = false}) {
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
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
    final l10n = AppLocalizations.of(context)!;
    switch (tabIndex) {
      case 0:
        return l10n.garage;
      case 1:
        return l10n.vehicleHeistMotorStorage;
      case 2:
      default:
        return l10n.marina;
    }
  }

  String _capacityPolicyForTab(int tabIndex) {
    final l10n = AppLocalizations.of(context)!;
    switch (tabIndex) {
      case 0:
        return l10n.vehicleHeistCapacityPolicyCar;
      case 1:
        return l10n.vehicleHeistCapacityPolicyMotorcycle;
      case 2:
      default:
        return l10n.vehicleHeistCapacityPolicyBoat;
    }
  }

  int _upgradeCostForTab(int tabIndex, VehicleProvider provider) {
    final costsGarage = [50000, 100000, 200000, 400000, 800000];
    final costsMarina = [75000, 150000, 300000, 600000, 1200000];
    final type = _opsVehicleTypeForTab(tabIndex);
    final cached = _laneCapacities[type];
    final fallbackLevel = tabIndex == 2
        ? (provider.marinaStatus?.currentUpgradeLevel ?? 0)
        : (provider.garageStatus?.currentUpgradeLevel ?? 0);
    final currentLevel = cached?['level'] ?? fallbackLevel;
    if (tabIndex == 2) {
      return currentLevel < costsMarina.length ? costsMarina[currentLevel] : 0;
    }
    return currentLevel < costsGarage.length ? costsGarage[currentLevel] : 0;
  }

  Future<void> _runTileSteal(VehicleProvider provider, int tabIndex) async {
    if (_laneActionInProgress) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _laneActionInProgress = true;
      if (_activeTabIndex != tabIndex) {
        _activeTabIndex = tabIndex;
        _tabController.animateTo(tabIndex);
      }
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final country =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';
      final vehicleType = _opsVehicleTypeForTab(tabIndex);
      final success = await provider.stealVehicle(country, vehicleType);
      // Snapshot: fetch ops intel + fetchInventory clear provider.error before we can show it.
      final stealError = provider.error;
      final stealCooldown = provider.lastStealCooldownRemainingSeconds;
      final stealArrested = provider.lastStealArrested;
      final stealJail = provider.lastStealJailMinutes;
      final stolenVehicle = provider.lastStolenVehicle;
      final stealXpGained = provider.lastStealXpGained;
      final lock = provider.regionalBlacklistForType(vehicleType);
      final lockActive = lock?['active'] == true;
      final lockReasonNl = lock?['reasonNl']?.toString();
      final lockReasonEn = lock?['reasonEn']?.toString();
      final lockEndsAt = lock?['endsAt']?.toString();

      if (!mounted) return;
      await _refreshOpsIntelligence();
      await authProvider.refreshPlayer();
      await provider.fetchInventory();

      if (tabIndex == 2) {
        await provider.fetchMarinaStatus(country);
      } else {
        await provider.fetchGarageStatus(country, vehicleType: vehicleType);
      }
      await _refreshLaneCapacities();

      if (!mounted) return;

      // Embedded dashboard: JailOverlay lives on this screen (garage/marina use
      // suppressJailOverlay). Refresh immediately after steal; polling alone can
      // leave players jailed with no overlay for up to ~30s.
      if (widget.embedded) {
        await _refreshEmbeddedJailStatus();
        if (mounted &&
            stealArrested &&
            stealJail > 0 &&
            (_embeddedJailSeconds == null || _embeddedJailSeconds! <= 0)) {
          setState(() {
            _embeddedJailSeconds = stealJail * 60;
          });
        }
      }

      if (!mounted) return;

      final typeLabel = switch (vehicleType) {
        'motorcycle' => l10n.motorcycle,
        'boat' => l10n.vehicleTypeBoat,
        _ => l10n.vehicleTypeCar,
      };

      if (success) {
        unawaited(_loadLiveVehicleEvent());
        final vehicleName = stolenVehicle?.definition?.name ??
            l10n.vehicleHeistGenericVehicle;
        setState(() {
          _showStealResult = true;
          _stealResultSuccess = true;
          _stealResultTitle = vehicleName;
          _stealResultMessage = l10n.vehicleHeistSuccessStolen(vehicleName);
          _stealResultXp = stealXpGained;
          _stealResultVehicle = stolenVehicle;
        });
      } else if (stealArrested) {
        setState(() {
          _showStealResult = true;
          _stealResultSuccess = false;
          _stealResultTitle = typeLabel;
          _stealResultMessage =
              l10n.vehicleHeistArrested(stealJail.toString());
          _stealResultXp = 0;
          _stealResultVehicle = null;
        });
      } else if (stealCooldown > 0) {
        setState(() {
          _showStealResult = true;
          _stealResultSuccess = false;
          _stealResultTitle = typeLabel;
          _stealResultMessage = stealError ??
              l10n.vehicleHeistCooldownActive(_formatCooldown(stealCooldown));
          _stealResultXp = 0;
          _stealResultVehicle = null;
        });
      } else if (lockActive) {
        final ends = DateTime.tryParse(lockEndsAt ?? '');
        final endsSuffix = ends == null
            ? ''
            : ' (${l10n.vehicleHeistUntil} ${formatAdaptiveDurationFromSeconds(
                ends.difference(DateTime.now().toUtc()).inSeconds.clamp(0, 999999),
                localeName: l10n.localeName,
              )})';
        setState(() {
          _showStealResult = true;
          _stealResultSuccess = false;
          _stealResultTitle = typeLabel;
          _stealResultMessage = (l10n.localeName.startsWith('nl')
                  ? (lockReasonNl ?? l10n.vehicleHeistRegionalLockActive)
                  : (lockReasonEn ?? l10n.vehicleHeistRegionalLockActive)) +
              endsSuffix;
          _stealResultXp = 0;
          _stealResultVehicle = null;
        });
      } else {
        setState(() {
          _showStealResult = true;
          _stealResultSuccess = false;
          _stealResultTitle = typeLabel;
          _stealResultMessage = stealError ?? l10n.vehicleHeistStealFailed;
          _stealResultXp = 0;
          _stealResultVehicle = null;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _laneActionInProgress = false;
        });
      }
    }
  }

  Future<void> _runTileUpgrade(VehicleProvider provider, int tabIndex) async {
    if (_laneActionInProgress) return;
    setState(() {
      _laneActionInProgress = true;
      if (_activeTabIndex != tabIndex) {
        _activeTabIndex = tabIndex;
        _tabController.animateTo(tabIndex);
      }
    });
    try {
      final authProvider = context.read<AuthProvider>();
      final country =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';
      final success = tabIndex == 2
          ? await provider.upgradeMarina(country)
          : await provider.upgradeGarage(
              country,
              garageTrack: tabIndex == 1 ? 'motorcycle' : 'car',
            );
      if (success) {
        if (tabIndex == 2) {
          await provider.fetchMarinaStatus(country);
        } else {
          await provider.fetchGarageStatus(
            country,
            vehicleType: _opsVehicleTypeForTab(tabIndex),
          );
        }
      }

      if (_activeTabIndex == tabIndex) {
        await _refreshOpsIntelligence();
      }
      await _refreshLaneCapacities();

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      _showTopMessage(
        success
            ? (l10n?.vehicleHeistUpgradeCompleted ?? 'Upgrade completed.')
            : (provider.error ??
                (l10n?.vehicleHeistUpgradeFailed ?? 'Upgrade failed.')),
        success: success,
      );
    } finally {
      if (mounted) {
        setState(() {
          _laneActionInProgress = false;
        });
      }
    }
  }

  Future<void> _showCatalogForActiveTab(VehicleProvider provider) async {
    final authProvider = context.read<AuthProvider>();
    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';
    final category = _catalogCategoryForTab(_activeTabIndex);
    final l10n = AppLocalizations.of(context)!;

    await provider.fetchStealableCatalog(category: category);
    if (!mounted) return;

    final title = _activeTabIndex == 0
        ? l10n.vehicleHeistCatalogTitleCars
        : _activeTabIndex == 1
        ? l10n.vehicleHeistCatalogTitleMotorcycles
        : l10n.vehicleHeistCatalogTitleBoats;

    await showVehicleCatalogDialog(
      context,
      title: title,
      vehicles: provider.availableVehicles,
      currentCountry: currentCountry,
    );
  }

  Widget _buildTabContent() {
    final epoch = _jailContentEpoch.toString();
    switch (_activeTabIndex) {
      case 0:
        return GarageScreen(
          key: ValueKey<String>('vehicle-tab-car-$epoch'),
          embedded: true,
          vehicleType: 'car',
          hideEmbeddedHeaderActions: true,
          hideEmbeddedCapacityHeader: true,
          suppressJailOverlay: widget.embedded,
        );
      case 1:
        return GarageScreen(
          key: ValueKey<String>('vehicle-tab-motorcycle-$epoch'),
          embedded: true,
          vehicleType: 'motorcycle',
          hideEmbeddedHeaderActions: true,
          hideEmbeddedCapacityHeader: true,
          suppressJailOverlay: widget.embedded,
        );
      case 2:
      default:
        return MarinaScreen(
          key: ValueKey<String>('vehicle-tab-boat-$epoch'),
          embedded: true,
          hideEmbeddedHeaderActions: true,
          hideEmbeddedCapacityHeader: true,
          suppressJailOverlay: widget.embedded,
        );
    }
  }

  Widget _buildOperationLaneCard(VehicleProvider provider, int tabIndex) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _tabAccentColor(tabIndex);
    final isActive = _activeTabIndex == tabIndex;
    final count = _countForTab(provider, tabIndex);
    final requiredRank = _requiredRankForTab(tabIndex);
    final laneType = _opsVehicleTypeForTab(tabIndex);
    final stealRemaining = _liveStealCooldownForOperationLane(provider, tabIndex);
    final cap = _laneCapacities[laneType];
    final storedCap = cap?['stored'] ?? 0;
    final totalCap = cap?['total'] ?? 0;
    final laneLevel = cap?['level'] ?? 0;
    final nextUpgradeRank = cap?['nextRank'] ?? 0;
    final playerRank = context.read<AuthProvider>().currentPlayer?.rank ?? 1;
    final upgradeLockedByRank = laneLevel < 5 && nextUpgradeRank > 0 && playerRank < nextUpgradeRank;

    if (stealRemaining > 0) {
      if (!_stealCreditHintByTab.containsKey(tabIndex)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _prefetchStealCreditHint(tabIndex);
        });
      }
    } else if (_stealCreditHintByTab.containsKey(tabIndex)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => _stealCreditHintByTab.remove(tabIndex));
        }
      });
    }

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
                      _tabTitle(l10n, tabIndex),
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
                _tabSubtitle(l10n, tabIndex),
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
                      l10n.vehicleHeistRankRequired(requiredRank.toString()),
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
              const SizedBox(height: 6),
              Text(
                l10n.vehicleHeistCapacityLine(
                  storedCap.toString(),
                  totalCap.toString(),
                  laneLevel.toString(),
                ),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TheftCooldownStealControl(
                    cooldownActive: stealRemaining > 0,
                    actionInProgress: _laneActionInProgress,
                    foregroundColor: accent,
                    borderColor: accent,
                    leadingIcon: stealRemaining > 0
                        ? Icons.timer
                        : (tabIndex == 2
                            ? Icons.sailing
                            : Icons.local_police),
                    label: stealRemaining > 0
                        ? _formatCooldown(stealRemaining)
                        : (tabIndex == 2
                            ? l10n.vehicleHeistStealBoat
                            : tabIndex == 1
                            ? l10n.vehicleHeistStealMotorcycle
                            : l10n.vehicleHeistStealCar),
                    onSteal: () => _runTileSteal(provider, tabIndex),
                    onCreditRedeem: () => _redeemStealCooldownWithCredits(
                      provider,
                      tabIndex,
                    ),
                    boltTooltip: _boltTooltipForLane(tabIndex),
                    compact: true,
                    iconSize: 14,
                  ),
                  if (laneLevel < 5 && !upgradeLockedByRank)
                    OutlinedButton.icon(
                      onPressed: _laneActionInProgress
                          ? null
                          : () => _runTileUpgrade(provider, tabIndex),
                      icon: const Icon(Icons.upgrade, size: 14),
                      label: Text(
                        l10n.vehicleHeistUpgradeCost(
                          _upgradeCostForTab(tabIndex, provider).toString(),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.amber.shade200,
                        side: BorderSide(color: Colors.amber.shade400),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  if (laneLevel < 5 && upgradeLockedByRank)
                    Tooltip(
                      message: l10n.vehicleHeistUpgradeRankRequired(
                        nextUpgradeRank.toString(),
                      ),
                      child: OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.lock, size: 14),
                        label: Text(
                          l10n.vehicleHeistUpgradeLocked,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Colors.grey),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                ],
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

  Widget _buildOpsActionInfoCard({
    required IconData icon,
    required String title,
    required String payout,
    required int cooldownSeconds,
    String? requirement,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final ready = cooldownSeconds <= 0;
    return Container(
      width: 210,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 15,
                color: ready ? Colors.lightGreen : Colors.white70,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            payout,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            '${l10n.cooldown}: ${_formatCooldown(cooldownSeconds)}',
            style: TextStyle(
              color: ready ? Colors.lightGreenAccent : Colors.orangeAccent,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (requirement != null && requirement.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              requirement,
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _runHotspotOp(VehicleProvider provider) async {
    if (_opsActionInProgress) return;
    final l10n = AppLocalizations.of(context)!;
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
        l10n.vehicleHeistOpsHotspotSuccess(formatCurrency(reward)),
        success: true,
      );
    } else {
      final reason = params['message']?.toString() ?? 'FAILED';
      if (reason == 'HOTSPOT_COOLDOWN') {
        final sec = (params['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
        _showTopMessage(
          l10n.vehicleHeistOpsHotspotCooldownActive(
            formatAdaptiveDurationFromSeconds(sec, localeName: l10n.localeName),
          ),
        );
      } else {
        _showTopMessage(
          l10n.vehicleHeistOpsHotspotFailedHeatIncreased,
        );
      }
    }
  }

  Future<void> _runCrewOp(VehicleProvider provider) async {
    if (_opsActionInProgress) return;
    final l10n = AppLocalizations.of(context)!;
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
      _showTopMessage(
        l10n.vehicleHeistOpsCrewSuccess(
            formatCurrency(personal),
        ),
        success: true,
      );
      return;
    }
    final reason = params['message']?.toString() ?? 'FAILED';
    if (reason == 'CREW_REQUIRED') {
      _showTopMessage(
        l10n.vehicleHeistOpsCrewRequired,
      );
    } else if (reason == 'CREW_OP_COOLDOWN') {
      final sec = (params['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        l10n.vehicleHeistOpsCrewCooldownActive(
          formatAdaptiveDurationFromSeconds(sec, localeName: l10n.localeName),
        ),
      );
    } else {
      _showTopMessage(l10n.vehicleHeistOpsCrewFailed);
    }
  }

  Future<void> _buyOpsParts(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final partsType = _opsVehicleTypeForTab(_activeTabIndex);
    final qtyController = TextEditingController(text: '5');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.vehicleHeistOpsBuyPartsTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.vehicleHeistOpsBuyPartsPrompt(partsType),
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
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.buy),
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
        l10n.vehicleHeistOpsPartsPurchased(formatCurrency(totalCost)),
        success: true,
      );
      return;
    }
    _showTopMessage(
      l10n.vehicleHeistOpsPartsPurchaseFailed,
    );
  }

  Future<void> _claimChopContract(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await provider.claimVehicleChopContract(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    final success = result['success'] == true;
    if (success) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        l10n.vehicleHeistOpsChopContractCompleted(formatCurrency(reward)),
        success: true,
      );
      return;
    }
    final reason = params['message']?.toString() ?? 'FAILED';
    if (reason == 'NO_ELIGIBLE_VEHICLE') {
      _showTopMessage(
        l10n.vehicleHeistOpsChopNoEligibleVehicle,
      );
    } else if (reason == 'CHOP_CONTRACT_COOLDOWN') {
      final sec = (params['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        l10n.vehicleHeistOpsChopContractCooldownActive(
          formatAdaptiveDurationFromSeconds(sec, localeName: l10n.localeName),
        ),
      );
    } else {
      _showTopMessage(l10n.vehicleHeistOpsChopContractClaimFailed);
    }
  }

  Future<void> _purchaseInsurance(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.vehicleHeistOpsInsuranceTitle),
        content: Text(
          l10n.vehicleHeistOpsInsuranceBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop('basic'),
            child: Text(l10n.vehicleHeistOpsInsuranceTierBasic),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop('pro'),
            child: Text(l10n.vehicleHeistOpsInsuranceTierPro),
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
        l10n.vehicleHeistOpsInsuranceActive(
          choice.toUpperCase(),
          formatCurrency(price),
        ),
        success: true,
      );
      return;
    }
    _showTopMessage(
      l10n.vehicleHeistOpsInsurancePurchaseFailed,
    );
  }

  Future<void> _runCrewMatch(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await provider.runVehicleCrewMatch(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      final msg = (params['message']?.toString() == 'CREW_MATCH_WON')
          ? l10n.vehicleHeistOpsCrewMatchWon(formatCurrency(reward))
          : l10n.vehicleHeistOpsCrewMatchLost(formatCurrency(reward));
      _showTopMessage(msg, success: true);
      return;
    }
    _showTopMessage(
      l10n.vehicleHeistOpsCrewMatchFailed,
    );
  }

  Future<void> _runCounterIntercept(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await provider.runVehicleCounterIntercept(
      vehicleType: _opsVehicleTypeForTab(_activeTabIndex),
    );
    final params = (result['params'] as Map<String, dynamic>? ?? const {});
    if (result['success'] == true) {
      final reward = (params['rewardMoney'] as num?)?.toInt() ?? 0;
      _showTopMessage(
        l10n.vehicleHeistOpsCounterSuccess(formatCurrency(reward)),
        success: true,
      );
      return;
    }
    _showTopMessage(
      l10n.vehicleHeistOpsCounterFailed,
    );
  }

  Future<void> _runOpsContract(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
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
        l10n.vehicleHeistOpsContractCompleted(formatCurrency(reward)),
        success: true,
      );
      return;
    }
    _showTopMessage(
      l10n.vehicleHeistOpsContractFailedOrCooldown,
    );
  }

  Future<void> _resolveInsuranceClaim(VehicleProvider provider) async {
    final l10n = AppLocalizations.of(context)!;
    final intel = provider.vehicleOpsIntelligence;
    final insurance =
        (intel?['contrabandInsurance'] as Map<String, dynamic>?) ?? const {};
    final claims = (insurance['openClaims'] as List<dynamic>? ?? const []);
    if (claims.isEmpty || claims.first is! Map<String, dynamic>) {
      _showTopMessage(
        l10n.vehicleHeistOpsNoOpenClaims,
      );
      return;
    }
    final claimId =
        ((claims.first as Map<String, dynamic>)['id'] as num?)?.toInt() ?? 0;
    if (claimId <= 0) {
      _showTopMessage(
        l10n.vehicleHeistOpsNoValidClaimFound,
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
          ? l10n.vehicleHeistOpsClaimApproved(formatCurrency(bonus))
          : l10n.vehicleHeistOpsClaimRejected(formatCurrency(fine));
      _showTopMessage(message, success: bonus > 0);
      return;
    }
    _showTopMessage(
      l10n.vehicleHeistOpsClaimResolutionFailed,
    );
  }

  Widget _buildOpsIntelligencePanel(VehicleProvider provider) {
    final l10n = AppLocalizations.of(context)!;
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
    final contractsBoard =
        (intel?['contractsBoard'] as Map<String, dynamic>?) ?? const {};
    final crewMatchmaking =
        (intel?['crewMatchmaking'] as Map<String, dynamic>?) ?? const {};
    final counterIntercept =
        (intel?['counterIntercept'] as Map<String, dynamic>?) ?? const {};
    final hotspots = (intel?['hotspots'] as List<dynamic>? ?? const []);
    final hotspot =
        hotspots.isNotEmpty && hotspots.first is Map<String, dynamic>
        ? hotspots.first as Map<String, dynamic>
        : const <String, dynamic>{};
    final isLoading = provider.vehicleOpsLoading;
    final hasCrew = crewOp['available'] == true;
    final hotspotCooldown = _liveCooldownSeconds(
      hotspot['cooldownRemainingSeconds'],
    );
    final crewCooldown = _liveCooldownSeconds(
      crewOp['cooldownRemainingSeconds'],
    );
    final chopCooldown = _liveCooldownSeconds(chop['cooldownRemainingSeconds']);
    final contractCooldown = _liveCooldownSeconds(
      contractsBoard['cooldownRemainingSeconds'],
    );
    final crewMatchCooldown = _liveCooldownSeconds(
      crewMatchmaking['cooldownRemainingSeconds'],
    );
    final counterCooldown = _liveCooldownSeconds(
      counterIntercept['cooldownRemainingSeconds'],
    );

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
                  l10n.vehicleHeistOpsIntelTitle,
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
                  tooltip: l10n.vehicleHeistOpsIntelRefreshTooltip,
                ),
              IconButton(
                onPressed: () {
                  setState(() => _opsPanelExpanded = !_opsPanelExpanded);
                },
                icon: Icon(
                  _opsPanelExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                tooltip: _opsPanelExpanded
                    ? l10n.vehicleHeistOpsHideDetails
                    : l10n.vehicleHeistOpsShowDetails,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildOpsPill(
                l10n.vehicleHeistOpsIntelHeatPill(
                  (heat['current'] ?? 0).toString(),
                  heatLevel,
                ),
                color: heatColor,
              ),
              _buildOpsPill(
                l10n.vehicleHeistOpsIntelPolicePill(
                  ((l10n.localeName.startsWith('nl') ? pattern['nameNl'] : pattern['nameEn']) ?? '-')
                      .toString(),
                ),
                color: Colors.lightBlueAccent,
              ),
              _buildOpsPill(
                l10n.vehicleHeistOpsIntelRepPill((rep['level'] ?? 0).toString()),
                color: Colors.purpleAccent,
              ),
              if (blacklist['active'] == true)
                _buildOpsPill(
                  l10n.vehicleOpsBlacklistActive,
                  color: Colors.redAccent,
                ),
              _buildOpsPill(
                l10n.vehicleHeistOpsIntelPartsMarketPill(
                  (partsMarket['trend'] ?? '-').toString(),
                ),
                color: Colors.cyanAccent,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.vehicleHeistOpsPrimaryActions,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed:
                    isLoading || _opsActionInProgress || hotspotCooldown > 0
                    ? null
                    : () => _runHotspotOp(provider),
                icon: const Icon(Icons.local_police, size: 16),
                label: Text(l10n.vehicleHeistOpsHotspotRunButton),
              ),
              OutlinedButton.icon(
                onPressed:
                    isLoading || _opsActionInProgress || chopCooldown > 0
                    ? null
                    : () => _claimChopContract(provider),
                icon: const Icon(Icons.build_circle, size: 16),
                label: Text(l10n.vehicleHeistOpsClaimContractButton),
              ),
              OutlinedButton.icon(
                onPressed: isLoading || _opsActionInProgress
                    ? null
                    : () => _buyOpsParts(provider),
                icon: const Icon(Icons.precision_manufacturing, size: 16),
                label: Text(l10n.vehicleHeistOpsBuyPartsButton),
              ),
              OutlinedButton.icon(
                onPressed:
                    isLoading || _opsActionInProgress || contractCooldown > 0
                    ? null
                    : () => _runOpsContract(provider),
                icon: const Icon(Icons.assignment_turned_in, size: 16),
                label: Text(l10n.vehicleHeistOpsOpsContractButton),
              ),
            ],
          ),
          if (!_opsPanelExpanded)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                l10n.vehicleHeistOpsIntelTapToExpand,
                style: const TextStyle(color: Colors.white54, fontSize: 11.5),
              ),
            ),
          if (_opsPanelExpanded) ...[
            const SizedBox(height: 10),
            Text(
              l10n.vehicleHeistOpsAdvancedActions,
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (hasCrew)
                  OutlinedButton.icon(
                    onPressed:
                        isLoading || _opsActionInProgress || crewCooldown > 0
                        ? null
                        : () => _runCrewOp(provider),
                    icon: const Icon(Icons.groups, size: 16),
                    label: Text(l10n.vehicleHeistOpsCrewOpButton),
                  ),
                OutlinedButton.icon(
                  onPressed: isLoading || _opsActionInProgress
                      ? null
                      : () => _purchaseInsurance(provider),
                  icon: const Icon(Icons.verified_user, size: 16),
                  label: Text(l10n.vehicleHeistOpsInsuranceButton),
                ),
                if (hasCrew)
                  OutlinedButton.icon(
                    onPressed:
                        isLoading ||
                            _opsActionInProgress ||
                            crewMatchCooldown > 0
                        ? null
                        : () => _runCrewMatch(provider),
                    icon: const Icon(Icons.emoji_events, size: 16),
                    label: Text(l10n.vehicleHeistOpsCrewMatchButton),
                  ),
                if (!hasCrew)
                  _buildOpsPill(
                    l10n.vehicleHeistOpsCrewJoinToUnlock,
                    color: Colors.amberAccent,
                  ),
                OutlinedButton.icon(
                  onPressed:
                      isLoading || _opsActionInProgress || counterCooldown > 0
                      ? null
                      : () => _runCounterIntercept(provider),
                  icon: const Icon(Icons.swap_horiz, size: 16),
                  label: Text(l10n.vehicleHeistOpsCounterButton),
                ),
                OutlinedButton.icon(
                  onPressed: isLoading || _opsActionInProgress
                      ? null
                      : () => _resolveInsuranceClaim(provider),
                  icon: const Icon(Icons.gavel, size: 16),
                  label: Text(l10n.vehicleHeistOpsClaimDisputeButton),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildOpsActionInfoCard(
                    icon: Icons.local_police,
                    title: l10n.vehicleHeistOpsHotspotRunTitle,
                    payout: l10n.vehicleHeistOpsIntelCashRangePayout(
                      formatCurrency(
                        (hotspot['rewardMin'] as num?)?.toInt() ?? 0,
                      ),
                      formatCurrency(
                        (hotspot['rewardMax'] as num?)?.toInt() ?? 0,
                      ),
                    ),
                    cooldownSeconds: hotspotCooldown,
                  ),
                  const SizedBox(width: 8),
                  _buildOpsActionInfoCard(
                    icon: Icons.groups,
                    title: l10n.vehicleHeistOpsCrewOpTitle,
                    payout: l10n.vehicleHeistOpsIntelYouCashRangePayout(
                      formatCurrency(
                        (crewOp['rewardPersonalMin'] as num?)?.toInt() ?? 0,
                      ),
                      formatCurrency(
                        (crewOp['rewardPersonalMax'] as num?)?.toInt() ?? 0,
                      ),
                    ),
                    cooldownSeconds: crewCooldown,
                    requirement: hasCrew
                        ? l10n.vehicleHeistOpsCrewRequiredYes
                        : l10n.vehicleHeistOpsCrewRequiredNoJoinFirst,
                  ),
                  const SizedBox(width: 8),
                  _buildOpsActionInfoCard(
                    icon: Icons.build_circle,
                    title: l10n.vehicleHeistOpsClaimContractTitle,
                    payout: l10n.vehicleHeistOpsIntelCashPayout(
                      formatCurrency(
                        (chop['rewardMoney'] as num?)?.toInt() ?? 0,
                      ),
                    ),
                    cooldownSeconds: chopCooldown,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vehicleHeistOpsIntelHotspotLine(
                ((l10n.localeName.startsWith('nl')
                            ? hotspot['nameNl']
                            : hotspot['nameEn']) ??
                        '-')
                    .toString(),
              ),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 12.5,
              ),
            ),
            Text(
              l10n.vehicleHeistOpsIntelPartsPricesLine(
                (prices['car'] ?? '-').toString(),
                (prices['motorcycle'] ?? '-').toString(),
                (prices['boat'] ?? '-').toString(),
              ),
              style: const TextStyle(color: Colors.white60, fontSize: 11.5),
            ),
            Text(
              l10n.vehicleHeistOpsIntelChopRewardLine(
                formatCurrency((chop['rewardMoney'] as num?)?.toInt() ?? 0),
              ),
              style: const TextStyle(color: Colors.white60, fontSize: 11.5),
            ),
            if (blacklist['active'] == true)
              Text(
                l10n.vehicleHeistOpsIntelBlacklistLine(
                  ((l10n.localeName.startsWith('nl')
                              ? blacklist['reasonNl']
                              : blacklist['reasonEn']) ??
                          '-')
                      .toString(),
                ),
                style: const TextStyle(color: Colors.redAccent, fontSize: 11.5),
              ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_showStealResult) {
      final result = VehicleTheftResultOverlay(
        embedded: widget.embedded,
        isSuccess: _stealResultSuccess,
        vehicle: _stealResultVehicle,
        title: _stealResultTitle.isNotEmpty
            ? _stealResultTitle
            : l10n.vehicleHeistTitle,
        message: _stealResultMessage,
        xpGained: _stealResultXp,
        onContinue: () {
          if (!mounted) return;
          setState(() {
            _showStealResult = false;
            _stealResultSuccess = false;
            _stealResultTitle = '';
            _stealResultMessage = null;
            _stealResultXp = 0;
            _stealResultVehicle = null;
          });
        },
      );
      return widget.embedded
          ? DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1210), Color(0xFF0C0A0A)],
                ),
              ),
              child: result,
            )
          : Scaffold(
              backgroundColor: const Color(0xFF0C0A0A),
              appBar: AppBar(title: Text(l10n.vehicleHeistTitle)),
              body: result,
            );
    }

    final content = Consumer<VehicleProvider>(
      builder: (context, provider, _) {
        final l10n = AppLocalizations.of(context)!;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final header = Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1A1210).withValues(alpha: 0.92),
                Colors.black.withValues(alpha: 0.55),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: Column(
              key: ValueKey<int>(_activeTabIndex),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPageHero(l10n, provider),
                _buildLiveEventBanner(l10n),
                _buildTabQuickSelect(l10n),
                Text(
                  _tabSubtitle(l10n, _activeTabIndex),
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
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
            key: ValueKey<String>('heist-tab-$_activeTabIndex-$_jailContentEpoch'),
            child: _buildTabContent(),
          ),
        );

        final mainBody = widget.embedded
            ? NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(child: header),
                  const SliverToBoxAdapter(child: Divider(height: 1)),
                ],
                body: tabBody,
              )
            : Column(
                children: [
                  header,
                  const Divider(height: 1),
                  Expanded(child: tabBody),
                ],
              );

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: mainBody),
            if (widget.embedded &&
                _embeddedJailSeconds != null &&
                _embeddedJailSeconds! > 0)
              Positioned.fill(
                child: JailOverlay(
                  remainingSeconds: _embeddedJailSeconds!,
                  wantedLevel: authProvider.currentPlayer?.wantedLevel,
                  embedded: true,
                  onReleased: () {
                    if (!mounted) return;
                    setState(() {
                      _embeddedJailSeconds = null;
                      _jailContentEpoch++;
                    });
                  },
                ),
              ),
          ],
        );
      },
    );

    return widget.embedded
        ? DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A1210), Color(0xFF0C0A0A)],
              ),
            ),
            child: content,
          )
        : Scaffold(
            backgroundColor: const Color(0xFF0C0A0A),
            appBar: AppBar(
              title: Text(l10n.vehicleHeistTitle),
            ),
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1210), Color(0xFF0C0A0A)],
                ),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/backgrounds/garage_background.png',
                  ),
                  fit: BoxFit.cover,
                  opacity: 0.18,
                ),
              ),
              child: content,
            ),
          );
  }
}
