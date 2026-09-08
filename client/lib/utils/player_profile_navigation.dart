import 'package:flutter/material.dart';

import '../screens/player_profile_screen.dart';

/// Opens a public profile inside the dashboard content pane on web.
/// Falls back to a route only when the dashboard shell is not bound.
class PlayerProfileNavigation {
  static void Function(int playerId, String username)? _openInShell;

  static void bindShell(void Function(int playerId, String username) open) {
    _openInShell = open;
  }

  static void unbindShell() {
    _openInShell = null;
  }

  static void open(BuildContext context, int playerId, String username) {
    if (playerId <= 0) return;
    final name = username.trim().isEmpty ? username : username.trim();
    final shellOpen = _openInShell;
    if (shellOpen != null) {
      shellOpen(playerId, name);
      _popOverlayRoutes(context);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayerProfileScreen(
          playerId: playerId,
          username: name,
        ),
      ),
    );
  }

  static void _popOverlayRoutes(BuildContext context) {
    final navigator = Navigator.maybeOf(context);
    if (navigator == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      navigator.popUntil((route) {
        if (route.settings.name == '/dashboard') return true;
        if (route.isFirst) return true;
        return route is! PopupRoute;
      });
    });
  }
}
