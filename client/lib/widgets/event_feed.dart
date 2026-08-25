import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../services/event_renderer.dart';
import '../l10n/app_localizations.dart';

import '../utils/world_event_feed_filter.dart';

/// Widget that displays the player's personal activity feed
class EventFeed extends StatelessWidget {
  final int maxEvents;

  const EventFeed({
    super.key,
    this.maxEvents = 20,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final renderer = EventRenderer(l10n);

    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        // Show connection status
        if (!eventProvider.isConnected && eventProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.signal_wifi_off, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  l10n.eventFeedDisconnected,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.eventFeedReconnecting,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }

        // Show empty state
        if (eventProvider.events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  eventProvider.isConnected ? Icons.check_circle : Icons.hourglass_empty,
                  size: 48,
                  color: eventProvider.isConnected ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  eventProvider.isConnected
                      ? l10n.eventFeedConnectedWaiting
                      : l10n.eventFeedConnecting,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        // Show events
        final displayEvents = eventProvider.events
            .where((event) => isPersonalDashboardFeedEvent(event.eventKey))
            .take(maxEvents)
            .toList();

        if (displayEvents.isEmpty) {
          return Center(
            child: Text(
              eventProvider.isConnected
                  ? l10n.eventFeedConnectedWaiting
                  : l10n.eventFeedConnecting,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: displayEvents.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final event = displayEvents[index];
            final message = renderer.renderEvent(event.eventKey, event.params);
            final timeAgo = _formatTimeAgo(l10n, event.timestamp);

            return ListTile(
              dense: true,
              leading: _getEventIcon(event.eventKey),
              title: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Get icon for event type
  Widget _getEventIcon(String eventKey) {
    IconData icon;
    Color color;

    if (eventKey.startsWith('crime.')) {
      icon = Icons.warning;
      color = Colors.orange;
    } else if (eventKey.startsWith('job.')) {
      icon = Icons.work;
      color = Colors.blue;
    } else if (eventKey.startsWith('travel.')) {
      icon = Icons.flight;
      color = Colors.purple;
    } else if (eventKey.startsWith('hospital.')) {
      icon = Icons.local_hospital;
      color = Colors.red;
    } else if (eventKey.startsWith('police.')) {
      icon = Icons.local_police;
      color = Colors.indigo;
    } else if (eventKey.startsWith('crew.')) {
      icon = Icons.groups;
      color = Colors.green;
    } else if (eventKey.startsWith('bank.')) {
      icon = Icons.account_balance;
      color = Colors.teal;
    } else if (eventKey.startsWith('connection.')) {
      icon = Icons.wifi;
      color = Colors.green;
    } else {
      icon = Icons.info;
      color = Colors.grey;
    }

    return Icon(icon, size: 20, color: color);
  }

  /// Format timestamp as relative time
  String _formatTimeAgo(AppLocalizations l10n, DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return l10n.supportTimeJustNow;
    } else if (difference.inMinutes < 60) {
      return l10n.supportTimeMinutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.supportTimeHoursAgo(difference.inHours);
    } else {
      return l10n.supportTimeDaysAgo(difference.inDays);
    }
  }
}
