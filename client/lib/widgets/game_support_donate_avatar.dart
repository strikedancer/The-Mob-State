import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../theme/dashboard_chrome.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

const gameSupportDonateAsset = 'assets/images/ui/game_support_donate_avatar.png';
const gameSupportDonateMinEur = 1.0;
const gameSupportDonateMaxEur = 250.0;
const _suggestedAmounts = ['2.50', '5.00', '10.00', '25.00'];

/// Clash-style circular donate avatar, mirrored from the live-event rail
/// but anchored bottom-left. Opens a one-time (non-subscription) Mollie checkout.
class GameSupportDonateAvatar extends StatefulWidget {
  const GameSupportDonateAvatar({
    super.key,
    this.bottomOffset = 16,
    this.leftOffset = 8,
  });

  final double bottomOffset;
  final double leftOffset;

  @override
  State<GameSupportDonateAvatar> createState() =>
      _GameSupportDonateAvatarState();
}

class _GameSupportDonateAvatarState extends State<GameSupportDonateAvatar>
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
    final l10n = AppLocalizations.of(context)!;
    final safeBottom = MediaQuery.paddingOf(context).bottom;

    return Positioned(
      left: widget.leftOffset,
      bottom: widget.bottomOffset + safeBottom,
      child: Tooltip(
        message: l10n.gameSupportDonateTooltip,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, child) {
            final glow = 0.35 + (_pulse.value * 0.35);
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => showGameSupportDonateDialog(context),
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
                              color: dashboardGold
                                  .withValues(alpha: 0.55 + glow * 0.35),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: dashboardGold.withValues(alpha: glow * 0.55),
                                blurRadius: 10,
                                spreadRadius: 0.5,
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: WebAssetHelper.imageHttpFirst(
                            gameSupportDonateAsset,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) =>
                                const ColoredBox(
                              color: Color(0xFF0F1420),
                              child: Icon(
                                Icons.favorite,
                                color: dashboardGold,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 4,
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
                            border: Border.all(color: dashboardGold.withValues(alpha: 0.7)),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            '€',
                            style: TextStyle(
                              color: dashboardGold,
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
      ),
    );
  }
}

Future<void> showGameSupportDonateDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => const _GameSupportDonateDialog(),
  );
}

class _GameSupportDonateDialog extends StatefulWidget {
  const _GameSupportDonateDialog();

  @override
  State<_GameSupportDonateDialog> createState() =>
      _GameSupportDonateDialogState();
}

class _GameSupportDonateDialogState extends State<_GameSupportDonateDialog> {
  final _controller = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? _parsedAmount() {
    final cleaned = _controller.text
        .trim()
        .replaceAll('€', '')
        .replaceAll(' ', '')
        .replaceAll(',', '.');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  String? _validate(AppLocalizations l10n) {
    final amount = _parsedAmount();
    if (amount == null) {
      return l10n.gameSupportDonateInvalidAmount;
    }
    if (amount < gameSupportDonateMinEur || amount > gameSupportDonateMaxEur) {
      return l10n.gameSupportDonateInvalidAmount;
    }
    return null;
  }

  String _amountValue() {
    final amount = _parsedAmount() ?? 0;
    return amount.toStringAsFixed(2);
  }

  Future<void> _openCheckoutUrl(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);
    final opened = kIsWeb
        ? await launchUrl(uri, webOnlyWindowName: '_self')
        : await launchUrl(uri, mode: LaunchMode.platformDefault);
    if (!opened) {
      throw Exception('checkout_launch_failed');
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final invalid = _validate(l10n);
    if (invalid != null) {
      setState(() => _error = invalid);
      return;
    }

    setState(() {
      _error = null;
      _submitting = true;
    });

    try {
      final response = await AuthService().apiClient.post(
        '/subscriptions/checkout/game-support-donate',
        {'amountEur': _amountValue()},
      );
      if (!mounted) return;
      if (response.statusCode != 200) {
        throw Exception('checkout_failed');
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final checkoutUrl = data['url'] as String?;
      if (checkoutUrl == null || checkoutUrl.isEmpty) {
        throw Exception('checkout_missing_url');
      }
      await _openCheckoutUrl(checkoutUrl);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = l10n.gameSupportDonateCheckoutFailed;
      });
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.gameSupportDonateCheckoutFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1010),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: dashboardGold, width: 1.2),
      ),
      title: Row(
        children: [
          ClipOval(
            child: WebAssetHelper.imageHttpFirst(
              gameSupportDonateAsset,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.favorite, color: dashboardGold),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.gameSupportDonateTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.gameSupportDonateBody,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.82),
                fontSize: 13,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.gameSupportDonateOneTimeNote,
              style: TextStyle(
                color: dashboardGold.withValues(alpha: 0.9),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _controller,
              enabled: !_submitting,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: l10n.gameSupportDonateAmountLabel,
                hintText: l10n.gameSupportDonateAmountHint,
                prefixText: '€ ',
                prefixStyle: const TextStyle(color: dashboardGold),
                labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35)),
                errorText: _error,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: dashboardGold.withValues(alpha: 0.45)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: dashboardGold, width: 1.4),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
              onSubmitted: (_) {
                if (!_submitting) {
                  _submit();
                }
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _suggestedAmounts.map((amount) {
                return ActionChip(
                  label: Text('€$amount'),
                  onPressed: _submitting
                      ? null
                      : () {
                          _controller.text = amount;
                          setState(() => _error = null);
                        },
                  backgroundColor: const Color(0xFF2A1818),
                  side: BorderSide(color: dashboardGold.withValues(alpha: 0.45)),
                  labelStyle: const TextStyle(
                    color: dashboardGold,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(),
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          ),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: dashboardGold,
            foregroundColor: const Color(0xFF1A1010),
          ),
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.gameSupportDonateButton),
        ),
      ],
    );
  }
}
