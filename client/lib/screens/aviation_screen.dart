import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  List<Map<String, dynamic>> _aircraft = const [];
  List<Map<String, dynamic>> _owned = const [];

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

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
      ]);

      final aircraftData =
          jsonDecode(responses[0].body) as Map<String, dynamic>;
      final ownedData = jsonDecode(responses[1].body) as Map<String, dynamic>;
      final licenseData = jsonDecode(responses[2].body) as Map<String, dynamic>;

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

  Future<void> _buyAircraft(Map<String, dynamic> item) async {
    if (_isBuying) return;

    final aircraftType = item['id']?.toString() ?? '';
    final aircraftName = item['name']?.toString() ?? aircraftType;
    final price = (item['price'] as num?)?.toInt() ?? 0;
    if (aircraftType.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr('Vliegtuig kopen?', 'Buy aircraft?')),
        content: Text(
          _tr(
            'Wil je $aircraftName kopen voor ${formatCurrency(price)}?',
            'Do you want to buy $aircraftName for ${formatCurrency(price)}?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr('Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_tr('Kopen', 'Buy')),
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
            data['message']?.toString() ??
            _tr('Aankoop mislukt.', 'Purchase failed.');
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
                  _tr('Vliegtuig gekocht.', 'Aircraft purchased.'),
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
          content: Text('${_tr('Fout', 'Error')}: $e'),
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
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadData,
                child: Text(_tr('Opnieuw proberen', 'Retry')),
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
                  _tr('Luchtvaart', 'Aviation'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _hasLicense
                      ? _tr(
                          'Licentie actief. Vliegtuigkoop vereist nu volledige pilot-opleiding (Aviation level 5 + alle certificaten).',
                          'License active. Aircraft purchase now requires full pilot training (Aviation level 5 + all certifications).',
                        )
                      : _tr(
                          'Je hebt nog geen vlieglicentie. Koop eerst een licentie via deze module voordat je vliegtuigen kunt kopen.',
                          'You do not have an aviation license yet. Buy a license in this module before purchasing aircraft.',
                        ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _tr('Jouw vliegtuigen', 'Your aircraft'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        if (_owned.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                _tr(
                  'Je bezit nog geen vliegtuigen.',
                  'You do not own any aircraft yet.',
                ),
              ),
            ),
          )
        else
          ..._owned.map((item) {
            final name =
                (_isNl ? item['name'] : (item['name_en'] ?? item['name']))
                    ?.toString() ??
                item['aircraftType']?.toString() ??
                'Aircraft';
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
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.flight, size: 28),
                  ),
                ),
                title: Text(name),
                subtitle: Text(
                  _tr('Brandstof: $fuel / $maxFuel', 'Fuel: $fuel / $maxFuel'),
                ),
              ),
            );
          }),
        const SizedBox(height: 12),
        Text(
          _tr('Beschikbare vliegtuigen', 'Available aircraft'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ..._aircraft.map((item) {
          final aircraftType = item['id']?.toString() ?? '';
          final name =
              (_isNl ? item['name'] : (item['name_en'] ?? item['name']))
                  ?.toString() ??
              aircraftType;
          final description =
              (_isNl
                      ? item['description']
                      : (item['description_en'] ?? item['description']))
                  ?.toString() ??
              '';
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
                          errorBuilder: (_, __, ___) =>
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
                              _tr(
                                'Prijs: ${formatCurrency(price)}',
                                'Price: ${formatCurrency(price)}',
                              ),
                            ),
                            Text(
                              _tr('Min rank: $minRank', 'Min rank: $minRank'),
                            ),
                            Text(
                              _tr(
                                'Snelheid x${speedMultiplier.toStringAsFixed(1)}',
                                'Speed x${speedMultiplier.toStringAsFixed(1)}',
                              ),
                            ),
                            Text(
                              _tr(
                                'Cargo: $cargoCapacity',
                                'Cargo: $cargoCapacity',
                              ),
                            ),
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
                      label: Text(_tr('Kopen', 'Buy')),
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
