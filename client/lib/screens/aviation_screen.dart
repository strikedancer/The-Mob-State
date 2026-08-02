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
  const AviationScreen({super.key});

  @override
  State<AviationScreen> createState() => _AviationScreenState();
}

class _AviationScreenState extends State<AviationScreen> {
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = true;
  bool _isBuying = false;
  String? _error;
  bool _hasLicense = false;
  String? _licenseType;
  List<Map<String, dynamic>> _licenseOffers = const [];

  List<Map<String, dynamic>> _aircraft = const [];
  List<Map<String, dynamic>> _owned = const [];

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
        title: Text(l10n.aviationUiLicenseBuyConfirmTitle),
        content: Text(
          l10n.aviationUiLicenseBuyConfirmBody(
            label,
            formatCurrency(price),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
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
        title: Text(l10n.aviationUiBuyConfirmTitle),
        content: Text(
          l10n.aviationUiBuyConfirmBody(
            aircraftName,
            formatCurrency(price),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.aviationUiLoadError(_error!),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.aviation,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _hasLicense
                      ? l10n.aviationUiLicenseActiveBlurb(
                          _licenseType ?? 'basic',
                        )
                      : l10n.aviationUiLicenseMissingBlurb,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.aviationUiLicensesTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ..._licenseOffers.map((offer) {
          final type = offer['licenseType']?.toString() ?? '';
          final price = (offer['price'] as num?)?.toInt() ?? 0;
          final minRank = (offer['minRank'] as num?)?.toInt() ?? 0;
          final canBuy = _canBuyOrUpgradeLicense(type);
          final ownedThis = _hasLicense && _licenseType == type;
          return Card(
            child: ListTile(
              title: Text(_licenseLabel(type, l10n)),
              subtitle: Text(
                '${l10n.aviationUiPriceLabel(formatCurrency(price))} · ${l10n.aviationUiLicenseMinRank(minRank)}',
              ),
              trailing: ownedThis
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : ElevatedButton(
                      onPressed: (!canBuy || _isBuying)
                          ? null
                          : () => _buyLicense(offer),
                      child: Text(
                        _hasLicense
                            ? l10n.aviationUiUpgradeLicense
                            : l10n.aviationUiBuyLicense,
                      ),
                    ),
            ),
          );
        }),
        const SizedBox(height: 12),
        Text(
          l10n.aviationUiYourAircraft,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (_owned.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(l10n.aviationUiNoOwnedAircraft),
            ),
          )
        else
          ..._owned.map((item) {
            final name = _ownedDisplayName(item, l10n);
            final fuel = (item['fuel'] as num?)?.toInt() ?? 0;
            final maxFuel = (item['maxFuel'] as num?)?.toInt() ?? 0;
            final type = item['aircraftType']?.toString() ?? '';

            return Card(
              child: ListTile(
                leading: SizedBox(
                  width: 52,
                  height: 52,
                  child: WebAssetHelper.image(
                    _imageForAircraftType(type),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.flight, size: 28),
                  ),
                ),
                title: Text(name),
                subtitle: Text(l10n.aviationUiFuelLabel(fuel, maxFuel)),
              ),
            );
          }),
        const SizedBox(height: 12),
        Text(
          l10n.aviationUiAvailableAircraft,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ..._aircraft.map((item) {
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

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                              const Icon(Icons.flight, size: 36),
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(description),
                            const SizedBox(height: 6),
                            Text(
                              l10n.aviationUiPriceLabel(formatCurrency(price)),
                            ),
                            Text(l10n.aviationUiMinRank(minRank)),
                            Text(
                              l10n.aviationUiSpeedMultiplier(
                                speedMultiplier.toStringAsFixed(1),
                              ),
                            ),
                            Text(l10n.aviationUiCargoCapacity(cargoCapacity)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: _isBuying ? null : () => _buyAircraft(item),
                      icon: const Icon(Icons.shopping_cart),
                      label: Text(l10n.buy),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
