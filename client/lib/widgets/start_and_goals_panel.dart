import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../screens/crime_screen.dart';
import '../screens/crew_screen.dart';
import '../screens/jobs_screen.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';

class StartAndGoalsPanel extends StatefulWidget {
  final bool compact;
  final int playerRank;
  final VoidCallback? onGoalsChanged;

  const StartAndGoalsPanel({
    super.key,
    this.compact = false,
    this.playerRank = 1,
    this.onGoalsChanged,
  });

  @override
  State<StartAndGoalsPanel> createState() => _StartAndGoalsPanelState();
}

class _StartAndGoalsPanelState extends State<StartAndGoalsPanel> {
  Map<String, dynamic>? _onboarding;
  Map<String, dynamic>? _crewWeek;
  bool _loading = true;
  String? _claimingKey;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final api = AuthService().apiClient;
      final results = await Future.wait([
        api.get('/player/onboarding'),
        api.get('/crews/weekly-goal'),
      ]);
      if (!mounted) return;
      setState(() {
        _onboarding = _json(results[0].body)['data'] as Map<String, dynamic>?;
        _crewWeek = _json(results[1].body)['data'] as Map<String, dynamic>?;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic> _json(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  void _openCta(String route) {
    Widget page;
    switch (route) {
      case '/jobs':
        page = const JobsScreen();
        break;
      case '/crew':
        page = const CrewScreen();
        break;
      default:
        page = const CrimeScreen();
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => page)).then((_) => _load());
  }

  void _toast(String text, {Color color = Colors.green}) {
    if (!mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.zero,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _claimCrewWeek() async {
    if (_claimingKey != null) return;
    setState(() => _claimingKey = 'crew_week');
    try {
      final api = AuthService().apiClient;
      final response = await api.post('/crews/weekly-goal/claim', {});
      final decoded = _json(response.body);
      if (!mounted) return;
      final cash = (_crewWeek?['rewardCrewCash'] as num?)?.toInt() ?? 25000;
      final xp = (_crewWeek?['rewardPersonalXp'] as num?)?.toInt() ?? 40;
      if (decoded['success'] == true || response.statusCode == 200) {
        _toast(
          _isNl
              ? 'Crew weekdoel geclaimd: +${formatCurrency(cash)} crewbank en +$xp XP'
              : 'Crew weekly goal claimed: +${formatCurrency(cash)} crew bank and +$xp XP',
        );
        await context.read<AuthProvider>().refreshPlayer();
        widget.onGoalsChanged?.call();
        await _load();
        return;
      }
      _toast(
        _isNl ? 'Mislukt. Probeer opnieuw.' : 'Failed. Please try again.',
        color: Colors.orange,
      );
    } catch (_) {
      if (!mounted) return;
      _toast(
        _isNl ? 'Mislukt. Probeer opnieuw.' : 'Failed. Please try again.',
        color: Colors.orange,
      );
    } finally {
      if (mounted) setState(() => _claimingKey = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final showStart = _onboarding != null && _onboarding!['completed'] != true;
    final crewIn = _crewWeek?['inCrew'] == true;
    if (!showStart && !crewIn) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showStart)
          Card(
            color: const Color(0xFF2A1A12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isNl ? 'Jouw start' : 'Your start',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isNl
                        ? (_onboarding!['titleNl'] as String? ?? '')
                        : (_onboarding!['titleEn'] as String? ?? ''),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isNl
                        ? (_onboarding!['bodyNl'] as String? ?? '')
                        : (_onboarding!['bodyEn'] as String? ?? ''),
                    style: TextStyle(color: Colors.white.withOpacity(0.75)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _openCta(_onboarding!['ctaRoute'] as String? ?? '/crimes'),
                    child: Text(_isNl ? 'Nu doen' : 'Do this now'),
                  ),
                ],
              ),
            ),
          ),
        if (crewIn)
          Card(
            child: ListTile(
              title: Text(
                _isNl
                    ? (_crewWeek!['titleNl'] as String? ?? 'Crew weekdoel')
                    : (_crewWeek!['titleEn'] as String? ?? 'Crew weekly goal'),
              ),
              subtitle: Text(
                '${_crewWeek!['progress'] ?? 0}/${_crewWeek!['target'] ?? 1}'
                ' · ${_isNl ? 'Beloning' : 'Reward'}: +${formatCurrency((_crewWeek!['rewardCrewCash'] as num?)?.toInt() ?? 25000)} '
                '${_isNl ? 'crewbank' : 'crew bank'} +${(_crewWeek!['rewardPersonalXp'] as num?)?.toInt() ?? 40} XP'
                '${_crewWeek!['claimed'] == true ? (_isNl ? ' · geclaimd' : ' · claimed') : ''}',
              ),
              trailing: _crewWeek!['claimable'] == true
                  ? TextButton(
                      onPressed: _claimingKey == null ? _claimCrewWeek : null,
                      child: Text(l10n?.claim ?? 'Claim'),
                    )
                  : Text(
                      _crewWeek!['claimed'] == true
                          ? (l10n?.claimed ?? (_isNl ? 'Geclaimd' : 'Claimed'))
                          : '',
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                    ),
            ),
          ),
      ],
    );
  }
}
