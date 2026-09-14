import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';

const Color _gold = Color(0xFFC0A060);
const Color _panel = Color(0xFF140E0C);
const kDiscordPromptArtCacheBust = '20260914b';

Future<void> maybeShowDiscordLinkPrompt(BuildContext context) async {
  if (!kIsWeb || !context.mounted) return;

  final auth = AuthService();
  final status = await auth.discordPromptStatus();
  if (!status.show || status.rewardCash <= 0 || !context.mounted) return;

  await auth.discordPromptSeen();
  if (!context.mounted) return;

  final amount = formatCurrency(status.rewardCash);
  await showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    builder: (ctx) {
      final l10n = AppLocalizations.of(ctx)!;
      final maxHeight = MediaQuery.sizeOf(ctx).height * 0.9;
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 440, maxHeight: maxHeight),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _panel,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _gold.withOpacity(0.55), width: 1.4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x88000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          WebAssetHelper.imageHttpFirst(
                            'assets/images/ui/discord_link_prompt.png',
                            fit: BoxFit.cover,
                            cacheBust: kDiscordPromptArtCacheBust,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFF1B1410),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.forum,
                                color: _gold,
                                size: 64,
                              ),
                            ),
                          ),
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x00000000),
                                  Color(0xAA140E0C),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: IconButton(
                              tooltip: MaterialLocalizations.of(ctx).closeButtonTooltip,
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon: const Icon(Icons.close, color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.discordPromptTitle,
                            style: const TextStyle(
                              color: _gold,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.discordPromptBody(amount),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14.5,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _gold,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            onPressed: () async {
                              final url = await auth.discordLinkStartUrl();
                              if (!ctx.mounted) return;
                              if (url == null) {
                                Navigator.of(ctx).pop();
                                return;
                              }
                              await launchUrl(
                                Uri.parse(url),
                                webOnlyWindowName: '_self',
                              );
                            },
                            child: Text(
                              l10n.discordPromptLink(amount),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextButton(
                            onPressed: () async {
                              await auth.discordPromptDecline();
                              if (ctx.mounted) Navigator.of(ctx).pop();
                            },
                            child: Text(
                              l10n.discordPromptNoAccount,
                              style: const TextStyle(color: Colors.white54),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
