import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../models/crew.dart';
import '../models/crew_join_request.dart';
import '../widgets/crew_chat_widget.dart';
import 'player_profile_screen.dart';
import '../utils/top_right_notification.dart';

class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _oneTimeProducts = [];
  static const List<String> _hqStyleOrder = [
    'camping',
    'rural',
    'city',
    'villa',
    'vip',
  ];

  late TabController _tabController;
  Crew? _myCrew;
  List<Crew> _allCrews = [];
  List<CrewJoinRequest> _joinRequests = [];
  Map<String, int>? _crewStats;
  List<dynamic> _crewBuildings = [];
  Map<String, dynamic>? _crewStorage;
  bool _loading = true;

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  static const Map<String, Map<String, String>> _crewI18n = {
    'app.crews': {'nl': 'Crews', 'en': 'Crews'},
    'tab.myCrew': {'nl': 'Mijn Crew', 'en': 'My Crew'},
    'tab.crewHq': {'nl': 'Crew HQ', 'en': 'Crew HQ'},
    'tab.members': {'nl': 'Leden', 'en': 'Members'},
    'tab.carStorage': {'nl': 'Auto opslag', 'en': 'Car Storage'},
    'tab.boatStorage': {'nl': 'Haven', 'en': 'Boat Storage'},
    'tab.weaponStorage': {'nl': 'Wapen opslag', 'en': 'Weapon Storage'},
    'tab.ammoStorage': {'nl': 'Munitie opslag', 'en': 'Ammo Storage'},
    'tab.drugStorage': {'nl': 'Drugs opslag', 'en': 'Drug Storage'},
    'tab.cashStorage': {'nl': 'Cash opslag', 'en': 'Cash Storage'},
    'tab.allCrews': {'nl': 'Alle Crews', 'en': 'All Crews'},
    'tab.chat': {'nl': 'Chat', 'en': 'Chat'},
    'action.createCrewShort': {
      'nl': 'Crew Maken (€50k)',
      'en': 'Create Crew (€50k)',
    },
    'state.notInCrewYet': {
      'nl': 'Je zit nog niet in een crew',
      'en': 'You are not in a crew yet',
    },
    'action.createCrew': {
      'nl': 'Crew Maken (€50,000)',
      'en': 'Create Crew (€50,000)',
    },
    'label.crewBank': {'nl': 'Crew Bank:', 'en': 'Crew Bank:'},
    'label.deposit': {'nl': 'Storten', 'en': 'Deposit'},
    'label.withdraw': {'nl': 'Opnemen', 'en': 'Withdraw'},
    'label.myTrustScore': {'nl': 'Mijn Trust Score:', 'en': 'My Trust Score:'},
    'action.deleteCrew': {'nl': 'Crew verwijderen', 'en': 'Delete crew'},
    'label.crewStats': {'nl': 'Crew Stats:', 'en': 'Crew Stats:'},
    'action.leaveCrew': {'nl': 'Crew Verlaten', 'en': 'Leave Crew'},
    'section.buildings': {'nl': 'Crew HQ & Opslag', 'en': 'Crew HQ & Storage'},
    'hint.buildingsTabs': {
      'nl': 'Open Crew HQ en de opslag-tabs om te bekijken en upgraden.',
      'en': 'Open Crew HQ and the storage tabs to view and upgrade.',
    },
    'section.crewStorage': {'nl': 'Crew Opslag', 'en': 'Crew Storage'},
    'state.noStorageData': {
      'nl': 'Geen opslagdata geladen',
      'en': 'No storage data loaded',
    },
    'action.addCar': {'nl': 'Auto toevoegen', 'en': 'Add car'},
    'action.addBoat': {'nl': 'Boot toevoegen', 'en': 'Add boat'},
    'action.addWeapon': {'nl': 'Wapen toevoegen', 'en': 'Add weapon'},
    'action.addAmmo': {'nl': 'Munitie toevoegen', 'en': 'Add ammo'},
    'action.addDrugs': {'nl': 'Drugs toevoegen', 'en': 'Add drugs'},
    'section.membersOverview': {
      'nl': 'Leden overzicht',
      'en': 'Members overview',
    },
    'hint.membersTab': {
      'nl': 'Open de tab Leden bovenaan voor de ledenlijst en join requests.',
      'en': 'Open the Members tab above for member list and join requests.',
    },
    'action.goToMembers': {'nl': 'Ga naar Leden', 'en': 'Go to Members'},
    'label.crewHq': {'nl': 'Crew HQ', 'en': 'Crew HQ'},
    'action.goToCrewHq': {'nl': 'Ga naar Crew HQ', 'en': 'Go to Crew HQ'},
    'state.joinCrewFirst': {
      'nl': 'Maak of join eerst een crew',
      'en': 'Create or join a crew first',
    },
    'state.joinRequests': {'nl': 'Join Requests', 'en': 'Join Requests'},
    'state.noJoinRequests': {
      'nl': 'Geen open verzoeken',
      'en': 'No pending requests',
    },
    'state.noCrewsFound': {'nl': 'Geen crews gevonden', 'en': 'No crews found'},
    'label.memberCount': {'nl': 'Leden', 'en': 'Members'},
    'badge.myCrew': {'nl': 'Mijn Crew', 'en': 'My Crew'},
    'action.join': {'nl': 'Joinen', 'en': 'Join'},
    'state.notInCrew': {
      'nl': 'Je zit niet in een crew',
      'en': 'You are not in a crew',
    },
    'hint.chatJoinCrew': {
      'nl': 'Maak of join een crew om te chatten!',
      'en': 'Create or join a crew to chat!',
    },
    'status.notOwned': {'nl': 'Niet gekocht', 'en': 'Not owned'},
    'label.level': {'nl': 'Level', 'en': 'Level'},
    'label.capacity': {'nl': 'Capaciteit', 'en': 'Capacity'},
    'label.memberCap': {'nl': 'Leden cap', 'en': 'Member cap'},
    'label.parking': {'nl': 'Parkeerplekken', 'en': 'Parking'},
    'action.purchase': {'nl': 'Kopen', 'en': 'Purchase'},
    'action.upgrade': {'nl': 'Upgrade', 'en': 'Upgrade'},
    'action.details': {'nl': 'Details', 'en': 'Details'},
    'help.capsTitle': {'nl': 'Level overzicht', 'en': 'Level overview'},
    'help.level': {'nl': 'Level', 'en': 'Level'},
    'help.capacity': {'nl': 'Cap', 'en': 'Cap'},
    'help.upgradeCost': {'nl': 'Kosten', 'en': 'Cost'},
    'help.close': {'nl': 'Sluiten', 'en': 'Close'},
    'help.showCaps': {'nl': 'Toon caps', 'en': 'Show caps'},
  };

  static const Map<String, List<int>> _buildingCapacityByLevel = {
    'hq': [5, 10, 16, 24],
    'car_storage': [
      2,
      5,
      10,
      18,
      28,
      40,
      55,
      72,
      92,
      115,
      145,
      180,
      220,
      265,
      315,
      504,
    ],
    'boat_storage': [
      1,
      3,
      6,
      10,
      15,
      21,
      28,
      36,
      46,
      58,
      72,
      88,
      106,
      126,
      150,
      240,
    ],
    'weapon_storage': [
      10,
      25,
      55,
      110,
      180,
      280,
      420,
      600,
      850,
      1200,
      1650,
      2200,
      2850,
      3600,
      4500,
      7200,
    ],
    'ammo_storage': [
      500,
      1500,
      3500,
      7000,
      12000,
      20000,
      32000,
      50000,
      75000,
      110000,
      160000,
      230000,
      320000,
      450000,
      620000,
      1054000,
    ],
    'drug_storage': [
      50,
      140,
      300,
      650,
      1200,
      2200,
      3800,
      6500,
      10000,
      15000,
      22000,
      31000,
      43000,
      58000,
      77000,
      123200,
    ],
    'cash_storage': [
      100000,
      600000,
      2500000,
      10000000,
      35000000,
      100000000,
      250000000,
      600000000,
      1200000000,
      2200000000,
      4000000000,
      7000000000,
      12000000000,
      20000000000,
      35000000000,
      66500000000,
    ],
  };

  static const Map<String, List<int>> _buildingCostByLevel = {
    'hq': [0, 75000, 250000, 900000],
    'car_storage': [
      50000,
      150000,
      450000,
      1200000,
      3200000,
      8000000,
      18000000,
      38000000,
      75000000,
      140000000,
      250000000,
      450000000,
      800000000,
      1400000000,
      2400000000,
      3720000000,
    ],
    'boat_storage': [
      60000,
      180000,
      520000,
      1400000,
      3600000,
      9000000,
      20000000,
      42000000,
      82000000,
      155000000,
      280000000,
      500000000,
      900000000,
      1600000000,
      2800000000,
      4340000000,
    ],
    'weapon_storage': [
      45000,
      130000,
      350000,
      950000,
      2500000,
      6250000,
      14000000,
      30000000,
      60000000,
      115000000,
      200000000,
      360000000,
      650000000,
      1200000000,
      2100000000,
      3255000000,
    ],
    'ammo_storage': [
      40000,
      120000,
      320000,
      900000,
      2300000,
      5700000,
      12800000,
      27000000,
      54000000,
      103000000,
      180000000,
      325000000,
      585000000,
      1050000000,
      1850000000,
      2867500000,
    ],
    'drug_storage': [
      55000,
      160000,
      420000,
      1100000,
      2800000,
      7000000,
      15600000,
      33000000,
      66000000,
      126000000,
      220000000,
      395000000,
      710000000,
      1280000000,
      2250000000,
      3487500000,
    ],
    'cash_storage': [
      75000,
      250000,
      800000,
      2000000,
      5000000,
      12500000,
      28000000,
      60000000,
      120000000,
      230000000,
      400000000,
      720000000,
      1300000000,
      2300000000,
      4000000000,
      6200000000,
    ],
  };

  String _t(String locale, String key) {
    final lang = locale == 'nl' ? 'nl' : 'en';
    return _crewI18n[key]?[lang] ?? key;
  }

  String _localizedHqStyleLabel(String locale, String style) {
    final isNl = locale == 'nl';
    switch (style) {
      case 'camping':
        return isNl ? 'camping' : 'camping';
      case 'rural':
        return isNl ? 'landelijk' : 'rural';
      case 'city':
        return isNl ? 'stad' : 'city';
      case 'villa':
        return isNl ? 'villa' : 'villa';
      case 'vip':
        return 'VIP';
      default:
        return style;
    }
  }

  int _getHqGlobalLevel(String? style, int? level) {
    final normalizedStyle = (style ?? 'camping').toLowerCase();
    final normalizedLevel = (level ?? 0).clamp(0, 3);
    final styleIndex = _hqStyleOrder.indexOf(normalizedStyle);
    final safeStyleIndex = styleIndex < 0 ? 0 : styleIndex;
    return (safeStyleIndex * 4) + normalizedLevel;
  }

  List<int> _getHqCapsByGlobalLevel() {
    const baseCaps = [5, 10, 16, 24];
    return [for (final _ in _hqStyleOrder) ...baseCaps];
  }

  List<int> _getHqCostsByGlobalLevel() {
    const baseCosts = [0, 75000, 250000, 900000];
    return [for (final _ in _hqStyleOrder) ...baseCosts];
  }

  int _requiredSideBuildingLevelForHqUpgrade(String? style, int? level) {
    final normalizedStyle = (style ?? 'camping').toLowerCase();
    final normalizedHqLevel = (level ?? 0).clamp(0, 3);

    switch (normalizedStyle) {
      case 'camping':
        return normalizedHqLevel >= 2 ? 2 : 1;
      case 'rural':
        return normalizedHqLevel >= 2 ? 4 : 3;
      case 'city':
        if (normalizedHqLevel >= 3) return 7;
        if (normalizedHqLevel >= 2) return 6;
        return 5;
      case 'villa':
        if (normalizedHqLevel >= 3) return 10;
        if (normalizedHqLevel >= 2) return 9;
        return 8;
      case 'vip':
        if (normalizedHqLevel <= 0) return 11;
        if (normalizedHqLevel == 1) return 12;
        if (normalizedHqLevel == 2) return 13;
        return 14;
      default:
        return 1;
    }
  }

  List<String> _getMissingSideBuildingsForHqUpgrade(
    int requiredLevel,
    String locale,
  ) {
    const sideTypes = [
      'car_storage',
      'boat_storage',
      'weapon_storage',
      'ammo_storage',
      'drug_storage',
      'cash_storage',
    ];

    final missing = <String>[];
    for (final sideType in sideTypes) {
      final sideBuilding = _crewBuildings.firstWhere(
        (b) => (b['type'] as String?) == sideType,
        orElse: () => {'type': sideType, 'level': null},
      );
      final sideLevel = sideBuilding['level'] as int?;
      if ((sideLevel ?? -1) < requiredLevel) {
        final label = _getBuildingLabel(sideType, locale);
        missing.add('$label L${sideLevel ?? 0}');
      }
    }

    return missing;
  }

  Future<void> _showHqUpgradeRequirementsDialog(
    String locale,
    int requiredSideLevel,
    List<String> missingSideBuildings,
  ) async {
    final message = locale == 'nl'
        ? 'Upgrade eerst alle bijgebouwen naar minimaal level $requiredSideLevel.\n\nOntbreekt:\n- ${missingSideBuildings.join('\n- ')}'
        : 'Upgrade all side buildings to at least level $requiredSideLevel first.\n\nMissing:\n- ${missingSideBuildings.join('\n- ')}';

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _tr(locale, 'HQ upgrade vereisten', 'HQ upgrade requirements'),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t(locale, 'help.close')),
          ),
        ],
      ),
    );
  }

  Future<void> _showBuildingCapsDialog(
    String locale,
    String buildingType,
    String buildingLabel,
  ) async {
    final caps = buildingType == 'hq'
        ? _getHqCapsByGlobalLevel()
        : _buildingCapacityByLevel[buildingType];
    final costs = buildingType == 'hq'
        ? _getHqCostsByGlobalLevel()
        : _buildingCostByLevel[buildingType];
    if (caps == null || caps.isEmpty) return;

    String shortNum(int n) {
      if (n >= 1000000000) return '${(n / 1000000000).toStringAsFixed(1)}B';
      if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
      if (n >= 1000) return '${(n / 1000).round()}K';
      return n.toString();
    }

    final capLabel = buildingType == 'hq'
        ? _t(locale, 'label.memberCap')
        : _t(locale, 'help.capacity');

    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const dataStyle = TextStyle(fontSize: 12);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_t(locale, 'help.capsTitle')} - $buildingLabel'),
        content: SizedBox(
          width: 380,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(_t(locale, 'help.level'), style: headerStyle),
                  ),
                  Expanded(
                    child: Text(
                      capLabel,
                      style: headerStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _t(locale, 'help.upgradeCost'),
                      style: headerStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const Divider(height: 8),
              ...List.generate(caps.length, (index) {
                final costStr = (costs != null && index < costs.length)
                    ? shortNum(costs[index])
                    : '-';
                final levelLabel = buildingType == 'hq'
                    ? 'L$index (${_localizedHqStyleLabel(locale, _hqStyleOrder[index ~/ 4])})'
                    : 'L$index';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 90,
                        child: Text(levelLabel, style: dataStyle),
                      ),
                      Expanded(
                        child: Text(
                          shortNum(caps[index]),
                          style: dataStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          costStr,
                          style: dataStyle,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t(locale, 'help.close')),
          ),
        ],
      ),
    );
  }

  String _tr(String locale, String nl, String en) => locale == 'nl' ? nl : en;

  String _buildingActionErrorMessage(String locale, String? event) {
    switch (event) {
      case 'error.hq_style_locked':
        return _tr(
          locale,
          'Upgrade eerst je huidige HQ-stijl naar max level om de volgende stijl te ontgrendelen',
          'Upgrade your current HQ style to max level to unlock the next style',
        );
      case 'error.hq_style_max':
        return _tr(
          locale,
          'Laatste HQ-stijl bereikt',
          'Final HQ style reached',
        );
      case 'error.hq_vip_required':
        return _tr(
          locale,
          'VIP HQ vereist voor level 11-15',
          'VIP HQ required for level 11-15',
        );
      case 'error.hq_side_buildings_incomplete':
        return _tr(
          locale,
          'Upgrade eerst alle bijgebouwen naar het vereiste level voor deze HQ-stijl',
          'Upgrade all side buildings to the required level for this HQ style first',
        );
      case 'error.building_already_owned':
        return _tr(locale, 'Gebouw al gekocht', 'Building already owned');
      case 'error.insufficient_crew_funds':
        return _tr(
          locale,
          'Onvoldoende saldo in crew bank',
          'Insufficient crew bank funds',
        );
      case 'error.hq_level_too_low':
        return _tr(
          locale,
          'HQ progression te laag voor deze upgrade',
          'HQ progression is too low for this upgrade',
        );
      case 'error.building_vip_required':
        return _tr(
          locale,
          'Crew VIP vereist voor level 11+',
          'Crew VIP required for level 11+',
        );
      default:
        return _tr(locale, 'Actie mislukt', 'Action failed');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 11, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      await _loadMyCrew();

      final futures = <Future<void>>[_loadAllCrews(), _loadOneTimeProducts()];
      if (_myCrew != null) {
        futures.add(_loadCrewStats());
        futures.add(_loadCrewBuildings());
        futures.add(_loadCrewStorage());
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final currentPlayerId = authProvider.currentPlayer?.id ?? 0;
        final myMembership = _myCrew!.members.firstWhere(
          (m) => m.playerId == currentPlayerId,
          orElse: () => _myCrew!.members.first,
        );
        if (myMembership.isLeader) {
          futures.add(_loadJoinRequests());
        }
      }

      await Future.wait(futures);
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _loadOneTimeProducts() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get(
        '/subscriptions/checkout/one-time/catalog',
      );

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final productsRaw = (data['products'] as List<dynamic>? ?? []);

      _oneTimeProducts
        ..clear()
        ..addAll(productsRaw.whereType<Map<String, dynamic>>());

      if (mounted) {
        setState(() {});
      }
    } catch (_) {}
  }

  Future<void> _loadMyCrew() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews/mine');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        if (params['crew'] != null) {
          final crewData = Crew.fromJson(params['crew']);
          print(
            '🏢 Loaded crew: ${crewData.name}, HQ Style: ${crewData.hqStyle}, HQ Level: ${crewData.hqLevel}',
          );
          setState(() {
            _myCrew = crewData;
          });
        }
      }
    } catch (e) {
      print('Error loading crew: $e');
    }
  }

  Future<void> _loadAllCrews() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final crewsList = params['crews'] as List;
        setState(() {
          _allCrews = crewsList.map((c) => Crew.fromJson(c)).toList();
        });
      }
    } catch (e) {
      print('Error loading crews: $e');
    }
  }

  Future<void> _loadJoinRequests() async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews/${_myCrew!.id}/requests');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final requestsList = params['requests'] as List;
        setState(() {
          _joinRequests = requestsList
              .map((r) => CrewJoinRequest.fromJson(r as Map<String, dynamic>))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading crew join requests: $e');
    }
  }

  Future<void> _loadCrewStats() async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews/${_myCrew!.id}/stats');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final stats = params['stats'] as Map<String, dynamic>;
        setState(() {
          _crewStats = {
            'totalCrimes': stats['totalCrimes'] as int,
            'heistsAttempted': stats['heistsAttempted'] as int,
            'heistsCompleted': stats['heistsCompleted'] as int,
          };
        });
      }
    } catch (e) {
      print('Error loading crew stats: $e');
    }
  }

  Future<void> _loadCrewBuildings() async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews/${_myCrew!.id}/buildings');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final buildings = params['buildings'] as List<dynamic>;
        setState(() {
          _crewBuildings = buildings;
        });
      }
    } catch (e) {
      print('Error loading crew buildings: $e');
    }
  }

  Future<void> _loadCrewStorage() async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crews/${_myCrew!.id}/storage');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        setState(() {
          _crewStorage = params['storage'] as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error loading crew storage: $e');
    }
  }

  Future<void> _createCrew() async {
    final nameController = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Crew Aanmaken'
              : 'Create Crew',
        ),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: Localizations.localeOf(context).languageCode == 'nl'
                ? 'Crew Naam'
                : 'Crew Name',
            hintText: Localizations.localeOf(context).languageCode == 'nl'
                ? 'Voer crew naam in...'
                : 'Enter crew name...',
          ),
          maxLength: 50,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Annuleren'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, nameController.text),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Aanmaken'
                  : 'Create',
            ),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final apiClient = AuthService().apiClient;
        final response = await apiClient.post('/crews/create', {
          'name': result,
        });

        if (response.statusCode == 201) {
          if (mounted) {
            showTopRightFromSnackBar(
              context,
              SnackBar(
                content: Text(
                  Localizations.localeOf(context).languageCode == 'nl'
                      ? 'Crew succesvol aangemaakt! (€50,000 betaald)'
                      : 'Crew created successfully! (€50,000 paid)',
                ),
                backgroundColor: Colors.green,
              ),
            );
            _loadData();
          }
        }
      } catch (e) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text('Er is een fout opgetreden'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _joinCrew(int crewId) async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post('/crews/$crewId/join', {});

      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'nl'
                    ? 'Join request verstuurd!'
                    : 'Join request sent!',
              ),
              backgroundColor: Colors.green,
            ),
          );
          _loadData();
        }
      } else if (mounted) {
        final locale = Localizations.localeOf(context).languageCode;
        String message = locale == 'nl'
            ? 'Join request mislukt'
            : 'Join request failed';

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final event = data['event'] as String?;
          if (event == 'error.crew_not_found') {
            message = locale == 'nl' ? 'Crew niet gevonden' : 'Crew not found';
          } else if (event == 'error.already_in_crew') {
            message = locale == 'nl'
                ? 'Je zit al in een crew'
                : 'You are already in a crew';
          } else if (event == 'error.request_already_pending') {
            message = locale == 'nl'
                ? 'Je hebt al een open verzoek'
                : 'You already have a pending request';
          } else if (event == 'error.invalid_crew_id') {
            message = locale == 'nl' ? 'Ongeldige crew' : 'Invalid crew';
          }
        } catch (_) {
          // Keep fallback message
        }

        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildVipStatusCard(String locale) {
    final crewVip = _myCrew!.isVip;
    final isNl = locale == 'nl';
    String crewExpiry = '';
    if (crewVip && _myCrew!.vipExpiresAt != null) {
      try {
        final dt = DateTime.parse(_myCrew!.vipExpiresAt!);
        crewExpiry = '${dt.day}-${dt.month}-${dt.year}';
      } catch (_) {
        crewExpiry = _myCrew!.vipExpiresAt!;
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  isNl ? 'VIP Abonnementen' : 'VIP Subscriptions',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              isNl
                  ? 'Echte betalingen · maandelijks opzegbaar'
                  : 'Real payments · cancel anytime',
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const Divider(height: 20),
            // Crew VIP row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.groups,
                            size: 18,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _tr(locale, 'Crew VIP', 'Crew VIP'),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (crewVip) ...[
                            const SizedBox(width: 6),
                            _vipBadge(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        crewVip
                            ? (isNl
                                  ? 'Actief tot: $crewExpiry'
                                  : 'Active until: $crewExpiry')
                            : (isNl
                                  ? 'Bijgebouwen lvl 11-15 + speler VIP inbegrepen'
                                  : 'Side buildings lvl 11-15 + player VIP included'),
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _tr(locale, '€9,99/mnd', '€9.99/mo'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () => _startCheckout('crew_vip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        crewVip
                            ? (isNl ? 'Verlengen' : 'Extend')
                            : (isNl ? 'Activeren' : 'Activate'),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Player VIP row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isNl ? 'Speler VIP' : 'Player VIP',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isNl
                            ? 'Exclusieve avatars & voordelen (alleen jij)'
                            : 'Exclusive avatars & perks (you only)',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _tr(locale, '€4,99/mnd', '€4.99/mo'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[700],
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () => _startCheckout('player_vip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        isNl ? 'Abonneren' : 'Subscribe',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Text(
              _tr(locale, 'Eenmalige aankopen', 'One-time purchases'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _oneTimeProducts.map((product) {
                final key = (product['key'] ?? '').toString();
                final title = locale == 'nl'
                    ? (product['titleNl'] ?? key).toString()
                    : (product['titleEn'] ?? key).toString();
                final imageUrl = (product['imageUrl'] ?? '').toString();
                final price = (product['priceEur'] ?? '0.00').toString();

                String rewardLabel = '';
                final rewardSummary = locale == 'nl'
                    ? (product['rewardSummaryNl'] ?? '').toString()
                    : (product['rewardSummaryEn'] ?? '').toString();
                final reward = product['reward'];
                if (reward is Map<String, dynamic>) {
                  final type = (reward['type'] ?? '').toString();
                  if (type == 'money') {
                    final amount = (reward['amount'] ?? 0);
                    rewardLabel = '+€$amount';
                  } else if (type == 'ammo') {
                    final ammoType = (reward['ammoType'] ?? '').toString();
                    final quantity = (reward['quantity'] ?? 0);
                    rewardLabel = '$ammoType x$quantity';
                  } else if (type == 'credits') {
                    final amount = (reward['amount'] ?? 0);
                    rewardLabel = '+$amount credits';
                  } else if (type == 'event_boost') {
                    rewardLabel = rewardSummary;
                  }
                }

                if (rewardLabel.isEmpty && rewardSummary.isNotEmpty) {
                  rewardLabel = rewardSummary;
                }

                return OutlinedButton(
                  onPressed: key.isEmpty
                      ? null
                      : () => _startCheckout('one_time', productKey: key),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Image.network(
                            imageUrl,
                            width: 18,
                            height: 18,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.image_not_supported, size: 16),
                          ),
                        ),
                      Flexible(
                        child: Text(
                          '€$price · $title${rewardLabel.isNotEmpty ? ' · $rewardLabel' : ''}',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vipBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      color: Colors.purple,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Text(
      'VIP',
      style: TextStyle(
        color: Colors.white,
        fontSize: 9,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Future<void> _startCheckout(String type, {String? productKey}) async {
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final apiClient = AuthService().apiClient;
      final String endpoint;
      final Map<String, dynamic> body;

      if (type == 'crew_vip') {
        endpoint = '/subscriptions/checkout/crew-vip';
        body = {'crewId': _myCrew!.id};
      } else if (type == 'one_time') {
        endpoint = '/subscriptions/checkout/one-time';
        body = {'productKey': productKey};
      } else {
        endpoint = '/subscriptions/checkout/player-vip';
        body = {};
      }

      final response = await apiClient.post(endpoint, body);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final checkoutUrl = data['url'] as String?;
        if (checkoutUrl != null) {
          final uri = Uri.parse(checkoutUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        }
      } else {
        final errData = response.statusCode != 200 && response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>?
            : null;
        final code = errData?['event'] as String? ?? 'unknown';
        final message = code == 'error.not_crew_leader'
            ? _tr(
                locale,
                'Alleen de leider kan crew VIP kopen',
                'Only the leader can buy crew VIP',
              )
            : code == 'error.invalid_product_key'
            ? _tr(locale, 'Ongeldig product', 'Invalid product')
            : _tr(locale, 'Actie mislukt', 'Action failed');
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              _tr(
                locale,
                'Fout bij openen betaalpagina',
                'Error opening payment page',
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _leaveCrew() async {
    final locale = Localizations.localeOf(context).languageCode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr(locale, 'Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _tr(locale, 'Crew verlaten', 'Leave crew'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                locale,
                'Weet je zeker dat je de crew wilt verlaten?',
                'Are you sure you want to leave the crew?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr(locale, 'Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(_tr(locale, 'Verlaten', 'Leave')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final apiClient = AuthService().apiClient;
        final response = await apiClient.post('/crews/leave', {});

        if (response.statusCode == 200) {
          if (mounted) {
            showTopRightFromSnackBar(
              context,
              SnackBar(
                content: Text(_tr(locale, 'Crew verlaten', 'Left crew')),
                backgroundColor: Colors.orange,
              ),
            );
            setState(() => _myCrew = null);
            _loadData();
          }
        }
      } catch (e) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text('Er is een fout opgetreden'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _approveJoinRequest(int requestId) async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/requests/$requestId/approve',
        {},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final locale = Localizations.localeOf(context).languageCode;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl' ? 'Verzoek geaccepteerd' : 'Request approved',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectJoinRequest(int requestId) async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/requests/$requestId/reject',
        {},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final locale = Localizations.localeOf(context).languageCode;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl' ? 'Verzoek geweigerd' : 'Request rejected',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _kickMember(int playerId) async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/members/$playerId/kick',
        {},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final locale = Localizations.localeOf(context).languageCode;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl' ? 'Lid verwijderd' : 'Member kicked',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _promoteMember(int playerId) async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/members/$playerId/promote',
        {},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final locale = Localizations.localeOf(context).languageCode;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl' ? 'Lid gepromoveerd' : 'Member promoted',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _demoteMember(int playerId) async {
    if (_myCrew == null) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/members/$playerId/demote',
        {},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final locale = Localizations.localeOf(context).languageCode;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl' ? 'Lid gedegradeerd' : 'Member demoted',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleBankAction({required bool deposit}) async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    final cashStorageCapacity =
        _crewStorage?['capacities']?['cash'] as int? ?? 0;
    if (cashStorageCapacity <= 0) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl'
                  ? 'Koop eerst geldopslag voor de crew bank'
                  : 'Purchase cash storage first for the crew bank',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    final controller = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr(locale, 'Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              deposit
                  ? _tr(locale, 'Storten in crew bank', 'Deposit to crew bank')
                  : _tr(
                      locale,
                      'Opnemen uit crew bank',
                      'Withdraw from crew bank',
                    ),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: _tr(locale, 'Bedrag', 'Amount'),
                prefixText: '€',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr(locale, 'Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(_tr(locale, 'Bevestigen', 'Confirm')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final amount = int.tryParse(controller.text);
    if (amount == null || amount <= 0) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Ongeldig bedrag' : 'Invalid amount',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      final apiClient = AuthService().apiClient;
      final endpoint = deposit
          ? '/crews/${_myCrew!.id}/bank/deposit'
          : '/crews/${_myCrew!.id}/bank/withdraw';
      final response = await apiClient.post(endpoint, {'amount': amount});

      if (response.statusCode == 200) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                deposit
                    ? (locale == 'nl'
                          ? 'Gestort in crew bank'
                          : 'Deposit successful')
                    : (locale == 'nl'
                          ? 'Opname succesvol'
                          : 'Withdrawal successful'),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteCrew() async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr(locale, 'Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _tr(locale, 'Crew verwijderen', 'Delete crew'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tr(
                locale,
                'Weet je zeker dat je de crew wilt verwijderen? Dit kan niet ongedaan worden.',
                'Are you sure you want to delete this crew? This cannot be undone.',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(_tr(locale, 'Annuleren', 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(_tr(locale, 'Verwijderen', 'Delete')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.delete('/crews/${_myCrew!.id}');
      if (response.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(locale == 'nl' ? 'Crew verwijderd' : 'Crew deleted'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _myCrew = null;
          _crewBuildings = [];
          _crewStorage = null;
        });
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _purchaseBuilding(String type) async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    final isHq = type == 'hq';
    final localizedLabel = _getBuildingLabel(type, locale);
    final purchaseLevel = isHq ? 0 : 1;
    String selectedStyle = 'camping';

    if (isHq) {
      final nextStyle = _getNextHqStyle();
      if (nextStyle == null) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl'
                    ? 'Geen volgende HQ-stijl beschikbaar'
                    : 'No next HQ style available',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }
      selectedStyle = nextStyle;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(_tr(locale, 'Weet je het zeker?', 'Are you sure?')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizedLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('${_t(locale, 'label.level')}: $purchaseLevel'),
              const SizedBox(height: 12),
              if (isHq)
                Text(
                  locale == 'nl'
                      ? 'Volgende stijl ontgrendelen'
                      : 'Unlock next style',
                  style: const TextStyle(color: Colors.grey),
                ),
              if (isHq)
                DropdownButtonFormField<String>(
                  initialValue: selectedStyle,
                  items: [selectedStyle]
                      .map(
                        (style) => DropdownMenuItem(
                          value: style,
                          child: Text(_localizedHqStyleLabel(locale, style)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setStateDialog(() {
                      selectedStyle = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: locale == 'nl' ? 'Stijl' : 'Style',
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(locale == 'nl' ? 'Annuleren' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(locale == 'nl' ? 'Kopen' : 'Purchase'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/buildings/$type/purchase',
        {'style': selectedStyle},
      );
      if (response.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Gebouw gekocht' : 'Building purchased',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
        return;
      }

      if (mounted) {
        String message = _tr(locale, 'Actie mislukt', 'Action failed');
        Color color = Colors.red;

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final event = data['event'] as String?;
          message = _buildingActionErrorMessage(locale, event);
          if (event == 'error.hq_style_locked' ||
              event == 'error.hq_style_max' ||
              event == 'error.hq_vip_required' ||
              event == 'error.hq_side_buildings_incomplete' ||
              event == 'error.hq_level_too_low' ||
              event == 'error.building_vip_required') {
            color = Colors.orange;
          }
        } catch (_) {
          // Keep fallback message
        }

        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: color),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _upgradeBuilding(String type) async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    final localizedLabel = _getBuildingLabel(type, locale);
    final currentBuilding = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == type,
      orElse: () => {'level': 0},
    );
    final currentLevel = currentBuilding['level'] as int? ?? 0;
    final nextLevel = currentLevel + 1;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_tr(locale, 'Weet je het zeker?', 'Are you sure?')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizedLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${_t(locale, 'label.level')}: $currentLevel → $nextLevel'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(locale == 'nl' ? 'Annuleren' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(locale == 'nl' ? 'Upgrade' : 'Upgrade'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/crews/${_myCrew!.id}/buildings/$type/upgrade',
        {},
      );
      if (response.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Gebouw geupgrade' : 'Building upgraded',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
        return;
      }

      if (mounted) {
        String message = _tr(locale, 'Actie mislukt', 'Action failed');
        Color color = Colors.red;

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final event = data['event'] as String?;
          if (event == 'error.building_max_level') {
            message = _tr(locale, 'Max level bereikt', 'Max level reached');
            color = Colors.orange;
          } else if (event == 'error.building_not_owned') {
            message = _tr(locale, 'Gebouw niet gekocht', 'Building not owned');
          } else if (event == 'error.insufficient_crew_funds') {
            message = _tr(
              locale,
              'Onvoldoende saldo in crew bank',
              'Insufficient crew bank funds',
            );
          } else if (event == 'error.hq_level_too_low' ||
              event == 'error.hq_vip_required') {
            message = _buildingActionErrorMessage(locale, event);
            color = Colors.orange;
          } else if (event == 'error.hq_side_buildings_incomplete') {
            message = _buildingActionErrorMessage(locale, event);
            color = Colors.orange;
          } else if (event == 'error.building_vip_required') {
            message = _buildingActionErrorMessage(locale, event);
            color = Colors.orange;
          }
        } catch (_) {
          // Keep fallback message
        }

        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(message), backgroundColor: color),
        );
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _depositVehicle({required String vehicleType}) async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/vehicles/mine');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final vehicles = (data['vehicles'] as List).cast<Map<String, dynamic>>();
      final filtered = vehicles
          .where((v) => v['vehicleType'] == vehicleType)
          .toList();

      if (filtered.isEmpty) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl'
                    ? 'Geen voertuigen beschikbaar'
                    : 'No vehicles available',
              ),
            ),
          );
        }
        return;
      }

      int? selectedId = filtered.first['id'] as int?;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text(
              vehicleType == 'car'
                  ? _tr(locale, 'Auto toevoegen', 'Add car')
                  : _tr(locale, 'Boot toevoegen', 'Add boat'),
            ),
            content: DropdownButtonFormField<int>(
              initialValue: selectedId,
              items: filtered
                  .map(
                    (vehicle) => DropdownMenuItem<int>(
                      value: vehicle['id'] as int,
                      child: Text(
                        '${vehicle['definition']?['name'] ?? vehicle['vehicleId']} (#${vehicle['id']})',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setStateDialog(() {
                  selectedId = value;
                });
              },
              decoration: InputDecoration(
                labelText: _tr(locale, 'Selecteer', 'Select'),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_tr(locale, 'Annuleren', 'Cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(_tr(locale, 'Toevoegen', 'Add')),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || selectedId == null) return;

      final endpoint = vehicleType == 'car'
          ? '/crews/${_myCrew!.id}/storage/cars/deposit'
          : '/crews/${_myCrew!.id}/storage/boats/deposit';
      final depositResponse = await apiClient.post(endpoint, {
        'vehicleInventoryId': selectedId,
      });

      if (depositResponse.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Toegevoegd aan crew' : 'Added to crew',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _depositWeapon() async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/weapons/inventory');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final weapons = (data['weapons'] as List).cast<Map<String, dynamic>>();

      if (weapons.isEmpty) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl'
                    ? 'Geen wapens beschikbaar'
                    : 'No weapons available',
              ),
            ),
          );
        }
        return;
      }

      String? selectedWeaponId = weapons.first['weaponId'] as String?;
      final qtyController = TextEditingController(text: '1');

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text(_tr(locale, 'Wapen toevoegen', 'Add weapon')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedWeaponId,
                  items: weapons
                      .map(
                        (weapon) => DropdownMenuItem<String>(
                          value: weapon['weaponId'] as String,
                          child: Text(
                            '${weapon['name'] ?? weapon['weaponId']} (${weapon['quantity']})',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedWeaponId = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: _tr(locale, 'Wapen', 'Weapon'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _tr(locale, 'Aantal', 'Quantity'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_tr(locale, 'Annuleren', 'Cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(_tr(locale, 'Toevoegen', 'Add')),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || selectedWeaponId == null) return;

      final quantity = int.tryParse(qtyController.text) ?? 0;
      final depositResponse = await apiClient.post(
        '/crews/${_myCrew!.id}/storage/weapons/deposit',
        {'weaponId': selectedWeaponId, 'quantity': quantity},
      );

      if (depositResponse.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Toegevoegd aan crew' : 'Added to crew',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _depositAmmo() async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/ammo/inventory');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final ammoList = (data['ammo'] as List).cast<Map<String, dynamic>>();

      if (ammoList.isEmpty) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl'
                    ? 'Geen munitie beschikbaar'
                    : 'No ammo available',
              ),
            ),
          );
        }
        return;
      }

      String? selectedAmmoType = ammoList.first['ammoType'] as String?;
      final qtyController = TextEditingController(text: '100');

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text(_tr(locale, 'Munitie toevoegen', 'Add ammo')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedAmmoType,
                  items: ammoList
                      .map(
                        (ammo) => DropdownMenuItem<String>(
                          value: ammo['ammoType'] as String,
                          child: Text(
                            '${ammo['ammoType']} (${ammo['quantity']})',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedAmmoType = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: _tr(locale, 'Munitie type', 'Ammo type'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _tr(locale, 'Aantal', 'Quantity'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_tr(locale, 'Annuleren', 'Cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(_tr(locale, 'Toevoegen', 'Add')),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || selectedAmmoType == null) return;

      final quantity = int.tryParse(qtyController.text) ?? 0;
      final depositResponse = await apiClient.post(
        '/crews/${_myCrew!.id}/storage/ammo/deposit',
        {'ammoType': selectedAmmoType, 'quantity': quantity},
      );

      if (depositResponse.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Toegevoegd aan crew' : 'Added to crew',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _depositDrugs() async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/trade/inventory');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final goods = (data['inventory'] as List).cast<Map<String, dynamic>>();

      if (goods.isEmpty) {
        if (mounted) {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                locale == 'nl'
                    ? 'Geen goederen beschikbaar'
                    : 'No goods available',
              ),
            ),
          );
        }
        return;
      }

      String? selectedGoodType = goods.first['goodType'] as String?;
      final qtyController = TextEditingController(text: '1');

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: Text(_tr(locale, 'Goederen toevoegen', 'Add goods')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedGoodType,
                  items: goods
                      .map(
                        (good) => DropdownMenuItem<String>(
                          value: good['goodType'] as String,
                          child: Text(
                            '${good['goodName'] ?? good['goodType']} (${good['quantity']})',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedGoodType = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: _tr(locale, 'Goederensoort', 'Goods type'),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _tr(locale, 'Aantal', 'Quantity'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(_tr(locale, 'Annuleren', 'Cancel')),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(_tr(locale, 'Toevoegen', 'Add')),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || selectedGoodType == null) return;

      final quantity = int.tryParse(qtyController.text) ?? 0;
      final depositResponse = await apiClient.post(
        '/crews/${_myCrew!.id}/storage/drugs/deposit',
        {'goodType': selectedGoodType, 'quantity': quantity},
      );

      if (depositResponse.statusCode == 200 && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Toegevoegd aan crew' : 'Added to crew',
            ),
            backgroundColor: Colors.green,
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('Er is een fout opgetreden'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String? _getCrewHqImagePath(String? style, int? level) {
    if (style == null || level == null) {
      print('🏢 HQ image path is null: style=$style, level=$level');
      return null;
    }
    final path = 'assets/images/crew_hq/$style/hq_l$level.png';
    print('🏢 HQ image path: $path');
    return path;
  }

  String? _getCrewBuildingImagePath(String? type, String? style, int? level) {
    if (type == null || style == null || level == null) return null;
    if (type == 'hq') return _getCrewHqImagePath(style, level);

    final normalizedType = type.replaceAll('_storage', '').replaceAll('_', '_');
    return 'assets/images/crew_buildings/$normalizedType/$style/lvl_$level.png';
  }

  IconData _getCrewBuildingIcon(String? type) {
    switch (type) {
      case 'car_storage':
        return Icons.directions_car;
      case 'boat_storage':
        return Icons.directions_boat;
      case 'weapon_storage':
        return Icons.gavel;
      case 'ammo_storage':
        return Icons.inventory_2;
      case 'drug_storage':
        return Icons.medication;
      case 'cash_storage':
        return Icons.account_balance_wallet;
      default:
        return Icons.business;
    }
  }

  String? _getNextHqStyle() {
    if (_crewBuildings.isEmpty) return 'camping';
    final hq = _crewBuildings.firstWhere(
      (building) => building['type'] == 'hq',
      orElse: () => null,
    );
    if (hq == null || hq is! Map<String, dynamic>) {
      return 'camping';
    }

    final level = hq['level'] as int?;
    final maxLevel = hq['maxLevel'] as int? ?? 0;
    final style = hq['style'] as String?;
    if (level == null) {
      return 'camping';
    }
    if (level < maxLevel) {
      return null;
    }

    const styleOrder = ['camping', 'rural', 'city', 'villa', 'vip'];
    final index = style == null ? -1 : styleOrder.indexOf(style);
    if (index < 0) {
      return styleOrder.first;
    }
    if (index >= styleOrder.length - 1) {
      return null;
    }
    return styleOrder[index + 1];
  }

  Widget _buildCrewHqThumbnail(String? style, int? level) {
    print('🏢 Building HQ thumbnail for style=$style, level=$level');
    final path = _getCrewHqImagePath(style, level);
    if (path == null) {
      print('🏢 Showing default icon (no HQ)');
      return const CircleAvatar(child: Icon(Icons.group));
    }
    print('🏢 Loading HQ image from: $path');

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        path,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 56,
          height: 56,
          color: Colors.black12,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported, color: Colors.black45),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(_t(locale, 'app.crews')),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: _t(locale, 'tab.myCrew')),
            Tab(text: _t(locale, 'tab.crewHq')),
            Tab(text: _t(locale, 'tab.members')),
            Tab(text: _t(locale, 'tab.carStorage')),
            Tab(text: _t(locale, 'tab.boatStorage')),
            Tab(text: _t(locale, 'tab.weaponStorage')),
            Tab(text: _t(locale, 'tab.ammoStorage')),
            Tab(text: _t(locale, 'tab.drugStorage')),
            Tab(text: _t(locale, 'tab.cashStorage')),
            Tab(text: _t(locale, 'tab.allCrews')),
            Tab(icon: const Icon(Icons.chat), text: _t(locale, 'tab.chat')),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyCrewTab(),
                _buildBuildingTab('hq'),
                _buildMembersTab(),
                _buildBuildingTab('car_storage'),
                _buildBuildingTab('boat_storage'),
                _buildBuildingTab('weapon_storage'),
                _buildBuildingTab('ammo_storage'),
                _buildBuildingTab('drug_storage'),
                _buildBuildingTab('cash_storage'),
                _buildAllCrewsTab(),
                _buildChatTab(),
              ],
            ),
      floatingActionButton: _myCrew == null
          ? FloatingActionButton.extended(
              onPressed: _createCrew,
              icon: const Icon(Icons.add),
              label: Text(_t(locale, 'action.createCrewShort')),
            )
          : null,
    );
  }

  Widget _buildMyCrewTab() {
    if (_myCrew == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _t(
                Localizations.localeOf(context).languageCode,
                'state.notInCrewYet',
              ),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createCrew,
              icon: const Icon(Icons.add),
              label: Text(
                _t(
                  Localizations.localeOf(context).languageCode,
                  'action.createCrew',
                ),
              ),
            ),
          ],
        ),
      );
    }

    final locale = Localizations.localeOf(context).languageCode;
    final authProvider = Provider.of<AuthProvider>(context);
    final currentPlayerId = authProvider.currentPlayer?.id ?? 0;
    final myMembership = _myCrew!.members.firstWhere(
      (m) => m.playerId == currentPlayerId,
    );
    final isLeader = myMembership.isLeader;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompactMobile = screenWidth < 420;
    final storageCapacities =
        _crewStorage?['capacities'] as Map<String, dynamic>?;
    final carStorageOwned = (storageCapacities?['cars'] as int? ?? 0) > 0;
    final boatStorageOwned = (storageCapacities?['boats'] as int? ?? 0) > 0;
    final weaponStorageOwned = (storageCapacities?['weapons'] as int? ?? 0) > 0;
    final ammoStorageOwned = (storageCapacities?['ammo'] as int? ?? 0) > 0;
    final drugStorageOwned = (storageCapacities?['drugs'] as int? ?? 0) > 0;
    final cashStorageOwned = (storageCapacities?['cash'] as int? ?? 0) > 0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isCompactMobile ? 12 : 16,
          vertical: 16,
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Crew Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.group, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _myCrew!.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    locale == 'nl'
                                        ? '${_myCrew!.memberCount} leden'
                                        : '${_myCrew!.memberCount} members',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.business),
                            title: Text(_t(locale, 'label.crewHq')),
                            subtitle: Text(
                              _myCrew!.hqStyle != null &&
                                      _myCrew!.hqLevel != null
                                  ? '${(_myCrew!.hqStyle ?? 'camping').toUpperCase()}  •  ${_t(locale, 'label.level')} ${_myCrew!.hqLevel}'
                                  : _t(locale, 'status.notOwned'),
                            ),
                            trailing: TextButton(
                              onPressed: () => _tabController.animateTo(1),
                              child: Text(_t(locale, 'action.goToCrewHq')),
                            ),
                          ),
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _t(locale, 'label.crewBank'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '€${_myCrew!.bankBalance.toLocaleString()}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cashStorageOwned
                              ? (locale == 'nl'
                                    ? 'Opslagcapaciteit: €${(_crewStorage?['capacities']?['cash'] ?? 0).toString()}'
                                    : 'Storage capacity: €${(_crewStorage?['capacities']?['cash'] ?? 0).toString()}')
                              : (locale == 'nl'
                                    ? 'Koop eerst geldopslag om de crew bank te gebruiken'
                                    : 'Purchase cash storage first to use the crew bank'),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: cashStorageOwned
                                    ? () => _handleBankAction(deposit: true)
                                    : null,
                                icon: const Icon(Icons.savings),
                                label: Text(_t(locale, 'label.deposit')),
                              ),
                            ),
                            if (isLeader) ...[
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: cashStorageOwned
                                      ? () => _handleBankAction(deposit: false)
                                      : null,
                                  icon: const Icon(Icons.payments_outlined),
                                  label: Text(_t(locale, 'label.withdraw')),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.security, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              _t(locale, 'label.myTrustScore'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${myMembership.trustScore}/100',
                              style: TextStyle(
                                fontSize: 18,
                                color: _getTrustColor(myMembership.trustScore),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (isLeader) ...[
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _deleteCrew,
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
                            label: Text(
                              _t(locale, 'action.deleteCrew'),
                              style: const TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ],
                        if (_crewStats != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.analytics, color: Colors.orange),
                              const SizedBox(width: 8),
                              Text(
                                _t(locale, 'label.crewStats'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            locale == 'nl'
                                ? 'Misdaden: ${_crewStats!['totalCrimes']} | Heists: ${_crewStats!['heistsCompleted']} / ${_crewStats!['heistsAttempted']}'
                                : 'Crimes: ${_crewStats!['totalCrimes']} | Heists: ${_crewStats!['heistsCompleted']} / ${_crewStats!['heistsAttempted']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                        if (!isLeader) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _leaveCrew,
                              icon: const Icon(Icons.exit_to_app),
                              label: Text(_t(locale, 'action.leaveCrew')),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                        if (isLeader) ...[
                          const SizedBox(height: 16),
                          _buildVipStatusCard(locale),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Buildings section with navigation
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.warehouse),
                    title: Text(_t(locale, 'section.buildings')),
                    subtitle: Text(_t(locale, 'hint.buildingsTabs')),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => _tabController.animateTo(1),
                  ),
                ),
                const SizedBox(height: 16),
                // Crew Storage
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _t(locale, 'section.crewStorage'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_crewStorage == null)
                          Text(
                            _t(locale, 'state.noStorageData'),
                            style: const TextStyle(color: Colors.grey),
                          )
                        else ...[
                          Text(
                            locale == 'nl'
                                ? 'Autos: ${_crewStorage!['totals']['cars']} / ${_crewStorage!['capacities']['cars']}'
                                : 'Cars: ${_crewStorage!['totals']['cars']} / ${_crewStorage!['capacities']['cars']}',
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Boten: ${_crewStorage!['totals']['boats']} / ${_crewStorage!['capacities']['boats']}'
                                : 'Boats: ${_crewStorage!['totals']['boats']} / ${_crewStorage!['capacities']['boats']}',
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Wapens: ${_crewStorage!['totals']['weapons']} / ${_crewStorage!['capacities']['weapons']}'
                                : 'Weapons: ${_crewStorage!['totals']['weapons']} / ${_crewStorage!['capacities']['weapons']}',
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Munitie: ${_crewStorage!['totals']['ammo']} / ${_crewStorage!['capacities']['ammo']}'
                                : 'Ammo: ${_crewStorage!['totals']['ammo']} / ${_crewStorage!['capacities']['ammo']}',
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Geldopslag: €${_crewStorage!['totals']['cash']} / €${_crewStorage!['capacities']['cash']}'
                                : 'Cash storage: €${_crewStorage!['totals']['cash']} / €${_crewStorage!['capacities']['cash']}',
                          ),
                          const SizedBox(height: 12),
                          Text(
                            locale == 'nl'
                                ? 'Stortacties zijn alleen beschikbaar als de juiste opslag is gekocht.'
                                : 'Deposit actions are only available once the matching storage is purchased.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton(
                                onPressed: carStorageOwned
                                    ? () => _depositVehicle(vehicleType: 'car')
                                    : null,
                                child: Text(_t(locale, 'action.addCar')),
                              ),
                              OutlinedButton(
                                onPressed: boatStorageOwned
                                    ? () => _depositVehicle(vehicleType: 'boat')
                                    : null,
                                child: Text(_t(locale, 'action.addBoat')),
                              ),
                              OutlinedButton(
                                onPressed: weaponStorageOwned
                                    ? _depositWeapon
                                    : null,
                                child: Text(_t(locale, 'action.addWeapon')),
                              ),
                              OutlinedButton(
                                onPressed: ammoStorageOwned
                                    ? _depositAmmo
                                    : null,
                                child: Text(_t(locale, 'action.addAmmo')),
                              ),
                              OutlinedButton(
                                onPressed: drugStorageOwned
                                    ? _depositDrugs
                                    : null,
                                child: Text(_t(locale, 'action.addDrugs')),
                              ),
                            ],
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Drugs: ${_crewStorage!['totals']['drugs']} / ${_crewStorage!['capacities']['drugs']}'
                                : 'Drugs: ${_crewStorage!['totals']['drugs']} / ${_crewStorage!['capacities']['drugs']}',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.groups),
                    title: Text(_t(locale, 'section.membersOverview')),
                    subtitle: Text(_t(locale, 'hint.membersTab')),
                    trailing: TextButton(
                      onPressed: () => _tabController.animateTo(2),
                      child: Text(_t(locale, 'action.goToMembers')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBuildingTab(String buildingType) {
    final locale = Localizations.localeOf(context).languageCode;
    if (_myCrew == null) {
      return Center(
        child: Text(
          _t(locale, 'state.joinCrewFirst'),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    final currentPlayerId = authProvider.currentPlayer?.id ?? 0;
    final myMembership = _myCrew!.members.firstWhere(
      (m) => m.playerId == currentPlayerId,
    );
    final isLeader = myMembership.isLeader;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: _buildSingleBuildingCard(buildingType, locale, isLeader),
      ),
    );
  }

  Widget _buildMembersTab() {
    final locale = Localizations.localeOf(context).languageCode;
    if (_myCrew == null) {
      return Center(
        child: Text(
          _t(locale, 'state.joinCrewFirst'),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final authProvider = Provider.of<AuthProvider>(context);
    final currentPlayerId = authProvider.currentPlayer?.id ?? 0;
    final myMembership = _myCrew!.members.firstWhere(
      (m) => m.playerId == currentPlayerId,
    );
    final isLeader = myMembership.isLeader;
    final screenWidth = MediaQuery.of(context).size.width;
    final memberGridColumns = screenWidth >= 900 ? 2 : 1;
    final joinRequestGridColumns = screenWidth >= 900 ? 2 : 1;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t(locale, 'tab.members'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: memberGridColumns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: memberGridColumns == 1 ? 3.4 : 3.8,
              children: _myCrew!.members
                  .map(
                    (member) => Card(
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () => _openPlayerProfile(
                            member.playerId,
                            member.playerInfo?.username ?? 'Unknown',
                          ),
                          child: CircleAvatar(
                            backgroundColor: member.isLeader
                                ? Colors.amber
                                : (member.role == 'co_leader'
                                      ? Colors.deepPurple
                                      : Colors.blue),
                            child: Icon(
                              member.isLeader ? Icons.star : Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () => _openPlayerProfile(
                            member.playerId,
                            member.playerInfo?.username ?? 'Unknown',
                          ),
                          child: Text(
                            member.playerInfo?.username ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: member.isLeader
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          '${locale == 'nl' ? 'Rank' : 'Rank'}: ${member.playerInfo?.rank ?? 0} | Trust: ${member.trustScore}/100',
                        ),
                        trailing: isLeader && !member.isLeader
                            ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'kick') {
                                    _kickMember(member.playerId);
                                  } else if (value == 'promote') {
                                    _promoteMember(member.playerId);
                                  } else if (value == 'demote') {
                                    _demoteMember(member.playerId);
                                  }
                                },
                                itemBuilder: (context) {
                                  final items = <PopupMenuEntry<String>>[];
                                  if (member.role == 'co_leader') {
                                    items.add(
                                      PopupMenuItem(
                                        value: 'demote',
                                        child: Text(
                                          locale == 'nl'
                                              ? 'Degradeer'
                                              : 'Demote',
                                        ),
                                      ),
                                    );
                                  } else {
                                    items.add(
                                      PopupMenuItem(
                                        value: 'promote',
                                        child: Text(
                                          locale == 'nl'
                                              ? 'Promoveer'
                                              : 'Promote',
                                        ),
                                      ),
                                    );
                                  }
                                  items.add(
                                    PopupMenuItem(
                                      value: 'kick',
                                      child: Text(
                                        locale == 'nl' ? 'Verwijder' : 'Kick',
                                      ),
                                    ),
                                  );
                                  return items;
                                },
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: member.isLeader
                                      ? Colors.amber
                                      : (member.role == 'co_leader'
                                            ? Colors.deepPurple
                                            : Colors.blue),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  member.isLeader
                                      ? (locale == 'nl' ? 'Leader' : 'Leader')
                                      : (member.role == 'co_leader'
                                            ? (locale == 'nl'
                                                  ? 'Co-Leader'
                                                  : 'Co-Leader')
                                            : (locale == 'nl'
                                                  ? 'Member'
                                                  : 'Member')),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (isLeader) ...[
              const SizedBox(height: 16),
              Text(
                _t(locale, 'state.joinRequests'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_joinRequests.isEmpty)
                Text(
                  _t(locale, 'state.noJoinRequests'),
                  style: const TextStyle(color: Colors.grey),
                )
              else
                GridView.count(
                  crossAxisCount: joinRequestGridColumns,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: joinRequestGridColumns == 1 ? 4.0 : 4.2,
                  children: _joinRequests
                      .map(
                        (request) => Card(
                          child: ListTile(
                            leading: GestureDetector(
                              onTap: () => _openPlayerProfile(
                                request.player.id,
                                request.player.username,
                              ),
                              child: const Icon(Icons.person_add),
                            ),
                            title: GestureDetector(
                              onTap: () => _openPlayerProfile(
                                request.player.id,
                                request.player.username,
                              ),
                              child: Text(request.player.username),
                            ),
                            subtitle: Text(
                              '${locale == 'nl' ? 'Rank' : 'Rank'}: ${request.player.rank}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  onPressed: () =>
                                      _approveJoinRequest(request.id),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () =>
                                      _rejectJoinRequest(request.id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSingleBuildingCard(
    String buildingType,
    String locale,
    bool isLeader,
  ) {
    final building = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == buildingType,
      orElse: () => {
        'type': buildingType,
        'label': _getBuildingLabel(buildingType, locale),
        'level': null,
      },
    );

    final currentHq = _crewBuildings.firstWhere(
      (b) => b['type'] == 'hq',
      orElse: () => {'style': 'camping'},
    );
    final hqStyle = currentHq['style'] as String? ?? 'camping';

    final type = building['type'] as String?;
    final level = building['level'] as int?;
    final maxLevel = building['maxLevel'] as int? ?? 0;
    final label = building['label'] as String? ?? 'Building';
    final imagePath = _getCrewBuildingImagePath(type, hqStyle, level);
    final capacity = building['capacity'] as int?;
    final memberCap = building['memberCap'] as int?;
    final parkingSlots = building['parkingSlots'] as int?;
    final nextCost = building['nextUpgradeCost'] as int?;
    final crewVip = building['crewVip'] as bool? ?? false;
    final allowedLevelByHq = building['allowedLevelByHq'] as int? ?? 0;

    final status = level == null
        ? _t(locale, 'status.notOwned')
        : '${_t(locale, 'label.level')} $level/$maxLevel';

    if (type == 'hq') {
      final displayLevel = _getHqGlobalLevel(
        building['style'] as String?,
        level,
      );
      final displayCap = memberCap ?? 0;
      final requiredSideLevel = _requiredSideBuildingLevelForHqUpgrade(
        building['style'] as String?,
        level,
      );
      final missingSideBuildings =
          (level != null && level < maxLevel && nextCost != null)
          ? _getMissingSideBuildingsForHqUpgrade(requiredSideLevel, locale)
          : <String>[];
      final hqUpgradeBlockedBySideBuildings = missingSideBuildings.isNotEmpty;

      return LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final imageWidth = width < 600
              ? width
              : width < 1000
              ? 380.0
              : 420.0;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: imageWidth,
                  child: AspectRatio(
                    aspectRatio: 2 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          if (imagePath != null)
                            Positioned.fill(
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.grey.shade800,
                                          Colors.grey.shade900,
                                        ],
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.business,
                                      color: Colors.amber.shade600,
                                      size: 56,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.grey.shade800,
                                      Colors.grey.shade900,
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.business,
                                  color: Colors.amber.shade600,
                                  size: 56,
                                ),
                              ),
                            ),
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber.shade400,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$displayLevel',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.group,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '$displayCap',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (level == null)
                          ? (isLeader
                                ? () => _purchaseBuilding(type ?? '')
                                : null)
                          : (level < maxLevel && nextCost != null)
                          ? (isLeader && !hqUpgradeBlockedBySideBuildings
                                ? () => _upgradeBuilding(type ?? '')
                                : null)
                          : null,
                      child: Text(
                        (level == null)
                            ? _t(locale, 'action.purchase')
                            : (level < maxLevel && nextCost != null)
                            ? '${_t(locale, 'action.upgrade')} (€${nextCost.toString()})'
                            : status,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: _t(locale, 'help.showCaps'),
                    onPressed: () =>
                        _showBuildingCapsDialog(locale, type ?? '', label),
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              if (!isLeader &&
                  ((level == null) || (level < maxLevel && nextCost != null)))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _tr(
                      locale,
                      'Alleen de leader kan kopen of upgraden',
                      'Only the leader can purchase or upgrade',
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              if (isLeader && hqUpgradeBlockedBySideBuildings)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: width < 600
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tr(
                                locale,
                                'HQ upgrade geblokkeerd: bijgebouwen eerst naar L$requiredSideLevel',
                                'HQ upgrade blocked: side buildings first to L$requiredSideLevel',
                              ),
                              style: const TextStyle(color: Colors.orange),
                            ),
                            const SizedBox(height: 4),
                            TextButton.icon(
                              onPressed: () => _showHqUpgradeRequirementsDialog(
                                locale,
                                requiredSideLevel,
                                missingSideBuildings,
                              ),
                              icon: const Icon(Icons.info_outline, size: 16),
                              label: Text(_t(locale, 'action.details')),
                            ),
                          ],
                        )
                      : Text(
                          locale == 'nl'
                              ? 'Upgrade eerst alle bijgebouwen naar minimaal level $requiredSideLevel. Ontbreekt: ${missingSideBuildings.join(', ')}'
                              : 'Upgrade all side buildings to at least level $requiredSideLevel first. Missing: ${missingSideBuildings.join(', ')}',
                          style: const TextStyle(color: Colors.orange),
                        ),
                ),
              if (isLeader &&
                  level != null &&
                  level < maxLevel &&
                  nextCost == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _tr(
                      locale,
                      'Volgende upgrade nog niet beschikbaar',
                      'Next upgrade not available yet',
                    ),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
            ],
          );
        },
      );
    }

    final displayLevel = level ?? 0;
    final displayCapValue = capacity ?? parkingSlots ?? memberCap ?? 0;
    final displayCapIcon = parkingSlots != null
        ? Icons.local_parking
        : (memberCap != null ? Icons.group : Icons.inventory_2);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final imageWidth = width < 600
            ? width
            : width < 1000
            ? 380.0
            : 420.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: imageWidth,
                child: AspectRatio(
                  aspectRatio: 2 / 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        if (imagePath != null)
                          Positioned.fill(
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.grey.shade800,
                                        Colors.grey.shade900,
                                      ],
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    _getCrewBuildingIcon(type),
                                    color: Colors.amber.shade600,
                                    size: 56,
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey.shade800,
                                    Colors.grey.shade900,
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                _getCrewBuildingIcon(type),
                                color: Colors.amber.shade600,
                                size: 56,
                              ),
                            ),
                          ),
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade400,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$displayLevel',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  displayCapIcon,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '$displayCapValue',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (level == null)
                        ? (isLeader
                              ? () => _purchaseBuilding(type ?? '')
                              : null)
                        : (level < maxLevel && nextCost != null)
                        ? (isLeader ? () => _upgradeBuilding(type ?? '') : null)
                        : null,
                    child: Text(
                      (level == null)
                          ? _t(locale, 'action.purchase')
                          : (level < maxLevel && nextCost != null)
                          ? '${_t(locale, 'action.upgrade')} (€${nextCost.toString()})'
                          : status,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: _t(locale, 'help.showCaps'),
                  onPressed: () =>
                      _showBuildingCapsDialog(locale, type ?? '', label),
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
            if (!isLeader &&
                ((level == null) || (level < maxLevel && nextCost != null)))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _tr(
                    locale,
                    'Alleen de leader kan kopen of upgraden',
                    'Only the leader can purchase or upgrade',
                  ),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            if (level != null && allowedLevelByHq < level)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _tr(
                    locale,
                    'HQ progression te laag',
                    'HQ progression too low',
                  ),
                  style: const TextStyle(color: Colors.orange),
                ),
              ),
            if (isLeader &&
                level != null &&
                level < maxLevel &&
                nextCost == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  level >= 10 && crewVip && hqStyle != 'vip'
                      ? _tr(
                          locale,
                          'VIP HQ vereist voor level 11-15',
                          'VIP HQ required for level 11-15',
                        )
                      : _tr(
                          locale,
                          'HQ-level te laag voor volgende upgrade',
                          'HQ level too low for next upgrade',
                        ),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getBuildingLabel(String buildingType, String locale) {
    const labels = {
      'hq': {'nl': 'Crew HQ', 'en': 'Crew HQ'},
      'car_storage': {'nl': 'Auto opslag', 'en': 'Car Storage'},
      'boat_storage': {'nl': 'Haven', 'en': 'Boat Storage'},
      'weapon_storage': {'nl': 'Wapen opslag', 'en': 'Weapon Storage'},
      'ammo_storage': {'nl': 'Munitie opslag', 'en': 'Ammo Storage'},
      'drug_storage': {'nl': 'Drugs opslag', 'en': 'Drug Storage'},
      'cash_storage': {'nl': 'Cash opslag', 'en': 'Cash Storage'},
    };
    final lang = locale == 'nl' ? 'nl' : 'en';
    return labels[buildingType]?[lang] ?? buildingType;
  }

  Widget _buildAllCrewsTab() {
    final locale = Localizations.localeOf(context).languageCode;

    if (_allCrews.isEmpty) {
      return Center(
        child: Text(
          _t(locale, 'state.noCrewsFound'),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allCrews.length,
        itemBuilder: (context, index) {
          final crew = _allCrews[index];
          final isMyCrew = _myCrew?.id == crew.id;

          return Card(
            child: ListTile(
              leading: _buildCrewHqThumbnail(crew.hqStyle, crew.hqLevel),
              title: Text(
                crew.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_t(locale, 'label.memberCount')}: ${crew.memberCount}',
                  ),
                  Text(
                    '${locale == 'nl' ? 'Leader' : 'Leader'}: ${crew.leader?.playerInfo?.username ?? 'Unknown'}',
                  ),
                  if (crew.leader?.playerInfo != null)
                    GestureDetector(
                      onTap: () => _openPlayerProfile(
                        crew.leader!.playerId,
                        crew.leader!.playerInfo!.username,
                      ),
                      child: Text(
                        locale == 'nl'
                            ? 'Open leiderprofiel'
                            : 'Open leader profile',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                ],
              ),
              trailing: isMyCrew
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _t(locale, 'badge.myCrew'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _myCrew != null
                  ? null
                  : ElevatedButton(
                      onPressed: () => _joinCrew(crew.id),
                      child: Text(_t(locale, 'action.join')),
                    ),
            ),
          );
        },
      ),
    );
  }

  Color _getTrustColor(int trust) {
    if (trust >= 75) return Colors.green;
    if (trust >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildChatTab() {
    if (_myCrew == null) {
      final locale = Localizations.localeOf(context).languageCode;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _t(locale, 'state.notInCrew'),
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              _t(locale, 'hint.chatJoinCrew'),
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return CrewChatWidget(crewId: _myCrew!.id);
  }
}

// Extension to format numbers with thousand separators
extension IntExtensions on int {
  String toLocaleString() {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
