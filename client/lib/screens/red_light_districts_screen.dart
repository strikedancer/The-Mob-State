import 'package:flutter/material.dart';
import '../models/prostitute.dart';
import '../models/achievement.dart';
import '../services/prostitution_service.dart';
import '../utils/achievement_notifier.dart';
import 'red_light_district_detail_screen.dart';
import 'player_profile_screen.dart';

import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class RedLightDistrictsScreen extends StatefulWidget {
  final bool embedded;

  const RedLightDistrictsScreen({super.key, this.embedded = false});

  @override
  State<RedLightDistrictsScreen> createState() =>
      _RedLightDistrictsScreenState();
}

class _RedLightDistrictsScreenState extends State<RedLightDistrictsScreen>
    with SingleTickerProviderStateMixin {
  final ProstitutionService _service = ProstitutionService();
  List<RedLightDistrict> _ownedDistricts = [];
  RedLightDistrict? _currentCountryDistrict;
  bool _isLoading = true;
  int? _selectedDistrictId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rebuild to update title
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final owned = await _service.getMyDistricts();
    final playerResult = await _service.getCurrentPlayer();

    RedLightDistrict? currentCountryDistrict;
    if (playerResult['success'] == true) {
      final player = playerResult['player'] as Map<String, dynamic>?;
      final currentCountry =
          (player?['currentCountry'] ?? player?['current_country'])
              ?.toString()
              .trim()
              .toLowerCase();

      if (currentCountry != null && currentCountry.isNotEmpty) {
        currentCountryDistrict = await _service.getDistrictByCountry(
          currentCountry,
        );
      }
    }

    setState(() {
      _ownedDistricts = owned;
      _currentCountryDistrict = currentCountryDistrict;
      _isLoading = false;
    });
  }

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  Future<void> _purchaseDistrict(RedLightDistrict district) async {
    final l10n = AppLocalizations.of(context)!;

    // Confirm purchase
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.prostitutionPurchase,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.prostitutionPurchaseConfirmMessage(
                district.countryCode,
                district.purchasePrice,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.prostitutionPurchase),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await _service.purchaseDistrict(district.countryCode);

    if (result['success'] == true) {
      await _loadData();

      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              result['message'] ?? l10n.prostitutionPurchaseSuccess,
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Show achievements from response if any
        final newAchievements = result['newAchievements'] as List<Achievement>?;
        if (newAchievements != null && newAchievements.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            AchievementNotifier.showMultipleAchievements(
              context,
              newAchievements,
            );
          }
        }
      }
    } else {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(result['message'] ?? l10n.prostitutionPurchaseFailed),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getCountryName(String countryCode) {
    final names = {
      'netherlands': 'Nederland',
      'belgium': 'België',
      'germany': 'Duitsland',
      'france': 'Frankrijk',
      'spain': 'Spanje',
      'italy': 'Italië',
      'uk': 'Verenigd Koninkrijk',
      'usa': 'Verenigde Staten',
      'mexico': 'Mexico',
      'colombia': 'Colombia',
      'brazil': 'Brazilië',
      'argentina': 'Argentinië',
      'russia': 'Rusland',
      'turkey': 'Turkije',
      'thailand': 'Thailand',
      'japan': 'Japan',
      'china': 'China',
      'australia': 'Australië',
      'southafrica': 'Zuid-Afrika',
      'dubai': 'Dubai',
    };
    return names[countryCode] ?? countryCode;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final body = _selectedDistrictId != null
        ? RedLightDistrictDetailScreen(
            districtId: _selectedDistrictId!,
            embedded: true,
            onBack: () {
              setState(() => _selectedDistrictId = null);
              _loadData();
            },
          )
        : Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: l10n.prostitutionCurrentRLD),
                  Tab(text: l10n.prostitutionMyRLDs),
                ],
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabController,
                        children: [_buildAvailableTab(), _buildOwnedTab()],
                      ),
              ),
            ],
          );

    if (widget.embedded) {
      return body;
    }

    // Dynamic title based on active tab
    String title = l10n.prostitutionRedLightDistricts;
    if (_tabController.index == 0 && _currentCountryDistrict != null) {
      final countryName = _getCountryName(_currentCountryDistrict!.countryCode);
      title = 'Red Light District ($countryName)';
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }

  Widget _buildAvailableTab() {
    final l10n = AppLocalizations.of(context)!;

    if (_currentCountryDistrict == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.prostitutionDistrictNotFound,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    final district = _currentCountryDistrict!;
    final isAvailable = district.ownerId == null;
    final hasStats = district.stats != null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with building visual
            Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Building visual representation
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/prostitution/buildings/rld_building_exterior.png',
                        ),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  // District status
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isAvailable
                            ? Colors.orange.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAvailable
                            ? l10n.prostitutionAvailable
                            : 'In eigendom',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isAvailable ? Colors.orange : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // District info
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Owner
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.purple, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Eigenaar:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: district.ownerId != null
                                ? () => _openPlayerProfile(
                                    district.ownerId!,
                                    district.owner!['username'] as String? ??
                                        'Onbekend',
                                  )
                                : null,
                            child: Text(
                              district.owner != null
                                  ? (district.owner!['username'] as String? ??
                                        'Onbekend')
                                  : (isAvailable ? 'Te koop' : 'Onbekend'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: district.ownerId != null
                                    ? Colors.lightBlue
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Room capacity
                    Row(
                      children: [
                        Icon(Icons.meeting_room, color: Colors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Kamers:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${hasStats ? district.stats!.occupiedRooms : 'N/B'} / 3.000.000',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'verhuurd',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (!isAvailable) ...[
                      const SizedBox(height: 12),
                      // Hourly income
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.prostitutionIncome}:',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hasStats
                                ? '€${district.stats!.hourlyIncome}/h'
                                : 'N/B',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action button
            if (isAvailable)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _purchaseDistrict(district),
                  icon: const Icon(Icons.shopping_cart, size: 24),
                  label: Text(
                    '${l10n.prostitutionBuy} - €${district.purchasePrice}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnedTab() {
    final l10n = AppLocalizations.of(context)!;

    if (_ownedDistricts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_center, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.prostitutionNoOwnedDistricts,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _ownedDistricts.length,
        itemBuilder: (context, index) {
          final district = _ownedDistricts[index];
          return _buildDistrictCard(district, isAvailable: false);
        },
      ),
    );
  }

  Widget _buildDistrictCard(
    RedLightDistrict district, {
    required bool isAvailable,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final stats = district.stats;
    final prostituteCount =
        stats?.tenantCount ??
        (district.rooms?.where((room) => room.occupied).length ?? 0);
    final hourlyIncome = stats?.hourlyIncome ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Land naam
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getCountryName(district.countryCode),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Stats (alleen als eigendom)
            if (!isAvailable) ...[
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      prostituteCount.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      'Bezet',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      '€$hourlyIncome/h',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      l10n.prostitutionIncome,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],

            // Knop
            if (isAvailable) ...[
              const SizedBox(width: 8),
              Flexible(
                child: ElevatedButton(
                  onPressed: () => _purchaseDistrict(district),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    l10n.prostitutionBuy,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
