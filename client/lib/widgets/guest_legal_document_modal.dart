import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'legal_marketing_document_body.dart';

/// Which marketing legal document to show in a guest footer modal.
enum GuestLegalDocument { privacy, terms, digitalGoods }

Future<void> showGuestLegalDocumentModal(
  BuildContext context,
  GuestLegalDocument doc,
) async {
  final localeProvider = context.read<LocaleProvider>();
  await localeProvider.initGuestLocale();

  if (!context.mounted) return;

  final l10n = AppLocalizations.of(context)!;
  final String title;
  final Widget Function(BuildContext) buildColumn;
  switch (doc) {
    case GuestLegalDocument.privacy:
      title = l10n.legalPrivacyTitle;
      buildColumn = buildLegalPrivacyDocumentColumn;
      break;
    case GuestLegalDocument.terms:
      title = l10n.legalTermsTitle;
      buildColumn = buildLegalTermsDocumentColumn;
      break;
    case GuestLegalDocument.digitalGoods:
      title = l10n.legalDigitalGoodsTitle;
      buildColumn = buildLegalDigitalGoodsDocumentColumn;
      break;
  }

  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) {
      final size = MediaQuery.sizeOf(ctx);
      final maxW = math.min(720.0, size.width - 24);
      final maxH = size.height * 0.88;
      return Dialog(
        backgroundColor: const Color(0xFF121212),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.amber.shade800.withOpacity(0.35)),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: MaterialLocalizations.of(ctx).closeButtonTooltip,
                      icon: const Icon(Icons.close, color: Color(0xFFC0A060)),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white24),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: buildColumn(ctx),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
