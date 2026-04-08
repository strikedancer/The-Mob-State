import 'package:flutter/material.dart';
import '../models/crime.dart';
import '../l10n/app_localizations.dart';

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
  bool _isHovered = false;

  // Get all requirement icons for the crime
  List<String> _getRequirementIcons() {
    final icons = <String>[];

    // Add tool icon if tools are required
    if (widget.crime.requiredTools != null &&
        widget.crime.requiredTools!.isNotEmpty) {
      icons.add('🔧');
    }

    // Add vehicle icon if vehicle is required
    if (widget.crime.requiresVehicle) {
      icons.add('🚗');
    }

    // Add weapon icon if weapon is required
    if (widget.crime.requiredWeapon == true) {
      icons.add('🔫');
    }

    // Add drugs icon if drugs are required
    if (widget.crime.requiredDrugs != null &&
        widget.crime.requiredDrugs!.isNotEmpty) {
      icons.add('💊');
    }

    return icons;
  }

  // Determine default icon if no requirements
  String? _getDefaultIcon() {
    switch (widget.crime.id) {
      // Money icon crimes (high value)
      case 'atm_theft':
      case 'jewelry_heist':
      case 'casino_heist':
      case 'bank_robbery':
      case 'drug_deal_large':
        return '💰';

      // People icon crimes
      case 'mug_person':
      case 'kidnapping':
      case 'extortion':
      case 'protection_racket':
        return '👥';

      // No icon for others
      default:
        return null;
    }
  }

  // Get comprehensive tooltip for all requirements
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

    // Add tool requirements
    if (widget.crime.requiredTools != null &&
        widget.crime.requiredTools!.isNotEmpty) {
      final toolNames = widget.crime.requiredTools!.map((toolId) {
        switch (toolId) {
          case 'bolt_cutter':
            return l10n.toolBoltCutter;
          case 'car_theft_tools':
            return l10n.toolCarTheftTools;
          case 'burglary_kit':
            return l10n.toolBurglaryKit;
          case 'toolbox':
            return l10n.toolToolbox;
          case 'crowbar':
            return l10n.toolCrowbar;
          case 'glass_cutter':
            return l10n.toolGlassCutter;
          case 'spray_paint':
            return l10n.toolSprayPaint;
          case 'jerry_can':
            return l10n.toolJerryCan;
          case 'fake_documents':
            return l10n.toolFakeDocuments;
          case 'hacking_laptop':
            return l10n.toolHackingLaptop;
          case 'counterfeiting_kit':
            return l10n.toolCounterfeitingKit;
          case 'rope':
            return l10n.toolRope;
          case 'silencer':
            return l10n.toolSilencer;
          case 'night_vision':
            return l10n.toolNightVision;
          case 'gps_jammer':
            return l10n.toolGpsJammer;
          case 'burner_phone':
            return l10n.toolBurnerPhone;
          case 'thermal_drill':
            return 'Thermische Boor';
          default:
            return toolId;
        }
      }).toList();
      requirements.add('🔧 ${toolNames.join(", ")}');
    }

    // Add vehicle requirement
    if (widget.crime.requiresVehicle) {
      requirements.add('🚗 ${l10n.tooltipCrimeRequiresVehicle}');
    }

    // Add weapon requirement
    if (widget.crime.requiredWeapon == true) {
      requirements.add('🔫 Wapen vereist');
    }

    // Add drug requirements
    if (widget.crime.requiredDrugs != null &&
        widget.crime.requiredDrugs!.isNotEmpty) {
      final drugNames = widget.crime.requiredDrugs!
          .map(formatDrugName)
          .join(', ');
      final minQty = widget.crime.minDrugQuantity ?? 1;
      requirements.add(
        '💊 ${l10n.tooltipCrimeRequiresDrugs} (min $minQty): $drugNames',
      );
    }

    // If has requirements, return combined tooltip
    if (requirements.isNotEmpty) {
      return 'Vereist:\n${requirements.join('\n')}';
    }

    // Default tooltips for other crime types
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

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final requirementIcons = _getRequirementIcons();
    final defaultIcon = _getDefaultIcon();
    final imageAsset = 'assets/images/crimes/${widget.crime.id}_crime.png';
    final legacyImageAsset = 'images/crimes/${widget.crime.id}_crime.png';

    // Use player-specific calculated success chance, or fall back to base chance
    final successChance =
        widget.crime.playerSuccessChance ??
        ((widget.crime.baseSuccessChance ?? 0) * 100).round();

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFC107).withOpacity(0.22),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ]
              : const [],
        ),
        child: Card(
          elevation: _isHovered ? 4 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: _isHovered
                  ? const Color(0xFFFFC107).withOpacity(0.75)
                  : Colors.transparent,
              width: _isHovered ? 1.2 : 0,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: (widget.isCommitting || !widget.canCommit)
                ? null
                : () {
                    print('[CrimeCard] Tapped crime: ${widget.crime.id}');
                    widget.onTap();
                  },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 120),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          color: Colors.grey[850],
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: Image.asset(
                            imageAsset,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                legacyImageAsset,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[850],
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white54,
                                      size: 26,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.12),
                              Colors.black.withOpacity(0.55),
                            ],
                          ),
                        ),
                      ),
                      if (!widget.canCommit)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10),
                            ),
                            color: Colors.black.withOpacity(0.45),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.crimeName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: widget.canCommit
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Show requirement icons
                            if (requirementIcons.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Tooltip(
                                  message: _getRequirementsTooltip(l10n) ?? '',
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: requirementIcons
                                        .map(
                                          (ico) => Text(
                                            ico,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              )
                            // Show default icon if no requirements
                            else if (defaultIcon != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Tooltip(
                                  message: _getRequirementsTooltip(l10n) ?? '',
                                  child: Text(
                                    defaultIcon,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (widget.crimeDescription.isNotEmpty)
                          Text(
                            widget.crimeDescription,
                            style: TextStyle(
                              fontSize: 9,
                              color: widget.canCommit
                                  ? Colors.grey[300]
                                  : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Success percentage
                            Text(
                              '$successChance% kans',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.amber,
                              ),
                            ),
                            // Right: Rewards (money and XP)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.crime.minPay > 0 ||
                                    widget.crime.maxPay > 0)
                                  Text(
                                    '\$${widget.crime.minPay}-${widget.crime.maxPay}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                if (widget.crime.xpReward > 0)
                                  Text(
                                    '+${widget.crime.xpReward} XP',
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
