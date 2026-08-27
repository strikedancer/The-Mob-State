import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/job.dart';
import '../utils/web_asset_helper.dart';

enum _JobPayTier { low, mid, high }

class JobCard extends StatefulWidget {
  final Job job;
  final bool canWork;
  final bool isWorking;
  final VoidCallback onTap;
  final String jobName;
  final String jobDescription;

  const JobCard({
    super.key,
    required this.job,
    required this.canWork,
    required this.isWorking,
    required this.onTap,
    required this.jobName,
    required this.jobDescription,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  static const Color _gold = Color(0xFFD4AF37);
  bool _isHovered = false;

  int _successPercent() => widget.job.successChance ?? 85;

  _JobPayTier _payTier() {
    if (widget.job.maxPay >= 2000) return _JobPayTier.high;
    if (widget.job.maxPay >= 500) return _JobPayTier.mid;
    return _JobPayTier.low;
  }

  ({Color accent, Color border, String label}) _tierStyle(
    AppLocalizations l10n,
    _JobPayTier tier,
  ) {
    switch (tier) {
      case _JobPayTier.high:
        return (
          accent: const Color(0xFF4A9FD4),
          border: const Color(0xFF4A9FD4),
          label: l10n.jobCardTierHigh,
        );
      case _JobPayTier.mid:
        return (
          accent: _gold,
          border: const Color(0xFFFFC107),
          label: l10n.jobCardTierMid,
        );
      case _JobPayTier.low:
        return (
          accent: Colors.white70,
          border: Colors.white24,
          label: l10n.jobCardTierLow,
        );
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
    final imageAsset = 'assets/images/jobs/${widget.job.id}_job.png';
    final tier = _payTier();
    final tierStyle = _tierStyle(l10n, tier);
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    final successPercent = _successPercent();
    final successFraction = successPercent / 100.0;
    final eduBonus = widget.job.educationBonusPercent ?? 0;

    final borderColor = _isHovered
        ? tierStyle.border.withValues(alpha: 0.95)
        : tierStyle.border.withValues(alpha: widget.canWork ? 0.55 : 0.25);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered && widget.canWork
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
            onTap: (widget.isWorking || !widget.canWork) ? null : widget.onTap,
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
                              Icons.work_outline,
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
                      if (!widget.canWork)
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
                                    widget.job.requiredRank,
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
                      if (widget.job.cooldownMinutes != null)
                        Positioned(
                          bottom: 6,
                          right: 6,
                          child: Tooltip(
                            message: l10n.cooldownMinutes(
                              widget.job.cooldownMinutes.toString(),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.72),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                '⏱️',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      if (!widget.canWork)
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
                        Text(
                          widget.jobName,
                          style: TextStyle(
                            fontSize: isWide ? 12.5 : 11,
                            fontWeight: FontWeight.w800,
                            color: widget.canWork ? Colors.white : Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (widget.jobDescription.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              widget.jobDescription,
                              style: TextStyle(
                                fontSize: isWide ? 10 : 9,
                                height: 1.2,
                                color: widget.canWork
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
                                    l10n.jobCardSuccessChance(successPercent),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: _successBarColor(successPercent),
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
                                        _successBarColor(successPercent),
                                      ),
                                    ),
                                  ),
                                  if (eduBonus > 0)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        l10n.jobCardEducationPayBonus(
                                          eduBonus,
                                        ),
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                          color: _gold.withValues(alpha: 0.9),
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
                                if (widget.job.minPay > 0 ||
                                    widget.job.maxPay > 0)
                                  Text(
                                    l10n.jobPayRangeEuro(
                                      widget.job.minPay.toString(),
                                      widget.job.maxPay.toString(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                if (widget.job.xpReward > 0)
                                  Text(
                                    l10n.jobXpRewardShort(
                                      widget.job.xpReward.toString(),
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
