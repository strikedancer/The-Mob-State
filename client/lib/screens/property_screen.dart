import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/property.dart';
import '../services/api_client.dart';
import '../widgets/property_card.dart';
import './nightclub_screen.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

class PropertyScreen extends StatefulWidget {
  const PropertyScreen({super.key});

  @override
  PropertyScreenState createState() => PropertyScreenState();
}

class PropertyScreenState extends State<PropertyScreen>
    with SingleTickerProviderStateMixin {
  static const Set<String> _hiddenPropertyTypes = {'nightclub', 'shop'};

  late TabController _tabController;
  final ApiClient _apiClient = ApiClient();

  List<PropertyDefinition> _availableProperties = [];
  List<Property> _myProperties = [];
  int _vipHousingBonusPerProperty = 5;
  bool _playerIsVip = false;

  bool _isLoadingAvailable = false;
  bool _isLoadingMine = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      _error = null;
    });

    try {
      final response = await _apiClient.get('/properties');
      final data = jsonDecode(response.body);

      // Backend uses event-based responses
      if (data['properties'] != null) {
        final List<dynamic> properties = data['properties'] ?? [];
        setState(() {
          _availableProperties = properties
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
          _error = data['message'] ?? l10n.errorLoadingProperties;
          _isLoadingAvailable = false;
        });
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.networkError(e.toString());
        _isLoadingAvailable = false;
      });
    }
  }

  Future<void> _loadMyProperties() async {
    setState(() {
      _isLoadingMine = true;
      _error = null;
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
          _error = data['message'] ?? l10n.errorLoadingMyProperties;
          _isLoadingMine = false;
        });
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.networkError(e.toString());
        _isLoadingMine = false;
      });
    }
  }

  Future<void> _buyProperty(PropertyDefinition property) async {
    // Confirmation dialog
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
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Eigendom kopen'
                  : 'Buy property',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.buyPropertyConfirm(
                property.name,
                property.basePrice.toString(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(AppLocalizations.of(context)!.buy),
          ),
        ],
      ),
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
            content: Text(l10n.propertyBought(property.name)),
            backgroundColor: Colors.green,
          ),
        );
        _loadData(); // Reload both tabs
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

  Future<void> _upgradeProperty(Property property) async {
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
        _loadMyProperties();
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

  Future<void> _collectIncome(Property property) async {
    try {
      final response = await _apiClient.post(
        '/properties/${property.id}/collect',
        {},
      );
      final data = jsonDecode(response.body);

      if (data['event'] == 'property.income_collected') {
        final income = data['params']?['income'] ?? property.currentIncome;
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.incomeCollected(income.toString())),
            backgroundColor: Colors.green,
          ),
        );
        _loadMyProperties();
      } else if (data['event']?.toString().contains('failed') == true) {
        final l10n = AppLocalizations.of(context)!;
        final message =
            data['params']?['message'] ?? l10n.errorCollectingIncome;
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

  Future<void> _openNightclub(Property property) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NightclubScreen(property: property)),
    );
    if (mounted) {
      _loadMyProperties();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.properties),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.propertiesAvailable, icon: const Icon(Icons.store)),
            Tab(text: l10n.myProperties, icon: const Icon(Icons.home)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildAvailablePropertiesTab(), _buildMyPropertiesTab()],
      ),
    );
  }

  Widget _buildAvailablePropertiesTab() {
    if (_isLoadingAvailable) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAvailableProperties,
              child: Text(l10n.retryAgain),
            ),
          ],
        ),
      );
    }

    if (_availableProperties.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
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

    return RefreshIndicator(
      onRefresh: _loadAvailableProperties,
      child: ListView.builder(
        itemCount: _availableProperties.length,
        itemBuilder: (context, index) {
          final property = _availableProperties[index];
          return PropertyCard(
            definition: property,
            onBuy: () => _buyProperty(property),
          );
        },
      ),
    );
  }

  Widget _buildMyPropertiesTab() {
    if (_isLoadingMine) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMyProperties,
              child: Text(l10n.retryAgain),
            ),
          ],
        ),
      );
    }

    if (_myProperties.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(l10n.noOwnedProperties),
            const SizedBox(height: 8),
            Text(
              l10n.buyFirstPropertyHint,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMyProperties,
      child: ListView.builder(
        itemCount: _myProperties.length,
        itemBuilder: (context, index) {
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
            playerIsVip: _playerIsVip,
            vipBonusPerProperty: _vipHousingBonusPerProperty,
            onUpgrade: () => _upgradeProperty(property),
            onCollectIncome: () => _collectIncome(property),
            onManage: propertyType == 'nightclub'
                ? () => _openNightclub(property)
                : null,
          );
        },
      ),
    );
  }
}
