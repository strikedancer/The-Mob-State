import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../utils/game_event_theme.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/web_asset_helper.dart';
import 'game_event_details_dialog.dart';

const _liveEventRailExpandedPref = 'live_event_rail_expanded';

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
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}


/// Right-edge circular avatars for active live events (Clash-style quick access).
/// Anchored bottom-right so page-header actions (info, refresh, chips) stay tappable.
/// Starts collapsed to one dock chip so avatars do not cover page text or send.
class LiveEventRail extends StatefulWidget {
  const LiveEventRail({
    super.key,
    required this.activeEvents,
    required this.onOpenEvents,
    this.eventPassClaimableCount = 0,
    this.maxVisible = 6,
    this.bottomOffset = 16,
  });

  final List<Map<String, dynamic>> activeEvents;
  final VoidCallback onOpenEvents;
  /// Claimable Event Pass rewards. Shown only on the monthly Empire avatar
  /// (that popup is the Event Pass list). Weekly event avatars and
  /// dashboard daily/weekly goals stay separate.
  final int eventPassClaimableCount;
  final int maxVisible;
  final double bottomOffset;

  static GameEventTheme categoryStyle(String? category) {
    return gameEventThemeForCategory(category);
  }

  @override
  State<LiveEventRail> createState() => _LiveEventRailState();
}

class _LiveEventRailState extends State<LiveEventRail> {
  bool _expanded = false;
  bool _prefLoaded = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadExpandedPref());
  }

  Future<void> _loadExpandedPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      setState(() {
        _expanded = prefs.getBool(_liveEventRailExpandedPref) ?? false;
        _prefLoaded = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _prefLoaded = true);
    }
  }

  Future<void> _setExpanded(bool value) async {
    setState(() => _expanded = value);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_liveEventRailExpandedPref, value);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeEvents.isEmpty) return const SizedBox.shrink();

    final visible = widget.activeEvents.take(widget.maxVisible).toList();
    final overflow = widget.activeEvents.length - visible.length;
    // Column is bottom-anchored, so reverse: Monthly Empire (first item) sits
    // nearest the thumb; overflow "+N" stays above the stack.
    final stacked = visible.reversed.toList();
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final preview = stacked.isNotEmpty ? stacked.last : visible.first;
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      right: 8,
      bottom: widget.bottomOffset + safeBottom,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        alignment: Alignment.bottomCenter,
        child: !_prefLoaded || !_expanded
            ? _CollapsedEventDock(
                event: preview,
                extraCount: widget.activeEvents.length - 1,
                claimableCount: widget.eventPassClaimableCount,
                tooltip: l10n.liveEventRailExpand,
                onTap: () => _setExpanded(true),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: l10n.liveEventRailCollapse,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _setExpanded(false),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 44,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.72),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white38),
                          ),
                          child: const Icon(
                            Icons.expand_more,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (overflow > 0) ...[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onOpenEvents,
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
                    const SizedBox(height: 8),
                  ],
                  for (var i = 0; i < stacked.length; i++) ...[
                    if (i > 0) const SizedBox(height: 8),
                    _EventAvatarButton(
                      event: stacked[i],
                      claimableCount: isMonthlyEmpireEvent(stacked[i])
                          ? widget.eventPassClaimableCount
                          : 0,
                      onTap: () => showGameEventDetailsDialog(
                        context: context,
                        event: stacked[i],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class _CollapsedEventDock extends StatelessWidget {
  const _CollapsedEventDock({
    required this.event,
    required this.extraCount,
    required this.claimableCount,
    required this.tooltip,
    required this.onTap,
  });

  final Map<String, dynamic> event;
  final int extraCount;
  final int claimableCount;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final template = event['template'] is Map
        ? Map<String, dynamic>.from(event['template'] as Map)
        : null;
    final style = LiveEventRail.categoryStyle(template?['category']?.toString());
    final stackLabel = extraCount > 0
        ? (extraCount > 9 ? '9+' : '+$extraCount')
        : null;
    final claimLabel = claimableCount > 0
        ? (claimableCount > 99 ? '99+' : '$claimableCount')
        : null;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0F1420).withValues(alpha: 0.92),
                      border: Border.all(
                        color: style.accent.withValues(alpha: 0.75),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: WebAssetHelper.imageHttpFirst(
                      style.asset,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => ColoredBox(
                        color: const Color(0xFF0F1420),
                        child: Icon(
                          style.icon,
                          color: style.accent,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                if (stackLabel != null)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 16,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B0F18),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white38),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        stackLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ),
                if (claimLabel != null)
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
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        claimLabel,
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
