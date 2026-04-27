import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../services/theft_cooldown_credit_service.dart';
import '../utils/theft_cooldown_confirm_prefs.dart';

/// Confirm + redeem credits to clear vehicle theft cooldown (no full-screen overlay).
Future<void> runTheftCooldownCreditRedeem(
  BuildContext context, {
  required String cooldownActionType,
  required Future<void> Function() onAfterSuccess,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final info = await TheftCooldownCreditService.load(cooldownActionType);
  if (!context.mounted) return;

  if (info == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.theftCooldownRedeemNotAvailable),
        backgroundColor: Colors.orange.shade800,
      ),
    );
    return;
  }

  if (info.itemKey.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.theftCooldownRedeemNotAvailable),
        backgroundColor: Colors.orange.shade800,
      ),
    );
    return;
  }

  /// Still show the dialog with real costs unless the user disabled confirmations;
  /// only block the confirm button when redemption cannot proceed.
  String? redeemBlockReason;
  if (!info.canRedeemNow) {
    redeemBlockReason = info.unavailableReason == 'ACTION_COOLDOWN_NOT_ACTIVE'
        ? l10n.theftCooldownRedeemNoActiveCooldown
        : l10n.theftCooldownRedeemNotAvailable;
  } else if (info.creditBalance < info.creditCost) {
    redeemBlockReason = l10n.theftCooldownRedeemInsufficientCredits;
  }

  final skip = await TheftCooldownConfirmPrefs.skipConfirmDialog;
  if (!context.mounted) return;

  Future<void> doRedeem({bool persistHideConfirm = false}) async {
    final result = await TheftCooldownCreditService.redeem(
      itemKey: info.itemKey,
      cooldownActionType: cooldownActionType,
    );
    if (!context.mounted) return;
    if (!result.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message?.isNotEmpty == true
                ? result.message!
                : l10n.theftCooldownRedeemFailed,
          ),
          backgroundColor: Colors.red.shade800,
        ),
      );
      return;
    }
    if (persistHideConfirm) {
      await TheftCooldownConfirmPrefs.setSkipConfirmDialog(true);
    }
    await onAfterSuccess();
    if (!context.mounted) return;
    await context.read<AuthProvider>().refreshPlayer();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.message?.isNotEmpty == true
              ? result.message!
              : l10n.theftCooldownRedeemSuccess,
        ),
        backgroundColor: Colors.green.shade800,
      ),
    );
  }

  if (skip) {
    if (redeemBlockReason != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(redeemBlockReason),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }
    await doRedeem();
    return;
  }

  var hideNextTime = false;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setLocal) {
          final canConfirm = redeemBlockReason == null;
          return AlertDialog(
            title: Text(l10n.theftCooldownRedeemTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.theftCooldownRedeemMessage(
                    info.creditCost,
                    info.creditBalance,
                  ),
                ),
                if (redeemBlockReason != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    redeemBlockReason,
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: hideNextTime,
                  onChanged: (v) {
                    hideNextTime = v ?? false;
                    setLocal(() {});
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.theftCooldownRedeemDontShowAgain,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: canConfirm
                    ? () => Navigator.of(ctx).pop(true)
                    : null,
                child: Text(
                  l10n.theftCooldownRedeemConfirmAction(info.creditCost),
                ),
              ),
            ],
          );
        },
      );
    },
  );

  if (confirmed != true || !context.mounted) return;
  await doRedeem(persistHideConfirm: hideNextTime);
}
