import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';
import 'responsive_modal.dart';

const Color _resultGold = Color(0xFFD4A24D);
const Color _resultPanelDark = Color(0xFF1B1212);
const Color _resultPanelLight = Color(0xFF2A1A1A);
const Color _resultMoney = Color(0xFF86EFAC);

class SmugglingResultOverlay extends StatelessWidget {
  final String title;
  final String subtitle;
  final int? fee;
  final int? etaMinutes;
  final int? xpGained;
  final double? riskPercent;
  final String? confiscationMessage;
  final VoidCallback onContinue;
  final bool embedded;

  const SmugglingResultOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onContinue,
    this.fee,
    this.etaMinutes,
    this.xpGained,
    this.riskPercent,
    this.confiscationMessage,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ResponsiveModalLayout(
      embedded: embedded,
      phoneMaxWidth: 520,
      tabletMaxWidth: 620,
      desktopMaxWidth: 720,
      cardColor: _resultPanelDark,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactWidth = constraints.maxWidth < 430;

          return Container(
            padding: EdgeInsets.all(compactWidth ? 18 : 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_resultPanelLight, _resultPanelDark],
              ),
              border: Border.all(
                color: _resultGold.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: compactWidth ? 56 : 64,
                    height: compactWidth ? 56 : 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _resultGold.withOpacity(0.16),
                      border: Border.all(color: _resultGold, width: 1.4),
                    ),
                    child: Icon(
                      Icons.local_shipping,
                      size: compactWidth ? 30 : 34,
                      color: _resultGold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: compactWidth ? 20 : 22,
                      fontWeight: FontWeight.w800,
                      color: _resultGold,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: compactWidth ? 15 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.92),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (confiscationMessage != null &&
                      confiscationMessage!.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      confiscationMessage!,
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      if (fee != null)
                        SizedBox(
                          width: compactWidth ? double.infinity : 200,
                          child: _ResultStat(
                            icon: Icons.payments_outlined,
                            label: l10n.smugglingResultFeeLabel,
                            value: formatCurrency(fee!),
                            valueColor: _resultMoney,
                          ),
                        ),
                      if (etaMinutes != null)
                        SizedBox(
                          width: compactWidth ? double.infinity : 200,
                          child: _ResultStat(
                            icon: Icons.schedule,
                            label: l10n.smugglingResultEtaLabel,
                            value: '${etaMinutes}m',
                            valueColor: _resultGold,
                          ),
                        ),
                      if (xpGained != null && xpGained! > 0)
                        SizedBox(
                          width: compactWidth ? double.infinity : 200,
                          child: _ResultStat(
                            icon: Icons.auto_awesome,
                            label: l10n.smugglingResultXpLabel,
                            value: '+$xpGained',
                            valueColor: _resultGold,
                          ),
                        ),
                      if (riskPercent != null)
                        SizedBox(
                          width: compactWidth ? double.infinity : 200,
                          child: _ResultStat(
                            icon: Icons.warning_amber_rounded,
                            label: l10n.smugglingResultRiskLabel,
                            value:
                                '${riskPercent!.toStringAsFixed(1)}%',
                            valueColor: Colors.orangeAccent,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _resultGold,
                        foregroundColor: const Color(0xFF1B1212),
                        disabledBackgroundColor: _resultGold.withOpacity(0.4),
                        elevation: 0,
                        minimumSize: Size.fromHeight(compactWidth ? 48 : 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        l10n.continueAction,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ResultStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _resultGold.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          Icon(icon, color: valueColor),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
