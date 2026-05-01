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

class _NightclubScreenState extends State<NightclubScreen> {
  static const String _managementSectionCrew = 'crew';
  static const String _managementSectionDrugs = 'drugs';
  static const String _managementSectionDj = 'dj';
  static const String _managementSectionSecurity = 'security';
  static const String _managementSectionOpsLab = 'ops';

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
  String _selectedManagementSection = _managementSectionCrew;
  List<dynamic> _rivalSearchResults = const [];
  late final TextEditingController _storeQuantityController;
  late final TextEditingController _rivalSearchController;

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

  String _apiOptionLabel(Map<String, dynamic> map) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'nl') {
      return (map['labelNl'] ?? map['nl'] ?? map['key'] ?? '').toString();
    }
    return (map['labelEn'] ?? map['en'] ?? map['key'] ?? '').toString();
  }

  String _pickLocaleField(
    Map<String, dynamic> map,
    String nlKey,
    String enKey, [
    String fallback = '-',
  ]) {
    final code = Localizations.localeOf(context).languageCode;
    final v = code == 'nl' ? map[nlKey] : map[enKey];
    return v?.toString() ?? fallback;
  }

  String _localizeNightclubApiMessage(String raw) {
    final t = _t;
    if (raw.startsWith('Error:')) {
      return t.nightclubErrorWithDetail(raw.substring(6).trimLeft());
    }
    switch (raw) {
      case 'Could not load nightclub stats':
        return t.nightclubServiceErrorStats;
      case 'Could not load leaderboard':
        return t.nightclubServiceErrorLeaderboard;
      case 'Could not load season ranking':
        return t.nightclubServiceErrorSeason;
      default:
        return raw;
    }
  }

  String _formatRemainingMinutesLabel(int minutesRaw) {
    final minutes = minutesRaw < 0 ? 0 : minutesRaw;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours <= 0) {
      return _t.nightclubTimeMinutes('$minutes');
    }
    if (remainingMinutes <= 0) {
      return _t.nightclubTimeHoursOnly('$hours');
    }
    return _t.nightclubTimeHoursMinutes('$hours', '$remainingMinutes');
  }

  bool _isVipVariant(dynamic variantRaw) {
    final variant = (variantRaw as num?)?.toInt() ?? 0;
    return variant >= 6 && variant <= 10;
  }

  String _vipStatusLabel(dynamic variantRaw) {
    return _isVipVariant(variantRaw)
        ? _t.nightclubBadgeVip
        : _t.nightclubBadgeStandard;
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
    if (djId == null) return _t.unknown;
    for (final dj in _djs) {
      final map = dj as Map<String, dynamic>;
      if ((map['id'] as num?)?.toInt() == djId) {
        return (map['name'] ?? _t.unknown).toString();
      }
    }
    return _t.unknown;
  }

  String _guardNameById(int? guardId) {
    if (guardId == null) return _t.unknown;
    for (final guard in _guards) {
      final map = guard as Map<String, dynamic>;
      if ((map['id'] as num?)?.toInt() == guardId) {
        return (map['name'] ?? _t.unknown).toString();
      }
    }
    return _t.unknown;
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
    _load();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _storeQuantityController.dispose();
    _rivalSearchController.dispose();
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
              _t.nightclubErrorLoading('$e'),
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

    final raw = result['message']?.toString();
    final message = (raw != null && raw.isNotEmpty)
        ? _localizeNightclubApiMessage(raw)
        : fallbackMessage;
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
      _t.nightclubResidentDjContractFailed,
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
      _t.nightclubScheduleEventFailed,
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
      _t.nightclubMarketingUpgradeFailed,
    );
    await _load();
  }

  Future<void> _applyUpgradeTreeChoice() async {
    if (_venueId == null) return;
    final result = await _nightclubService.applyUpgrade(
      venueId: _venueId!,
      upgradeType: _selectedUpgradeType,
    );
    _showResultMessage(result, _t.nightclubUpgradeFailed);
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
      _t.nightclubIncidentResponseFailed,
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
      _t.nightclubRivalActionFailed,
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
      _t.nightclubSupplierContractFailed,
    );
    await _load();
  }

  Future<void> _hirePromoterProfile() async {
    if (_venueId == null) return;
    final result = await _nightclubService.hirePromoter(
      venueId: _venueId!,
      profileType: _selectedPromoterProfile,
    );
    _showResultMessage(result, _t.nightclubPromoterFailed);
    await _load();
  }

  Future<void> _runHeatCooldownAction() async {
    if (_venueId == null) return;
    final result = await _nightclubService.runHeatCooldown(venueId: _venueId!);
    _showResultMessage(
      result,
      _t.nightclubHeatCooldownFailed,
    );
    await _load();
  }

  Future<void> _runSmugglingRouteAction() async {
    if (_venueId == null) return;
    final result = await _nightclubService.runSmugglingRoute(
      venueId: _venueId!,
      routeType: _selectedSmugglingRoute,
    );
    _showResultMessage(result, _t.nightclubSmugglingFailed);
    await _load();
  }

  Future<void> _runCounterIntelSweep() async {
    if (_venueId == null) return;
    final result = await _nightclubService.runCounterIntel(venueId: _venueId!);
    _showResultMessage(
      result,
      _t.nightclubCounterIntelFailed,
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
      _t.nightclubHospitalityStockFailed,
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
      _t.nightclubHospitalityPricingFailed,
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
                _t.nightclubCurrentVisitorsPct('$crowd'),
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
              _t.nightclubCommandDeckTitle,
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
                _kpiChip(_t.nightclubKpiVibe, vibe),
                _kpiChip(_t.nightclubKpiCrowd, '${crowd.toStringAsFixed(0)}%'),
                _kpiChip(
                  _t.nightclubOpsDeckRevenueToday,
                  '€$revenueToday',
                ),
                _kpiChip(_t.nightclubStockValueLabel, '€$inventoryValue'),
              ],
            ),
            const SizedBox(height: 12),
            _progressRow(
              _t.nightclubCrewOccupancy,
              '$staffCount/$staffCap',
              staffingRatio,
              Colors.cyanAccent,
            ),
            const SizedBox(height: 8),
            _progressRow(
              _t.nightclubOperationalRisk,
              _t.nightclubIncidents24h('$thefts'),
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
            _intelligenceSectionTitle(
              _t.nightclubActiveCrewShifts,
              Icons.groups_2,
            ),
            const SizedBox(height: 6),
            if (assignedStaff.isEmpty)
              Text(_t.nightclubNoCrewAssigned)
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final columns = maxWidth >= 980
                      ? 2
                      : (maxWidth >= 520 ? 2 : 1);
                  final extent = _isCompactLayout() ? 116.0 : 122.0;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: assignedStaff.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: extent,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final map = assignedStaff[index] as Map<String, dynamic>;
                      final id = (map['id'] as num).toInt();
                      final vipLabel = _vipStatusLabel(map['variant']);

                      return Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              _thumbFromImageRef(
                                fallbackAsset: _prostitutePortraitAsset(
                                  map['variant'],
                                ),
                                fallbackIcon: Icons.person,
                                size: 44,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${map['name']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$vipLabel • Lv ${map['level'] ?? 1}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 6),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            _unassignProstitute(id),
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(0, 30),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 0,
                                          ),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(_t.nightclubRemove),
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
                  );
                },
              ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubRecentCrewHistory,
              Icons.history,
            ),
            const SizedBox(height: 6),
            if (history.isEmpty) Text(_t.nightclubNoStaffHistory),
            ...history.take(8).map((h) {
              final map = h as Map<String, dynamic>;
              final prostitute =
                  (map['prostitute'] as Map<String, dynamic>?) ?? const {};
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
                  : (active ? _t.nightclubStatusActiveLower : '-');
              final estimatedRevenue = map['estimatedRevenue'] ?? 0;
              final estimatedSalesCount = map['estimatedSalesCount'] ?? 0;
              final vipLabel = _vipStatusLabel(prostitute['variant']);

              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: _thumbFromImageRef(
                  fallbackAsset: _prostitutePortraitAsset(
                    prostitute['variant'],
                  ),
                  fallbackIcon: active ? Icons.schedule : Icons.history,
                  size: 30,
                ),
                title: Text(
                  '${prostitute['name'] ?? _t.unknown} • $vipLabel (Lv ${prostitute['level'] ?? 1})',
                ),
                subtitle: Text(
                  '${_t.nightclubFrom}: $startText  |  ${_t.nightclubTo}: $endText\n${_t.nightclubRevenueImpact}: €$estimatedRevenue (${_t.nightclubSalesCountLabel}: $estimatedSalesCount)',
                ),
              );
            }),
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
    final djTimeClock = activeUntil == null
        ? null
        : '${activeUntil.hour.toString().padLeft(2, '0')}:${activeUntil.minute.toString().padLeft(2, '0')}';

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
                  ? '${_t.nightclubActiveDj}: $activeDjName${djTimeClock != null ? ' (${_t.nightclubUntilTime(djTimeClock)})' : ''}'
                  : _t.nightclubActiveDjNone,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (_djs.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _t.nightclubNoDjsLoaded,
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
                    _t.level,
                    'Lv ${selectedDj['skillLevel']}',
                  ),
                  _kpiChip(_t.nightclubCrowdBoost, 'x$crowdBoost'),
                  _kpiChip(
                    _t.nightclubCostPerHour,
                    '€${selectedDj['costPerHour']}/h',
                  ),
                  _kpiChip(_t.nightclubReputationLabel, reputation),
                  _kpiChip(
                    _t.nightclubSpecialtyLabel,
                    (selectedDj['specialty'] ?? '-').toString(),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _djHours,
              items: [4, 8, 12, 24]
                  .map(
                    (h) => DropdownMenuItem<int>(
                      value: h,
                      child: Text(_t.nightclubShiftHours('$h')),
                    ),
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
    final guardTimeClock = activeUntil == null
        ? null
        : '${activeUntil.hour.toString().padLeft(2, '0')}:${activeUntil.minute.toString().padLeft(2, '0')}';

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
                  ? '${_t.nightclubActiveSecurity}: $activeGuardName${guardTimeClock != null ? ' (${_t.nightclubUntilTime(guardTimeClock)})' : ''}'
                  : _t.nightclubActiveSecurityNone,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            if (_guards.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _t.nightclubNoSecurityLoaded,
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
                    _t.level,
                    'Lv ${selectedGuard['skillLevel']}',
                  ),
                  _kpiChip(
                    _t.nightclubTheftReduction,
                    '$theftReduction%',
                  ),
                  _kpiChip(
                    _t.nightclubShiftCost,
                    '€${selectedGuard['costPerShift']}',
                  ),
                  _kpiChip(_t.nightclubReputationLabel, reputation),
                  _kpiChip(
                    _t.nightclubSpecialtyLabel,
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
                    _t.nightclubSelectedStock,
                    '${selected['drugName']} (${selected['quality']})',
                  ),
                  _kpiChip(
                    _t.nightclubAvailableGrams,
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
                  label: Text(_t.nightclubMaxChip),
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
              _t.nightclubStoredInNightclub,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              _t.nightclubCurrentStockGrams('$totalStoredGrams'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            if (stored.isEmpty)
              Text(
                storedAll.isEmpty
                    ? _t.nightclubNoStoredDrugs
                    : _t.nightclubStockZeroSoldOut,
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
                                  _t.nightclubQualityWithValue(quality),
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
                                _t.nightclubGramsStock('$quantity'),
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
    final staffTraits =
        (expansion['staffTraits'] as List<dynamic>?) ?? const [];
    final smuggling =
        (expansion['smuggling'] as Map<String, dynamic>?) ?? const {};
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
              _t.nightclubOperationsLabTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFFFFE3A0),
              ),
            ),
            const SizedBox(height: 8),
            _intelligenceSectionTitle(
              _t.nightclubSectionResidentDjContract,
              Icons.library_music,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _t.nightclubStatusActive,
                  resident['isActive'] == true
                      ? _t.yes
                      : _t.no,
                ),
                _kpiChip(
                  _t.nightclubContractDiscount,
                  '${resident['discountPct'] ?? 12}%',
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _residentDays,
              items: [3, 7, 14]
                  .map(
                    (d) => DropdownMenuItem(
                      value: d,
                      child: Text(_t.nightclubContractDays(d)),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _residentDays = v ?? 7),
              decoration: InputDecoration(
                labelText: _t.nightclubContractDuration,
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _selectedDjId == null ? null : _hireResidentDj,
              icon: const Icon(Icons.verified),
              label: Text(
                _t.nightclubStartResidentContract,
              ),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionEventCalendar,
              Icons.event,
            ),
            if (dynamicCalendar.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _kpiChip(
                  _t.nightclubRecommendedToday,
                  _apiOptionLabel({
                    'labelNl': (dynamicCalendar['today']
                            as Map<String, dynamic>?)?['nl']
                        ?.toString(),
                    'labelEn': (dynamicCalendar['today']
                            as Map<String, dynamic>?)?['en']
                        ?.toString(),
                    'key': '-',
                  }),
                ),
              ),
            if (eventTemplates.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _selectedEventType,
                items: eventTemplates.map((raw) {
                  final map = raw as Map<String, dynamic>;
                  final key = map['key']?.toString() ?? '';
                  final label = _apiOptionLabel(map);
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
                  labelText: _t.nightclubEventTemplate,
                ),
              ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _scheduleNightclubEvent,
              icon: const Icon(Icons.event_available),
              label: Text(_t.nightclubScheduleEventFiveMin),
            ),
            if (events.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                _t.nightclubUpcomingEvents,
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
              _t.nightclubSectionUpgradeTree,
              Icons.account_tree,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _t.nightclubUpgradeSoundRig,
                  'Lv ${soundRig['level'] ?? 1}',
                ),
                _kpiChip(
                  _t.nightclubUpgradeVipLounge,
                  'Lv ${vipLounge['level'] ?? 1}',
                ),
                _kpiChip(
                  _t.nightclubUpgradeSurveillance,
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
                    _t.nightclubUpgradeWithCost(
                      _t.nightclubUpgradeSoundRig,
                      soundRig['nextCost'] != null
                          ? '€${soundRig['nextCost']}'
                          : _t.nightclubMaxChip,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'vip_lounge',
                  child: Text(
                    _t.nightclubUpgradeWithCost(
                      _t.nightclubUpgradeVipLounge,
                      vipLounge['nextCost'] != null
                          ? '€${vipLounge['nextCost']}'
                          : _t.nightclubMaxChip,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 'surveillance',
                  child: Text(
                    _t.nightclubUpgradeWithCost(
                      _t.nightclubUpgradeSurveillance,
                      surveillance['nextCost'] != null
                          ? '€${surveillance['nextCost']}'
                          : _t.nightclubMaxChip,
                    ),
                  ),
                ),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedUpgradeType = v);
              },
              decoration: InputDecoration(
                labelText: _t.nightclubChooseUpgrade,
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
                    'message': _t.nightclubUpgradeAlreadyMaxMessage,
                  }, _t.nightclubUpgradeAlreadyMaxed);
                  return;
                }
                _applyUpgradeTreeChoice();
              },
              icon: const Icon(Icons.upgrade),
              label: Text(_t.nightclubUpgradeNow),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _marketingAmount,
              items: const [25000, 50000, 100000, 200000]
                  .map((v) => DropdownMenuItem(value: v, child: Text('€$v')))
                  .toList(),
              onChanged: (v) => setState(() => _marketingAmount = v ?? 50000),
              decoration: InputDecoration(
                labelText: _t.nightclubMarketingInvestment,
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _investMarketing,
              icon: const Icon(Icons.trending_up),
              label: Text(_t.nightclubInvestMarketing),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionPoliceHeat,
              Icons.crisis_alert,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_t.nightclubHeatLabel, '${policeHeat['value'] ?? 0}'),
                _kpiChip(
                  _t.nightclubRaidRisk,
                  '${policeHeat['raidRiskPct'] ?? 0}%',
                ),
                _kpiChip(
                  _t.nightclubCooldownLabel,
                  policeHeat['cooldownActive'] == true
                      ? _t.nightclubStatusActive
                      : _t.nightclubStatusOff,
                ),
              ],
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _runHeatCooldownAction,
              icon: const Icon(Icons.shield_moon),
              label: Text(_t.nightclubStartHeatCooldown),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => _respondToIncident('bribe'),
                  child: Text(_t.nightclubBribe),
                ),
                OutlinedButton(
                  onPressed: () => _respondToIncident('lockdown'),
                  child: Text(_t.nightclubLockdown),
                ),
                OutlinedButton(
                  onPressed: () => _respondToIncident('counterintel'),
                  child: Text(_t.nightclubCounterIntelShort),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionStaffMorale,
              Icons.psychology,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_t.nightclubMorale, '${morale['morale'] ?? 1}'),
                _kpiChip(_t.nightclubFatigue, '${morale['fatigue'] ?? 1}'),
                _kpiChip(
                  _t.nightclubStaffing,
                  '${morale['assignedStaff'] ?? 0}/${morale['staffCap'] ?? 0}',
                ),
              ],
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionSupplierPromoter,
              Icons.local_shipping,
            ),
            DropdownButtonFormField<String>(
              value: _selectedSupplierContract,
              items:
                  ((supplierContracts['options'] as List<dynamic>?) ?? const [])
                      .map((raw) {
                        final map = raw as Map<String, dynamic>;
                        final key = (map['key'] ?? '').toString();
                        final label = _apiOptionLabel(map);
                        return DropdownMenuItem(value: key, child: Text(label));
                      })
                      .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedSupplierContract = v);
              },
              decoration: InputDecoration(
                labelText: _t.nightclubSupplierContract,
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _activateSupplierContract,
              icon: const Icon(Icons.playlist_add_check),
              label: Text(_t.nightclubActivateSupplier),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedPromoterProfile,
              items: ((promoters['options'] as List<dynamic>?) ?? const []).map(
                (raw) {
                  final map = raw as Map<String, dynamic>;
                  final key = (map['key'] ?? '').toString();
                  final label = _apiOptionLabel(map);
                  return DropdownMenuItem(value: key, child: Text(label));
                },
              ).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedPromoterProfile = v);
              },
              decoration: InputDecoration(
                labelText: _t.nightclubPromoterProfile,
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _hirePromoterProfile,
              icon: const Icon(Icons.record_voice_over),
              label: Text(_t.nightclubHirePromoter),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionVipClientele,
              Icons.workspace_premium,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _t.nightclubVipShare,
                  '${vipClientele['sharePct'] ?? 0}%',
                ),
                _kpiChip(
                  _t.nightclubSpendMultiplier,
                  '${vipClientele['spendMultiplier'] ?? 1}',
                ),
                _kpiChip(_t.nightclubTier, '${reputation['tier'] ?? '-'}'),
              ],
            ),
            ...staffTraits.take(2).map((raw) {
              final map = raw as Map<String, dynamic>;
              final title = _pickLocaleField(map, 'nl', 'en');
              final effect = _pickLocaleField(map, 'effectNl', 'effectEn');
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(title),
                subtitle: Text(effect),
              );
            }),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionSmugglingRoutes,
              Icons.route,
            ),
            _kpiChip(
              _t.nightclubCooldownLabel,
              smugglingCooldownActive
                  ? _formatRemainingMinutesLabel(
                      smugglingCooldownRemainingMinutes,
                    )
                  : _t.nightclubReady,
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedSmugglingRoute,
              items: ((smuggling['options'] as List<dynamic>?) ?? const []).map(
                (raw) {
                  final map = raw as Map<String, dynamic>;
                  final key = (map['key'] ?? '').toString();
                  final label = _apiOptionLabel(map);
                  return DropdownMenuItem(value: key, child: Text(label));
                },
              ).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedSmugglingRoute = v);
              },
              decoration: InputDecoration(labelText: _t.nightclubRoute),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: smugglingCooldownActive
                  ? null
                  : _runSmugglingRouteAction,
              icon: const Icon(Icons.local_shipping),
              label: Text(_t.nightclubStartRoute),
            ),
            const SizedBox(height: 6),
            Text(
              '${_t.nightclubLastRoute}: ${smuggling['lastRouteKey'] ?? '-'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (smugglingCooldownActive)
              Text(
                _t.nightclubRouteLockUntil(
                  formatDate(smuggling['cooldownEndsAt']),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionBarKitchen,
              Icons.restaurant_menu,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(
                  _t.nightclubServiceLevel,
                  '${hospitality['serviceLevel'] ?? 0}%',
                ),
                _kpiChip(
                  _t.nightclubStockStatus,
                  (hospitality['stockStatus'] ?? '-').toString(),
                ),
                _kpiChip(
                  _t.nightclubSpoilageRisk,
                  '${hospitality['spoilageRiskPct'] ?? 0}%',
                ),
              ],
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedHospitalityPack,
              items:
                  ((hospitality['stockOptions'] as List<dynamic>?) ?? const [])
                      .map((raw) {
                        final map = raw as Map<String, dynamic>;
                        final key = (map['key'] ?? '').toString();
                        final label = _apiOptionLabel(map);
                        return DropdownMenuItem(
                          value: key,
                          child: Text('$label • €${map['cost'] ?? 0}'),
                        );
                      })
                      .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedHospitalityPack = v);
              },
              decoration: InputDecoration(
                labelText: _t.nightclubDrinksFoodStock,
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _buyHospitalityStock,
              icon: const Icon(Icons.local_bar),
              label: Text(_t.nightclubBuyStock),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _selectedHospitalityPricing,
              items:
                  ((hospitality['pricingOptions'] as List<dynamic>?) ??
                          const [])
                      .map((raw) {
                        final map = raw as Map<String, dynamic>;
                        final key = (map['key'] ?? '').toString();
                        final label = _apiOptionLabel(map);
                        return DropdownMenuItem(value: key, child: Text(label));
                      })
                      .toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => _selectedHospitalityPricing = v);
              },
              decoration: InputDecoration(
                labelText: _t.nightclubMenuPricingMode,
              ),
            ),
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _setHospitalityPricingMode,
              icon: const Icon(Icons.price_change),
              label: Text(_t.nightclubApplyPricing),
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionRivals,
              Icons.sports_mma,
            ),
            TextField(
              controller: _rivalSearchController,
              decoration: InputDecoration(
                labelText: _t.nightclubSearchPlayerName,
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
                      _t.nightclubRivalCrowdLine(
                        name,
                        (map['country'] ?? '-').toString(),
                        '${map['crowdSize'] ?? 0}',
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedRivalName = v),
                decoration: InputDecoration(
                  labelText: _t.nightclubTargetName,
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
                  child: Text(_t.nightclubSabotage),
                ),
                FilledButton(
                  onPressed: _selectedRivalName == null
                      ? null
                      : () => _runRivalAction('promo_war'),
                  child: Text(_t.nightclubPromoWar),
                ),
                OutlinedButton(
                  onPressed: _runCounterIntelSweep,
                  child: Text(_t.nightclubCounterIntelSweep),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${_t.nightclubMitigation}: ${counterIntel['mitigationPct'] ?? 0}% | ${_t.nightclubStatusActive}: ${counterIntel['active'] == true ? _t.yes : _t.no}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubSectionTimeline,
              Icons.timeline,
            ),
            if (timeline.isEmpty)
              Text(_t.nightclubNoTimelineEvents),
            ...timeline.take(6).map((raw) {
              final map = raw as Map<String, dynamic>;
              final severity = (map['severity'] ?? 'low').toString();
              final color = severity == 'high'
                  ? Colors.redAccent
                  : (severity == 'medium'
                        ? Colors.orangeAccent
                        : Colors.lightGreenAccent);
              final label = _apiOptionLabel({
                'labelNl': map['labelNl'],
                'labelEn': map['labelEn'],
                'key': '-',
              });
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.fiber_manual_record,
                  color: color,
                  size: 12,
                ),
                title: Text(label),
                subtitle: Text(formatDate(map['at'])),
              );
            }),
            const SizedBox(height: 12),
            _intelligenceSectionTitle(
              _t.nightclubOperationsAlerts,
              Icons.notifications_active,
            ),
            if (alerts.isEmpty)
              Text(_t.nightclubNoCriticalAlerts),
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
                  '${_t.nightclubQuickAction}: ${map['quickAction'] ?? '-'}',
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<_ManagementSectionMeta> _managementSections() {
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final operations =
        (data['operations'] as Map<String, dynamic>?) ?? const {};
    final expansion =
        (operations['expansion'] as Map<String, dynamic>?) ?? const {};
    final smuggling =
        (expansion['smuggling'] as Map<String, dynamic>?) ?? const {};
    final smugglingCooldown = smuggling['cooldownActive'] == true;
    final smugglingMinutes =
        (smuggling['cooldownRemainingMinutes'] as num?)?.toInt() ?? 0;
    final opsAlerts = (operations['alerts'] as List<dynamic>?)?.length ?? 0;

    return [
      _ManagementSectionMeta(
        key: _managementSectionCrew,
        icon: Icons.groups_2_rounded,
        title: _t.nightclubMgmtCrewTitle,
        subtitle: _t.nightclubMgmtCrewSubtitle,
      ),
      _ManagementSectionMeta(
        key: _managementSectionDrugs,
        icon: Icons.science_rounded,
        title: _t.nightclubMgmtDrugsTitle,
        subtitle: _t.nightclubMgmtDrugsSubtitle,
      ),
      _ManagementSectionMeta(
        key: _managementSectionDj,
        icon: Icons.queue_music_rounded,
        title: _t.nightclubMgmtDjTitle,
        subtitle: _t.nightclubMgmtDjSubtitle,
      ),
      _ManagementSectionMeta(
        key: _managementSectionSecurity,
        icon: Icons.shield_moon_rounded,
        title: _t.nightclubMgmtSecurityTitle,
        subtitle: _t.nightclubMgmtSecuritySubtitle,
      ),
      _ManagementSectionMeta(
        key: _managementSectionOpsLab,
        icon: Icons.precision_manufacturing_rounded,
        title: _t.nightclubMgmtOpsLabTitle,
        subtitle: opsAlerts > 0
            ? _t.nightclubMgmtOpsLabSubtitleAlert(
                '$opsAlerts',
                smugglingCooldown
                    ? _formatRemainingMinutesLabel(smugglingMinutes)
                    : _t.nightclubReady,
              )
            : _t.nightclubMgmtOpsLabSubtitleDefault,
      ),
    ];
  }

  Widget _managementZoneCard({
    required _ManagementSectionMeta section,
    required bool selected,
  }) {
    final borderColor = selected
        ? const Color(0xFFD4A24D)
        : const Color(0x44D4A24D);
    final bgGradient = selected
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xCC3B2412), Color(0xAA2B180D), Color(0xCC150E0A)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0x77221311), Color(0x55201510), Color(0x7720120D)],
          );

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedManagementSection = section.key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: bgGradient,
          border: Border.all(color: borderColor),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x55000000),
                    blurRadius: 12,
                    offset: Offset(0, 5),
                  ),
                ]
              : const [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? const Color(0x33FFE3A0)
                    : const Color(0x22FFFFFF),
              ),
              child: Icon(
                section.icon,
                color: selected ? const Color(0xFFFFE3A0) : Colors.white70,
                size: 19,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: selected ? const Color(0xFFFFE3A0) : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    section.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: selected ? Colors.white : Colors.white70,
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

  Widget _managementSectionBody(String key) {
    switch (key) {
      case _managementSectionCrew:
        return _staffCard();
      case _managementSectionDrugs:
        return _storeCard();
      case _managementSectionDj:
        return _djCard();
      case _managementSectionSecurity:
        return _securityCard();
      case _managementSectionOpsLab:
        return _operationsCard();
      default:
        return _staffCard();
    }
  }

  Widget _managementTabs() {
    final compact = _isCompactLayout();
    final sections = _managementSections();
    final selectedSection = sections.firstWhere(
      (section) => section.key == _selectedManagementSection,
      orElse: () => sections.first,
    );
    final data = (_stats?['data'] as Map<String, dynamic>?) ?? const {};
    final prostitution =
        (data['prostitution'] as Map<String, dynamic>?) ?? const {};
    final assignedCount = (prostitution['assignedCount'] as num?)?.toInt() ?? 0;
    final staffCap = (prostitution['staffCap'] as num?)?.toInt() ?? 0;
    final storedTotalGrams = _nightclubStoredDrugs().fold<int>(
      0,
      (sum, row) => sum + ((row['quantity'] as num?)?.toInt() ?? 0),
    );
    final ops =
        (data['operations'] as Map<String, dynamic>?) ??
        const <String, dynamic>{};
    final opsAlerts = (ops['alerts'] as List<dynamic>?)?.length ?? 0;

    return _mafiaPanel(
      child: Padding(
        padding: EdgeInsets.all(compact ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t.nightclubManagementPanelTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: Color(0xFFFFE3A0),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _t.nightclubChooseZoneHint,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _kpiChip(_t.nightclubChipCrew, '$assignedCount/$staffCap'),
                _kpiChip(_t.nightclubChipStorage, '${storedTotalGrams}g'),
                _kpiChip(
                  _t.nightclubChipDjShift,
                  _activeDjShift() == null
                      ? _t.nightclubNone
                      : _t.nightclubStatusActive,
                ),
                _kpiChip(
                  _t.nightclubChipSecurity,
                  _activeSecurityShift() == null
                      ? _t.nightclubNone
                      : _t.nightclubStatusActive,
                ),
                _kpiChip(_t.nightclubChipOpsAlerts, '$opsAlerts'),
              ],
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final columns = maxWidth >= 1200
                    ? 3
                    : (maxWidth >= 780 ? 2 : 1);
                final totalSpacing = (columns - 1) * 10;
                final cardWidth = (maxWidth - totalSpacing) / columns;

                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: sections.map((section) {
                    final isSelected = section.key == selectedSection.key;
                    return SizedBox(
                      width: columns == 1 ? maxWidth : cardWidth,
                      child: _managementZoneCard(
                        section: section,
                        selected: isSelected,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: KeyedSubtree(
                key: ValueKey<String>(selectedSection.key),
                child: _managementSectionBody(selectedSection.key),
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
        : _t.nightclubSeasonCountdown(
            '${remaining.inDays}',
            '${remaining.inHours % 24}',
            '${remaining.inMinutes % 60}',
          );

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
                    _t.nightclubIntelligenceCardTitle,
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
              _t.nightclubLiveStatistics,
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
              _t.nightclubSeasonStatus,
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

class _ManagementSectionMeta {
  final String key;
  final IconData icon;
  final String title;
  final String subtitle;

  const _ManagementSectionMeta({
    required this.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
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
