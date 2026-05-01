import 'package:flutter/material.dart';
import 'responsive_modal.dart';
import '../l10n/app_localizations.dart';

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

  String _formatNumber(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ResponsiveModalLayout(
      embedded: embedded,
      phoneMaxWidth: 520,
      tabletMaxWidth: 620,
      desktopMaxWidth: 720,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactWidth = constraints.maxWidth < 430;

          return Container(
            padding: EdgeInsets.all(compactWidth ? 18 : 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF9F4D6), Colors.white],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: compactWidth ? 40 : 48,
                    color: const Color(0xFFFFC107),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    crimeName,
                    style: TextStyle(
                      fontSize: compactWidth ? 21 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      SizedBox(
                        width: compactWidth ? double.infinity : 220,
                        child: _ResultStat(
                          icon: Icons.euro,
                          label: l10n.crimeResultMoneyLabel,
                          value: '+€${_formatNumber(reward)}',
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: compactWidth ? double.infinity : 220,
                        child: _ResultStat(
                          icon: Icons.auto_awesome,
                          label: l10n.crimeResultXpLabel,
                          value: l10n.jobXpRewardShort(xpGained.toString()),
                          color: Colors.blue,
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
                        minimumSize: Size.fromHeight(compactWidth ? 48 : 54),
                      ),
                      child: Text(l10n.continueAction),
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
  final Color color;

  const _ResultStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
