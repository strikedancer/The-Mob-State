import 'package:flutter/material.dart';
import '../models/crime.dart';
import '../l10n/app_localizations.dart';
import '../utils/web_asset_helper.dart';
import '../utils/tool_display_name.dart';

enum _CrimeRewardTier { low, mid, high }

class CrimeCard extends StatefulWidget {
  final Crime crime;
  final bool canCommit;
  final bool isCommitting;
  final VoidCallback onTap;
  final String crimeName;
  final String crimeDescription;

  const CrimeCard({
    required this.crime,
    required this.canCommit,
    required this.isCommitting,
    required this.onTap,
    required this.crimeName,
    required this.crimeDescription,
    super.key,
  });

  @override
  State<CrimeCard> createState() => _CrimeCardState();
}

class _CrimeCardState extends State<CrimeCard> {
  static const Color _gold = Color(0xFFD4AF37);
  bool _isHovered = false;

  _CrimeRewardTier _rewardTier() {
    if (widget.crime.maxPay >= 15000) return _CrimeRewardTier.high;
    if (widget.crime.maxPay >= 2000) return _CrimeRewardTier.mid;
    return _CrimeRewardTier.low;
  }

  ({Color accent, Color border, String label}) _tierStyle(
    AppLocalizations l10n,
    _CrimeRewardTier tier,
  ) {
    switch (tier) {
      case _CrimeRewardTier.high:
        return (
          accent: const Color(0xFFE85D4C),
          border: const Color(0xFFE85D4C),
          label: l10n.crimeCardTierHigh,
        );
      case _CrimeRewardTier.mid:
        return (
          accent: _gold,
          border: const Color(0xFFFFC107),
          label: l10n.crimeCardTierMid,
        );
      case _CrimeRewardTier.low:
        return (
          accent: Colors.white70,
          border: Colors.white24,
          label: l10n.crimeCardTierLow,
        );
    }
  }

  List<String> _getRequirementIcons() {
    final icons = <String>[];

    if (widget.crime.requiredTools != null &&
        widget.crime.requiredTools!.isNotEmpty) {
      icons.add('🔧');
    }
    if (widget.crime.requiresVehicle) {
      icons.add('🚗');
    }
    if (widget.crime.requiredWeapon == true) {
      icons.add('🔫');
    }
    if (widget.crime.requiredDrugs != null &&
        widget.crime.requiredDrugs!.isNotEmpty) {
      icons.add('💊');
    }

    return icons;
  }

  String? _getDefaultIcon() {
    switch (widget.crime.id) {
      case 'atm_theft':
      case 'jewelry_heist':
      case 'casino_heist':
      case 'bank_robbery':
      case 'drug_deal_large':
        return '💰';
      case 'mug_person':
      case 'kidnapping':
      case 'extortion':
      case 'protection_racket':
        return '👥';
      case 'criminal_record_wipe':
        return '🧾';
      default:
        return null;
    }
  }

  String? _getRequirementsTooltip(AppLocalizations l10n) {
    final requirements = <String>[];

    String formatDrugName(String drugId) {
      return drugId
          .replaceAll('_', ' ')
          .split(' ')
          .map(
            (part) => part.isEmpty
                ? part
                : '${part[0].toUpperCase()}${part.substring(1)}',
          )
          .join(' ');
    }

    if (widget.crime.requiredTools != null &&
        widget.crime.requiredTools!.isNotEmpty) {
      final toolNames = widget.crime.requiredTools!
          .map((toolId) => localizedToolName(l10n, toolId, null))
          .toList();
      requirements.add('🔧 ${toolNames.join(", ")}');
    }
    if (widget.crime.requiresVehicle) {
      requirements.add('🚗 ${l10n.tooltipCrimeRequiresVehicle}');
    }
    if (widget.crime.requiredWeapon == true) {
      requirements.add('🔫 ${l10n.tooltipCrimeRequiresWeapon}');
    }
    if (widget.crime.requiredDrugs != null &&
        widget.crime.requiredDrugs!.isNotEmpty) {
      final drugNames = widget.crime.requiredDrugs!
          .map(formatDrugName)
          .join(', ');
      final minQty = widget.crime.minDrugQuantity ?? 1;
      requirements.add(
        l10n.crimeRequirementDrugsFull(
          l10n.tooltipCrimeRequiresDrugs,
          minQty.toString(),
          drugNames,
        ),
      );
    }

    if (requirements.isNotEmpty) {
      return '${l10n.tooltipCrimeRequirementsHeading}\n${requirements.join('\n')}';
    }

    switch (widget.crime.id) {
      case 'atm_theft':
      case 'jewelry_heist':
      case 'casino_heist':
      case 'bank_robbery':
      case 'drug_deal_large':
        return l10n.tooltipCrimeHighValue;
      case 'mug_person':
      case 'kidnapping':
      case 'extortion':
      case 'protection_racket':
        return l10n.tooltipCrimeRequiresViolence;
      case 'criminal_record_wipe':
        return l10n.crimeCriminalRecordWipeTooltip;
      default:
        return null;
    }
  }

  Color _successBarColor(int percent) {
    if (percent >= 70) return Colors.greenAccent;
    if (percent >= 45) return _gold;
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final requirementIcons = _getRequirementIcons();
    final defaultIcon = _getDefaultIcon();
    final imageAsset = 'assets/images/crimes/${widget.crime.id}_crime.png';
    final tier = _rewardTier();
    final tierStyle = _tierStyle(l10n, tier);
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final successChance =
        widget.crime.playerSuccessChance ??
        ((widget.crime.baseSuccessChance ?? 0) * 100).round();
    final successFraction = (successChance.clamp(0, 100)) / 100.0;

    final borderColor = _isHovered
        ? tierStyle.border.withValues(alpha: 0.95)
        : tierStyle.border.withValues(alpha: widget.canCommit ? 0.55 : 0.25);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered && widget.canCommit
              ? [
                  BoxShadow(
                    color: tierStyle.accent.withValues(alpha: 0.28),
                    blurRadius: 14,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Material(
          color: const Color(0xFF151B28),
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: (widget.isCommitting || !widget.canCommit)
                ? null
                : widget.onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      WebAssetHelper.image(
                        imageAsset,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF1E2433),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                              size: 26,
                            ),
                          );
                        },
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.08),
                              Colors.black.withValues(alpha: 0.72),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: tierStyle.accent.withValues(alpha: 0.7),
                            ),
                          ),
                          child: Text(
                            tierStyle.label,
                            style: TextStyle(
                              color: tierStyle.accent,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (!widget.canCommit)
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.75),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.white38),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.lock,
                                  color: Colors.white70,
                                  size: 11,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.crimeCardRankRequired(
                                    widget.crime.requiredRank,
                                  ),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (!widget.canCommit)
                        Container(
                          color: Colors.black.withValues(alpha: 0.42),
                        ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: borderColor, width: 1.1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.crimeName,
                                style: TextStyle(
                                  fontSize: isWide ? 12.5 : 11,
                                  fontWeight: FontWeight.w800,
                                  color: widget.canCommit
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (requirementIcons.isNotEmpty)
                              Tooltip(
                                message: _getRequirementsTooltip(l10n) ?? '',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: requirementIcons
                                      .map(
                                        (ico) => Padding(
                                          padding: const EdgeInsets.only(
                                            left: 3,
                                          ),
                                          child: Text(
                                            ico,
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            else if (defaultIcon != null)
                              Tooltip(
                                message: _getRequirementsTooltip(l10n) ?? '',
                                child: Text(
                                  defaultIcon,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                          ],
                        ),
                        if (widget.crimeDescription.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              widget.crimeDescription,
                              style: TextStyle(
                                fontSize: isWide ? 10 : 9,
                                height: 1.2,
                                color: widget.canCommit
                                    ? Colors.white60
                                    : Colors.grey,
                              ),
                              maxLines: isWide ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.crimeCardSuccessChance(
                                      successChance,
                                    ),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _successBarColor(successChance),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: successFraction,
                                      minHeight: 4,
                                      backgroundColor: Colors.white12,
                                      valueColor: AlwaysStoppedAnimation(
                                        _successBarColor(successChance),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.crime.minPay > 0 ||
                                    widget.crime.maxPay > 0)
                                  Text(
                                    l10n.jobPayRangeEuro(
                                      widget.crime.minPay.toString(),
                                      widget.crime.maxPay.toString(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                if (widget.crime.xpReward > 0)
                                  Text(
                                    l10n.jobXpRewardShort(
                                      widget.crime.xpReward.toString(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue[300],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
