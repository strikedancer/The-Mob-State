import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/supported_languages.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

const Color _guestFooterGold = Color(0xFFC0A060);

/// Sticky legal footer (privacy, digital goods, guest language, copyright) for
/// marketing and auth shells — same copy as [LandingScreen] had inline.
class GuestLegalFooter extends StatelessWidget {
  const GuestLegalFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final year = DateTime.now().year;
    return Material(
      color: Colors.black.withOpacity(0.88),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.amber.shade800.withOpacity(0.45)),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 4,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed('/privacy'),
                  child: Text(
                    l10n.landingFooterPrivacy,
                    style: const TextStyle(
                      color: _guestFooterGold,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed('/terms'),
                  child: Text(
                    l10n.landingFooterTerms,
                    style: const TextStyle(
                      color: _guestFooterGold,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/digital-goods'),
                  child: Text(
                    l10n.landingFooterDigitalGoods,
                    style: const TextStyle(
                      color: _guestFooterGold,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                  onPressed: () => showGuestLanguageDialog(context),
                  icon: const Icon(
                    Icons.language,
                    color: _guestFooterGold,
                    size: 18,
                  ),
                  label: Text(
                    l10n.landingFooterLanguage,
                    style: const TextStyle(
                      color: _guestFooterGold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.landingCopyright(year),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showGuestLanguageDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final localeProvider = context.read<LocaleProvider>();
  final current = localeProvider.locale.languageCode;

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: const Color(0xFF1a1a2e),
      title: Text(
        l10n.landingFooterLanguage,
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final code in SupportedLanguages.codes)
              ListTile(
                leading: Text(
                  SupportedLanguages.flagFor(code) ?? '🌐',
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  SupportedLanguages.labelFor(code),
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: current == code
                    ? const Icon(Icons.check, color: Colors.green)
                    : null,
                onTap: () async {
                  await localeProvider.persistGuestLocale(code);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(
            l10n.cancel,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    ),
  );
}
