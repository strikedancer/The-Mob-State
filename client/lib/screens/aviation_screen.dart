import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

class AviationScreen extends StatefulWidget {
  const AviationScreen({
    super.key,
    this.embedded = false,
  });

  /// When true (web dashboard), hide the page AppBar; the sidebar already names the page.
  final bool embedded;

  @override
  State<AviationScreen> createState() => _AviationScreenState();
}

class _AviationScreenState extends State<AviationScreen> {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);

  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  bool _isBuying = false;
  String? _error;
  bool _hasLicense = false;
  String? _licenseType;
  List<Map<String, dynamic>> _licenseOffers = const [];

  List<Map<String, dynamic>> _aircraft = const [];
  List<Map<String, dynamic>> _owned = const [];
  int _aviationLevel = 0;
  bool _hasFlightBasic = false;
  bool _hasFlightCommercial = false;

  static const _licenseTier = <String, int>{
    'basic': 1,
    'commercial': 2,
    'cargo': 3,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final responses = await Future.wait([
        _apiClient.get('/aviation/aircraft'),
        _apiClient.get('/aviation/my-aircraft'),
        _apiClient.get('/aviation/my-license'),
        _apiClient.get('/aviation/licenses'),
      ]);

      final aircraftData =
          jsonDecode(responses[0].body) as Map<String, dynamic>;
      final ownedData = jsonDecode(responses[1].body) as Map<String, dynamic>;
      final licenseData = jsonDecode(responses[2].body) as Map<String, dynamic>;
      final offersData = jsonDecode(responses[3].body) as Map<String, dynamic>;

      var aviationLevel = 0;
      var hasFlightBasic = false;
      var hasFlightCommercial = false;
      try {
        final eduResponse = await _apiClient.get('/education/profile');
        if (eduResponse.statusCode == 200) {
          final eduData = jsonDecode(eduResponse.body) as Map<String, dynamic>;
          final profile =
              (eduData['profile'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{};
          final tracks =
              (profile['tracks'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{};
          final aviation =
              (tracks['aviation'] as Map?)?.cast<String, dynamic>() ??
              const <String, dynamic>{};
          aviationLevel = (aviation['level'] as num?)?.toInt() ?? 0;
          final certs = ((profile['certifications'] as List?) ?? const [])
              .map((entry) => entry.toString())
              .toSet();
          hasFlightBasic = certs.contains('flight_basic');
          hasFlightCommercial = certs.contains('flight_commercial');
        }
      } catch (_) {
        // Hangar still works without school progress chips.
      }

      final license = licenseData['license'];
      setState(() {
        _aircraft = ((aircraftData['aircraft'] as List?) ?? const [])
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList(growable: false);
        _owned = ((ownedData['aircraft'] as List?) ?? const [])
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList(growable: false);
        _hasLicense = (licenseData['hasLicense'] as bool?) ?? false;
        _licenseType = license is Map
            ? license['licenseType']?.toString()
            : null;
        _licenseOffers = ((offersData['licenses'] as List?) ?? const [])
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList(growable: false);
        _aviationLevel = aviationLevel;
        _hasFlightBasic = hasFlightBasic;
        _hasFlightCommercial = hasFlightCommercial;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  static const _aircraftImages = <String, String>{
    'cessna_172': 'aircraft/cessna.png',
    'king_air_350': 'aircraft/king_air.png',
    'citation_x': 'aircraft/citation_x.png',
    'gulfstream_g650': 'aircraft/gulfstream.png',
    'boeing_737_cargo': 'aircraft/cargo_737.png',
    'antonov_an_225': 'aircraft/antonov.png',
  };

  String _imageForAircraftType(String aircraftType) {
    return _aircraftImages[aircraftType.toLowerCase()] ?? 'aircraft/cessna.png';
  }

  bool _useDutchNames(AppLocalizations l10n) =>
      l10n.localeName.toLowerCase().startsWith('nl');

  String _catalogName(Map<String, dynamic> item, AppLocalizations l10n) {
    final useNl = _useDutchNames(l10n);
    return (useNl ? item['name'] : (item['name_en'] ?? item['name']))
            ?.toString() ??
        item['id']?.toString() ??
        '';
  }

  String _catalogDescription(Map<String, dynamic> item, AppLocalizations l10n) {
    final useNl = _useDutchNames(l10n);
    return (useNl
            ? item['description']
            : (item['description_en'] ?? item['description']))
        ?.toString() ??
        '';
  }

  String _ownedDisplayName(Map<String, dynamic> item, AppLocalizations l10n) {
    final useNl = _useDutchNames(l10n);
    return (useNl ? item['name'] : (item['name_en'] ?? item['name']))
            ?.toString() ??
        item['aircraftType']?.toString() ??
        l10n.aviationUiDefaultAircraftName;
  }

  String _licenseLabel(String type, AppLocalizations l10n) {
    switch (type) {
      case 'commercial':
        return l10n.aviationUiLicenseCommercial;
      case 'cargo':
        return l10n.aviationUiLicenseCargo;
      case 'basic':
      default:
        return l10n.aviationUiLicenseBasic;
    }
  }

  bool _canBuyOrUpgradeLicense(String type) {
    final next = _licenseTier[type] ?? 0;
    if (!_hasLicense) return next > 0;
    final current = _licenseTier[_licenseType ?? ''] ?? 0;
    return next > current;
  }

  Future<void> _buyLicense(Map<String, dynamic> offer) async {
    if (_isBuying) return;
    final l10n = AppLocalizations.of(context)!;
    final licenseType = offer['licenseType']?.toString() ?? '';
    final price = (offer['price'] as num?)?.toInt() ?? 0;
    if (licenseType.isEmpty || !_canBuyOrUpgradeLicense(licenseType)) return;

    final label = _licenseLabel(licenseType, l10n);
    final isUpgrade = _hasLicense;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _panelBg,
        title: Text(
          l10n.aviationUiLicenseBuyConfirmTitle,
          style: const TextStyle(color: _gold, fontWeight: FontWeight.w800),
        ),
        content: Text(
          l10n.aviationUiLicenseBuyConfirmBody(
            label,
            formatCurrency(price),
          ),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
            ),
            child: Text(
              isUpgrade ? l10n.aviationUiUpgradeLicense : l10n.aviationUiBuyLicense,
            ),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _isBuying = true);
    try {
      final response = await _apiClient.post('/aviation/buy-license', {
        'licenseType': licenseType,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400 || data['success'] == false) {
        final message =
            data['message']?.toString() ?? l10n.aviationUiLicensePurchaseFailed;
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(backgroundColor: Colors.red, content: Text(message)),
        );
        return;
      }

      final remainingMoney = (data['remainingMoney'] as num?)?.toInt();
      if (remainingMoney != null && mounted) {
        Provider.of<AuthProvider>(
          context,
          listen: false,
        ).updatePlayerStats(money: remainingMoney);
      }

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              data['message']?.toString() ??
                  l10n.aviationUiLicensePurchasedSuccess,
            ),
          ),
        );
      }
      await _loadData();
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(l10n.error(e.toString())),
        ),
      );
    } finally {
      if (mounted) setState(() => _isBuying = false);
    }
  }

  Future<void> _buyAircraft(Map<String, dynamic> item) async {
    if (_isBuying) return;

    final l10n = AppLocalizations.of(context)!;
    final aircraftType = item['id']?.toString() ?? '';
    final aircraftName = _catalogName(item, l10n).isNotEmpty
        ? _catalogName(item, l10n)
        : aircraftType;
    final price = (item['price'] as num?)?.toInt() ?? 0;
    if (aircraftType.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _panelBg,
        title: Text(
          l10n.aviationUiBuyConfirmTitle,
          style: const TextStyle(color: _gold, fontWeight: FontWeight.w800),
        ),
        content: Text(
          l10n.aviationUiBuyConfirmBody(
            aircraftName,
            formatCurrency(price),
          ),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.white70),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isBuying = true);
    try {
      final response = await _apiClient.post('/aviation/buy-aircraft', {
        'aircraftType': aircraftType,
      });
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400 || (data['success'] == false)) {
        final message =
            data['message']?.toString() ?? l10n.aviationUiPurchaseFailed;
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(backgroundColor: Colors.red, content: Text(message)),
        );
        return;
      }

      final remainingMoney = (data['remainingMoney'] as num?)?.toInt();
      if (remainingMoney != null && mounted) {
        Provider.of<AuthProvider>(
          context,
          listen: false,
        ).updatePlayerStats(money: remainingMoney);
      }

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              data['message']?.toString() ?? l10n.aviationUiPurchasedSuccess,
            ),
          ),
        );
      }

      await _loadData();
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(l10n.error(e.toString())),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isBuying = false);
      }
    }
  }

  String _requiredLicenseForAircraft(String aircraftTypeField) {
    switch (aircraftTypeField) {
      case 'business_jet':
      case 'luxury_jet':
        return 'commercial';
      case 'cargo_jet':
      case 'super_heavy_cargo':
        return 'cargo';
      default:
        return 'basic';
    }
  }

  bool _licenseCovers(String requiredType) {
    if (!_hasLicense) return false;
    final current = _licenseTier[_licenseType ?? ''] ?? 0;
    final needed = _licenseTier[requiredType] ?? 1;
    return current >= needed;
  }

  Widget _buildPanel({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required VoidCallback? onPressed,
    bool owned = false,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 88, maxWidth: 140),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: owned ? const Color(0xFF2E5A3C) : _gold,
          foregroundColor: owned ? Colors.white : Colors.black,
          disabledBackgroundColor: const Color(0xFF3A4252),
          disabledForegroundColor: Colors.white38,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: FittedBox(fit: BoxFit.scaleDown, child: Text(label)),
      ),
    );
  }

  Widget _buildHero(AppLocalizations l10n) {
    final schoolReady = _aviationLevel >= 5;
    final certCount =
        (_hasFlightBasic ? 1 : 0) + (_hasFlightCommercial ? 1 : 0);
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
                child: const Icon(Icons.flight, color: _gold, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.aviationHeroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.aviationHeroSubtitle,
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
          const SizedBox(height: 10),
          Text(
            _hasLicense
                ? l10n.aviationUiLicenseActiveBlurb(
                    _licenseLabel(_licenseType ?? 'basic', l10n),
                  )
                : l10n.aviationUiLicenseMissingBlurb,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip(
                l10n.aviationSchoolChip('$_aviationLevel'),
                schoolReady ? const Color(0xFF72C48F) : const Color(0xFFE6B85C),
              ),
              _statChip(
                l10n.aviationCertsChip('$certCount'),
                certCount >= 2
                    ? const Color(0xFF72C48F)
                    : const Color(0xFFE6B85C),
              ),
              _statChip(
                _hasLicense
                    ? _licenseLabel(_licenseType ?? 'basic', l10n)
                    : l10n.aviationNoLicenseChip,
                _hasLicense ? const Color(0xFF72C48F) : const Color(0xFFE5967A),
              ),
              _statChip(
                l10n.aviationOwnedCountChip('${_owned.length}'),
                _gold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLicenseCard(Map<String, dynamic> offer, AppLocalizations l10n) {
    final type = offer['licenseType']?.toString() ?? '';
    final price = (offer['price'] as num?)?.toInt() ?? 0;
    final minRank = (offer['minRank'] as num?)?.toInt() ?? 0;
    final canBuy = _canBuyOrUpgradeLicense(type);
    final ownedThis = _hasLicense && _licenseType == type;
    return _buildPanel(
      child: Row(
        children: [
          Icon(
            ownedThis ? Icons.verified : Icons.badge_outlined,
            color: ownedThis ? const Color(0xFF72C48F) : _gold,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _licenseLabel(type, l10n),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _statChip(
                      l10n.aviationUiPriceLabel(formatCurrency(price)),
                      _gold,
                    ),
                    _statChip(
                      l10n.aviationUiLicenseMinRank(minRank),
                      Colors.white70,
                    ),
                    if (ownedThis)
                      _statChip(
                        l10n.aviationOwnedBadge,
                        const Color(0xFF72C48F),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _actionButton(
            label: ownedThis
                ? l10n.aviationOwnedBadge
                : (_hasLicense
                      ? l10n.aviationUiUpgradeLicense
                      : l10n.aviationUiBuyLicense),
            owned: ownedThis,
            onPressed: (!canBuy || _isBuying || ownedThis)
                ? null
                : () => _buyLicense(offer),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnedCard(Map<String, dynamic> item, AppLocalizations l10n) {
    final name = _ownedDisplayName(item, l10n);
    final fuel = (item['fuel'] as num?)?.toInt() ?? 0;
    final maxFuel = (item['maxFuel'] as num?)?.toInt() ?? 0;
    final type = item['aircraftType']?.toString() ?? '';
    return _buildPanel(
      child: Row(
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: WebAssetHelper.image(
              _imageForAircraftType(type),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.flight, size: 32, color: _gold),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                _statChip(
                  l10n.aviationUiFuelLabel(fuel, maxFuel),
                  fuel <= 0
                      ? const Color(0xFFE5967A)
                      : const Color(0xFF72C48F),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogCard(
    Map<String, dynamic> item,
    AppLocalizations l10n,
    int playerRank,
    int money,
  ) {
    final aircraftType = item['id']?.toString() ?? '';
    final name = _catalogName(item, l10n).isNotEmpty
        ? _catalogName(item, l10n)
        : aircraftType;
    final description = _catalogDescription(item, l10n);
    final price = (item['price'] as num?)?.toInt() ?? 0;
    final minRank = (item['minRank'] as num?)?.toInt() ?? 0;
    final speedMultiplier =
        (item['speedMultiplier'] as num?)?.toDouble() ?? 1.0;
    final cargoCapacity = (item['cargoCapacity'] as num?)?.toInt() ?? 0;
    final requiredLicense = _requiredLicenseForAircraft(
      item['type']?.toString() ?? '',
    );
    final rankOk = playerRank >= minRank;
    final moneyOk = money >= price;
    final licenseOk = _licenseCovers(requiredLicense);
    final canBuy = rankOk && moneyOk && licenseOk && !_isBuying;

    String buttonLabel = l10n.buy;
    if (!licenseOk) {
      buttonLabel = l10n.aviationRequiresLicense(
        _licenseLabel(requiredLicense, l10n),
      );
    } else if (!rankOk) {
      buttonLabel = l10n.aviationRankLocked;
    } else if (!moneyOk) {
      buttonLabel = l10n.travelCannotAfford;
    }

    return _buildPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 82,
                height: 82,
                child: WebAssetHelper.image(
                  _imageForAircraftType(aircraftType),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flight, size: 36, color: _gold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _statChip(
                l10n.aviationUiPriceLabel(formatCurrency(price)),
                moneyOk ? _gold : const Color(0xFFE5967A),
              ),
              _statChip(
                l10n.aviationUiMinRank(minRank),
                rankOk ? Colors.white70 : const Color(0xFFE5967A),
              ),
              _statChip(
                l10n.aviationUiSpeedMultiplier(
                  speedMultiplier.toStringAsFixed(1),
                ),
                Colors.white70,
              ),
              _statChip(
                l10n.aviationUiCargoCapacity(cargoCapacity),
                Colors.white70,
              ),
              _statChip(
                l10n.aviationRequiresLicense(
                  _licenseLabel(requiredLicense, l10n),
                ),
                licenseOk ? const Color(0xFF72C48F) : const Color(0xFFE6B85C),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _actionButton(
              label: buttonLabel,
              onPressed: canBuy ? () => _buyAircraft(item) : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final player = Provider.of<AuthProvider>(context).currentPlayer;
    final playerRank = player?.rank ?? 0;
    final money = player?.money ?? 0;

    late final Widget body;
    if (_isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.aviationUiLoadError(_error!),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _gold,
                  foregroundColor: Colors.black,
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    } else {
      body = RefreshIndicator(
        color: _gold,
        onRefresh: _loadData,
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
                    _buildHero(l10n),
                    _sectionTitle(l10n.aviationUiLicensesTitle),
                    ..._licenseOffers.map(
                      (offer) => _buildLicenseCard(offer, l10n),
                    ),
                    _sectionTitle(l10n.aviationUiYourAircraft),
                    if (_owned.isEmpty)
                      _buildPanel(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.aviationUiNoOwnedAircraft,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.aviationHangarEmptyHint,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ..._owned.map((item) => _buildOwnedCard(item, l10n)),
                    _sectionTitle(l10n.aviationUiAvailableAircraft),
                    ..._aircraft.map(
                      (item) => _buildCatalogCard(
                        item,
                        l10n,
                        playerRank,
                        money,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text(l10n.aviation),
              backgroundColor: const Color(0xFF2E2A24),
              foregroundColor: Colors.white,
            ),
      backgroundColor: widget.embedded ? Colors.transparent : null,
      body: body,
    );
  }
}
