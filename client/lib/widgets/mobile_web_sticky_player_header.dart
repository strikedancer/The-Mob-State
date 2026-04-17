import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../utils/country_helper.dart';
import '../utils/formatters.dart';

class MobileWebStickyPlayerHeaderShell extends StatelessWidget {
  final Widget child;

  const MobileWebStickyPlayerHeaderShell({
    super.key,
    required this.child,
  });

  static const double headerOffset = 112;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }

    final width = MediaQuery.of(context).size.width;
    if (width >= 900) {
      return child;
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final player = authProvider.currentPlayer;
        if (!authProvider.isAuthenticated || player == null) {
          return child;
        }

        return Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: headerOffset),
                child: child,
              ),
            ),
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _MobileWebStickyPlayerHeader(),
            ),
          ],
        );
      },
    );
  }
}

class _MobileWebStickyPlayerHeader extends StatelessWidget {
  const _MobileWebStickyPlayerHeader();

  @override
  Widget build(BuildContext context) {
    final player = context.watch<AuthProvider>().currentPlayer;
    if (player == null) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final countryName = CountryHelper.getLocalizedCountryName(
      player.currentCountry,
      l10n,
      fallbackName: player.currentCountry?.toString(),
    );
    final wantedLevel = (player.wantedLevel ?? 0).toDouble();
    final fbiHeat = (player.fbiHeat ?? 0).toDouble();

    return Material(
      elevation: 8,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111111).withOpacity(0.96),
          border: Border(
            bottom: BorderSide(color: Colors.amber.shade700.withOpacity(0.7)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    _TopInfoItem(
                      label: l10n.localeName == 'nl' ? 'Contant' : 'Cash',
                      value: formatCurrency(player.money),
                      color: Colors.green.shade300,
                    ),
                    _TopInfoItem(
                      label: l10n.rank,
                      value: 'R${player.rank}',
                      color: Colors.amber.shade300,
                    ),
                    _TopInfoItem(
                      label: l10n.localeName == 'nl' ? 'Land' : 'Country',
                      value:
                          '${CountryHelper.getCountryFlag(player.currentCountry)} $countryName',
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _TinyProgressBar(
                        label: l10n.health,
                        valueText: '${player.health}%',
                        progress: (player.health / 100).clamp(0.0, 1.0),
                        color: player.health > 50
                            ? Colors.green
                            : (player.health > 25
                                ? Colors.orange
                                : Colors.red),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _TinyProgressBar(
                        label: 'Wanted',
                        valueText: '${wantedLevel.toInt()}/5',
                        progress: (wantedLevel / 5.0).clamp(0.0, 1.0),
                        color: wantedLevel > 0 ? Colors.orange : Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _TinyProgressBar(
                        label: 'FBI',
                        valueText: '${fbiHeat.toInt()}%',
                        progress: (fbiHeat / 100.0).clamp(0.0, 1.0),
                        color: fbiHeat > 0 ? Colors.deepPurple : Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopInfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TopInfoItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        children: [
          TextSpan(text: '$label: ', style: const TextStyle(color: Colors.white60)),
          TextSpan(text: value, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}

class _TinyProgressBar extends StatelessWidget {
  final String label;
  final String valueText;
  final double progress;
  final Color color;

  const _TinyProgressBar({
    required this.label,
    required this.valueText,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              valueText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}