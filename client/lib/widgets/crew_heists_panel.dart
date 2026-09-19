import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

class CrewHeistsPanel extends StatefulWidget {
  const CrewHeistsPanel({
    super.key,
    required this.crewId,
    required this.isLeader,
    required this.memberCount,
    this.onHeistResolved,
  });

  final int crewId;
  final bool isLeader;
  final int memberCount;
  final void Function(Map<String, dynamic> result)? onHeistResolved;

  @override
  State<CrewHeistsPanel> createState() => _CrewHeistsPanelState();
}

class _CrewHeistsPanelState extends State<CrewHeistsPanel> {
  final ApiClient _apiClient = ApiClient();

  bool _loading = true;
  bool _starting = false;
  String? _error;
  List<Map<String, dynamic>> _heists = [];
  Map<String, dynamic>? _crimeVehicle;
  int _heistCooldownSeconds = 0;
  Timer? _heistCooldownTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _heistCooldownTimer?.cancel();
    super.dispose();
  }

  void _setHeistCooldown(int seconds) {
    _heistCooldownTimer?.cancel();
    final remaining = seconds < 0 ? 0 : seconds;
    _heistCooldownSeconds = remaining;
    if (remaining <= 0) return;
    _heistCooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_heistCooldownSeconds <= 1) {
          _heistCooldownSeconds = 0;
          timer.cancel();
        } else {
          _heistCooldownSeconds -= 1;
        }
      });
    });
  }

  int _readCooldownSeconds(dynamic raw) {
    if (raw is num) return raw.toInt();
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }

  Future<void> _loadHeistCooldown() async {
    try {
      final response = await _apiClient.get('/player/action-cooldowns');
      if (response.statusCode != 200 || response.body.isEmpty) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = data['cooldowns'];
      if (raw is! Map) return;
      final seconds = _readCooldownSeconds(raw['heist']);
      if (!mounted) return;
      setState(() => _setHeistCooldown(seconds));
    } catch (_) {}
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final heistsResponse =
          await _apiClient.get('/heists/crew/${widget.crewId}');
      final vehicleResponse = await _apiClient.get('/garage/crime-vehicle');
      await _loadHeistCooldown();

      if (!mounted) return;

      List<Map<String, dynamic>> heists = [];
      if (heistsResponse.statusCode == 200) {
        final data = jsonDecode(heistsResponse.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>? ?? {};
        heists = (params['heists'] as List<dynamic>? ?? [])
            .map((h) => Map<String, dynamic>.from(h as Map))
            .toList();
      } else {
        _error = AppLocalizations.of(context)!.crewHeistsLoadError;
      }

      Map<String, dynamic>? vehicle;
      if (vehicleResponse.statusCode == 200) {
        final data = jsonDecode(vehicleResponse.body) as Map<String, dynamic>;
        final raw = data['vehicle'];
        if (raw is Map) {
          vehicle = Map<String, dynamic>.from(raw);
        }
      }

      setState(() {
        _heists = heists;
        _crimeVehicle = vehicle;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context)!.crewHeistsLoadError;
        _loading = false;
      });
    }
  }

  String _vehicleWearSuffix(AppLocalizations l10n, Map<String, dynamic> params) {
    final conditionLoss =
        ((params['vehicleConditionLoss'] as num?)?.round() ?? 0) +
        ((params['vehicleChaseDamage'] as num?)?.round() ?? 0);
    final fuelUsed = (params['vehicleFuelUsed'] as num?)?.round() ?? 0;
    final parts = <String>[];
    if (conditionLoss > 0) {
      parts.add(l10n.crimeResultVehicleConditionLoss(conditionLoss));
    }
    if (fuelUsed > 0) {
      parts.add(l10n.crimeResultVehicleFuelUsed(fuelUsed));
    }
    return parts.isEmpty ? '' : '\n${parts.join('\n')}';
  }

  void _applyCooldownFromParams(Map<String, dynamic> params) {
    final cooldown = params['cooldown'];
    if (cooldown is Map) {
      final remaining = _readCooldownSeconds(cooldown['remainingSeconds']);
      if (remaining > 0) {
        _setHeistCooldown(remaining);
        return;
      }
    }
    final remaining = _readCooldownSeconds(params['remainingSeconds']);
    if (remaining > 0) {
      _setHeistCooldown(remaining);
    }
  }

  Future<void> _startHeist(Map<String, dynamic> heist) async {
    if (!widget.isLeader || _starting || _heistCooldownSeconds > 0) return;

    final l10n = AppLocalizations.of(context)!;
    final requiresVehicle = heist['requiresVehicle'] != false;
    if (requiresVehicle && _crimeVehicle == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.crewHeistsNoVehicle),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _starting = true);
    try {
      final heistId = heist['id']?.toString() ?? '';
      final heistName = heist['name']?.toString() ?? '—';
      final response = await _apiClient.post('/heists/$heistId/start', {});
      if (!mounted) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final eventKey = data['event']?.toString() ?? '';
      final params = (data['params'] as Map<String, dynamic>?) ?? {};

      if (eventKey == 'error.cooldown') {
        _applyCooldownFromParams(params);
        final remaining = _heistCooldownSeconds;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              formatAdaptiveDurationFromSeconds(
                remaining,
                localeName: l10n.localeName,
              ),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final success = eventKey.contains('success');
      var message = success
          ? l10n.evStreamHeistOk(heistName, '${params['payout'] ?? 0}')
          : l10n.evStreamHeistFail(heistName);
      message += _vehicleWearSuffix(l10n, params);

      if (response.statusCode != 200) {
        final reason = params['reason']?.toString();
        if (reason == 'VEHICLE_REQUIRED') {
          message = l10n.crimeErrorVehicleRequired;
        } else if (reason == 'VEHICLE_BROKEN') {
          message = l10n.crimeErrorVehicleBroken;
        } else if (reason == 'NO_FUEL') {
          message = l10n.crimeErrorNoFuel;
        }
      }

      if (response.statusCode == 200) {
        _applyCooldownFromParams(params);
        if (_heistCooldownSeconds <= 0) {
          await _loadHeistCooldown();
        }
      }

      if (response.statusCode == 200 && widget.onHeistResolved != null) {
        widget.onHeistResolved!({
          'success': success,
          'heistName': heistName,
          'payout': (params['payout'] as num?)?.toInt() ?? 0,
          'xpGained': (params['xpGained'] as num?)?.toInt() ?? 0,
          'xpLost': (params['xpLost'] as num?)?.toInt() ?? 0,
          'jailed': params['jailed'] == true,
          'jailTime': (params['jailTime'] as num?)?.toInt() ?? 0,
          'vehicleConditionLoss':
              ((params['vehicleConditionLoss'] as num?)?.round() ?? 0) +
              ((params['vehicleChaseDamage'] as num?)?.round() ?? 0),
          'vehicleFuelUsed': (params['vehicleFuelUsed'] as num?)?.round() ?? 0,
        });
        if (success) {
          await _load();
        }
        return;
      }

      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(message),
          backgroundColor: success && response.statusCode == 200
              ? Colors.green
              : Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
      if (response.statusCode == 200) {
        await _load();
      }
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.crewHeistsLoadError),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _starting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cooldownLabel = _heistCooldownSeconds > 0
        ? formatAdaptiveDurationFromSeconds(
            _heistCooldownSeconds,
            localeName: l10n.localeName,
          )
        : l10n.crewHeistsStart;

    return Card(
      color: const Color(0xFF1E1414),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.groups_3, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  l10n.crewHeistsTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.crewHeistsSubtitle,
              style: TextStyle(color: Colors.white.withOpacity(0.75)),
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red))
            else if (_heists.isEmpty)
              Text(
                l10n.crewHeistsEmpty,
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              )
            else ...[
              if (_crimeVehicle != null)
                Text(
                  l10n.crewHeistsVehicleLine(
                    _crimeVehicle!['name']?.toString() ?? '—',
                    (_crimeVehicle!['condition'] as num?)?.round() ?? 0,
                    (_crimeVehicle!['fuel'] as num?)?.round() ?? 0,
                  ),
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                )
              else
                Text(
                  l10n.crewHeistsNoVehicle,
                  style: const TextStyle(color: Colors.orange),
                ),
              const SizedBox(height: 12),
              ..._heists.map((heist) {
                final requiredMembers =
                    (heist['requiredMembers'] as num?)?.toInt() ?? 0;
                final successRate =
                    (heist['successRate'] as num?)?.round() ?? 0;
                final requiresVehicle = heist['requiresVehicle'] != false;
                final canStart = widget.isLeader &&
                    widget.memberCount >= requiredMembers &&
                    (!_starting) &&
                    _heistCooldownSeconds <= 0 &&
                    (!requiresVehicle || _crimeVehicle != null);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heist['name']?.toString() ?? '—',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          heist['description']?.toString() ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${l10n.crewHeistsMembersRequired(widget.memberCount, requiredMembers)} · ${l10n.crewHeistsSuccessRate(successRate)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 12,
                          ),
                        ),
                        if (requiresVehicle) ...[
                          const SizedBox(height: 4),
                          Text(
                            l10n.crewHeistsRequiresVehicle,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                        ],
                        const SizedBox(height: 10),
                        if (!widget.isLeader)
                          Text(
                            l10n.crewHeistsLeaderOnly,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          )
                        else
                          ElevatedButton(
                            onPressed: canStart ? () => _startHeist(heist) : null,
                            child: Text(cooldownLabel),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
