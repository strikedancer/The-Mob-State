import 'package:flutter/material.dart';
import '../models/crime.dart';
import '../l10n/app_localizations.dart';
import '../utils/web_asset_helper.dart';
import '../utils/tool_display_name.dart';
import '../utils/weapon_display_name.dart';

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

  bool get _hasToolRequirement =>
      widget.crime.requiredTools != null &&
      widget.crime.requiredTools!.isNotEmpty;

  bool get _hasWeaponRequirement => widget.crime.requiredWeapon == true;

  static const double _requirementBannerHeight = 30;

  String _formatToolNames(AppLocalizations l10n, List<String> toolIds) {
    return toolIds
        .map((id) => localizedToolName(l10n, id, null))
        .join(', ');
  }

  String? _blockerLabel(AppLocalizations l10n) {
    switch (widget.crime.readinessBlocker) {
      case 'rank':
        return l10n.crimeCardRankRequired(widget.crime.requiredRank);
      case 'tools':
        final missing = widget.crime.missingToolIds;
        if (missing != null && missing.isNotEmpty) {
          return l10n.crimeCardToolBannerNeeded(
            _formatToolNames(l10n, missing),
          );
        }
        return l10n.tooltipCrimeRequiresTools;
      case 'tools_in_storage':
        final stored = widget.crime.toolsInStorageIds;
        if (stored != null && stored.isNotEmpty) {
          return l10n.crimeCardToolBannerStorage(
            _formatToolNames(l10n, stored),
          );
        }
        return l10n.tooltipCrimeRequiresTools;
      case 'vehicle':
        return l10n.crimeCardBlockerVehicle;
      case 'drugs':
        return l10n.crimeCardBlockerDrugs;
      case 'weapon':
        return l10n.crimeCardBlockerWeapon;
      case 'weapon_ammo':
        return l10n.crimeCardBlockerAmmo;
      case 'criminal_record':
        return l10n.crimeCardBlockerCriminalRecord;
      default:
        if (!widget.canCommit) {
          return l10n.crimeCardRankRequired(widget.crime.requiredRank);
        }
        return null;
    }
  }

  Widget? _buildToolBanner(AppLocalizations l10n, {double bottom = 0}) {
    if (!_hasToolRequirement) return null;

    final toolIds = widget.crime.requiredTools!;
    final toolLabel = _formatToolNames(l10n, toolIds);
    final blocker = widget.crime.readinessBlocker;
    final toolsReady = widget.crime.toolsReady == true;

    late final String bannerText;
    late final Color bannerColor;
    late final Color textColor;
    IconData trailingIcon;
    Color trailingColor;

    if (toolsReady && widget.canCommit) {
      bannerText = l10n.crimeCardToolBannerReady(toolLabel);
      bannerColor = const Color(0xFF1B5E20);
      textColor = Colors.greenAccent;
      trailingIcon = Icons.check_circle_rounded;
      trailingColor = Colors.greenAccent;
    } else if (blocker == 'tools_in_storage') {
      bannerText = l10n.crimeCardToolBannerStorage(toolLabel);
      bannerColor = const Color(0xFF5D4037);
      textColor = Colors.orangeAccent;
      trailingIcon = Icons.home_work_outlined;
      trailingColor = Colors.orangeAccent;
    } else if (blocker == 'tools' || widget.crime.toolsReady == false) {
      bannerText = l10n.crimeCardToolBannerNeeded(toolLabel);
      bannerColor = const Color(0xFF4A3728);
      textColor = const Color(0xFFFFB74D);
      trailingIcon = Icons.lock_outline_rounded;
      trailingColor = const Color(0xFFFFB74D);
    } else if (blocker == 'rank') {
      bannerText = l10n.crimeCardToolBannerNeeded(toolLabel);
      bannerColor = Colors.black.withValues(alpha: 0.72);
      textColor = Colors.white60;
      trailingIcon = Icons.build_rounded;
      trailingColor = Colors.white54;
    } else {
      bannerText = l10n.crimeCardToolBannerReady(toolLabel);
      bannerColor = const Color(0xFF1B5E20).withValues(alpha: 0.85);
      textColor = Colors.greenAccent;
      trailingIcon = Icons.check_circle_outline_rounded;
      trailingColor = Colors.greenAccent;
    }

    return _buildRequirementBanner(
      bottom: bottom,
      bannerColor: bannerColor,
      textColor: textColor,
      leadingIcon: Icons.build_rounded,
      bannerText: bannerText,
      trailingIcon: trailingIcon,
      trailingColor: trailingColor,
    );
  }

  Widget? _buildWeaponBanner(AppLocalizations l10n, {double bottom = 0}) {
    if (!_hasWeaponRequirement) return null;

    final blocker = widget.crime.readinessBlocker;
    final weaponReady = widget.crime.weaponReady == true;
    final weaponLabel = localizedWeaponDisplayName(
      l10n,
      widget.crime.selectedCrimeWeaponId,
      widget.crime.selectedCrimeWeaponName,
    );

    late final String bannerText;
    late final Color bannerColor;
    late final Color textColor;
    IconData trailingIcon;
    Color trailingColor;

    if (weaponReady && widget.canCommit) {
      final label = weaponLabel.isNotEmpty
          ? weaponLabel
          : l10n.tooltipCrimeRequiresWeapon;
      bannerText = l10n.crimeCardWeaponBannerReady(label);
      bannerColor = const Color(0xFF1A237E);
      textColor = Colors.lightBlueAccent;
      trailingIcon = Icons.check_circle_rounded;
      trailingColor = Colors.lightBlueAccent;
    } else if (blocker == 'weapon_ammo') {
      bannerText = l10n.crimeCardWeaponBannerAmmo;
      bannerColor = const Color(0xFF4A148C);
      textColor = Colors.purpleAccent;
      trailingIcon = Icons.lock_outline_rounded;
      trailingColor = Colors.purpleAccent;
    } else if (blocker == 'weapon' || widget.crime.weaponReady == false) {
      bannerText = l10n.crimeCardWeaponBannerNeeded;
      bannerColor = const Color(0xFF311B92);
      textColor = const Color(0xFFB39DDB);
      trailingIcon = Icons.lock_outline_rounded;
      trailingColor = const Color(0xFFB39DDB);
    } else if (blocker == 'rank') {
      bannerText = l10n.crimeCardWeaponBannerNeeded;
      bannerColor = Colors.black.withValues(alpha: 0.72);
      textColor = Colors.white60;
      trailingIcon = Icons.whatshot_outlined;
      trailingColor = Colors.white54;
    } else {
      final label = weaponLabel.isNotEmpty
          ? weaponLabel
          : l10n.tooltipCrimeRequiresWeapon;
      bannerText = l10n.crimeCardWeaponBannerReady(label);
      bannerColor = const Color(0xFF1A237E).withValues(alpha: 0.88);
      textColor = Colors.lightBlueAccent;
      trailingIcon = Icons.check_circle_outline_rounded;
      trailingColor = Colors.lightBlueAccent;
    }

    return _buildRequirementBanner(
      bottom: bottom,
      bannerColor: bannerColor,
      textColor: textColor,
      leadingIcon: Icons.whatshot_outlined,
      bannerText: bannerText,
      trailingIcon: trailingIcon,
      trailingColor: trailingColor,
    );
  }

  Widget _buildRequirementBanner({
    required double bottom,
    required Color bannerColor,
    required Color textColor,
    required IconData leadingIcon,
    required String bannerText,
    required IconData trailingIcon,
    required Color trailingColor,
  }) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: bottom,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              bannerColor.withValues(alpha: 0.92),
            ],
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
          color: bannerColor.withValues(alpha: 0.88),
          child: Row(
            children: [
              Icon(leadingIcon, size: 13, color: textColor),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  bannerText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(trailingIcon, size: 13, color: trailingColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildBlockerBadge(AppLocalizations l10n) {
    if (widget.canCommit) return null;

    final label = _blockerLabel(l10n);
    if (label == null) return null;

    // Requirement banners cover these blockers; skip duplicate top badge.
    if (_hasToolRequirement &&
        (widget.crime.readinessBlocker == 'tools' ||
            widget.crime.readinessBlocker == 'tools_in_storage')) {
      return null;
    }
    if (_hasWeaponRequirement &&
        (widget.crime.readinessBlocker == 'weapon' ||
            widget.crime.readinessBlocker == 'weapon_ammo')) {
      return null;
    }

    return Positioned(
      top: 6,
      right: 6,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 120),
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
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getRequirementIcons() {
    final icons = <String>[];

    if (_hasToolRequirement) {
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

    if (_hasToolRequirement) {
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

    final weaponBanner = _buildWeaponBanner(l10n);
    final toolBottomOffset =
        weaponBanner != null ? _requirementBannerHeight : 0.0;
    final toolBanner = _buildToolBanner(l10n, bottom: toolBottomOffset);
    final blockerBadge = _buildBlockerBadge(l10n);

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
                      if (blockerBadge != null) blockerBadge,
                      if (!widget.canCommit)
                        Container(
                          color: Colors.black.withValues(alpha: 0.42),
                        ),
                      if (weaponBanner != null) weaponBanner,
                      if (toolBanner != null) toolBanner,
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
