import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

/// Privacy policy (all copy from ARB).
class LegalPrivacyScreen extends StatefulWidget {
  const LegalPrivacyScreen({super.key});

  @override
  State<LegalPrivacyScreen> createState() => _LegalPrivacyScreenState();
}

class _LegalPrivacyScreenState extends State<LegalPrivacyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LocaleProvider>().initGuestLocale();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    Widget section(String title, String body) => Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: cs.primary, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(body, style: const TextStyle(color: Colors.white70, height: 1.45)),
            ],
          ),
        );

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(l10n.legalPrivacyTitle),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.legalPrivacyLastUpdated, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 16),
              Text(l10n.legalPrivacyIntro, style: const TextStyle(color: Colors.white70, height: 1.45)),
              const SizedBox(height: 24),
              section(l10n.legalPrivacySection01Title, l10n.legalPrivacySection01Body),
              section(l10n.legalPrivacySection02Title, l10n.legalPrivacySection02Body),
              section(l10n.legalPrivacySection03Title, l10n.legalPrivacySection03Body),
              section(l10n.legalPrivacySection04Title, l10n.legalPrivacySection04Body),
              section(l10n.legalPrivacySection05Title, l10n.legalPrivacySection05Body),
              section(l10n.legalPrivacySection06Title, l10n.legalPrivacySection06Body),
              section(l10n.legalPrivacySection07Title, l10n.legalPrivacySection07Body),
              section(l10n.legalPrivacySection08Title, l10n.legalPrivacySection08Body),
              section(l10n.legalPrivacySection09Title, l10n.legalPrivacySection09Body),
              section(l10n.legalPrivacySection10Title, l10n.legalPrivacySection10Body),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
