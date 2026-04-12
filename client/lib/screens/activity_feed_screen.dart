import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_activity.dart';
import '../services/auth_service.dart';
import '../providers/event_provider.dart';
import '../utils/avatar_helper.dart';
import 'player_profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../utils/top_right_notification.dart';

class ActivityFeedScreen extends StatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  State<ActivityFeedScreen> createState() => _ActivityFeedScreenState();
}

class _ActivityFeedScreenState extends State<ActivityFeedScreen> {
  List<PlayerActivity> _activities = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
    _listenToActivityEvents();
  }

  void _listenToActivityEvents() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.eventStreamService.eventStream.listen((event) {
      if (!mounted) return;
      
      if (event['event'] == 'player.activity') {
        // Refresh feed when new activity is detected
        _loadActivities();
      }
    });
  }

  Future<void> _loadActivities() async {
    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/activities/feed?limit=50');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final activitiesList = data['params']['activities'] as List;

        if (mounted) {
          setState(() {
            _activities = activitiesList
                .map((a) => PlayerActivity.fromJson(a))
                .toList();
          });
        }
      }
    } catch (e) {
      print('[ActivityFeed] Error loading: $e');
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('Failed to load activity feed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType) {
      case 'CRIME':
        return Icons.local_police;
      case 'JOB':
        return Icons.work;
      case 'RANK_UP':
        return Icons.trending_up;
      case 'LEVEL_UP':
        return Icons.stars;
      case 'PURCHASE':
        return Icons.shopping_bag;
      case 'HEIST':
        return Icons.shield;
      case 'TRAVEL':
        return Icons.flight;
      default:
        return Icons.info;
    }
  }

  Color _getActivityColor(String activityType) {
    switch (activityType) {
      case 'CRIME':
        return Colors.red;
      case 'JOB':
        return Colors.blue;
      case 'RANK_UP':
        return Colors.amber;
      case 'LEVEL_UP':
        return Colors.amber;
      case 'PURCHASE':
        return Colors.green;
      case 'HEIST':
        return Colors.purple;
      case 'TRAVEL':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  void _openPlayerProfile(ActivityPlayer player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerProfileScreen(playerId: player.id, username: player.username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Activity'),
        backgroundColor: const Color(0xFF1A1A2E),
      ),
      backgroundColor: const Color(0xFF0F0F1E),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _activities.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No friend activity yet',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add friends to see their activities',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadActivities,
                  child: ListView.builder(
                    itemCount: _activities.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final activity = _activities[index];
                      final player = activity.player;

                      if (player == null) return const SizedBox.shrink();

                      return Card(
                        color: const Color(0xFF16213E),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              GestureDetector(
                                onTap: () => _openPlayerProfile(player),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                        AvatarHelper.getAvatarPath(player.avatar),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () => _openPlayerProfile(player),
                                          child: Text(
                                            player.username,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Level ${player.rank}',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          _getActivityIcon(activity.activityType),
                                          size: 16,
                                          color: _getActivityColor(
                                            activity.activityType,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            activity.description,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      timeago.format(activity.createdAt),
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
