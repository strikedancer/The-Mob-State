import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../models/vehicle.dart';
import '../providers/vehicle_provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../services/jail_service.dart';
import '../widgets/jail_screen.dart';
import '../widgets/overlay_image.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/cooldown_overlay.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/formatters.dart';

class MarinaScreen extends StatefulWidget {
  const MarinaScreen({super.key, this.embedded = false, this.titleOverride});

  final bool embedded;
  final String? titleOverride;

  @override
  State<MarinaScreen> createState() => _MarinaScreenState();
}

class _MarinaScreenState extends State<MarinaScreen> {
  String _sortBy = 'value'; // value, condition, fuel, name
  final ApiClient _apiClient = ApiClient();
  final JailService _jailService = JailService();
  int? _selectedVehicleId;
  int? _jailTime;
  bool _isStealAttemptRunning = false;
  int _stealCooldownSeconds = 0;
  bool _showStealCooldownOverlay = false;
  Timer? _stealCooldownTimer;

  String _tr(String nl, String en) {
    return Localizations.localeOf(context).languageCode == 'nl' ? nl : en;
  }

  String _confirmTitle() => _tr('Weet je het zeker?', 'Are you sure?');

  String get _sectionTitle =>
      widget.titleOverride ?? AppLocalizations.of(context)!.marina;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkJailStatusAndLoadData();
    });
  }

  @override
  void dispose() {
    _stealCooldownTimer?.cancel();
    super.dispose();
  }

  void _startStealCooldown(int seconds) {
    _stealCooldownTimer?.cancel();
    if (seconds <= 0) {
      setState(() {
        _stealCooldownSeconds = 0;
        _showStealCooldownOverlay = false;
      });
      return;
    }

    setState(() {
      _stealCooldownSeconds = seconds;
    });

    _stealCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_stealCooldownSeconds <= 1) {
        timer.cancel();
        setState(() {
          _stealCooldownSeconds = 0;
          _showStealCooldownOverlay = false;
        });
        return;
      }

      setState(() {
        _stealCooldownSeconds -= 1;
      });
    });
  }

  Future<void> _checkJailStatusAndLoadData() async {
    final jailTime = await _jailService.checkJailStatus();
    if (!mounted) return;

    if (jailTime > 0) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.refreshPlayer();
      if (!mounted) return;

      setState(() {
        _jailTime = jailTime;
      });
      return;
    }

    setState(() {
      _jailTime = null;
    });

    await _loadData();
  }

  Future<void> _loadData() async {
    final vehicleProvider = Provider.of<VehicleProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';

    await Future.wait([
      vehicleProvider.fetchInventory(),
      vehicleProvider.fetchMarinaStatus(currentCountry),
      _loadSelectedVehicle(),
    ]);
  }

  Future<void> _loadSelectedVehicle() async {
    try {
      final response = await _apiClient.get('/garage/crime-vehicle');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['vehicleInventoryId'] != null) {
          setState(() {
            _selectedVehicleId = data['vehicleInventoryId'];
          });
        } else {
          setState(() {
            _selectedVehicleId = null;
          });
        }
      }
    } catch (e) {
      print('[MarinaScreen] Error loading selected vehicle: $e');
    }
  }

  List<dynamic> _getSortedVehicles(VehicleProvider provider) {
    var vehicles = provider.boats;

    // Sort
    vehicles.sort((a, b) {
      switch (_sortBy) {
        case 'value':
          return b.getMarketValue().compareTo(a.getMarketValue());
        case 'condition':
          return b.condition.compareTo(a.condition);
        case 'fuel':
          return b.fuelLevel.compareTo(a.fuelLevel);
        case 'name':
          final nameA = a.definition?.name ?? '';
          final nameB = b.definition?.name ?? '';
          return nameA.compareTo(nameB);
        default:
          return 0;
      }
    });

    return vehicles;
  }

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    final content = Stack(
      children: [
        _jailTime != null && _jailTime! > 0
            ? JailOverlay(
                remainingSeconds: _jailTime!,
                wantedLevel: authProvider.currentPlayer?.wantedLevel,
                embedded: true,
                onReleased: () {
                  setState(() {
                    _jailTime = null;
                  });
                  _checkJailStatusAndLoadData();
                },
              )
            : Column(
                children: [
                  if (vehicleProvider.marinaStatus != null)
                    _buildCapacityIndicator(vehicleProvider, authProvider),
                  Expanded(child: _buildVehicleGrid(vehicleProvider)),
                ],
              ),
        if (_jailTime == null &&
            _stealCooldownSeconds > 0 &&
            _showStealCooldownOverlay)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _showStealCooldownOverlay = false;
                });
              },
              child: Container(
                color: Colors.black45,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: CooldownOverlay(
                    actionType: 'crime',
                    remainingSeconds: _stealCooldownSeconds,
                    embedded: true,
                    resultMessage: _tr(
                      'Boot stelen staat op cooldown.',
                      'Boat theft is on cooldown.',
                    ),
                    isSuccess: false,
                    onExpired: () {
                      if (!mounted) return;
                      _stealCooldownTimer?.cancel();
                      setState(() {
                        _stealCooldownSeconds = 0;
                        _showStealCooldownOverlay = false;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/backgrounds/marina_background.png'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: widget.embedded
            ? null
            : AppBar(
                title: Text(_sectionTitle),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _checkJailStatusAndLoadData,
                  ),
                  IconButton(
                    icon: const Icon(Icons.directions_boat_filled_outlined),
                    tooltip: _tr('Beschikbare boten', 'Available boats'),
                    onPressed: () => _showAvailableBoatCatalog(
                      vehicleProvider,
                      authProvider,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.sort),
                    onSelected: (value) {
                      setState(() {
                        _sortBy = value;
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'value',
                        child: Text(AppLocalizations.of(context)!.byValue),
                      ),
                      PopupMenuItem(
                        value: 'condition',
                        child: Text(AppLocalizations.of(context)!.byCondition),
                      ),
                      PopupMenuItem(
                        value: 'fuel',
                        child: Text(AppLocalizations.of(context)!.byFuel),
                      ),
                      PopupMenuItem(
                        value: 'name',
                        child: Text(AppLocalizations.of(context)!.byName),
                      ),
                    ],
                  ),
                ],
              ),
        body: content,
      ),
    );
  }

  Widget _buildCapacityIndicator(
    VehicleProvider vehicleProvider,
    AuthProvider authProvider,
  ) {
    final marinaStatus = vehicleProvider.marinaStatus!;
    const goldColor = Color(0xFFD4AF37);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 500;
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 12 : 20,
            vertical: isSmall ? 10 : 14,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_boat,
                        color: goldColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.marinaCapacity,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  fontSize: isSmall ? 12 : 14,
                                ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.marinaBoatsCount(
                              marinaStatus.capacity.toString(),
                              marinaStatus.totalCapacity.toString(),
                            ),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white54,
                                  fontSize: isSmall ? 10 : 12,
                                ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.rankRequired(10),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.orangeAccent,
                                  fontSize: isSmall ? 10 : 12,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (isSmall) ...[
                        Tooltip(
                          message: AppLocalizations.of(context)!.stealBoat,
                          child: InkWell(
                            onTap: _isStealAttemptRunning
                                ? null
                                : () =>
                                      _stealBoat(vehicleProvider, authProvider),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.lightBlue.shade300,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.sailing,
                                color: Colors.lightBlue.shade300,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: marinaStatus.currentUpgradeLevel < 5
                              ? AppLocalizations.of(
                                  context,
                                )!.marinaUpgradeWithCost(
                                  _getUpgradeCost(
                                    marinaStatus.currentUpgradeLevel,
                                  ).toString(),
                                )
                              : AppLocalizations.of(context)!.marinaMaxLevel,
                          child: InkWell(
                            onTap: marinaStatus.currentUpgradeLevel < 5
                                ? () => _upgradeMarina(
                                    vehicleProvider,
                                    authProvider,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: marinaStatus.currentUpgradeLevel < 5
                                      ? goldColor
                                      : Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.upgrade,
                                color: marinaStatus.currentUpgradeLevel < 5
                                    ? goldColor
                                    : Colors.grey,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        OutlinedButton.icon(
                          onPressed: _isStealAttemptRunning
                              ? null
                              : () => _stealBoat(vehicleProvider, authProvider),
                          icon: const Icon(Icons.sailing, size: 16),
                          label: Text(
                            _stealCooldownSeconds > 0
                                ? '${AppLocalizations.of(context)!.stealBoat} (${_stealCooldownSeconds}s)'
                                : AppLocalizations.of(context)!.stealBoat,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.lightBlue.shade300,
                            side: BorderSide(color: Colors.lightBlue.shade300),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: marinaStatus.currentUpgradeLevel < 5
                              ? () => _upgradeMarina(
                                  vehicleProvider,
                                  authProvider,
                                )
                              : null,
                          icon: const Icon(Icons.upgrade, size: 16),
                          label: Text(
                            marinaStatus.currentUpgradeLevel < 5
                                ? AppLocalizations.of(
                                    context,
                                  )!.marinaUpgradeWithCost(
                                    _getUpgradeCost(
                                      marinaStatus.currentUpgradeLevel,
                                    ).toString(),
                                  )
                                : AppLocalizations.of(context)!.marinaMaxLevel,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: goldColor,
                            side: const BorderSide(color: goldColor),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: marinaStatus.getUsagePercentage(),
                  backgroundColor: const Color(0xFF3A3A3A),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    marinaStatus.isFull() ? Colors.red.shade700 : goldColor,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVehicleGrid(VehicleProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && !provider.error!.contains('vol')) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.error!, style: TextStyle(color: Colors.grey[700])),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: Text(l10n.retryAgain)),
          ],
        ),
      );
    }

    final boats = provider.boats;

    if (boats.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sailing, size: 64, color: Colors.grey[500]),
            const SizedBox(height: 16),
            Text(
              l10n.noBoatsInMarina,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.stealBoatsToStart,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final sortedBoats = _getSortedVehicles(provider);

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 350,
          childAspectRatio: 0.50,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: sortedBoats.length,
        itemBuilder: (context, index) {
          final boat = sortedBoats[index];
          return VehicleCard(
            vehicle: boat,
            onSelectForCrimes: _selectedVehicleId == boat.id
                ? null
                : () => _selectForCrimes(boat),
            onDeselectForCrimes: _selectedVehicleId == boat.id
                ? _deselectForCrimes
                : null,
            isSelectedForCrimes: _selectedVehicleId == boat.id,
            onRefuel: () => _refuelVehicle(provider, boat),
            onRepair: () => _repairVehicle(provider, boat),
            onSell: () => _sellVehicle(provider, boat.id),
            onScrap: () => _scrapVehicle(provider, boat.id),
            onList: () => _showListOnMarketDialog(provider, boat),
          );
        },
      ),
    );
  }

  int _getUpgradeCost(int currentLevel) {
    final costs = [10000, 25000, 50000, 100000, 200000];
    return currentLevel < costs.length ? costs[currentLevel] : 0;
  }

  Future<void> _stealBoat(
    VehicleProvider provider,
    AuthProvider authProvider,
  ) async {
    if (_isStealAttemptRunning) {
      return;
    }

    if (_stealCooldownSeconds > 0) {
      setState(() {
        _showStealCooldownOverlay = true;
      });
      return;
    }

    setState(() {
      _isStealAttemptRunning = true;
    });

    final preJailSeconds = await _jailService.checkJailStatus();
    if (!mounted) return;
    if (preJailSeconds > 0) {
      setState(() {
        _jailTime = preJailSeconds;
        _isStealAttemptRunning = false;
      });
      return;
    }

    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';

    final success = await provider.stealVehicle(currentCountry, 'boat');

    if (!mounted) return;

    await authProvider.refreshPlayer();
    if (!mounted) return;

    // Always check jail status (theft can succeed but player arrested immediately after)
    final jailSeconds = await _jailService.checkJailStatus();
    if (!mounted) return;

    if (jailSeconds > 0) {
      setState(() {
        _jailTime = jailSeconds;
        _isStealAttemptRunning = false;
      });
      return;
    }

    final cooldownSeconds = provider.lastStealCooldownRemainingSeconds;
    if (cooldownSeconds > 0) {
      _startStealCooldown(cooldownSeconds);
    }

    if (!success && cooldownSeconds > 0) {
      setState(() {
        _isStealAttemptRunning = false;
        _showStealCooldownOverlay = true;
      });
      return;
    }

    if (!success &&
        provider.lastStealArrested &&
        provider.lastStealJailMinutes > 0) {
      setState(() {
        _jailTime = provider.lastStealJailMinutes * 60;
        _isStealAttemptRunning = false;
      });
      return;
    }

    if (success) {
      final successMessage = _withStealOutcomeDetails(
        AppLocalizations.of(context)!.boatStolen,
        provider,
      );
      setState(() {
        _isStealAttemptRunning = false;
      });
      final stolenBoat = provider.lastStolenVehicle;
      final xpGained = provider.lastStealXpGained;
      if (stolenBoat != null) {
        await _showStolenBoatDialog(stolenBoat, xpGained: xpGained);
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(successMessage),
            backgroundColor: Colors.green,
          ),
        );
      }
      await _loadData();
    } else {
      final errorMessage = _buildStealFailureMessage(provider);
      setState(() {
        _isStealAttemptRunning = false;
      });
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _showStolenBoatDialog(
    VehicleInventoryItem vehicle, {
    int xpGained = 0,
  }) async {
    final definition = vehicle.definition;
    final stats = definition?.stats;
    final l10n = AppLocalizations.of(context)!;

    String statText(int? value) {
      if (value == null) return '-';
      return value.toString();
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final image = vehicle.conditionImage;
        final screenWidth = MediaQuery.of(context).size.width;
        final dialogWidth = screenWidth < 600
            ? screenWidth - 32
            : screenWidth < 1024
            ? 560.0
            : 680.0;
        final imageHeight = screenWidth < 600 ? 150.0 : 220.0;

        return AlertDialog(
          title: Text(l10n.stolenVehicleTitle(l10n.vehicleTypeBoat)),
          content: SizedBox(
            width: dialogWidth,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image != null && image.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: OverlayImageBuilder()
                          .base('images/vehicles/$image')
                          .width(double.infinity)
                          .height(imageHeight)
                          .fit(BoxFit.contain)
                          .build(),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: imageHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.sailing, size: 48),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    definition?.name ??
                        l10n.unknownVehicleType(l10n.vehicleTypeBoat),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (xpGained > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      _tr('XP verdiend: +$xpGained', 'XP gained: +$xpGained'),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final statItems = [
                        (
                          label: l10n.vehicleStatSpeed,
                          value: statText(stats?.speed),
                          icon: Icons.speed,
                        ),
                        (
                          label: l10n.vehicleStatFuel,
                          value: '${vehicle.fuelLevel}%',
                          icon: Icons.local_gas_station,
                        ),
                        (
                          label: l10n.condition,
                          value: '${vehicle.condition}%',
                          icon: Icons.build_circle,
                        ),
                        (
                          label: l10n.armor,
                          value: statText(stats?.armor),
                          icon: Icons.shield,
                        ),
                        (
                          label: l10n.vehicleStatCargo,
                          value: statText(stats?.cargo),
                          icon: Icons.inventory_2,
                        ),
                        (
                          label: l10n.vehicleStatStealth,
                          value: statText(stats?.stealth),
                          icon: Icons.visibility_off,
                        ),
                      ];

                      final columns = constraints.maxWidth < 600 ? 1 : 2;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: statItems.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 3.8,
                        ),
                        itemBuilder: (context, index) {
                          final stat = statItems[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  stat.icon,
                                  size: 16,
                                  color: Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    stat.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  stat.value,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.continueAction),
            ),
          ],
        );
      },
    );
  }

  String _withStealOutcomeDetails(
    String baseMessage,
    VehicleProvider provider,
  ) {
    final details = <String>[];
    final xpGained = provider.lastStealXpGained;
    if (xpGained > 0) {
      details.add(_tr('XP: +$xpGained', 'XP: +$xpGained'));
    }

    final wantedLevel = provider.lastStealWantedLevel;
    if (wantedLevel != null) {
      details.add('Wanted: ${wantedLevel.toStringAsFixed(0)}');
    }

    if (provider.lastStealArrested && provider.lastStealJailMinutes > 0) {
      details.add(
        _tr(
          'Gevangenis: ${provider.lastStealJailMinutes} min',
          'Jail: ${provider.lastStealJailMinutes} min',
        ),
      );
    }

    final bail = provider.lastStealBailAmount;
    if (bail != null && bail > 0) {
      details.add(_tr('Borg: \$$bail', 'Bail: \$$bail'));
    }

    if (details.isEmpty) return baseMessage;
    return '$baseMessage\n${details.join(' | ')}';
  }

  String _buildStealFailureMessage(VehicleProvider provider) {
    final baseError =
        provider.error ?? AppLocalizations.of(context)!.stealFailed;
    final normalizedError = baseError.toLowerCase();
    final gotCaughtButEscaped =
        !provider.lastStealArrested &&
        provider.lastStealJailMinutes == 0 &&
        provider.lastStealCooldownRemainingSeconds == 0 &&
        (normalizedError.contains('gesnapt') ||
            normalizedError.contains('caught') ||
            normalizedError.contains('politie') ||
            normalizedError.contains('police') ||
            normalizedError.contains('wanted'));

    if (gotCaughtButEscaped) {
      return _withStealOutcomeDetails(
        _tr(
          'Je werd gesnapt door de politie, maar je wist te ontkomen.',
          'You were spotted by the police, but you managed to escape.',
        ),
        provider,
      );
    }

    return _withStealOutcomeDetails(baseError, provider);
  }

  Future<void> _upgradeMarina(
    VehicleProvider provider,
    AuthProvider authProvider,
  ) async {
    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';
    final success = await provider.upgradeMarina(currentCountry);

    if (!mounted) return;

    if (success) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(AppLocalizations.of(context)!.marinaUpgraded),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? AppLocalizations.of(context)!.marinaUpgradeFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sellVehicle(VehicleProvider provider, int vehicleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_confirmTitle()),
        content: Text(AppLocalizations.of(context)!.confirmSellBoat),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(AppLocalizations.of(context)!.sell),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await provider.sellVehicle(vehicleId);

    if (!mounted) return;

    if (success) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(AppLocalizations.of(context)!.boatSold),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? AppLocalizations.of(context)!.saleFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _scrapVehicle(VehicleProvider provider, int vehicleId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_confirmTitle()),
        content: Text(
          _tr(
            'Deze boot slopen voor onderdelen? Dit kan niet ongedaan gemaakt worden.',
            'Scrap this boat for parts? This cannot be undone.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_tr('Slopen', 'Scrap')),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await provider.scrapVehicle(vehicleId);

    if (!mounted) return;

    if (result != null) {
      final gained = result['partsGained'] as int? ?? 0;
      final type = (result['partsType'] as String? ?? 'boat').toLowerCase();
      final typeNl = type == 'motorcycle'
          ? 'motor'
          : type == 'boat'
          ? 'boot'
          : 'auto';
      final typeEn = type == 'motorcycle'
          ? 'motorcycle'
          : type == 'boat'
          ? 'boat'
          : 'car';
      final msg = _tr(
        'Voertuig gesloopt — +$gained $typeNl-onderdelen',
        'Vehicle scrapped — +$gained $typeEn parts',
      );
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(msg), backgroundColor: Colors.green),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? _tr('Slopen mislukt', 'Scrap failed'),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showListOnMarketDialog(
    VehicleProvider provider,
    vehicle,
  ) async {
    final priceController = TextEditingController(
      text: vehicle.getMarketValue().toStringAsFixed(0),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_confirmTitle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(
                context,
              )!.marketValue(vehicle.getMarketValue().toStringAsFixed(0)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.askingPrice,
                hintText: AppLocalizations.of(context)!.enterPrice,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(AppLocalizations.of(context)!.list),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final price = int.tryParse(priceController.text);
    if (price == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(AppLocalizations.of(context)!.invalidPrice),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await provider.listVehicleOnMarket(vehicle.id, price);

    if (!mounted) return;

    if (success) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(AppLocalizations.of(context)!.vehicleListed),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? AppLocalizations.of(context)!.listVehicleFailed,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refuelVehicle(VehicleProvider provider, vehicle) async {
    if (vehicle.definition?.fuelCapacity == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Dit voertuig heeft geen brandstoftank',
              'This vehicle has no fuel tank',
            ),
          ),
        ),
      );
      return;
    }

    final maxFuel = vehicle.definition!.fuelCapacity;
    final fuelPercentage = vehicle.fuelLevel; // This is a percentage (0-100)
    final currentFuel = (fuelPercentage / 100) * maxFuel; // Convert to liters
    final fuelNeeded = maxFuel - currentFuel;

    if (fuelNeeded <= 0.5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Tank is al vol', 'Tank is already full'))),
      );
      return;
    }

    final cost = fuelNeeded * 2; // €2 per liter

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_confirmTitle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Voertuig tanken', 'Refuel vehicle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Huidige brandstof: ${currentFuel.toStringAsFixed(1)}L / ${maxFuel}L',
                'Current fuel: ${currentFuel.toStringAsFixed(1)}L / ${maxFuel}L',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Benodigde brandstof: ${fuelNeeded.toStringAsFixed(1)}L',
                'Required fuel: ${fuelNeeded.toStringAsFixed(1)}L',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Kosten: €${cost.toStringAsFixed(0)}',
                'Cost: €${cost.toStringAsFixed(0)}',
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _tr(
                'Wil je dit voertuig volledig tanken?',
                'Do you want to fully refuel this vehicle?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr('Tanken', 'Refuel')),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await provider.refuelVehicle(vehicle.id, fuelNeeded.ceil());

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('Voertuig getankt!', 'Vehicle refueled!'))),
      );
      // Small delay to ensure data is fetched and UI updates
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _loadData();
      }
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? _tr('Tanken mislukt', 'Refueling failed'),
          ),
        ),
      );
    }
  }

  Future<void> _repairVehicle(VehicleProvider provider, vehicle) async {
    if (vehicle.repairInProgress == true) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr(
              'Dit voertuig is al in reparatie',
              'This vehicle is already being repaired',
            ),
          ),
        ),
      );
      return;
    }

    if (vehicle.condition >= 100) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _tr('Voertuig is niet beschadigd', 'Vehicle is not damaged'),
          ),
        ),
      );
      return;
    }

    final vehicleValue = vehicle.definition?.baseValue ?? 0;
    final damagePercent = 100 - vehicle.condition;
    final repairCost = (vehicleValue * damagePercent / 100).toInt();
    final estimatedRepairDuration = _estimateRepairDuration(
      vehicle.definition?.baseValue ?? 0,
      vehicle.condition,
      'boat',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_confirmTitle()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _tr('Voertuig repareren', 'Repair vehicle'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Huidige conditie: ${vehicle.condition.toInt()}%',
                'Current condition: ${vehicle.condition.toInt()}%',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Schade: ${damagePercent.toInt()}%',
                'Damage: ${damagePercent.toInt()}%',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Reparatiekosten: €${repairCost.toStringAsFixed(0)}',
                'Repair cost: €${repairCost.toStringAsFixed(0)}',
              ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                'Geschatte reparatietijd: ${formatAdaptiveDuration(estimatedRepairDuration, localeName: 'nl', includeSeconds: false)}',
                'Estimated repair time: ${formatAdaptiveDuration(estimatedRepairDuration, localeName: 'en', includeSeconds: false)}',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _tr(
                'Reparatie start direct, maar wordt pas na de timer afgerond.',
                'Repair starts immediately, but only completes after the timer ends.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr('Repareer', 'Repair')),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await provider.repairVehicle(vehicle.id);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _tr(
              'Reparatie gestart. De boot is tijdelijk niet beschikbaar.',
              'Repair started. The boat is temporarily unavailable.',
            ),
          ),
        ),
      );
      await _loadData();
    } else {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            provider.error ?? _tr('Reparatie mislukt', 'Repair failed'),
          ),
        ),
      );
    }
  }

  Duration _estimateRepairDuration(
    int baseValue,
    int currentCondition,
    String vehicleType,
  ) {
    final damagePercent = (100 - currentCondition).clamp(0, 100);
    final baseSeconds = vehicleType == 'boat' ? 20 * 60 : 12 * 60;
    final damageSeconds = damagePercent * (vehicleType == 'boat' ? 120 : 90);
    final valueSeconds = (baseValue / (vehicleType == 'boat' ? 120 : 200))
        .floor()
        .clamp(0, 6 * 60 * 60);
    final minSeconds = vehicleType == 'boat' ? 30 * 60 : 15 * 60;
    final totalSeconds = (baseSeconds + damageSeconds + valueSeconds).clamp(
      minSeconds,
      12 * 60 * 60,
    );
    return Duration(seconds: totalSeconds);
  }

  Color _rarityColor(String rarity) {
    switch (rarity) {
      case 'common':
        return Colors.grey.shade400;
      case 'uncommon':
        return Colors.green.shade400;
      case 'rare':
        return Colors.blue.shade300;
      case 'epic':
        return Colors.purple.shade300;
      case 'legendary':
        return Colors.amber.shade300;
      default:
        return Colors.white70;
    }
  }

  String _rarityLabel(String rarity) {
    switch (rarity) {
      case 'common':
        return _tr('Gewoon', 'Common');
      case 'uncommon':
        return _tr('Ongewoon', 'Uncommon');
      case 'rare':
        return _tr('Zeldzaam', 'Rare');
      case 'epic':
        return _tr('Episch', 'Epic');
      case 'legendary':
        return _tr('Legendarisch', 'Legendary');
      default:
        return rarity;
    }
  }

  Future<void> _showAvailableBoatCatalog(
    VehicleProvider provider,
    AuthProvider authProvider,
  ) async {
    final currentCountry =
        authProvider.currentPlayer?.currentCountry ?? 'netherlands';
    await provider.fetchAvailableVehicles(currentCountry);
    if (!mounted) return;

    final boats =
        provider.availableVehicles
            .where((vehicle) => vehicle.vehicleCategory == 'boat')
            .toList()
          ..sort((a, b) => (a.baseValue ?? 0).compareTo(b.baseValue ?? 0));
    final policeEvent = provider.policeVehicleEvent;
    final eventActive = policeEvent?['active'] == true;
    final eventCategory = (policeEvent?['activeCategory'] ?? '').toString();
    final eventRemaining =
        (policeEvent?['remainingSeconds'] as num?)?.toInt() ?? 0;
    final eventStartsIn =
        (policeEvent?['startsInSeconds'] as num?)?.toInt() ?? 0;
    final eventAllCategories = eventCategory.isEmpty || eventCategory == 'null';
    final eventAppliesToMarina =
        eventActive && (eventAllCategories || eventCategory == 'boat');

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Beschikbare boten', 'Available boats')),
        content: SizedBox(
          width: MediaQuery.of(context).size.width < 700
              ? double.maxFinite
              : 720,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: eventAppliesToMarina
                      ? Colors.orange.withOpacity(0.18)
                      : Colors.blueGrey.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: eventAppliesToMarina
                        ? Colors.orangeAccent
                        : Colors.white24,
                  ),
                ),
                child: Text(
                  eventAppliesToMarina
                      ? _tr(
                          'Politie-voertuig event actief - nog ${formatAdaptiveDurationFromSeconds(eventRemaining, localeName: Localizations.localeOf(context).languageCode)}',
                          'Police vehicle event active - ${formatAdaptiveDurationFromSeconds(eventRemaining, localeName: Localizations.localeOf(context).languageCode)} left',
                        )
                      : _tr(
                          'Volgende politie-boot event over ${formatAdaptiveDurationFromSeconds(eventStartsIn, localeName: Localizations.localeOf(context).languageCode)}',
                          'Next police boat event starts in ${formatAdaptiveDurationFromSeconds(eventStartsIn, localeName: Localizations.localeOf(context).languageCode)}',
                        ),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (boats.isEmpty)
                Text(
                  _tr(
                    'Er zijn nu geen boten beschikbaar in dit land.',
                    'There are currently no boats available in this country.',
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: boats.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vehicle = boats[index];
                      final image = vehicle.imageNew ?? vehicle.image;
                      final rarity = vehicle.rarity ?? 'common';
                      final marketValue =
                          vehicle.marketValue?[currentCountry] ??
                          vehicle.baseValue ??
                          0;
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (image != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: OverlayImageBuilder()
                                        .base('images/vehicles/$image')
                                        .width(90)
                                        .height(64)
                                        .fit(BoxFit.contain)
                                        .build(),
                                  )
                                else
                                  const SizedBox(width: 90, height: 64),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle.name ?? '-',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _rarityColor(
                                                rarity,
                                              ).withOpacity(0.16),
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                color: _rarityColor(rarity),
                                              ),
                                            ),
                                            child: Text(
                                              _rarityLabel(rarity),
                                              style: TextStyle(
                                                color: _rarityColor(rarity),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _tr(
                                              'Waarde: ${formatCurrency(marketValue)}',
                                              'Value: ${formatCurrency(marketValue)}',
                                            ),
                                          ),
                                          Text(
                                            _tr(
                                              'Rank: ${vehicle.requiredRank ?? '-'}',
                                              'Rank: ${vehicle.requiredRank ?? '-'}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(vehicle.description ?? ''),
                            const SizedBox(height: 8),
                            Text(
                              _tr(
                                'In spel: ${vehicle.currentWorldCount ?? 0}/${vehicle.maxGameAvailability ?? '-'} beschikbaar',
                                'In game: ${vehicle.currentWorldCount ?? 0}/${vehicle.maxGameAvailability ?? '-'} available',
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _tr(
                                'Landen: ${(vehicle.availableInCountries ?? const <String>[]).join(', ')}',
                                'Countries: ${(vehicle.availableInCountries ?? const <String>[]).join(', ')}',
                              ),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _selectForCrimes(dynamic vehicle) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final l10n = AppLocalizations.of(context)!;
      final playerCountry =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';
      final vehicleCountry = vehicle.stolenInCountry ?? 'netherlands';

      if (vehicleCountry != playerCountry) {
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.vehicleWrongCountry),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final response = await _apiClient.post('/garage/crime-vehicle', {
        'vehicleId': vehicle.id.toString(),
      });

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['params']?['vehicleInventoryId'] != null) {
          setState(() {
            _selectedVehicleId = data['params']['vehicleInventoryId'];
          });
        }
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.vehicleSelectedForCrimes),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _deselectForCrimes() async {
    final l10n = AppLocalizations.of(context)!;

    try {
      final response = await _apiClient.delete('/garage/crime-vehicle');

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _selectedVehicleId = null;
        });
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.vehicleDeselectedForCrimes),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.failedDeselectVehicle),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
