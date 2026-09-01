import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/country_helper.dart';
import '../utils/formatters.dart';
import '../widgets/education_requirements_dialog.dart';
import '../utils/top_right_notification.dart';
import 'black_market_screen.dart';
import 'school_screen.dart';

class AmmoFactoryScreen extends StatefulWidget {
  const AmmoFactoryScreen({super.key});

  @override
  State<AmmoFactoryScreen> createState() => _AmmoFactoryScreenState();
}

class _AmmoFactoryScreenState extends State<AmmoFactoryScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xE6151B28);
  static const Color _panelBorder = Color(0xFF3A4558);
  static const Color _accent = Color(0xFFE85D4C);

  final ApiClient _apiClient = ApiClient();
  Map<String, dynamic>? _currentCountryFactory;
  Map<String, dynamic>? _myFactory;
  Map<String, dynamic>? _purchaseContext;
  bool _isLoading = true;
  bool _isWorking = false;
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  // Constants from backend
  static const int maxLevel = 5;
  static const int baseRoundsPerTickPerType =
      3; // per ammo type, per production tick, at level 1 (matches backend BASE_ROUNDS_PER_TICK)
  static const int numAmmoTypes = 6;
  static const int productionIntervalMinutes = 20;
  static const int productionSessionHours = 8;
  static const int ticksPerHour = 3; // 60 min / 20 min
  static const int ticksPerSession = 24; // 8h × 3 ticks

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

      final factoriesData = jsonDecode(factoriesResponse.body);
      final myData = jsonDecode(myResponse.body);

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
        _purchaseContext = myData['purchase'] as Map<String, dynamic>?;
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

  // Total rounds per 8h session across all ammo types combined
  int _getProductionOutput(int level) {
    return (baseRoundsPerTickPerType *
            numAmmoTypes *
            ticksPerSession *
            _outputMultiplier(level))
        .toInt();
  }

  // Rounds per hour across all ammo types combined
  int _getProductionPerHour(int level) {
    return (baseRoundsPerTickPerType *
            numAmmoTypes *
            ticksPerHour *
            _outputMultiplier(level))
        .toInt();
  }

  Future<void> _showUpgradeDialog(String type) async {
    final l10n = AppLocalizations.of(context);
    if (_myFactory == null) return;

    final currentLevel = type == 'output'
        ? (_myFactory?['level'] ?? 1)
        : (_myFactory?['qualityLevel'] ?? 1);

    if (currentLevel >= maxLevel) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
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
          showTopRightFromSnackBar(
            context,
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

        final message = l10n != null
            ? _ammoFactoryFailureMessage(
                l10n,
                data,
                data.toString(),
                operation: 'upgrade',
              )
            : (data['message']?.toString() ??
                'Error: $data');
        showTopRightFromSnackBar(
          context,
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
          showTopRightFromSnackBar(
            context,
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

        final message = l10n != null
            ? _ammoFactoryFailureMessage(
                l10n,
                data,
                data.toString(),
                operation: 'buy',
              )
            : (data['message']?.toString() ??
                'Error: $data');
        showTopRightFromSnackBar(
          context,
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
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                sessionStarted
                    ? (l10n?.factorySessionStarted ??
                          'Production started: active for 8 hours, claim every 20 minutes')
                    : (l10n?.factoryProduced ?? 'Production updated'),
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
        await _loadData();
      } else if (mounted) {
        final message = l10n != null
            ? _ammoFactoryFailureMessage(
                l10n,
                data,
                data.toString(),
                operation: 'produce',
              )
            : (data['message']?.toString() ??
                'Error: $data');
        showTopRightFromSnackBar(
          context,
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

  /// Maps API [error] codes from `/ammo-factories/*` to localized messages.
  /// [operation] disambiguates `INSUFFICIENT_MONEY` and generic fallbacks.
  String? _localizedAmmoFactoryApiError(
    AppLocalizations l10n,
    String? errorCode, {
    required String operation,
  }) {
    switch (errorCode) {
      case 'MISSING_COUNTRY':
        return l10n.ammoFactoryErrCountryRequired;
      case 'PLAYER_NOT_FOUND':
        return l10n.ammoFactoryErrPlayerNotFound;
      case 'WRONG_COUNTRY':
        return l10n.ammoFactoryErrWrongCountry;
      case 'FACTORY_OWNED':
        return l10n.ammoFactoryErrAlreadyOwned;
      case 'INSUFFICIENT_MONEY':
        return operation == 'upgrade'
            ? l10n.ammoFactoryErrInsufficientMoneyUpgrade
            : l10n.ammoFactoryErrInsufficientMoneyBuy;
      case 'EDUCATION_REQUIREMENTS_NOT_MET':
        return l10n.ammoFactoryErrEducationNotMet;
      case 'FACTORY_NOT_OWNED':
        return l10n.ammoFactoryErrNotOwned;
      case 'COOLDOWN':
        return l10n.ammoFactoryErrOnCooldown;
      case 'FACTORY_INACTIVE':
        return l10n.ammoFactoryErrInactive;
      case 'MAX_LEVEL':
        return l10n.ammoFactoryErrMaxLevel;
      case 'INVALID_UPGRADE_TYPE':
        return l10n.ammoFactoryErrInvalidUpgradeType;
      default:
        return null;
    }
  }

  String _ammoFactoryFailureMessage(
    AppLocalizations l10n,
    Map<String, dynamic> data,
    String fallbackGeneric, {
    required String operation,
  }) {
    final code = data['error']?.toString();
    final mapped = _localizedAmmoFactoryApiError(
      l10n,
      code,
      operation: operation,
    );
    if (mapped != null) return mapped;
    final raw = data['message']?.toString();
    if (raw != null && raw.isNotEmpty) return raw;
    if (operation == 'produce') {
      return l10n.ammoFactoryErrCouldNotProduce;
    }
    if (operation == 'upgrade') {
      return l10n.ammoFactoryErrCouldNotUpgrade;
    }
    if (operation == 'buy') {
      return l10n.ammoFactoryErrCouldNotPurchase;
    }
    return l10n.hitError(fallbackGeneric);
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

  int get _purchasePrice {
    final fromApi = (_purchaseContext?['price'] as num?)?.toInt();
    return fromApi ?? 500000;
  }

  bool get _educationAllowed {
    final education = _purchaseContext?['education'] as Map<String, dynamic>?;
    return education?['allowed'] == true;
  }

  List<Map<String, dynamic>> get _missingEducation {
    final education = _purchaseContext?['education'] as Map<String, dynamic>?;
    return ((education?['missing'] as List?) ?? const [])
        .whereType<Map>()
        .map((entry) => entry.cast<String, dynamic>())
        .toList(growable: false);
  }

  String _trackName(String trackId, AppLocalizations l10n) {
    switch (trackId) {
      case 'aviation':
        return l10n.educationTrackNameAviation;
      case 'law':
        return l10n.educationTrackNameLaw;
      case 'medicine':
        return l10n.educationTrackNameMedicine;
      case 'finance':
        return l10n.educationTrackNameFinance;
      case 'engineering':
        return l10n.educationTrackNameEngineering;
      case 'it':
        return l10n.educationTrackNameIt;
      case 'narcotics':
        return l10n.educationTrackNameNarcotics;
      default:
        return trackId;
    }
  }

  String _certName(String certificationId, AppLocalizations l10n) {
    switch (certificationId) {
      case 'software_engineer':
        return l10n.educationCertSoftwareEngineer;
      case 'bar_exam':
        return l10n.educationCertBarExam;
      case 'medical_license':
        return l10n.educationCertMedicalLicense;
      case 'flight_commercial':
        return l10n.educationCertFlightCommercial;
      case 'flight_basic':
        return l10n.educationCertFlightBasic;
      case 'industrial_safety':
        return l10n.educationCertIndustrialSafety;
      case 'financial_analyst':
        return l10n.educationCertFinancialAnalyst;
      case 'casino_management':
        return l10n.educationCertCasinoManagement;
      case 'paramedic_cert':
        return l10n.educationCertParamedic;
      case 'hydroponic_specialist':
        return l10n.educationCertHydroponicSpecialist;
      case 'process_electrics_specialist':
        return l10n.educationCertProcessElectricsSpecialist;
      case 'clandestine_chemist':
        return l10n.educationCertClandestineChemist;
      case 'narco_grid_architect':
        return l10n.educationCertNarcoGridArchitect;
      default:
        return certificationId;
    }
  }

  ({IconData icon, String title, String subtitle, bool met}) _formatRequirement(
    Map<String, dynamic> requirement,
    AppLocalizations l10n,
  ) {
    final code = requirement['code']?.toString() ?? '';
    final params =
        (requirement['params'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    if (code == 'TRACK_LEVEL_REQUIRED') {
      final trackId = params['trackId']?.toString() ?? '';
      final requiredLevel = (params['requiredLevel'] as num?)?.toInt() ?? 0;
      final currentLevel = (params['currentLevel'] as num?)?.toInt() ?? 0;
      return (
        icon: Icons.school_outlined,
        title: l10n.educationRequirementTrackLevelTitle,
        subtitle: l10n.educationRequirementTrackLevelProgress(
          _trackName(trackId, l10n),
          requiredLevel,
          currentLevel,
        ),
        met: currentLevel >= requiredLevel,
      );
    }

    if (code == 'CERTIFICATION_REQUIRED') {
      final certificationId = params['certificationId']?.toString() ?? '';
      return (
        icon: Icons.verified_outlined,
        title: l10n.educationRequirementCertificationTitle,
        subtitle: _certName(certificationId, l10n),
        met: false,
      );
    }

    return (
      icon: Icons.info_outline,
      title: l10n.educationRequirementGenericTitle,
      subtitle:
          requirement['reasonKey']?.toString() ??
          l10n.educationRequirementUnknown,
      met: false,
    );
  }

  void _openSchool() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SchoolScreen()),
    );
  }

  Widget _buildPanel({
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? _panelBorder),
      ),
      child: child,
    );
  }

  Widget _buildRequirementTile(
    AppLocalizations l10n,
    Map<String, dynamic> requirement,
  ) {
    final formatted = _formatRequirement(requirement, l10n);
    final accent = formatted.met ? Colors.greenAccent : const Color(0xFFFFB74D);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withOpacity(0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            formatted.met ? Icons.check_circle : formatted.icon,
            color: accent,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatted.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatted.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsSection(AppLocalizations l10n) {
    final missing = _missingEducation;

    return _buildPanel(
      borderColor: _gold.withOpacity(0.35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _educationAllowed ? Icons.verified : Icons.lock_outline,
                color: _educationAllowed ? Colors.greenAccent : _gold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.ammoFactoryRequirementsTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_educationAllowed)
            Text(
              l10n.ammoFactoryRequirementsComplete,
              style: TextStyle(color: Colors.greenAccent.withOpacity(0.95)),
            )
          else ...[
            Text(
              l10n.schoolGateAssetAmmoFactoryPurchase,
              style: TextStyle(color: Colors.white.withOpacity(0.72), fontSize: 12),
            ),
            const SizedBox(height: 10),
            ...missing.map((req) => _buildRequirementTile(l10n, req)),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: _openSchool,
              icon: const Icon(Icons.school_outlined, size: 18),
              label: Text(l10n.ammoFactoryGoToSchool),
              style: OutlinedButton.styleFrom(
                foregroundColor: _gold,
                side: BorderSide(color: _gold.withOpacity(0.65)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPurchaseCard(
    BuildContext context,
    AppLocalizations l10n,
    int playerMoney,
  ) {
    final countryId = _currentCountryFactory?['countryId']?.toString();
    final countryName = countryId == null
        ? '-'
        : CountryHelper.getLocalizedCountryName(countryId, l10n);
    final canAfford = playerMoney >= _purchasePrice;
    final canBuy = _educationAllowed && canAfford && !_isWorking;

    return _buildPanel(
      borderColor: _accent.withOpacity(0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _accent.withOpacity(0.45)),
                ),
                child: const Icon(Icons.factory_outlined, color: _accent, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ammoFactoryTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${l10n.factoryCountry}: $countryName',
                      style: TextStyle(color: Colors.white.withOpacity(0.72)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.green.withOpacity(0.35)),
                ),
                child: Text(
                  l10n.factoryUnowned,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            l10n.ammoFactoryPurchasePriceLabel,
            style: TextStyle(
              color: Colors.white.withOpacity(0.65),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatCurrency(_purchasePrice),
            style: TextStyle(
              color: canAfford ? Colors.greenAccent : Colors.redAccent,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
          if (!canAfford) ...[
            const SizedBox(height: 6),
            Text(
              l10n.ammoFactoryErrInsufficientMoneyBuy,
              style: TextStyle(color: Colors.redAccent.withOpacity(0.9), fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          _buildRequirementsSection(l10n),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: canBuy && countryId != null
                  ? () => _buyFactory(countryId)
                  : (!_educationAllowed
                        ? () => EducationRequirementsDialog.show(
                            context,
                            title: l10n.educationAmmoFactoryPurchaseLockedTitle,
                            missingRequirements: _missingEducation,
                          )
                        : null),
              icon: Icon(
                _educationAllowed ? Icons.shopping_cart_outlined : Icons.lock_outline,
              ),
              label: Text(
                _educationAllowed
                    ? l10n.ammoFactoryBuyFor(formatCurrency(_purchasePrice))
                    : l10n.educationAmmoFactoryPurchaseLockedTitle,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canBuy ? _accent : Colors.grey.shade800,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white70,
                disabledBackgroundColor: Colors.grey.shade800,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context, AppLocalizations l10n) {
    return _buildPanel(
      borderColor: _gold.withOpacity(0.28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ammoFactoryWhatYouCanDo,
            style: const TextStyle(
              color: _gold,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.ammoFactoryIntro,
            style: TextStyle(
              color: Colors.white.withOpacity(0.82),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          _buildBullet(l10n.ammoFactoryActionBuy),
          _buildBullet(l10n.ammoFactoryActionProduce),
          _buildBullet(l10n.ammoFactoryActionOutput),
          _buildBullet(l10n.ammoFactoryActionQuality),
          _buildBullet(l10n.ammoFactoryActionBlackMarket),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: _gold)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withOpacity(0.78), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  void _openBlackMarketAmmo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const BlackMarketScreen(initialTabIndex: 6),
      ),
    );
  }

  Widget _buildBlackMarketNotice(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFC107).withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.ammoFactoryBlackMarketTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(l10n.ammoFactoryBlackMarketBody),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _openBlackMarketAmmo,
            icon: const Icon(Icons.open_in_new),
            label: Text(l10n.blackMarket),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final authProvider = Provider.of<AuthProvider>(context);
    final playerMoney = authProvider.currentPlayer?.money ?? 0;
    final sessionEnd = _getSessionEnd();
    final nextProductionAt = _getNextProductionAt();
    final isSessionActive = _isSessionActive();
    final isProduceReady =
        !isSessionActive ||
        (nextProductionAt != null && !_now.isBefore(nextProductionAt));

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final ownsCurrentCountryFactory =
        _myFactory != null &&
        _myFactory?['countryId'] == _currentCountryFactory?['countryId'];
    final currentOwner = _currentCountryFactory?['owner'];
    final isAvailableToBuy = currentOwner == null && !ownsCurrentCountryFactory;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/backgrounds/ammo_factory_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.35,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _buildIntroCard(context, l10n),
          const SizedBox(height: 12),
          if (_currentCountryFactory != null) ...[
            if (isAvailableToBuy)
              _buildPurchaseCard(context, l10n, playerMoney)
            else if (!ownsCurrentCountryFactory)
              _buildPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.ammoFactoryTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.factoryOwnedBy(
                        currentOwner?['username']?.toString() ?? l10n.unknown,
                      ),
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    ),
                    const SizedBox(height: 12),
                    _buildBlackMarketNotice(context),
                  ],
                ),
              )
            else
              _buildPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.myFactory,
                      style: const TextStyle(
                        color: _gold,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.factoryCountry}: ${CountryHelper.getLocalizedCountryName(_currentCountryFactory?['countryId']?.toString(), l10n)}',
                      style: TextStyle(color: Colors.white.withOpacity(0.78)),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.28),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _panelBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.factoryOutputLevel}: ${_myFactory?['level'] ?? 1}/$maxLevel',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.factoryProductionOutput('${_getProductionOutput(_myFactory?['level'] ?? 1)}')}: ${_getProductionOutput(_myFactory?['level'] ?? 1)} ${l10n.factoryUnitsPerCycle} (±${_getProductionPerHour(_myFactory?['level'] ?? 1)} ${l10n.factoryUnitsPerHour})',
                            style: TextStyle(color: Colors.white.withOpacity(0.75)),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${l10n.factoryQualityLevel}: ${_myFactory?['qualityLevel'] ?? 1}/$maxLevel',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l10n.factoryQualityMultiplier(((_qualityMultiplier(_myFactory?['qualityLevel'] ?? 1)).toStringAsFixed(2)))}: ${(_qualityMultiplier(_myFactory?['qualityLevel'] ?? 1)).toStringAsFixed(2)}x',
                            style: TextStyle(color: Colors.white.withOpacity(0.75)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${l10n.factoryLastProduced}: ${_formatDate(_myFactory?['lastProducedAt']?.toString())}',
                      style: TextStyle(color: Colors.white.withOpacity(0.78)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isSessionActive
                          ? l10n.factorySessionActive
                          : l10n.factorySessionStopped,
                      style: TextStyle(
                        color: isSessionActive
                            ? Colors.greenAccent
                            : Colors.orangeAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isSessionActive && sessionEnd != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        l10n.factorySessionEndsIn(
                          _formatDuration(sessionEnd.difference(_now)),
                        ),
                        style: TextStyle(color: Colors.white.withOpacity(0.72)),
                      ),
                    ],
                    if (isSessionActive && nextProductionAt != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _now.isAfter(nextProductionAt)
                            ? l10n.factoryNextProductionReady
                            : l10n.factoryNextProductionIn(
                                _formatDuration(
                                  nextProductionAt.difference(_now),
                                ),
                              ),
                        style: TextStyle(color: Colors.white.withOpacity(0.72)),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          '${l10n.factoryProduceStatusLabel}:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
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
                                ? Colors.green.withOpacity(0.16)
                                : Colors.orange.withOpacity(0.16),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: isProduceReady
                                  ? Colors.greenAccent.withOpacity(0.45)
                                  : Colors.orangeAccent.withOpacity(0.45),
                            ),
                          ),
                          child: Text(
                            isProduceReady
                                ? l10n.factoryProduceStatusReady
                                : l10n.factoryProduceStatusCooldown,
                            style: TextStyle(
                              color: isProduceReady
                                  ? Colors.greenAccent
                                  : Colors.orangeAccent,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton(
                          onPressed: _isWorking ? null : _produce,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _accent,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(l10n.factoryProduce),
                        ),
                        OutlinedButton(
                          onPressed: _isWorking
                              ? null
                              : () => _showUpgradeDialog('output'),
                          child: Text(l10n.factoryUpgradeOutput),
                        ),
                        OutlinedButton(
                          onPressed: _isWorking
                              ? null
                              : () => _showUpgradeDialog('quality'),
                          child: Text(l10n.factoryUpgradeQuality),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildBlackMarketNotice(context),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
