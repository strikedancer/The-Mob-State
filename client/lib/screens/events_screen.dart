import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/game_event_rewards.dart';
import '../utils/game_event_theme.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/top_right_notification.dart';
import '../widgets/game_event_details_dialog.dart';
import '../widgets/season_pass_panel.dart';
import 'premium_screen.dart';

class EventsScreen extends StatefulWidget {
  /// When true (e.g. web dashboard panel), no [AppBar] — parent provides chrome.
  final bool embedded;

  /// Opens Premium & Credits (Season Pass purchase).
  final VoidCallback? onOpenPremium;

  const EventsScreen({
    super.key,
    this.embedded = false,
    this.onOpenPremium,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  static const Color _gold = Color(0xFFD4AF37);

  final _apiClient = AuthService().apiClient;

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _active = const [];
  List<Map<String, dynamic>> _upcoming = const [];
  List<Map<String, dynamic>> _upcomingPreview = const [];
  Map<int, Map<String, dynamic>> _progressByEvent = const {};
  DateTime _now = DateTime.now();
  Timer? _tickTimer;

  @override
  void initState() {
    super.initState();
    _loadOverview(autoRetry: true);
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _tickTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOverview({bool autoRetry = false}) async {
    setState(() {
      _isLoading = _active.isEmpty && _upcoming.isEmpty && _error == null;
      _error = null;
    });

    try {
      final response = await _apiClient.get('/game-events/overview');
      if (response.statusCode != 200) {
        throw Exception('failed');
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('invalid events overview');
      }
      final data = decoded;
      final activeList = ((data['active'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      final upcomingList = ((data['upcoming'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
      final upcomingPreviewList =
          ((data['upcomingPreview'] as List?) ?? const <dynamic>[])
              .whereType<Map>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
      final progressList = ((data['myProgress'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

      final progressByEvent = <int, Map<String, dynamic>>{};
      for (final item in progressList) {
        final eventId = (item['liveEventId'] as num?)?.toInt();
        if (eventId != null) {
          progressByEvent[eventId] = item;
        }
      }

      if (!mounted) return;
      setState(() {
        _active = activeList;
        _upcoming = upcomingList;
        _upcomingPreview = upcomingPreviewList;
        _progressByEvent = progressByEvent;
        _isLoading = false;
        _error = null;
        _now = DateTime.now();
      });
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      setState(() {
        _isLoading = false;
        _error = l10n?.connectionErrorGeneric;
      });
      if (l10n == null) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.gameScreenLoadError),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (autoRetry && _error != null && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!mounted || _error == null) return;
      await _loadOverview();
    }
  }

  Future<void> _openEventDetails(Map<String, dynamic> event) {
    return showGameEventDetailsDialog(context: context, event: event);
  }


  String _formatCountdown(DateTime? at, AppLocalizations l10n) {
    if (at == null) return l10n.gameScreenDash;
    final diff = at.difference(_now);
    if (diff.inSeconds <= 0) return l10n.gameScreenCountdownNow;
    final d = diff.inDays;
    final h = diff.inHours.remainder(24);
    final m = diff.inMinutes.remainder(60);
    final s = diff.inSeconds.remainder(60);
    if (d > 0) {
      return l10n.gameScreenCountdownDays(
        d.toString(),
        h.toString().padLeft(2, '0'),
        m.toString().padLeft(2, '0'),
      );
    }
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  GameEventTheme _categoryTheme(Map<String, dynamic>? template) {
    return gameEventThemeForCategory(template?['category']?.toString());
  }

  String? _topPrizeTeaser(AppLocalizations l10n, Map<String, dynamic> event) {
    final tiers = parseGameEventPrizeTiers(
      (event['rewardRules'] as List?) ?? const <dynamic>[],
    );
    if (tiers.isEmpty) return null;
    final top = tiers.first;
    final parts = <String>[];
    if (top.cash > 0) parts.add(formatCurrency(top.cash));
    if (top.premiumCredits > 0) {
      parts.add(l10n.gameScreenPrizeCredits(top.premiumCredits.toString()));
    }
    final extras = top.extendedPrizeLines(l10n);
    if (extras.isNotEmpty) {
      parts.add(extras.first);
    }
    if (parts.isEmpty && top.xp > 0) {
      parts.add(l10n.gameScreenPrizeXp(top.xp.toString()));
    }
    if (parts.isEmpty) return null;
    return l10n.gameCardTopPrize(parts.join(' · '));
  }

  Widget _buildEventCard(
    AppLocalizations l10n,
    Map<String, dynamic> event, {
    required bool isActive,
  }) {
    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final eventId = (event['id'] as num?)?.toInt();
    final isPreview = event['preview'] == true;
    final progress = eventId != null ? _progressByEvent[eventId] : null;
    final score = (progress?['score'] as num?)?.toDouble();
    final rank = (progress?['rank'] as num?)?.toInt();
    final theme = _categoryTheme(template);
    final endsAt = DateTime.tryParse(event['endsAt']?.toString() ?? '')?.toLocal();
    final startsAt =
        DateTime.tryParse(event['startedAt']?.toString() ?? '')?.toLocal();
    final prizeTeaser = _topPrizeTeaser(l10n, event);
    final title = localizedGameEventTitle(l10n, template);
    final desc = localizedGameEventShortDescription(l10n, template);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? theme.accent.withValues(alpha: 0.55)
              : _gold.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accent.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openEventDetails(event),
            child: SizedBox(
              height: 210,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    theme.asset,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFF1A1210),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.82),
                          const Color(0xFF0A0808).withValues(alpha: 0.96),
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.accent.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: theme.accent.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Icon(
                                theme.icon,
                                color: theme.accent,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                  height: 1.15,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.green.withValues(alpha: 0.22)
                                    : Colors.orange.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: isActive
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                ),
                              ),
                              child: Text(
                                isActive
                                    ? l10n.gameCardActive
                                    : l10n.gameCardScheduled,
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (desc.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            desc,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                        ],
                        const Spacer(),
                        if (isActive) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 16,
                                color: theme.accent,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.gameCardEndsIn(
                                  _formatCountdown(endsAt, l10n),
                                ),
                                style: TextStyle(
                                  color: theme.accent,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                          if (progress != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _statChip(
                                  l10n.gameCardYourScore(
                                    (score ?? 0).toStringAsFixed(0),
                                  ),
                                  theme.accent,
                                ),
                                const SizedBox(width: 8),
                                _statChip(
                                  l10n.gameCardYourRank(
                                    rank?.toString() ?? l10n.gameScreenDash,
                                  ),
                                  _gold,
                                ),
                              ],
                            ),
                          ],
                        ] else ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule,
                                size: 16,
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.gameCardStartsIn(
                                    _formatCountdown(startsAt, l10n),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (prizeTeaser != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.emoji_events,
                                size: 16,
                                color: _gold,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  prizeTeaser,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _gold,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: theme.accent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.accent.withValues(alpha: 0.55),
                              ),
                            ),
                            child: Text(
                              isPreview
                                  ? l10n.gameCardViewPrizes
                                  : l10n.gameCardJoinCta,
                              style: TextStyle(
                                color: theme.accent,
                                fontWeight: FontWeight.w800,
                                fontSize: 12.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(999),
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

  Widget _buildPageHero(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A2814).withValues(alpha: 0.95),
            const Color(0xFF120808),
          ],
        ),
        border: Border.all(color: _gold.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _gold.withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.emoji_events, color: _gold, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.gameScreenHeroTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.gameScreenHeroSubtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statChip(
                l10n.gameScreenActiveCount(_active.length.toString()),
                Colors.greenAccent,
              ),
              _statChip(
                l10n.gameScreenUpcomingCount(
                  (_upcoming.length + _upcomingPreview.length).toString(),
                ),
                Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final upcomingCombined = [..._upcoming, ..._upcomingPreview];

    final seasonPass = SeasonPassPanel(
      onBuyPremium: () {
        if (widget.onOpenPremium != null) {
          widget.onOpenPremium!();
          return;
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const PremiumScreen()),
        );
      },
    );

    Widget liveSection;
    if (_isLoading) {
      liveSection = const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(child: CircularProgressIndicator(color: _gold)),
      );
    } else if (_error != null) {
      liveSection = Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
        child: Column(
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loadOverview,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      );
    } else {
      liveSection = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle(l10n.gameScreenSectionLive),
          if (_active.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                l10n.gameScreenNoActive,
                style: const TextStyle(color: Colors.white70),
              ),
            )
          else
            ..._active.map(
              (event) => _buildEventCard(l10n, event, isActive: true),
            ),
          _sectionTitle(l10n.gameScreenSectionUpcoming),
          if (upcomingCombined.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF151010),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                l10n.gameScreenNoUpcoming,
                style: const TextStyle(color: Colors.white70),
              ),
            )
          else
            ...upcomingCombined.map(
              (event) => _buildEventCard(l10n, event, isActive: false),
            ),
        ],
      );
    }

    final body = RefreshIndicator(
      color: _gold,
      onRefresh: _loadOverview,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
        children: [
          _buildPageHero(l10n),
          seasonPass,
          liveSection,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0A),
      appBar: widget.embedded ? null : AppBar(title: Text(l10n.events)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A0A0A), Color(0xFF0C0A0A)],
          ),
        ),
        child: body,
      ),
    );
  }
}
