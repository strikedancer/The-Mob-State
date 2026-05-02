import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

/// Terms of Service (all copy from ARB).
class LegalTermsScreen extends StatefulWidget {
  const LegalTermsScreen({super.key});

  @override
  State<LegalTermsScreen> createState() => _LegalTermsScreenState();
}

class _LegalTermsScreenState extends State<LegalTermsScreen> {
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
        title: Text(l10n.legalTermsTitle),
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
              Text(l10n.legalTermsLastUpdated, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 16),
              Text(l10n.legalTermsIntro, style: const TextStyle(color: Colors.white70, height: 1.45)),
              const SizedBox(height: 24),
              section(l10n.legalTermsSection01Title, l10n.legalTermsSection01Body),
              section(l10n.legalTermsSection02Title, l10n.legalTermsSection02Body),
              section(l10n.legalTermsSection03Title, l10n.legalTermsSection03Body),
              section(l10n.legalTermsSection04Title, l10n.legalTermsSection04Body),
              section(l10n.legalTermsSection05Title, l10n.legalTermsSection05Body),
              section(l10n.legalTermsSection06Title, l10n.legalTermsSection06Body),
              section(l10n.legalTermsSection07Title, l10n.legalTermsSection07Body),
              section(l10n.legalTermsSection08Title, l10n.legalTermsSection08Body),
              section(l10n.legalTermsSection09Title, l10n.legalTermsSection09Body),
              section(l10n.legalTermsSection10Title, l10n.legalTermsSection10Body),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
