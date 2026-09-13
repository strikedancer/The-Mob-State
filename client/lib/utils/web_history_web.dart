// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;

/// Replace the current URL without adding history (OAuth tokens must not stay visible).
void replaceBrowserPath(String path) {
  try {
    var normalized = path.trim();
    if (normalized.isEmpty) {
      normalized = '/';
    }
    if (!normalized.startsWith('/')) {
      normalized = '/$normalized';
    }
    final origin = html.window.location.origin;
    html.window.history.replaceState(
      html.window.history.state,
      '',
      '$origin$normalized',
    );
  } catch (_) {}
}
