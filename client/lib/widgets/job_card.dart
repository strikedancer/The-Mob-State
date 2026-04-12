import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/job.dart';

class JobCard extends StatefulWidget {
  final Job job;
  final bool canWork;
  final bool isWorking;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.canWork,
    required this.isWorking,
    required this.onTap,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final imageAsset = 'assets/images/jobs/${widget.job.id}_job.png';
    final successChance = 85;

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
            onTap: (widget.isWorking || !widget.canWork) ? null : widget.onTap,
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
                          image: DecorationImage(
                            image: AssetImage(imageAsset),
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            onError: (exception, stackTrace) {},
                          ),
                          color: Colors.grey[850],
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
                      if (!widget.canWork)
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
                                widget.job.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: widget.canWork
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.job.cooldownMinutes != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Tooltip(
                                  message: l10n.cooldownMinutes(
                                    widget.job.cooldownMinutes.toString(),
                                  ),
                                  child: const Text(
                                    '⏱️',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (widget.job.description != null &&
                            widget.job.description!.isNotEmpty)
                          Text(
                            widget.job.description!,
                            style: TextStyle(
                              fontSize: 9,
                              color: widget.canWork
                                  ? Colors.grey[300]
                                  : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Left: Success percentage (jobs are 85% success rate)
                            Text(
                              '$successChance% kans',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.lightGreen,
                              ),
                            ),
                            // Right: Rewards (money and XP)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (widget.job.minPay > 0 ||
                                    widget.job.maxPay > 0)
                                  Text(
                                    '\$${widget.job.minPay}-${widget.job.maxPay}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[400],
                                    ),
                                  ),
                                if (widget.job.xpReward > 0)
                                  Text(
                                    '+${widget.job.xpReward} XP',
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
