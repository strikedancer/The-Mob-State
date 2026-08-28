import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/game_event_rewards.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/formatters.dart';

/// Right-edge circular avatars for active live events (Clash-style quick access).
class LiveEventRail extends StatelessWidget {
  const LiveEventRail({
    super.key,
    required this.activeEvents,
    required this.onOpenEvents,
    this.claimableByCategory = const {},
    this.maxVisible = 4,
    this.topOffset = 120,
  });

  final List<Map<String, dynamic>> activeEvents;
  final VoidCallback onOpenEvents;
  /// Event Pass claimable reward counts keyed by goal category
  /// (`crime`, `vehicles`, `smuggling`, `drugs`, `money`, `xp`).
  final Map<String, int> claimableByCategory;
  final int maxVisible;
  final double topOffset;

  static int claimablesForEventCategory(
    String? eventCategory,
    Map<String, int> claimableByCategory,
  ) {
    final cat = (eventCategory ?? '').toLowerCase();
    switch (cat) {
      case 'crime':
        return claimableByCategory['crime'] ?? 0;
      case 'vehicles':
        return claimableByCategory['vehicles'] ?? 0;
      case 'smuggling':
        return claimableByCategory['smuggling'] ?? 0;
      case 'drugs':
        return claimableByCategory['drugs'] ?? 0;
      case 'trade':
        return claimableByCategory['money'] ?? 0;
      case 'allround':
        return (claimableByCategory['money'] ?? 0) +
            (claimableByCategory['xp'] ?? 0);
      default:
        return 0;
    }
  }

  /// Money/XP claimables with no matching allround/trade avatar still need a home.
  static int orphanClaimables(
    List<Map<String, dynamic>> events,
    Map<String, int> claimableByCategory,
  ) {
    var hasMoneyHome = false;
    var hasXpHome = false;
    for (final event in events) {
      final template = event['template'] is Map
          ? Map<String, dynamic>.from(event['template'] as Map)
          : null;
      final cat = (template?['category']?.toString() ?? '').toLowerCase();
      if (cat == 'allround') {
        hasMoneyHome = true;
        hasXpHome = true;
      } else if (cat == 'trade') {
        hasMoneyHome = true;
      }
    }
    var orphan = 0;
    if (!hasMoneyHome) orphan += claimableByCategory['money'] ?? 0;
    if (!hasXpHome) orphan += claimableByCategory['xp'] ?? 0;
    return orphan;
  }

  static ({IconData icon, Color accent}) categoryStyle(String? category) {
    switch ((category ?? '').toLowerCase()) {
      case 'crime':
        return (icon: Icons.warning_amber_rounded, accent: const Color(0xFFE85D4C));
      case 'drugs':
        return (icon: Icons.science, accent: const Color(0xFF5CC8A0));
      case 'smuggling':
        return (icon: Icons.local_shipping, accent: const Color(0xFF5B9BD5));
      case 'vehicles':
        return (icon: Icons.directions_car, accent: const Color(0xFFF0A04B));
      case 'trade':
        return (icon: Icons.storefront, accent: const Color(0xFFD4AF37));
      case 'allround':
        return (icon: Icons.emoji_events, accent: const Color(0xFFB388FF));
      default:
        return (icon: Icons.event, accent: const Color(0xFFD4AF37));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activeEvents.isEmpty) return const SizedBox.shrink();

    final visible = activeEvents.take(maxVisible).toList();
    final overflow = activeEvents.length - visible.length;
    final orphans = orphanClaimables(visible, claimableByCategory);

    return Positioned(
      right: 8,
      top: topOffset,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < visible.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _EventAvatarButton(
              event: visible[i],
              claimableCount: claimablesForEventCategory(
                    (visible[i]['template'] is Map
                            ? Map<String, dynamic>.from(
                                visible[i]['template'] as Map,
                              )
                            : null)?['category']
                        ?.toString(),
                    claimableByCategory,
                  ) +
                  (i == 0 ? orphans : 0),
              onTap: () => _showEventSheet(context, visible[i]),
            ),
          ],
          if (overflow > 0) ...[
            const SizedBox(height: 10),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpenEvents,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.72),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: Text(
                    '+$overflow',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEventSheet(BuildContext context, Map<String, dynamic> event) {
    final l10n = AppLocalizations.of(context)!;
    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final style = categoryStyle(template?['category']?.toString());
    final title = localizedGameEventTitle(l10n, template);
    final desc = localizedGameEventShortDescription(l10n, template);
    final endsAt =
        DateTime.tryParse(event['endsAt']?.toString() ?? '')?.toLocal();
    final tiers = parseGameEventPrizeTiers(
      (event['rewardRules'] as List?) ?? const <dynamic>[],
    );
    String? prizeHint;
    if (tiers.isNotEmpty) {
      final top = tiers.first;
      final parts = <String>[];
      if (top.cash > 0) parts.add(formatCurrency(top.cash));
      final extras = top.extendedPrizeLines(l10n);
      if (extras.isNotEmpty) parts.add(extras.first);
      if (parts.isNotEmpty) {
        prizeHint = l10n.gameCardTopPrize(parts.join(' · '));
      }
    }

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF151B28),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: style.accent.withValues(alpha: 0.2),
                        border: Border.all(color: style.accent),
                      ),
                      child: Icon(style.icon, color: style.accent, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          if (endsAt != null)
                            _CountdownLine(endsAt: endsAt, color: style.accent),
                        ],
                      ),
                    ),
                  ],
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.white70, height: 1.35),
                  ),
                ],
                if (prizeHint != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    prizeHint,
                    style: TextStyle(
                      color: style.accent,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      onOpenEvents();
                    },
                    icon: const Icon(Icons.event),
                    label: Text(l10n.liveEventRailOpenEvents),
                    style: FilledButton.styleFrom(
                      backgroundColor: style.accent,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EventAvatarButton extends StatefulWidget {
  const _EventAvatarButton({
    required this.event,
    required this.onTap,
    this.claimableCount = 0,
  });

  final Map<String, dynamic> event;
  final VoidCallback onTap;
  final int claimableCount;

  @override
  State<_EventAvatarButton> createState() => _EventAvatarButtonState();
}

class _EventAvatarButtonState extends State<_EventAvatarButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final template = widget.event['template'] is Map
        ? Map<String, dynamic>.from(widget.event['template'] as Map)
        : null;
    final style = LiveEventRail.categoryStyle(template?['category']?.toString());
    final l10n = AppLocalizations.of(context)!;
    final title = localizedGameEventTitle(l10n, template);

    final badge = widget.claimableCount > 0
        ? (widget.claimableCount > 99 ? '99+' : '${widget.claimableCount}')
        : null;

    return Tooltip(
      message: title,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final glow = 0.35 + (_pulse.value * 0.35);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 52,
                height: 52,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 2,
                      top: 2,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0F1420).withValues(alpha: 0.92),
                          border: Border.all(
                            color: style.accent
                                .withValues(alpha: 0.55 + glow * 0.35),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: style.accent.withValues(alpha: glow * 0.55),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Icon(style.icon, color: style.accent, size: 22),
                      ),
                    ),
                    if (badge != null)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFF0F1420),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CountdownLine extends StatefulWidget {
  const _CountdownLine({required this.endsAt, required this.color});

  final DateTime endsAt;
  final Color color;

  @override
  State<_CountdownLine> createState() => _CountdownLineState();
}

class _CountdownLineState extends State<_CountdownLine> {
  Timer? _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();
    _remaining = widget.endsAt.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _remaining = widget.endsAt.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_remaining.inSeconds <= 0) {
      return Text(
        l10n.gameScreenCountdownNow,
        style: TextStyle(color: widget.color, fontSize: 12),
      );
    }
    final h = _remaining.inHours;
    final m = _remaining.inMinutes.remainder(60);
    final s = _remaining.inSeconds.remainder(60);
    final text = h > 0
        ? '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}'
        : '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    return Text(
      text,
      style: TextStyle(
        color: widget.color,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
