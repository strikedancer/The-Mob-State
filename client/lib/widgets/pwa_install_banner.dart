import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../utils/pwa_install.dart';

const _dismissPrefKey = 'pwa_install_banner_dismissed';
const _dismissAtPrefKey = 'pwa_install_banner_dismissed_at';
const _dismissTtl = Duration(hours: 24);
const Color _gold = Color(0xFFC0A060);

/// Compact add-to-home-screen prompt for phone/tablet web (not already installed).
class PwaInstallBanner extends StatefulWidget {
  const PwaInstallBanner({super.key, this.forceShow = false});

  /// Settings can force the card even after dismiss.
  final bool forceShow;

  @override
  State<PwaInstallBanner> createState() => _PwaInstallBannerState();
}

class _PwaInstallBannerState extends State<PwaInstallBanner> {
  bool _ready = false;
  bool _dismissed = false;
  bool _busy = false;
  bool _canPrompt = false;

  @override
  void initState() {
    super.initState();
    _load();
    pwaListenForNativePrompt(() {
      if (mounted) setState(() => _canPrompt = true);
    });
  }

  Future<void> _load() async {
    if (!kIsWeb || pwaIsStandalone()) {
      if (mounted) setState(() => _ready = true);
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_dismissPrefKey) == true) {
      await prefs.remove(_dismissPrefKey);
    }
    final dismissedAtMs = prefs.getInt(_dismissAtPrefKey);
    final dismissed = dismissedAtMs != null &&
        DateTime.now().difference(
              DateTime.fromMillisecondsSinceEpoch(dismissedAtMs),
            ) <
            _dismissTtl;
    if (!mounted) return;
    setState(() {
      _dismissed = dismissed;
      _canPrompt = pwaCanNativePrompt();
      _ready = true;
    });
  }

  bool _isPhoneOrTablet(BuildContext context) {
    if (pwaLooksLikeMobileWeb()) return true;
    final size = MediaQuery.sizeOf(context);
    return size.shortestSide < 1100;
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_dismissAtPrefKey, DateTime.now().millisecondsSinceEpoch);
    if (mounted) setState(() => _dismissed = true);
  }

  Future<void> _install(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _busy = true);
    try {
      if (pwaCanNativePrompt() || _canPrompt) {
        final outcome = await pwaPromptNativeInstall();
        if (!mounted) return;
        if (outcome == 'accepted') {
          if (mounted) setState(() => _dismissed = true);
          return;
        }
        if (outcome == 'unavailable') {
          await _showManualHelp(context, l10n);
        }
        return;
      }
      await _showManualHelp(context, l10n);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showManualHelp(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final ios = pwaIsIosSafari();
    return showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1510),
          title: Text(
            ios ? dialogL10n.pwaInstallIosTitle : dialogL10n.pwaInstallManualTitle,
            style: const TextStyle(color: _gold),
          ),
          content: SingleChildScrollView(
            child: Text(
              ios ? dialogL10n.pwaInstallIosBody : dialogL10n.pwaInstallManualBody,
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(dialogL10n.close),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || !kIsWeb || pwaIsStandalone()) {
      return const SizedBox.shrink();
    }
    if (!widget.forceShow && (_dismissed || !_isPhoneOrTablet(context))) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xF21A1510),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _gold.withOpacity(0.45)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              child: Row(
                children: [
                  const Icon(Icons.smartphone, color: _gold, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.pwaInstallTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          l10n.pwaInstallBody,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: _busy ? null : () => _install(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: _gold,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Text(
                      l10n.pwaInstallButton,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                  if (!widget.forceShow)
                    IconButton(
                      tooltip: l10n.pwaInstallLater,
                      onPressed: _dismiss,
                      icon: const Icon(Icons.close, color: Colors.white54, size: 18),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Settings / manual entry: open the native install sheet or iOS/manual steps.
Future<void> startPwaHomeScreenInstall(BuildContext context) async {
  if (pwaIsStandalone()) return;
  if (pwaCanNativePrompt()) {
    final outcome = await pwaPromptNativeInstall();
    if (outcome != 'unavailable' || !context.mounted) return;
  }
  if (!context.mounted) return;
  final ios = pwaIsIosSafari();
  await showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) {
      final dialogL10n = AppLocalizations.of(ctx)!;
      return AlertDialog(
        backgroundColor: const Color(0xFF1A1510),
        title: Text(
          ios ? dialogL10n.pwaInstallIosTitle : dialogL10n.pwaInstallManualTitle,
          style: const TextStyle(color: _gold),
        ),
        content: SingleChildScrollView(
          child: Text(
            ios ? dialogL10n.pwaInstallIosBody : dialogL10n.pwaInstallManualBody,
            style: const TextStyle(color: Colors.white70, height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(dialogL10n.close),
          ),
        ],
      );
    },
  );
}
