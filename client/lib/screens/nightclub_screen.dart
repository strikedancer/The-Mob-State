import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../models/achievement.dart';
import '../models/drug_models.dart';
import '../models/property.dart';
import '../services/drug_service.dart';
import '../services/nightclub_service.dart';
import '../services/prostitution_service.dart';
import '../utils/achievement_notifier.dart';
import '../utils/top_right_notification.dart';

class NightclubScreen extends StatefulWidget {
  final Property? property;

  const NightclubScreen({super.key, this.property});

  @override
  State<NightclubScreen> createState() => _NightclubScreenState();
}

class _NightclubScreenState extends State<NightclubScreen>
    with TickerProviderStateMixin {
  final NightclubService _nightclubService = NightclubService();
  final DrugService _drugService = DrugService();
  final ProstitutionService _achievementService = ProstitutionService();

  Timer? _pollTimer;
  bool _loading = true;
  bool _autoRefresh = true;
  bool _initialAchievementCheckDone = false;
  int? _venueId;
  List<dynamic> _venues = const [];
  Map<String, dynamic>? _stats;
  List<dynamic> _djs = const [];
  List<dynamic> _guards = const [];
  List<dynamic> _availableProstitutes = const [];
  List<dynamic> _leaderboard = const [];
  Map<String, dynamic>? _seasonSummary;
  List<DrugInventory> _drugInventory = const [];
  final List<int> _revenueTrend = <int>[];
  String _leaderboardScope = 'country';

  int? _selectedDjId;
  int _djHours = 8;
  int? _selectedGuardId;
  int? _selectedProstituteId;
  String? _selectedDrugKey;
  int _storeQuantity = 10;
  late final TabController _managementTabController;
  late final TabController _insightTabController;

  List<Map<String, dynamic>> _storeDrugOptions() {
    final byKey = <String, Map<String, dynamic>>{};

    for (final item in _drugInventory.where((d) => d.quantity > 0)) {
      final key = '${item.drugType}:${item.quality}';
      final existing = byKey[key];
      if (existing == null) {
        byKey[key] = {
          'key': key,
          'drugName': item.drugName,
          'quality': item.quality,
          'quantity': item.quantity,
        };
      } else {
        existing['quantity'] = (existing['quantity'] as int) + item.quantity;
      }
    }

    final options = byKey.values.toList();
    options.sort((a, b) => (a['key'] as String).compareTo(b['key'] as String));
    return options;
  }

  String _l(String nl, String en) {
    return Localizations.localeOf(context).languageCode == 'nl' ? nl : en;
  }

  bool _isVipVariant(dynamic variantRaw) {
    final variant = (variantRaw as num?)?.toInt() ?? 0;
    return variant >= 6 && variant <= 10;
  }

  String _vipStatusLabel(dynamic variantRaw) {
    return _isVipVariant(variantRaw)
        ? _l('VIP', 'VIP')
        : _l('STANDAARD', 'STANDARD');
  }

  String _prostitutePortraitAsset(dynamic variantRaw) {
    const standard = <String>[
      'assets/images/prostitution/portraits/prostitute_asian_cheongsam.png',
      'assets/images/prostitution/portraits/prostitute_blonde_red_dress.png',
      'assets/images/prostitution/portraits/prostitute_brunette_black_lingerie.png',
      'assets/images/prostitution/portraits/prostitute_latina_green_dress.png',
      'assets/images/prostitution/portraits/prostitute_redhead_purple_latex.png',
    ];
    const vip = <String>[
      'assets/images/prostitution/vip_portraits/vip_prostitute_redcarpet_icon.png',
      'assets/images/prostitution/vip_portraits/vip_prostitute_velvet_executive.png',
      'assets/images/prostitution/vip_portraits/vip_prostitute_platinum_gala.png',
      'assets/images/prostitution/vip_portraits/vip_prostitute_emerald_penthouse.png',
      'assets/images/prostitution/vip_portraits/vip_prostitute_eastern_luxe.png',
    ];

    final variant = (variantRaw as num?)?.toInt() ?? 1;
    if (_isVipVariant(variant)) {
      final idx = ((variant - 6) % vip.length).clamp(0, vip.length - 1);
      return vip[idx];
    }

    final normalized = variant <= 0 ? 1 : variant;
    final idx = ((normalized - 1) % standard.length).clamp(
      0,
      standard.length - 1,
    );
    return standard[idx];
  }

  String? _drugImageAsset(String drugType) {
    const byType = <String, String>{
      'white_widow':
          'assets/images/achievements/badges/drugs/drug_white_widow_100.png',
      'cocaine': 'assets/images/achievements/badges/drugs/drug_cocaine_100.png',
      'heroin': 'assets/images/achievements/badges/drugs/drug_heroin_100.png',
      'speed': 'assets/images/achievements/badges/drugs/drug_speed_100.png',
      'og_kush': 'assets/images/achievements/badges/drugs/drug_og_kush_100.png',
      'amnesia_haze':
          'assets/images/achievements/badges/drugs/drug_amnesia_haze_100.png',
      'xtc': 'assets/images/achievements/badges/drugs/drug_xtc_100.png',
      'mdma': 'assets/images/achievements/badges/drugs/drug_xtc_100.png',
    };

    return byType[drugType.toLowerCase()];
  }

  Widget _thumbFromImageRef({
    String? imageRef,
    String? fallbackAsset,
    required IconData fallbackIcon,
    double size = 38,
  }) {
    final ref = imageRef?.trim() ?? '';

    Widget fallbackWidget() {
      if (fallbackAsset != null && fallbackAsset.isNotEmpty) {
        return Image.asset(
          fallbackAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: size,
            height: size,
            color: Colors.black26,
            child: Icon(fallbackIcon, size: size * 0.55),
          ),
        );
      }

      return Container(
        width: size,
        height: size,
        color: Colors.black26,
        child: Icon(fallbackIcon, size: size * 0.55),
      );
    }

    if (ref.startsWith('http://') || ref.startsWith('https://')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          ref,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallbackWidget(),
        ),
      );
    }

    if (ref.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          ref,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => fallbackWidget(),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: fallbackWidget(),
    );
  }

  Widget _dropdownItemLabel(String text) {
    final width = _isCompactLayout() ? 180.0 : 280.0;
    return SizedBox(
      width: width,
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  String _djNameById(int? djId) {
    if (djId == null) return _l('Onbekend', 'Unknown');
    for (final dj in _djs) {
      final map = dj as Map<String, dynamic>;
      if ((map['id'] as num?)?.toInt() == djId) {
        return (map['name'] ?? _l('Onbekend', 'Unknown')).toString();
      }
    }
    return _l('Onbekend', 'Unknown');
  }

  String _guardNameById(int? guardId) {
    if (guardId == null) return _l('Onbekend', 'Unknown');
    for (final guard in _guards) {
      final map = guard as Map<String, dynamic>;
      if ((map['id'] as num?)?.toInt() == guardId) {
        return (map['name'] ?? _l('Onbekend', 'Unknown')).toString();
      }
    }
    return _l('Onbekend', 'Unknown');
  }

  Map<String, dynamic>? _activeDjShift() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final active = data['activeDj'] as Map<String, dynamic>?;
    if (active != null) return active;
    final shifts = (data['djShifts'] as List<dynamic>?) ?? const [];
    final now = DateTime.now();

    for (final raw in shifts) {
      final shift = raw as Map<String, dynamic>;
      final end = DateTime.tryParse((shift['shiftEndAt'] ?? '').toString());
      if (end != null && end.isAfter(now)) {
        return shift;
      }
    }
    return null;
  }

  Map<String, dynamic>? _activeSecurityShift() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final active = data['activeSecurity'] as Map<String, dynamic>?;
    if (active != null) return active;
    final shifts = (data['securityShifts'] as List<dynamic>?) ?? const [];
    final now = DateTime.now();

    for (final raw in shifts) {
      final shift = raw as Map<String, dynamic>;
      final end = DateTime.tryParse((shift['shiftEndAt'] ?? '').toString());
      if (end != null && end.isAfter(now)) {
        return shift;
      }
    }
    return null;
  }

  List<Map<String, dynamic>> _nightclubStoredDrugs() {
    final root = (_stats ?? const <String, dynamic>{});
    final data = (root['data'] as Map<String, dynamic>?) ?? root;
    final rawInventory = (data['inventory'] as List<dynamic>?) ?? const [];
    return rawInventory
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();
  }

  AppLocalizations get _t => AppLocalizations.of(context)!;

  String _backgroundAsset(double width) {
    if (width >= 1200)
      return 'assets/images/backgrounds/nightclub_hub_bg_desktop.png';
    if (width >= 700)
      return 'assets/images/backgrounds/nightclub_hub_bg_tablet.png';
    return 'assets/images/backgrounds/nightclub_hub_bg_mobile.png';
  }

  String _emblemAsset(double width) {
    if (width >= 1200)
      return 'assets/images/ui/nightclub_hub_emblem_desktop.png';
    if (width >= 700) return 'assets/images/ui/nightclub_hub_emblem_tablet.png';
    return 'assets/images/ui/nightclub_hub_emblem_mobile.png';
  }

  bool _isCompactLayout() => MediaQuery.of(context).size.width < 700;

  double _contentPadding() => _isCompactLayout() ? 10 : 16;

  double _tabIconSize() => _isCompactLayout() ? 16 : 20;

  TextStyle _tabLabelStyle() {
    return TextStyle(
      fontSize: _isCompactLayout() ? 12 : 14,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  void initState() {
    super.initState();
    _managementTabController = TabController(length: 4, vsync: this);
    _insightTabController = TabController(length: 3, vsync: this);
    _load();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _managementTabController.dispose();
    _insightTabController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      if (!mounted || !_autoRefresh || _venueId == null) return;
      _load(silent: true);
    });
  }

  Future<T> _safeFetch<T>(
    Future<T> future,
    T fallback, {
    int timeoutMs = 12000,
  }) async {
    try {
      return await future.timeout(Duration(milliseconds: timeoutMs));
    } catch (_) {
      return fallback;
    }
  }

  Future<void> _load({bool silent = false}) async {
    List<Achievement> queuedAchievements = const [];
    if (!silent) {
      setState(() => _loading = true);
    }

    try {
      final venues = await _nightclubService.getMyVenues();
      int? venueIdLocal = _venueId;

      if (widget.property != null) {
        final existing = venues.cast<Map<String, dynamic>?>().firstWhere(
          (v) => v?['propertyId'] == widget.property!.id,
          orElse: () => null,
        );

        if (existing != null) {
          venueIdLocal = (existing['id'] as num).toInt();
        } else {
          final setup = await _nightclubService.setupForProperty(
            widget.property!.id,
          );
          if (setup['success'] == true && setup['venueId'] != null) {
            venueIdLocal = (setup['venueId'] as num).toInt();
            queuedAchievements = _parseAchievements(
              setup['newlyUnlockedAchievements'],
            );
          }
        }
      } else if (venueIdLocal == null && venues.isNotEmpty) {
        venueIdLocal = (venues.first['id'] as num).toInt();
      }

      if (venueIdLocal != null) {
        final results = await Future.wait<dynamic>([
          _safeFetch<Map<String, dynamic>>(
            _nightclubService.getVenueStats(venueIdLocal),
            {'success': false, 'data': <String, dynamic>{}},
          ),
          _safeFetch<List<dynamic>>(
            _nightclubService.getAvailableDjs(),
            const <dynamic>[],
          ),
          _safeFetch<List<dynamic>>(
            _nightclubService.getAvailableSecurity(),
            const <dynamic>[],
          ),
          _safeFetch<List<dynamic>>(
            _nightclubService.getAssignableProstitutes(venueIdLocal),
            const <dynamic>[],
          ),
          _safeFetch<Map<String, dynamic>>(
            _nightclubService.getLeaderboard(
              scope: _leaderboardScope,
              limit: 10,
            ),
            {'success': false, 'data': <dynamic>[]},
          ),
          _safeFetch<Map<String, dynamic>>(
            _nightclubService.getSeasonSummary(),
            {'success': false, 'data': <String, dynamic>{}},
          ),
          _safeFetch<List<DrugInventory>>(
            _drugService.getDrugInventory(),
            const <DrugInventory>[],
          ),
        ]);

        var djs = results[1] as List<dynamic>;
        var guards = results[2] as List<dynamic>;
        final rawAvailable = (results[3] as List<dynamic>)
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .where((p) => (p['location'] ?? '').toString() == 'street')
            .toList();
        final availableById = <int, Map<String, dynamic>>{};
        for (final p in rawAvailable) {
          final id = (p['id'] as num?)?.toInt();
          if (id != null) {
            availableById[id] = p;
          }
        }
        var availableProstitutes = availableById.values.toList();

        // Retry once if one of the staffing lists comes back empty
        if (djs.isEmpty || guards.isEmpty || availableProstitutes.isEmpty) {
          final retryResults = await Future.wait<dynamic>([
            _safeFetch<List<dynamic>>(
              _nightclubService.getAvailableDjs(),
              const <dynamic>[],
              timeoutMs: 12000,
            ),
            _safeFetch<List<dynamic>>(
              _nightclubService.getAvailableSecurity(),
              const <dynamic>[],
              timeoutMs: 12000,
            ),
            _safeFetch<List<dynamic>>(
              _nightclubService.getAssignableProstitutes(venueIdLocal),
              const <dynamic>[],
              timeoutMs: 12000,
            ),
          ]);

          final retryDjs = retryResults[0] as List<dynamic>;
          final retryGuards = retryResults[1] as List<dynamic>;
          final retryProstitutesRaw = (retryResults[2] as List<dynamic>)
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .where((p) => (p['location'] ?? '').toString() == 'street')
              .toList();

          if (retryDjs.isNotEmpty) {
            djs = retryDjs;
          }
          if (retryGuards.isNotEmpty) {
            guards = retryGuards;
          }
          if (retryProstitutesRaw.isNotEmpty) {
            final retryById = <int, Map<String, dynamic>>{};
            for (final p in retryProstitutesRaw) {
              final id = (p['id'] as num?)?.toInt();
              if (id != null) {
                retryById[id] = p;
              }
            }
            availableProstitutes = retryById.values.toList();
          }
        }

        if (mounted) {
          setState(() {
            _venueId = venueIdLocal;
            _venues = venues;
            _stats = results[0] as Map<String, dynamic>;
            _djs = djs;
            _guards = guards;
            _availableProstitutes = availableProstitutes;

            final leaderboardResult = results[4] as Map<String, dynamic>;
            _leaderboard = List<dynamic>.from(
              leaderboardResult['data'] ?? const [],
            );
            final seasonResult = results[5] as Map<String, dynamic>;
            _seasonSummary = seasonResult['data'] as Map<String, dynamic>?;
            _drugInventory = results[6] as List<DrugInventory>;

            final statsData =
                (_stats?['data'] as Map<String, dynamic>?) ?? const {};
            final revenueToday =
                (statsData['revenueToday'] as num?)?.toInt() ?? 0;
            _revenueTrend.add(revenueToday);
            if (_revenueTrend.length > 24) {
              _revenueTrend.removeAt(0);
            }

            if (_djs.isNotEmpty) {
              final djIds = _djs.map((d) => (d['id'] as num).toInt()).toSet();
              if (_selectedDjId == null || !djIds.contains(_selectedDjId)) {
                _selectedDjId = (_djs.first['id'] as num).toInt();
              }
            } else {
              _selectedDjId = null;
            }

            if (_guards.isNotEmpty) {
              final guardIds = _guards
                  .map((g) => (g['id'] as num).toInt())
                  .toSet();
              if (_selectedGuardId == null ||
                  !guardIds.contains(_selectedGuardId)) {
                _selectedGuardId = (_guards.first['id'] as num).toInt();
              }
            } else {
              _selectedGuardId = null;
            }

            if (_availableProstitutes.isNotEmpty) {
              final availableIds = _availableProstitutes
                  .map((p) => (p['id'] as num).toInt())
                  .toSet();
              if (_selectedProstituteId == null ||
                  !availableIds.contains(_selectedProstituteId)) {
                _selectedProstituteId =
                    (_availableProstitutes.first['id'] as num).toInt();
              }
            } else {
              _selectedProstituteId = null;
            }

            final storeOptions = _storeDrugOptions();
            if (storeOptions.isEmpty) {
              _selectedDrugKey = null;
            } else {
              final availableKeys = storeOptions
                  .map((o) => o['key'] as String)
                  .toSet();
              if (_selectedDrugKey == null ||
                  !availableKeys.contains(_selectedDrugKey)) {
                _selectedDrugKey = storeOptions.first['key'] as String;
              }
            }
          });
        }

        if (!_initialAchievementCheckDone) {
          _initialAchievementCheckDone = true;
          final achievementResult = await _safeFetch<Map<String, dynamic>>(
            _achievementService.checkAchievements(),
            {'newlyUnlocked': <dynamic>[]},
            timeoutMs: 7000,
          );
          queuedAchievements = [
            ...queuedAchievements,
            ..._parseAchievements(achievementResult['newlyUnlocked']),
          ];
        }
      }
    } catch (e) {
      if (mounted && !silent) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _l('Fout bij laden nightclub: $e', 'Error loading nightclub: $e'),
            ),
          ),
        );
      }
    } finally {
      if (mounted && !silent) {
        setState(() => _loading = false);
      }

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }

          if (queuedAchievements.isNotEmpty) {
            AchievementNotifier.showMultipleAchievements(
              context,
              queuedAchievements,
            );
          }

          _checkSeasonRewardPopup();
        });
      }
    }
  }

  List<Achievement> _parseAchievements(dynamic payload) {
    if (payload is! List) {
      return const <Achievement>[];
    }

    return payload
        .whereType<Map>()
        .map((item) => Achievement.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  void _showAchievementsFromResult(Map<String, dynamic> result) {
    final achievements = _parseAchievements(
      result['newlyUnlockedAchievements'],
    );
    if (achievements.isEmpty || !mounted) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AchievementNotifier.showMultipleAchievements(context, achievements);
      }
    });
  }

  Future<void> _checkSeasonRewardPopup() async {
    if (!mounted || _seasonSummary == null) {
      return;
    }

    final latest = _seasonSummary!['latestPlayerReward'];
    if (latest is! Map<String, dynamic>) {
      return;
    }

    final paidAt = latest['paidAt']?.toString();
    if (paidAt == null || paidAt.isEmpty) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final seenKey = 'nightclub.latestRewardPopup';
    final lastSeen = prefs.getString(seenKey);
    if (lastSeen == paidAt) {
      return;
    }

    await prefs.setString(seenKey, paidAt);
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        final rewardAmount = latest['rewardAmount'] ?? 0;
        final rank = latest['rank'] ?? '-';
        final weeklyRevenue = latest['weeklyRevenue'] ?? 0;
        final weeklyTheftLoss = latest['weeklyTheftLoss'] ?? 0;

        return AlertDialog(
          title: Text(_t.nightclubSeasonPayoutDialogTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_t.nightclubSeasonPayoutDialogBody(rank.toString())),
              const SizedBox(height: 12),
              Text(_t.nightclubSeasonPayoutDialogReward('€$rewardAmount')),
              Text(_t.nightclubSeasonPayoutDialogRevenue('€$weeklyRevenue')),
              Text(_t.nightclubSeasonPayoutDialogLoss('€$weeklyTheftLoss')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(_t.nightclubSeasonPayoutDialogAction),
            ),
          ],
        );
      },
    );
  }

  String _localizedVibe(String vibe) {
    switch (vibe) {
      case 'chill':
        return _t.nightclubVibeChill;
      case 'normal':
        return _t.nightclubVibeNormal;
      case 'wild':
        return _t.nightclubVibeWild;
      case 'raging':
        return _t.nightclubVibeRaging;
      default:
        return vibe;
    }
  }

  String _localizedTheftType(String theftType) {
    switch (theftType) {
      case 'customer_theft':
        return _t.nightclubTheftTypeCustomer;
      case 'employee_heist':
        return _t.nightclubTheftTypeEmployee;
      case 'rival_sabotage':
        return _t.nightclubTheftTypeRival;
      default:
        return theftType;
    }
  }

  void _showResultMessage(Map<String, dynamic> result, String fallbackMessage) {
    if (!mounted) {
      return;
    }

    final message = result['message']?.toString() ?? fallbackMessage;
    showTopRightFromSnackBar(context, SnackBar(content: Text(message)));
  }

  Future<void> _hireDj() async {
    if (_venueId == null || _selectedDjId == null) return;
    final result = await _nightclubService.hireDj(
      venueId: _venueId!,
      djId: _selectedDjId!,
      hoursCount: _djHours,
      startTime: DateTime.now(),
    );
    _showResultMessage(result, _t.nightclubHireDjSuccess);
    _showAchievementsFromResult(result);
    await _load();
  }

  Future<void> _hireSecurity() async {
    if (_venueId == null || _selectedGuardId == null) return;
    final result = await _nightclubService.hireSecurity(
      venueId: _venueId!,
      guardId: _selectedGuardId!,
      shiftDate: DateTime.now(),
    );
    _showResultMessage(result, _t.nightclubHireSecuritySuccess);
    _showAchievementsFromResult(result);
    await _load();
  }

  Future<void> _assignProstitute() async {
    if (_venueId == null || _selectedProstituteId == null) return;
    final result = await _nightclubService.assignProstitute(
      venueId: _venueId!,
      prostituteId: _selectedProstituteId!,
    );

    _showResultMessage(result, _t.nightclubAssignCrewSuccess);
    _showAchievementsFromResult(result);
    await _load();
  }

  Future<void> _unassignProstitute(int prostituteId) async {
    if (_venueId == null) return;
    final result = await _nightclubService.unassignProstitute(
      venueId: _venueId!,
      prostituteId: prostituteId,
    );

    _showResultMessage(result, _t.nightclubRemoveCrewSuccess);
    _showAchievementsFromResult(result);
    await _load();
  }

  Future<void> _storeDrugs() async {
    if (_venueId == null || _selectedDrugKey == null) return;
    final split = _selectedDrugKey!.split(':');
    if (split.length != 2) return;

    final result = await _nightclubService.storeDrugs(
      venueId: _venueId!,
      drugType: split[0],
      quality: split[1],
      quantity: _storeQuantity,
    );

    _showResultMessage(result, _t.nightclubStoreDrugsSuccess);
    _showAchievementsFromResult(result);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final bg = _backgroundAsset(width);
        final emblem = _emblemAsset(width);

        return Scaffold(
          appBar: AppBar(title: Text(_t.nightclubManagementTitle)),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  bg,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.black87),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xCC000000),
                        Color(0xA8000000),
                        Color(0xCC000000),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Opacity(
                  opacity: 0.72,
                  child: Image.asset(
                    emblem,
                    width: width < 700 ? 70 : 96,
                    height: width < 700 ? 70 : 96,
                  ),
                ),
              ),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _venueId == null
                  ? _emptyState()
                  : RefreshIndicator(
                      onRefresh: () => _load(),
                      child: ListView(
                        padding: EdgeInsets.all(_contentPadding()),
                        children: [
                          _topControls(),
                          const SizedBox(height: 12),
                          _venueSelectorCard(),
                          const SizedBox(height: 12),
                          _insightTabs(),
                          const SizedBox(height: 12),
                          _managementTabs(),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _topControls() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _t.nightclubRealtimeStatus,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(width: 8),
        Switch(
          value: _autoRefresh,
          onChanged: (v) => setState(() => _autoRefresh = v),
        ),
        IconButton(
          tooltip: _t.nightclubRefresh,
          onPressed: () => _load(),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.nightlife, size: 48),
            const SizedBox(height: 12),
            Text(_t.nightclubEmptyTitle),
            const SizedBox(height: 6),
            Text(_t.nightclubEmptyBody, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _venueSelectorCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final crowd = (data['crowdSize'] as num?)?.toInt() ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubLocationTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _venueId,
              items: _venues
                  .map(
                    (v) => DropdownMenuItem<int>(
                      value: (v['id'] as num).toInt(),
                      child: Text('${v['country']} (#${v['id']})'),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _venueId = v);
                _load(silent: true);
              },
              decoration: InputDecoration(labelText: _t.nightclubSelectVenue),
            ),
            if (_venueId != null) ...[
              const SizedBox(height: 8),
              Text(
                '${_l('Huidige bezoekers', 'Current visitors')}: $crowd%',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statsCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final crowd = (data['crowdSize'] as num?)?.toInt() ?? 0;
    final revenueToday = (data['revenueToday'] as num?)?.toInt() ?? 0;
    final revenueAllTime = (data['revenueAllTime'] as num?)?.toInt() ?? 0;
    final inventoryValue = (data['inventoryValue'] as num?)?.toInt() ?? 0;
    final djActive = data['djActive'] == true;
    final thefts = ((data['thefts'] as List<dynamic>?) ?? const []).length;
    final prostitution =
        (data['prostitution'] as Map<String, dynamic>?) ?? const {};
    final staffCap = (prostitution['staffCap'] ?? 0).toString();
    final staffCount = (prostitution['assignedCount'] ?? 0).toString();
    final vipActive = prostitution['isVipBoostActive'] == true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubLiveStatistics,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_t.nightclubKpiCrowd, '$crowd%'),
                _kpiChip(
                  _t.nightclubKpiVibe,
                  _localizedVibe((data['crowdVibe'] ?? 'chill').toString()),
                ),
                _kpiChip(_t.nightclubKpiToday, '€$revenueToday'),
                _kpiChip(_t.nightclubKpiAllTime, '€$revenueAllTime'),
                _kpiChip(_t.nightclubKpiStock, '€$inventoryValue'),
                _kpiChip(
                  _t.nightclubKpiDj,
                  djActive ? _t.nightclubStatusActive : _t.nightclubStatusOff,
                ),
                _kpiChip(_t.nightclubKpiThefts, '$thefts'),
                _kpiChip(_t.nightclubKpiStaff, '$staffCount/$staffCap'),
                _kpiChip(
                  _t.nightclubKpiSalesBoost,
                  'x${(prostitution['salesBoost'] ?? 1)}',
                ),
                _kpiChip(
                  _t.nightclubKpiPriceBoost,
                  'x${(prostitution['priceBoost'] ?? 1)}',
                ),
                _kpiChip(
                  _t.nightclubKpiVipBonus,
                  vipActive ? _t.nightclubStatusActive : _t.nightclubStatusOff,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _trendCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubRevenueTrend,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: CustomPaint(
                painter: _SparklinePainter(_revenueTrend),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leaderboardCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _t.nightclubLeaderboardTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _leaderboardScope,
                  items: [
                    DropdownMenuItem(
                      value: 'country',
                      child: Text(_t.nightclubLeaderboardCountry),
                    ),
                    DropdownMenuItem(
                      value: 'global',
                      child: Text(_t.nightclubLeaderboardGlobal),
                    ),
                  ],
                  onChanged: (v) async {
                    if (v == null) return;
                    setState(() => _leaderboardScope = v);
                    await _load(silent: true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_leaderboard.isEmpty) Text(_t.nightclubLeaderboardEmpty),
            ..._leaderboard.map((entry) {
              final map = entry as Map<String, dynamic>;
              final rank = map['rank'] ?? '-';
              final owner = map['ownerUsername'] ?? 'unknown';
              final country = map['country'] ?? '-';
              final score = map['score'] ?? 0;
              final revenue24h = map['revenue24h'] ?? 0;
              final crowdSize = map['crowdSize'] ?? 0;
              final staffCount = map['staffCount'] ?? 0;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 14,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text('$owner • $country'),
                subtitle: Text(
                  '${_t.nightclubLeaderboardRevenue24h}: €$revenue24h | ${_t.nightclubKpiCrowd}: $crowdSize% | ${_t.nightclubKpiStaff}: $staffCount',
                ),
                trailing: Text(
                  '★$score',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _seasonCard() {
    final data = _seasonSummary ?? const {};
    final leaderboard =
        (data['currentLeaderboard'] as List<dynamic>?) ?? const [];
    final rewards = (data['recentRewards'] as List<dynamic>?) ?? const [];
    final totalRewards = data['yourTotalSeasonRewards'] ?? 0;
    final endAt = DateTime.tryParse((data['seasonEndAt'] ?? '').toString());
    final now = DateTime.now().toUtc();
    final remaining = endAt != null ? endAt.difference(now) : const Duration();
    final remainingText = remaining.isNegative
        ? _t.nightclubSeasonProcessing
        : '${remaining.inDays}d ${remaining.inHours % 24}h ${remaining.inMinutes % 60}m';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubSeasonTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text('${_t.nightclubSeasonResetIn}: $remainingText'),
            Text('${_t.nightclubSeasonYourRewards}: €$totalRewards'),
            const SizedBox(height: 10),
            Text(
              _t.nightclubSeasonCurrentTop5,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (leaderboard.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(_t.nightclubSeasonEmpty),
              ),
            ...leaderboard.take(5).map((entry) {
              final map = entry as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 12,
                  child: Text(
                    '${map['rank'] ?? '-'}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  '${map['ownerUsername'] ?? 'unknown'} • ${map['country'] ?? '-'}',
                ),
                subtitle: Text(
                  '${_t.nightclubSeasonWeekRevenue}: €${map['weeklyRevenue'] ?? 0} | ${_t.nightclubSeasonScore}: ${map['score'] ?? 0}',
                ),
              );
            }),
            const SizedBox(height: 8),
            Text(
              _t.nightclubSeasonRecentPayouts,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            if (rewards.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(_t.nightclubSeasonNoPayouts),
              ),
            ...rewards.take(5).map((entry) {
              final map = entry as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.workspace_premium,
                  size: 18,
                  color: Colors.amber.shade700,
                ),
                title: Text(
                  '#${map['rank'] ?? '-'} ${map['username'] ?? 'unknown'}',
                ),
                trailing: Text(
                  '€${map['rewardAmount'] ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _salesLogCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final sales = ((data['recentSales'] as List<dynamic>?) ?? const []);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubSalesTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (sales.isEmpty) Text(_t.nightclubSalesEmpty),
            ...sales.take(8).map((s) {
              final map = s as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.point_of_sale, size: 18),
                title: Text(
                  '${map['drugType']} (${map['quality']}) x${map['quantitySold']}g',
                ),
                subtitle: Text(
                  '${_t.nightclubKpiVibe}: ${_localizedVibe((map['crowdVibe'] ?? '').toString())}',
                ),
                trailing: Text('€${map['totalRevenue']}'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _theftLogCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final thefts = ((data['thefts'] as List<dynamic>?) ?? const []);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubTheftTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (thefts.isEmpty) Text(_t.nightclubTheftEmpty),
            ...thefts.take(8).map((t) {
              final map = t as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Colors.orange,
                ),
                title: Text(
                  '${_localizedTheftType((map['theftType'] ?? '').toString())} - ${map['drugType']} (${map['quality']})',
                ),
                subtitle: Text(
                  '${_t.nightclubTheftLoss}: ${map['quantityStolen']}g',
                ),
                trailing: Text('€${map['valueLost']}'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _staffCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final prostitution =
        (data['prostitution'] as Map<String, dynamic>?) ?? const {};
    final assignedStaff = (prostitution['staff'] as List<dynamic>?) ?? const [];
    final history = (prostitution['history'] as List<dynamic>?) ?? const [];
    final assignedCount = prostitution['assignedCount'] ?? 0;
    final staffCap = prostitution['staffCap'] ?? 0;
    final salesBoost = prostitution['salesBoost'] ?? 1;
    final priceBoost = prostitution['priceBoost'] ?? 1;
    final vibeFactor = prostitution['vibeFactor'] ?? 1;
    final securityFactor = prostitution['securityFactor'] ?? 1;
    final vipFactor = prostitution['vipFactor'] ?? 1;
    final vipStaffFactor = prostitution['vipStaffFactor'] ?? 1;
    final vipAssignedCount = prostitution['vipAssignedCount'] ?? 0;
    final vipActive = prostitution['isVipBoostActive'] == true;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubStaffTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              _t.nightclubStaffCapacity(
                assignedCount.toString(),
                staffCap.toString(),
                vipActive ? _t.nightclubStaffVipExtraActive : '',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _t.nightclubStaffBoostMix(
                salesBoost.toString(),
                priceBoost.toString(),
                vibeFactor.toString(),
                securityFactor.toString(),
                vipFactor.toString(),
                vipStaffFactor.toString(),
                vipAssignedCount.toString(),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _selectedProstituteId,
              items: _availableProstitutes.map((p) {
                final id = (p['id'] as num).toInt();
                final level = p['level'] ?? 1;
                final location = (p['location'] ?? 'street').toString();
                final vipLabel = _vipStatusLabel(p['variant']);
                final label = '$vipLabel | $location | Lv $level';
                return DropdownMenuItem<int>(
                  value: id,
                  child: Row(
                    children: [
                      _thumbFromImageRef(
                        fallbackAsset: _prostitutePortraitAsset(p['variant']),
                        fallbackIcon: Icons.person,
                      ),
                      const SizedBox(width: 8),
                      _dropdownItemLabel('${p['name']} ($label)'),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedProstituteId = v),
              decoration: InputDecoration(
                labelText: _t.nightclubSelectCrewMember,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _selectedProstituteId == null
                  ? null
                  : _assignProstitute,
              icon: const Icon(Icons.groups_2),
              label: Text(_t.nightclubAssignShift),
            ),
            const SizedBox(height: 12),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: _t.nightclubTabActive),
                      Tab(text: _t.nightclubTabHistory),
                    ],
                  ),
                  SizedBox(
                    height: 240,
                    child: TabBarView(
                      children: [
                        assignedStaff.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(_t.nightclubNoCrewAssigned),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.only(top: 8),
                                itemCount: assignedStaff.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _isCompactLayout()
                                          ? 1
                                          : 2,
                                      mainAxisExtent: _isCompactLayout()
                                          ? 118
                                          : 124,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                    ),
                                itemBuilder: (context, index) {
                                  final map =
                                      assignedStaff[index]
                                          as Map<String, dynamic>;
                                  final id = (map['id'] as num).toInt();
                                  final vipLabel = _vipStatusLabel(
                                    map['variant'],
                                  );

                                  return Card(
                                    margin: EdgeInsets.zero,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          _thumbFromImageRef(
                                            fallbackAsset:
                                                _prostitutePortraitAsset(
                                                  map['variant'],
                                                ),
                                            fallbackIcon: Icons.person,
                                            size: 44,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${map['name']}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '$vipLabel • Lv ${map['level'] ?? 1}',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(
                                                    context,
                                                  ).textTheme.bodySmall,
                                                ),
                                                const SizedBox(height: 6),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        _unassignProstitute(id),
                                                    style: OutlinedButton.styleFrom(
                                                      minimumSize: const Size(
                                                        0,
                                                        30,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 0,
                                                          ),
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                    ),
                                                    child: Text(
                                                      _t.nightclubRemove,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ListView(
                          children: [
                            if (history.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(_t.nightclubNoStaffHistory),
                              ),
                            ...history.map((h) {
                              final map = h as Map<String, dynamic>;
                              final prostitute =
                                  (map['prostitute']
                                      as Map<String, dynamic>?) ??
                                  const {};
                              final assignedAt = DateTime.tryParse(
                                map['assignedAt']?.toString() ?? '',
                              );
                              final releasedAt = DateTime.tryParse(
                                map['releasedAt']?.toString() ?? '',
                              );
                              final active = map['isActive'] == true;
                              final startText = assignedAt != null
                                  ? '${assignedAt.day.toString().padLeft(2, '0')}-${assignedAt.month.toString().padLeft(2, '0')} ${assignedAt.hour.toString().padLeft(2, '0')}:${assignedAt.minute.toString().padLeft(2, '0')}'
                                  : '-';
                              final endText = releasedAt != null
                                  ? '${releasedAt.day.toString().padLeft(2, '0')}-${releasedAt.month.toString().padLeft(2, '0')} ${releasedAt.hour.toString().padLeft(2, '0')}:${releasedAt.minute.toString().padLeft(2, '0')}'
                                  : (active
                                        ? _t.nightclubStatusActiveLower
                                        : '-');
                              final estimatedRevenue =
                                  map['estimatedRevenue'] ?? 0;
                              final estimatedSalesCount =
                                  map['estimatedSalesCount'] ?? 0;
                              final vipLabel = _vipStatusLabel(
                                prostitute['variant'],
                              );

                              return ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: _thumbFromImageRef(
                                  fallbackAsset: _prostitutePortraitAsset(
                                    prostitute['variant'],
                                  ),
                                  fallbackIcon: active
                                      ? Icons.schedule
                                      : Icons.history,
                                  size: 30,
                                ),
                                title: Text(
                                  '${prostitute['name'] ?? _l('Onbekend', 'Unknown')} • $vipLabel (Lv ${prostitute['level'] ?? 1})',
                                ),
                                subtitle: Text(
                                  '${_t.nightclubFrom}: $startText  |  ${_t.nightclubTo}: $endText\n${_t.nightclubRevenueImpact}: €$estimatedRevenue (${_t.nightclubSalesCountLabel}: $estimatedSalesCount)',
                                ),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _djCard() {
    final activeShift = _activeDjShift();
    final activeDjId = (activeShift?['djId'] as num?)?.toInt();
    final activeDjName =
        (activeShift?['djName'] as String?) ??
        ((activeShift?['dj'] as Map<String, dynamic>?)?['djName'] as String?) ??
        _djNameById(activeDjId);
    final activeUntil = DateTime.tryParse(
      (activeShift?['shiftEndAt'] ?? '').toString(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubDjTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              activeShift != null
                  ? '${_l('Actieve DJ', 'Active DJ')}: $activeDjName${activeUntil != null ? ' (${_l('tot', 'until')} ${activeUntil.hour.toString().padLeft(2, '0')}:${activeUntil.minute.toString().padLeft(2, '0')})' : ''}'
                  : _l('Actieve DJ: geen', 'Active DJ: none'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (_djs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _l(
                    'Geen DJ\'s beschikbaar geladen. Ververs het scherm.',
                    'No DJs available loaded. Refresh the screen.',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            DropdownButtonFormField<int>(
              value: _selectedDjId,
              items: _djs
                  .map(
                    (d) => DropdownMenuItem<int>(
                      value: (d['id'] as num).toInt(),
                      child: Row(
                        children: [
                          _thumbFromImageRef(
                            imageRef: d['image']?.toString(),
                            fallbackIcon: Icons.person,
                          ),
                          const SizedBox(width: 8),
                          _dropdownItemLabel(
                            '${d['name']} (Lv ${d['skillLevel']}) - €${d['costPerHour']}/h',
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedDjId = v),
              decoration: InputDecoration(labelText: _t.nightclubChooseDj),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _djHours,
              items: const [4, 8, 12, 24]
                  .map(
                    (h) => DropdownMenuItem<int>(value: h, child: Text('$h h')),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _djHours = v ?? 8),
              decoration: InputDecoration(labelText: _t.nightclubShiftLength),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _selectedDjId == null ? null : _hireDj,
              icon: const Icon(Icons.music_note),
              label: Text(_t.nightclubHireDj),
            ),
          ],
        ),
      ),
    );
  }

  Widget _securityCard() {
    final activeShift = _activeSecurityShift();
    final activeGuardId = (activeShift?['guardId'] as num?)?.toInt();
    final activeGuardName =
        (activeShift?['guardName'] as String?) ??
        ((activeShift?['guard'] as Map<String, dynamic>?)?['guardName']
            as String?) ??
        _guardNameById(activeGuardId);
    final activeUntil = DateTime.tryParse(
      (activeShift?['shiftEndAt'] ?? '').toString(),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubSecurityTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              activeShift != null
                  ? '${_l('Actieve beveiliging', 'Active security')}: $activeGuardName${activeUntil != null ? ' (${_l('tot', 'until')} ${activeUntil.hour.toString().padLeft(2, '0')}:${activeUntil.minute.toString().padLeft(2, '0')})' : ''}'
                  : _l('Actieve beveiliging: geen', 'Active security: none'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (_guards.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _l(
                    'Geen beveiliging beschikbaar geladen. Ververs het scherm.',
                    'No security loaded. Refresh the screen.',
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            DropdownButtonFormField<int>(
              value: _selectedGuardId,
              items: _guards
                  .map(
                    (g) => DropdownMenuItem<int>(
                      value: (g['id'] as num).toInt(),
                      child: Row(
                        children: [
                          _thumbFromImageRef(
                            imageRef: g['image']?.toString(),
                            fallbackIcon: Icons.shield,
                          ),
                          const SizedBox(width: 8),
                          _dropdownItemLabel(
                            '${g['name']} (Lv ${g['skillLevel']}) - €${g['costPerShift']}/shift',
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedGuardId = v),
              decoration: InputDecoration(
                labelText: _t.nightclubChooseSecurity,
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _selectedGuardId == null ? null : _hireSecurity,
              icon: const Icon(Icons.security),
              label: Text(_t.nightclubHireSecurity),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storeCard() {
    final options = _storeDrugOptions();
    final storedAll = _nightclubStoredDrugs();
    final stored = storedAll
        .where((row) => ((row['quantity'] as num?)?.toInt() ?? 0) > 0)
        .toList();
    final totalStoredGrams = stored.fold<int>(
      0,
      (sum, row) => sum + ((row['quantity'] as num?)?.toInt() ?? 0),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubStoreTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: options.any((o) => o['key'] == _selectedDrugKey)
                  ? _selectedDrugKey
                  : null,
              items: options
                  .map(
                    (o) => DropdownMenuItem<String>(
                      value: o['key'] as String,
                      child: Row(
                        children: [
                          _thumbFromImageRef(
                            fallbackAsset: _drugImageAsset(
                              (o['key'] as String).split(':').first,
                            ),
                            fallbackIcon: Icons.science,
                          ),
                          const SizedBox(width: 8),
                          _dropdownItemLabel(
                            '${o['drugName']} (${o['quality']}) - ${o['quantity']}g',
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedDrugKey = v),
              decoration: InputDecoration(labelText: _t.nightclubChooseStock),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _storeQuantity.toString(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: _t.nightclubAmountGrams),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null && parsed > 0) {
                  _storeQuantity = parsed;
                }
              },
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _selectedDrugKey == null ? null : _storeDrugs,
              icon: const Icon(Icons.inventory_2),
              label: Text(_t.nightclubStoreButton),
            ),
            const SizedBox(height: 12),
            Text(
              _l('Opgeslagen in nightclub', 'Stored in nightclub'),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              _l(
                'Huidige voorraad: ${totalStoredGrams}g',
                'Current stock: ${totalStoredGrams}g',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            if (stored.isEmpty)
              Text(
                storedAll.isEmpty
                    ? _l('Nog geen opgeslagen drugs.', 'No stored drugs yet.')
                    : _l(
                        'Voorraad is momenteel 0g (alles is verkocht).',
                        'Current stock is 0g (everything has been sold).',
                      ),
              ),
            if (stored.isNotEmpty)
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final columns = maxWidth >= 1200
                      ? 4
                      : (maxWidth >= 800 ? 3 : (maxWidth >= 480 ? 2 : 1));
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: stored.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: 200,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final row = stored[index];
                      final drugType = (row['drugType'] ?? '-').toString();
                      final quality = (row['quality'] ?? '-').toString();
                      final quantity =
                          ((row['quantity'] as num?)?.toInt() ?? 0);

                      return Card(
                        color: Colors.black.withOpacity(0.58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Color(0x33FFFFFF)),
                        ),
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: _thumbFromImageRef(
                                    fallbackAsset: _drugImageAsset(drugType),
                                    fallbackIcon: Icons.inventory_2_outlined,
                                    size: 80,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                drugType,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text(
                                  '${_l('Kwaliteit', 'Quality')}: $quality',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${quantity}g ${_l('voorraad', 'stock')}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Colors.lightGreenAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _managementTabs() {
    final screenHeight = MediaQuery.of(context).size.height;
    final compact = _isCompactLayout();
    final tabBodyHeight = (screenHeight * 0.62).clamp(420.0, 780.0);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 8 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _l('Nachtclub Beheer', 'Nightclub Management'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _managementTabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: _tabLabelStyle(),
              labelPadding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
              tabs: [
                Tab(
                  text: _l('Hoeren', 'Crew'),
                  icon: Icon(Icons.group, size: _tabIconSize()),
                ),
                Tab(
                  text: _l('Drugs', 'Drugs'),
                  icon: Icon(Icons.science, size: _tabIconSize()),
                ),
                Tab(
                  text: _l('DJ', 'DJ'),
                  icon: Icon(Icons.music_note, size: _tabIconSize()),
                ),
                Tab(
                  text: _l('Beveiliging', 'Security'),
                  icon: Icon(Icons.security, size: _tabIconSize()),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: tabBodyHeight,
              child: TabBarView(
                controller: _managementTabController,
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: _staffCard(),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: _storeCard(),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: _djCard(),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: _securityCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _insightTabs() {
    final screenHeight = MediaQuery.of(context).size.height;
    final compact = _isCompactLayout();
    final tabBodyHeight = (screenHeight * 0.56).clamp(360.0, 700.0);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 8 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _l('Nachtclub Overzicht', 'Nightclub Overview'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _insightTabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: _tabLabelStyle(),
              labelPadding: EdgeInsets.symmetric(horizontal: compact ? 8 : 12),
              tabs: [
                Tab(
                  text: _l('Overzicht', 'Overview'),
                  icon: Icon(Icons.dashboard, size: _tabIconSize()),
                ),
                Tab(
                  text: _l('Omzet', 'Revenue'),
                  icon: Icon(Icons.euro, size: _tabIconSize()),
                ),
                Tab(
                  text: _l('Risico', 'Risk'),
                  icon: Icon(Icons.warning_amber_rounded, size: _tabIconSize()),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: tabBodyHeight,
              child: TabBarView(
                controller: _insightTabController,
                children: [
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _statsCard(),
                      const SizedBox(height: 10),
                      _seasonCard(),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _trendCard(),
                      const SizedBox(height: 10),
                      _salesLogCard(),
                      const SizedBox(height: 10),
                      _leaderboardCard(),
                    ],
                  ),
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [_theftLogCard()],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<int> points;

  _SparklinePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final axis = Paint()
      ..color = Colors.grey.withValues(alpha: 0.4)
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height - 1),
      Offset(size.width, size.height - 1),
      axis,
    );

    if (points.length < 2) {
      return;
    }

    final maxVal = points.reduce((a, b) => a > b ? a : b).toDouble();
    final minVal = points.reduce((a, b) => a < b ? a : b).toDouble();
    final range = (maxVal - minVal).abs() < 1 ? 1.0 : (maxVal - minVal);

    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final normalized = (points[i] - minVal) / range;
      final y = size.height - (normalized * (size.height - 4)) - 2;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    if (oldDelegate.points.length != points.length) {
      return true;
    }
    for (int i = 0; i < points.length; i++) {
      if (oldDelegate.points[i] != points[i]) return true;
    }
    return false;
  }
}
