import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';
import '../utils/top_right_notification.dart';

const _dismissPrefKey = 'push_enable_prompt_dismissed';
const Color _gold = Color(0xFFC0A060);

/// After login: ask once to enable push. Never blocks gameplay if dismissed.
Future<void> maybeShowPushEnablePrompt(BuildContext context) async {
  if (!context.mounted) return;

  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_dismissPrefKey) == true) return;

  NotificationSettings settings;
  try {
    settings = await NotificationService().getNotificationSettings();
  } catch (_) {
    return;
  }

  final alreadyOn =
      settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional;
  if (alreadyOn || settings.authorizationStatus == AuthorizationStatus.denied) {
    return;
  }

  if (!context.mounted) return;
  final accepted = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx)!;
      return SafeArea(
        child: AlertDialog(
        backgroundColor: const Color(0xFF1A1510),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _gold.withOpacity(0.4)),
        ),
        title: Text(
          l10n.pushEnableTitle,
          style: const TextStyle(color: _gold, fontWeight: FontWeight.w800),
        ),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420, maxHeight: 280),
          child: SingleChildScrollView(
            child: Text(
              l10n.pushEnableBody,
              style: const TextStyle(color: Colors.white70, height: 1.45),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              l10n.pushEnableLater,
              style: const TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _gold,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.pushEnableButton),
          ),
        ],
      ),
      );
    },
  );

  if (accepted != true) {
    await prefs.setBool(_dismissPrefKey, true);
    return;
  }

  if (!context.mounted) return;
  final l10n = AppLocalizations.of(context)!;
  try {
    await NotificationService().initialize();
    await NotificationService().registerCurrentToken();
    if (!context.mounted) return;
    final after = await NotificationService().getNotificationSettings();
    final on =
        after.authorizationStatus == AuthorizationStatus.authorized ||
        after.authorizationStatus == AuthorizationStatus.provisional;
    await prefs.setBool(_dismissPrefKey, true);
    if (!context.mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(
          on ? l10n.settingsPushEnabledToast : l10n.settingsPushDisabledInSystem,
        ),
        backgroundColor: on ? Colors.green : Colors.orange,
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    showTopRightFromSnackBar(
      context,
      SnackBar(
        content: Text(l10n.settingsEnablePushFailed(e.toString())),
        backgroundColor: Colors.red,
      ),
    );
  }
}
