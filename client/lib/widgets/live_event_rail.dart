import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/game_event_rewards.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/formatters.dart';

String formatLiveEventRemaining(Duration remaining, AppLocalizations l10n) {
  if (remaining.inSeconds <= 0) {
    return l10n.gameScreenCountdownNow;
  }
  final days = remaining.inDays;
  final hours = remaining.inHours.remainder(24);
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60);
  if (days > 0) {
    return l10n.gameScreenCountdownDays(
      days.toString(),
      hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
    );
  }
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

/// Compact badge text so it fits under a 48px avatar.
String formatLiveEventRemainingBadge(Duration remaining, AppLocalizations l10n) {
  if (remaining.inSeconds <= 0) {
    return l10n.gameScreenCountdownNow;
  }
  final days = remaining.inDays;
  final hours = remaining.inHours;
  final minutes = remaining.inMinutes.remainder(60);
  final seconds = remaining.inSeconds.remainder(60);
  if (days > 0) {
    return l10n.gameScreenCountdownDays(
      days.toString(),
      hours.remainder(24).toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
    );
  }
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

String _formatEventDateTime(String? raw) {
  final parsed = DateTime.tryParse(raw ?? '');
  if (parsed == null) return '';
  final local = parsed.toLocal();
  final dd = local.day.toString().padLeft(2, '0');
  final mm = local.month.toString().padLeft(2, '0');
  final yy = local.year.toString();
  final hh = local.hour.toString().padLeft(2, '0');
  final min = local.minute.toString().padLeft(2, '0');
  return '$dd-$mm-$yy $hh:$min';
}

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
            if (i > 0) const SizedBox(height: 8),
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
              onTap: () => _showEventPopup(context, visible[i]),
            ),
          ],
          if (overflow > 0) ...[
            const SizedBox(height: 8),
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

  void _showEventPopup(BuildContext context, Map<String, dynamic> event) {
    final l10n = AppLocalizations.of(context)!;
    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final style = categoryStyle(template?['category']?.toString());
    final title = localizedGameEventTitle(l10n, template);
    final desc = localizedGameEventShortDescription(l10n, template);
    final endsAt =
        DateTime.tryParse(event['endsAt']?.toString() ?? '')?.toLocal();
    final startedAtRaw = _formatEventDateTime(event['startedAt']?.toString());
    final endsAtRaw = _formatEventDateTime(event['endsAt']?.toString());
    final statusLabel = localizedGameEventLiveStatus(
      l10n,
      event['status']?.toString() ?? 'active',
    );
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

    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.62),
      builder: (dialogContext) {
        final dialogL10n = AppLocalizations.of(dialogContext)!;
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A2233), Color(0xFF0E1219)],
                ),
                border: Border.all(color: style.accent.withValues(alpha: 0.55)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: style.accent.withValues(alpha: 0.18),
                            border: Border.all(color: style.accent),
                          ),
                          child: Icon(style.icon, color: style.accent, size: 24),
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
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.greenAccent),
                                ),
                                child: Text(
                                  statusLabel,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          icon: const Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),
                    if (endsAt != null) ...[
                      const SizedBox(height: 12),
                      _EventRemainingLine(
                        endsAt: endsAt,
                        color: style.accent,
                        compact: false,
                      ),
                    ],
                    if (startedAtRaw.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        dialogL10n.gameScreenStartLine(startedAtRaw),
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                    if (endsAtRaw.isNotEmpty)
                      Text(
                        dialogL10n.gameScreenEndLine(endsAtRaw),
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    if (desc.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        desc,
                        style: const TextStyle(color: Colors.white70, height: 1.35),
                      ),
                    ],
                    if (prizeHint != null) ...[
                      const SizedBox(height: 12),
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
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white70,
                          ),
                          child: Text(dialogL10n.close),
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            onOpenEvents();
                          },
                          icon: const Icon(Icons.event),
                          label: Text(dialogL10n.liveEventRailOpenEvents),
                          style: FilledButton.styleFrom(
                            backgroundColor: style.accent,
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
    final endsAt =
        DateTime.tryParse(widget.event['endsAt']?.toString() ?? '')?.toLocal();

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
              borderRadius: BorderRadius.circular(28),
              child: SizedBox(
                width: 58,
                height: 68,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 5,
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
                        right: 0,
                        top: 0,
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
                    if (endsAt != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Center(
                          child: _EventRemainingBadge(
                            endsAt: endsAt,
                            accent: style.accent,
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

class _EventRemainingBadge extends StatelessWidget {
  const _EventRemainingBadge({
    required this.endsAt,
    required this.accent,
  });

  final DateTime endsAt;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0F18).withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: _EventRemainingLine(
          endsAt: endsAt,
          color: accent,
          compact: true,
        ),
      ),
    );
  }
}

class _EventRemainingLine extends StatefulWidget {
  const _EventRemainingLine({
    required this.endsAt,
    required this.color,
    required this.compact,
  });

  final DateTime endsAt;
  final Color color;
  final bool compact;

  @override
  State<_EventRemainingLine> createState() => _EventRemainingLineState();
}

class _EventRemainingLineState extends State<_EventRemainingLine> {
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
  void didUpdateWidget(covariant _EventRemainingLine oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endsAt != widget.endsAt) {
      _remaining = widget.endsAt.difference(DateTime.now());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = widget.compact
        ? formatLiveEventRemainingBadge(_remaining, l10n)
        : formatLiveEventRemaining(_remaining, l10n);
    return Text(
      text,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.compact ? 9 : 14,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: widget.compact ? -0.2 : 0,
      ),
    );
  }
}
