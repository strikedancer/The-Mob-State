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
  Map<String, dynamic>? _daily;
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
        api.get('/daily-goals/daily'),
        api.get('/crews/weekly-goal'),
      ]);
      if (!mounted) return;
      setState(() {
        _onboarding = _json(results[0].body)['data'] as Map<String, dynamic>?;
        _daily = _json(results[1].body)['data'] as Map<String, dynamic>?;
        _crewWeek = _json(results[2].body)['data'] as Map<String, dynamic>?;
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

  String _rewardLine(AppLocalizations? l10n, int cash, int xp) {
    if (l10n != null) {
      return l10n.dailyGoalReward(formatCurrency(cash), xp.toString());
    }
    return _isNl
        ? 'Beloning: +${formatCurrency(cash)} en +$xp XP'
        : 'Reward: +${formatCurrency(cash)} and +$xp XP';
  }

  Future<void> _claimDaily(String key) async {
    if (_claimingKey != null) return;
    setState(() => _claimingKey = key);
    try {
      final api = AuthService().apiClient;
      final response = await api.post('/daily-goals/daily/claim', {'goalKey': key});
      final decoded = _json(response.body);
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      if (decoded['success'] == true) {
        final data = (decoded['data'] as Map?)?.cast<String, dynamic>() ?? {};
        final cash = (data['rewardCash'] as num?)?.toInt() ?? 0;
        final xp = (data['rewardXp'] as num?)?.toInt() ?? 0;
        final title = l10n?.dailyGoalClaimed ??
            (_isNl ? 'Dagdoel geclaimd!' : 'Daily goal claimed!');
        _toast('$title ${_rewardLine(l10n, cash, xp)}');
        final auth = context.read<AuthProvider>();
        if (data['money'] != null || data['xp'] != null) {
          auth.updatePlayerStats(
            money: (data['money'] as num?)?.toInt(),
            xp: (data['xp'] as num?)?.toInt(),
            rank: (data['rank'] as num?)?.toInt(),
          );
        } else {
          await auth.refreshPlayer();
        }
        widget.onGoalsChanged?.call();
        await _load();
        return;
      }
      _toast(
        l10n?.failedPleaseTryAgain ?? (_isNl ? 'Mislukt. Probeer opnieuw.' : 'Failed. Please try again.'),
        color: Colors.orange,
      );
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      _toast(
        l10n?.failedPleaseTryAgain ?? (_isNl ? 'Mislukt. Probeer opnieuw.' : 'Failed. Please try again.'),
        color: Colors.orange,
      );
    } finally {
      if (mounted) setState(() => _claimingKey = null);
    }
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
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    final l10n = AppLocalizations.of(context);
    final completed = _onboarding?['completed'] == true;
    final featuredKey = (_daily?['featured'] as Map?)?['key']?.toString();
    final streak = (_daily?['streak'] as num?)?.toInt() ?? 0;
    final goals = (_daily?['goals'] as List?) ?? const [];
    final crewIn = _crewWeek?['inCrew'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!completed && _onboarding != null)
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
        if (goals.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n?.dailyGoals ?? (_isNl ? 'Dagdoelen' : 'Daily goals'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (streak > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          _isNl ? '$streak dagen streak' : '$streak day streak',
                          style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...goals.whereType<Map>().map((raw) {
                    final g = Map<String, dynamic>.from(raw);
                    return _dailyGoalRow(
                      l10n: l10n,
                      goal: g,
                      highlighted: g['key']?.toString() == featuredKey,
                    );
                  }),
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

  Widget _dailyGoalRow({
    required AppLocalizations? l10n,
    required Map<String, dynamic> goal,
    required bool highlighted,
  }) {
    final key = goal['key']?.toString() ?? '';
    final title = _isNl
        ? (goal['titleNl'] as String? ?? key)
        : (goal['titleEn'] as String? ?? key);
    final progress = (goal['progress'] as num?)?.toInt() ?? 0;
    final target = (goal['target'] as num?)?.toInt() ?? 0;
    final claimable = goal['claimable'] == true;
    final claimed = goal['claimed'] == true;
    final cash = (goal['rewardCash'] as num?)?.toInt() ?? 0;
    final xp = (goal['rewardXp'] as num?)?.toInt() ?? 0;
    final reward = _rewardLine(l10n, cash, xp);
    final busy = _claimingKey == key;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFF2A1A12) : Colors.black.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: claimable
                ? Colors.lightGreenAccent.withOpacity(0.55)
                : highlighted
                    ? const Color(0xFFD4AF37).withOpacity(0.45)
                    : Colors.white10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  claimed
                      ? (l10n?.claimed ?? (_isNl ? 'Geclaimd' : 'Claimed'))
                      : claimable
                          ? (l10n?.ready ?? (_isNl ? 'Klaar' : 'Ready'))
                          : '$progress/$target',
                  style: TextStyle(
                    color: claimed
                        ? Colors.greenAccent.withOpacity(0.9)
                        : claimable
                            ? Colors.lightGreenAccent
                            : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              claimed
                  ? (_isNl ? 'Geclaimd · $reward' : 'Claimed · $reward')
                  : reward,
              style: TextStyle(
                color: claimable ? const Color(0xFFD4AF37) : Colors.white70,
                fontSize: 12,
                fontWeight: claimable ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (!claimed)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: claimable && !busy && key.isNotEmpty ? () => _claimDaily(key) : null,
                  child: Text(
                    busy
                        ? '…'
                        : claimable
                            ? '${l10n?.claim ?? 'Claim'} · +${formatCurrency(cash)}'
                            : (l10n?.claim ?? 'Claim'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
