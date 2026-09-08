import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../widgets/action_result_toast.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  final ApiClient _api = ApiClient();
  final _stakeController = TextEditingController();
  final _betController = TextEditingController();

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _overview;
  bool _busy = false;
  bool _fixing = false;
  int? _selectedCarId;
  int? _selectedEntryId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _stakeController.dispose();
    _betController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final response = await _api.get('/races/overview');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        setState(() {
          _loading = false;
          _error = _errorFromPayload(data);
        });
        return;
      }
      setState(() {
        _overview = data;
        _loading = false;
        _selectedCarId ??= ((data['eligibleCars'] as List?) ?? [])
            .cast<dynamic>()
            .map((row) => (row as Map)['inventoryId'] as int?)
            .firstWhere((id) => id != null, orElse: () => null);
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = AppLocalizations.of(context)?.raceErrorGeneric ?? '';
      });
    }
  }

  String _errorFromPayload(Map<String, dynamic> data) {
    final l10n = AppLocalizations.of(context)!;
    final params = (data['params'] as Map?)?.cast<String, dynamic>() ?? {};
    final reason = (params['reason'] ?? '').toString();
    switch (reason) {
      case 'DISABLED':
        return l10n.raceErrorDisabled;
      case 'JAILED':
        return l10n.raceErrorJailed;
      case 'TRAVELING':
        return l10n.raceErrorTraveling;
      case 'FUNDS':
        return l10n.raceErrorFunds;
      case 'COOLDOWN':
        return l10n.raceErrorCooldown;
      case 'CLOSED':
        return l10n.raceErrorClosed;
      case 'ALREADY_ENTERED':
        return l10n.raceErrorEntered;
      case 'FULL':
        return l10n.raceErrorFull;
      case 'VEHICLE_INVALID':
        return l10n.raceErrorVehicle;
      case 'CONDITION':
        return l10n.raceErrorCondition;
      case 'BET_OWN':
        return l10n.raceErrorBetOwn;
      case 'BET_CAP':
        return l10n.raceErrorBetCap;
      case 'RANK_TOO_LOW':
        return l10n.raceErrorRank((params['requiredRank'] as num?)?.toInt() ?? 3);
      default:
        return l10n.raceErrorGeneric;
    }
  }

  Future<void> _post(String path, Map<String, dynamic> body) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final response = await _api.post(path, body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        if (!mounted) return;
        showActionResultToast(context, title: _errorFromPayload(data), success: false);
        return;
      }
      if (!mounted) return;
      setState(() => _overview = data);
      showActionResultToast(context, title: AppLocalizations.of(context)!.raceActionOk);
    } catch (_) {
      if (!mounted) return;
      showActionResultToast(
        context,
        title: AppLocalizations.of(context)!.raceErrorGeneric,
        success: false,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _load, child: Text(l10n.retry)),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(onRefresh: _load, child: _buildBody(l10n));

    if (widget.embedded) return body;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.raceMenuLabel)),
      body: body,
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final meeting = (_overview?['meeting'] as Map?)?.cast<String, dynamic>();
    final config = (_overview?['config'] as Map?)?.cast<String, dynamic>() ?? {};
    final cars = ((_overview?['eligibleCars'] as List?) ?? [])
        .whereType<Map>()
        .map((row) => row.cast<String, dynamic>())
        .toList();
    final last = (_overview?['lastResult'] as Map?)?.cast<String, dynamic>();
    final cooldownUntil = _overview?['cooldownUntil']?.toString();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.raceIntro, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        if (meeting == null) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                cooldownUntil != null ? l10n.raceCooldown : l10n.raceNoMeeting,
              ),
            ),
          ),
        ] else ...[
          _meetingCard(l10n, meeting, config, cars),
          const SizedBox(height: 12),
          _entriesCard(l10n, meeting, config),
        ],
        if (last != null) ...[
          const SizedBox(height: 12),
          _lastResultCard(l10n, last),
        ],
      ],
    );
  }

  Widget _meetingCard(
    AppLocalizations l10n,
    Map<String, dynamic> meeting,
    Map<String, dynamic> config,
    List<Map<String, dynamic>> cars,
  ) {
    final myEntry = (meeting['myEntry'] as Map?)?.cast<String, dynamic>();
    final endsIn = (meeting['endsInSeconds'] as num?)?.toInt() ?? 0;
    final rakeBps = (meeting['rakeBps'] as num?)?.toInt() ?? 800;
    final carIds = cars.map((car) => car['inventoryId'] as int).toSet();
    final selectedCarId = carIds.contains(_selectedCarId) ? _selectedCarId : null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.raceLiveTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(l10n.raceEndsIn(_formatSeconds(endsIn))),
            Text(l10n.raceRake((rakeBps / 100).round())),
            const SizedBox(height: 12),
            if (myEntry != null)
              Text(l10n.raceYouEntered)
            else if (cars.isEmpty)
              Text(l10n.raceNeedCar)
            else ...[
              DropdownButtonFormField<int>(
                value: selectedCarId,
                decoration: InputDecoration(labelText: l10n.racePickCar),
                items: cars
                    .map(
                      (car) => DropdownMenuItem<int>(
                        value: car['inventoryId'] as int,
                        child: Text(
                          '${car['name']} · ${l10n.raceSpeedLabel}: ${car['speed']} · ${car['condition']}%',
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _selectedCarId = value),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _stakeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.raceStake,
                  hintText: '${config['minStake']}-${config['maxStake']}',
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.raceFixing),
                subtitle: Text(l10n.raceFixingHint),
                value: _fixing,
                onChanged: (value) => setState(() => _fixing = value),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _busy || selectedCarId == null
                      ? null
                      : () => _post('/races/enter', {
                            'vehicleInventoryId': selectedCarId,
                            'stake': int.tryParse(_stakeController.text.trim()) ?? 0,
                            'fixing': _fixing,
                          }),
                  child: Text(l10n.raceEnter),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _entriesCard(
    AppLocalizations l10n,
    Map<String, dynamic> meeting,
    Map<String, dynamic> config,
  ) {
    final entries = ((meeting['entries'] as List?) ?? [])
        .whereType<Map>()
        .map((row) => row.cast<String, dynamic>())
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.raceField, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (entries.isEmpty) Text(l10n.raceNoEntries),
            ...entries.map((entry) {
              final selected = _selectedEntryId == entry['id'];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                selected: selected,
                title: Text('${entry['username']}'),
                subtitle: Text(
                  '${entry['vehicleId']} · ${formatCurrency((entry['stake'] as num?)?.toInt() ?? 0)}'
                  '${entry['fixing'] == true ? ' · ${l10n.raceFixing}' : ''}',
                ),
                onTap: () => setState(() => _selectedEntryId = entry['id'] as int),
              );
            }),
            if (entries.isNotEmpty) ...[
              TextField(
                controller: _betController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.raceBetAmount,
                  hintText: '${config['minBet']}-${config['maxBet']}',
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _busy || _selectedEntryId == null
                      ? null
                      : () => _post('/races/bet', {
                            'entryId': _selectedEntryId,
                            'amount': int.tryParse(_betController.text.trim()) ?? 0,
                          }),
                  child: Text(l10n.racePlaceBet),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _lastResultCard(AppLocalizations l10n, Map<String, dynamic> last) {
    final entries = ((last['entries'] as List?) ?? [])
        .whereType<Map>()
        .map((row) => row.cast<String, dynamic>())
        .toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.raceLastResult, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...entries.map(
              (entry) => Text(
                '#${entry['finishPlace'] ?? '-'} ${entry['username']} · ${formatCurrency((entry['payout'] as num?)?.toInt() ?? 0)}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
