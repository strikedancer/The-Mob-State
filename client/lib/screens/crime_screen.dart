import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/crime.dart';
import '../models/vehicle_crime.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/event_renderer.dart';
import '../services/jail_service.dart';
import '../services/tool_service.dart';
import '../widgets/jail_screen.dart';
import '../widgets/cooldown_overlay.dart';
import '../widgets/crime_card.dart';
import '../widgets/crime_result_overlay.dart';
import '../utils/top_right_notification.dart';

class CrimeScreen extends StatefulWidget {
  const CrimeScreen({super.key});

  @override
  State<CrimeScreen> createState() => _CrimeScreenState();
}

class _CrimeScreenState extends State<CrimeScreen> {
  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();
  final ToolService _toolService = ToolService();
  static const Set<String> _excludedCrimeIds = {'car_theft', 'steal_yacht'};
  List<Crime> _crimes = [];
  bool _isLoading = true;
  bool _isCommittingCrime = false;
  String? _error;
  int? _jailTime; // null = not jailed, >0 = SECONDS remaining
  int? _cooldownSeconds; // null = not on cooldown, >0 = seconds remaining
  String? _cooldownResultMessage;
  bool? _cooldownIsSuccess;
  String? _resultCrimeName;
  bool _showCrimeResult = false;
  int _crimeReward = 0;
  int _crimeXpGained = 0;

  @override
  void initState() {
    super.initState();
    _checkJailStatusAndLoadCrimes();
    _loadTools();
    _loadSelectedCrimeVehicle();
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
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingCrimes;
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

  Future<void> _loadCrimes() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/crimes');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final crimesJson = data['crimes'] as List;
        final crimes = crimesJson
            .map((c) => Crime.fromJson(c))
            .where((crime) => !_excludedCrimeIds.contains(crime.id))
            .toList();
        setState(() {
          _crimes = crimes;
          _isLoading = false;
        });
      } else {
        setState(() {
          final l10n = AppLocalizations.of(context)!;
          _error = l10n.errorLoadingCrimes;
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

  Future<void> _commitCrime(Crime crime) async {
    setState(() {
      _isCommittingCrime = true;
      _error = null;
    });

    try {
      final response = await _apiClient.post('/crimes/${crime.id}/attempt', {});

      print('[CrimeScreen] Response status: ${response.statusCode}');
      print('[CrimeScreen] Response body: ${response.body}');

      if (response.statusCode != 200) {
        // Handle non-200 responses
        final data = jsonDecode(response.body);
        final eventKey = data['event'] as String?;
        final params = (data['params'] as Map<String, dynamic>?) ?? {};

        setState(() {
          _isCommittingCrime = false;
        });

        if (eventKey != null) {
          final l10n = AppLocalizations.of(context)!;
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

      print('[CrimeScreen] Event: $eventKey');
      print('[CrimeScreen] Params: $params');

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
        final remainingTime = params['remainingTime'] as int? ?? 0;
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
                    'images/cooldown_jail.png',
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
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text('⚒️ ${l10n.crimeErrorToolInStorage(toolsParam)}'),
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
      final l10n = AppLocalizations.of(context)!;
      final eventRenderer = EventRenderer(l10n);
      final message = eventRenderer.renderEvent(eventKey, params);

      setState(() {
        _isCommittingCrime = false;
      });

      // Check if cooldown info is in response
      int? cooldownSeconds;
      if (data.containsKey('cooldown') && data['cooldown'] != null) {
        final cooldownData = data['cooldown'] as Map<String, dynamic>;
        if (cooldownData['remainingSeconds'] != null) {
          cooldownSeconds = cooldownData['remainingSeconds'] as int;
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
            print('[CrimeScreen] Player data: $playerData');

            authProvider.updatePlayerStats(
              money: playerData['money'] as int?,
              xp: playerData['xp'] as int?,
              rank: playerData['rank'] as int?,
              health: playerData['health'] as int?,
              wantedLevel: playerData['wantedLevel'] as int?,
              fbiHeat: playerData['fbiHeat'] as int?,
            );
            print('[CrimeScreen] Player stats updated successfully');
            // Validate by refreshing to ensure XP is correct on server side
            await authProvider.refreshPlayer();
          } else {
            print('[CrimeScreen] No player data in response, refreshing...');
            // Fallback: refresh full player data
            await authProvider.refreshPlayer();
          }
        } catch (e) {
          print('[CrimeScreen] Error updating player stats: $e');
        }

        // Check if player was jailed as part of the crime
        bool wasJailed = false;
        int? jailTimeMinutes;
        if (params.containsKey('jailed') && params['jailed'] == true) {
          wasJailed = true;
          jailTimeMinutes = params['jailTime'] as int?;
          if (jailTimeMinutes != null && jailTimeMinutes > 0) {
            setState(() {
              _jailTime = jailTimeMinutes! * 60;
            });
            showTopRightFromSnackBar(
              context,
              SnackBar(
                content: Row(
                  children: [
                    Image.asset(
                      'images/cooldown_jail.png',
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
                duration: Duration(seconds: jailTimeMinutes > 1 ? 8 : 5),
              ),
            );
          }
        }

        // Show cooldown overlay ONLY if not jailed
        if (!wasJailed && cooldownSeconds != null && cooldownSeconds > 0) {
          final reward = params['reward'] as int? ?? 0;
          final xpGained = params['xpGained'] as int? ?? 0;

          if (eventKey.contains('success')) {
            setState(() {
              _resultCrimeName = crime.name;
              _crimeReward = reward;
              _crimeXpGained = xpGained;
              _showCrimeResult = reward > 0 || xpGained > 0;
              _cooldownSeconds = cooldownSeconds;
              _cooldownResultMessage = message;
              _cooldownIsSuccess = true;
            });
          } else {
            setState(() {
              _cooldownSeconds = cooldownSeconds;
              _cooldownResultMessage = message;
              _cooldownIsSuccess = eventKey.contains('success');
            });
          }
        } else {
          // No cooldown, just show snackbar
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(message),
              backgroundColor: eventKey.contains('success')
                  ? Colors.green
                  : Colors.red,
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
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
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

  String _localizedCrimeName(Crime crime, AppLocalizations l10n) {
    switch (crime.id) {
      case 'pickpocket':
        return l10n.crimePickpocketName;
      case 'shoplift':
        return l10n.crimeShopliftName;
      case 'steal_bike':
        return l10n.crimeStealBikeName;
      case 'car_theft':
        return l10n.crimeCarTheftName;
      case 'burglary':
        return l10n.crimeBurglaryName;
      case 'rob_store':
        return l10n.crimeRobStoreName;
      case 'mug_person':
        return l10n.crimeMugPersonName;
      case 'steal_car_parts':
        return l10n.crimeStealCarPartsName;
      case 'hijack_truck':
        return l10n.crimeHijackTruckName;
      case 'atm_theft':
        return l10n.crimeAtmTheftName;
      case 'jewelry_heist':
        return l10n.crimeJewelryHeistName;
      case 'vandalism':
        return l10n.crimeVandalismName;
      case 'graffiti':
        return l10n.crimeGraffitiName;
      case 'drug_deal_small':
        return l10n.crimeDrugDealSmallName;
      case 'drug_deal_large':
        return l10n.crimeDrugDealLargeName;
      case 'extortion':
        return l10n.crimeExtortionName;
      case 'kidnapping':
        return l10n.crimeKidnappingName;
      case 'arson':
        return l10n.crimeArsonName;
      case 'smuggling':
        return l10n.crimeSmugglingName;
      case 'assassination':
        return l10n.crimeAssassinationName;
      case 'hack_account':
        return l10n.crimeHackAccountName;
      case 'counterfeit_money':
        return l10n.crimeCounterfeitMoneyName;
      case 'identity_theft':
        return l10n.crimeIdentityTheftName;
      case 'rob_armored_truck':
        return l10n.crimeRobArmoredTruckName;
      case 'art_theft':
        return l10n.crimeArtTheftName;
      case 'protection_racket':
        return l10n.crimeProtectionRacketName;
      case 'casino_heist':
        return l10n.crimeCasinoHeistName;
      case 'bank_robbery':
        return l10n.crimeBankRobberyName;
      case 'steal_yacht':
        return l10n.crimeStealYachtName;
      case 'corrupt_official':
        return l10n.crimeCorruptOfficialName;
      default:
        return crime.name;
    }
  }

  String _localizedCrimeDescription(Crime crime, AppLocalizations l10n) {
    switch (crime.id) {
      case 'pickpocket':
        return l10n.crimePickpocketDesc;
      case 'shoplift':
        return l10n.crimeShopliftDesc;
      case 'steal_bike':
        return l10n.crimeStealBikeDesc;
      case 'car_theft':
        return l10n.crimeCarTheftDesc;
      case 'burglary':
        return l10n.crimeBurglaryDesc;
      case 'rob_store':
        return l10n.crimeRobStoreDesc;
      case 'mug_person':
        return l10n.crimeMugPersonDesc;
      case 'steal_car_parts':
        return l10n.crimeStealCarPartsDesc;
      case 'hijack_truck':
        return l10n.crimeHijackTruckDesc;
      case 'atm_theft':
        return l10n.crimeAtmTheftDesc;
      case 'jewelry_heist':
        return l10n.crimeJewelryHeistDesc;
      case 'vandalism':
        return l10n.crimeVandalismDesc;
      case 'graffiti':
        return l10n.crimeGraffitiDesc;
      case 'drug_deal_small':
        return l10n.crimeDrugDealSmallDesc;
      case 'drug_deal_large':
        return l10n.crimeDrugDealLargeDesc;
      case 'extortion':
        return l10n.crimeExtortionDesc;
      case 'kidnapping':
        return l10n.crimeKidnappingDesc;
      case 'arson':
        return l10n.crimeArsonDesc;
      case 'smuggling':
        return l10n.crimeSmugglingDesc;
      case 'assassination':
        return l10n.crimeAssassinationDesc;
      case 'hack_account':
        return l10n.crimeHackAccountDesc;
      case 'counterfeit_money':
        return l10n.crimeCounterfeitMoneyDesc;
      case 'identity_theft':
        return l10n.crimeIdentityTheftDesc;
      case 'rob_armored_truck':
        return l10n.crimeRobArmoredTruckDesc;
      case 'art_theft':
        return l10n.crimeArtTheftDesc;
      case 'protection_racket':
        return l10n.crimeProtectionRacketDesc;
      case 'casino_heist':
        return l10n.crimeCasinoHeistDesc;
      case 'bank_robbery':
        return l10n.crimeBankRobberyDesc;
      case 'steal_yacht':
        return l10n.crimeStealYachtDesc;
      case 'corrupt_official':
        return l10n.crimeCorruptOfficialDesc;
      default:
        return crime.description ?? '';
    }
  }

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
              crimeName: _resultCrimeName ?? l10n.crimes,
              reward: _crimeReward,
              xpGained: _crimeXpGained,
              onContinue: () {
                setState(() {
                  _showCrimeResult = false;
                  _resultCrimeName = null;
                  _crimeReward = 0;
                  _crimeXpGained = 0;
                });
                // Reload vehicle after crime to get updated stats
                _loadSelectedCrimeVehicle();
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
                // Load crimes after release
                _loadCrimes();
              },
            )
          : _cooldownSeconds != null && _cooldownSeconds! > 0
          ? CooldownOverlay(
              embedded: kIsWeb,
              actionType: 'crime',
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
                _loadCrimes();
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
                    onPressed: _loadCrimes,
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadCrimes,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'images/backgrounds/crime_background.png',
                    ),
                    fit: BoxFit.cover,
                    opacity: 0.3,
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    // Crime Cards Grid
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width < 480
                              ? 2
                              : MediaQuery.of(context).size.width < 900
                              ? 3
                              : 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.78,
                        ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final crime = _crimes[index];
                          final playerRank = player?.rank ?? 1;
                          final canCommit = playerRank >= crime.requiredRank;

                          if (index == 0) {
                            print(
                              '[CrimeScreen] DEBUG - Player rank: $playerRank',
                            );
                            print(
                              '[CrimeScreen] DEBUG - Crime: ${crime.id}, requiredRank: ${crime.requiredRank}, canCommit: $canCommit',
                            );
                            print(
                              '[CrimeScreen] DEBUG - isCommittingCrime: $_isCommittingCrime',
                            );
                          }

                          final localizedName = _localizedCrimeName(
                            crime,
                            l10n,
                          );
                          final localizedDescription =
                              _localizedCrimeDescription(crime, l10n);

                          return CrimeCard(
                            crime: crime,
                            canCommit: canCommit,
                            isCommitting: _isCommittingCrime,
                            onTap: () => _commitCrime(crime),
                            crimeName: localizedName,
                            crimeDescription: localizedDescription,
                          );
                        }, childCount: _crimes.length),
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
