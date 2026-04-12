import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../utils/avatar_helper.dart';

class HitCard extends StatelessWidget {
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

  String _t(BuildContext context, String nl, String en) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'nl' ? nl : en;
  }

  String _formatMoney(dynamic amount) {
    if (amount == null) return '€0';
    final formatted = NumberFormat('#,##0', 'nl_NL').format(amount);
    return '€$formatted';
  }

  String _getTimeAgo(DateTime dateTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      final plural = difference.inDays > 1 ? 'en' : '';
      return l10n.daysAgo((difference.inDays.toString()), plural);
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

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCounterBounty ? Icons.swap_horiz : Icons.location_on,
                  color: isCounterBounty ? Colors.orange : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap:
                        (target?['id'] != null && onOpenPlayerProfile != null)
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
                            backgroundImage: AvatarHelper.getAvatarImageProvider(
                              target?['avatar']?.toString(),
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
                                    style: const TextStyle(fontSize: 11),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            target?['username'] ?? l10n.unknown,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  (target?['id'] != null &&
                                      onOpenPlayerProfile != null)
                                  ? Colors.lightBlue
                                  : null,
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
                    color: isCounterBounty ? Colors.orange : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isCounterBounty ? l10n.counterBid : l10n.hit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.monetization_on, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(
                  _formatMoney(isCounterBounty ? counterBounty : bounty),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                  ),
                ),
                const Spacer(),
                Text(
                  _getTimeAgo(createdAt, l10n),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hit Details
                _buildDetailRow(
                  l10n.target,
                  target?['username'] ?? l10n.unknown,
                  Icons.person,
                  context,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n.level,
                  '${target?['level'] ?? 0}',
                  Icons.show_chart,
                  context,
                ),
                const Divider(),
                _buildPlayerDetailRow(
                  label: l10n.placer,
                  playerId: placer?['id'] as int?,
                  username: placer?['username']?.toString(),
                  avatar: placer?['avatar']?.toString(),
                  icon: Icons.person_add,
                  context: context,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n.bounty,
                  _formatMoney(bounty),
                  Icons.monetization_on,
                  context,
                  valueColor: Colors.amber,
                ),
                if (counterBounty != null && counterBounty > 0) ...[
                  const Divider(),
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
                      color: Colors.orange[50],
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(4),
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
                // Actions
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
                      backgroundColor: Colors.grey,
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
                          label: Text(
                            _t(
                              context,
                              'Onderzoek opties',
                              'Investigation options',
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      ElevatedButton.icon(
                        onPressed: onAttemptHit,
                        icon: const Icon(Icons.local_police),
                        label: Text(l10n.executeHit),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
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
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }

  Widget _buildPlayerDetailRow({
    required String label,
    required int? playerId,
    required String? username,
    required String? avatar,
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
          backgroundImage: AvatarHelper.getAvatarImageProvider(avatar),
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );

    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
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
