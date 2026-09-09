import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../providers/auth_provider.dart';
import '../services/api_client.dart';
import '../widgets/property_card.dart';
import '../widgets/responsive_modal.dart';
import './inventory_screen.dart';
import './nightclub_screen.dart';
import './showroom_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';
import '../utils/top_right_notification.dart';
import '../widgets/empire_page_hero.dart';
import '../widgets/game_page_info.dart';

class PropertyScreen extends StatefulWidget {
  final ValueChanged<int>? onOpenInventory;
  final bool embedded;

  const PropertyScreen({
    super.key,
    this.onOpenInventory,
    this.embedded = false,
  });

  @override
  PropertyScreenState createState() => PropertyScreenState();
}

class PropertyScreenState extends State<PropertyScreen>
    with SingleTickerProviderStateMixin {
  static const Set<String> _hiddenPropertyTypes = {'shop'};

  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();

  List<PropertyDefinition> _availableProperties = [];
  List<Property> _myProperties = [];
  int _vipHousingBonusPerProperty = 5;
  bool _playerIsVip = false;

  bool _isLoadingAvailable = false;
  bool _isLoadingMine = false;
  String? _availableError;
  String? _ownedError;
  String? _availableTypeFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 1, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([_loadAvailableProperties(), _loadMyProperties()]);
  }

  Future<void> _loadAvailableProperties() async {
    setState(() {
      _isLoadingAvailable = true;
      _availableError = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final country =
          authProvider.currentPlayer?.currentCountry ?? 'netherlands';
      final response = await _apiClient.get('/properties/available/$country');
      final data = jsonDecode(response.body);

      // Backend uses event-based responses
      if (data['properties'] != null) {
        final List<dynamic> properties = data['properties'] ?? [];
        final propertyDefinitions = properties
            .whereType<Map>()
            .map((entry) {
              final mapEntry = entry.cast<String, dynamic>();
              final nested = mapEntry['property'];
              if (nested is Map) {
                return {
                  ...nested.cast<String, dynamic>(),
                  'countryAvailable': mapEntry['available'],
                  'slotsAvailable': mapEntry['slotsAvailable'],
                  'ownedCount': mapEntry['ownedCount'],
                  'maxOwners': nested['maxOwners'] ?? mapEntry['maxOwners'],
                  'alreadyOwned': mapEntry['alreadyOwned'],
                };
              }
              return mapEntry;
            })
            .toList(growable: false);

        setState(() {
          _availableProperties = propertyDefinitions
              .map((json) => PropertyDefinition.fromJson(json))
              .where((property) => !_hiddenPropertyTypes.contains(property.id))
              .toList();
          _isLoadingAvailable = false;
        });
      } else if (data['success'] == true) {
        final List<dynamic> properties = data['data'] ?? [];
        setState(() {
          _availableProperties = properties
              .map((json) => PropertyDefinition.fromJson(json))
              .where((property) => !_hiddenPropertyTypes.contains(property.id))
              .toList();
          _isLoadingAvailable = false;
        });
      } else {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _availableError = data['message'] ?? l10n.errorLoadingProperties;
          _isLoadingAvailable = false;
        });
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _availableError = l10n.networkError(e.toString());
        _isLoadingAvailable = false;
      });
    }
  }

  Future<void> _loadMyProperties() async {
    setState(() {
      _isLoadingMine = true;
      _ownedError = null;
    });

    try {
      final response = await _apiClient.get('/properties/mine');
      final data = jsonDecode(response.body);

      // Backend uses event-based responses
      if (data['properties'] != null) {
        final List<dynamic> properties = data['properties'] ?? [];
        setState(() {
          _myProperties = properties
              .map((json) => Property.fromJson(json))
              .where((property) {
                final propertyType = property.type ?? property.propertyId;
                return !_hiddenPropertyTypes.contains(propertyType);
              })
              .toList();
          _vipHousingBonusPerProperty =
              (data['vipHousingBonusPerProperty'] as num?)?.toInt() ?? 5;
          _playerIsVip = data['playerIsVip'] as bool? ?? false;
          _isLoadingMine = false;
        });
      } else if (data['success'] == true) {
        final List<dynamic> properties = data['data'] ?? [];
        setState(() {
          _myProperties = properties
              .map((json) => Property.fromJson(json))
              .where((property) {
                final propertyType = property.type ?? property.propertyId;
                return !_hiddenPropertyTypes.contains(propertyType);
              })
              .toList();
          _isLoadingMine = false;
        });
      } else {
        final l10n = AppLocalizations.of(context)!;
        setState(() {
          _ownedError = data['message'] ?? l10n.errorLoadingMyProperties;
          _isLoadingMine = false;
        });
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _ownedError = l10n.networkError(e.toString());
        _isLoadingMine = false;
      });
    }
  }

  String _localizedPropertyName(PropertyDefinition property, AppLocalizations l10n) {
    switch (property.id) {
      case 'warehouse':
        return l10n.propertyWarehouseName;
      case 'nightclub':
        return l10n.propertyNightclubName;
      case 'house':
        return l10n.propertyHouseName;
      case 'apartment':
        return l10n.propertyApartmentName;
      case 'casino':
        return l10n.propertyCasinoName;
      case 'car_showroom':
        return l10n.propertyCarShowroomName;
      case 'motorcycle_showroom':
        return l10n.propertyMotorcycleShowroomName;
      case 'boat_harbor':
        return l10n.propertyBoatHarborName;
      default:
        return property.name;
    }
  }

  String? _buyLockedReason(
    PropertyDefinition property,
    AppLocalizations l10n,
    AuthProvider auth,
  ) {
    final player = auth.currentPlayer;
    final rank = player?.rank ?? 0;
    final money = player?.money ?? 0;
    if (property.alreadyOwned) {
      return property.type == 'unique_per_player'
          ? l10n.propertyAlreadyOwnedWorldwide
          : l10n.propertyAlreadyOwnedInCountry;
    }
    if (!property.countryAvailable) {
      return property.unique
          ? l10n.propertyUniqueTaken
          : l10n.propertySlotsGone;
    }
    if (property.minLevel > 0 && rank < property.minLevel) {
      return l10n.propertyBuyNeedsRank(property.minLevel);
    }
    if (money < property.basePrice) {
      return l10n.propertyBuyNeedsCash(formatCurrency(property.basePrice));
    }
    return null;
  }

  Future<void> _buyProperty(PropertyDefinition property) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        final displayName = _localizedPropertyName(property, l10n);
        return AlertDialog(
          title: Text(l10n.propertiesConfirmPurchaseTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.buyPropertyConfirm(
                    displayName,
                    formatCurrency(property.basePrice),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(l10n.buy),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await _apiClient.post(
        '/properties/claim/${property.id}',
        {},
      );
      final data = jsonDecode(response.body);

      // Backend uses event-based responses
      if (data['event'] == 'property.claimed') {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.propertyBought(_localizedPropertyName(property, l10n)),
            ),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          await context.read<AuthProvider>().refreshPlayer();
          _tabController.animateTo(1);
        }
        await _loadData();
      } else if (data['event'] == 'property.claim_failed') {
        final l10n = AppLocalizations.of(context)!;
        final message = data['params']?['message'] ?? l10n.errorBuyingProperty;
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } else {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.unknownResponse),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.networkError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _developProperty(Property property) async {
    final cost = property.nextDevelopCost;
    if (cost == null || !property.canDevelopNow) return;

    final nextLevel = property.developmentLevel + 1;
    final bonusPerLevel = property.developIncomeBonusPercentPerLevel;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.propertyDevelopConfirmTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 440,
            child: Text(
              l10n.propertyDevelopConfirmBody(
                cost.toString(),
                nextLevel,
                bonusPerLevel,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: Text(l10n.propertyDevelopAction),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      final response = await _apiClient.post(
        '/properties/${property.id}/develop',
        {},
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final l10n = AppLocalizations.of(context)!;
      if (data['event'] == 'property.developed') {
        final params = data['params'] as Map<String, dynamic>? ?? const {};
        final level = (params['developmentLevel'] as num?)?.toInt() ?? nextLevel;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.propertyDevelopedSuccessLevel(level)),
            backgroundColor: Colors.teal,
          ),
        );
        _loadMyProperties();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _developErrorMessage(
                data['event']?.toString(),
                data['params'] as Map<String, dynamic>?,
                l10n,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        if (data['event'] == 'property.develop_cooldown') {
          _loadMyProperties();
        }
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.networkError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _developErrorMessage(
    String? event,
    Map<String, dynamic>? params,
    AppLocalizations l10n,
  ) {
    switch (event) {
      case 'property.develop_cooldown':
        final seconds =
            (params?['cooldownRemainingSeconds'] as num?)?.toInt() ?? 0;
        if (seconds > 0) {
          return l10n.propertyDevelopErrorCooldown(
            formatDuration(Duration(seconds: seconds)),
          );
        }
        return l10n.propertyDevelopErrorCooldownGeneric;
      case 'property.develop_max_level':
        return l10n.propertyDevelopErrorMaxLevel;
      case 'property.develop_disabled':
        return l10n.propertyDevelopErrorDisabled;
      case 'error.insufficient_balance':
        return l10n.propertyDevelopInsufficientBalance;
      default:
        return event?.isNotEmpty == true
            ? event!
            : l10n.propertyDevelopErrorUnknown;
    }
  }

  Future<void> _upgradeProperty(Property property) async {
    final cost = property.nextUpgradeCost;
    if (cost == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.propertyUpgradeConfirmTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.propertyUpgradeConfirmBody(
                    formatCurrency(cost),
                    property.level + 1,
                  ),
                ),
                if (_upgradeBenefitLines(property, l10n).isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ..._upgradeBenefitLines(property, l10n).map(Text.new),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(l10n.propertyUpgradeAction),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      final response = await _apiClient.post(
        '/properties/${property.id}/upgrade',
        {},
      );
      final data = jsonDecode(response.body);

      if (data['event'] == 'property.upgraded') {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.propertyUpgraded((property.level + 1).toString()),
            ),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          await context.read<AuthProvider>().refreshPlayer();
        }
        await _loadMyProperties();
      } else if (data['event'] == 'property.upgrade_failed') {
        final l10n = AppLocalizations.of(context)!;
        final message = data['params']?['message'] ?? l10n.errorUpgrading;
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } else {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.unknownResponse),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.networkError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sellProperty(Property property) async {
    final price = property.sellPrice;
    if (price == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final l10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(l10n.propertySellConfirmTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 440,
            child: Text(
              l10n.propertySellConfirmBody(formatCurrency(price)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
              child: Text(l10n.propertySellAction),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    try {
      final response = await _apiClient.post(
        '/properties/${property.id}/sell',
        {},
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final l10n = AppLocalizations.of(context)!;
      if (data['event'] == 'property.sold') {
        final soldFor =
            (data['params']?['sellPrice'] as num?)?.toInt() ?? price;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.propertySold(formatCurrency(soldFor))),
            backgroundColor: Colors.green,
          ),
        );
        if (mounted) {
          await context.read<AuthProvider>().refreshPlayer();
        }
        await _loadData();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_sellErrorMessage(data['params']?['reason']?.toString(), l10n)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.networkError(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _sellErrorMessage(String? reason, AppLocalizations l10n) {
    switch (reason) {
      case 'STORAGE_NOT_EMPTY':
        return l10n.propertySellErrorStorage;
      case 'WRONG_COUNTRY':
        return l10n.propertySellErrorCountry;
      case 'NIGHTCLUB_NOT_EMPTY':
        return l10n.propertySellErrorNightclub;
      case 'SHOWROOM_NOT_EMPTY':
        return l10n.propertySellErrorShowroom;
      default:
        return l10n.propertySellErrorUnknown;
    }
  }

  static const _storagePropertyTypes = {
    'warehouse',
    'house',
    'apartment',
    'mansion',
    'penthouse',
    'safehouse',
  };

  Future<void> _openStorage(Property property) async {
    if (widget.onOpenInventory != null) {
      widget.onOpenInventory!(property.id);
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InventoryScreen(initialPropertyId: property.id),
      ),
    );
  }

  Future<void> _openNightclub(Property property) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NightclubScreen(property: property)),
    );
    if (mounted) {
      _loadMyProperties();
    }
  }

  bool _isShowroom(String? propertyType) {
    return propertyType == 'car_showroom' ||
        propertyType == 'motorcycle_showroom' ||
        propertyType == 'boat_harbor';
  }

  Future<void> _openShowroom(Property property) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ShowroomScreen(property: property)),
    );
    if (mounted) {
      _loadMyProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GamePageInfoHost(
      topicId: 'properties',
      showOverlay: false,
      child: _buildPageInfoChild(context),
    );
  }

  Widget _buildPageInfoChild(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: true,
      labelColor: kEmpireGold,
      unselectedLabelColor: Colors.white70,
      indicatorColor: kEmpireGold,
      dividerColor: kEmpireGold.withValues(alpha: 0.22),
      tabs: [
        Tab(text: l10n.propertiesAvailable),
        Tab(text: l10n.myProperties),
      ],
    );
    final body = NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: EmpirePageHero(
              title: l10n.properties,
              imageAsset: 'assets/images/properties/house.png',
              topicId: 'properties',
              onRefresh: _loadData,
              fallbackIcon: Icons.home_work,
              chips: [
                EmpireStatChip(
                  icon: Icons.home,
                  label: '${_myProperties.length}',
                ),
              ],
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: PinnedTabBarDelegate(tabBar: tabBar),
        ),
      ],
      body: TabBarView(
        controller: _tabController,
        children: [_buildAvailablePropertiesTab(), _buildMyPropertiesTab()],
      ),
    );
    final painted = empireHubPainted(child: body);
    if (widget.embedded) return painted;
    return Scaffold(
      backgroundColor: kEmpireBgEnd,
      appBar: AppBar(
        backgroundColor: kEmpireBgStart,
        foregroundColor: kEmpireGold,
        title: Text(l10n.properties),
      ),
      body: painted,
    );
  }

  Widget _buildAvailablePropertiesTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoadingAvailable && _availableProperties.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_availableError != null && _availableProperties.isEmpty) {
      return _buildErrorState(_availableError!, _loadAvailableProperties);
    }

    if (_availableProperties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_work, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noAvailableProperties),
          ],
        ),
      );
    }

    final typeIds = _availableProperties.map((p) => p.id).toSet().toList()
      ..sort();
    final visible = _availableTypeFilter == null
        ? _availableProperties
        : _availableProperties
              .where((p) => p.id == _availableTypeFilter)
              .toList();
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        if (_isLoadingAvailable) const LinearProgressIndicator(minHeight: 2),
        if (_availableError != null)
          _buildInlineError(_availableError!, _loadAvailableProperties),
        _buildTypeFilterRow(typeIds, l10n),
        Expanded(
          child: visible.isEmpty
              ? Center(child: Text(l10n.propertyFilterEmpty))
              : _buildResponsivePropertyList(
                  itemCount: visible.length,
                  onRefresh: _loadAvailableProperties,
                  itemBuilder: (context, index, expandToFill) {
                    final property = visible[index];
                    return PropertyCard(
                      definition: property,
                      expandToFill: expandToFill,
                      buyLockedReason: _buyLockedReason(
                        property,
                        l10n,
                        auth,
                      ),
                      onBuy: () => _buyProperty(property),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTypeFilterRow(List<String> typeIds, AppLocalizations l10n) {
    if (typeIds.length < 2) return const SizedBox.shrink();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(l10n.propertyFilterAll),
              selected: _availableTypeFilter == null,
              onSelected: (_) => setState(() => _availableTypeFilter = null),
            ),
          ),
          ...typeIds.map((id) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(_filterLabel(id, l10n)),
                selected: _availableTypeFilter == id,
                onSelected: (_) => setState(() => _availableTypeFilter = id),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _filterLabel(String propertyId, AppLocalizations l10n) {
    switch (propertyId) {
      case 'house':
        return l10n.propertyTypeHouse;
      case 'apartment':
        return l10n.propertyTypeApartment;
      case 'warehouse':
        return l10n.propertyTypeWarehouse;
      case 'nightclub':
        return l10n.propertyTypeNightclub;
      case 'casino':
        return l10n.propertyTypeCasino;
      case 'car_showroom':
        return l10n.propertyTypeCarShowroom;
      case 'motorcycle_showroom':
        return l10n.propertyTypeMotorcycleShowroom;
      case 'boat_harbor':
        return l10n.propertyTypeBoatHarbor;
      default:
        return propertyId;
    }
  }

  List<String> _upgradeBenefitLines(Property property, AppLocalizations l10n) {
    final lines = <String>[];
    final fromSlots = property.nextUpgradeStorageFrom;
    final toSlots = property.nextUpgradeStorageTo;
    if (fromSlots != null && toSlots != null && toSlots > fromSlots) {
      lines.add(l10n.propertyUpgradeNextStorage(fromSlots, toSlots));
      final type = property.type ?? property.propertyId;
      if (type == 'house' || type == 'apartment') {
        lines.add(
          l10n.propertyUpgradeNextHousing(
            (fromSlots / 5).floor().clamp(1, 999),
            (toSlots / 5).floor().clamp(1, 999),
          ),
        );
      }
    }
    final incomeBonus = property.nextUpgradeIncomeBonus ?? 0;
    if (incomeBonus > 0) {
      lines.add(l10n.propertyUpgradeNextIncome(formatCurrency(incomeBonus)));
    }
    return lines;
  }

  Widget _buildMyPropertiesTab() {
    final l10n = AppLocalizations.of(context)!;
    if (_isLoadingMine && _myProperties.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_ownedError != null && _myProperties.isEmpty) {
      return _buildErrorState(_ownedError!, _loadMyProperties);
    }

    if (_myProperties.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                l10n.noOwnedProperties,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.buyFirstPropertyHint,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => _tabController.animateTo(0),
                icon: const Icon(Icons.storefront),
                label: Text(l10n.propertyBrowseAvailableAction),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_isLoadingMine) const LinearProgressIndicator(minHeight: 2),
        if (_ownedError != null)
          _buildInlineError(_ownedError!, _loadMyProperties),
        Expanded(
          child: _buildResponsivePropertyList(
            itemCount: _myProperties.length,
            onRefresh: _loadMyProperties,
            itemBuilder: (context, index, expandToFill) {
              final property = _myProperties[index];
              final propertyType = property.type ?? property.propertyId;
              final matchingDefs = _availableProperties
                  .where((d) => d.id == propertyType)
                  .toList();
              final definition = matchingDefs.isNotEmpty
                  ? matchingDefs.first
                  : null;
              return PropertyCard(
                ownedProperty: property,
                definition: definition,
                expandToFill: expandToFill,
                playerIsVip: _playerIsVip,
                vipBonusPerProperty: _vipHousingBonusPerProperty,
                onUpgrade: () => _upgradeProperty(property),
                upgradeLockedReason: () {
                  final cost = property.nextUpgradeCost;
                  final money = context.read<AuthProvider>().currentPlayer?.money ?? 0;
                  if (cost != null && money < cost) {
                    return l10n.propertyBuyNeedsCash(formatCurrency(cost));
                  }
                  return null;
                }(),
                onDevelop: property.canDevelop && property.nextDevelopCost != null
                    ? () => _developProperty(property)
                    : null,
                onSell: property.sellPrice != null
                    ? () => _sellProperty(property)
                    : null,
                onOpenStorage: _storagePropertyTypes.contains(propertyType)
                    ? () => _openStorage(property)
                    : null,
                onManage: propertyType == 'nightclub'
                    ? () => _openNightclub(property)
                    : _isShowroom(propertyType)
                        ? () => _openShowroom(property)
                        : null,
                manageLabel: propertyType == 'nightclub'
                    ? l10n.propertyManageNightclub
                    : _isShowroom(propertyType)
                        ? l10n.propertyManageShowroom
                        : null,
                manageIcon: propertyType == 'nightclub'
                    ? Icons.nightlife
                    : _isShowroom(propertyType)
                        ? Icons.garage_outlined
                        : null,
              );
            },
          ),
        ),
      ],
    );
  }

  int _propertyColumnCount(double width) {
    if (width >= 1180) return 3;
    if (width >= 720) return 2;
    return 1;
  }

  Widget _buildResponsivePropertyList({
    required int itemCount,
    required Future<void> Function() onRefresh,
    required Widget Function(BuildContext context, int index, bool expandToFill)
        itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _propertyColumnCount(constraints.maxWidth);
        final expandToFill = columns > 1;
        const gap = 12.0;
        const pad = 12.0;
        if (columns == 1) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: itemCount,
              itemBuilder: (context, index) =>
                  itemBuilder(context, index, false),
            ),
          );
        }

        final innerWidth = constraints.maxWidth - (pad * 2);
        final cardWidth = (innerWidth - gap * (columns - 1)) / columns;
        final rowCount = (itemCount / columns).ceil();

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(pad, 8, pad, 16),
            itemCount: rowCount,
            itemBuilder: (context, rowIndex) {
              final start = rowIndex * columns;
              return Padding(
                padding: const EdgeInsets.only(bottom: gap),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < columns; i++) ...[
                      if (i > 0) const SizedBox(width: gap),
                      SizedBox(
                        width: cardWidth,
                        child: start + i < itemCount
                            ? itemBuilder(
                                context,
                                start + i,
                                expandToFill,
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String message, Future<void> Function() onRetry) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(message, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text(l10n.retryAgain),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineError(String message, Future<void> Function() onRetry) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
            TextButton(onPressed: onRetry, child: Text(l10n.retryAgain)),
          ],
        ),
      ),
    );
  }
}
