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
  int _viewerId = 0;
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
          _viewerId = (data['viewerId'] as num?)?.toInt() ?? 0;
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
          l10n.prisonBuyoutSuccess(targetUsername, amount.toString()),
          backgroundColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      } else {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final message = _resolveActionError(event, l10n, params);
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
        _showTopRightNotification(
          l10n.prisonActionFailed,
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

      if (!mounted) {
        return;
      }

      final message = _resolveJailbreakEvent(event, data, l10n);
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
        _showTopRightNotification(
          l10n.prisonActionFailed,
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

  Future<void> _payOwnBail() async {
    if (_isActing) {
      return;
    }

    setState(() {
      _isActing = true;
    });

    try {
      final response = await _apiClient.post('/player/pay-bail', {});
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final event = data['event'] as String? ?? 'error.internal';
      final l10n = AppLocalizations.of(context)!;

      if (!mounted) {
        return;
      }

      if (response.statusCode >= 200 && response.statusCode < 300 &&
          event == 'bail.paid') {
        final amount =
            ((data['params'] as Map<String, dynamic>?)?['amount'] as num?)
                ?.toInt() ??
            0;
        _showTopRightNotification(
          l10n.prisonPaidBailSuccess(amount.toString()),
          backgroundColor: Colors.green.shade700,
          icon: Icons.check_circle_outline,
        );
      } else {
        final params = (data['params'] as Map<String, dynamic>?) ?? {};
        final message = _resolveActionError(event, l10n, params);
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
        _showTopRightNotification(
          l10n.prisonActionFailed,
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

  Future<void> _attemptOwnEscape() async {
    if (_isActing) {
      return;
    }

    setState(() {
      _isActing = true;
    });

    try {
      final response = await _apiClient.post('/player/prison/escape', {});
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final event = data['event'] as String? ?? 'error.internal';
      final params = (data['params'] as Map<String, dynamic>?) ?? {};
      final l10n = AppLocalizations.of(context)!;

      if (!mounted) {
        return;
      }

      String message;
      Color backgroundColor;
      IconData icon;

      if (event == 'prison.escape_success') {
        message = l10n.prisonEscapeSuccess;
        backgroundColor = Colors.green.shade700;
        icon = Icons.check_circle_outline;
      } else if (event == 'prison.escape_failed') {
        final penalty = (params['penaltySeconds'] as num?)?.toInt() ?? 0;
        final penaltyText = formatAdaptiveDurationFromSeconds(
          penalty,
          localeName: l10n.localeName,
        );
        message = l10n.prisonEscapeFailed(penaltyText);
        backgroundColor = Colors.orange.shade700;
        icon = Icons.warning_amber_rounded;
      } else if (event == 'error.cooldown') {
        final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
        message = l10n.prisonCooldownActive(
          formatAdaptiveDurationFromSeconds(
            remaining,
            localeName: l10n.localeName,
          ),
        );
        backgroundColor = Colors.red.shade700;
        icon = Icons.hourglass_top;
      } else {
        message = l10n.prisonEscapeGenericFailure;
        backgroundColor = Colors.red.shade700;
        icon = Icons.error_outline;
      }

      _showTopRightNotification(
        message,
        backgroundColor: backgroundColor,
        icon: icon,
      );

      await _loadPrisoners();
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        _showTopRightNotification(
          l10n.prisonActionFailed,
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
    AppLocalizations l10n,
    Map<String, dynamic> params,
  ) {
    switch (event) {
      case 'error.insufficient_funds':
        return l10n.prisonErrorInsufficientFunds;
      case 'error.cooldown':
        final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
        return l10n.prisonCooldownActive(
          formatAdaptiveDurationFromSeconds(
            remaining,
            localeName: l10n.localeName,
          ),
        );
      case 'error.target_not_jailed':
        return l10n.prisonErrorTargetNotJailed;
      case 'error.cannot_buyout_self':
        return l10n.prisonErrorCannotBuyoutSelf;
      case 'error.player_not_found':
        return l10n.prisonErrorPlayerNotFound;
      default:
        return l10n.prisonActionFailed;
    }
  }

  String _resolveJailbreakEvent(
    String event,
    Map<String, dynamic> data,
    AppLocalizations l10n,
  ) {
    final params = (data['params'] as Map<String, dynamic>?) ?? {};
    final rescuerJailTime = (params['rescuerJailTime'] as num?)?.toInt() ?? 0;

    switch (event) {
      case 'jailbreak.success':
        return l10n.prisonJailbreakSuccess;
      case 'jailbreak.caught':
        return l10n.prisonJailbreakCaught(rescuerJailTime.toString());
      case 'jailbreak.failed':
        return l10n.prisonJailbreakFailed;
      case 'error.rescuer_jailed':
        return l10n.prisonErrorRescuerJailed;
      case 'error.target_not_jailed':
        return l10n.prisonErrorTargetNotJailed;
      case 'error.cooldown':
        {
          final remaining = (params['remainingSeconds'] as num?)?.toInt() ?? 0;
          return l10n.prisonCooldownActive(
            formatAdaptiveDurationFromSeconds(
              remaining,
              localeName: l10n.localeName,
            ),
          );
        }
      case 'error.player_not_found':
        return l10n.prisonErrorPlayerNotFound;
      default:
        return l10n.prisonJailbreakGenericFailure;
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.prisonTitle),
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
                l10n.prisonLoadFailed,
                style: const TextStyle(color: Colors.red),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: _prisoners.isEmpty
                      ? Center(
                          child: Text(
                            l10n.prisonNoPrisonersFound,
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
                            final isCurrentViewer =
                                _viewerId > 0 && playerId == _viewerId;
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
                                      isCurrentViewer
                                          ? l10n.prisonRankYouLine(rank.toString())
                                          : l10n.prisonRankLine(rank.toString()),
                                    ),
                                    Text(
                                      l10n.prisonRemainingTimeLine(
                                        _formatDuration(remainingSeconds),
                                      ),
                                    ),
                                    Text(
                                      l10n.prisonBailLine(bailCost.toString()),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _isActing || playerId == 0
                                                ? null
                                                : isCurrentViewer
                                                ? _payOwnBail
                                                : () => _buyOut(playerId),
                                            icon: const Icon(Icons.payments),
                                            label: Text(
                                              isCurrentViewer
                                                  ? l10n.prisonPayBailButton
                                                  : l10n.prisonBuyOutButton,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: OutlinedButton.icon(
                                            onPressed: _isActing || playerId == 0
                                                ? null
                                                : isCurrentViewer
                                                ? _attemptOwnEscape
                                                : () => _attemptJailbreak(
                                                    playerId,
                                                  ),
                                            icon: const Icon(Icons.lock_open),
                                            label: Text(
                                              isCurrentViewer
                                                  ? l10n.prisonAttemptEscapeButton
                                                  : l10n.prisonJailbreakButton,
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
