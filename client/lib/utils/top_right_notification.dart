import 'dart:async';

import 'package:flutter/material.dart';

OverlayEntry? _topRightNotificationEntry;
Timer? _topRightNotificationTimer;

enum _NotificationKind { success, warning, error, info }

_NotificationKind _inferKind(SnackBar snackBar) {
  final color = snackBar.backgroundColor;
  final text = _extractText(snackBar.content).toLowerCase();

  if (text.contains('cooldown') || text.contains('wacht') || text.contains('wait')) {
    return _NotificationKind.warning;
  }

  if (text.contains('error') ||
      text.contains('mislukt') ||
      text.contains('failed') ||
      text.contains('not enough') ||
      text.contains('onvoldoende') ||
      text.contains('❌')) {
    return _NotificationKind.error;
  }

  if (text.contains('gelukt') ||
      text.contains('success') ||
      text.contains('vrij') ||
      text.contains('free') ||
      text.contains('✅') ||
      text.contains('🎉')) {
    return _NotificationKind.success;
  }

  if (color != null) {
    if (color.red > color.green + 25) {
      return _NotificationKind.error;
    }
    if (color.green > color.red + 25) {
      return _NotificationKind.success;
    }
    if (color.red > 180 && color.green > 120) {
      return _NotificationKind.warning;
    }
  }

  return _NotificationKind.info;
}

String _extractText(Widget widget) {
  if (widget is Text) {
    return widget.data ?? widget.textSpan?.toPlainText() ?? '';
  }
  if (widget is RichText) {
    return widget.text.toPlainText();
  }
  return '';
}

Color _backgroundFor(_NotificationKind kind) {
  switch (kind) {
    case _NotificationKind.success:
      return const Color(0xFF14532D);
    case _NotificationKind.warning:
      return const Color(0xFF92400E);
    case _NotificationKind.error:
      return const Color(0xFF991B1B);
    case _NotificationKind.info:
      return const Color(0xFF1E3A8A);
  }
}

Color _accentFor(_NotificationKind kind) {
  switch (kind) {
    case _NotificationKind.success:
      return const Color(0xFF34D399);
    case _NotificationKind.warning:
      return const Color(0xFFFBBF24);
    case _NotificationKind.error:
      return const Color(0xFFF87171);
    case _NotificationKind.info:
      return const Color(0xFF60A5FA);
  }
}

IconData _iconFor(_NotificationKind kind) {
  switch (kind) {
    case _NotificationKind.success:
      return Icons.check_circle_rounded;
    case _NotificationKind.warning:
      return Icons.hourglass_top_rounded;
    case _NotificationKind.error:
      return Icons.error_rounded;
    case _NotificationKind.info:
      return Icons.info_rounded;
  }
}

void showTopRightFromSnackBar(BuildContext context, SnackBar snackBar) {
  final overlay = Overlay.of(context, rootOverlay: true);
  if (overlay == null) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    return;
  }

  _topRightNotificationTimer?.cancel();
  _topRightNotificationEntry?.remove();

  final kind = _inferKind(snackBar);
  final Color backgroundColor = snackBar.backgroundColor ?? _backgroundFor(kind);
  final Color accentColor = _accentFor(kind);
  final IconData icon = _iconFor(kind);
  final Duration duration = snackBar.duration;

  final entry = OverlayEntry(
    builder: (overlayContext) {
      final media = MediaQuery.of(overlayContext);
      final toastWidth = media.size.width < 480 ? media.size.width - 24 : 360.0;

      return Positioned(
        top: 14,
        right: 12,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: toastWidth,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withValues(alpha: 0.45), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.32),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: accentColor, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: FontWeight.w500,
                      ),
                      child: snackBar.content,
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
  _topRightNotificationEntry = entry;
  _topRightNotificationTimer = Timer(duration, () {
    _topRightNotificationEntry?.remove();
    _topRightNotificationEntry = null;
  });
}
