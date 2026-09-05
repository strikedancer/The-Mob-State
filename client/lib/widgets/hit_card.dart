import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/avatar_helper.dart';
import '../utils/formatters.dart';

class HitCard extends StatelessWidget {
  static const Color _gold = Color(0xFFD4AF37);
  static const Color _panelBg = Color(0xFF151B28);
  static const Color _panelBorder = Color(0xFF2A3344);
  static const Color _hitAccent = Color(0xFFE85D4C);

  final dynamic hit;
  final VoidCallback onAttemptHit;
  final VoidCallback? onInvestigate;
  final void Function(int playerId, String? username)? onOpenPlayerProfile;
  final VoidCallback onPlaceCounterBounty;
  final VoidCallback onCancelHit;

  const HitCard({
    super.key,
    required this.hit,
    required this.onAttemptHit,
    this.onInvestigate,
    this.onOpenPlayerProfile,
    required this.onPlaceCounterBounty,
    required this.onCancelHit,
  });

  String _formatMoney(dynamic amount) {
    if (amount == null) return formatCurrency(0);
    if (amount is num) return formatCurrency(amount);
    final parsed = num.tryParse(amount.toString());
    return formatCurrency(parsed ?? 0);
  }

  String _getTimeAgo(DateTime dateTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      final days = difference.inDays;
      if (days == 1) {
        return l10n.hitlistRelativeOneDayAgo;
      }
      return l10n.hitlistRelativeDaysAgo(days.toString());
    } else if (difference.inHours > 0) {
      return l10n.hoursAgo(difference.inHours.toString());
    } else if (difference.inMinutes > 0) {
      return l10n.minutesAgo(difference.inMinutes.toString());
    } else {
      return l10n.justPlaced;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final target = hit['target'];
    final placer = hit['placedBy'];
    final bounty = hit['bounty'] ?? 0;
    final counterBounty = hit['counterBounty'];
    final isCounterBounty = counterBounty != null && counterBounty > 0;
    final createdAt = hit['createdAt'] != null
        ? DateTime.parse(hit['createdAt'])
        : DateTime.now();

    // Determine if current player is the target
    final isTarget = hit['isTarget'] == true;
    final isPlacer = hit['isPlacer'] == true;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      decoration: BoxDecoration(
        color: _panelBg.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCounterBounty
              ? Colors.orange.withValues(alpha: 0.55)
              : _panelBorder,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: const ExpansionTileThemeData(
            iconColor: _gold,
            collapsedIconColor: Colors.white54,
            textColor: Colors.white,
            collapsedTextColor: Colors.white,
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(14, 6, 10, 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isCounterBounty ? Icons.swap_horiz : Icons.my_location,
                    color: isCounterBounty ? Colors.orange : _hitAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap:
                          (target?['id'] != null &&
                              onOpenPlayerProfile != null)
                          ? () => onOpenPlayerProfile!(
                              target!['id'] as int,
                              target['username']?.toString(),
                            )
                          : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage:
                                  AvatarHelper.getAvatarImageProvider(
                                target?['avatar']?.toString(),
                                activePortraitPath: target?['activePortraitPath']
                                    ?.toString(),
                              ),
                              child:
                                  (target?['avatar'] == null ||
                                      target?['avatar']?.toString().isEmpty ==
                                          true)
                                  ? Text(
                                      (target?['username']
                                                  ?.toString()
                                                  .isNotEmpty ==
                                              true)
                                          ? target['username']
                                                .toString()[0]
                                                .toUpperCase()
                                          : '?',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                target?['username'] ?? l10n.unknown,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      (target?['id'] != null &&
                                          onOpenPlayerProfile != null)
                                      ? _gold
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (isCounterBounty ? Colors.orange : _hitAccent)
                          .withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCounterBounty ? Colors.orange : _hitAccent,
                      ),
                    ),
                    child: Text(
                      isCounterBounty ? l10n.counterBid : l10n.hit,
                      style: TextStyle(
                        color: isCounterBounty ? Colors.orange : _hitAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.monetization_on, color: _gold, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _formatMoney(isCounterBounty ? counterBounty : bounty),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _gold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _getTimeAgo(createdAt, l10n),
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                ],
              ),
            ],
          ),
          children: [
            const Divider(height: 1, color: _panelBorder),
            const SizedBox(height: 12),
            _buildDetailRow(
              l10n.target,
              target?['username'] ?? l10n.unknown,
              Icons.person,
              context,
            ),
            const Divider(color: _panelBorder),
            _buildDetailRow(
              l10n.level,
              '${target?['level'] ?? 0}',
              Icons.show_chart,
              context,
            ),
            const Divider(color: _panelBorder),
            _buildPlayerDetailRow(
              label: l10n.placer,
              playerId: placer?['id'] as int?,
              username: placer?['username']?.toString(),
              avatar: placer?['avatar']?.toString(),
              activePortraitPath: placer?['activePortraitPath']?.toString(),
              icon: Icons.person_add,
              context: context,
            ),
            const Divider(color: _panelBorder),
            _buildDetailRow(
              l10n.bounty,
              _formatMoney(bounty),
              Icons.monetization_on,
              context,
              valueColor: _gold,
            ),
            if (counterBounty != null && counterBounty > 0) ...[
              const Divider(color: _panelBorder),
              _buildDetailRow(
                l10n.counterBid,
                _formatMoney(counterBounty),
                Icons.swap_horiz,
                context,
                valueColor: Colors.orange,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.12),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.7)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.counterBidPlaced,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (isTarget)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: onPlaceCounterBounty,
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(l10n.counterBountyTitle),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            if (isPlacer)
              ElevatedButton.icon(
                onPressed: onCancelHit,
                icon: const Icon(Icons.close),
                label: Text(l10n.cancel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3A4254),
                  foregroundColor: Colors.white,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onInvestigate != null) ...[
                    OutlinedButton.icon(
                      onPressed: onInvestigate,
                      icon: const Icon(Icons.search),
                      label: Text(l10n.hitlistInvestigationOptions),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _gold,
                        side: const BorderSide(color: _gold),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  ElevatedButton.icon(
                    onPressed: onAttemptHit,
                    icon: const Icon(Icons.local_police),
                    label: Text(l10n.executeHit),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hitAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon,
    BuildContext context, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white54),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerDetailRow({
    required String label,
    required int? playerId,
    required String? username,
    required String? avatar,
    String? activePortraitPath,
    required IconData icon,
    required BuildContext context,
  }) {
    final displayName = (username != null && username.isNotEmpty)
        ? username
        : AppLocalizations.of(context)!.unknown;

    final canOpenProfile = playerId != null && onOpenPlayerProfile != null;

    final playerChip = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 11,
          backgroundImage: AvatarHelper.getAvatarImageProvider(
            avatar,
            activePortraitPath: activePortraitPath,
          ),
          child: (avatar == null || avatar.isEmpty)
              ? Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 9),
                )
              : null,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            displayName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );

    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white54),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        if (canOpenProfile)
          InkWell(
            onTap: () => onOpenPlayerProfile!(playerId, username),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: playerChip,
            ),
          )
        else
          playerChip,
      ],
    );
  }
}
