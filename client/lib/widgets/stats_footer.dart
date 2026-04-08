import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// Sticky footer showing player stats at the bottom of the screen
class StatsFooter extends StatelessWidget {
  const StatsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final player = authProvider.currentPlayer;

        if (player == null) {
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Colors.amber[600]!, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                // Top row: Progress bars (compact, small)
                Row(
                  children: [
                    // Health bar
                    Expanded(
                      flex: 3,
                      child: _ProgressBar(
                        label: '❤️ Health',
                        value: player.health.toDouble(),
                        max: 100.0,
                        color: player.health > 50 ? Colors.red[400]! : Colors.red[700]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Wanted level bar
                    Expanded(
                      flex: 2,
                      child: _ProgressBar(
                        label: '🚔 Wanted',
                        value: (player.wantedLevel ?? 0).toDouble(),
                        max: 5.0,
                        color: (player.wantedLevel ?? 0) > 0 ? Colors.orange : Colors.grey[600]!,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // FBI Heat bar
                    Expanded(
                      flex: 2,
                      child: _ProgressBar(
                        label: '🛡️ FBI',
                        value: (player.fbiHeat ?? 0).toDouble(),
                        max: 100.0,
                        color: (player.fbiHeat ?? 0) > 0 ? Colors.deepPurple : Colors.grey[600]!,
                      ),
                    ),
                  ],
                ),
                // Bottom row: Compact stats grid
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CompactStat(
                      icon: '💰',
                      label: 'Money',
                      value: '€${_formatNumber(player.money)}',
                      color: Colors.green,
                    ),
                    _CompactStat(
                      icon: '⭐',
                      label: 'Rank',
                      value: 'R${player.rank}',
                      color: Colors.amber,
                    ),
                    _CompactStat(
                      icon: '🌍',
                      label: 'Location',
                      value: _getCountryName(player.currentCountry ?? 'Unknown'),
                      color: Colors.teal,
                    ),
                    _CompactStat(
                      icon: '�',
                      label: 'Country',
                      value: player.currentCountry ?? '?',
                      color: Colors.cyan,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _getCountryName(String countryId) {
    const countryNames = {
      'netherlands': 'Nederland',
      'belgium': 'België',
      'germany': 'Duitsland',
      'france': 'Frankrijk',
      'spain': 'Spanje',
      'italy': 'Italië',
      'uk': 'Verenigd Koninkrijk',
      'united_kingdom': 'Verenigd Koninkrijk',
      'poland': 'Polen',
      'austria': 'Oostenrijk',
      'switzerland': 'Zwitserland',
      'sweden': 'Zweden',
      'usa': 'Verenigde Staten',
      'mexico': 'Mexico',
      'colombia': 'Colombia',
      'brazil': 'Brazilië',
      'argentina': 'Argentinië',
      'japan': 'Japan',
      'china': 'China',
      'russia': 'Rusland',
      'turkey': 'Turkije',
      'united_arab_emirates': 'Verenigde Arabische Emiraten',
      'south_africa': 'Zuid-Afrika',
      'australia': 'Australië',
    };
    return countryNames[countryId] ?? countryId;
  }
}

/// Compact progress bar with label and percentage
class _ProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color color;

  const _ProgressBar({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = ((value / max) * 100).clamp(0, 100);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
                letterSpacing: 0.3,
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: (value / max).clamp(0, 1),
            minHeight: 4,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}

/// Compact inline stat display
class _CompactStat extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final Color color;

  const _CompactStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 11),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: TextStyle(
            fontSize: 7,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
