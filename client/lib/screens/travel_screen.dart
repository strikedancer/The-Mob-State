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
import '../utils/fontawesome_icons.dart';
import '../utils/top_right_notification.dart';

class TravelScreen extends StatefulWidget {
  const TravelScreen({super.key});

  @override
  State<TravelScreen> createState() => _TravelScreenState();
}

class _TravelScreenState extends State<TravelScreen> {
  static const int _legCooldownMinutes = 30;

  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();

  List<Country> _countries = [];
  bool _isLoading = true;
  bool _isTraveling = false;
  String? _error;
  int? _jailTime;
  int? _cooldownSeconds; // null = not jailed, >0 = seconds remaining

  bool _isInTransit = false;
  String? _journeyDestination;
  List<String> _journeyRoute = [];
  int _journeyCurrentLeg = 0;
  int _journeyTotalLegs = 0;

  String _confirmTitle() {
    return Localizations.localeOf(context).languageCode == 'nl'
        ? 'Weet je het zeker?'
        : 'Are you sure?';
  }

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
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingCountries;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        final l10n = AppLocalizations.of(context)!;
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
    switch (goodType) {
      case 'contraband_flowers':
        return l10n.contrabandFlowersName;
      case 'contraband_electronics':
        return l10n.contrabandElectronicsName;
      case 'contraband_diamonds':
        return l10n.contrabandDiamondsName;
      case 'contraband_weapons':
        return l10n.contrabandWeaponsName;
      case 'contraband_pharmaceuticals':
        return l10n.contrabandPharmaceuticalsName;
      default:
        return goodType.replaceAll('contraband_', '');
    }
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
          title: Row(
            children: [
              Image.asset(
                'assets/images/travel/journey_start.png',
                width: 32,
                height: 32,
              ),
              const SizedBox(width: 8),
              Text(_confirmTitle()),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.travelRouteLabel}: $routeText'),
              Text(l10n.travelLegsLabel(totalLegs.toString())),
              const Divider(),
              Text(l10n.travelCostPerLeg(costPerLeg.toLocaleString())),
              Text(l10n.travelTotalCost(totalCost.toLocaleString())),
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
                  Expanded(child: Text(l10n.travelRiskPerLeg)),
                ],
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

      final l10nCountryName = CountryHelper.getLocalizedCountryName(
        country.id,
        l10n,
        fallbackName: country.name,
      );
      final message = l10n.travelSuccessTo(l10nCountryName);

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
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 5),
          ),
        );

        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (data.containsKey('remainingMoney') &&
            data.containsKey('currentLocation')) {
          authProvider.updatePlayerStats(
            money: data['remainingMoney'] as int?,
            currentCountry: data['currentLocation'] as String?,
          );
        } else {
          await authProvider.refreshPlayer();
        }
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
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Image.asset(
              'assets/images/travel/border_checkpoint.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            Text(_confirmTitle()),
          ],
        ),
        content: Text(l10n.travelContinueConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
        showTopRightFromSnackBar(context, 
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
        } else {
          await authProvider.refreshPlayer();
        }
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
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            Image.asset(
              'assets/images/travel/journey_cancelled.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            Text(_confirmTitle()),
          ],
        ),
        content: Text(l10n.confirmAction),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
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
      final data = jsonDecode(response.body);
      final messageKey = data['messageKey'] as String?;
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(
              messageKey == 'travelJourneyCanceled'
                  ? l10n.travelJourneyCanceled
                  : l10n.travelJourneyCanceled,
            ),
            backgroundColor: Colors.orange,
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

  Widget _buildTravelHeader(AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                'assets/images/travel/route_map.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/travel/journey_start.png',
                  width: 28,
                  height: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.travel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/travel/en_route.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.85),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${l10n.travelRouteLabel}:',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    routeText,
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
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isTraveling ? null : _continueJourney,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade600,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(l10n.travelContinue),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _isTraveling ? null : _cancelJourney,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(l10n.travelCancelJourney),
                      ),
                    ],
                  ),
                ],
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.travel)),
      body: _cooldownSeconds != null && _cooldownSeconds! > 0
          ? CooldownOverlay(
              actionType: 'travel',
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
                _loadCountries();
              },
            )
          : _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTravelHeader(l10n),
                if (_isInTransit) _buildJourneyCard(l10n),
                ..._countries.map((country) {
                  final isCurrent = country.id == currentCountry;
                  final displayCost = country.totalCost ?? country.flightCost;
                  final canAfford = (player?.money ?? 0) >= displayCost;
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
                          .map((id) {
                            return _resolveCountryNameWithFlag(id, l10n);
                          })
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

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isCurrent
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: ListTile(
                      leading: Icon(
                        FontAwesomeIcons.planeSolid,
                        size: 32,
                        color: isCurrent ? Colors.green : Colors.amber.shade600,
                      ),
                      title: Text(
                        '$countryFlag $localizedName',
                        style: TextStyle(
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCurrent
                                ? l10n.currentLocation
                                : l10n.travelCost(displayCost.toLocaleString()),
                          ),
                          if (routeDescription.isNotEmpty)
                            Text(
                              routeDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          if (legsInfo.isNotEmpty)
                            Text(
                              legsInfo,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed:
                            isCurrent ||
                                _isTraveling ||
                                !canAfford ||
                                _isInTransit
                            ? null
                            : () => _startJourney(country),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isCurrent
                              ? Colors.green
                              : Colors.amber.shade600,
                          foregroundColor: Colors.black,
                        ),
                        child: Text(isCurrent ? l10n.current : l10n.travelTo),
                      ),
                    ),
                  );
                }),
              ],
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
