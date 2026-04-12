import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/country_helper.dart';
import '../widgets/education_requirements_dialog.dart';
import '../utils/top_right_notification.dart';

class AmmoFactoryScreen extends StatefulWidget {
  const AmmoFactoryScreen({super.key});

  @override
  State<AmmoFactoryScreen> createState() => _AmmoFactoryScreenState();
}

class _AmmoFactoryScreenState extends State<AmmoFactoryScreen> {
  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _currentCountryFactory;
  Map<String, dynamic>? _myFactory;
  List<dynamic> _marketStock = [];
  bool _isLoading = true;
  bool _isWorking = false;
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  // Constants from backend
  static const int maxLevel = 5;
  static const int baseOutput = 295; // Sum of all ammo box sizes at level 1
  static const int productionIntervalMinutes = 5;
  static const int productionSessionHours = 8;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final factoriesResponse = await _apiClient.get('/ammo-factories');
      final myResponse = await _apiClient.get('/ammo-factories/my');
      final marketResponse = await _apiClient.get('/ammo/market');

      final factoriesData = jsonDecode(factoriesResponse.body);
      final myData = jsonDecode(myResponse.body);
      final marketData = jsonDecode(marketResponse.body);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentCountry = authProvider.currentPlayer?.currentCountry;

      final allFactories = (factoriesData['factories'] as List<dynamic>? ?? []);
      final currentCountryFactory = allFactories.firstWhere(
        (f) => f['countryId'] == currentCountry,
        orElse: () => null,
      );

      setState(() {
        _currentCountryFactory = currentCountryFactory as Map<String, dynamic>?;
        _myFactory = myData['factory'] as Map<String, dynamic>?;
        _marketStock = (marketData['stock'] as List<dynamic>? ?? []);
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  double _outputMultiplier(int level) {
    return 1 + (level - 1) * 2.46;
  }

  double _qualityMultiplier(int qualityLevel) {
    return 1 + (qualityLevel - 1) * 0.05;
  }

  int _getProductionOutput(int level) {
    return (baseOutput * _outputMultiplier(level)).toInt();
  }

  int _getProductionPerHour(int level) {
    return (_getProductionOutput(level) / 8).toInt();
  }

  Future<void> _showUpgradeDialog(String type) async {
    final l10n = AppLocalizations.of(context);
    if (_myFactory == null) return;

    final currentLevel = type == 'output'
        ? (_myFactory?['level'] ?? 1)
        : (_myFactory?['qualityLevel'] ?? 1);

    if (currentLevel >= maxLevel) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(
              l10n?.factoryUpgradeMaxLevel ?? 'Factory is at max level',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    final cost = 250000 * currentLevel;
    final nextLevel = currentLevel + 1;

    final nextOutput = type == 'output'
        ? _getProductionOutput(nextLevel)
        : _getProductionOutput(currentLevel);
    final nextQuality = type == 'quality'
        ? _qualityMultiplier(nextLevel)
        : _qualityMultiplier(currentLevel);

    final title = type == 'output'
        ? (l10n?.factoryUpgradeOutput ?? 'Upgrade Output')
        : (l10n?.factoryUpgradeQuality ?? 'Upgrade Quality');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n?.factoryCostLabel ?? "Cost"}: €${cost.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 8),
            if (type == 'output')
              Text(
                '${l10n?.factoryCurrentOutput ?? "Current Output"}: ${_getProductionOutput(currentLevel)} ${l10n?.factoryUnitsPerCycle ?? "units/8h max"}',
              )
            else
              Text(
                '${l10n?.factoryCurrentQuality ?? "Current Quality"}: ${_qualityMultiplier(currentLevel).toStringAsFixed(2)}x',
              ),
            const SizedBox(height: 4),
            if (type == 'output')
              Text(
                '${l10n?.factoryNextOutput ?? "Next Output"}: $nextOutput ${l10n?.factoryUnitsPerCycle ?? "units/8h max"}',
                style: TextStyle(color: Colors.green[700]),
              )
            else
              Text(
                '${l10n?.factoryNextQuality ?? "Next Quality"}: ${nextQuality.toStringAsFixed(2)}x',
                style: TextStyle(color: Colors.green[700]),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: _isWorking
                ? null
                : () {
                    Navigator.pop(context);
                    _confirmUpgrade(type);
                  },
            child: Text(l10n?.confirm ?? 'Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmUpgrade(String type) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isWorking = true);
    try {
      final response = await _apiClient.post('/ammo-factories/upgrade', {
        'type': type,
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          final msg = type == 'output'
              ? (l10n?.factoryUpgradeOutputSuccess ?? 'Output upgraded')
              : (l10n?.factoryUpgradeQualitySuccess ?? 'Quality upgraded');
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(msg),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        await _loadData();
      } else if (mounted) {
        final missing = (data['missing'] as List?) ?? const [];
        final isEducationLocked =
            data['error'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            missing.isNotEmpty;

        if (isEducationLocked) {
          await EducationRequirementsDialog.show(
            context,
            title: type == 'output'
                ? (l10n?.educationAmmoOutputUpgradeLockedTitle ??
                      '🔒 Output upgrade locked')
                : (l10n?.educationAmmoQualityUpgradeLockedTitle ??
                      '🔒 Quality upgrade locked'),
            subtitle: data['message']?.toString(),
            missingRequirements: missing,
          );
          return;
        }

        final message =
            data['message']?.toString() ??
            (l10n?.hitError(data.toString()) ?? 'Error: $data');
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }

  Future<void> _buyFactory(String countryId) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isWorking = true);
    try {
      final response = await _apiClient.post('/ammo-factories/buy', {
        'countryId': countryId,
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n?.factoryBought ?? 'Factory purchased'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        await _loadData();
      } else if (mounted) {
        final missing = (data['missing'] as List?) ?? const [];
        final isEducationLocked =
            data['error'] == 'EDUCATION_REQUIREMENTS_NOT_MET' ||
            missing.isNotEmpty;

        if (isEducationLocked) {
          await EducationRequirementsDialog.show(
            context,
            title:
                l10n?.educationAmmoFactoryPurchaseLockedTitle ??
                '🔒 Factory purchase locked',
            subtitle: data['message']?.toString(),
            missingRequirements: missing,
          );
          return;
        }

        final message =
            data['message']?.toString() ??
            (l10n?.hitError(data.toString()) ?? 'Error: $data');
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }

  Future<void> _produce() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isWorking = true);
    try {
      final response = await _apiClient.post('/ammo-factories/produce', {});
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          final sessionStarted = data['sessionStarted'] == true;
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                sessionStarted
                    ? (l10n?.factorySessionStarted ??
                          'Production started: active for 8 hours, new ammo every 5 minutes')
                    : (l10n?.factoryProduced ?? 'Production updated'),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        await _loadData();
      } else if (mounted) {
        final message =
            data['message']?.toString() ??
            (l10n?.hitError(data.toString()) ?? 'Error: $data');
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }

  Future<void> _buyAmmo(String ammoType, [String? factoryId]) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: '1');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Munitie kopen'
                  : 'Buy ammo',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n?.ammoBoxes ?? 'Boxes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n?.buy ?? 'Buy'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final boxes = int.tryParse(controller.text) ?? 0;
    if (boxes < 1) return;

    setState(() => _isWorking = true);
    try {
      final response = await _apiClient.post('/ammo/buy', {
        'ammoType': ammoType,
        'boxes': boxes,
      });
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(l10n?.ammoPurchased ?? 'Ammo purchased'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        await _loadData();
      } else if (mounted) {
        final message =
            data['message']?.toString() ??
            (l10n?.hitError(data.toString()) ?? 'Error: $data');
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isWorking = false);
      }
    }
  }

  String _formatDate(String? iso) {
    if (iso == null) return '-';
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) return '-';
    return DateFormat('dd-MM HH:mm').format(parsed);
  }

  DateTime? _parseFactoryDate(String? iso) {
    if (iso == null) return null;
    return DateTime.tryParse(iso);
  }

  DateTime? _getSessionStart() {
    if (_myFactory == null) return null;
    final lastActiveAt = _parseFactoryDate(
      _myFactory?['lastActiveAt']?.toString(),
    );
    final lastProducedAt = _parseFactoryDate(
      _myFactory?['lastProducedAt']?.toString(),
    );
    return lastActiveAt ?? lastProducedAt;
  }

  DateTime? _getSessionEnd() {
    final sessionStart = _getSessionStart();
    if (sessionStart == null) return null;
    return sessionStart.add(const Duration(hours: productionSessionHours));
  }

  DateTime? _getNextProductionAt() {
    final sessionEnd = _getSessionEnd();
    final lastProducedAt = _parseFactoryDate(
      _myFactory?['lastProducedAt']?.toString(),
    );

    if (sessionEnd == null || lastProducedAt == null) return null;
    if (_now.isAfter(sessionEnd)) return null;

    final next = lastProducedAt.add(
      const Duration(minutes: productionIntervalMinutes),
    );
    if (next.isAfter(sessionEnd)) return null;
    return next;
  }

  bool _isSessionActive() {
    final sessionEnd = _getSessionEnd();
    final lastProducedAt = _parseFactoryDate(
      _myFactory?['lastProducedAt']?.toString(),
    );
    if (sessionEnd == null || lastProducedAt == null) return false;
    return _now.isBefore(sessionEnd);
  }

  String _formatDuration(Duration duration) {
    final totalSeconds = duration.inSeconds;
    if (totalSeconds <= 0) return '00:00';

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _getAmmoName(String ammoType) {
    switch (ammoType) {
      case '9mm':
        return '9mm';
      case '45acp':
        return '.45 ACP';
      case '12gauge':
        return '12 Gauge';
      case '556mm':
        return '5.56mm';
      case '762mm':
        return '7.62mm';
      case '308':
        return '.308 Winchester';
      default:
        return ammoType;
    }
  }

  Widget _buildAmmoMarket(
    Map<String, dynamic> factory,
    AppLocalizations? l10n,
  ) {
    final isMyFactory = _myFactory?['id'] == factory['id'];
    final factoryLabel = isMyFactory
        ? (l10n?.myFactory ?? 'My Factory')
        : (factory['owner']?['username'] ?? 'Factory');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${l10n?.ammoMarket ?? "Ammo Market"} - $factoryLabel',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width < 520 ? 1 : 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.7,
          ),
          itemCount: _marketStock.length,
          itemBuilder: (context, index) {
            final stock = _marketStock[index] as Map<String, dynamic>;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: const Color(0xFFFFC107).withOpacity(0.55),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[900]?.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.inventory_2,
                        color: Color(0xFFFFC107),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getAmmoName(stock['ammoType']?.toString() ?? ''),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${l10n?.ammoQuality ?? 'Quality'}: ${((stock['quality'] as num?)?.toDouble() ?? 1.0).toStringAsFixed(2)}x',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isWorking
                          ? null
                          : () => _buyAmmo(
                              stock['ammoType']?.toString() ?? '',
                              factory['id']?.toString(),
                            ),
                      child: Text(l10n?.buy ?? 'Buy'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sessionEnd = _getSessionEnd();
    final nextProductionAt = _getNextProductionAt();
    final isSessionActive = _isSessionActive();
    final isProduceReady =
        !isSessionActive ||
        (nextProductionAt != null && !_now.isBefore(nextProductionAt));

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/backgrounds/ammo_factory_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.4,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.ammoFactoryTitle ?? 'Ammo Factory',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.ammoFactoryIntro ??
                        'Produces automatically every 5 minutes. You can claim up to 8 hours of backlog.',
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n?.ammoFactoryWhatYouCanDo ?? 'What you can do:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• ${l10n?.ammoFactoryActionBuy ?? 'Buy a factory in your current country'}',
                  ),
                  Text(
                    '• ${l10n?.ammoFactoryActionProduce ?? 'Claim production (interval: 5 minutes, max backlog: 8 hours)'}',
                  ),
                  Text(
                    '• ${l10n?.ammoFactoryActionOutput ?? 'Upgrade output to level 5 (max ±3200 per 8h / ±400 per hour)'}',
                  ),
                  Text(
                    '• ${l10n?.ammoFactoryActionQuality ?? 'Upgrade quality for stronger market prices'}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Current Country Factory Section
          if (_currentCountryFactory != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n?.ammoFactoryTitle ?? 'Ammo Factory',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n?.factoryCountry ?? 'Country'}: ${l10n != null ? CountryHelper.getLocalizedCountryName(_currentCountryFactory?['countryId']?.toString(), l10n) : '-'}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),

                    // If I don't own it
                    if (_myFactory == null ||
                        _myFactory?['countryId'] !=
                            _currentCountryFactory?['countryId'])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentCountryFactory?['owner'] == null
                                ? (l10n?.factoryUnowned ?? 'Available')
                                : (l10n?.factoryOwnedBy(
                                        _currentCountryFactory?['owner']?['username'] ??
                                            'Unknown',
                                      ) ??
                                      'Owner: Unknown'),
                          ),
                          const SizedBox(height: 8),
                          if (_currentCountryFactory?['owner'] == null)
                            ElevatedButton(
                              onPressed: _isWorking
                                  ? null
                                  : () => _buyFactory(
                                      _currentCountryFactory?['countryId'],
                                    ),
                              child: Text(l10n?.factoryBuy ?? 'Buy'),
                            )
                          else
                            _buildAmmoMarket(
                              _currentCountryFactory ?? {},
                              l10n,
                            ),
                        ],
                      )
                    // If I own it
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.myFactory ?? 'My Factory',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              border: Border.all(color: Colors.blue[200]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${l10n?.factoryOutputLevel ?? 'Output level'}: ${_myFactory?['level'] ?? 1}/$maxLevel',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${l10n?.factoryProductionOutput('${_getProductionOutput(_myFactory?['level'] ?? 1)}') ?? "Output"}: ${_getProductionOutput(_myFactory?['level'] ?? 1)} ${l10n?.factoryUnitsPerCycle ?? 'units/8h max'} (±${_getProductionPerHour(_myFactory?['level'] ?? 1)} ${l10n?.factoryUnitsPerHour ?? 'units/hour'})',
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${l10n?.factoryQualityLevel ?? 'Quality level'}: ${_myFactory?['qualityLevel'] ?? 1}/$maxLevel',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${l10n?.factoryQualityMultiplier(((_qualityMultiplier(_myFactory?['qualityLevel'] ?? 1)).toStringAsFixed(2))) ?? "Quality"}: ${(_qualityMultiplier(_myFactory?['qualityLevel'] ?? 1)).toStringAsFixed(2)}x',
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${l10n?.factoryLastProduced ?? 'Last produced'}: ${_formatDate(_myFactory?['lastProducedAt']?.toString())}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isSessionActive
                                ? (l10n?.factorySessionActive ??
                                      'Production window: active (5 min interval)')
                                : (l10n?.factorySessionStopped ??
                                      'Production window: stopped (click Produce to start a new 8-hour window)'),
                            style: TextStyle(
                              color: isSessionActive
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (isSessionActive && sessionEnd != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              l10n?.factorySessionEndsIn(
                                    _formatDuration(
                                      sessionEnd.difference(_now),
                                    ),
                                  ) ??
                                  'Window ends in: ${_formatDuration(sessionEnd.difference(_now))}',
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ],
                          if (isSessionActive && nextProductionAt != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              _now.isAfter(nextProductionAt)
                                  ? (l10n?.factoryNextProductionReady ??
                                        'Next production: available now (press Produce to claim)')
                                  : (l10n?.factoryNextProductionIn(
                                          _formatDuration(
                                            nextProductionAt.difference(_now),
                                          ),
                                        ) ??
                                        'Next production in: ${_formatDuration(nextProductionAt.difference(_now))}'),
                              style: TextStyle(color: Colors.blue[700]),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                '${l10n?.factoryProduceStatusLabel ?? 'Produce status'}:',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isProduceReady
                                      ? Colors.green[100]
                                      : Colors.orange[100],
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: isProduceReady
                                        ? Colors.green[300]!
                                        : Colors.orange[300]!,
                                  ),
                                ),
                                child: Text(
                                  isProduceReady
                                      ? (l10n?.factoryProduceStatusReady ??
                                            'Ready')
                                      : (l10n?.factoryProduceStatusCooldown ??
                                            'Cooldown'),
                                  style: TextStyle(
                                    color: isProduceReady
                                        ? Colors.green[800]
                                        : Colors.orange[800],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: _isWorking ? null : _produce,
                                child: Text(l10n?.factoryProduce ?? 'Produce'),
                              ),
                              OutlinedButton(
                                onPressed: _isWorking
                                    ? null
                                    : () => _showUpgradeDialog('output'),
                                child: Text(
                                  l10n?.factoryUpgradeOutput ??
                                      'Upgrade Output',
                                ),
                              ),
                              OutlinedButton(
                                onPressed: _isWorking
                                    ? null
                                    : () => _showUpgradeDialog('quality'),
                                child: Text(
                                  l10n?.factoryUpgradeQuality ??
                                      'Upgrade Quality',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildAmmoMarket(_myFactory ?? {}, l10n),
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
}
