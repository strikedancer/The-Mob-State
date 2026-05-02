import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../widgets/legal_marketing_document_body.dart';

/// Purchase of digital goods policy (all copy from ARB).
class LegalDigitalGoodsScreen extends StatefulWidget {
  const LegalDigitalGoodsScreen({super.key});

  @override
  State<LegalDigitalGoodsScreen> createState() =>
      _LegalDigitalGoodsScreenState();
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
          child: buildLegalDigitalGoodsDocumentColumn(context),
        ),
      ),
    );
  }
}
