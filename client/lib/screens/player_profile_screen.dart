import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../l10n/app_localizations.dart';
import '../config/app_config.dart';
import '../models/vehicle.dart';
import '../screens/crew_screen.dart';
import '../utils/achievement_display.dart';
import '../utils/avatar_helper.dart';
import '../utils/game_event_rewards.dart';
import '../utils/property_display.dart';
import '../utils/rank_display.dart';
import '../utils/top_right_notification.dart';
import '../utils/web_asset_helper.dart';

class PlayerProfileScreen extends StatefulWidget {
  final int playerId;
  final String username;
  final bool embedded;

  const PlayerProfileScreen({
    super.key,
    required this.playerId,
    required this.username,
    this.embedded = false,
  });

  @override
  State<PlayerProfileScreen> createState() => _PlayerProfileScreenState();
}

class _PlayerProfileScreenState extends State<PlayerProfileScreen> {
  bool _isLoading = true;
  bool _isLiking = false;
  Map<String, dynamic>? _playerData;
  List<VehicleInventoryItem> _playerListings = [];
  String? _error;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  String _rankLabel() {
    final rankNumber =
        ((_playerData?['rank'] ?? _playerData?['level'] ?? 0) as num).toInt();
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return '${_playerData?['rankIcon'] ?? '❓'} ${_playerData?['rankTitle'] ?? _tr('Onbekend', 'Unknown')}';
    }
    return RankDisplay.withIcon(l10n, rankNumber);
  }

  int get _likesCount => (_playerData?['likesCount'] as num?)?.toInt() ?? 0;
  bool get _viewerHasLiked => _playerData?['viewerHasLiked'] == true;

  String _formatNumber(num value) {
    final raw = value.toInt().toString();
    return raw.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  String _formatCurrency(num value) => '€${_formatNumber(value)}';

  String _formatStartDate(dynamic value) {
    if (value == null) return '-';
    final parsed = DateTime.tryParse(value.toString());
    if (parsed == null) return value.toString();
    final local = parsed.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    return '$day-$month-$year';
  }

  String _onlineText() {
    final isOnlineNow = _playerData?['isOnlineNow'] == true;
    if (isOnlineNow) {
      return _tr('Nu online', 'Online now');
    }

    final seconds =
        (_playerData?['secondsSinceLastSeen'] as num?)?.toInt() ?? 0;
    if (seconds < 60) {
      return _tr('$seconds sec geleden', '$seconds sec ago');
    }

    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      return _tr('$minutes min geleden', '$minutes min ago');
    }

    final hours = minutes ~/ 60;
    if (hours < 24) {
      return _tr('$hours uur geleden', '$hours h ago');
    }

    final days = hours ~/ 24;
    return _tr('$days d geleden', '$days d ago');
  }

  String _aliveText() {
    final isAlive = _playerData?['isAlive'] == true;
    return isAlive ? _tr('Levend', 'Alive') : _tr('Dood', 'Dead');
  }

  @override
  void initState() {
    super.initState();
    _loadPlayerProfile();
  }

  Future<void> _loadPlayerProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        setState(() {
          _error = _tr('Niet ingelogd', 'Not logged in');
          _isLoading = false;
        });
        return;
      }

      final profileResponse = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/player/${widget.playerId}/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (profileResponse.statusCode == 200) {
        _playerData = jsonDecode(profileResponse.body) as Map<String, dynamic>;
      } else {
        setState(() {
          _error = _tr(
            'Profiel kon niet worden geladen (${profileResponse.statusCode})',
            'Failed to load profile (${profileResponse.statusCode})',
          );
          _isLoading = false;
        });
        return;
      }

      try {
        final listingsResponse = await http.get(
          Uri.parse(
            '${AppConfig.apiBaseUrl}/market/player/${widget.playerId}/listings',
          ),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (listingsResponse.statusCode == 200) {
          final data =
              jsonDecode(listingsResponse.body) as Map<String, dynamic>;
          final dynamic listings = data['listings'];
          if (listings is List) {
            _playerListings = listings
                .whereType<Map<String, dynamic>>()
                .map(VehicleInventoryItem.fromJson)
                .toList();
          }
        }
      } catch (_) {
        // Optional data; profile blijft bruikbaar.
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = _tr('Fout bij laden: $e', 'Load error: $e');
        _isLoading = false;
      });
    }
  }

  Future<void> _likeProfile() async {
    if (_viewerHasLiked || _isLiking) {
      return;
    }

    setState(() => _isLiking = true);

    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(_tr('Niet ingelogd', 'Not logged in')),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final response = await http.post(
        Uri.parse(
          '${AppConfig.apiBaseUrl}/player/${widget.playerId}/profile/like',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _playerData = {
            ...?_playerData,
            'viewerHasLiked': true,
            'likesCount':
                (payload['likesCount'] as num?)?.toInt() ?? _likesCount,
          };
        });
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_tr('Like gegeven!', 'Like sent!')),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 409) {
        final payload = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          _playerData = {
            ...?_playerData,
            'viewerHasLiked': true,
            'likesCount':
                (payload['likesCount'] as num?)?.toInt() ?? _likesCount,
          };
        });
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _tr(
                'Je hebt dit profiel al geliked.',
                'You already liked this profile.',
              ),
            ),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_tr('Like mislukt', 'Like failed')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_tr('Like mislukt: $e', 'Like failed: $e')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }

  Future<void> _buyVehicleFromProfile(VehicleInventoryItem vehicle) async {
    try {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'auth_token');

      if (token == null) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(_tr('Niet ingelogd', 'Not logged in')),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/market/buy/${vehicle.id}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _tr(
                'Voertuig succesvol gekocht!',
                'Vehicle purchased successfully!',
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadPlayerProfile();
      } else if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              data['params']?['reason']?.toString() ??
                  _tr('Aankoop mislukt', 'Purchase failed'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent();

    if (widget.embedded) {
      return Material(
        color: Colors.transparent,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: content,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPlayerProfile,
            tooltip: _tr('Ververs', 'Refresh'),
          ),
        ],
      ),
      body: content,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.redAccent),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loadPlayerProfile,
              child: Text(_tr('Opnieuw proberen', 'Retry')),
            ),
          ],
        ),
      );
    }

    final body = RefreshIndicator(
      onRefresh: _loadPlayerProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: [
          _buildHeroCard(),
          const SizedBox(height: 12),
          _buildIdentityCard(),
          const SizedBox(height: 12),
          _buildAchievementsCard(),
          const SizedBox(height: 12),
          _buildEventChipsCard(),
          const SizedBox(height: 12),
          _buildPropertiesCard(),
          const SizedBox(height: 12),
          _buildEconomyCard(),
          const SizedBox(height: 12),
          _buildListingsCard(),
        ],
      ),
    );

    if (widget.embedded) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF151619),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: body,
        ),
      );
    }

    return body;
  }

  Widget _buildHeroCard() {
    final avatar =
        (_playerData?['avatar']?.toString().trim().isNotEmpty == true)
        ? _playerData!['avatar'].toString()
        : 'default_1';
    final activePortraitPath =
        _playerData?['activePortraitPath']?.toString().trim();
    final isVip = _playerData?['isVip'] == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.25),
            Colors.orange.withOpacity(0.16),
            Colors.black.withOpacity(0.24),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundImage: AvatarHelper.getAvatarImageProvider(
                  avatar,
                  activePortraitPath:
                      (activePortraitPath != null && activePortraitPath.isNotEmpty)
                      ? activePortraitPath
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _rankLabel(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Builder(
                builder: (context) {
                  final tier = (_playerData?['vipPrestigeTier'] ?? 'none')
                      .toString()
                      .toLowerCase();
                  final tierLabel = switch (tier) {
                    'bronze' => _tr('Brons', 'Bronze'),
                    'silver' => _tr('Zilver', 'Silver'),
                    'gold' => _tr('Goud', 'Gold'),
                    _ => '',
                  };
                  if (!isVip && tierLabel.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  final badgeText = isVip && tierLabel.isNotEmpty
                      ? 'VIP · $tierLabel'
                      : (isVip ? _tr('VIP', 'VIP') : 'VIP · $tierLabel');
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.amber.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          badgeText,
                          style: const TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _buildMetricPill(
                icon: Icons.favorite,
                label: _tr('Likes', 'Likes'),
                value: _likesCount.toString(),
                color: Colors.pinkAccent,
              ),
              const SizedBox(width: 8),
              _buildMetricPill(
                icon: Icons.verified,
                label: _tr('Reputatie', 'Reputation'),
                value: (_playerData?['reputation'] ?? 0).toString(),
                color: Colors.lightBlueAccent,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _viewerHasLiked || _isLiking ? null : _likeProfile,
                icon: _isLiking
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _viewerHasLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                label: Text(
                  _viewerHasLiked
                      ? _tr('Geliked', 'Liked')
                      : _tr('Like', 'Like'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text('$label: $value'),
        ],
      ),
    );
  }

  Widget _buildIdentityCard() {
    final rankNumber =
        ((_playerData?['rank'] ?? _playerData?['level'] ?? 0) as num).toInt();
    final reputation = (_playerData?['reputation'] ?? 0).toString();
    final rank = '#$rankNumber • ${_rankLabel()}';
    final vip = (_playerData?['vip'] == true || _playerData?['isVip'] == true)
        ? _tr('Ja', 'Yes')
        : _tr('Nee', 'No');
    final rawCrewName = _playerData?['crewName'];
    final crewRole = _playerData?['crewRole']?.toString();
    final crewName = ((rawCrewName?.toString().trim().isNotEmpty) ?? false)
        ? rawCrewName.toString()
        : _tr('Geen crew', 'No crew');

    final crewDisplay = (crewRole != null && crewRole.trim().isNotEmpty)
        ? '$crewName (${_tr('rol', 'role')}: $crewRole)'
        : crewName;

    return _sectionCard(
      title: _tr('Identiteit', 'Identity'),
      child: Column(
        children: [
          InkWell(
            onTap: (_playerData?['crewId'] as num?) != null
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CrewScreen()),
                    );
                  }
                : null,
            child: _statTile(_tr('Crew', 'Crew'), crewDisplay, Icons.group),
          ),
          _divider(),
          _statTile(_tr('Rank', 'Rank'), rank, Icons.military_tech),
          _divider(),
          _statTile(_tr('Reputatie', 'Reputation'), reputation, Icons.shield),
          _divider(),
          _statTile(_tr('Status', 'Status'), _aliveText(), Icons.favorite),
          _divider(),
          _statTile(
            _tr('Online', 'Online'),
            _onlineText(),
            Icons.wifi_tethering,
          ),
          _divider(),
          _statTile(
            _tr('Start datum', 'Start date'),
            _formatStartDate(_playerData?['startDate']),
            Icons.calendar_month,
          ),
          _divider(),
          _statTile(_tr('VIP', 'VIP'), vip, Icons.workspace_premium),
          _divider(),
          _statTile(
            _tr('Aantal likes', 'Likes'),
            _likesCount.toString(),
            Icons.favorite_border,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _unlockedAchievementRows() {
    final raw = _playerData?['unlockedAchievements'];
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .where((row) => (row['id']?.toString() ?? '').isNotEmpty)
          .toList();
    }
    final featured = _playerData?['featuredAchievements'];
    if (featured is List) {
      return featured
          .whereType<Map>()
          .map((row) => Map<String, dynamic>.from(row))
          .where((row) => (row['id']?.toString() ?? '').isNotEmpty)
          .toList();
    }
    return const <Map<String, dynamic>>[];
  }

  List<String> _orderedAchievementCategories(Iterable<String> categories) {
    final unique = categories.toSet();
    final ordered = <String>[];
    for (final category in kAchievementCategoryOrder) {
      if (unique.remove(category)) {
        ordered.add(category);
      }
    }
    ordered.addAll(unique);
    return ordered;
  }

  Widget _buildAchievementsCard() {
    final l10n = AppLocalizations.of(context)!;
    final items = _unlockedAchievementRows();
    final byCategory = <String, List<Map<String, dynamic>>>{};
    for (final item in items) {
      final category = (item['category']?.toString().isNotEmpty ?? false)
          ? item['category'].toString()
          : 'legacy';
      byCategory.putIfAbsent(category, () => []).add(item);
    }
    final categories = _orderedAchievementCategories(byCategory.keys);

    return _sectionCard(
      title: l10n.profileAchievementsTitle,
      trailing: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.18),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.amber.withOpacity(0.35)),
              ),
              child: Text(
                l10n.profileAchievementsCount(items.length.toString()),
                style: const TextStyle(
                  color: Color(0xFFFFD54F),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
      child: items.isEmpty
          ? Text(
              l10n.profileAchievementsEmpty,
              style: const TextStyle(color: Colors.white70),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileAchievementsHint,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                for (var i = 0; i < categories.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  Text(
                    localizedAchievementCategory(l10n, categories[i]),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final item in byCategory[categories[i]]!)
                        _profileAchievementBadge(item),
                    ],
                  ),
                ],
              ],
            ),
    );
  }

  Widget _profileAchievementBadge(Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context)!;
    final id = item['id']?.toString() ?? '';
    final category = item['category']?.toString() ?? 'legacy';
    final title = localizedAchievementTitle(
      l10n,
      id,
      item['title']?.toString(),
    );
    return Tooltip(
      message: title,
      child: InkWell(
        onTap: () => _showProfileAchievement(item),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 64,
          height: 70,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.28)),
          ),
          alignment: Alignment.center,
          child: achievementBadgeImage(
            id: id,
            category: category,
            fallbackIcon: item['icon']?.toString(),
            width: 52,
            height: 58,
          ),
        ),
      ),
    );
  }

  Future<void> _showProfileAchievement(Map<String, dynamic> item) async {
    final l10n = AppLocalizations.of(context)!;
    final id = item['id']?.toString() ?? '';
    final category = item['category']?.toString() ?? 'legacy';
    final title = localizedAchievementTitle(
      l10n,
      id,
      item['title']?.toString(),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1C20),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            achievementBadgeImage(
              id: id,
              category: category,
              fallbackIcon: item['icon']?.toString(),
              width: 96,
              height: 108,
            ),
            const SizedBox(height: 12),
            Text(
              localizedAchievementCategory(l10n, category),
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _eventChipRows() {
    const keys = [
      'event_chip_gold',
      'event_chip_silver',
      'event_chip_bronze',
    ];
    final raw = _playerData?['eventChips'];
    final listed = raw is List
        ? raw.whereType<Map>().map((row) => Map<String, dynamic>.from(row)).toList()
        : const <Map<String, dynamic>>[];
    final byKey = {for (final row in listed) row['itemKey']?.toString(): row};
    return keys
        .map(
          (key) => {
            'itemKey': key,
            'quantity': (byKey[key]?['quantity'] as num?)?.toInt() ?? 0,
          },
        )
        .toList();
  }

  Color _chipMetalColor(String itemKey) {
    switch (itemKey) {
      case 'event_chip_gold':
        return const Color(0xFFE0B44A);
      case 'event_chip_silver':
        return const Color(0xFFC0C7D1);
      default:
        return const Color(0xFFCD7F32);
    }
  }

  Widget _buildEventChipsCard() {
    final l10n = AppLocalizations.of(context)!;
    final chips = _eventChipRows();
    return _sectionCard(
      title: l10n.profileEventChipsTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.profileEventChipsHint,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < chips.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _eventChipTile(chips[i])),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _eventChipTile(Map<String, dynamic> chip) {
    final l10n = AppLocalizations.of(context)!;
    final itemKey = chip['itemKey']?.toString() ?? '';
    final quantity = (chip['quantity'] as num?)?.toInt() ?? 0;
    final color = _chipMetalColor(itemKey);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        children: [
          Icon(Icons.workspace_premium, color: color),
          const SizedBox(height: 6),
          Text(
            eventItemDisplayName(l10n, itemKey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            quantity.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _ownedPropertyRows() {
    final raw = _playerData?['ownedProperties'];
    if (raw is! List) return const <Map<String, dynamic>>[];
    final rows = raw
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .where((row) {
          final type = row['propertyType']?.toString() ?? '';
          return kPublicPropertyTypeOrder.contains(type);
        })
        .toList();
    rows.sort((a, b) {
      final aType = a['propertyType']?.toString() ?? '';
      final bType = b['propertyType']?.toString() ?? '';
      final aOrder = kPublicPropertyTypeOrder.indexOf(aType);
      final bOrder = kPublicPropertyTypeOrder.indexOf(bType);
      if (aOrder != bOrder) return aOrder.compareTo(bOrder);
      final aLevel = (a['upgradeLevel'] as num?)?.toInt() ?? 1;
      final bLevel = (b['upgradeLevel'] as num?)?.toInt() ?? 1;
      return bLevel.compareTo(aLevel);
    });
    return rows;
  }

  Widget _buildPropertiesCard() {
    final l10n = AppLocalizations.of(context)!;
    final items = _ownedPropertyRows();
    return _sectionCard(
      title: l10n.profilePropertiesTitle,
      trailing: items.isEmpty
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('${items.length}'),
            ),
      child: items.isEmpty
          ? Text(
              l10n.profilePropertiesEmpty,
              style: const TextStyle(color: Colors.white70),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profilePropertiesHint,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in items) _profilePropertyTile(item),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _profilePropertyTile(Map<String, dynamic> item) {
    final l10n = AppLocalizations.of(context)!;
    final type = item['propertyType']?.toString() ?? '';
    final level = (item['upgradeLevel'] as num?)?.toInt() ?? 1;
    final name = localizedPropertyName(l10n, type);
    final imagePath = propertyCatalogAssetPath(type);
    return Container(
      width: 148,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 88,
            child: imagePath == null
                ? const Icon(Icons.home_work, color: Colors.white54, size: 36)
                : WebAssetHelper.image(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 88,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.home_work,
                      color: Colors.white54,
                      size: 36,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.propertyLevel(level.toString()),
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEconomyCard() {
    final cashMoney = _formatCurrency((_playerData?['cashMoney'] as num?) ?? 0);
    final bankMoney = _formatCurrency((_playerData?['bankMoney'] as num?) ?? 0);
    final prostitutesCount = ((_playerData?['prostitutesCount'] as num?) ?? 0)
        .toInt()
        .toString();
    final propertiesCount = ((_playerData?['propertiesCount'] as num?) ?? 0)
        .toInt()
        .toString();

    return _sectionCard(
      title: _tr('Economie', 'Economy'),
      child: Column(
        children: [
          _statTile(
            _tr('Contant geld', 'Cash money'),
            cashMoney,
            Icons.payments,
          ),
          _divider(),
          _statTile(
            _tr('Geld op de bank', 'Money in bank'),
            bankMoney,
            Icons.account_balance,
          ),
          _divider(),
          _statTile(
            _tr('Aantal hoeren', 'Number of prostitutes'),
            prostitutesCount,
            Icons.person,
          ),
          _divider(),
          _statTile(
            _tr('Aantal woningen', 'Number of properties'),
            propertiesCount,
            Icons.home,
          ),
        ],
      ),
    );
  }

  Widget _buildListingsCard() {
    return _sectionCard(
      title: _tr('Te koop', 'For sale'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text('${_playerListings.length}'),
      ),
      child: _playerListings.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                _tr('Geen voertuigen te koop', 'No vehicles for sale'),
                style: const TextStyle(color: Colors.white70),
              ),
            )
          : Column(
              children: _playerListings
                  .map(
                    (listing) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _listingTile(listing),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _listingTile(VehicleInventoryItem vehicle) {
    final selectedImage = vehicle.conditionImage;
    final askingPrice = vehicle.askingPrice ?? 0;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8),
            ),
            child: selectedImage != null
                ? Image.asset(
                    'assets/images/vehicles/$selectedImage',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      vehicle.vehicleType == 'car'
                          ? Icons.directions_car
                          : Icons.directions_boat,
                      color: Colors.white54,
                    ),
                  )
                : Icon(
                    vehicle.vehicleType == 'car'
                        ? Icons.directions_car
                        : Icons.directions_boat,
                    color: Colors.white54,
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.definition?.name ??
                      _tr('Onbekend voertuig', 'Unknown vehicle'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '€${askingPrice.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.greenAccent),
                ),
                Text(
                  '${_tr('Conditie', 'Condition')}: ${vehicle.condition.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => _buyVehicleFromProfile(vehicle),
            child: Text(_tr('Koop', 'Buy')),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              ?trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _statTile(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.white70),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Divider(height: 1, color: Colors.white12),
  );
}
