import 'package:flutter/material.dart';

import '../services/territory_service.dart';
import '../utils/top_right_notification.dart';

// ---------------------------------------------------------------------------
// TerritoryScreen — Responsive crew territory map (NL-first)
// Layout: desktop = split (map | side panel), tablet = stacked collapsible,
//         mobile  = map card + action bottom sheet.
// ---------------------------------------------------------------------------

class TerritoryScreen extends StatefulWidget {
  const TerritoryScreen({super.key});

  @override
  State<TerritoryScreen> createState() => _TerritoryScreenState();
}

class _TerritoryScreenState extends State<TerritoryScreen>
    with SingleTickerProviderStateMixin {
  final TerritoryService _service = TerritoryService();

  bool _isLoading = true;
  bool _isTerritoryEnabled = false;

  // ── Data ──────────────────────────────────────────────────────────────────
  Map<String, dynamic> _mapData = {};
  List<dynamic> _leaderboard = [];
  Map<String, dynamic> _overview = {};

  // ── Selection ─────────────────────────────────────────────────────────────
  Map<String, dynamic>? _selectedRegion;
  bool _isActing = false;

  // ── Tabs ──────────────────────────────────────────────────────────────────
  late TabController _tabController;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _t(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final [mapData, overview, leaderboard] = await Future.wait([
      _service.getMap('nl'),
      _service.getOverview(),
      _service.getLeaderboard(),
    ]);

    if (!mounted) return;
    setState(() {
      _mapData = mapData as Map<String, dynamic>;
      _overview = overview as Map<String, dynamic>;
      _leaderboard = leaderboard as List<dynamic>;
      _isTerritoryEnabled =
          (_overview['config']?['enabled'] as bool?) ?? false;
      _isLoading = false;
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isTerritoryEnabled) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_t('Territorium', 'Territory')),
        ),
        body: Center(
          child: Text(
            _t('Territorium is momenteel niet beschikbaar.',
                'Territory is currently unavailable.'),
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('Territorium', 'Territory')),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: _t('Kaart', 'Map')),
            Tab(text: _t('Ranglijst', 'Leaderboard')),
            Tab(text: _t('Seizoen', 'Season')),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: _t('Vernieuwen', 'Refresh'),
            onPressed: _loadData,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMapTab(),
          _buildLeaderboardTab(),
          _buildSeasonTab(),
        ],
      ),
    );
  }

  // ── Map Tab ───────────────────────────────────────────────────────────────

  Widget _buildMapTab() {
    final regions = (_mapData['regions'] as List<dynamic>?) ?? [];

    return LayoutBuilder(builder: (context, constraints) {
      final isDesktop = constraints.maxWidth >= 900;
      final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;

      if (isDesktop) {
        return Row(
          children: [
            Expanded(flex: 3, child: _buildRegionGrid(regions)),
            const VerticalDivider(width: 1),
            SizedBox(
              width: 320,
              child: _selectedRegion != null
                  ? _buildRegionDetail(_selectedRegion!)
                  : _buildNoSelectionPlaceholder(),
            ),
          ],
        );
      }

      if (isTablet) {
        return Column(
          children: [
            Expanded(child: _buildRegionGrid(regions)),
            if (_selectedRegion != null)
              SizedBox(
                height: 280,
                child: _buildRegionDetail(_selectedRegion!),
              ),
          ],
        );
      }

      // Mobile
      return Stack(
        children: [
          _buildRegionGrid(regions),
          if (_selectedRegion != null)
            DraggableScrollableSheet(
              initialChildSize: 0.35,
              minChildSize: 0.15,
              maxChildSize: 0.65,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: const [BoxShadow(blurRadius: 8, spreadRadius: 2)],
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    _buildRegionDetail(_selectedRegion!),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildRegionGrid(List<dynamic> regions) {
    if (regions.isEmpty) {
      return Center(child: Text(_t('Geen regio\'s gevonden.', 'No regions found.')));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 120,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: regions.length,
        itemBuilder: (context, i) => _buildRegionCard(regions[i] as Map<String, dynamic>),
      ),
    );
  }

  Widget _buildRegionCard(Map<String, dynamic> region) {
    final regionName = _isNl
        ? (region['nameNl'] as String? ?? region['regionKey'] as String? ?? '')
        : (region['nameEn'] as String? ?? region['regionKey'] as String? ?? '');
    final ownerName = region['ownerCrewName'] as String?;
    final controlPercent = (region['controlPercent'] as num?)?.toInt() ?? 0;
    final contestStatus = region['contestStatus'] as String?;
    final isSelected = _selectedRegion?['regionKey'] == region['regionKey'];

    final Color statusColor = contestStatus != null
        ? Colors.orange
        : (ownerName != null ? Colors.green[700]! : Colors.grey[600]!);

    return GestureDetector(
      onTap: () => setState(() => _selectedRegion = region),
      child: Card(
        elevation: isSelected ? 6 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected
              ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(regionName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(
                ownerName ?? _t('Neutraal', 'Neutral'),
                style: TextStyle(color: statusColor, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (controlPercent > 0) ...[
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: controlPercent / 100,
                  color: statusColor,
                  backgroundColor: Colors.grey[300],
                  minHeight: 4,
                ),
              ],
              if (contestStatus != null) ...[
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.warning_amber_rounded, size: 12, color: Colors.orange),
                  const SizedBox(width: 2),
                  Text(
                    _t('In strijd', 'Under contest'),
                    style: const TextStyle(color: Colors.orange, fontSize: 10),
                  ),
                ]),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegionDetail(Map<String, dynamic> region) {
    final regionName = _isNl
        ? (region['nameNl'] as String? ?? '')
        : (region['nameEn'] as String? ?? '');
    final ownerName = region['ownerCrewName'] as String?;
    final stability = (region['stability'] as num?)?.toInt() ?? 100;
    final contestId = region['contestId'] as int?;
    final contestStatus = region['contestStatus'] as String?;
    final tier = (region['valueTier'] as num?)?.toInt() ?? 1;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Expanded(
              child: Text(regionName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => setState(() => _selectedRegion = null),
            ),
          ]),
          const SizedBox(height: 8),
          _detailRow(
            _t('Eigenaar', 'Owner'),
            ownerName ?? _t('Neutraal', 'Neutral'),
          ),
          _detailRow(
            _t('Stabiliteit', 'Stability'),
            '$stability%',
          ),
          _detailRow(
            _t('Waarde', 'Value tier'),
            '⭐' * tier,
          ),
          if (contestStatus != null)
            _detailRow(
              _t('Contest status', 'Contest status'),
              contestStatus,
            ),
          const SizedBox(height: 16),
          // Actions
          if (contestStatus == null)
            _buildActionButton(
              label: _t('Aanvallen', 'Attack'),
              icon: Icons.gps_fixed,
              color: Colors.red[700]!,
              onTap: () => _confirmStartContest(region['regionKey'] as String),
            ),
          if (contestId != null && contestStatus == 'active') ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _smallActionButton(_t('Patrouille', 'Patrol'), 'patrol', contestId),
                _smallActionButton(_t('Sabotage', 'Sabotage'), 'sabotage', contestId),
                _smallActionButton(_t('Inval', 'Raid'), 'raid', contestId),
                _smallActionButton(_t('Verdedigen', 'Defense'), 'defense', contestId),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
        onPressed: _isActing ? null : onTap,
      ),
    );
  }

  Widget _smallActionButton(String label, String actionType, int contestId) {
    return OutlinedButton(
      onPressed: _isActing ? null : () => _doAction(contestId, actionType),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildNoSelectionPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          _t('Selecteer een regio op de kaart.', 'Select a region on the map.'),
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // ── Leaderboard Tab ────────────────────────────────────────────────────────

  Widget _buildLeaderboardTab() {
    if (_leaderboard.isEmpty) {
      return Center(
        child: Text(_t('Nog geen territorium gecontroleerd.', 'No territory controlled yet.')),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _leaderboard.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final entry = _leaderboard[i] as Map<String, dynamic>;
        return ListTile(
          leading: CircleAvatar(
            child: Text('${i + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          title: Text(entry['crewName'] as String? ?? ''),
          trailing: Text(
            '${entry['regionsOwned']} ${_t('regio\'s', 'regions')}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  // ── Season Tab ─────────────────────────────────────────────────────────────

  Widget _buildSeasonTab() {
    final season = _overview['activeSeason'] as Map<String, dynamic>?;
    if (season == null) {
      return Center(
        child: Text(_t('Geen actief seizoen gevonden.', 'No active season found.')),
      );
    }

    final key = season['seasonKey'] as String? ?? '';
    final status = season['status'] as String? ?? '';
    final startsAt = season['startsAt'] as String? ?? '';
    final endsAt = season['endsAt'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_t('Huidig seizoen', 'Current season'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _detailRow(_t('Sleutel', 'Key'), key),
          _detailRow(_t('Status', 'Status'), status),
          _detailRow(_t('Start', 'Start'), startsAt),
          _detailRow(_t('Einde', 'End'), endsAt),
        ],
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _confirmStartContest(String regionKey) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(_t('Aanvallen?', 'Attack?')),
        content: Text(
            _t('Wil je een contest starten voor $regionKey?',
                'Start a contest for $regionKey?')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_t('Annuleer', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_t('Aanvallen', 'Attack')),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isActing = true);
    final result = await _service.startContest(regionKey);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      showTopRightNotification(
          context, _t('Contest gestart!', 'Contest started!'));
      await _loadData();
    } else {
      showTopRightNotification(
          context,
          _t('Mislukt: ${result['event'] ?? result['message']}',
              'Failed: ${result['event'] ?? result['message']}'));
    }
  }

  Future<void> _doAction(int contestId, String actionType) async {
    setState(() => _isActing = true);
    final result = await _service.doAction(contestId, actionType);
    if (!mounted) return;
    setState(() => _isActing = false);

    if (result['success'] == true) {
      final pts = result['pointsDelta'] ?? 0;
      showTopRightNotification(
          context, _t('+$pts punten!', '+$pts points!'));
      await _loadData();
    } else {
      showTopRightNotification(
          context,
          _t('Actie mislukt: ${result['event'] ?? result['message']}',
              'Action failed: ${result['event'] ?? result['message']}'));
    }
  }
}
