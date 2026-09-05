import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/country.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/jail_service.dart';
import '../utils/country_helper.dart';
import '../widgets/jail_screen.dart';
import '../widgets/cooldown_overlay.dart';
import '../widgets/country_police_ui.dart';
import '../utils/top_right_notification.dart';
import '../utils/trade_good_l10n.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({
    super.key,
    this.embedded = false,
  });

  /// When true (web dashboard), hide the page AppBar; the sidebar already names the page.
  final bool embedded;

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  static const int _legCooldownMinutes = 60;
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);

  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();

  List<Country> _countries = [];
  bool _isLoading = true;
  bool _isTraveling = false;
  String? _error;
  int? _jailTime;
  int? _cooldownSeconds; // null = not jailed, >0 = seconds remaining
  /// countryCode -> police pressure snapshot from GET /police/countries
  Map<String, Map<String, dynamic>> _policeByCountry = {};
  bool _countryPoliceEnabled = false;

  bool _isInTransit = false;
  String? _journeyDestination;
  List<String> _journeyRoute = [];
  int _journeyCurrentLeg = 0;
  int _journeyTotalLegs = 0;

  @override
  void initState() {
    super.initState();
    _checkJailStatusAndLoadCountries();
  }

  Future<void> _checkJailStatusAndLoadCountries() async {
    final jailTime = await _jailService.checkJailStatus();

    if (jailTime > 0) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.refreshPlayer();

      setState(() {
        _jailTime = jailTime;
        _isLoading = false;
      });
      return;
    }

    await _loadJourneyStatus();
    await _loadCountries();
  }

  Future<void> _loadCountries() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/travel/countries');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['cooldown'] != null && data['cooldown'] is Map) {
          final cooldownData = data['cooldown'] as Map<String, dynamic>;
          if (cooldownData['remainingSeconds'] != null) {
            setState(() {
              _cooldownSeconds = cooldownData['remainingSeconds'] as int;
              _isLoading = false;
            });
            return;
          }
        }

        final countriesJson = data['countries'] as List<dynamic>;
        final List<Country> parsedCountries = [];
        for (final countryData in countriesJson) {
          try {
            parsedCountries.add(
              Country.fromJson(countryData as Map<String, dynamic>),
            );
          } catch (e) {
            // Skip malformed entries
          }
        }

        setState(() {
          _countries = parsedCountries;
          _isLoading = false;
        });
        await _loadCountryPoliceCountries();
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingCountries;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Verbindingsfout';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadJourneyStatus() async {
    try {
      final response = await _apiClient.get('/travel/status');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _isInTransit = data['isInTransit'] == true;
          _journeyDestination = data['destination'] as String?;
          _journeyRoute = (data['route'] as List<dynamic>? ?? [])
              .cast<String>();
          _journeyCurrentLeg = data['currentLeg'] as int? ?? 0;
          _journeyTotalLegs = data['totalLegs'] as int? ?? 0;
        });
      }
    } catch (e) {
      // Ignore, keep previous state
    }
  }

  Future<void> _loadCountryPoliceCountries() async {
    try {
      final results = await Future.wait([
        _apiClient.get('/police/countries'),
        _apiClient.get('/police/status'),
      ]);
      if (!mounted) return;

      final countriesResponse = results[0];
      final statusResponse = results[1];

      var enabled = false;
      if (statusResponse.statusCode == 200) {
        final statusData =
            jsonDecode(statusResponse.body) as Map<String, dynamic>;
        final cp = statusData['countryPolice'];
        if (cp is Map && cp['enabled'] == true) {
          enabled = true;
        }
      }

      final byCode = <String, Map<String, dynamic>>{};
      if (countriesResponse.statusCode == 200) {
        final data =
            jsonDecode(countriesResponse.body) as Map<String, dynamic>;
        final list = ((data['countries'] as List?) ?? const [])
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        for (final row in list) {
          final code = row['countryCode']?.toString();
          if (code == null || code.isEmpty) continue;
          byCode[code] = row;
        }
      }

      if (!mounted) return;
      setState(() {
        _policeByCountry = byCode;
        _countryPoliceEnabled = enabled;
      });
    } catch (e) {
      // Non-fatal: travel still works without badges.
    }
  }

  String _resolveCountryName(String countryId, AppLocalizations l10n) {
    final match = _countries.firstWhere(
      (c) => c.id == countryId,
      orElse: () => Country(id: countryId, name: countryId, flightCost: 0),
    );
    return CountryHelper.getLocalizedCountryName(
      match.id,
      l10n,
      fallbackName: match.name,
    );
  }

  String _resolveCountryNameWithFlag(String countryId, AppLocalizations l10n) {
    final localizedName = _resolveCountryName(countryId, l10n);
    final flag = CountryHelper.getCountryFlag(countryId);
    return '$flag $localizedName';
  }

  String _formatRoute(List<String> route, AppLocalizations l10n) {
    if (route.isEmpty) return '';
    return route.map((id) => _resolveCountryNameWithFlag(id, l10n)).join(' → ');
  }

  String _formatRouteCompact(
    List<String> route,
    AppLocalizations l10n, {
    int maxCountries = 3,
  }) {
    if (route.isEmpty) return '';
    if (route.length <= maxCountries) {
      return _formatRoute(route, l10n);
    }

    final first = _resolveCountryNameWithFlag(route.first, l10n);
    final last = _resolveCountryNameWithFlag(route.last, l10n);
    return '$first → ... → $last';
  }

  String _localizedGoodType(String goodType, AppLocalizations l10n) {
    return TradeGoodL10n.name(l10n, goodType);
  }

  Future<void> _startJourney(Country country) async {
    setState(() {
      _isTraveling = true;
      _error = null;
    });

    try {
      final l10n = AppLocalizations.of(context)!;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentCountryId =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';
      final route = country.route?.path ?? [currentCountryId, country.id];
      final totalLegs = route.length > 1 ? route.length - 1 : 1;
      final totalCost = country.totalCost ?? country.flightCost;
      final costPerLeg = (totalCost / totalLegs).round();
      final isMobile = MediaQuery.of(context).size.width < 600;
      final routeText = isMobile
          ? _formatRouteCompact(route, l10n, maxCountries: 3)
          : _formatRoute(route, l10n);

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: _panelBg,
          title: Row(
            children: [
              Image.asset(
                'assets/images/travel/journey_start.png',
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.travelJourneyTitle,
                  style: const TextStyle(
                    color: _gold,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${l10n.travelRouteLabel}: $routeText',
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                l10n.travelLegsLabel(totalLegs.toString()),
                style: const TextStyle(color: Colors.white70),
              ),
              const Divider(color: _panelBorder),
              Text(
                l10n.travelCostPerLeg(costPerLeg.toLocaleString()),
                style: const TextStyle(
                  color: _gold,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                l10n.travelTotalCost(totalCost.toLocaleString()),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset(
                    'assets/images/travel/cooldown_timer.png',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      l10n.travelCooldownPerLeg(_legCooldownMinutes.toString()),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'assets/images/travel/wanted_indicator.png',
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      l10n.travelRiskPerLeg,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: Colors.white70),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _gold,
                foregroundColor: Colors.black,
              ),
              child: Text(l10n.travelStart),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isTraveling = false;
        });
        return;
      }

      final response = await _apiClient.post('/travel/${country.id}', {});
      final data = jsonDecode(response.body);

      if (data.containsKey('event') && data['event'] == 'error.cooldown') {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final remainingSeconds = params['remainingSeconds'] as int? ?? 0;

        setState(() {
          _isTraveling = false;
          _cooldownSeconds = remainingSeconds;
        });
        return;
      }

      if (data.containsKey('event') && data['event'] == 'error.jailed') {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final remainingTime = params['remainingTime'] as int? ?? 0;
        setState(() {
          _isTraveling = false;
          _jailTime = remainingTime;
        });

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.red.shade900.withOpacity(0.95),
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/travel/police_arrest.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.arrested,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: Text(
                l10n.jailMessage,
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.ok,
                    style: TextStyle(color: Colors.red.shade200),
                  ),
                ),
              ],
            ),
          );
        }
        return;
      }

      final destinationCountryId =
          (data['destinationCountry'] as String?) ?? country.id;
      final destinationCountryName = CountryHelper.getLocalizedCountryName(
        destinationCountryId,
        l10n,
        fallbackName: country.name,
      );
      final newCountryId =
          (data['newCountry'] as String?) ??
          (data['currentLocation'] as String?);
      final isInTransitToDestination =
          newCountryId != null && newCountryId != destinationCountryId;
      final currentStopName = newCountryId != null
          ? _resolveCountryName(newCountryId, l10n)
          : l10n.currentLocation;
      final message = isInTransitToDestination
          ? '${l10n.travelInTransitTo(destinationCountryName)}. ${l10n.travelNextStop(currentStopName)}'
          : l10n.travelSuccessTo(destinationCountryName);

      int? cooldownSeconds;
      if (data.containsKey('cooldown') && data['cooldown'] is Map) {
        final cooldownData = data['cooldown'] as Map<String, dynamic>;
        cooldownSeconds = cooldownData['remainingSeconds'] as int?;
      }

      setState(() {
        _isTraveling = false;
        _cooldownSeconds = cooldownSeconds;
      });

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        authProvider.updatePlayerStats(
          money: data['remainingMoney'] as int?,
          currentCountry:
              (data['newCountry'] as String?) ??
              (data['currentLocation'] as String?),
        );
        await authProvider.refreshPlayer();
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
        _error = l10n.unknownError;
        _isTraveling = false;
      });
    } finally {
      await _loadJourneyStatus();
      await _loadCountries();
    }
  }

  Future<void> _continueJourney() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _panelBg,
        title: Row(
          children: [
            Image.asset(
              'assets/images/travel/border_checkpoint.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.travelContinueConfirmTitle,
                style: const TextStyle(
                  color: _gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.travelContinueConfirmBody,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final isFinalLeg =
        _journeyTotalLegs > 0 && (_journeyCurrentLeg + 1 >= _journeyTotalLegs);

    setState(() {
      _isTraveling = true;
      _error = null;
    });

    try {
      final response = await _apiClient.post('/travel/next', {});
      final data = jsonDecode(response.body);

      if (data.containsKey('event') && data['event'] == 'error.cooldown') {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final remainingSeconds = params['remainingSeconds'] as int? ?? 0;
        setState(() {
          _isTraveling = false;
          _cooldownSeconds = remainingSeconds;
        });
        return;
      }

      if (data.containsKey('event') && data['event'] == 'error.jailed') {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final remainingTime = params['remainingTime'] as int? ?? 0;
        setState(() {
          _isTraveling = false;
          _jailTime = remainingTime;
        });

        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.red.shade900.withOpacity(0.95),
              title: Row(
                children: [
                  Image.asset(
                    'assets/images/travel/police_arrest.png',
                    width: 32,
                    height: 32,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.arrested,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: Text(
                l10n.jailMessage,
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    l10n.ok,
                    style: TextStyle(color: Colors.red.shade200),
                  ),
                ),
              ],
            ),
          );
        }
        return;
      }

      final newCountryId = data['newCountry'] as String?;
      final newCountryName = newCountryId != null
          ? _resolveCountryName(newCountryId, l10n)
          : '';
      final message = newCountryName.isNotEmpty
          ? l10n.travelSuccessTo(newCountryName)
          : (data['message'] as String? ??
                l10n.travelSuccessTo(l10n.currentLocation));

      String warningMessage = '';
      final confiscatedGoods = data['confiscatedGoods'] as List<dynamic>?;
      final damagedGoods = data['damagedGoods'] as List<dynamic>?;

      if (confiscatedGoods != null && confiscatedGoods.isNotEmpty) {
        for (var item in confiscatedGoods) {
          final goodType = item['goodType'] as String;
          final quantity = item['quantity'] as int;
          final goodName = _localizedGoodType(goodType, l10n);
          warningMessage +=
              '\n${l10n.travelConfiscated(quantity.toString(), goodName)}';
        }
      }
      if (damagedGoods != null && damagedGoods.isNotEmpty) {
        for (var item in damagedGoods) {
          final goodType = item['goodType'] as String;
          final damagePercent = item['damagePercent'] as int;
          final goodName = _localizedGoodType(goodType, l10n);
          warningMessage +=
              '\n${l10n.travelDamaged(goodName, damagePercent.toString())}';
        }
      }

      int? cooldownSeconds;
      if (data.containsKey('cooldown') && data['cooldown'] is Map) {
        final cooldownData = data['cooldown'] as Map<String, dynamic>;
        cooldownSeconds = cooldownData['remainingSeconds'] as int?;
      }

      setState(() {
        _isTraveling = false;
        _cooldownSeconds = cooldownSeconds;
      });

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(message + warningMessage),
            backgroundColor: warningMessage.isNotEmpty
                ? Colors.orange
                : Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (data.containsKey('remainingMoney') &&
            data.containsKey('newCountry')) {
          authProvider.updatePlayerStats(
            money: data['remainingMoney'] as int?,
            currentCountry: data['newCountry'] as String?,
          );
        }
        await authProvider.refreshPlayer();
      }

      if (isFinalLeg && mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black87,
            title: Row(
              children: [
                Image.asset(
                  'assets/images/travel/safe_arrival.png',
                  width: 32,
                  height: 32,
                ),
                const SizedBox(width: 8),
                Text(l10n.travelJourneyCompleteTitle),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/travel/safehouse.png',
                    fit: BoxFit.cover,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.travelJourneyCompleteBody,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = l10n.unknownError;
        _isTraveling = false;
      });
    } finally {
      await _loadJourneyStatus();
      await _loadCountries();
    }
  }

  Future<void> _cancelJourney() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _panelBg,
        title: Row(
          children: [
            Image.asset(
              'assets/images/travel/journey_cancelled.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.travelCancelJourney,
                style: const TextStyle(
                  color: _gold,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          l10n.confirmAction,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8A2121),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isTraveling = true;
      _error = null;
    });

    try {
      final response = await _apiClient.post('/travel/cancel', {});
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      if (response.statusCode == 200 && data['success'] == true) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(loc.travelJourneyCanceled),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        final err = data['error'] as String?;
        final body = err == 'NOT_IN_TRANSIT'
            ? loc.travelNotInTransit
            : (data['message'] as String? ?? loc.unknownError);
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(body),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = l10n.unknownError;
      });
    } finally {
      setState(() {
        _isTraveling = false;
      });
      await _loadJourneyStatus();
      await _loadCountries();
    }
  }

  Widget _buildPanel({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: padding ?? const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _panelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _panelBorder),
      ),
      child: child,
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

  Widget _buildPageHero(
    AppLocalizations l10n, {
    required String currentName,
    required String currentFlag,
    required int destinationCount,
    required int wantedLevel,
    required int fbiHeat,
  }) {
    return _buildPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _gold.withValues(alpha: 0.45)),
                ),
                child: const Icon(Icons.public, color: _gold, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.travelHeroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.travelHeroSubtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.3,
                        fontSize: 13,
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
                '$currentFlag ${l10n.travelHereChip}',
                const Color(0xFF72C48F),
              ),
              _statChip(currentName, _gold),
              _statChip(
                l10n.travelDestinationsChip('$destinationCount'),
                _gold,
              ),
              _statChip(
                l10n.travelWantedChip('$wantedLevel'),
                wantedLevel > 0
                    ? const Color(0xFFE5967A)
                    : Colors.white70,
              ),
              _statChip(
                l10n.travelFbiChip('$fbiHeat'),
                fbiHeat > 0
                    ? const Color(0xFFE5967A)
                    : Colors.white70,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard(AppLocalizations l10n) {
    if (_journeyRoute.isEmpty || !_isInTransit) {
      return const SizedBox.shrink();
    }

    final destinationName = _journeyDestination != null
        ? _resolveCountryNameWithFlag(_journeyDestination!, l10n)
        : l10n.currentLocation;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final routeText = isMobile
        ? _formatRouteCompact(_journeyRoute, l10n, maxCountries: 3)
        : _formatRoute(_journeyRoute, l10n);
    final nextLegIndex = _journeyCurrentLeg + 1;
    final nextStop = nextLegIndex < _journeyRoute.length
        ? _resolveCountryNameWithFlag(_journeyRoute[nextLegIndex], l10n)
        : destinationName;

    return _buildPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/travel/wanted_indicator.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.travelInTransitTo(destinationName),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${l10n.travelRouteLabel}: $routeText',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Text(
            l10n.travelLegProgress(
              _journeyCurrentLeg.toString(),
              _journeyTotalLegs.toString(),
            ),
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            l10n.travelNextStop(nextStop),
            style: const TextStyle(color: _gold, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: _isTraveling ? null : _continueJourney,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.travelContinue),
              ),
              OutlinedButton(
                onPressed: _isTraveling ? null : _cancelJourney,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: const BorderSide(color: _panelBorder),
                ),
                child: Text(l10n.travelCancelJourney),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard({
    required Country country,
    required AppLocalizations l10n,
    required String currentCountry,
    required int money,
  }) {
    final isCurrent = country.id == currentCountry;
    final displayCost = country.totalCost ?? country.flightCost;
    final canAfford = money >= displayCost;
    final localizedName = CountryHelper.getLocalizedCountryName(
      country.id,
      l10n,
      fallbackName: country.name,
    );
    final countryFlag = CountryHelper.getCountryFlag(country.id);

    String routeDescription = '';
    if (country.route != null && !isCurrent) {
      if (country.route!.isDirect) {
        routeDescription = l10n.travelDirect;
      } else if (country.route!.path.length > 2) {
        final layoverIds = country.route!.path.sublist(
          1,
          country.route!.path.length - 1,
        );
        final layoverNames = layoverIds
            .map((id) => _resolveCountryNameWithFlag(id, l10n))
            .join(', ');
        routeDescription = l10n.travelVia(layoverNames);
      }
    }

    final legsCount = country.route != null
        ? (country.route!.path.length - 1)
        : 0;
    final legsInfo = legsCount > 0
        ? l10n.travelLegsCount(legsCount.toString())
        : '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
      decoration: BoxDecoration(
        color: isCurrent
            ? const Color(0xFF1B2A22).withValues(alpha: 0.94)
            : _panelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrent ? const Color(0xFF72C48F) : _panelBorder,
        ),
      ),
      child: Row(
        children: [
          Text(countryFlag, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        localizedName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: isCurrent
                              ? FontWeight.w800
                              : FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (_countryPoliceEnabled &&
                        _policeByCountry.containsKey(country.id)) ...[
                      const SizedBox(width: 8),
                      countryPoliceBandChip(
                        l10n: l10n,
                        band: _policeByCountry[country.id]?['band']
                            ?.toString(),
                        pressure: (_policeByCountry[country.id]?['pressure']
                                as num?)
                            ?.toInt(),
                        compact: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (isCurrent)
                      _statChip(
                        l10n.currentLocation,
                        const Color(0xFF72C48F),
                      )
                    else
                      _statChip(
                        l10n.travelCost(displayCost.toLocaleString()),
                        canAfford ? _gold : const Color(0xFFE5967A),
                      ),
                    if (routeDescription.isNotEmpty)
                      _statChip(routeDescription, Colors.white70),
                    if (legsInfo.isNotEmpty)
                      _statChip(legsInfo, Colors.white70),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 88, maxWidth: 128),
            child: ElevatedButton(
              onPressed: isCurrent ||
                      _isTraveling ||
                      !canAfford ||
                      _isInTransit
                  ? null
                  : () => _startJourney(country),
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent
                    ? const Color(0xFF2E5A3C)
                    : _gold,
                foregroundColor: isCurrent ? Colors.white : Colors.black,
                disabledBackgroundColor: isCurrent
                    ? const Color(0xFF2E5A3C)
                    : const Color(0xFF3A4252),
                disabledForegroundColor: isCurrent
                    ? Colors.white70
                    : Colors.white38,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isCurrent
                      ? l10n.current
                      : canAfford
                      ? l10n.travelTo
                      : l10n.travelCannotAfford,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;
    final currentCountry = player?.currentCountry ?? 'netherlands';

    final currentName = CountryHelper.getLocalizedCountryName(
      currentCountry,
      l10n,
    );
    final currentFlag = CountryHelper.getCountryFlag(currentCountry);
    final destinations = [
      ..._countries.where((country) => country.id == currentCountry),
      ..._countries.where((country) => country.id != currentCountry),
    ];

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(l10n.travel),
              backgroundColor: const Color(0xFF2E2A24),
              foregroundColor: Colors.white,
            ),
      backgroundColor: widget.embedded ? Colors.transparent : null,
      body: _cooldownSeconds != null && _cooldownSeconds! > 0
          ? CooldownOverlay(
              actionType: 'travel',
              cooldownActionType: 'travel',
              remainingSeconds: _cooldownSeconds!,
              onExpired: () {
                setState(() {
                  _cooldownSeconds = null;
                });
                _checkJailStatusAndLoadCountries();
              },
            )
          : _jailTime != null && _jailTime! > 0
          ? JailOverlay(
              remainingSeconds: _jailTime!,
              wantedLevel: player?.wantedLevel,
              onReleased: () {
                setState(() {
                  _jailTime = null;
                });
                _checkJailStatusAndLoadCountries();
              },
            )
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _isTraveling ? null : _loadCountries,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              color: _gold,
              onRefresh: _checkJailStatusAndLoadCountries,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 860),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildPageHero(
                            l10n,
                            currentName: currentName,
                            currentFlag: currentFlag,
                            destinationCount: destinations.length,
                            wantedLevel: player?.wantedLevel ?? 0,
                            fbiHeat: player?.fbiHeat ?? 0,
                          ),
                          if (_isInTransit) _buildJourneyCard(l10n),
                          ...destinations.map(
                            (country) => _buildDestinationCard(
                              country: country,
                              l10n: l10n,
                              currentCountry: currentCountry,
                              money: player?.money ?? 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

extension IntExtensions on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }
}
