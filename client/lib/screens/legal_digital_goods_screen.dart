import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

/// Purchase of digital goods policy (all copy from ARB).
class LegalDigitalGoodsScreen extends StatefulWidget {
  const LegalDigitalGoodsScreen({super.key});

  @override
  State<LegalDigitalGoodsScreen> createState() => _LegalDigitalGoodsScreenState();
}

class _LegalDigitalGoodsScreenState extends State<LegalDigitalGoodsScreen> {
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
        title: Text(l10n.legalDigitalGoodsTitle),
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
              Text(l10n.legalDigitalGoodsLastUpdated, style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 16),
              Text(l10n.legalDigitalGoodsIntro, style: const TextStyle(color: Colors.white70, height: 1.45)),
              const SizedBox(height: 24),
              section(l10n.legalDigitalGoodsSection01Title, l10n.legalDigitalGoodsSection01Body),
              section(l10n.legalDigitalGoodsSection02Title, l10n.legalDigitalGoodsSection02Body),
              section(l10n.legalDigitalGoodsSection03Title, l10n.legalDigitalGoodsSection03Body),
              section(l10n.legalDigitalGoodsSection04Title, l10n.legalDigitalGoodsSection04Body),
              section(l10n.legalDigitalGoodsSection05Title, l10n.legalDigitalGoodsSection05Body),
              section(l10n.legalDigitalGoodsSection06Title, l10n.legalDigitalGoodsSection06Body),
              section(l10n.legalDigitalGoodsSection07Title, l10n.legalDigitalGoodsSection07Body),
              section(l10n.legalDigitalGoodsSection08Title, l10n.legalDigitalGoodsSection08Body),
              section(l10n.legalDigitalGoodsSection09Title, l10n.legalDigitalGoodsSection09Body),
              section(l10n.legalDigitalGoodsSection10Title, l10n.legalDigitalGoodsSection10Body),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
