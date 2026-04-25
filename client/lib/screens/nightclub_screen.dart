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
  int _residentDays = 7;
  String _selectedEventType = 'deep_house_night';
  int _marketingAmount = 50000;
  String _selectedUpgradeType = 'sound_rig';
  String _selectedSupplierContract = 'street';
  String _selectedPromoterProfile = 'street_hype';
  String _selectedSmugglingRoute = 'harbor';
  String _selectedHospitalityPack = 'beer_crates';
  String _selectedHospitalityPricing = 'balanced';
  String? _selectedRivalName;
  List<dynamic> _rivalSearchResults = const [];
  late final TextEditingController _storeQuantityController;
  late final TextEditingController _rivalSearchController;
  late final TabController _managementTabController;

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

  String _formatRemainingMinutesLabel(int minutesRaw) {
    final minutes = minutesRaw < 0 ? 0 : minutesRaw;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours <= 0) {
      return _l('$minutes min', '$minutes min');
    }
    if (remainingMinutes <= 0) {
      return _l('$hours uur', '${hours}h');
    }
    return _l('${hours}u ${remainingMinutes}m', '${hours}h ${remainingMinutes}m');
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
    if (width >= 1200) {
      return 'assets/images/backgrounds/nightclub_hub_bg_desktop.png';
    }
    if (width >= 700) {
      return 'assets/images/backgrounds/nightclub_hub_bg_tablet.png';
    }
    return 'assets/images/backgrounds/nightclub_hub_bg_mobile.png';
  }

  String _emblemAsset(double width) {
    if (width >= 1200) {
      return 'assets/images/ui/nightclub_hub_emblem_desktop.png';
    }
    if (width >= 700) {
      return 'assets/images/ui/nightclub_hub_emblem_tablet.png';
    }
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

  Map<String, dynamic>? _selectedStoreOption(
    List<Map<String, dynamic>> options,
  ) {
    if (_selectedDrugKey == null) return null;
    for (final option in options) {
      if (option['key'] == _selectedDrugKey) {
        return option;
      }
    }
    return null;
  }

  int _selectedStoreMax(List<Map<String, dynamic>> options) {
    final selected = _selectedStoreOption(options);
    return (selected?['quantity'] as int?) ?? 0;
  }

  Map<String, dynamic>? _selectedDj() {
    if (_selectedDjId == null) return null;
    for (final raw in _djs) {
      final map = raw as Map<String, dynamic>;
      if ((map['id'] as num?)?.toInt() == _selectedDjId) {
        return map;
      }
    }
    return null;
  }

  Map<String, dynamic>? _selectedGuard() {
    if (_selectedGuardId == null) return null;
    for (final raw in _guards) {
      final map = raw as Map<String, dynamic>;
      if ((map['id'] as num?)?.toInt() == _selectedGuardId) {
        return map;
      }
    }
    return null;
  }

  void _setStoreQuantityValue(int value) {
    final next = value < 1 ? 1 : value;
    _storeQuantity = next;
    if (_storeQuantityController.text != '$next') {
      _storeQuantityController.text = '$next';
      _storeQuantityController.selection = TextSelection.collapsed(
        offset: _storeQuantityController.text.length,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _storeQuantityController = TextEditingController(text: '$_storeQuantity');
    _rivalSearchController = TextEditingController();
    _managementTabController = TabController(length: 5, vsync: this);
    _load();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _storeQuantityController.dispose();
    _rivalSearchController.dispose();
    _managementTabController.dispose();
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
              final maxStore = _selectedStoreMax(storeOptions);
              if (maxStore > 0 && _storeQuantity > maxStore) {
                _setStoreQuantityValue(maxStore);
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

  Future<void> _hireResidentDj() async {
    if (_venueId == null || _selectedDjId == null) return;
    final result = await _nightclubService.hireResidentDj(
      venueId: _venueId!,
      djId: _selectedDjId!,
      days: _residentDays,
    );
    _showResultMessage(
      result,
      _l('Resident DJ contract mislukt', 'Resident DJ contract failed'),
    );
    _showAchievementsFromResult(result);
    await _load();
  }

  Future<void> _scheduleNightclubEvent() async {
    if (_venueId == null) return;
    final result = await _nightclubService.scheduleEvent(
      venueId: _venueId!,
      eventType: _selectedEventType,
      startsAt: DateTime.now().add(const Duration(minutes: 5)),
    );
    _showResultMessage(
      result,
      _l('Event plannen mislukt', 'Failed to schedule event'),
    );
    _showAchievementsFromResult(result);
    await _load();
  }

  Future<void> _investMarketing() async {
    if (_venueId == null) return;
    final result = await _nightclubService.investMarketing(
      venueId: _venueId!,
      amount: _marketingAmount,
    );
    _showResultMessage(
      result,
      _l('Marketing upgrade mislukt', 'Marketing upgrade failed'),
    );
    await _load();
  }

  Future<void> _applyUpgradeTreeChoice() async {
    if (_venueId == null) return;
    final result = await _nightclubService.applyUpgrade(
      venueId: _venueId!,
      upgradeType: _selectedUpgradeType,
    );
    _showResultMessage(result, _l('Upgrade mislukt', 'Upgrade failed'));
    await _load();
  }

  Future<void> _respondToIncident(String actionType) async {
    if (_venueId == null) return;
    final result = await _nightclubService.respondIncident(
      venueId: _venueId!,
      actionType: actionType,
    );
    _showResultMessage(
      result,
      _l('Incident response mislukt', 'Incident response failed'),
    );
    await _load();
  }

  Future<void> _searchRivals() async {
    final name = _rivalSearchController.text.trim();
    if (name.length < 2) {
      setState(() {
        _rivalSearchResults = const [];
        _selectedRivalName = null;
      });
      return;
    }

    final data = await _nightclubService.searchRivalsByName(name);
    if (!mounted) return;
    setState(() {
      _rivalSearchResults = data;
      _selectedRivalName = data.isNotEmpty
          ? (data.first as Map<String, dynamic>)['ownerName']?.toString()
          : null;
    });
  }

  Future<void> _runRivalAction(String actionType) async {
    if (_venueId == null || _selectedRivalName == null) return;
    final result = await _nightclubService.rivalAction(
      venueId: _venueId!,
      targetName: _selectedRivalName!,
      actionType: actionType,
    );
    _showResultMessage(
      result,
      _l('Rival action mislukt', 'Rival action failed'),
    );
    await _searchRivals();
    await _load();
  }

  Future<void> _activateSupplierContract() async {
    if (_venueId == null) return;
    final result = await _nightclubService.activateSupplierContract(
      venueId: _venueId!,
      contractType: _selectedSupplierContract,
    );
    _showResultMessage(
      result,
      _l('Supplier contract mislukt', 'Supplier contract failed'),
    );
    await _load();
  }

  Future<void> _hirePromoterProfile() async {
    if (_venueId == null) return;
    final result = await _nightclubService.hirePromoter(
      venueId: _venueId!,
      profileType: _selectedPromoterProfile,
    );
    _showResultMessage(result, _l('Promoter mislukt', 'Promoter failed'));
    await _load();
  }

  Future<void> _runHeatCooldownAction() async {
    if (_venueId == null) return;
    final result = await _nightclubService.runHeatCooldown(venueId: _venueId!);
    _showResultMessage(
      result,
      _l('Heat cooldown mislukt', 'Heat cooldown failed'),
    );
    await _load();
  }

  Future<void> _runSmugglingRouteAction() async {
    if (_venueId == null) return;
    final result = await _nightclubService.runSmugglingRoute(
      venueId: _venueId!,
      routeType: _selectedSmugglingRoute,
    );
    _showResultMessage(result, _l('Smuggling mislukt', 'Smuggling failed'));
    await _load();
  }

  Future<void> _runCounterIntelSweep() async {
    if (_venueId == null) return;
    final result = await _nightclubService.runCounterIntel(venueId: _venueId!);
    _showResultMessage(
      result,
      _l('Counter-intel mislukt', 'Counter-intel failed'),
    );
    await _load();
  }

  Future<void> _buyHospitalityStock() async {
    if (_venueId == null) return;
    final result = await _nightclubService.buyHospitalityStock(
      venueId: _venueId!,
      packType: _selectedHospitalityPack,
    );
    _showResultMessage(
      result,
      _l('Hospitality stock mislukt', 'Hospitality stock failed'),
    );
    await _load();
  }

  Future<void> _setHospitalityPricingMode() async {
    if (_venueId == null) return;
    final result = await _nightclubService.setHospitalityPricing(
      venueId: _venueId!,
      pricingMode: _selectedHospitalityPricing,
    );
    _showResultMessage(
      result,
      _l('Hospitality pricing mislukt', 'Hospitality pricing failed'),
    );
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
                          _operationsDeckCard(),
                          const SizedBox(height: 12),
                          _nightclubIntelligenceCard(),
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

    return _mafiaPanel(
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

  Widget _operationsDeckCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final crowdRaw = (data['crowdSize'] as num?)?.toDouble() ?? 0;
    final crowd = crowdRaw < 0 ? 0.0 : (crowdRaw > 100 ? 100.0 : crowdRaw);
    final inventoryValue = (data['inventoryValue'] as num?)?.toInt() ?? 0;
    final revenueToday = (data['revenueToday'] as num?)?.toInt() ?? 0;
    final thefts = ((data['thefts'] as List<dynamic>?) ?? const []).length;
    final prostitution =
        (data['prostitution'] as Map<String, dynamic>?) ?? const {};
    final staffCap = ((prostitution['staffCap'] as num?)?.toInt() ?? 0);
    final staffCount = ((prostitution['assignedCount'] as num?)?.toInt() ?? 0);
    final staffingRatioRaw = staffCap > 0 ? (staffCount / staffCap) : 0.0;
    final staffingRatio = staffingRatioRaw < 0
        ? 0.0
        : (staffingRatioRaw > 1 ? 1.0 : staffingRatioRaw);
    final riskRatioRaw = thefts / 10;
    final riskRatio = riskRatioRaw < 0
        ? 0.0
        : (riskRatioRaw > 1 ? 1.0 : riskRatioRaw);
    final vibe = _localizedVibe((data['crowdVibe'] ?? 'chill').toString());

    return _mafiaPanel(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _l('Nightclub Command Deck', 'Nightclub Command Deck'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_l('Vibe', 'Vibe'), vibe),
                _kpiChip(_l('Crowd', 'Crowd'), '${crowd.toStringAsFixed(0)}%'),
                _kpiChip(
                  _l('Omzet vandaag', 'Revenue today'),
                  '€$revenueToday',
                ),
                _kpiChip(_l('Stockwaarde', 'Stock value'), '€$inventoryValue'),
              ],
            ),
            const SizedBox(height: 12),
            _progressRow(
              _l('Crew bezetting', 'Crew occupancy'),
              '$staffCount/$staffCap',
              staffingRatio,
              Colors.cyanAccent,
            ),
            const SizedBox(height: 8),
            _progressRow(
              _l('Operationeel risico', 'Operational risk'),
              _l('$thefts incidenten (24h)', '$thefts incidents (24h)'),
              riskRatio,
              riskRatio >= 0.6 ? Colors.redAccent : Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _mafiaPanel({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCC110A0A), Color(0xCC24120A), Color(0xCC16110E)],
        ),
        border: Border.all(color: const Color(0x66D4A24D)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _progressRow(
    String title,
    String value,
    double valueRatio,
    Color accentColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: valueRatio.clamp(0, 1).toDouble(),
            minHeight: 8,
            backgroundColor: Colors.white24,
            color: accentColor,
          ),
        ),
      ],
    );
  }

  Widget _kpiChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0x33241A0F),
        border: Border.all(color: const Color(0x55D4A24D)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFE3A0),
            ),
          ),
        ],
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

    return _mafiaPanel(
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
    final selectedDj = _selectedDj();
    final crowdBoost = ((selectedDj?['crowdBoostMultiplier'] as num?) ?? 1)
        .toDouble()
        .toStringAsFixed(2);
    final reputation = ((selectedDj?['reputation'] as num?) ?? 0)
        .toDouble()
        .toStringAsFixed(2);

    return _mafiaPanel(
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
              isExpanded: true,
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
            if (selectedDj != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _kpiChip(
                    _l('Level', 'Level'),
                    'Lv ${selectedDj['skillLevel']}',
                  ),
                  _kpiChip(_l('Crowd boost', 'Crowd boost'), 'x$crowdBoost'),
                  _kpiChip(
                    _l('Kosten', 'Cost'),
                    '€${selectedDj['costPerHour']}/h',
                  ),
                  _kpiChip(_l('Reputatie', 'Reputation'), reputation),
                  _kpiChip(
                    _l('Specialiteit', 'Specialty'),
                    (selectedDj['specialty'] ?? '-').toString(),
                  ),
                ],
              ),
            ],
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
    final selectedGuard = _selectedGuard();
    final theftReduction =
        (((selectedGuard?['theftReductionPercentage'] as num?) ?? 0).toDouble())
            .toStringAsFixed(0);
    final reputation = ((selectedGuard?['reputation'] as num?) ?? 0)
        .toDouble()
        .toStringAsFixed(2);

    return _mafiaPanel(
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
              isExpanded: true,
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
            if (selectedGuard != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _kpiChip(
                    _l('Level', 'Level'),
                    'Lv ${selectedGuard['skillLevel']}',
                  ),
                  _kpiChip(
                    _l('Diefstalreductie', 'Theft reduction'),
                    '$theftReduction%',
                  ),
                  _kpiChip(
                    _l('Shift kosten', 'Shift cost'),
                    '€${selectedGuard['costPerShift']}',
                  ),
                  _kpiChip(_l('Reputatie', 'Reputation'), reputation),
                  _kpiChip(
                    _l('Specialiteit', 'Specialty'),
                    (selectedGuard['specialty'] ?? '-').toString(),
                  ),
                ],
              ),
            ],
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
    final selected = _selectedStoreOption(options);
    final selectedMax = _selectedStoreMax(options);
    final storedAll = _nightclubStoredDrugs();
    final stored = storedAll
        .where((row) => ((row['quantity'] as num?)?.toInt() ?? 0) > 0)
        .toList();
    final totalStoredGrams = stored.fold<int>(
      0,
      (sum, row) => sum + ((row['quantity'] as num?)?.toInt() ?? 0),
    );

    return _mafiaPanel(
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
              isExpanded: true,
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
                          Expanded(
                            child: Text(
                              '${o['quantity']}g • ${o['drugName']} (${o['quality']})',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() {
                  _selectedDrugKey = v;
                  final max = _selectedStoreMax(options);
                  if (max > 0 && _storeQuantity > max) {
                    _setStoreQuantityValue(max);
                  }
                });
              },
              decoration: InputDecoration(labelText: _t.nightclubChooseStock),
            ),
            if (selected != null) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _kpiChip(
                    _l('Geselecteerd', 'Selected'),
                    '${selected['drugName']} (${selected['quality']})',
                  ),
                  _kpiChip(
                    _l('Beschikbaar', 'Available'),
                    '${selected['quantity']}g',
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            TextField(
              controller: _storeQuantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: _t.nightclubAmountGrams),
              onChanged: (v) {
                final parsed = int.tryParse(v);
                if (parsed != null && parsed > 0) {
                  _storeQuantity = parsed;
                }
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final amount in const [10, 25, 50, 100, 250])
                  ActionChip(
                    label: Text('${amount}g'),
                    onPressed: () {
                      final max = _selectedStoreMax(options);
                      final target = max > 0 ? amount.clamp(1, max) : amount;
                      setState(() => _setStoreQuantityValue(target));
                    },
                  ),
                ActionChip(
                  label: Text(_l('MAX', 'MAX')),
                  onPressed: selectedMax > 0
                      ? () =>
                            setState(() => _setStoreQuantityValue(selectedMax))
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _selectedDrugKey == null || selectedMax <= 0
                  ? null
                  : () {
                      final clamped = _storeQuantity.clamp(1, selectedMax);
                      if (clamped != _storeQuantity) {
                        setState(() => _setStoreQuantityValue(clamped));
                      }
                      _storeDrugs();
                    },
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

  Widget _operationsCard() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final operations =
        (data['operations'] as Map<String, dynamic>?) ?? const {};
    final resident =
        (operations['residentDj'] as Map<String, dynamic>?) ?? const {};
    final morale = (operations['morale'] as Map<String, dynamic>?) ?? const {};
    final upgrades =
        (operations['upgrades'] as Map<String, dynamic>?) ?? const {};
    final soundRig =
        (upgrades['soundRig'] as Map<String, dynamic>?) ?? const {};
    final vipLounge =
        (upgrades['vipLounge'] as Map<String, dynamic>?) ?? const {};
    final surveillance =
        (upgrades['surveillance'] as Map<String, dynamic>?) ?? const {};
    final alerts = (operations['alerts'] as List<dynamic>?) ?? const [];
    final eventTemplates =
        (operations['eventTemplates'] as List<dynamic>?) ?? const [];
    final events = (operations['events'] as List<dynamic>?) ?? const [];
    final expansion =
        (operations['expansion'] as Map<String, dynamic>?) ?? const {};
    final policeHeat =
        (expansion['policeHeat'] as Map<String, dynamic>?) ?? const {};
    final supplierContracts =
        (expansion['supplierContracts'] as Map<String, dynamic>?) ?? const {};
    final promoters =
        (expansion['promoters'] as Map<String, dynamic>?) ?? const {};
    final dynamicCalendar =
        (expansion['dynamicCalendar'] as Map<String, dynamic>?) ?? const {};
    final vipClientele =
        (expansion['vipClientele'] as Map<String, dynamic>?) ?? const {};
    final staffTraits = (expansion['staffTraits'] as List<dynamic>?) ?? const [];
    final smuggling = (expansion['smuggling'] as Map<String, dynamic>?) ?? const {};
    final smugglingCooldownActive = smuggling['cooldownActive'] == true;
    final smugglingCooldownRemainingMinutes =
        (smuggling['cooldownRemainingMinutes'] as num?)?.toInt() ?? 0;
    final reputation =
        (expansion['reputationSeason'] as Map<String, dynamic>?) ?? const {};
    final counterIntel =
        (expansion['counterIntel'] as Map<String, dynamic>?) ?? const {};
    final hospitality =
        (expansion['hospitality'] as Map<String, dynamic>?) ?? const {};
    final timeline = (expansion['timeline'] as List<dynamic>?) ?? const [];

    String formatDate(dynamic value) {
      final parsed = DateTime.tryParse((value ?? '').toString());
      if (parsed == null) return '-';
      final local = parsed.toLocal();
      final mm = local.minute.toString().padLeft(2, '0');
      return '${local.day}/${local.month} ${local.hour}:$mm';
    }

    return _mafiaPanel(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _l('Operations Lab (11 systemen)', 'Operations Lab (11 systems)'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFFFE3A0),
              ),
            ),
            const SizedBox(height: 8),
            _intelligenceSectionTitle(
              _l('1) Resident DJ contract', '1) Resident DJ contract'),
              Icons.library_music,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _l('Actief', 'Active'),
                  resident['isActive'] == true
                      ? _l('Ja', 'Yes')
                      : _l('Nee', 'No'),
                ),
                _kpiChip(
                  _l('Contract korting', 'Contract discount'),
                  '${resident['discountPct'] ?? 12}%',
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _residentDays,
              items: const [3, 7, 14]
                  .map(
                    (d) => DropdownMenuItem(
                      value: d,
                      child: Text('$d ${d == 1 ? 'day' : 'days'}'),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _residentDays = v ?? 7),
              decoration: InputDecoration(
                labelText: _l('Contract duur', 'Contract duration'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _selectedDjId == null ? null : _hireResidentDj,
              icon: const Icon(Icons.verified),
              label: Text(
                _l('Start resident contract', 'Start resident contract'),
              ),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('2) Dynamic event kalender', '2) Dynamic event calendar'),
              Icons.event,
            ),
            if (dynamicCalendar.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _kpiChip(
                  _l('Aanbevolen vandaag', 'Recommended today'),
                  Localizations.localeOf(context).languageCode == 'nl'
                      ? ((dynamicCalendar['today'] as Map<String, dynamic>?)?['nl'] ?? '-')
                            .toString()
                      : ((dynamicCalendar['today'] as Map<String, dynamic>?)?['en'] ?? '-')
                            .toString(),
                ),
              ),
            if (eventTemplates.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedEventType,
                items: eventTemplates.map((raw) {
                  final map = raw as Map<String, dynamic>;
                  final key = map['key']?.toString() ?? '';
                  final label =
                      Localizations.localeOf(context).languageCode == 'nl'
                      ? (map['labelNl'] ?? key).toString()
                      : (map['labelEn'] ?? key).toString();
                  return DropdownMenuItem(
                    value: key,
                    child: Text('$label • €${map['investment'] ?? 0}'),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _selectedEventType = v);
                },
                decoration: InputDecoration(
                  labelText: _l('Event template', 'Event template'),
                ),
              ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _scheduleNightclubEvent,
              icon: const Icon(Icons.event_available),
              label: Text(_l('Plan event (+5 min)', 'Schedule event (+5 min)')),
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                _l('Komende events', 'Upcoming events'),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              ...events.take(3).map((raw) {
                final map = raw as Map<String, dynamic>;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text((map['eventName'] ?? '-').toString()),
                  subtitle: Text(
                    '€${map['investment'] ?? 0} • +${map['expectedVisitors'] ?? 0}',
                  ),
                );
              }),
            ],
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('3) Upgrade tree', '3) Upgrade tree'),
              Icons.account_tree,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _l('Sound rig', 'Sound rig'),
                  'Lv ${soundRig['level'] ?? 1}',
                ),
                _kpiChip(
                  _l('VIP lounge', 'VIP lounge'),
                  'Lv ${vipLounge['level'] ?? 1}',
                ),
                _kpiChip(
                  _l('Surveillance', 'Surveillance'),
                  'Lv ${surveillance['level'] ?? 1}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedUpgradeType,
              items: [
                DropdownMenuItem(
                  value: 'sound_rig',
                  child: Text(
                    '${_l('Sound rig', 'Sound rig')} (${soundRig['nextCost'] != null ? '€${soundRig['nextCost']}' : _l('MAX', 'MAX')})',
                  ),
                ),
                DropdownMenuItem(
                  value: 'vip_lounge',
                  child: Text(
                    '${_l('VIP lounge', 'VIP lounge')} (${vipLounge['nextCost'] != null ? '€${vipLounge['nextCost']}' : _l('MAX', 'MAX')})',
                  ),
                ),
                DropdownMenuItem(
                  value: 'surveillance',
                  child: Text(
                    '${_l('Surveillance', 'Surveillance')} (${surveillance['nextCost'] != null ? '€${surveillance['nextCost']}' : _l('MAX', 'MAX')})',
                  ),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedUpgradeType = v);
              },
              decoration: InputDecoration(
                labelText: _l('Kies upgrade', 'Choose upgrade'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: () {
                final selected = _selectedUpgradeType == 'sound_rig'
                    ? soundRig
                    : _selectedUpgradeType == 'vip_lounge'
                    ? vipLounge
                    : surveillance;
                if (selected['nextCost'] == null) {
                  _showResultMessage({
                    'message': _l(
                      'Deze upgrade zit al op max level.',
                      'This upgrade is already max level.',
                    ),
                  }, _l('Upgrade al maximaal', 'Upgrade already maxed'));
                  return;
                }
                _applyUpgradeTreeChoice();
              },
              icon: const Icon(Icons.upgrade),
              label: Text(_l('Upgrade nu', 'Upgrade now')),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _marketingAmount,
              items: const [25000, 50000, 100000, 200000]
                  .map((v) => DropdownMenuItem(value: v, child: Text('€$v')))
                  .toList(),
              onChanged: (v) => setState(() => _marketingAmount = v ?? 50000),
              decoration: InputDecoration(
                labelText: _l('Marketing investering', 'Marketing investment'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _investMarketing,
              icon: const Icon(Icons.trending_up),
              label: Text(_l('Investeer in marketing', 'Invest in marketing')),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('4) Police heat & incidents', '4) Police heat & incidents'),
              Icons.crisis_alert,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_l('Heat', 'Heat'), '${policeHeat['value'] ?? 0}'),
                _kpiChip(
                  _l('Raid risico', 'Raid risk'),
                  '${policeHeat['raidRiskPct'] ?? 0}%',
                ),
                _kpiChip(
                  _l('Cooldown', 'Cooldown'),
                  policeHeat['cooldownActive'] == true
                      ? _l('Actief', 'Active')
                      : _l('Uit', 'Off'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _runHeatCooldownAction,
              icon: const Icon(Icons.shield_moon),
              label: Text(_l('Start heat cooldown', 'Start heat cooldown')),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => _respondToIncident('bribe'),
                  child: Text(_l('Omkopen', 'Bribe')),
                ),
                OutlinedButton(
                  onPressed: () => _respondToIncident('lockdown'),
                  child: Text(_l('Lockdown', 'Lockdown')),
                ),
                OutlinedButton(
                  onPressed: () => _respondToIncident('counterintel'),
                  child: Text(_l('Counter-intel', 'Counter-intel')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('5) Staff fatigue & morale', '5) Staff fatigue & morale'),
              Icons.psychology,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_l('Morale', 'Morale'), '${morale['morale'] ?? 1}'),
                _kpiChip(_l('Fatigue', 'Fatigue'), '${morale['fatigue'] ?? 1}'),
                _kpiChip(
                  _l('Bezetting', 'Staffing'),
                  '${morale['assignedStaff'] ?? 0}/${morale['staffCap'] ?? 0}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('6) Supplier & promoter', '6) Supplier & promoter'),
              Icons.local_shipping,
            ),
            DropdownButtonFormField<String>(
              value: _selectedSupplierContract,
              items: ((supplierContracts['options'] as List<dynamic>?) ?? const [])
                  .map((raw) {
                    final map = raw as Map<String, dynamic>;
                    final key = (map['key'] ?? '').toString();
                    final label = Localizations.localeOf(context).languageCode == 'nl'
                        ? (map['labelNl'] ?? key).toString()
                        : (map['labelEn'] ?? key).toString();
                    return DropdownMenuItem(value: key, child: Text(label));
                  })
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedSupplierContract = v);
              },
              decoration: InputDecoration(
                labelText: _l('Supplier contract', 'Supplier contract'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _activateSupplierContract,
              icon: const Icon(Icons.playlist_add_check),
              label: Text(_l('Activeer supplier', 'Activate supplier')),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedPromoterProfile,
              items: ((promoters['options'] as List<dynamic>?) ?? const []).map((raw) {
                final map = raw as Map<String, dynamic>;
                final key = (map['key'] ?? '').toString();
                final label = Localizations.localeOf(context).languageCode == 'nl'
                    ? (map['labelNl'] ?? key).toString()
                    : (map['labelEn'] ?? key).toString();
                return DropdownMenuItem(value: key, child: Text(label));
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedPromoterProfile = v);
              },
              decoration: InputDecoration(
                labelText: _l('Promoter profiel', 'Promoter profile'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _hirePromoterProfile,
              icon: const Icon(Icons.record_voice_over),
              label: Text(_l('Huur promoter', 'Hire promoter')),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('7) VIP clientele & staff traits', '7) VIP clientele & staff traits'),
              Icons.workspace_premium,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_l('VIP share', 'VIP share'), '${vipClientele['sharePct'] ?? 0}%'),
                _kpiChip(
                  _l('Spend x', 'Spend x'),
                  '${vipClientele['spendMultiplier'] ?? 1}',
                ),
                _kpiChip(
                  _l('Tier', 'Tier'),
                  '${reputation['tier'] ?? '-'}',
                ),
              ],
            ),
            ...staffTraits.take(2).map((raw) {
              final map = raw as Map<String, dynamic>;
              final title = Localizations.localeOf(context).languageCode == 'nl'
                  ? (map['nl'] ?? '-').toString()
                  : (map['en'] ?? '-').toString();
              final effect = Localizations.localeOf(context).languageCode == 'nl'
                  ? (map['effectNl'] ?? '-').toString()
                  : (map['effectEn'] ?? '-').toString();
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(title),
                subtitle: Text(effect),
              );
            }),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('8) Smuggling routes', '8) Smuggling routes'),
              Icons.route,
            ),
            _kpiChip(
              _l('Cooldown', 'Cooldown'),
              smugglingCooldownActive
                  ? _formatRemainingMinutesLabel(smugglingCooldownRemainingMinutes)
                  : _l('Klaar', 'Ready'),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedSmugglingRoute,
              items: ((smuggling['options'] as List<dynamic>?) ?? const []).map((raw) {
                final map = raw as Map<String, dynamic>;
                final key = (map['key'] ?? '').toString();
                final label = Localizations.localeOf(context).languageCode == 'nl'
                    ? (map['labelNl'] ?? key).toString()
                    : (map['labelEn'] ?? key).toString();
                return DropdownMenuItem(value: key, child: Text(label));
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedSmugglingRoute = v);
              },
              decoration: InputDecoration(labelText: _l('Route', 'Route')),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: smugglingCooldownActive ? null : _runSmugglingRouteAction,
              icon: const Icon(Icons.local_shipping),
              label: Text(_l('Start route', 'Start route')),
            ),
            const SizedBox(height: 6),
            Text(
              '${_l('Laatste route', 'Last route')}: ${smuggling['lastRouteKey'] ?? '-'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (smugglingCooldownActive)
              Text(
                _l(
                  'Route-lock actief tot ${formatDate(smuggling['cooldownEndsAt'])}',
                  'Route lock active until ${formatDate(smuggling['cooldownEndsAt'])}',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('9) Bar & Kitchen management', '9) Bar & Kitchen management'),
              Icons.restaurant_menu,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _l('Service level', 'Service level'),
                  '${hospitality['serviceLevel'] ?? 0}%',
                ),
                _kpiChip(
                  _l('Stock status', 'Stock status'),
                  (hospitality['stockStatus'] ?? '-').toString(),
                ),
                _kpiChip(
                  _l('Bederfrisico', 'Spoilage risk'),
                  '${hospitality['spoilageRiskPct'] ?? 0}%',
                ),
              ],
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedHospitalityPack,
              items: ((hospitality['stockOptions'] as List<dynamic>?) ?? const []).map((raw) {
                final map = raw as Map<String, dynamic>;
                final key = (map['key'] ?? '').toString();
                final label = Localizations.localeOf(context).languageCode == 'nl'
                    ? (map['labelNl'] ?? key).toString()
                    : (map['labelEn'] ?? key).toString();
                return DropdownMenuItem(
                  value: key,
                  child: Text('$label • €${map['cost'] ?? 0}'),
                );
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedHospitalityPack = v);
              },
              decoration: InputDecoration(
                labelText: _l('Drank/Food voorraad', 'Drinks/Food stock'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _buyHospitalityStock,
              icon: const Icon(Icons.local_bar),
              label: Text(_l('Voorraad inkopen', 'Buy stock')),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedHospitalityPricing,
              items: ((hospitality['pricingOptions'] as List<dynamic>?) ?? const []).map((raw) {
                final map = raw as Map<String, dynamic>;
                final key = (map['key'] ?? '').toString();
                final label = Localizations.localeOf(context).languageCode == 'nl'
                    ? (map['labelNl'] ?? key).toString()
                    : (map['labelEn'] ?? key).toString();
                return DropdownMenuItem(value: key, child: Text(label));
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedHospitalityPricing = v);
              },
              decoration: InputDecoration(
                labelText: _l('Menu pricing mode', 'Menu pricing mode'),
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _setHospitalityPricingMode,
              icon: const Icon(Icons.price_change),
              label: Text(_l('Pricing toepassen', 'Apply pricing')),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('10) Rival clubs + counter-intel', '10) Rival clubs + counter-intel'),
              Icons.sports_mma,
            ),
            TextField(
              controller: _rivalSearchController,
              decoration: InputDecoration(
                labelText: _l('Zoek spelernaam', 'Search player name'),
                suffixIcon: IconButton(
                  onPressed: _searchRivals,
                  icon: const Icon(Icons.search),
                ),
              ),
              onSubmitted: (_) => _searchRivals(),
            ),
            const SizedBox(height: 6),
            if (_rivalSearchResults.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedRivalName,
                isExpanded: true,
                items: _rivalSearchResults.map((raw) {
                  final map = raw as Map<String, dynamic>;
                  final name = (map['ownerName'] ?? '').toString();
                  return DropdownMenuItem(
                    value: name,
                    child: Text(
                      '$name • ${map['country'] ?? '-'} • crowd ${map['crowdSize'] ?? 0}%',
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedRivalName = v),
                decoration: InputDecoration(
                  labelText: _l('Doelwit (naam)', 'Target (name)'),
                ),
              ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(
                  onPressed: _selectedRivalName == null
                      ? null
                      : () => _runRivalAction('sabotage'),
                  child: Text(_l('Sabotage', 'Sabotage')),
                ),
                FilledButton(
                  onPressed: _selectedRivalName == null
                      ? null
                      : () => _runRivalAction('promo_war'),
                  child: Text(_l('Promo war', 'Promo war')),
                ),
                OutlinedButton(
                  onPressed: _runCounterIntelSweep,
                  child: Text(_l('Counter-intel sweep', 'Counter-intel sweep')),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${_l('Mitigatie', 'Mitigation')}: ${counterIntel['mitigationPct'] ?? 0}% | ${_l('Actief', 'Active')}: ${counterIntel['active'] == true ? _l('Ja', 'Yes') : _l('Nee', 'No')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('11) Operations timeline', '11) Operations timeline'),
              Icons.timeline,
            ),
            if (timeline.isEmpty)
              Text(_l('Geen timeline events.', 'No timeline events.')),
            ...timeline.take(6).map((raw) {
              final map = raw as Map<String, dynamic>;
              final severity = (map['severity'] ?? 'low').toString();
              final color = severity == 'high'
                  ? Colors.redAccent
                  : (severity == 'medium'
                        ? Colors.orangeAccent
                        : Colors.lightGreenAccent);
              final label = Localizations.localeOf(context).languageCode == 'nl'
                  ? (map['labelNl'] ?? '-').toString()
                  : (map['labelEn'] ?? '-').toString();
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.fiber_manual_record, color: color, size: 12),
                title: Text(label),
                subtitle: Text(formatDate(map['at'])),
              );
            }),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _l('Operations alerts', 'Operations alerts'),
              Icons.notifications_active,
            ),
            if (alerts.isEmpty)
              Text(_l('Geen kritieke alerts.', 'No critical alerts.')),
            ...alerts.map((raw) {
              final map = raw as Map<String, dynamic>;
              final severity = (map['severity'] ?? 'low').toString();
              final color = severity == 'high'
                  ? Colors.redAccent
                  : (severity == 'medium'
                        ? Colors.orangeAccent
                        : Colors.lightGreenAccent);
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.report_gmailerrorred,
                  color: color,
                  size: 18,
                ),
                title: Text((map['message'] ?? '-').toString()),
                subtitle: Text(
                  '${_l('Quick action', 'Quick action')}: ${map['quickAction'] ?? '-'}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _managementTabs() {
    final screenHeight = MediaQuery.of(context).size.height;
    final compact = _isCompactLayout();
    final tabBodyHeight = (screenHeight * 0.62).clamp(420.0, 780.0);

    return _mafiaPanel(
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
              labelColor: const Color(0xFFFFE3A0),
              unselectedLabelColor: Colors.white70,
              indicatorColor: const Color(0xFFD4A24D),
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
                Tab(
                  text: _l('Ops Lab', 'Ops Lab'),
                  icon: Icon(
                    Icons.precision_manufacturing,
                    size: _tabIconSize(),
                  ),
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
                  SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: _operationsCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nightclubIntelligenceCard() {
    final statsData = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final crowd = (statsData['crowdSize'] as num?)?.toInt() ?? 0;
    final revenueToday = (statsData['revenueToday'] as num?)?.toInt() ?? 0;
    final revenueAllTime = (statsData['revenueAllTime'] as num?)?.toInt() ?? 0;
    final inventoryValue = (statsData['inventoryValue'] as num?)?.toInt() ?? 0;
    final djActive = statsData['djActive'] == true;
    final sales = (statsData['recentSales'] as List<dynamic>?) ?? const [];
    final thefts = (statsData['thefts'] as List<dynamic>?) ?? const [];
    final prostitution =
        (statsData['prostitution'] as Map<String, dynamic>?) ?? const {};
    final staffCap = (prostitution['staffCap'] ?? 0).toString();
    final staffCount = (prostitution['assignedCount'] ?? 0).toString();
    final vipActive = prostitution['isVipBoostActive'] == true;
    final season = _seasonSummary ?? const {};
    final seasonLeaders =
        (season['currentLeaderboard'] as List<dynamic>?) ?? const [];
    final endAt = DateTime.tryParse((season['seasonEndAt'] ?? '').toString());
    final now = DateTime.now().toUtc();
    final remaining = endAt != null ? endAt.difference(now) : const Duration();
    final remainingText = remaining.isNegative
        ? _t.nightclubSeasonProcessing
        : '${remaining.inDays}d ${remaining.inHours % 24}h ${remaining.inMinutes % 60}m';

    return _mafiaPanel(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _l('Nightclub Intelligence', 'Nightclub Intelligence'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFFFE3A0),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _leaderboardScope,
                  dropdownColor: const Color(0xFF1A130E),
                  style: const TextStyle(color: Colors.white),
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
            const SizedBox(height: 10),
            _intelligenceSectionTitle(
              _l('Live statistieken', 'Live statistics'),
              Icons.bar_chart_rounded,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_t.nightclubKpiCrowd, '$crowd%'),
                _kpiChip(
                  _t.nightclubKpiVibe,
                  _localizedVibe(
                    (statsData['crowdVibe'] ?? 'chill').toString(),
                  ),
                ),
                _kpiChip(_t.nightclubKpiToday, '€$revenueToday'),
                _kpiChip(_t.nightclubKpiAllTime, '€$revenueAllTime'),
                _kpiChip(_t.nightclubKpiStock, '€$inventoryValue'),
                _kpiChip(
                  _t.nightclubKpiDj,
                  djActive ? _t.nightclubStatusActive : _t.nightclubStatusOff,
                ),
                _kpiChip(_t.nightclubKpiThefts, '${thefts.length}'),
                _kpiChip(_t.nightclubKpiStaff, '$staffCount/$staffCap'),
                _kpiChip(
                  _t.nightclubKpiVipBonus,
                  vipActive ? _t.nightclubStatusActive : _t.nightclubStatusOff,
                ),
              ],
            ),
            const SizedBox(height: 10),
            _intelligenceSectionTitle(
              _t.nightclubRevenueTrend,
              Icons.show_chart,
            ),
            SizedBox(
              height: 90,
              child: CustomPaint(
                painter: _SparklinePainter(_revenueTrend),
                child: Container(),
              ),
            ),
            const SizedBox(height: 10),
            _intelligenceSectionTitle(
              _l('Seizoen status', 'Season status'),
              Icons.workspace_premium,
            ),
            Text('${_t.nightclubSeasonResetIn}: $remainingText'),
            Text(
              '${_t.nightclubSeasonYourRewards}: €${season['yourTotalSeasonRewards'] ?? 0}',
            ),
            if (seasonLeaders.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...seasonLeaders.take(3).map((entry) {
                final map = entry as Map<String, dynamic>;
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 12,
                    child: Text('${map['rank'] ?? '-'}'),
                  ),
                  title: Text(
                    '${map['ownerUsername'] ?? 'unknown'} • ${map['country'] ?? '-'}',
                  ),
                  trailing: Text(
                    '€${map['weeklyRevenue'] ?? 0}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                );
              }),
            ],
            const SizedBox(height: 10),
            _intelligenceSectionTitle(
              _t.nightclubLeaderboardTitle,
              Icons.leaderboard,
            ),
            if (_leaderboard.isEmpty) Text(_t.nightclubLeaderboardEmpty),
            ..._leaderboard.take(5).map((entry) {
              final map = entry as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 12,
                  child: Text('${map['rank'] ?? '-'}'),
                ),
                title: Text('${map['ownerUsername'] ?? 'unknown'}'),
                subtitle: Text(
                  '${_t.nightclubLeaderboardRevenue24h}: €${map['revenue24h'] ?? 0}',
                ),
                trailing: Text(
                  '★${map['score'] ?? 0}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              );
            }),
            const SizedBox(height: 10),
            _intelligenceSectionTitle(
              _t.nightclubSalesTitle,
              Icons.point_of_sale,
            ),
            if (sales.isEmpty) Text(_t.nightclubSalesEmpty),
            ...sales.take(4).map((raw) {
              final map = raw as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${map['drugType']} (${map['quality']}) x${map['quantitySold']}g',
                ),
                subtitle: Text(
                  '${_t.nightclubKpiVibe}: ${_localizedVibe((map['crowdVibe'] ?? '').toString())}',
                ),
                trailing: Text('€${map['totalRevenue'] ?? 0}'),
              );
            }),
            const SizedBox(height: 10),
            _intelligenceSectionTitle(
              _t.nightclubTheftTitle,
              Icons.warning_amber_rounded,
            ),
            if (thefts.isEmpty) Text(_t.nightclubTheftEmpty),
            ...thefts.take(4).map((raw) {
              final map = raw as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: Colors.orangeAccent,
                ),
                title: Text(
                  '${_localizedTheftType((map['theftType'] ?? '').toString())} • ${map['drugType']}',
                ),
                subtitle: Text('${map['quantityStolen'] ?? 0}g'),
                trailing: Text('€${map['valueLost'] ?? 0}'),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _intelligenceSectionTitle(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFD4A24D)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFE3A0),
            ),
          ),
        ],
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

