import 'package:flutter/material.dart';
import 'responsive_modal.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';

const Color _resultGold = Color(0xFFFFB347);
const Color _resultPanelDark = Color(0xFF1B1212);
const Color _resultPanelLight = Color(0xFF2A1A1A);
const Color _resultMoney = Color(0xFF86EFAC);
const Color _resultFail = Color(0xFFE85D4C);

class CrimeResultOverlay extends StatelessWidget {
  final String crimeName;
  final int reward;
  final int xpGained;
  final int xpLost;
  final VoidCallback onContinue;
  final bool embedded;
  final bool isSuccess;
  /// Optional headline; defaults to success or failure l10n.
  final String? headline;
  final String? flavorLine;
  final String? tipBonusLabel;
  final bool intelDropped;
  final int? vehicleConditionLoss;
  final int? vehicleFuelUsed;

  const CrimeResultOverlay({
    super.key,
    required this.crimeName,
    this.reward = 0,
    this.xpGained = 0,
    this.xpLost = 0,
    required this.onContinue,
    this.embedded = false,
    this.isSuccess = true,
    this.headline,
    this.flavorLine,
    this.tipBonusLabel,
    this.intelDropped = false,
    this.vehicleConditionLoss,
    this.vehicleFuelUsed,
  });

  String get _badgeAssetPath => isSuccess
      ? 'assets/images/ui/result_badge_success.png'
      : 'assets/images/ui/result_badge_fail.png';

  List<_ResultStatData> _buildResultStats(
    AppLocalizations l10n,
    Color accent,
  ) {
    final stats = <_ResultStatData>[];
    if (isSuccess) {
      if (reward > 0) {
        stats.add(
          _ResultStatData(
            icon: Icons.payments_outlined,
            label: l10n.crimeResultMoneyLabel,
            value: '+${formatCurrency(reward)}',
            valueColor: _resultMoney,
          ),
        );
      }
      if (xpGained > 0) {
        stats.add(
          _ResultStatData(
            icon: Icons.auto_awesome,
            label: l10n.crimeResultXpLabel,
            value: l10n.jobXpRewardShort(xpGained.toString()),
            valueColor: accent,
          ),
        );
      }
    } else if (xpLost > 0) {
      stats.add(
        _ResultStatData(
          icon: Icons.trending_down,
          label: l10n.jobResultXpLostLabel,
          value: '−$xpLost XP',
          valueColor: const Color(0xFFFF8A80),
        ),
      );
    }
    if (vehicleConditionLoss != null && vehicleConditionLoss! > 0) {
      stats.add(
        _ResultStatData(
          icon: Icons.build_circle_outlined,
          label: l10n.vehicleCondition,
          value: '−${vehicleConditionLoss!}%',
          valueColor: const Color(0xFFFFB74D),
        ),
      );
    }
    if (vehicleFuelUsed != null && vehicleFuelUsed! > 0) {
      stats.add(
        _ResultStatData(
          icon: Icons.local_gas_station_outlined,
          label: l10n.vehicleFuel,
          value: '−${vehicleFuelUsed!}%',
          valueColor: const Color(0xFF81D4FA),
        ),
      );
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = isSuccess ? _resultGold : _resultFail;
    final panelLight =
        isSuccess ? _resultPanelLight : const Color(0xFF2A1515);
    final panelDark = isSuccess ? _resultPanelDark : const Color(0xFF1B1010);

    return ResponsiveModalLayout(
      embedded: embedded,
      phoneMaxWidth: 520,
      tabletMaxWidth: 620,
      desktopMaxWidth: 720,
      cardColor: panelDark,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compactWidth = constraints.maxWidth < 430;
          final badgeSize = compactWidth ? 56.0 : 64.0;

          return Container(
            padding: EdgeInsets.all(compactWidth ? 18 : 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [panelLight, panelDark],
              ),
              border: Border.all(
                color: accent.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ResultBadge(
                  size: badgeSize,
                  accent: accent,
                  isSuccess: isSuccess,
                  assetPath: _badgeAssetPath,
                ),
                const SizedBox(height: 10),
                Text(
                  headline ??
                      (isSuccess
                          ? l10n.crimeOutcomeSuccess
                          : l10n.jobOutcomeFailed),
                  style: TextStyle(
                    fontSize: compactWidth ? 20 : 22,
                    fontWeight: FontWeight.w800,
                    color: accent,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  crimeName,
                  style: TextStyle(
                    fontSize: compactWidth ? 15 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.92),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (flavorLine != null && flavorLine!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.jobResultFlavorLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.55),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    flavorLine!,
                    style: TextStyle(
                      fontSize: compactWidth ? 13 : 14,
                      height: 1.3,
                      color: Colors.white.withOpacity(0.82),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (tipBonusLabel != null && tipBonusLabel!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    tipBonusLabel!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _resultMoney,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (intelDropped) ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.jobResultIntelInbox,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: accent.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 14),
                _ResultStatsGrid(
                  accent: accent,
                  stats: _buildResultStats(l10n, accent),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: const Color(0xFF1B1212),
                      disabledBackgroundColor: accent.withOpacity(0.4),
                      elevation: 0,
                      minimumSize: Size.fromHeight(compactWidth ? 44 : 48),
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
          );
        },
      ),
    );
  }
}

/// Circular badge: Leonardo PNG when available; CustomPaint glyph otherwise.
/// Material Icons often render empty on Flutter web inside this modal.
class _ResultBadge extends StatelessWidget {
  final double size;
  final Color accent;
  final bool isSuccess;
  final String assetPath;

  const _ResultBadge({
    required this.size,
    required this.accent,
    required this.isSuccess,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final glyph = CustomPaint(
      size: Size(size * 0.48, size * 0.48),
      painter: isSuccess
          ? _ResultSuccessGlyphPainter(accent)
          : _ResultFailGlyphPainter(accent),
    );

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.withOpacity(0.16),
        border: Border.all(color: accent, width: 1.4),
      ),
      clipBehavior: Clip.antiAlias,
      child: WebAssetHelper.image(
        assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(child: glyph);
        },
      ),
    );
  }
}

class _ResultFailGlyphPainter extends CustomPainter {
  final Color color;
  _ResultFailGlyphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide * 0.14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final inset = size.shortestSide * 0.12;
    canvas.drawLine(
      Offset(inset, inset),
      Offset(size.width - inset, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ResultFailGlyphPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ResultSuccessGlyphPainter extends CustomPainter {
  final Color color;
  _ResultSuccessGlyphPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.shortestSide * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.18, h * 0.52)
      ..lineTo(w * 0.40, h * 0.74)
      ..lineTo(w * 0.82, h * 0.28);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ResultSuccessGlyphPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _ResultStatData {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _ResultStatData({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });
}

class _ResultStatsGrid extends StatelessWidget {
  final List<_ResultStatData> stats;
  final Color accent;

  const _ResultStatsGrid({
    required this.stats,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = 8.0;
        final columns = stats.length == 1 ? 1 : 2;
        final tileWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          alignment: WrapAlignment.center,
          children: stats
              .map(
                (stat) => SizedBox(
                  width: tileWidth,
                  child: _ResultStatCompact(
                    icon: stat.icon,
                    label: stat.label,
                    value: stat.value,
                    valueColor: stat.valueColor,
                    accent: accent,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ResultStatCompact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final Color accent;

  const _ResultStatCompact({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Icon(icon, color: valueColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.65),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: valueColor,
                    height: 1.15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
