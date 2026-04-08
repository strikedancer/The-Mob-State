import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class HitCard extends StatelessWidget {
  final dynamic hit;
  final VoidCallback onAttemptHit;
  final VoidCallback onPlaceCounterBounty;
  final VoidCallback onCancelHit;

  const HitCard({
    super.key,
    required this.hit,
    required this.onAttemptHit,
    required this.onPlaceCounterBounty,
    required this.onCancelHit,
  });

  String _formatMoney(dynamic amount) {
    if (amount == null) return '€0';
    final formatted = NumberFormat('#,##0', 'nl_NL').format(amount);
    return '€$formatted';
  }

  String _getTimeAgo(DateTime dateTime, AppLocalizations? l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      final plural = difference.inDays > 1 ? 'en' : '';
      return l10n?.daysAgo((difference.inDays.toString()), plural) ?? 
        '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return l10n?.hoursAgo(difference.inHours.toString()) ?? 
        '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return l10n?.minutesAgo(difference.inMinutes.toString()) ?? 
        '${difference.inMinutes} minutes ago';
    } else {
      return l10n?.justPlaced ?? 'Just placed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                  child: Text(
                    target?['username'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
                    isCounterBounty 
                      ? (l10n?.counterBid ?? 'COUNTER-BID')
                      : (l10n?.hit ?? 'HIT'),
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
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber,
                  size: 14,
                ),
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
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
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
                  l10n?.target ?? 'Target',
                  target?['username'] ?? 'Unknown',
                  Icons.person,
                  context,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n?.level ?? 'Level',
                  '${target?['level'] ?? 0}',
                  Icons.show_chart,
                  context,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n?.placer ?? 'Placer',
                  placer?['username'] ?? 'Unknown',
                  Icons.person_add,
                  context,
                ),
                const Divider(),
                _buildDetailRow(
                  l10n?.bounty ?? 'Bounty',
                  _formatMoney(bounty),
                  Icons.monetization_on,
                  context,
                  valueColor: Colors.amber,
                ),
                if (counterBounty != null && counterBounty > 0) ...[
                  const Divider(),
                  _buildDetailRow(
                    l10n?.counterBid ?? 'Counter-bid',
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
                            l10n?.counterBidPlaced ?? 'Counter-bid placed! The contract has been reversed.',
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
                        label: Text(l10n?.counterBountyTitle ?? 'Place Counter-Bounty'),
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
                    label: Text(l10n?.cancel ?? 'Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: onAttemptHit,
                    icon: const Icon(Icons.local_police),
                    label: Text(l10n?.executeHit ?? 'Execute Hit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
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
        Expanded(
          child: Text(label),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
