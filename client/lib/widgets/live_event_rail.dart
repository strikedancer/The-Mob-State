import 'dart:async';

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/game_event_theme.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/web_asset_helper.dart';
import 'game_event_details_dialog.dart';

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


/// Right-edge circular avatars for active live events (Clash-style quick access).
class LiveEventRail extends StatelessWidget {
  const LiveEventRail({
    super.key,
    required this.activeEvents,
    required this.onOpenEvents,
    this.claimableByCategory = const {},
    this.maxVisible = 6,
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

  static GameEventTheme categoryStyle(String? category) {
    return gameEventThemeForCategory(category);
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
              onTap: () => showGameEventDetailsDialog(
                context: context,
                event: visible[i],
              ),
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
    final isActive = widget.event['status']?.toString() == 'active' ||
        widget.event['preview'] != true &&
            widget.event['status']?.toString() != 'scheduled';
    final countdownAt = DateTime.tryParse(
      ((isActive
                  ? widget.event['endsAt']
                  : widget.event['startedAt'] ?? widget.event['endsAt'])
              ?.toString() ??
          ''),
    )?.toLocal();

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
                height: 62,
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
                        clipBehavior: Clip.antiAlias,
                        child: WebAssetHelper.imageHttpFirst(
                          style.asset,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) =>
                              ColoredBox(
                            color: const Color(0xFF0F1420),
                            child: Icon(
                              style.icon,
                              color: style.accent,
                              size: 22,
                            ),
                          ),
                        ),
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
                    if (countdownAt != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        // Avatar bottom (top 2 + 48) sits on the vertical
                        // midpoint of this ~18px pill.
                        top: 41,
                        child: Center(
                          child: _EventRemainingBadge(
                            endsAt: countdownAt,
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
      child: SizedBox(
        height: 18,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Center(
            child: _EventRemainingLine(
              endsAt: endsAt,
              color: accent,
              compact: true,
            ),
          ),
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
