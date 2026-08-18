import 'package:flutter/material.dart';
import 'responsive_modal.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';

const Color _resultGold = Color(0xFFFFB347);
const Color _resultPanelDark = Color(0xFF1B1212);
const Color _resultPanelLight = Color(0xFF2A1A1A);
const Color _resultMoney = Color(0xFF86EFAC);

class CrimeResultOverlay extends StatelessWidget {
  final String crimeName;
  final int reward;
  final int xpGained;
  final VoidCallback onContinue;
  final bool embedded;

  const CrimeResultOverlay({
    super.key,
    required this.crimeName,
    required this.reward,
    required this.xpGained,
    required this.onContinue,
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
                      Icons.emoji_events,
                      size: compactWidth ? 30 : 34,
                      color: _resultGold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.crimeOutcomeSuccess,
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
                    crimeName,
                    style: TextStyle(
                      fontSize: compactWidth ? 15 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.92),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 22),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: compactWidth ? double.infinity : 220,
                        child: _ResultStat(
                          icon: Icons.payments_outlined,
                          label: l10n.crimeResultMoneyLabel,
                          value: '+${formatCurrency(reward)}',
                          valueColor: _resultMoney,
                        ),
                      ),
                      SizedBox(
                        width: compactWidth ? double.infinity : 220,
                        child: _ResultStat(
                          icon: Icons.auto_awesome,
                          label: l10n.crimeResultXpLabel,
                          value: l10n.jobXpRewardShort(xpGained.toString()),
                          valueColor: _resultGold,
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
