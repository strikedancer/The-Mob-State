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
      clipBehavior: Clip.none,
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
          tilePadding: const EdgeInsets.fromLTRB(12, 2, 4, 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 420;
              final avatar = InkWell(
                onTap: (target?['id'] != null && onOpenPlayerProfile != null)
                    ? () => onOpenPlayerProfile!(
                        target!['id'] as int,
                        target['username']?.toString(),
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _gold, width: 1.2),
                  ),
                  child: CircleAvatar(
                    radius: 19,
                    backgroundImage: AvatarHelper.getAvatarImageProvider(
                      target?['avatar']?.toString(),
                      activePortraitPath:
                          target?['activePortraitPath']?.toString(),
                    ),
                    child:
                        (target?['avatar'] == null ||
                            target?['avatar']?.toString().isEmpty == true)
                        ? Text(
                            (target?['username']?.toString().isNotEmpty == true)
                                ? target['username'].toString()[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
              );
              final name = InkWell(
                onTap: (target?['id'] != null && onOpenPlayerProfile != null)
                    ? () => onOpenPlayerProfile!(
                        target!['id'] as int,
                        target['username']?.toString(),
                      )
                    : null,
                child: Text(
                  target?['username'] ?? l10n.unknown,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color:
                        (target?['id'] != null && onOpenPlayerProfile != null)
                        ? _gold
                        : Colors.white,
                  ),
                ),
              );
              final hitButton = !isPlacer
                  ? FilledButton(
                      onPressed: onAttemptHit,
                      style: FilledButton.styleFrom(
                        backgroundColor: _hitAccent,
                        foregroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        minimumSize: const Size(0, 36),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.hit,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                    )
                  : null;
              final meta = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatMoney(isCounterBounty ? counterBounty : bounty),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: _gold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getTimeAgo(createdAt, l10n),
                    style: const TextStyle(fontSize: 12, color: Colors.white54),
                  ),
                  if (hitButton != null) ...[
                    const SizedBox(width: 8),
                    hitButton,
                  ],
                ],
              );
              if (compact) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        avatar,
                        const SizedBox(width: 10),
                        Expanded(child: name),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerRight, child: meta),
                  ],
                );
              }
              return Row(
                children: [
                  avatar,
                  const SizedBox(width: 10),
                  Expanded(child: name),
                  const SizedBox(width: 8),
                  meta,
                ],
              );
            },
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
