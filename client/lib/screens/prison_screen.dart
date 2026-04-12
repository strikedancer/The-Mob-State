import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/api_client.dart';
import '../utils/formatters.dart';
import 'player_profile_screen.dart';

class PrisonScreen extends StatefulWidget {
  const PrisonScreen({super.key});

  @override
  State<PrisonScreen> createState() => _PrisonScreenState();
}

class _PrisonScreenState extends State<PrisonScreen> {
  final ApiClient _apiClient = ApiClient();
  Timer? _ticker;
  OverlayEntry? _notificationEntry;

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  Timer? _notificationTimer;

  bool _isLoading = true;
  bool _isActing = false;
  String? _error;
  int _viewerMoney = 0;
  List<Map<String, dynamic>> _prisoners = [];

  @override
  void initState() {
    super.initState();
    _startTicker();
    _loadPrisoners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _notificationTimer?.cancel();
    _notificationEntry?.remove();
    super.dispose();
  }

  void _showTopRightNotification(
    String message, {
    Color backgroundColor = const Color(0xFF323232),
    IconData icon = Icons.info_outline,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    _notificationTimer?.cancel();
    _notificationEntry?.remove();

    final entry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final toastWidth = screenWidth < 440 ? screenWidth - 24 : 380.0;

        return Positioned(
          top: 16,
          right: 12,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: toastWidth,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(entry);
    _notificationEntry = entry;
    _notificationTimer = Timer(const Duration(seconds: 3), () {
      _notificationEntry?.remove();
      _notificationEntry = null;
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted || _prisoners.isEmpty) {
        return;
      }

      setState(() {
        _prisoners = _prisoners
            .map((prisoner) {
              final current =
                  (prisoner['remainingSeconds'] as num?)?.toInt() ?? 0;
              final next = current > 0 ? current - 1 : 0;
              return {...prisoner, 'remainingSeconds': next};
            })
            .where(
              (prisoner) =>
                  ((prisoner['remainingSeconds'] as num?)?.toInt() ?? 0) > 0,
            )
            .toList();
      });
    });
  }

  Future<void> _loadPrisoners() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/player/prisoners');
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final prisoners = (data['prisoners'] as List? ?? [])
            .whereType<Map>()
            .map((entry) => Map<String, dynamic>.from(entry))
            .toList();

        setState(() {
          _viewerMoney = (data['viewerMoney'] as num?)?.toInt() ?? 0;
          _prisoners = prisoners;
        });
      } else {
        setState(() {
          _error = (data['event'] as String?) ?? 'error.internal';
        });
      }
    } catch (_) {
      setState(() {
        _error = 'error.internal';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _buyOut(int targetId) async {
    if (_isActing) {
      return;
    }

    setState(() {
      _isActing = true;
    });

    try {
      final response = await _apiClient.post(
        '/player/prison/buyout/$targetId',
        {},
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final event = data['event'] as String? ?? 'error.internal';
      final l10n = AppLocalizations.of(context)!;
      final isDutch = l10n.localeName == 'nl';

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          event == 'prison.buyout_success') {
        final targetUsername =
            (data['params'] as Map<String, dynamic>?)?['targetUsername']
                as String? ??
            '-';
        final amount =
            ((data['params'] as Map<String, dynamic>?)?['amount'] as num?)
                ?.toInt() ??
            0;

        _showTopRightNotification(
          isDutch
              ? '✅ $targetUsername is vrijgekocht voor €$amount'
              : '✅ Bought out $targetUsername for €$amount',
          backgroundColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      } else {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final message = _resolveActionError(event, isDutch, params);
        _showTopRightNotification(
          message,
          backgroundColor: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      }

      await _loadPrisoners();
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final isDutch = l10n.localeName == 'nl';
        _showTopRightNotification(
          isDutch ? '❌ Actie mislukt' : '❌ Action failed',
          backgroundColor: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isActing = false;
        });
      }
    }
  }

  Future<void> _attemptJailbreak(int targetId) async {
    if (_isActing) {
      return;
    }

    setState(() {
      _isActing = true;
    });

    try {
      final response = await _apiClient.post('/player/jailbreak/$targetId', {});
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final event = data['event'] as String? ?? 'error.internal';
      final l10n = AppLocalizations.of(context)!;
      final isDutch = l10n.localeName == 'nl';

      if (!mounted) {
        return;
      }

      final message = _resolveJailbreakEvent(event, data, isDutch);
      _showTopRightNotification(
        message,
        backgroundColor: event == 'jailbreak.success'
            ? Colors.green.shade700
            : event == 'error.cooldown'
            ? Colors.red.shade700
            : Colors.orange.shade700,
        icon: event == 'jailbreak.success'
            ? Icons.check_circle_outline
            : event == 'error.cooldown'
            ? Icons.hourglass_top
            : Icons.warning_amber_rounded,
      );

      await _loadPrisoners();
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        final isDutch = l10n.localeName == 'nl';
        _showTopRightNotification(
          isDutch ? '❌ Actie mislukt' : '❌ Action failed',
          backgroundColor: Colors.red.shade700,
          icon: Icons.error_outline,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isActing = false;
        });
      }
    }
  }

  String _resolveActionError(
    String event,
    bool isDutch,
    Map<String, dynamic> params,
  ) {
    switch (event) {
      case 'error.insufficient_funds':
        return isDutch ? '❌ Onvoldoende geld' : '❌ Not enough money';
      case 'error.cooldown':
        final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
        return isDutch
            ? '⏱️ Cooldown actief: wacht nog ${formatAdaptiveDurationFromSeconds(remaining, localeName: 'nl')}'
            : '⏱️ Cooldown active: wait ${formatAdaptiveDurationFromSeconds(remaining, localeName: 'en')}';
      case 'error.target_not_jailed':
        return isDutch
            ? '❌ Doelwit zit niet meer in de gevangenis'
            : '❌ Target is no longer in prison';
      case 'error.cannot_buyout_self':
        return isDutch
            ? '❌ Je kunt jezelf niet uitkopen'
            : '❌ You cannot buy yourself out';
      case 'error.player_not_found':
        return isDutch ? '❌ Speler niet gevonden' : '❌ Player not found';
      default:
        return isDutch ? '❌ Actie mislukt' : '❌ Action failed';
    }
  }

  String _resolveJailbreakEvent(
    String event,
    Map<String, dynamic> data,
    bool isDutch,
  ) {
    final params = (data['params'] as Map<String, dynamic>?) ?? {};
    final rescuerJailTime = (params['rescuerJailTime'] as num?)?.toInt() ?? 0;

    switch (event) {
      case 'jailbreak.success':
        return isDutch
            ? '✅ Uitbraak gelukt! Gevangene is vrij.'
            : '✅ Jailbreak succeeded! Prisoner is free.';
      case 'jailbreak.caught':
        return isDutch
            ? '🚔 Uitbraak mislukt, je bent gepakt ($rescuerJailTime min cel).'
            : '🚔 Jailbreak failed, you got caught ($rescuerJailTime min jail).';
      case 'jailbreak.failed':
        return isDutch
            ? '❌ Uitbraak mislukt. Gevangene zit nog vast.'
            : '❌ Jailbreak failed. Prisoner is still locked up.';
      case 'error.rescuer_jailed':
        return isDutch
            ? '❌ Jij zit zelf in de cel'
            : '❌ You are in jail yourself';
      case 'error.target_not_jailed':
        return isDutch
            ? '❌ Doelwit zit niet meer in de gevangenis'
            : '❌ Target is no longer in prison';
      case 'error.cooldown':
        {
          final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
          return isDutch
              ? '⏱️ Cooldown actief: wacht nog ${formatAdaptiveDurationFromSeconds(remaining, localeName: 'nl')}'
              : '⏱️ Cooldown active: wait ${formatAdaptiveDurationFromSeconds(remaining, localeName: 'en')}';
        }
      case 'error.player_not_found':
        return isDutch ? '❌ Speler niet gevonden' : '❌ Player not found';
      default:
        return isDutch ? '❌ Uitbraak mislukt' : '❌ Jailbreak failed';
    }
  }

  String _formatDuration(int remainingSeconds) {
    final localeName = Localizations.localeOf(context).languageCode;
    return formatAdaptiveDurationFromSeconds(
      remainingSeconds,
      localeName: localeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDutch = l10n.localeName == 'nl';

    return Scaffold(
      appBar: AppBar(
        title: Text(isDutch ? 'Gevangenis' : 'Prison'),
        actions: [
          IconButton(
            onPressed: _isLoading || _isActing ? null : _loadPrisoners,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(
                isDutch
                    ? 'Kon gevangenen niet laden'
                    : 'Failed to load prisoners',
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey.shade900,
                  child: Text(
                    isDutch
                        ? 'Beschikbaar geld: €$_viewerMoney'
                        : 'Available money: €$_viewerMoney',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: _prisoners.isEmpty
                      ? Center(
                          child: Text(
                            isDutch
                                ? 'Geen gevangenen gevonden'
                                : 'No prisoners found',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: _prisoners.length,
                          separatorBuilder:
                              (separatorContext, separatorIndex) =>
                                  const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final prisoner = _prisoners[index];
                            final playerId =
                                (prisoner['playerId'] as num?)?.toInt() ?? 0;
                            final username =
                                prisoner['username'] as String? ?? '-';
                            final rank =
                                (prisoner['rank'] as num?)?.toInt() ?? 1;
                            final remainingSeconds =
                                (prisoner['remainingSeconds'] as num?)
                                    ?.toInt() ??
                                0;
                            final bailCost =
                                (prisoner['bailCost'] as num?)?.toInt() ?? 0;

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: playerId > 0
                                          ? () => _openPlayerProfile(
                                              playerId,
                                              username,
                                            )
                                          : null,
                                      child: Text(
                                        username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: playerId > 0
                                              ? Colors.lightBlue
                                              : null,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      isDutch ? 'Rank: $rank' : 'Rank: $rank',
                                    ),
                                    Text(
                                      isDutch
                                          ? 'Resterende tijd: ${_formatDuration(remainingSeconds)}'
                                          : 'Remaining time: ${_formatDuration(remainingSeconds)}',
                                    ),
                                    Text(
                                      isDutch
                                          ? 'Borg: €$bailCost'
                                          : 'Bail: €$bailCost',
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed:
                                                _isActing || playerId == 0
                                                ? null
                                                : () => _buyOut(playerId),
                                            icon: const Icon(Icons.payments),
                                            label: Text(
                                              isDutch ? 'Uitkopen' : 'Buy out',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed:
                                                _isActing || playerId == 0
                                                ? null
                                                : () => _attemptJailbreak(
                                                    playerId,
                                                  ),
                                            icon: const Icon(Icons.lock_open),
                                            label: Text(
                                              isDutch
                                                  ? 'Uitbreken'
                                                  : 'Jailbreak',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
