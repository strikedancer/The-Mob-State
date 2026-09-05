import 'package:flutter/material.dart';
import '../models/prostitute.dart';
import '../models/achievement.dart';
import '../services/prostitution_service.dart';
import '../utils/achievement_notifier.dart';
import 'red_light_district_detail_screen.dart';
import 'player_profile_screen.dart';

import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';
import '../utils/country_helper.dart';
import '../widgets/mobile_load_error.dart';
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
  String? _loadError;
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
    setState(() {
      _isLoading = _ownedDistricts.isEmpty && _currentCountryDistrict == null;
      _loadError = null;
    });

    try {
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

    if (!mounted) return;
    setState(() {
      _ownedDistricts = owned;
      _currentCountryDistrict = currentCountryDistrict;
      _isLoading = false;
      _loadError = null;
    });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = AppLocalizations.of(context)!.connectionErrorGeneric;
        _isLoading = false;
      });
    }
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
        title: Text(l10n.confirmAction),
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
                CountryHelper.getLocalizedCountryName(
                  district.countryCode,
                  l10n,
                ),
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
                isScrollable: true,
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
                    : _loadError != null
                    ? MobileLoadError(
                        message: _loadError!,
                        onRetry: _loadData,
                      )
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
      final countryName = CountryHelper.getLocalizedCountryName(
        _currentCountryDistrict!.countryCode,
        l10n,
      );
      title = l10n.prostitutionRldAppBarTitle(countryName);
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
                            : l10n.prostitutionDistrictOwnedBadge,
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
                          l10n.prostitutionOwnerLabel,
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
                                        l10n.unknown,
                                  )
                                : null,
                            child: Text(
                              district.owner != null
                                  ? (district.owner!['username'] as String? ??
                                        l10n.unknown)
                                  : (isAvailable
                                        ? l10n.prostitutionForSale
                                        : l10n.unknown),
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
                          l10n.prostitutionRoomsLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${hasStats ? district.stats!.occupiedRooms : l10n.prostitutionNotApplicable} / 3.000.000',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.prostitutionRoomsRented,
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
                                ? l10n.prostitutionEuroPerHour(
                                    district.stats!.hourlyIncome.toString(),
                                  )
                                : l10n.prostitutionNotApplicable,
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
                    CountryHelper.getLocalizedCountryName(
                      district.countryCode,
                      l10n,
                    ),
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
                      l10n.prostitutionOccupiedShort,
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
                      l10n.prostitutionEuroPerHour(hourlyIncome.toString()),
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
