import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../screens/prostitution_leaderboard_screen.dart';
import '../../screens/prostitution_rivalry_screen.dart';
import 'prostitution_section_header.dart';

/// Social launcher: rivalry + leaderboard without nested TabBar chaos.
class ProstitutionSocialTab extends StatefulWidget {
  const ProstitutionSocialTab({super.key});

  @override
  State<ProstitutionSocialTab> createState() => _ProstitutionSocialTabState();
}

class _ProstitutionSocialTabState extends State<ProstitutionSocialTab> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SegmentedButton<int>(
            segments: [
              ButtonSegment(
                value: 0,
                label: Text(l10n.prostitutionRivalryButton),
                icon: const Icon(Icons.sports_kabaddi, size: 18),
              ),
              ButtonSegment(
                value: 1,
                label: Text(l10n.prostitutionLeaderboardButton),
                icon: const Icon(Icons.leaderboard, size: 18),
              ),
            ],
            selected: {_segment},
            onSelectionChanged: (s) => setState(() => _segment = s.first),
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.black;
                }
                return Colors.grey.shade300;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return kProstitutionGold;
                }
                return Colors.grey.shade900;
              }),
            ),
          ),
        ),
        Expanded(
          child: _segment == 0
              ? const ProstitutionRivalryScreen()
              : const ProstitutionLeaderboardScreen(),
        ),
      ],
    );
  }
}
