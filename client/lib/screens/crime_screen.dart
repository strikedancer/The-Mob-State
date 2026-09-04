import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/crime.dart';
import '../models/vehicle_crime.dart';
import '../providers/auth_provider.dart';
import '../screens/events_screen.dart';
import '../services/api_client.dart';
import '../services/event_renderer.dart';
import '../services/jail_service.dart';
import '../services/tool_service.dart';
import '../widgets/jail_screen.dart';
import '../widgets/cooldown_overlay.dart';
import '../widgets/crime_card.dart';
import '../widgets/crime_result_overlay.dart';
import '../widgets/country_police_ui.dart';
import '../utils/crime_localization.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/top_right_notification.dart';

enum _CrimeListFilter { all, available }

enum _CrimeListSort { reward, rank, success }

class CrimeScreen extends StatefulWidget {
  const CrimeScreen({
    super.key,
    this.onOpenTraining,
    this.onOpenEvents,
  });

  /// When set (e.g. web dashboard), opens the training hub section.
  final VoidCallback? onOpenTraining;

  /// When set (e.g. web dashboard), opens the live events section.
  final VoidCallback? onOpenEvents;

  @override
  State<CrimeScreen> createState() => _CrimeScreenState();
}

class _CrimeScreenState extends State<CrimeScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);
  static const Color _crimeAccent = Color(0xFFE85D4C);

  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();
  final ToolService _toolService = ToolService();
  static const Set<String> _excludedCrimeIds = {'car_theft', 'steal_yacht'};
  List<Crime> _crimes = [];
  bool _isLoading = true;
  bool _isCommittingCrime = false;
  bool _loadingWeaponSelection = true;
  String? _error;
  int? _jailTime; // null = not jailed, >0 = SECONDS remaining
  int? _cooldownSeconds; // null = not on cooldown, >0 = seconds remaining
  String? _cooldownResultMessage;
  bool? _cooldownIsSuccess;
  String? _resultCrimeName;
  Map<String, dynamic>? _equippedSlotOne;
  Map<String, dynamic>? _equippedSlotTwo;
  bool _showCrimeResult = false;
  bool _crimeResultSuccess = true;
  int _crimeReward = 0;
  int _crimeXpGained = 0;
  int _crimeXpLost = 0;
  String? _resultFlavorLine;
  int? _crimeVehicleConditionLoss;
  int? _crimeVehicleFuelUsed;
  bool _trainingBonusesLoaded = false;
  double _trainingStrengthBonus = 0;
  double _trainingAccuracyBonus = 0;
  bool _trainingComboActive = false;
  double _trainingComboBonusFraction = 0;
  Map<String, dynamic>? _liveCrimeEvent;
  Map<String, dynamic>? _liveCrimeEventProgress;
  _CrimeListFilter _listFilter = _CrimeListFilter.available;
  _CrimeListSort _listSort = _CrimeListSort.reward;
  DateTime _now = DateTime.now();
  Timer? _tickTimer;
  Map<String, dynamic>? _countryPolice;
  List<Map<String, dynamic>> _disruptActions = [];

  @override
  void initState() {
    super.initState();
    _checkJailStatusAndLoadCrimes();
    _loadTrainingBonuses();
    _loadLiveCrimeEvent();
    _loadTools();
    _loadSelectedCrimeVehicle();
    _loadCrimeWeaponSelection();
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTrainingBonuses() async {
    try {
      final response = await _apiClient.get('/training/status');
      if (response.statusCode != 200 || !mounted) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>?;
      final gym = data?['gym'] as Map<String, dynamic>?;
      final shooting = data?['shootingRange'] as Map<String, dynamic>?;
      final strength =
          (gym?['strengthBonus'] as num?)?.toDouble() ?? 0.0;
      final accuracy =
          (shooting?['accuracyBonus'] as num?)?.toDouble() ?? 0.0;
      final combo = data?['trainingComboReadiness'] as Map<String, dynamic>?;
      final comboFrac =
          (combo?['bonusFraction'] as num?)?.toDouble() ?? 0.0;
      final comboOn = combo?['active'] == true && comboFrac > 0;
      if (!mounted) return;
      setState(() {
        _trainingStrengthBonus = strength;
        _trainingAccuracyBonus = accuracy;
        _trainingComboActive = comboOn;
        _trainingComboBonusFraction = comboFrac;
        _trainingBonusesLoaded = true;
      });
    } catch (e) {
      print('[CrimeScreen] Error loading training bonuses: $e');
    }
  }

  Future<void> _loadLiveCrimeEvent() async {
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

      Map<String, dynamic>? crimeEvent;
      for (final event in activeList) {
        final template = event['template'] is Map
            ? Map<String, dynamic>.from(event['template'] as Map)
            : null;
        if (template?['key']?.toString() == 'street_crime_spree') {
          crimeEvent = event;
          break;
        }
      }

      Map<String, dynamic>? progress;
      if (crimeEvent != null) {
        final eventId = (crimeEvent['id'] as num?)?.toInt();
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
        _liveCrimeEvent = crimeEvent;
        _liveCrimeEventProgress = progress;
      });
    } catch (e) {
      print('[CrimeScreen] Error loading live crime event: $e');
    }
  }

  Future<void> _refreshCrimeScreen() async {
    await _checkJailStatusAndLoadCrimes();
    await _loadTrainingBonuses();
    await _loadLiveCrimeEvent();
    await _loadCrimeWeaponSelection(showLoading: false);
  }

  Future<void> _loadCountryPoliceStatus() async {
    try {
      final response = await _apiClient.get('/police/status');
      if (response.statusCode != 200 || !mounted) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final countryPolice = data['countryPolice'] is Map
          ? Map<String, dynamic>.from(data['countryPolice'] as Map)
          : null;
      final disruptActions = ((data['disruptActions'] as List?) ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      if (!mounted) return;
      setState(() {
        _countryPolice = countryPolice;
        _disruptActions = disruptActions;
      });
    } catch (e) {
      print('[CrimeScreen] Error loading country police status: $e');
    }
  }

  Future<void> _openCountryPoliceDisrupt() async {
    await showCountryPoliceDisruptSheet(
      context: context,
      apiClient: _apiClient,
      disruptActions: _disruptActions,
      onCompleted: () async {
        await _loadCountryPoliceStatus();
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.refreshPlayer();
      },
    );
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

  bool get _hasWeaponCrime =>
      _crimes.any((crime) => crime.requiredWeapon == true);

  bool get _hasLowTrainingBonus =>
      _trainingBonusesLoaded &&
      _trainingStrengthBonus <= 0 &&
      _trainingAccuracyBonus <= 0;

  int _crimeSuccessPercent(Crime crime) {
    return crime.playerSuccessChance ??
        ((crime.baseSuccessChance ?? 0) * 100).round();
  }

  bool _crimeIsAvailable(Crime crime, int playerRank) {
    return crime.isAvailable ?? playerRank >= crime.requiredRank;
  }

  bool _crimeCanAttempt(Crime crime, int playerRank) {
    return crime.canAttempt ?? false;
  }

  List<Crime> _visibleCrimes(int playerRank) {
    final filtered = _crimes.where((crime) {
      if (_listFilter == _CrimeListFilter.available) {
        return _crimeIsAvailable(crime, playerRank);
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      switch (_listSort) {
        case _CrimeListSort.rank:
          final rankCmp = a.requiredRank.compareTo(b.requiredRank);
          if (rankCmp != 0) return rankCmp;
          return b.maxPay.compareTo(a.maxPay);
        case _CrimeListSort.success:
          final successCmp =
              _crimeSuccessPercent(b).compareTo(_crimeSuccessPercent(a));
          if (successCmp != 0) return successCmp;
          return b.maxPay.compareTo(a.maxPay);
        case _CrimeListSort.reward:
          return b.maxPay.compareTo(a.maxPay);
      }
    });

    return filtered;
  }

  String _formatEventCountdown(DateTime? endsAt, AppLocalizations l10n) {
    if (endsAt == null) return l10n.gameScreenDash;
    final diff = endsAt.difference(_now);
    if (diff.inSeconds <= 0) return l10n.gameScreenCountdownNow;
    final h = diff.inHours;
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Widget _panel({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _panelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _panelBorder),
      ),
      child: child,
    );
  }

  Widget _buildPageHero(AppLocalizations l10n, int playerRank) {
    final availableCount =
        _crimes.where((c) => _crimeIsAvailable(c, playerRank)).length;

    return _panel(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _crimeAccent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _crimeAccent.withValues(alpha: 0.45),
                  ),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: _crimeAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.crimeScreenHeroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.crimeScreenHeroSubtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip(
                '${_crimes.length} ${l10n.crimes.toLowerCase()}',
                _gold,
              ),
              _statChip(
                '$availableCount ${l10n.crimeScreenFilterAvailable.toLowerCase()}',
                Colors.greenAccent,
              ),
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
    final event = _liveCrimeEvent;
    if (event == null) return const SizedBox.shrink();

    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final title = localizedGameEventTitle(l10n, template);
    final endsAt =
        DateTime.tryParse(event['endsAt']?.toString() ?? '')?.toLocal();
    final score = (_liveCrimeEventProgress?['score'] as num?)?.toDouble();
    final rank = (_liveCrimeEventProgress?['rank'] as num?)?.toInt();
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
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  _crimeAccent.withValues(alpha: 0.28),
                  const Color(0xFF1A1210),
                ],
              ),
              border: Border.all(
                color: _crimeAccent.withValues(alpha: 0.55),
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
                        l10n.crimeScreenLiveEventActive(title),
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
                  l10n.crimeScreenLiveEventProgress(
                    scoreLabel,
                    rankLabel,
                    _formatEventCountdown(endsAt, l10n),
                  ),
                  style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.crimeScreenOpenEvents,
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

  Widget _buildPrepStrip(AppLocalizations l10n) {
    final strengthPct = (_trainingStrengthBonus * 100).toStringAsFixed(1);
    final accuracyPct = (_trainingAccuracyBonus * 100).toStringAsFixed(1);
    final comboPct =
        (_trainingComboBonusFraction * 100).toStringAsFixed(1);
    String weaponSlotLabel(Map<String, dynamic>? weapon) {
      if (weapon == null) return l10n.crimeWeaponSlotEmpty;
      return '${weapon['name'] ?? weapon['weaponId']} (${weapon['condition']}%)';
    }

    return _panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.crimeScreenPrepTitle,
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          if (_trainingBonusesLoaded) ...[
            Builder(
              builder: (context) {
                final trainingBody = Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _gold.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.trending_up, color: _gold, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.crimeTrainingBonusStrip(
                                strengthPct,
                                accuracyPct,
                              ),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (widget.onOpenTraining != null)
                            Icon(
                              Icons.chevron_right,
                              color: Colors.white.withValues(alpha: 0.45),
                              size: 18,
                            ),
                        ],
                      ),
                      if (_trainingComboActive) ...[
                        const SizedBox(height: 6),
                        Text(
                          l10n.crimeTrainingComboStrip(comboPct),
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                      if (_hasLowTrainingBonus &&
                          widget.onOpenTraining != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          l10n.crimeScreenTrainingNudge,
                          style: TextStyle(
                            color: Colors.orangeAccent.withValues(alpha: 0.95),
                            fontSize: 11,
                          ),
                        ),
                      ] else if (widget.onOpenTraining != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          l10n.crimeTrainingOpenHub,
                          style: TextStyle(
                            color: _gold.withValues(alpha: 0.85),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                );

                if (widget.onOpenTraining == null) {
                  return trainingBody;
                }

                return InkWell(
                  onTap: widget.onOpenTraining,
                  borderRadius: BorderRadius.circular(10),
                  child: trainingBody,
                );
              },
            ),
            const SizedBox(height: 12),
          ],
          if (_hasWeaponCrime) ...[
            Row(
              children: [
                const Icon(Icons.gps_fixed, color: _gold, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.crimeWeaponSectionTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _openInventoryForWeaponSelection,
                  icon: const Icon(Icons.inventory_2_outlined, size: 15),
                  label: Text(l10n.goToInventory),
                  style: TextButton.styleFrom(
                    foregroundColor: _gold,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.crimeWeaponInstruction,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
            const SizedBox(height: 8),
            if (_loadingWeaponSelection)
              const SizedBox(
                height: 36,
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_equippedSlotOne == null && _equippedSlotTwo == null) ...[
              Text(
                l10n.crimeWeaponNoSelectionNote,
                style: const TextStyle(color: Colors.orange, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.crimeWeaponEmptyInventoryHelp,
                style: const TextStyle(color: Colors.white54, fontSize: 11.5),
              ),
            ] else ...[
              Text(
                l10n.crimeWeaponEquippedStatus(
                  weaponSlotLabel(_equippedSlotOne),
                  weaponSlotLabel(_equippedSlotTwo),
                ),
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.crimeWeaponFooterNote,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildFilterSortBar(AppLocalizations l10n) {
    return _panel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ChoiceChip(
            label: Text(l10n.crimeScreenFilterAll),
            selected: _listFilter == _CrimeListFilter.all,
            onSelected: (_) =>
                setState(() => _listFilter = _CrimeListFilter.all),
            selectedColor: _gold.withValues(alpha: 0.25),
            labelStyle: TextStyle(
              color: _listFilter == _CrimeListFilter.all
                  ? _gold
                  : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: _listFilter == _CrimeListFilter.all
                  ? _gold.withValues(alpha: 0.6)
                  : _panelBorder,
            ),
          ),
          ChoiceChip(
            label: Text(l10n.crimeScreenFilterAvailable),
            selected: _listFilter == _CrimeListFilter.available,
            onSelected: (_) =>
                setState(() => _listFilter = _CrimeListFilter.available),
            selectedColor: Colors.greenAccent.withValues(alpha: 0.18),
            labelStyle: TextStyle(
              color: _listFilter == _CrimeListFilter.available
                  ? Colors.greenAccent
                  : Colors.white70,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: _listFilter == _CrimeListFilter.available
                  ? Colors.greenAccent.withValues(alpha: 0.55)
                  : _panelBorder,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            l10n.crimeScreenSortLabel,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          DropdownButton<_CrimeListSort>(
            value: _listSort,
            dropdownColor: _panelBg,
            underline: const SizedBox.shrink(),
            iconEnabledColor: _gold,
            style: const TextStyle(color: Colors.white, fontSize: 12.5),
            items: [
              DropdownMenuItem(
                value: _CrimeListSort.reward,
                child: Text(l10n.crimeScreenSortReward),
              ),
              DropdownMenuItem(
                value: _CrimeListSort.rank,
                child: Text(l10n.crimeScreenSortRank),
              ),
              DropdownMenuItem(
                value: _CrimeListSort.success,
                child: Text(l10n.crimeScreenSortSuccess),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => _listSort = value);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadTools() async {
    try {
      await _toolService.getAllTools();
    } catch (e) {
      print('[CrimeScreen] Error loading tools: $e');
      // Non-blocking - crimes still work without tool names
    }
  }

  Future<void> _loadSelectedCrimeVehicle() async {
    try {
      final response = await _apiClient.get('/garage/crime-vehicle');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['vehicle'] != null) {
          Vehicle.fromJson(data['vehicle']);
        }
      }
    } catch (e) {
      print('[CrimeScreen] Error loading selected vehicle: $e');
    }
  }

  Future<void> _loadCrimeWeaponSelection({bool showLoading = true}) async {
    if (showLoading && mounted) {
      setState(() {
        _loadingWeaponSelection = true;
      });
    }

    try {
      final inventoryResponse = await _apiClient.get('/weapons/inventory');
      final slotOneResponse = await _apiClient.get('/weapons/crime-weapon');
      final slotTwoResponse = await _apiClient.get('/weapons/secondary-weapon');

      if (inventoryResponse.statusCode != 200) {
        throw Exception('WEAPON_INVENTORY_LOAD_FAILED');
      }

      final inventoryData = jsonDecode(inventoryResponse.body);
      final weapons = (inventoryData['weapons'] as List<dynamic>? ?? [])
          .map((w) => (w as Map<String, dynamic>))
          .where((w) => ((w['condition'] as num?)?.toInt() ?? 0) > 0)
          .toList();

      Map<String, dynamic>? matchEquipped(dynamic payload) {
        final weaponId = payload is Map ? payload['weapon']?['weaponId'] as String? : null;
        if (weaponId == null) return null;
        for (final weapon in weapons) {
          if (weapon['weaponId'] == weaponId) return weapon;
        }
        return null;
      }

      final slotOne = slotOneResponse.statusCode == 200
          ? matchEquipped(jsonDecode(slotOneResponse.body))
          : null;
      final slotTwo = slotTwoResponse.statusCode == 200
          ? matchEquipped(jsonDecode(slotTwoResponse.body))
          : null;

      if (!mounted) return;
      setState(() {
        _equippedSlotOne = slotOne;
        _equippedSlotTwo = slotTwo;
        _loadingWeaponSelection = false;
      });
    } catch (e) {
      print('[CrimeScreen] Error loading crime weapon selection: $e');
      if (!mounted) return;
      setState(() {
        _loadingWeaponSelection = false;
      });
    }
  }

  void _openInventoryForWeaponSelection() {
    Navigator.of(context).pushNamed('/inventory').then((_) async {
      await _loadCrimeWeaponSelection(showLoading: false);
      if (!mounted) return;
      await _checkJailStatusAndLoadCrimes();
    });
  }

  Future<void> _checkJailStatusAndLoadCrimes() async {
    // First check if player is in jail
    final jailTime = await _jailService.checkJailStatus();

    if (jailTime > 0) {
      // Refresh player data to get current wanted level for bail button
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.refreshPlayer();

      setState(() {
        _jailTime = jailTime;
        _isLoading = false;
      });
      return; // Don't load crimes if jailed
    }

    // Check for active cooldown by attempting to load crimes
    try {
      final response = await _apiClient.get('/crimes');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check for cooldown in response
        if (data['cooldown'] != null && data['cooldown'] is Map) {
          final cooldownData = data['cooldown'] as Map<String, dynamic>;
          if (cooldownData['remainingSeconds'] != null) {
            setState(() {
              _cooldownSeconds = cooldownData['remainingSeconds'] as int;
              _isLoading = false;
            });
            return; // Don't load crimes if on cooldown
          }
        }

        // No cooldown, load crimes normally
        final crimesJson = data['crimes'] as List;
        final crimes = crimesJson
            .map((c) => Crime.fromJson(c))
            .where((crime) => !_excludedCrimeIds.contains(crime.id))
            .toList();
        setState(() {
          _crimes = crimes;
          _isLoading = false;
        });
        await _loadCountryPoliceStatus();
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingCrimes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      setState(() {
        _error = loc.connectionErrorGeneric;
        _isLoading = false;
      });
    }
  }

  Future<void> _commitCrime(Crime crime) async {
    final l10n = AppLocalizations.of(context)!;

    if (crime.requiredWeapon == true && crime.weaponReady != true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.crimeChooseWeaponBeforeCommit,
          ),
          backgroundColor: Colors.orange,
          action: SnackBarAction(
            label: l10n.goToInventory,
            textColor: Colors.white,
            onPressed: _openInventoryForWeaponSelection,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isCommittingCrime = true;
      _error = null;
    });

    try {
      final response = await _apiClient.post('/crimes/${crime.id}/attempt', {});

      if (response.statusCode != 200) {
        // Handle non-200 responses
        final data = jsonDecode(response.body);
        final eventKey = data['event'] as String?;
        final params = (data['params'] as Map<String, dynamic>?) ?? {};

        final reason = params['reason'] as String?;
        if (reason == 'WEAPON_SELECTION_REQUIRED' ||
            reason == 'WEAPON_REQUIRED' ||
            reason == 'WEAPON_BROKEN' ||
            reason == 'WEAPON_NOT_SUITABLE') {
          await _loadCrimeWeaponSelection(showLoading: false);
        }

        setState(() {
          _isCommittingCrime = false;
        });

        if (eventKey != null) {
          final eventRenderer = EventRenderer(l10n);
          final message = eventRenderer.renderEvent(eventKey, params);

          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      final data = jsonDecode(response.body);
      final eventKey = data['event'] as String;
      final params = (data['params'] as Map<String, dynamic>?) ?? {};

      int readInt(dynamic value) {
        if (value is int) return value;
        if (value is num) return value.toInt();
        return 0;
      }

      // Check if error.cooldown - show cooldown overlay
      if (eventKey == 'error.cooldown') {
        final remainingSeconds = params['remainingSeconds'] as int? ?? 0;
        final l10n = AppLocalizations.of(context)!;
        final eventRenderer = EventRenderer(l10n);
        final message = eventRenderer.renderEvent(eventKey, params);

        setState(() {
          _isCommittingCrime = false;
          _cooldownSeconds = remainingSeconds;
          _cooldownResultMessage = message;
          _cooldownIsSuccess = false;
        });
        return;
      }

      // Check if error.jailed - handle specially
      if (eventKey == 'error.jailed') {
        final remainingTime = readInt(params['remainingTime']);
        final l10n = AppLocalizations.of(context)!;
        final eventRenderer = EventRenderer(l10n);
        final message = eventRenderer.renderEvent(eventKey, params);

        setState(() {
          _isCommittingCrime = false;
          _jailTime = remainingTime;
        });

        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Row(
                children: [
                  Image.asset(
                    'assets/images/cooldown_jail.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.local_police, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(message)),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: remainingTime > 60 ? 10 : 5),
            ),
          );
        }
        return;
      }

      // Check if error.toolInStorage - show transfer button
      if (eventKey == 'error.toolInStorage') {
        final l10n = AppLocalizations.of(context)!;
        final toolsParam = params['tools'] as String? ?? 'unknown';

        setState(() {
          _isCommittingCrime = false;
        });

        if (mounted) {
          final toolsLabel =
              toolsParam == 'unknown' ? l10n.unknown : toolsParam;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.crimeErrorToolInStorage(toolsLabel)),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: l10n.transfer,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamed('/inventory');
                },
              ),
            ),
          );
        }
        return;
      }

      // Render event
      final eventRenderer = EventRenderer(l10n);
      final message = eventRenderer.renderEvent(eventKey, params);
      final success = eventKey.contains('success');
      final reward = readInt(params['reward']);
      final xpGained = readInt(params['xpGained']);
      final xpLost = readInt(params['xpLost']);
      final vehicleConditionLoss =
          readInt(params['vehicleConditionLoss']) +
          readInt(params['vehicleChaseDamage']);
      final vehicleFuelUsed = readInt(params['vehicleFuelUsed']);

      setState(() {
        _isCommittingCrime = false;
        _crimeVehicleConditionLoss =
            vehicleConditionLoss > 0 ? vehicleConditionLoss : null;
        _crimeVehicleFuelUsed = vehicleFuelUsed > 0 ? vehicleFuelUsed : null;
      });

      // Check if cooldown info is in response
      int? cooldownSeconds;
      if (data.containsKey('cooldown') && data['cooldown'] != null) {
        final cooldownData = data['cooldown'] as Map<String, dynamic>;
        if (cooldownData['remainingSeconds'] != null) {
          cooldownSeconds = readInt(cooldownData['remainingSeconds']);
        }
      }

      // Update player stats from response
      if (mounted) {
        try {
          final authProvider = Provider.of<AuthProvider>(
            context,
            listen: false,
          );
          if (data.containsKey('player')) {
            final playerData = data['player'] as Map<String, dynamic>;

            authProvider.updatePlayerStats(
              money: playerData['money'] == null
                  ? null
                  : readInt(playerData['money']),
              xp: playerData['xp'] == null ? null : readInt(playerData['xp']),
              rank: playerData['rank'] == null
                  ? null
                  : readInt(playerData['rank']),
              health: playerData['health'] == null
                  ? null
                  : readInt(playerData['health']),
              wantedLevel: playerData['wantedLevel'] == null
                  ? null
                  : readInt(playerData['wantedLevel']),
              fbiHeat: playerData['fbiHeat'] == null
                  ? null
                  : readInt(playerData['fbiHeat']),
            );
            await authProvider.refreshPlayer();
          } else {
            await authProvider.refreshPlayer();
          }
        } catch (e) {
          print('[CrimeScreen] Error updating player stats: $e');
        }

        var wasJailed = false;
        if (params.containsKey('jailed') && params['jailed'] == true) {
          wasJailed = true;
          final jailTimeMinutes = params['jailTime'] == null
              ? null
              : readInt(params['jailTime']);
          if (jailTimeMinutes != null && jailTimeMinutes > 0) {
            setState(() {
              _jailTime = jailTimeMinutes * 60;
            });
          }
        }

        if (success && (reward > 0 || xpGained > 0)) {
          setState(() {
            _crimeResultSuccess = true;
            _resultCrimeName = CrimeLocalization.name(crime, l10n);
            _crimeReward = reward;
            _crimeXpGained = xpGained;
            _crimeXpLost = 0;
            _resultFlavorLine = null;
            _showCrimeResult = true;
            if (!wasJailed && cooldownSeconds != null && cooldownSeconds > 0) {
              _cooldownSeconds = cooldownSeconds;
              _cooldownResultMessage = message;
              _cooldownIsSuccess = true;
            }
          });
          _loadLiveCrimeEvent();
          return;
        }

        if (!success) {
          setState(() {
            _crimeResultSuccess = false;
            _resultCrimeName = CrimeLocalization.name(crime, l10n);
            _crimeReward = 0;
            _crimeXpGained = 0;
            _crimeXpLost = xpLost;
            _resultFlavorLine = message;
            _showCrimeResult = true;
            if (!wasJailed && cooldownSeconds != null && cooldownSeconds > 0) {
              _cooldownSeconds = cooldownSeconds;
              _cooldownResultMessage = null;
              _cooldownIsSuccess = false;
            }
          });
          _loadLiveCrimeEvent();
          return;
        }

        if (!wasJailed && cooldownSeconds != null && cooldownSeconds > 0) {
          setState(() {
            _cooldownSeconds = cooldownSeconds;
            _cooldownResultMessage = message;
            _cooldownIsSuccess = success;
          });
        } else {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(message),
              backgroundColor: success ? Colors.green : Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }

        // Don't reload crimes - keep cooldown/jail overlay visible
      }
    } catch (e, stackTrace) {
      print('[CrimeScreen] ERROR: $e');
      print('[CrimeScreen] Stack trace: $stackTrace');

      setState(() {
        _error = null;
        _isCommittingCrime = false;
      });

      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(loc.crimeCommitUnexpectedError),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Unused - kept for potential future use
  /*
  String _formatToolNames(List<String> toolIds) {
    // Map tool IDs to user-friendly Dutch names from loaded tools
    final toolNames = toolIds.map((id) {
      final tool = _availableTools.firstWhere(
        (t) => t.id == id,
        orElse: () => CrimeTool(
          id: id,
          name: id, // Fallback to ID if not found
          type: '',
          basePrice: 0,
          maxDurability: 0,
          loseChance: 0,
          wearPerUse: 0,
          requiredFor: [],
        ),
      );
      return tool.name;
    }).toList();

    return toolNames.join(', ');
  }
  */

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.crimes)),
      body: _showCrimeResult
          ? CrimeResultOverlay(
              embedded: kIsWeb,
              isSuccess: _crimeResultSuccess,
              headline: _crimeResultSuccess
                  ? null
                  : l10n.crimeOutcomeFailed,
              crimeName: _resultCrimeName ?? l10n.crimes,
              reward: _crimeReward,
              xpGained: _crimeXpGained,
              xpLost: _crimeXpLost,
              flavorLine: _resultFlavorLine,
              vehicleConditionLoss: _crimeVehicleConditionLoss,
              vehicleFuelUsed: _crimeVehicleFuelUsed,
              onContinue: () {
                setState(() {
                  _showCrimeResult = false;
                  _crimeResultSuccess = true;
                  _resultCrimeName = null;
                  _crimeReward = 0;
                  _crimeXpGained = 0;
                  _crimeXpLost = 0;
                  _resultFlavorLine = null;
                  _crimeVehicleConditionLoss = null;
                  _crimeVehicleFuelUsed = null;
                });
                // Reload vehicle after crime to get updated stats
                _loadSelectedCrimeVehicle();
                _loadTrainingBonuses();
                _loadLiveCrimeEvent();
              },
            )
          : _jailTime != null && _jailTime! > 0
          ? JailOverlay(
              embedded: kIsWeb,
              remainingSeconds: _jailTime!,
              wantedLevel: player?.wantedLevel,
              onReleased: () {
                setState(() {
                  _jailTime = null;
                });
                // Re-check state after release so cooldowns are picked up too.
                _checkJailStatusAndLoadCrimes();
              },
            )
          : _cooldownSeconds != null && _cooldownSeconds! > 0
          ? CooldownOverlay(
              embedded: kIsWeb,
              actionType: 'crime',
              cooldownActionType: 'crime',
              remainingSeconds: _cooldownSeconds!,
              resultMessage: _cooldownResultMessage,
              isSuccess: _cooldownIsSuccess,
              onExpired: () {
                setState(() {
                  _cooldownSeconds = null;
                  _cooldownResultMessage = null;
                  _cooldownIsSuccess = null;
                });
                // Load crimes after cooldown expires
                _checkJailStatusAndLoadCrimes();
              },
            )
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isCommittingCrime ? null : _refreshCrimeScreen,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: _gold,
              onRefresh: _refreshCrimeScreen,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1210), Color(0xFF0C0A0A)],
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/backgrounds/crime_background.png',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.22,
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),
                    SliverToBoxAdapter(
                      child: _buildPageHero(l10n, player?.rank ?? 1),
                    ),
                    SliverToBoxAdapter(child: _buildLiveEventBanner(l10n)),
                    if (_countryPolice != null &&
                        _countryPolice!['enabled'] == true)
                      SliverToBoxAdapter(
                        child: CountryPoliceStrip(
                          countryPolice: _countryPolice!,
                          disruptActions: _disruptActions,
                          onDisrupt: _openCountryPoliceDisrupt,
                        ),
                      ),
                    SliverToBoxAdapter(child: _buildPrepStrip(l10n)),
                    SliverToBoxAdapter(child: _buildFilterSortBar(l10n)),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                      sliver: Builder(
                        builder: (context) {
                          final playerRank = player?.rank ?? 1;
                          final visibleCrimes = _visibleCrimes(playerRank);
                          if (visibleCrimes.isEmpty) {
                            return SliverToBoxAdapter(
                              child: _panel(
                                child: Text(
                                  l10n.crimeScreenNoMatches,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            );
                          }

                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width < 480
                                  ? 2
                                  : MediaQuery.of(context).size.width < 900
                                  ? 3
                                  : 5,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.82,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final crime = visibleCrimes[index];
                                final canCommit = _crimeCanAttempt(crime, playerRank);
                                final localizedName = CrimeLocalization.name(
                                  crime,
                                  l10n,
                                );
                                final localizedDescription =
                                    CrimeLocalization.description(crime, l10n);

                                return CrimeCard(
                                  crime: crime,
                                  canCommit: canCommit,
                                  isCommitting: _isCommittingCrime,
                                  onTap: () => _commitCrime(crime),
                                  crimeName: localizedName,
                                  crimeDescription: localizedDescription,
                                );
                              },
                              childCount: visibleCrimes.length,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Extension to add toLocaleString to int
extension IntExtensions on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
