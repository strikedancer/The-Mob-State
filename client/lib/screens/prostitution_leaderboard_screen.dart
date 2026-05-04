import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/prostitute.dart';
import '../services/prostitution_service.dart';
import '../utils/top_right_notification.dart';
import 'player_profile_screen.dart';

class ProstitutionLeaderboardScreen extends StatefulWidget {
  const ProstitutionLeaderboardScreen({super.key});

  @override
  State<ProstitutionLeaderboardScreen> createState() =>
      _ProstitutionLeaderboardScreenState();
}

class _ProstitutionLeaderboardScreenState
    extends State<ProstitutionLeaderboardScreen>
    with SingleTickerProviderStateMixin {
  final ProstitutionService _service = ProstitutionService();

  late TabController _tabController;
  bool _isLoading = true;
  List<LeaderboardEntry> _weekly = [];
  List<LeaderboardEntry> _monthly = [];
  List<LeaderboardEntry> _allTime = [];
  Map<String, dynamic>? _myWeeklyRank;
  List<ProstitutionAchievement> _achievements = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAllData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  Future<void> _loadAllData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _service.getLeaderboard('weekly', limit: 50),
        _service.getLeaderboard('monthly', limit: 50),
        _service.getLeaderboard('all_time', limit: 50),
        _service.getMyRank('weekly'),
        _service.getAchievements(),
      ]);

      final weeklyData = results[0];
      final monthlyData = results[1];
      final allTimeData = results[2];
      final myRankData = results[3];
      final achievementsData = results[4];

      setState(() {
        _weekly = _parseLeaderboard(weeklyData['leaderboard']);
        _monthly = _parseLeaderboard(monthlyData['leaderboard']);
        _allTime = _parseLeaderboard(allTimeData['leaderboard']);
        _myWeeklyRank = myRankData;
        _achievements = _parseAchievements(achievementsData['achievements']);
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${l10n.prostitutionLeaderboardLoadFailed}: $error'),
          ),
        );
      }
    }
  }

  List<LeaderboardEntry> _parseLeaderboard(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map<String, dynamic>>()
        .map(LeaderboardEntry.fromJson)
        .toList();
  }

  List<ProstitutionAchievement> _parseAchievements(dynamic value) {
    if (value is! List) return [];
    return value
        .whereType<Map<String, dynamic>>()
        .map(ProstitutionAchievement.fromJson)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        if (_myWeeklyRank != null) _buildMyRankCard(),
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.prostitutionLeaderboardWeekly),
            Tab(text: l10n.prostitutionLeaderboardMonthly),
            Tab(text: l10n.prostitutionLeaderboardAllTime),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLeaderboardList(_weekly),
                    _buildLeaderboardList(_monthly),
                    _buildLeaderboardList(_allTime),
                  ],
                ),
        ),
        if (_achievements.isNotEmpty) _buildAchievementsSection(),
      ],
    );
  }

  Widget _buildMyRankCard() {
    final l10n = AppLocalizations.of(context)!;
    final rank = _myWeeklyRank?['rank'];
    final total = _myWeeklyRank?['totalPlayers'];

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.prostitutionLeaderboardYourRank,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            rank != null
                ? '#$rank / $total'
                : l10n.prostitutionLeaderboardUnranked,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    final l10n = AppLocalizations.of(context)!;

    if (entries.isEmpty) {
      return Center(child: Text(l10n.prostitutionLeaderboardNoData));
    }

    return RefreshIndicator(
      onRefresh: _loadAllData,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return Card(
            color: entry.isCurrentPlayer ? Colors.amber.withOpacity(0.2) : null,
            child: ListTile(
              leading: Text(
                _rankIcon(entry.rank),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: GestureDetector(
                onTap: () => _openPlayerProfile(entry.playerId, entry.username),
                child: Text(
                  entry.username,
                  style: const TextStyle(color: Colors.lightBlue),
                ),
              ),
              subtitle: Text(
                '${entry.totalProstitutes} ${l10n.prostitutionLeaderboardProstitutesUnit} • ${entry.totalDistricts} ${l10n.prostitutionLeaderboardDistrictsUnit} • L${entry.highestLevel}',
              ),
              trailing: Text(
                entry.earningsText,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.prostitutionLeaderboardAchievements,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ..._achievements
              .take(3)
              .map(
                (achievement) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('🏆 ${achievement.displayName}'),
                ),
              ),
        ],
      ),
    );
  }

  String _rankIcon(int rank) {
    if (rank == 1) return '🥇';
    if (rank == 2) return '🥈';
    if (rank == 3) return '🥉';
    return '#$rank';
  }
}
