import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/prostitute.dart';
import '../services/prostitution_service.dart';
import 'player_profile_screen.dart';
import '../widgets/mobile_load_error.dart';

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
  String? _loadError;
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
        _loadError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadError =
            '${AppLocalizations.of(context)!.prostitutionLeaderboardLoadFailed}: $error';
      });
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
          isScrollable: true,
          tabs: [
            Tab(text: l10n.prostitutionLeaderboardWeekly),
            Tab(text: l10n.prostitutionLeaderboardMonthly),
            Tab(text: l10n.prostitutionLeaderboardAllTime),
          ],
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _loadError != null &&
                    _weekly.isEmpty &&
                    _monthly.isEmpty &&
                    _allTime.isEmpty
              ? MobileLoadError(message: _loadError!, onRetry: _loadAllData)
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
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.45)),
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
              color: Color(0xFFD4AF37),
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
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: entry.isCurrentPlayer
                  ? const Color(0xFFD4AF37).withOpacity(0.12)
                  : Colors.grey.shade900,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: entry.isCurrentPlayer
                    ? const Color(0xFFD4AF37).withOpacity(0.55)
                    : Colors.white24,
              ),
            ),
            child: ListTile(
              leading: Text(
                _rankIcon(entry.rank),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: GestureDetector(
                onTap: () =>
                    _openPlayerProfile(entry.playerId, entry.username),
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
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.prostitutionLeaderboardAchievements,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _achievements
                .take(6)
                .map(
                  (achievement) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withOpacity(0.35),
                      ),
                    ),
                    child: Text(
                      '🏆 ${achievement.displayName}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                )
                .toList(),
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
