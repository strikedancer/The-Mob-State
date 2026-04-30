import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({super.key});

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  Map<String, dynamic>? _hospitalInfo;
  bool _isInICU = false;
  int _icuRemainingSeconds = 0;
  bool _isOnCooldown = false;
  int _cooldownRemainingSeconds = 0;
  Timer? _cooldownTimer;

  @override
  void initState() {
    super.initState();
    _loadHospitalInfo();
    _loadIcuStatus();
    _loadCooldownStatus();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCooldownStatus() async {
    try {
      final response = await _apiClient.get('/hospital/cooldown');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final params = data['params'] as Map<String, dynamic>?;
        if (params != null && mounted) {
          final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
          setState(() {
            _isOnCooldown = params['onCooldown'] == true;
            _cooldownRemainingSeconds = remaining;
          });
          if (_isOnCooldown && remaining > 0) {
            _startCooldownCountdown();
          }
        }
      }
    } catch (_) {}
  }

  void _startCooldownCountdown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_cooldownRemainingSeconds > 1) {
          _cooldownRemainingSeconds--;
        } else {
          _cooldownRemainingSeconds = 0;
          _isOnCooldown = false;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _loadIcuStatus() async {
    try {
      final response = await _apiClient.get('/icu/status');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final icuData = data['data'] as Map<String, dynamic>?;
        if (icuData != null && mounted) {
          setState(() {
            _isInICU = icuData['inICU'] == true;
            _icuRemainingSeconds =
                (icuData['remainingSeconds'] as num?)?.toInt() ?? 0;
          });
        }
      }
    } catch (_) {
      // Silent fail: ICU status is secondary info
    }
  }

  Future<void> _refreshMedicalStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.refreshPlayer();
    await _loadHospitalInfo();
    await _loadIcuStatus();
  }

  String _formatTime(int seconds) {
    final l10n = AppLocalizations.of(context)!;
    return formatAdaptiveDurationFromSeconds(
      seconds,
      localeName: l10n.localeName,
    );
  }

  List<Widget> _buildCooldownBanner() {
    final l10n = AppLocalizations.of(context)!;
    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A1A0A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange.shade700),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer, color: Colors.orange, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.hospitalCooldownTitle,
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.hospitalCooldownNextAvailable(
                      _formatTime(_cooldownRemainingSeconds),
                    ),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
    ];
  }

  Future<void> _loadHospitalInfo() async {
    try {
      final response = await _apiClient.get('/hospital/info');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _hospitalInfo = data['params'];
        });
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.error(e.toString()))));
      }
    }
  }

  Future<void> _heal({String treatmentType = 'standard'}) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.post('/hospital/heal', {
        'treatmentType': treatmentType,
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['event'] == 'hospital.healed' && mounted) {
          await _refreshMedicalStatus();
          await _loadCooldownStatus();

          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                '✅ ${l10n.treated} ${l10n.healthRestored(data['params']['healthRestored'].toString(), data['params']['cost'].toString())}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          String errorMessage = l10n.errorTreatment;
          if (data['params']?['reason'] == 'ALREADY_FULL_HEALTH') {
            errorMessage = l10n.alreadyFullHealth;
          } else if (data['params']?['reason'] == 'INSUFFICIENT_FUNDS') {
            errorMessage = l10n.notEnoughMoney;
          } else if (data['params']?['reason'] == 'PLAYER_DEAD') {
            errorMessage = l10n.youAreDead;
          } else if (data['params']?['reason'] == 'ON_COOLDOWN') {
            final minutes = data['params']?['remainingMinutes'] ?? 60;
            errorMessage = l10n.waitMinutes(minutes.toString());
          }

          showTopRightFromSnackBar(
            context,
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _emergencyRoom() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiClient.post('/hospital/emergency', {});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['event'] == 'hospital.emergency' && mounted) {
          await _refreshMedicalStatus();

          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                '🊘 ${l10n.emergencyTreatment(data['params']['healthRestored'].toString())}',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (mounted && data['params']?['reason'] == 'NOT_CRITICAL') {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.emergencyOnly),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const goldColor = Color(0xFFD4AF37);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.local_hospital, color: goldColor),
            const SizedBox(width: 8),
            Text(l10n.hospital),
          ],
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: goldColor),
        ),
      ),
      body: _hospitalInfo == null
          ? const Center(child: CircularProgressIndicator())
          : Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                final player = authProvider.currentPlayer;

                if (player == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final healthPercent = player.health / 100;
                final treatmentOptions =
                    (_hospitalInfo!['treatmentOptions']
                        as Map<String, dynamic>?) ??
                    {
                      'standard': {
                        'cost': _hospitalInfo!['cost'],
                        'healAmount': _hospitalInfo!['healAmount'],
                      },
                      'intensive': {
                        'cost': (_hospitalInfo!['cost'] as num).toInt() * 2,
                        'healAmount':
                            ((_hospitalInfo!['healAmount'] as num).toInt() *
                                    2.5)
                                .round(),
                      },
                    };
                final standardOption =
                    (treatmentOptions['standard'] as Map<String, dynamic>?) ??
                    {
                      'cost': _hospitalInfo!['cost'],
                      'healAmount': _hospitalInfo!['healAmount'],
                    };
                final intensiveOption =
                    (treatmentOptions['intensive'] as Map<String, dynamic>?) ??
                    {
                      'cost': (_hospitalInfo!['cost'] as num).toInt() * 2,
                      'healAmount':
                          ((_hospitalInfo!['healAmount'] as num).toInt() * 2.5)
                              .round(),
                    };
                final standardCost = (standardOption['cost'] as num).toInt();
                final standardHealAmount = (standardOption['healAmount'] as num)
                    .toInt();
                final intensiveCost = (intensiveOption['cost'] as num).toInt();
                final intensiveHealAmount =
                    (intensiveOption['healAmount'] as num).toInt();
                final canAffordStandard = player.money >= standardCost;
                final canAffordIntensive = player.money >= intensiveCost;
                final needsHealing = player.health < 100;
                final isCritical = player.health < 30;
                final isSmallScreen = MediaQuery.of(context).size.width < 600;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Professional hospital header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A1A1A), Color(0xFF2A2A2A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.monitor_heart,
                                      color: Color(0xFFD4AF37),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.hospitalMedicalStatusTitle,
                                      style: TextStyle(
                                        color: Color(0xFFD4AF37),
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_isInICU)
                                  Text(
                                    l10n.hospitalIcuRemaining(
                                      _formatTime(_icuRemainingSeconds),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    l10n.hospitalHpLine(
                                      player.health.toString(),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: healthPercent,
                                minHeight: 6,
                                backgroundColor: const Color(0xFF3A3A3A),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  healthPercent > 0.6
                                      ? Colors.green
                                      : healthPercent > 0.3
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (player.health < 30) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade700),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  player.health < 10
                                      ? AppLocalizations.of(
                                          context,
                                        )!.criticalHealthWarning
                                      : AppLocalizations.of(
                                          context,
                                        )!.lowHealthWarning,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Cooldown banner
                      if (_isOnCooldown) ..._buildCooldownBanner(),

                      // Treatment Options
                      Text(
                        l10n.treatmentOptions,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Extra realistic options
                      Card(
                        color: const Color(0xFF242424),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _isInICU
                                        ? Icons.local_hospital
                                        : Icons.assignment,
                                    color: _isInICU
                                        ? Colors.orange
                                        : Colors.lightBlueAccent,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.hospitalIcuTriageTitle,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isInICU
                                    ? l10n.hospitalIcuPatientRemaining(
                                        _formatTime(_icuRemainingSeconds),
                                      )
                                    : isCritical
                                    ? l10n.hospitalCriticalStatusDetected
                                    : l10n.hospitalStableStatus,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: isSmallScreen ? double.infinity : null,
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading
                                      ? null
                                      : _refreshMedicalStatus,
                                  icon: const Icon(Icons.refresh, size: 16),
                                  label: Text(
                                    l10n.hospitalRefreshMedicalRecord,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFFD4AF37),
                                    side: const BorderSide(
                                      color: Color(0xFFD4AF37),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Emergency Room - only when HP < 10
                      if (player.health < 10) ...[
                        Card(
                          color: Colors.orange[50],
                          child: InkWell(
                            onTap: !_isLoading ? _emergencyRoom : null,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.medical_services,
                                      color: Colors.orange[900],
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              l10n.emergencyHelp,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(
                                                  context,
                                                )!.free,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          AppLocalizations.of(
                                            context,
                                          )!.restoreCritical,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_isLoading)
                                    const CircularProgressIndicator()
                                  else
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.orange[700],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Standard treatment
                      Card(
                        child: InkWell(
                          onTap:
                              needsHealing &&
                                  canAffordStandard &&
                                  !_isLoading &&
                                  !_isOnCooldown
                              ? () => _heal(treatmentType: 'standard')
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.local_hospital,
                                    color: Colors.green[700],
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.hospitalStandardTreatmentTitle,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        l10n.hospitalStandardTreatmentSubtitle(
                                          standardHealAmount.toString(),
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${l10n.cost}: €$standardCost',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: canAffordStandard
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isLoading)
                                  const CircularProgressIndicator()
                                else if (!needsHealing)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                    size: 32,
                                  )
                                else if (_isOnCooldown)
                                  const Icon(
                                    Icons.lock_clock,
                                    color: Colors.orange,
                                    size: 28,
                                  )
                                else if (!canAffordStandard)
                                  const Icon(
                                    Icons.money_off,
                                    color: Colors.red,
                                    size: 32,
                                  )
                                else
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[400],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Intensive treatment
                      Card(
                        child: InkWell(
                          onTap:
                              needsHealing &&
                                  canAffordIntensive &&
                                  !_isLoading &&
                                  !_isOnCooldown
                              ? () => _heal(treatmentType: 'intensive')
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.purple[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.monitor_heart,
                                    color: Colors.purple[700],
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.hospitalIntensiveTreatmentTitle,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        l10n.hospitalIntensiveTreatmentSubtitle(
                                          intensiveHealAmount.toString(),
                                        ),
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${l10n.cost}: €$intensiveCost',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: canAffordIntensive
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_isLoading)
                                  const CircularProgressIndicator()
                                else if (!needsHealing)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green[700],
                                    size: 32,
                                  )
                                else if (_isOnCooldown)
                                  const Icon(
                                    Icons.lock_clock,
                                    color: Colors.orange,
                                    size: 28,
                                  )
                                else if (!canAffordIntensive)
                                  const Icon(
                                    Icons.money_off,
                                    color: Colors.red,
                                    size: 32,
                                  )
                                else
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey[400],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.blue[700],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.information,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.blue[900],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              [
                                l10n.hospitalInfo1,
                                l10n.hospitalInfo2,
                                l10n.emergencyInfo,
                                l10n.hospitalInfo3(standardCost.toString()),
                                l10n.hospitalInfo4(standardHealAmount.toString()),
                                l10n.hospitalIntensiveTreatmentInfoLine(
                                  intensiveCost.toString(),
                                  intensiveHealAmount.toString(),
                                ),
                                l10n.hospitalInfo5,
                                l10n.hospitalInfo6,
                              ].join('\n'),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[900],
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
