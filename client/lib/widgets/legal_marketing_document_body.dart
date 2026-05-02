import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Shared scrollable column for privacy / terms / digital-goods (ARB-only).
/// Used by full-screen legal routes and [showGuestLegalDocumentModal].
Widget legalMarketingSection(
  BuildContext context, {
  required String title,
  required String body,
}) {
  final cs = Theme.of(context).colorScheme;
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: cs.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: const TextStyle(color: Colors.white70, height: 1.45),
        ),
      ],
    ),
  );
}

Widget buildLegalPrivacyDocumentColumn(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.legalPrivacyLastUpdated,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
      const SizedBox(height: 16),
      Text(
        l10n.legalPrivacyIntro,
        style: const TextStyle(color: Colors.white70, height: 1.45),
      ),
      const SizedBox(height: 24),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection01Title,
          body: l10n.legalPrivacySection01Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection02Title,
          body: l10n.legalPrivacySection02Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection03Title,
          body: l10n.legalPrivacySection03Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection04Title,
          body: l10n.legalPrivacySection04Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection05Title,
          body: l10n.legalPrivacySection05Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection06Title,
          body: l10n.legalPrivacySection06Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection07Title,
          body: l10n.legalPrivacySection07Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection08Title,
          body: l10n.legalPrivacySection08Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection09Title,
          body: l10n.legalPrivacySection09Body),
      legalMarketingSection(context,
          title: l10n.legalPrivacySection10Title,
          body: l10n.legalPrivacySection10Body),
      const SizedBox(height: 32),
    ],
  );
}

Widget buildLegalTermsDocumentColumn(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.legalTermsLastUpdated,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
      const SizedBox(height: 16),
      Text(
        l10n.legalTermsIntro,
        style: const TextStyle(color: Colors.white70, height: 1.45),
      ),
      const SizedBox(height: 24),
      legalMarketingSection(context,
          title: l10n.legalTermsSection01Title,
          body: l10n.legalTermsSection01Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection02Title,
          body: l10n.legalTermsSection02Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection03Title,
          body: l10n.legalTermsSection03Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection04Title,
          body: l10n.legalTermsSection04Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection05Title,
          body: l10n.legalTermsSection05Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection06Title,
          body: l10n.legalTermsSection06Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection07Title,
          body: l10n.legalTermsSection07Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection08Title,
          body: l10n.legalTermsSection08Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection09Title,
          body: l10n.legalTermsSection09Body),
      legalMarketingSection(context,
          title: l10n.legalTermsSection10Title,
          body: l10n.legalTermsSection10Body),
      const SizedBox(height: 32),
    ],
  );
}

Widget buildLegalDigitalGoodsDocumentColumn(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        l10n.legalDigitalGoodsLastUpdated,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
      const SizedBox(height: 16),
      Text(
        l10n.legalDigitalGoodsIntro,
        style: const TextStyle(color: Colors.white70, height: 1.45),
      ),
      const SizedBox(height: 24),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection01Title,
          body: l10n.legalDigitalGoodsSection01Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection02Title,
          body: l10n.legalDigitalGoodsSection02Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection03Title,
          body: l10n.legalDigitalGoodsSection03Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection04Title,
          body: l10n.legalDigitalGoodsSection04Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection05Title,
          body: l10n.legalDigitalGoodsSection05Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection06Title,
          body: l10n.legalDigitalGoodsSection06Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection07Title,
          body: l10n.legalDigitalGoodsSection07Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection08Title,
          body: l10n.legalDigitalGoodsSection08Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection09Title,
          body: l10n.legalDigitalGoodsSection09Body),
      legalMarketingSection(context,
          title: l10n.legalDigitalGoodsSection10Title,
          body: l10n.legalDigitalGoodsSection10Body),
      const SizedBox(height: 32),
    ],
  );
}
