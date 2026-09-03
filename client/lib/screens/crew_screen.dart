import 'package:flutter/foundation.dart';
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
import '../utils/formatters.dart';
import '../utils/web_asset_helper.dart';
import '../utils/trade_good_l10n.dart';
import '../l10n/app_localizations.dart';
import '../widgets/crew_heists_panel.dart';
import 'black_market_screen.dart';
class CrewScreen extends StatefulWidget {
  const CrewScreen({super.key});

  @override
  State<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends State<CrewScreen>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _oneTimeProducts = [];

  Future<void> _openCheckoutUrl(String checkoutUrl) async {
    final uri = Uri.parse(checkoutUrl);
    final opened = kIsWeb
        ? await launchUrl(uri, webOnlyWindowName: '_self')
        : await launchUrl(uri, mode: LaunchMode.platformDefault);

    if (!opened) {
      throw Exception('checkout_launch_failed');
    }
  }

  static const List<String> _hqStyleOrder = [
    'camping',
    'rural',
    'city',
    'villa',
    'vip',
  ];
  static const List<int> _hqMemberCapsByGlobalLevel = [
    5,
    10,
    16,
    24,
    32,
    40,
    50,
    60,
    72,
    84,
    96,
    108,
    118,
    126,
    133,
    139,
    144,
    147,
    149,
    150,
  ];

  late TabController _tabController;
  Crew? _myCrew;
  List<Crew> _allCrews = [];
  final Set<int> _pendingJoinCrewIds = <int>{};
  Map<String, dynamic>? _crewWeeklyGoal;
  List<CrewJoinRequest> _joinRequests = [];
  Map<String, int>? _crewStats;
  List<dynamic> _crewBuildings = [];
  Map<String, dynamic>? _crewStorage;
  Map<String, dynamic>? _crewWarHub;
  Map<String, dynamic>? _crewMissionsOverview;
  final Map<int, Map<String, dynamic>> _crewMissionSpeedupQuotes = {};
  final Set<int> _crewMissionSpeedupQuoteLoading = <int>{};
  bool _loading = true;
  bool _crewWarLoading = false;
  bool _crewMissionsLoading = false;
  bool _crewMissionActionLoading = false;
  String _selectedWarType = 'kill_war';
  int? _selectedWarTargetCrewId;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  void _openPlayerProfile(int playerId, String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  String _crewMapLookup(AppLocalizations l10n, String key, [Map<String, String>? params]) {
      switch (key) {
        case 'app.crews': return l10n.crewUiAppCrews;
        case 'tab.myCrew': return l10n.crewUiTabMyCrew;
        case 'tab.crewHq': return l10n.crewUiTabCrewHq;
        case 'tab.storageHub': return l10n.crewUiTabStorageHub;
        case 'tab.members': return l10n.crewUiTabMembers;
        case 'tab.warRoom': return l10n.crewUiTabWarRoom;
        case 'tab.crewMissions': return l10n.crewUiTabCrewMissions;
        case 'tab.carStorage': return l10n.crewUiTabCarStorage;
        case 'tab.boatStorage': return l10n.crewUiTabBoatStorage;
        case 'tab.weaponStorage': return l10n.crewUiTabWeaponStorage;
        case 'tab.ammoStorage': return l10n.crewUiTabAmmoStorage;
        case 'tab.drugStorage': return l10n.crewUiTabDrugStorage;
        case 'tab.cashStorage': return l10n.crewUiTabCashStorage;
        case 'tab.allCrews': return l10n.crewUiTabAllCrews;
        case 'tab.chat': return l10n.crewUiTabChat;
        case 'action.createCrewShort': return l10n.crewUiActionCreateCrewShort;
        case 'state.notInCrewYet': return l10n.crewUiStateNotInCrewYet;
        case 'action.createCrew': return l10n.crewUiActionCreateCrew;
        case 'label.crewBank': return l10n.crewUiLabelCrewBank;
        case 'label.deposit': return l10n.crewUiLabelDeposit;
        case 'label.withdraw': return l10n.crewUiLabelWithdraw;
        case 'label.myTrustScore': return l10n.crewUiLabelMyTrustScore;
        case 'action.deleteCrew': return l10n.crewUiActionDeleteCrew;
        case 'label.crewStats': return l10n.crewUiLabelCrewStats;
        case 'action.leaveCrew': return l10n.crewUiActionLeaveCrew;
        case 'section.buildings': return l10n.crewUiSectionBuildings;
        case 'hint.buildingsTabs': return l10n.crewUiHintBuildingsTabs;
        case 'section.crewStorage': return l10n.crewUiSectionCrewStorage;
        case 'state.noStorageData': return l10n.crewUiStateNoStorageData;
        case 'action.addCar': return l10n.crewUiActionAddCar;
        case 'action.addBoat': return l10n.crewUiActionAddBoat;
        case 'action.addWeapon': return l10n.crewUiActionAddWeapon;
        case 'action.addAmmo': return l10n.crewUiActionAddAmmo;
        case 'action.addDrugs': return l10n.crewUiActionAddDrugs;
        case 'section.membersOverview': return l10n.crewUiSectionMembersOverview;
        case 'hint.membersTab': return l10n.crewUiHintMembersTab;
        case 'action.goToMembers': return l10n.crewUiActionGoToMembers;
        case 'label.crewHq': return l10n.crewUiLabelCrewHq;
        case 'action.goToCrewHq': return l10n.crewUiActionGoToCrewHq;
        case 'action.goToStorage': return l10n.crewUiActionGoToStorage;
        case 'state.joinCrewFirst': return l10n.crewUiStateJoinCrewFirst;
        case 'state.joinRequests': return l10n.crewUiStateJoinRequests;
        case 'state.noJoinRequests': return l10n.crewUiStateNoJoinRequests;
        case 'state.noCrewsFound': return l10n.crewUiStateNoCrewsFound;
        case 'label.memberCount': return l10n.crewUiLabelMemberCount;
        case 'badge.myCrew': return l10n.crewUiBadgeMyCrew;
        case 'action.join': return l10n.crewUiActionJoin;
        case 'state.notInCrew': return l10n.crewUiStateNotInCrew;
        case 'hint.chatJoinCrew': return l10n.crewUiHintChatJoinCrew;
        case 'status.notOwned': return l10n.crewUiStatusNotOwned;
        case 'label.level': return l10n.crewUiLabelLevel;
        case 'label.capacity': return l10n.crewUiLabelCapacity;
        case 'label.memberCap': return l10n.crewUiLabelMemberCap;
        case 'label.parking': return l10n.crewUiLabelParking;
        case 'action.purchase': return l10n.crewUiActionPurchase;
        case 'action.upgrade': return l10n.crewUiActionUpgrade;
        case 'action.details': return l10n.crewUiActionDetails;
        case 'help.capsTitle': return l10n.crewUiHelpCapsTitle;
        case 'help.level': return l10n.crewUiHelpLevel;
        case 'help.capacity': return l10n.crewUiHelpCapacity;
        case 'help.upgradeCost': return l10n.crewUiHelpUpgradeCost;
        case 'help.close': return l10n.crewUiHelpClose;
        case 'help.showCaps': return l10n.crewUiHelpShowCaps;
        case 'section.upgradeHub': return l10n.crewUiSectionUpgradeHub;
        case 'section.storageHub': return l10n.crewUiSectionStorageHub;
        case 'hint.storageTab': return l10n.crewUiHintStorageTab;
        case 'hint.upgradeHub': return l10n.crewUiHintUpgradeHub;
        case 'section.crewMissions': return l10n.crewUiSectionCrewMissions;
        case 'state.crewMissionsEmpty': return l10n.crewUiStateCrewMissionsEmpty;
        case 'state.crewMissionNoCrew': return l10n.crewUiStateCrewMissionNoCrew;
        case 'action.startMission': return l10n.crewUiActionStartMission;
        case 'action.configureAndStartMission': return l10n.crewUiActionConfigureAndStartMission;
        case 'action.resolveMission': return l10n.crewUiActionResolveMission;
        case 'action.claimRewards': return l10n.crewUiActionClaimRewards;
        case 'action.speedupCooldown': return l10n.crewUiActionSpeedupCooldown;
        case 'action.confirmSpeedupCooldown': return l10n.crewUiActionConfirmSpeedupCooldown;
        case 'label.activeMission': return l10n.crewUiLabelActiveMission;
        case 'label.recentMissions': return l10n.crewUiLabelRecentMissions;
        case 'label.missionDuration': return l10n.crewUiLabelMissionDuration;
        case 'label.missionCooldown': return l10n.crewUiLabelMissionCooldown;
        case 'label.missionTier': return l10n.crewUiLabelMissionTier;
        case 'label.missionRewards': return l10n.crewUiLabelMissionRewards;
        case 'label.missionTradeCargo': return l10n.crewUiLabelMissionTradeCargo;
        case 'hint.missionTradeCargo': return l10n.crewUiHintMissionTradeCargo;
        case 'label.crewMissionProgress': return l10n.crewUiLabelCrewMissionProgress;
        case 'label.crewMissionXp': return l10n.crewUiLabelCrewMissionXp;
        case 'label.crewMissionLevelBonus': return l10n.crewUiLabelCrewMissionLevelBonus;
        case 'label.crewMissionNextLevelBonus': return l10n.crewUiLabelCrewMissionNextLevelBonus;
        case 'label.missionStatus': return l10n.crewUiLabelMissionStatus;
        case 'label.cooldownActive': return l10n.crewUiLabelCooldownActive;
        case 'label.roleContributions': return l10n.crewUiLabelRoleContributions;
        case 'label.contribution': return l10n.crewUiLabelContribution;
        case 'label.multiplier': return l10n.crewUiLabelMultiplier;
        case 'status.missionLocked': return l10n.crewUiStatusMissionLocked;
        case 'status.inProgress': return l10n.crewUiStatusInProgress;
        case 'status.completed': return l10n.crewUiStatusCompleted;
        case 'status.ready': return l10n.crewUiStatusReady;
        case 'status.rewardsClaimed': return l10n.crewUiStatusRewardsClaimed;
        case 'state.missionActionBusy': return l10n.crewUiStateMissionActionBusy;
        case 'hint.missionLeaderOnly': return l10n.crewUiHintMissionLeaderOnly;
        case 'dialog.roleAssignTitle': return l10n.crewUiDialogRoleAssignTitle;
        case 'dialog.roleAssignSubtitle': return l10n.crewUiDialogRoleAssignSubtitle;
        case 'label.roleNone': return l10n.crewUiLabelRoleNone;
        case 'label.rolePlanner': return l10n.crewUiLabelRolePlanner;
        case 'label.roleEnforcer': return l10n.crewUiLabelRoleEnforcer;
        case 'label.roleLogistics': return l10n.crewUiLabelRoleLogistics;
        case 'label.roleTech': return l10n.crewUiLabelRoleTech;
        case 'hint.roleBonus': return l10n.crewUiHintRoleBonus;
        case 'state.roleAssignNoMembers': return l10n.crewUiStateRoleAssignNoMembers;
        case 'state.roleAssignPickOne': return l10n.crewUiStateRoleAssignPickOne;
        case 'hint.missionLockedTier2': return l10n.crewUiHintMissionLockedTier2;
        case 'hint.missionLockedTier3': return l10n.crewUiHintMissionLockedTier3;
        case 'hint.missionLockedDefault': return l10n.crewUiHintMissionLockedDefault;
        case 'message.missionOverviewLoadFailed': return l10n.crewUiMessageMissionOverviewLoadFailed;
        case 'message.missionStarted': return l10n.crewUiMessageMissionStarted;
        case 'message.missionResolved': return l10n.crewUiMessageMissionResolved;
        case 'message.missionRewardsClaimed': return l10n.crewUiMessageMissionRewardsClaimed;
        case 'message.missionCooldownSpedUp': return l10n.crewUiMessageMissionCooldownSpedUp;
        case 'message.missionSpeedupQuoteFailed': return l10n.crewUiMessageMissionSpeedupQuoteFailed;
        case 'dialog.speedupTitle': return l10n.crewUiDialogSpeedupTitle;
        case 'dialog.speedupBody':
          return l10n.crewUiDialogSpeedupBody(
            params?['credits'] ?? '',
            params?['minutes'] ?? '',
          );
        case 'label.credits': return l10n.crewUiLabelCredits;
        case 'state.loadingPrice': return l10n.crewUiStateLoadingPrice;
        case 'action.cancel': return l10n.crewUiActionCancel;
        case 'hint.missionUnlockCta': return l10n.crewUiHintMissionUnlockCta;
        case 'action.goToHqForMissions': return l10n.crewUiActionGoToHqForMissions;
        case 'action.goToTradeMarket': return l10n.crewUiActionGoToTradeMarket;
        case 'hint.missionPrepReady': return l10n.crewUiHintMissionPrepReady;
        case 'hint.missionPrepShort': return l10n.crewUiHintMissionPrepShort;
        case 'hint.missionLevelProgress': return l10n.crewUiHintMissionLevelProgress;
        default: return key;
      }
    }


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
    'trade_storage': [
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
    'trade_storage': [
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

  String _t(AppLocalizations l10n, String key) => _crewMapLookup(l10n, key);

  String _localizedHqStyleLabel(AppLocalizations loc, String style) {
    final isNl = loc.localeName.startsWith('nl');
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
    return _hqMemberCapsByGlobalLevel;
  }

  List<int> _getHqCostsByGlobalLevel() {
    const globalMaxLevel = 19;
    const growthMultiplier = 1.55;
    final costs = <int>[0, 75000, 250000, 900000];
    for (var level = costs.length; level <= globalMaxLevel; level++) {
      costs.add((costs[level - 1] * growthMultiplier).round());
    }
    return costs;
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
    AppLocalizations loc,
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
        final label = _getBuildingLabel(sideType, loc);
        missing.add('$label L${sideLevel ?? 0}');
      }
    }

    return missing;
  }

  Future<void> _showHqUpgradeRequirementsDialog(
    int requiredSideLevel,
    List<String> missingSideBuildings,
  ) async {
    final message = l10n.crewUiHqUpgradeSideBuildingsMessage(
      requiredSideLevel.toString(),
      missingSideBuildings.isEmpty
          ? '—'
          : '- ${missingSideBuildings.join('\n- ')}',
    );

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.crewUiTr0,
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t(l10n, 'help.close')),
          ),
        ],
      ),
    );
  }

  Future<void> _showBuildingCapsDialog(
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
        ? _t(l10n, 'label.memberCap')
        : _t(l10n, 'help.capacity');

    const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const dataStyle = TextStyle(fontSize: 12);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_t(l10n, 'help.capsTitle')} - $buildingLabel'),
        content: SizedBox(
          width: 380,
          child: ListView(
            shrinkWrap: true,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 36,
                    child: Text(_t(l10n, 'help.level'), style: headerStyle),
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
                      _t(l10n, 'help.upgradeCost'),
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
                    ? 'L$index (${_localizedHqStyleLabel(l10n, _hqStyleOrder[index ~/ 4])})'
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
            child: Text(_t(l10n, 'help.close')),
          ),
        ],
      ),
    );
  }

  String _tParam(AppLocalizations l10n, String key, Map<String, String> params) {
    var text = _crewMapLookup(l10n, key, params);
    params.forEach((paramKey, paramValue) {
      text = text.replaceAll('{$paramKey}', paramValue);
    });
    return text;
  }

  String _money(num amount) => formatCurrency(amount);

  String _buildingActionErrorMessage(AppLocalizations l10n, String? event) {
    switch (event) {
      case 'error.hq_style_locked':
        return l10n.crewUiTr1;
      case 'error.hq_style_max':
        return l10n.crewUiTr2;
      case 'error.hq_vip_required':
        return l10n.crewUiTr3;
      case 'error.hq_side_buildings_incomplete':
        return l10n.crewUiTr4;
      case 'error.building_already_owned':
        return l10n.crewUiTr5;
      case 'error.insufficient_crew_funds':
        return l10n.crewUiTr6;
      case 'error.hq_level_too_low':
        return l10n.crewUiTr7;
      case 'error.building_vip_required':
        return l10n.crewUiTr8;
      case 'error.cash_bootstrap_limit_reached':
        return l10n.crewUiTr9;
      default:
        return l10n.crewUiTr10;
    }
  }

  Map<String, dynamic> _decodeJsonBody(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return <String, dynamic>{};
  }

  String _crewMissionErrorMessage(AppLocalizations l10n, String? event) {
    switch (event) {
      case 'error.not_in_crew':
        return _t(l10n, 'state.crewMissionNoCrew');
      case 'error.mission_permission_denied':
        return _t(l10n, 'hint.missionLeaderOnly');
      case 'error.mission_already_in_progress':
        return l10n.crewUiTr11;
      case 'error.mission_cooldown_active':
        return l10n.crewUiTr12;
      case 'error.mission_template_not_found':
        return l10n.crewUiTr13;
      case 'error.mission_tier_locked':
        return l10n.crewUiTr14;
      case 'error.mission_run_not_found':
        return l10n.crewUiTr15;
      case 'error.mission_already_resolved':
        return l10n.crewUiTr16;
      case 'error.mission_not_completed':
        return l10n.crewUiTr17;
      case 'error.mission_rewards_already_claimed':
        return _t(l10n, 'status.rewardsClaimed');
      case 'error.mission_cooldown_not_active':
        return l10n.crewUiTr18;
      case 'error.insufficient_credits':
        return l10n.crewUiTr19;
      case 'error.mission_trade_requirements_not_met':
        return l10n.crewUiErrorMissionTradeRequirementsNotMet;
      default:
        return l10n.crewUiTr10;
    }
  }

  String _crewMissionLockedReason(AppLocalizations loc, String? reason) {
    switch (reason) {
      case 'TIER2_REQUIRES_HQ5_AND_2_MEMBERS':
        return _t(loc, 'hint.missionLockedTier2');
      case 'TIER3_REQUIRES_HQ9_AND_3_MEMBERS':
        return _t(loc, 'hint.missionLockedTier3');
      default:
        return _t(loc, 'hint.missionLockedDefault');
    }
  }

  int _secondsUntil(String? isoString) {
    if (isoString == null || isoString.isEmpty) return 0;
    try {
      final target = DateTime.parse(isoString).toUtc();
      final now = DateTime.now().toUtc();
      final diff = target.difference(now).inSeconds;
      return diff > 0 ? diff : 0;
    } catch (_) {
      return 0;
    }
  }

  String _formatRemaining(int seconds, AppLocalizations loc) {
    final mins = (seconds / 60).ceil();
    if (mins < 1) {
      return loc.crewUiFormatRemainingUnderOneMinute;
    }
    return loc.crewUiFormatRemainingMinutes(mins);
  }

  Future<void> _loadCrewMissionsOverview({bool silent = false}) async {
    if (_myCrew == null) {
      if (mounted) {
        setState(() {
          _crewMissionsOverview = null;
          _crewMissionsLoading = false;
          _crewMissionSpeedupQuotes.clear();
          _crewMissionSpeedupQuoteLoading.clear();
        });
      }
      return;
    }

    if (!silent && mounted) {
      setState(() => _crewMissionsLoading = true);
    }
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crew-missions/overview');
      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        if (mounted) {
          setState(() {
            _crewMissionsOverview = data;
            _crewMissionSpeedupQuotes.clear();
            _crewMissionSpeedupQuoteLoading.clear();
          });
        }
      } else if (!silent && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionOverviewLoadFailed')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (!silent && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionOverviewLoadFailed')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _crewMissionsLoading = false);
      }
    }
  }

  String _crewRoleLabel(AppLocalizations loc, String roleKey) {
    switch (roleKey) {
      case 'planner':
        return _t(loc, 'label.rolePlanner');
      case 'enforcer':
        return _t(loc, 'label.roleEnforcer');
      case 'logistics':
        return _t(loc, 'label.roleLogistics');
      case 'tech':
        return _t(loc, 'label.roleTech');
      default:
        return _t(loc, 'label.roleNone');
    }
  }

  List<Map<String, dynamic>> _extractMissionContributions(
    Map<String, dynamic> run,
  ) {
    final raw = run['missionContributions'];
    if (raw is! List) return const [];
    final parsed = raw
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .toList();
    parsed.sort((a, b) {
      final aScore = (a['contributionScore'] as num?)?.toDouble() ?? 0;
      final bScore = (b['contributionScore'] as num?)?.toDouble() ?? 0;
      return bScore.compareTo(aScore);
    });
    return parsed;
  }

  String _formatContributionValue(num? value) {
    if (value == null) return '0';
    final v = value.toDouble();
    if ((v - v.roundToDouble()).abs() < 0.01) {
      return v.toStringAsFixed(0);
    }
    return v.toStringAsFixed(2);
  }

  List<Map<String, dynamic>> _extractMissionTradeRequirements(
    Map<String, dynamic> template,
  ) {
    final raw = template['tradeRequirements'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => item.cast<String, dynamic>())
        .where((row) {
          final goodType = (row['goodType'] ?? '').toString();
          final quantity = (row['quantity'] as num?)?.toInt() ?? 0;
          return goodType.isNotEmpty && quantity > 0;
        })
        .toList();
  }

  int _crewTradeHeldQuantity(String goodType) {
    final inventory = _crewStorage?['inventory'];
    if (inventory is! Map) return 0;
    final trade = inventory['trade'];
    if (trade is! List) return 0;
    for (final row in trade) {
      if (row is! Map) continue;
      if ((row['goodType'] ?? '').toString() == goodType) {
        return (row['quantity'] as num?)?.toInt() ?? 0;
      }
    }
    return 0;
  }

  void _openCrewStorageTab() {
    _tabController.animateTo(2);
  }

  void _openCrewHqTab() {
    _tabController.animateTo(1);
  }

  void _openBlackMarketTrade() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const BlackMarketScreen(initialTabIndex: 0),
      ),
    );
  }

  String _crewMissionFallbackImagePath(String missionKey) {
    switch (missionKey) {
      case 'safehouse_supply_run':
        return 'images/crimes/smuggling_crime.png';
      case 'street_intel_sweep':
        return 'images/crimes/hack_account_crime.png';
      case 'armory_smuggle_chain':
        return 'images/crimes/rob_armored_truck_crime.png';
      case 'port_hijack_window':
        return 'images/crimes/hijack_truck_crime.png';
      case 'casino_ledger_raid':
        return 'images/crimes/casino_heist_crime.png';
      case 'federal_convoy_break':
        return 'images/crimes/bank_robbery_crime.png';
      case 'night_deposit_grab':
        return 'images/crimes/atm_theft_crime.png';
      case 'skim_network_rollout':
        return 'images/crimes/identity_theft_crime.png';
      case 'armored_pivot_route':
        return 'images/crimes/rob_armored_truck_crime.png';
      case 'subsidiary_vault_window':
        return 'images/crimes/burglary_crime.png';
      case 'reserve_vault_breach':
        return 'images/crimes/diamond_heist_crime.png';
      case 'clearing_house_vault_run':
        return 'images/crimes/counterfeit_money_crime.png';
      case 'port_contraband_manifest':
        return 'images/crimes/smuggling_crime.png';
      case 'warehouse_luxury_offload':
        return 'images/crimes/counterfeit_money_crime.png';
      default:
        return 'images/casino/casino_background_landscape.png';
    }
  }

  Future<void> _openCrewMissionRoleAssignDialog(String missionKey) async {
    if (_myCrew == null) return;
    final members = _myCrew!.members;
    if (members.isEmpty) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_t(l10n, 'state.roleAssignNoMembers')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentPlayerId = authProvider.currentPlayer?.id ?? 0;
    final roleByPlayerId = <int, String>{};
    for (final member in members) {
      roleByPlayerId[member.playerId] = member.playerId == currentPlayerId
          ? 'planner'
          : 'none';
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedCount = roleByPlayerId.values
                .where((value) => value != 'none')
                .length;

            return AlertDialog(
              title: Text(_t(l10n, 'dialog.roleAssignTitle')),
              content: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 560,
                  maxHeight: MediaQuery.of(context).size.height * 0.72,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t(l10n, 'dialog.roleAssignSubtitle'),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _t(l10n, 'hint.roleBonus'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 14),
                      ...members.map((member) {
                        final username =
                            member.playerInfo?.username ??
                            '#${member.playerId}';
                        final currentRole =
                            roleByPlayerId[member.playerId] ?? 'none';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  username,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: currentRole,
                                items:
                                    const [
                                      'none',
                                      'planner',
                                      'enforcer',
                                      'logistics',
                                      'tech',
                                    ].map((role) {
                                      return DropdownMenuItem<String>(
                                        value: role,
                                        child: Text(
                                          _crewRoleLabel(l10n, role),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (value) {
                                  if (value == null) return;
                                  setDialogState(() {
                                    roleByPlayerId[member.playerId] = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                      if (selectedCount == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            _t(l10n, 'state.roleAssignPickOne'),
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(_t(l10n, 'action.cancel')),
                ),
                ElevatedButton(
                  onPressed: selectedCount == 0
                      ? null
                      : () => Navigator.of(context).pop(true),
                  child: Text(_t(l10n, 'action.configureAndStartMission')),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    final assignments = <Map<String, dynamic>>[];
    roleByPlayerId.forEach((playerId, roleKey) {
      if (roleKey == 'none') return;
      assignments.add({'playerId': playerId, 'roleKey': roleKey});
    });

    await _startCrewMissionWithAssignments(missionKey, assignments);
  }

  Future<void> _startCrewMissionWithAssignments(
    String missionKey,
    List<Map<String, dynamic>> assignments,
  ) async {
    if (_crewMissionActionLoading) return;
    setState(() => _crewMissionActionLoading = true);
    try {
      final response = await AuthService().apiClient
          .post('/crew-missions/start', {
            'missionKey': missionKey,
            if (assignments.isNotEmpty) 'assignments': assignments,
          });
      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionStarted')),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCrewMissionsOverview(silent: true);
      } else {
        final data = response.body.isNotEmpty
            ? _decodeJsonBody(response.body)
            : <String, dynamic>{};
        final event = data['event']?.toString();
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_crewMissionErrorMessage(l10n, event)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr20,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _crewMissionActionLoading = false);
      }
    }
  }

  Future<void> _resolveCrewMission(int runId) async {
    if (_crewMissionActionLoading) return;
    setState(() => _crewMissionActionLoading = true);
    try {
      final response = await AuthService().apiClient.post(
        '/crew-missions/runs/$runId/resolve',
        {},
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        _crewMissionSpeedupQuotes.remove(runId);
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionResolved')),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCrewMissionsOverview(silent: true);
      } else {
        final data = response.body.isNotEmpty
            ? _decodeJsonBody(response.body)
            : <String, dynamic>{};
        final event = data['event']?.toString();
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_crewMissionErrorMessage(l10n, event)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr21,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _crewMissionActionLoading = false);
      }
    }
  }

  Future<void> _claimCrewMissionRewards(int runId) async {
    if (_crewMissionActionLoading) return;
    setState(() => _crewMissionActionLoading = true);
    try {
      final response = await AuthService().apiClient.post(
        '/crew-missions/runs/$runId/claim',
        {},
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionRewardsClaimed')),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCrewMissionsOverview(silent: true);
        _loadData();
      } else {
        final data = response.body.isNotEmpty
            ? _decodeJsonBody(response.body)
            : <String, dynamic>{};
        final event = data['event']?.toString();
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_crewMissionErrorMessage(l10n, event)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr22,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _crewMissionActionLoading = false);
      }
    }
  }

  Future<Map<String, dynamic>?> _loadCrewMissionSpeedupQuote(
    int runId, {
    bool silent = true,
  }) async {
    if (_crewMissionSpeedupQuoteLoading.contains(runId)) {
      return _crewMissionSpeedupQuotes[runId];
    }

    _crewMissionSpeedupQuoteLoading.add(runId);
    try {
      final response = await AuthService().apiClient.get(
        '/crew-missions/runs/$runId/speedup-quote',
      );
      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        if (mounted) {
          setState(() {
            _crewMissionSpeedupQuotes[runId] = data;
          });
        } else {
          _crewMissionSpeedupQuotes[runId] = data;
        }
        return data;
      }

      if (!silent && mounted) {
        final data = response.body.isNotEmpty
            ? _decodeJsonBody(response.body)
            : <String, dynamic>{};
        final event = data['event']?.toString();
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_crewMissionErrorMessage(l10n, event)),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } catch (_) {
      if (!silent && mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionSpeedupQuoteFailed')),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } finally {
      _crewMissionSpeedupQuoteLoading.remove(runId);
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _confirmSpeedupCrewMissionCooldown(int runId) async {
    if (_crewMissionActionLoading) return;

    final quote = await _loadCrewMissionSpeedupQuote(runId, silent: false);
    if (!mounted || quote == null) return;

    final credits = (quote['credits'] as num?)?.toInt() ?? 0;
    final remainingMinutes = (quote['remainingMinutes'] as num?)?.toInt() ?? 0;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_t(l10n, 'dialog.speedupTitle')),
        content: Text(
          _tParam(l10n, 'dialog.speedupBody', {
            'credits': credits.toString(),
            'minutes': remainingMinutes.toString(),
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(_t(l10n, 'action.cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(_t(l10n, 'action.confirmSpeedupCooldown')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _speedupCrewMissionCooldown(runId);
    }
  }

  Future<void> _speedupCrewMissionCooldown(int runId) async {
    if (_crewMissionActionLoading) return;
    setState(() => _crewMissionActionLoading = true);
    try {
      final response = await AuthService().apiClient.post(
        '/crew-missions/runs/$runId/speedup',
        {},
      );
      if (!mounted) return;

      if (response.statusCode == 200) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_t(l10n, 'message.missionCooldownSpedUp')),
            backgroundColor: Colors.green,
          ),
        );
        await _loadCrewMissionsOverview(silent: true);
      } else {
        final data = response.body.isNotEmpty
            ? _decodeJsonBody(response.body)
            : <String, dynamic>{};
        final event = data['event']?.toString();
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_crewMissionErrorMessage(l10n, event)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr23,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _crewMissionActionLoading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
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

      final futures = <Future<void>>[
        _loadAllCrews(),
        _loadOneTimeProducts(),
        _loadCrewWeeklyGoal(),
      ];
      if (_myCrew != null) {
        futures.add(_loadCrewWarHub());
        futures.add(_loadCrewStats());
        futures.add(_loadCrewBuildings());
        futures.add(_loadCrewStorage());
        futures.add(_loadCrewMissionsOverview(silent: true));
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
      final path = _myCrew == null ? '/crews/recruiting' : '/crews';
      final response = await apiClient.get(path);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final crewsList = params['crews'] as List;
        final pending = params['pendingRequests'] as List? ?? const [];
        setState(() {
          _allCrews = crewsList
              .map((c) => Crew.fromJson(c as Map<String, dynamic>))
              .toList();
          _pendingJoinCrewIds
            ..clear()
            ..addAll(
              pending
                  .whereType<Map<String, dynamic>>()
                  .map((row) => (row['crewId'] as num?)?.toInt())
                  .whereType<int>(),
            );
        });
      }
    } catch (e) {
      print('Error loading crews: $e');
    }
  }

  Future<void> _loadCrewWeeklyGoal() async {
    try {
      final response = await AuthService().apiClient.get('/crews/weekly-goal');
      if (response.statusCode != 200) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _crewWeeklyGoal = data['data'] as Map<String, dynamic>?;
      });
    } catch (_) {}
  }

  Future<void> _claimCrewWeeklyGoal() async {
    try {
      final response = await AuthService().apiClient.post(
        '/crews/weekly-goal/claim',
        {},
      );
      if (!mounted) return;
      final locale = Localizations.localeOf(context).languageCode;
      if (response.statusCode == 200) {
        final cash = (_crewWeeklyGoal?['rewardCrewCash'] as num?)?.toInt() ?? 25000;
        final xp = (_crewWeeklyGoal?['rewardPersonalXp'] as num?)?.toInt() ?? 40;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl'
                  ? 'Crew weekdoel geclaimd: +${_money(cash)} crewbank en +$xp XP'
                  : 'Crew weekly goal claimed: +${_money(cash)} crew bank and +$xp XP',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
        await _loadCrewWeeklyGoal();
        await _loadMyCrew();
      }
    } catch (_) {}
  }

  Future<void> _cancelJoin(int crewId) async {
    try {
      final response = await AuthService().apiClient.post(
        '/crews/$crewId/join/cancel',
        {},
      );
      if (!mounted) return;
      final locale = Localizations.localeOf(context).languageCode;
      if (response.statusCode == 200) {
        setState(() => _pendingJoinCrewIds.remove(crewId));
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              locale == 'nl' ? 'Verzoek geannuleerd' : 'Request cancelled',
            ),
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _updateRecruiting({
    bool? recruitingOpen,
    bool? autoAccept,
  }) async {
    if (_myCrew == null) return;
    try {
      final response = await AuthService().apiClient.post(
        '/crews/${_myCrew!.id}/recruiting',
        {
          if (recruitingOpen != null) 'recruitingOpen': recruitingOpen,
          if (autoAccept != null) 'autoAccept': autoAccept,
        },
      );
      if (response.statusCode == 200) {
        await _loadMyCrew();
      }
    } catch (_) {}
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

  Future<void> _loadCrewWarHub() async {
    if (_myCrew == null) {
      if (mounted) {
        setState(() {
          _crewWarHub = null;
          _selectedWarTargetCrewId = null;
        });
      }
      return;
    }

    try {
      if (mounted) {
        setState(() => _crewWarLoading = true);
      }

      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/crew-wars/hub');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final hub =
            (params['hub'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{};
        final targets = (hub['availableTargets'] as List<dynamic>? ?? []);
        final suggestedTargetId = targets.isNotEmpty
            ? (targets.first as Map<String, dynamic>)['id'] as int?
            : null;

        if (mounted) {
          setState(() {
            _crewWarHub = hub;
            _selectedWarTargetCrewId =
                targets.any(
                  (target) =>
                      (target as Map<String, dynamic>)['id'] ==
                      _selectedWarTargetCrewId,
                )
                ? _selectedWarTargetCrewId
                : suggestedTargetId;
          });
        }
      }
    } catch (e) {
      print('Error loading crew war hub: $e');
    } finally {
      if (mounted) {
        setState(() => _crewWarLoading = false);
      }
    }
  }

  String _crewWarErrorMessage(
    AppLocalizations loc,
    String? event,
    Map<String, dynamic>? params,
  ) {
    switch (event) {
      case 'error.not_in_crew':
        return loc.crewUiTr24;
      case 'error.not_crew_leader':
        return loc.crewUiTr25;
      case 'error.target_crew_not_found':
        return loc.crewUiTr26;
      case 'error.crew_already_in_war':
        return loc.crewUiTr27;
      case 'error.not_enough_crew_members':
        return loc.crewUiTr28;
      case 'error.war_not_found':
        return loc.crewUiTr29;
      case 'error.war_not_active':
        return loc.crewUiTr30;
      case 'error.war_not_joinable':
        return loc.crewUiTr31;
      case 'error.war_target_required':
        return loc.crewUiTr32;
      case 'error.war_repeated_target_blocked':
        return loc.crewUiTr33;
      case 'error.vip_player_required':
        return loc.crewUiTr34;
      case 'error.vip_crew_required':
        return loc.crewUiTr35;
      case 'error.war_action_limit_reached':
        return loc.crewUiTr36;
      case 'error.war_action_cooldown':
        final remaining = params?['remainingMinutes'] ?? 0;
        return loc.crewUiTr37(remaining.toString());
      case 'error.invalid_war_territory':
        return loc.crewUiTr38;
      default:
        return loc.crewUiTr39;
    }
  }

  Future<int?> _promptWarTargetPlayer(
    AppLocalizations loc,
    String title,
    List<Map<String, dynamic>> opponents,
  ) async {
    if (opponents.isEmpty) return null;
    int? selectedPlayerId = (opponents.first['playerId'] as num?)?.toInt();
    return showDialog<int>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: Text(title),
          content: DropdownButtonFormField<int>(
            value: selectedPlayerId,
            decoration: InputDecoration(
              labelText: loc.crewUiTr40,
            ),
            items: opponents.map((opponent) {
              final player = (opponent['player'] as Map?)
                  ?.cast<String, dynamic>();
              final participant = (opponent['participant'] as Map?)
                  ?.cast<String, dynamic>();
              final role = (opponent['role'] ?? 'member').toString();
              final playerId = (opponent['playerId'] as num?)?.toInt() ?? 0;
              final username = (player?['username'] ?? '#$playerId').toString();
              final kills = (participant?['kills'] as num?)?.toInt() ?? 0;
              final deaths = (participant?['deaths'] as num?)?.toInt() ?? 0;
              return DropdownMenuItem<int>(
                value: playerId,
                child: Text(
                  '$username • ${_formatCrewWarRole(loc, role)} (#$playerId) • ${loc.crewUiTr41}: $kills • ${loc.crewUiTr42}: $deaths',
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;
              setLocalState(() => selectedPlayerId = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.crewUiTr43),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(selectedPlayerId),
              child: Text(loc.crewUiTr44),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCrewWarRole(AppLocalizations loc, String role) {
    switch (role) {
      case 'leader':
        return loc.crewUiTr45;
      case 'co_leader':
        return loc.crewUiTr46;
      default:
        return loc.crewUiTr47;
    }
  }

  String _formatWarTerritoryOptionLabel(
    AppLocalizations loc,
    Map<String, dynamic> territory,
  ) {
    final name =
        ((loc.localeName.startsWith('nl')
                ? territory['nameNl']
                : territory['nameEn']) ??
                territory['regionKey'] ??
                '-')
            .toString();
    final countryCode = (territory['countryCode'] as String?)?.toUpperCase();
    final ownerCrewName =
        territory['currentHolderCrewName'] as String? ??
        territory['ownerCrewName'] as String?;
    final suffixParts = <String>[];
    if (countryCode != null && countryCode.isNotEmpty) {
      suffixParts.add(countryCode);
    }
    if (ownerCrewName != null && ownerCrewName.isNotEmpty) {
      suffixParts.add(ownerCrewName);
    }
    if (suffixParts.isEmpty) return name;
    return '$name (${suffixParts.join(' • ')})';
  }

  String _formatWarTerritoryTagLabel(AppLocalizations loc, String tag) {
    switch (tag.toLowerCase()) {
      case 'capital':
        return loc.crewUiTr48;
      case 'harbor':
        return loc.crewUiTr49;
      case 'industry':
        return loc.crewUiTr50;
      case 'border':
        return loc.crewUiTr51;
      case 'logistics':
        return loc.crewUiTr52;
      default:
        return tag;
    }
  }

  String _formatWarTerritoryBonusSummary(
    AppLocalizations loc,
    Map<String, dynamic> territory,
  ) {
    final claimBonus = (territory['claimBonusPoints'] as num?)?.toInt() ?? 0;
    final tickPoints = (territory['tickPoints'] as num?)?.toInt() ?? 4;
    final strategicTags =
        (territory['strategicTags'] as List<dynamic>? ?? const [])
            .map((tag) => _formatWarTerritoryTagLabel(loc, tag.toString()))
            .where((tag) => tag.trim().isNotEmpty)
            .toList();
    final bonusParts = <String>[
      '${loc.crewUiTr53} +$claimBonus',
      '${loc.crewUiTr54} $tickPoints',
    ];
    if (strategicTags.isNotEmpty) {
      bonusParts.add(strategicTags.join('/'));
    }
    return bonusParts.join(' • ');
  }

  Future<String?> _promptWarTerritory(
    AppLocalizations loc,
    List<Map<String, dynamic>> territories,
  ) async {
    if (territories.isEmpty) return null;
    String selected = (territories.first['regionKey'] ?? '').toString();
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          title: Text(loc.crewUiTr55),
          content: DropdownButtonFormField<String>(
            value: selected,
            items: territories
                .map(
                  (territory) => DropdownMenuItem<String>(
                    value: (territory['regionKey'] ?? '').toString(),
                    child: Text(
                      '${_formatWarTerritoryOptionLabel(loc, territory)} • ${_formatWarTerritoryBonusSummary(loc, territory)}',
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setLocalState(() => selected = value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.crewUiTr43),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(selected),
              child: Text(loc.crewUiTr53),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _declareCrewWar() async {
    if (_selectedWarTargetCrewId == null) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.crewUiTr56,
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post('/crew-wars/declare', {
        'targetCrewId': _selectedWarTargetCrewId,
        'warType': _selectedWarType,
      });

      if (response.statusCode == 201) {
        await _loadData();
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr57,
            ),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }

      if (!mounted) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final event = data['event'] as String?;
      final params = (data['params'] as Map?)?.cast<String, dynamic>();
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_crewWarErrorMessage(l10n, event, params)),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.crewUiTr58,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _joinCrewWar(int warId) async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post('/crew-wars/$warId/join', {});
      if (response.statusCode == 200) {
        await _loadData();
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr59,
            ),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }

      if (!mounted) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _crewWarErrorMessage(
              l10n,
              data['event'] as String?,
              (data['params'] as Map?)?.cast<String, dynamic>(),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.crewUiTr60,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _performCrewWarAction(
    int warId,
    String actionType, {
    int? targetPlayerId,
    String? territoryKey,
  }) async {
    try {
      final apiClient = AuthService().apiClient;
      final payload = <String, dynamic>{'actionType': actionType};
      if (targetPlayerId != null) {
        payload['targetPlayerId'] = targetPlayerId;
      }
      if (territoryKey != null) {
        payload['territoryKey'] = territoryKey;
      }
      final response = await apiClient.post(
        '/crew-wars/$warId/actions',
        payload,
      );

      if (response.statusCode == 200) {
        await _loadData();
        if (!mounted) return;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              l10n.crewUiTr61,
            ),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }

      if (!mounted) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            _crewWarErrorMessage(
              l10n,
              data['event'] as String?,
              (data['params'] as Map?)?.cast<String, dynamic>(),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            l10n.crewUiTr39,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatCrewWarType(AppLocalizations loc, String? warType) {
    switch (warType) {
      case 'kill_war':
        return loc.crewUiTr62;
      case 'economy_war':
        return loc.crewUiTr63;
      case 'territory_war':
        return loc.crewUiTr64;
      case 'total_war':
        return loc.crewUiTr65;
      default:
        return warType ?? '-';
    }
  }

  String _formatCrewWarStatus(AppLocalizations loc, String? status) {
    switch (status) {
      case 'preparing':
        return loc.crewUiTr66;
      case 'active':
        return loc.crewUiTr67;
      case 'lockdown':
        return loc.crewUiTr68;
      case 'resolved':
        return loc.crewUiTr69;
      case 'archived':
        return loc.crewUiTr70;
      case 'cancelled':
        return loc.crewUiTr71;
      default:
        return status ?? '-';
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
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final instant = data['event'] == 'crew.joined';
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'nl'
                    ? (instant ? 'Je zit nu in de crew!' : 'Join request verstuurd!')
                    : (instant ? 'You joined the crew!' : 'Join request sent!'),
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
          } else if (event == 'error.recruiting_closed') {
            message = locale == 'nl'
                ? 'Deze crew neemt geen leden aan'
                : 'This crew is not recruiting';
          } else if (event == 'error.crew_full') {
            message = locale == 'nl' ? 'Deze crew is vol' : 'This crew is full';
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

  Widget _buildVipStatusCard(AppLocalizations loc) {
    final crewVip = _myCrew!.isVip;
    final isNl = loc.localeName.startsWith('nl');
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
                            loc.crewUiTr72,
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
                      loc.crewUiTr73,
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
                      loc.crewUiTr74,
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
              loc.crewUiTr75,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _oneTimeProducts.map((product) {
                final key = (product['key'] ?? '').toString();
                final title = isNl
                    ? (product['titleNl'] ?? key).toString()
                    : (product['titleEn'] ?? key).toString();
                final imageUrl = (product['imageUrl'] ?? '').toString();
                final price = (product['priceEur'] ?? '0.00').toString();

                String rewardLabel = '';
                final rewardSummary = isNl
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
          await _openCheckoutUrl(checkoutUrl);
        }
      } else {
        final errData = response.statusCode != 200 && response.body.isNotEmpty
            ? jsonDecode(response.body) as Map<String, dynamic>?
            : null;
        final code = errData?['event'] as String? ?? 'unknown';
        final message = code == 'error.not_crew_leader'
            ? l10n.crewUiTr76
            : code == 'error.invalid_product_key'
            ? l10n.crewUiTr77
            : l10n.crewUiTr10;
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
              l10n.crewUiTr78,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _leaveCrew() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.crewUiTr79),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.crewUiTr80,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.crewUiTr81,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.crewUiTr43),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.crewUiTr82),
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
                content: Text(l10n.crewUiTr83),
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
    final cashStorageBuilding = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == 'cash_storage',
      orElse: () => <String, dynamic>{},
    );
    final cashBootstrapLimit =
        cashStorageBuilding['nextUpgradeCost'] as int? ?? 0;
    final canUseBootstrapDeposit =
        deposit && cashStorageCapacity <= 0 && cashBootstrapLimit > 0;

    if (cashStorageCapacity <= 0 && !canUseBootstrapDeposit) {
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
        title: Text(l10n.crewUiTr79),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              deposit
                  ? l10n.crewUiTr84
                  : l10n.crewUiTr85,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.crewUiTr86,
                prefixText: '€',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.crewUiTr43),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text(l10n.crewUiTr44),
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
        return;
      }

      if (mounted) {
        String message = l10n.crewUiTr10;
        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final event = data['event'] as String?;
          switch (event) {
            case 'error.invalid_amount':
              message = l10n.crewUiTr87;
              break;
            case 'error.insufficient_funds':
              message = l10n.crewUiTr88;
              break;
            case 'error.cash_storage_not_owned':
              message = l10n.crewUiTr89;
              break;
            case 'error.cash_bootstrap_limit_reached':
              message = _buildingActionErrorMessage(l10n, event);
              break;
            case 'error.cash_storage_full':
              message = l10n.crewUiTr90;
              break;
            case 'error.insufficient_crew_funds':
              message = l10n.crewUiTr6;
              break;
          }
        } catch (_) {
          // Keep fallback message.
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

  Future<void> _deleteCrew() async {
    if (_myCrew == null) return;
    final locale = Localizations.localeOf(context).languageCode;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.crewUiTr79),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.crewUiTr91,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.crewUiTr92,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.crewUiTr43),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.crewUiTr93),
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
    final localizedLabel = _getBuildingLabel(type, l10n);
    final purchaseLevel = isHq ? 0 : 1;
    final building = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == type,
      orElse: () => <String, dynamic>{},
    );
    final nextCost = building['nextUpgradeCost'] as int?;
    String selectedStyle = 'camping';
    final hqCurrentStyle = building['style'] as String?;
    final hqCurrentLevel = building['level'] as int?;
    final hqCurrentGlobalLevel = isHq && hqCurrentLevel != null
        ? _getHqGlobalLevel(hqCurrentStyle, hqCurrentLevel)
        : null;
    final targetDisplayLevel = isHq
        ? ((hqCurrentGlobalLevel ?? -1) + 1).clamp(0, 19)
        : purchaseLevel;

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
          title: Text(l10n.crewUiTr79),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizedLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (isHq)
                Text(
                  '${l10n.crewUiTr94}: L$targetDisplayLevel',
                )
              else
                Text('${_t(l10n, 'label.level')}: $purchaseLevel'),
              if (nextCost != null) ...[
                const SizedBox(height: 8),
                Text('${l10n.crewUiTr95}: ${_money(nextCost)}'),
              ],
              if (isHq)
                DropdownButtonFormField<String>(
                  initialValue: selectedStyle,
                  items: [selectedStyle]
                      .map(
                        (style) => DropdownMenuItem(
                          value: style,
                          child: Text(_localizedHqStyleLabel(l10n, style)),
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
              child: Text(
                isHq && hqCurrentLevel != null
                    ? _t(l10n, 'action.upgrade')
                    : (locale == 'nl' ? 'Kopen' : 'Purchase'),
              ),
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
        String message = l10n.crewUiTr10;
        Color color = Colors.red;

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final event = data['event'] as String?;
          message = _buildingActionErrorMessage(l10n, event);
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
    final localizedLabel = _getBuildingLabel(type, l10n);
    final currentBuilding = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == type,
      orElse: () => {'level': 0},
    );
    final currentLevel = currentBuilding['level'] as int? ?? 0;
    final nextLevel = currentLevel + 1;
    final nextCost = currentBuilding['nextUpgradeCost'] as int?;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.crewUiTr79),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizedLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${_t(l10n, 'label.level')}: $currentLevel → $nextLevel'),
            if (nextCost != null) ...[
              const SizedBox(height: 8),
              Text('${l10n.crewUiTr95}: ${_money(nextCost)}'),
            ],
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
        String message = l10n.crewUiTr10;
        Color color = Colors.red;

        try {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final event = data['event'] as String?;
          if (event == 'error.building_max_level') {
            message = l10n.crewUiTr96;
            color = Colors.orange;
          } else if (event == 'error.building_not_owned') {
            message = l10n.crewUiTr97;
          } else if (event == 'error.insufficient_crew_funds') {
            message = l10n.crewUiTr6;
          } else if (event == 'error.hq_level_too_low' ||
              event == 'error.hq_vip_required') {
            message = _buildingActionErrorMessage(l10n, event);
            color = Colors.orange;
          } else if (event == 'error.hq_side_buildings_incomplete') {
            message = _buildingActionErrorMessage(l10n, event);
            color = Colors.orange;
          } else if (event == 'error.building_vip_required') {
            message = _buildingActionErrorMessage(l10n, event);
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
      final filtered = vehicles.where((v) {
        final currentType = (v['vehicleType'] ?? '').toString();
        if (vehicleType == 'car') {
          return currentType == 'car' || currentType == 'motorcycle';
        }
        return currentType == vehicleType;
      }).toList();

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
                  ? l10n.crewUiTr98
                  : l10n.crewUiTr99,
            ),
            content: DropdownButtonFormField<int>(
              initialValue: selectedId,
              items: filtered
                  .map(
                    (vehicle) => DropdownMenuItem<int>(
                      value: vehicle['id'] as int,
                      child: Text(
                        '${vehicle['definition']?['name'] ?? vehicle['vehicleId']} • ${((vehicle['vehicleType'] ?? '').toString() == 'motorcycle') ? l10n.crewUiTr100 : ((vehicle['vehicleType'] ?? '').toString() == 'boat' ? l10n.crewUiTr101 : l10n.crewUiTr102)} (#${vehicle['id']})',
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
                labelText: l10n.crewUiTr103,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.crewUiTr43),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(l10n.crewUiTr104),
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
            title: Text(l10n.crewUiTr105),
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
                    labelText: l10n.crewUiTr106,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.crewUiTr107,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.crewUiTr43),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(l10n.crewUiTr104),
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
            title: Text(l10n.crewUiTr108),
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
                    labelText: l10n.crewUiTr109,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.crewUiTr107,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.crewUiTr43),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(l10n.crewUiTr104),
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

  Future<void> _depositTradeGoods() async {
    await _depositDrugs(trade: true);
  }

  Future<void> _depositDrugs({bool trade = false}) async {
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
            title: Text(l10n.crewUiTr110),
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
                    labelText: l10n.crewUiTr111,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.crewUiTr107,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.crewUiTr43),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: Text(l10n.crewUiTr104),
              ),
            ],
          ),
        ),
      );

      if (confirmed != true || selectedGoodType == null) return;

      final quantity = int.tryParse(qtyController.text) ?? 0;
      final depositResponse = await apiClient.post(
        trade
            ? '/crews/${_myCrew!.id}/storage/trade/deposit'
            : '/crews/${_myCrew!.id}/storage/drugs/deposit',
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

    final normalizedType = type.replaceAll('_storage', '');
    final buildingStyle = _getCrewBuildingStyleForLevel(level);
    return 'assets/images/crew_buildings/$normalizedType/$buildingStyle/lvl_$level.png';
  }

  /// Fallback when [trade] tier art is missing on the image mount.
  String? _getCrewBuildingImageFallbackPath(String? type, int? level) {
    if (type != 'trade_storage' || level == null) return null;
    final buildingStyle = _getCrewBuildingStyleForLevel(level);
    return 'assets/images/crew_buildings/drug/$buildingStyle/lvl_$level.png';
  }

  Widget _buildCrewBuildingCardImage({
    required String? type,
    required String imagePath,
    required int? level,
  }) {
    Widget placeholder() {
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
    }

    final fallback = _getCrewBuildingImageFallbackPath(type, level);
    return WebAssetHelper.image(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        if (fallback != null) {
          return WebAssetHelper.image(
            fallback,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => placeholder(),
          );
        }
        return placeholder();
      },
    );
  }

  String _getCrewBuildingStyleForLevel(int level) {
    if (level <= 2) return 'camping';
    if (level <= 4) return 'rural';
    if (level <= 7) return 'city';
    if (level <= 10) return 'villa';
    return 'vip';
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
      case 'trade_storage':
        return Icons.inventory;
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
    final path = _getCrewHqImagePath(style, level);
    if (path == null) {
      return const CircleAvatar(child: Icon(Icons.group));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: WebAssetHelper.image(
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_t(l10n, 'app.crews')),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: _t(l10n, 'tab.myCrew')),
            Tab(text: _t(l10n, 'tab.crewHq')),
            Tab(text: _t(l10n, 'tab.storageHub')),
            Tab(text: _t(l10n, 'tab.members')),
            Tab(text: _t(l10n, 'tab.warRoom')),
            Tab(text: _t(l10n, 'tab.crewMissions')),
            Tab(text: _t(l10n, 'tab.allCrews')),
            Tab(icon: const Icon(Icons.chat), text: _t(l10n, 'tab.chat')),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyCrewTab(),
                _buildHqManagementTab(),
                _buildStorageManagementTab(),
                _buildMembersTab(),
                _buildCrewWarTab(),
                _buildCrewMissionsTab(),
                _buildAllCrewsTab(),
                _buildChatTab(),
              ],
            ),
      floatingActionButton: _myCrew == null
          ? FloatingActionButton.extended(
              onPressed: _createCrew,
              icon: const Icon(Icons.add),
              label: Text(_t(l10n, 'action.createCrewShort')),
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
              _t(l10n, 'state.notInCrewYet'),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createCrew,
              icon: const Icon(Icons.add),
              label: Text(
                _t(l10n, 'action.createCrew'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _tabController.animateTo(6),
              child: Text(
                Localizations.localeOf(context).languageCode == 'nl'
                    ? 'Bekijk open crews'
                    : 'Browse open crews',
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
    final tradeStorageOwned = (storageCapacities?['trade'] as int? ?? 0) > 0;
    final cashStorageOwned = (storageCapacities?['cash'] as int? ?? 0) > 0;
    final cashStorageBuilding = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == 'cash_storage',
      orElse: () => <String, dynamic>{},
    );
    final cashBootstrapLimit =
        cashStorageBuilding['nextUpgradeCost'] as int? ?? 0;
    final canBootstrapDeposit =
        !cashStorageOwned &&
        cashBootstrapLimit > 0 &&
        _myCrew!.bankBalance < cashBootstrapLimit;

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
                if (_crewWeeklyGoal?['inCrew'] == true)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.flag),
                      title: Text(
                        locale == 'nl'
                            ? (_crewWeeklyGoal!['titleNl'] as String? ??
                                'Crew weekdoel')
                            : (_crewWeeklyGoal!['titleEn'] as String? ??
                                'Crew weekly goal'),
                      ),
                      subtitle: Text(
                        '${_crewWeeklyGoal!['progress'] ?? 0}/${_crewWeeklyGoal!['target'] ?? 1}'
                        ' · ${locale == 'nl' ? 'Beloning' : 'Reward'}: +${_money((_crewWeeklyGoal!['rewardCrewCash'] as num?)?.toInt() ?? 25000)} '
                        '${locale == 'nl' ? 'crewbank' : 'crew bank'} +${(_crewWeeklyGoal!['rewardPersonalXp'] as num?)?.toInt() ?? 40} XP'
                        '${_crewWeeklyGoal!['claimed'] == true ? (locale == 'nl' ? ' · geclaimd' : ' · claimed') : ''}',
                      ),
                      trailing: _crewWeeklyGoal!['claimable'] == true
                          ? TextButton(
                              onPressed: _claimCrewWeeklyGoal,
                              child: Text(locale == 'nl' ? 'Claim' : 'Claim'),
                            )
                          : null,
                    ),
                  ),
                if (_crewWeeklyGoal?['inCrew'] == true) const SizedBox(height: 16),
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
                            title: Text(_t(l10n, 'label.crewHq')),
                            subtitle: Text(
                              _myCrew!.hqStyle != null &&
                                      _myCrew!.hqLevel != null
                                  ? '${(_myCrew!.hqStyle ?? 'camping').toUpperCase()}  •  ${_t(l10n, 'label.level')} ${_myCrew!.hqLevel}'
                                  : _t(l10n, 'status.notOwned'),
                            ),
                            trailing: TextButton(
                              onPressed: () => _tabController.animateTo(1),
                              child: Text(_t(l10n, 'action.goToCrewHq')),
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
                              _t(l10n, 'label.crewBank'),
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
                                    ? 'Opslagcapaciteit: ${_money(_crewStorage?['capacities']?['cash'] ?? 0)}'
                                    : 'Storage capacity: ${_money(_crewStorage?['capacities']?['cash'] ?? 0)}')
                              : canBootstrapDeposit
                              ? (locale == 'nl'
                                    ? 'Starterstorting voor cash opslag: ${_money(_myCrew!.bankBalance)} / ${_money(cashBootstrapLimit)}'
                                    : 'Starter deposit for cash storage: ${_money(_myCrew!.bankBalance)} / ${_money(cashBootstrapLimit)}')
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
                                onPressed:
                                    (cashStorageOwned || canBootstrapDeposit)
                                    ? () => _handleBankAction(deposit: true)
                                    : null,
                                icon: const Icon(Icons.savings),
                                label: Text(_t(l10n, 'label.deposit')),
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
                                  label: Text(_t(l10n, 'label.withdraw')),
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
                              _t(l10n, 'label.myTrustScore'),
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
                              _t(l10n, 'action.deleteCrew'),
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
                                _t(l10n, 'label.crewStats'),
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
                        const SizedBox(height: 16),
                        CrewHeistsPanel(
                          crewId: _myCrew!.id,
                          isLeader: isLeader,
                          memberCount: _myCrew!.memberCount,
                        ),
                        if (!isLeader) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _leaveCrew,
                              icon: const Icon(Icons.exit_to_app),
                              label: Text(_t(l10n, 'action.leaveCrew')),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                        if (isLeader) ...[
                          const SizedBox(height: 16),
                          _buildVipStatusCard(l10n),
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
                    title: Text(_t(l10n, 'section.buildings')),
                    subtitle: Text(_t(l10n, 'hint.buildingsTabs')),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => _tabController.animateTo(1),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(_t(l10n, 'section.storageHub')),
                    subtitle: Text(_t(l10n, 'hint.storageTab')),
                    trailing: TextButton(
                      onPressed: () => _tabController.animateTo(2),
                      child: Text(_t(l10n, 'action.goToStorage')),
                    ),
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
                          _t(l10n, 'section.crewStorage'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (_crewStorage == null)
                          Text(
                            _t(l10n, 'state.noStorageData'),
                            style: const TextStyle(color: Colors.grey),
                          )
                        else ...[
                          Text(
                            locale == 'nl'
                                ? 'Auto'
                                      's & motoren: ${_crewStorage!['totals']['cars']} / ${_crewStorage!['capacities']['cars']}'
                                : 'Cars & motorcycles: ${_crewStorage!['totals']['cars']} / ${_crewStorage!['capacities']['cars']}',
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
                                ? 'Geldopslag: ${_money(_crewStorage!['totals']['cash'])} / ${_money(cashStorageOwned ? _crewStorage!['capacities']['cash'] : cashBootstrapLimit)}'
                                : 'Cash storage: ${_money(_crewStorage!['totals']['cash'])} / ${_money(cashStorageOwned ? _crewStorage!['capacities']['cash'] : cashBootstrapLimit)}',
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
                                child: Text(_t(l10n, 'action.addCar')),
                              ),
                              OutlinedButton(
                                onPressed: boatStorageOwned
                                    ? () => _depositVehicle(vehicleType: 'boat')
                                    : null,
                                child: Text(_t(l10n, 'action.addBoat')),
                              ),
                              OutlinedButton(
                                onPressed: weaponStorageOwned
                                    ? _depositWeapon
                                    : null,
                                child: Text(_t(l10n, 'action.addWeapon')),
                              ),
                              OutlinedButton(
                                onPressed: ammoStorageOwned
                                    ? _depositAmmo
                                    : null,
                                child: Text(_t(l10n, 'action.addAmmo')),
                              ),
                              OutlinedButton(
                                onPressed: drugStorageOwned
                                    ? _depositDrugs
                                    : null,
                                child: Text(_t(l10n, 'action.addDrugs')),
                              ),
                              OutlinedButton(
                                onPressed: tradeStorageOwned
                                    ? _depositTradeGoods
                                    : null,
                                child: Text(
                                  locale == 'nl' ? 'Handelswaren' : 'Trade goods',
                                ),
                              ),
                            ],
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Drugs: ${_crewStorage!['totals']['drugs']} / ${_crewStorage!['capacities']['drugs']}'
                                : 'Drugs: ${_crewStorage!['totals']['drugs']} / ${_crewStorage!['capacities']['drugs']}',
                          ),
                          Text(
                            locale == 'nl'
                                ? 'Handelswaren: ${_crewStorage!['totals']['trade'] ?? 0} / ${_crewStorage!['capacities']['trade'] ?? 0}'
                                : 'Trade goods: ${_crewStorage!['totals']['trade'] ?? 0} / ${_crewStorage!['capacities']['trade'] ?? 0}',
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
                    title: Text(_t(l10n, 'section.membersOverview')),
                    subtitle: Text(_t(l10n, 'hint.membersTab')),
                    trailing: TextButton(
                      onPressed: () => _tabController.animateTo(3),
                      child: Text(_t(l10n, 'action.goToMembers')),
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

  Widget _buildHqManagementTab() {
    if (_myCrew == null) {
      return Center(
        child: Text(
          _t(l10n, 'state.joinCrewFirst'),
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
    const storageTypes = [
      'car_storage',
      'boat_storage',
      'weapon_storage',
      'ammo_storage',
      'drug_storage',
      'trade_storage',
      'cash_storage',
    ];

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _t(l10n, 'section.upgradeHub'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _t(l10n, 'hint.upgradeHub'),
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildSingleBuildingCard('hq', isLeader),
              ),
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final fullWidth = constraints.maxWidth;
                final columns = fullWidth >= 980
                    ? 3
                    : fullWidth >= 640
                    ? 2
                    : 1;
                final totalSpacing = 16.0 * (columns - 1);
                final cardWidth = (fullWidth - totalSpacing) / columns;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: storageTypes
                      .map(
                        (type) => SizedBox(
                          width: cardWidth,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: _buildSingleBuildingCard(
                                type,
                                isLeader,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageManagementTab() {
    final locale = Localizations.localeOf(context).languageCode;
    if (_myCrew == null) {
      return Center(
        child: Text(
          _t(l10n, 'state.joinCrewFirst'),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final storage = _crewStorage;
    final capacities = storage?['capacities'] as Map<String, dynamic>?;
    final totals = storage?['totals'] as Map<String, dynamic>?;
    final cashStorageOwned = (capacities?['cash'] as int? ?? 0) > 0;
    final cashStorageBuilding = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == 'cash_storage',
      orElse: () => <String, dynamic>{},
    );
    final cashBootstrapLimit =
        cashStorageBuilding['nextUpgradeCost'] as int? ?? 0;
    final cashLimit = cashStorageOwned
        ? (capacities?['cash'] as int? ?? 0)
        : cashBootstrapLimit;

    Widget buildStorageTile({
      required IconData icon,
      required String titleNl,
      required String titleEn,
      required String value,
      VoidCallback? onPressed,
      String? actionNl,
      String? actionEn,
    }) {
      return Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(locale == 'nl' ? titleNl : titleEn),
          subtitle: Text(value),
          trailing: onPressed != null
              ? OutlinedButton(
                  onPressed: onPressed,
                  child: Text(locale == 'nl' ? actionNl! : actionEn!),
                )
              : null,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _t(l10n, 'section.storageHub'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _t(l10n, 'hint.storageTab'),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t(l10n, 'section.crewStorage'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    locale == 'nl'
                        ? 'Auto'
                              's & motoren: ${totals?['cars'] ?? 0} / ${capacities?['cars'] ?? 0}'
                        : 'Cars & motorcycles: ${totals?['cars'] ?? 0} / ${capacities?['cars'] ?? 0}',
                  ),
                  Text(
                    locale == 'nl'
                        ? 'Boten: ${totals?['boats'] ?? 0} / ${capacities?['boats'] ?? 0}'
                        : 'Boats: ${totals?['boats'] ?? 0} / ${capacities?['boats'] ?? 0}',
                  ),
                  Text(
                    locale == 'nl'
                        ? 'Wapens: ${totals?['weapons'] ?? 0} / ${capacities?['weapons'] ?? 0}'
                        : 'Weapons: ${totals?['weapons'] ?? 0} / ${capacities?['weapons'] ?? 0}',
                  ),
                  Text(
                    locale == 'nl'
                        ? 'Munitie: ${totals?['ammo'] ?? 0} / ${capacities?['ammo'] ?? 0}'
                        : 'Ammo: ${totals?['ammo'] ?? 0} / ${capacities?['ammo'] ?? 0}',
                  ),
                  Text(
                    locale == 'nl'
                        ? 'Drugs: ${totals?['drugs'] ?? 0} / ${capacities?['drugs'] ?? 0}'
                        : 'Drugs: ${totals?['drugs'] ?? 0} / ${capacities?['drugs'] ?? 0}',
                  ),
                  Text(
                    locale == 'nl'
                        ? 'Cash: ${_money(totals?['cash'] ?? 0)} / ${_money(cashLimit)}'
                        : 'Cash: ${_money(totals?['cash'] ?? 0)} / ${_money(cashLimit)}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          buildStorageTile(
            icon: Icons.directions_car,
            titleNl: 'Auto/motor opslag',
            titleEn: 'Car/Motorcycle Storage',
            value: '${totals?['cars'] ?? 0} / ${capacities?['cars'] ?? 0}',
            onPressed: (capacities?['cars'] as int? ?? 0) > 0
                ? () => _depositVehicle(vehicleType: 'car')
                : null,
            actionNl: 'Toevoegen',
            actionEn: 'Add',
          ),
          buildStorageTile(
            icon: Icons.directions_boat,
            titleNl: 'Haven',
            titleEn: 'Boat Storage',
            value: '${totals?['boats'] ?? 0} / ${capacities?['boats'] ?? 0}',
            onPressed: (capacities?['boats'] as int? ?? 0) > 0
                ? () => _depositVehicle(vehicleType: 'boat')
                : null,
            actionNl: 'Toevoegen',
            actionEn: 'Add',
          ),
          buildStorageTile(
            icon: Icons.gavel,
            titleNl: 'Wapen opslag',
            titleEn: 'Weapon Storage',
            value:
                '${totals?['weapons'] ?? 0} / ${capacities?['weapons'] ?? 0}',
            onPressed: (capacities?['weapons'] as int? ?? 0) > 0
                ? _depositWeapon
                : null,
            actionNl: 'Toevoegen',
            actionEn: 'Add',
          ),
          buildStorageTile(
            icon: Icons.inventory_2,
            titleNl: 'Munitie opslag',
            titleEn: 'Ammo Storage',
            value: '${totals?['ammo'] ?? 0} / ${capacities?['ammo'] ?? 0}',
            onPressed: (capacities?['ammo'] as int? ?? 0) > 0
                ? _depositAmmo
                : null,
            actionNl: 'Toevoegen',
            actionEn: 'Add',
          ),
          buildStorageTile(
            icon: Icons.medication,
            titleNl: 'Drugsopslag',
            titleEn: 'Drug Storage',
            value: '${totals?['drugs'] ?? 0} / ${capacities?['drugs'] ?? 0}',
            onPressed: (capacities?['drugs'] as int? ?? 0) > 0
                ? _depositDrugs
                : null,
            actionNl: 'Toevoegen',
            actionEn: 'Add',
          ),
          buildStorageTile(
            icon: Icons.inventory,
            titleNl: 'Handelswarenopslag',
            titleEn: 'Trade Storage',
            value: '${totals?['trade'] ?? 0} / ${capacities?['trade'] ?? 0}',
            onPressed: (capacities?['trade'] as int? ?? 0) > 0
                ? _depositTradeGoods
                : null,
            actionNl: 'Toevoegen',
            actionEn: 'Add',
          ),
          buildStorageTile(
            icon: Icons.account_balance_wallet,
            titleNl: 'Cash opslag',
            titleEn: 'Cash Storage',
            value: '${_money(totals?['cash'] ?? 0)} / ${_money(cashLimit)}',
            onPressed: () => _handleBankAction(deposit: true),
            actionNl: 'Storten',
            actionEn: 'Deposit',
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.upgrade),
              label: Text(_t(l10n, 'section.upgradeHub')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    final locale = Localizations.localeOf(context).languageCode;
    if (_myCrew == null) {
      return Center(
        child: Text(
          _t(l10n, 'state.joinCrewFirst'),
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
              _t(l10n, 'tab.members'),
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
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        locale == 'nl' ? 'Werving open' : 'Recruiting open',
                      ),
                      subtitle: Text(
                        locale == 'nl'
                            ? 'Spelers kunnen jouw crew vinden in de open lijst'
                            : 'Players can find your crew in the open list',
                      ),
                      value: _myCrew!.recruitingOpen,
                      onChanged: (value) =>
                          _updateRecruiting(recruitingOpen: value),
                    ),
                    SwitchListTile(
                      title: Text(
                        locale == 'nl' ? 'Direct toelaten' : 'Auto-accept',
                      ),
                      subtitle: Text(
                        locale == 'nl'
                            ? 'Open crews met deze optie joinen in één klik'
                            : 'Open crews with this option join in one click',
                      ),
                      value: _myCrew!.autoAccept,
                      onChanged: _myCrew!.recruitingOpen
                          ? (value) => _updateRecruiting(autoAccept: value)
                          : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _t(l10n, 'state.joinRequests'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (_joinRequests.isEmpty)
                Text(
                  _t(l10n, 'state.noJoinRequests'),
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

  Widget _buildCrewWarTab() {
    if (_myCrew == null) {
      return Center(
        child: Text(
          l10n.crewUiTr112,
          style: const TextStyle(color: Colors.grey, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    final hub = _crewWarHub ?? <String, dynamic>{};
    final currentWar = (hub['currentWar'] as Map?)?.cast<String, dynamic>();
    final availableTargets = (hub['availableTargets'] as List<dynamic>? ?? [])
        .map((target) => (target as Map).cast<String, dynamic>())
        .toList();
    final seasonLeaderboard = (hub['seasonLeaderboard'] as List<dynamic>? ?? [])
        .map((entry) => (entry as Map).cast<String, dynamic>())
        .toList();
    final recentWars = (hub['recentWars'] as List<dynamic>? ?? [])
        .map((war) => (war as Map).cast<String, dynamic>())
        .toList();
    final standings = (currentWar?['standings'] as List<dynamic>? ?? [])
        .map((entry) => (entry as Map).cast<String, dynamic>())
        .toList();
    final recentActions = (currentWar?['recentActions'] as List<dynamic>? ?? [])
        .map((entry) => (entry as Map).cast<String, dynamic>())
        .toList();
    final myParticipant = (currentWar?['myParticipant'] as Map?)
        ?.cast<String, dynamic>();
    final status = currentWar?['status'] as String?;
    final canAct =
        currentWar != null &&
        myParticipant != null &&
        (status == 'active' || status == 'lockdown');
    final metadata = currentWar != null
        ? ((currentWar['metadata'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{})
        : <String, dynamic>{};
    final opponentMembers =
        (currentWar?['opponentMembers'] as List<dynamic>? ?? [])
            .map((entry) => (entry as Map).cast<String, dynamic>())
            .toList();
    final territoryTargets =
        (metadata['territoryTargets'] as List<dynamic>? ?? [])
            .whereType<Map>()
            .map((entry) => entry.cast<String, dynamic>())
            .toList();
    final legacyTerritories =
        ((metadata['territories'] as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{})
            .keys
            .map(
              (regionKey) => <String, dynamic>{
                'regionKey': regionKey,
                'nameNl': regionKey,
                'nameEn': regionKey,
              },
            )
            .toList();
    final territories = territoryTargets.isNotEmpty
        ? territoryTargets
        : legacyTerritories;

    Future<void> handleAction(String actionType) async {
      if (currentWar == null) return;
      int? targetPlayerId;
      String? territoryKey;

      if ([
        'attack_kill',
        'attack_mug',
        'attack_sabotage',
        'raid',
      ].contains(actionType)) {
        if (opponentMembers.isEmpty) {
          if (!mounted) return;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(
                l10n.crewUiTr113,
              ),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        targetPlayerId = await _promptWarTargetPlayer(
          l10n,
          l10n.crewUiTr114,
          opponentMembers,
        );
        if (targetPlayerId == null || targetPlayerId <= 0) return;
      }

      if (actionType == 'territory_claim') {
        territoryKey = await _promptWarTerritory(l10n, territories);
        if (territoryKey == null || territoryKey.isEmpty) return;
      }

      await _performCrewWarAction(
        currentWar['id'] as int,
        actionType,
        targetPlayerId: targetPlayerId,
        territoryKey: territoryKey,
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCrewWarHub,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _t(l10n, 'tab.warRoom'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _crewWarLoading ? null : () => _loadCrewWarHub(),
                  icon: _crewWarLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.crewUiTr115,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.crewUiTr116}: ${hub['season'] is Map ? ((hub['season'] as Map)['seasonKey'] ?? '-') : '-'}',
                    ),
                    Text(
                      '${l10n.crewUiTr117}: ${hub['myRole'] ?? '-'}',
                    ),
                    Text(
                      '${l10n.crewUiTr118}: ${(hub['canDeclare'] == true) ? l10n.crewUiTr119 : l10n.crewUiTr120}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (hub['canDeclare'] == true && currentWar == null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.crewUiTr121,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _selectedWarTargetCrewId,
                        decoration: InputDecoration(
                          labelText: l10n.crewUiTr122,
                        ),
                        items: availableTargets
                            .map(
                              (target) => DropdownMenuItem<int>(
                                value: target['id'] as int,
                                child: Text(
                                  l10n.crewUiWarTargetCrewSubtitle(
                                    (target['name'] ?? '').toString(),
                                    (target['memberCount'] as num?)?.toInt() ?? 0,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedWarTargetCrewId = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedWarType,
                        decoration: InputDecoration(
                          labelText: l10n.crewUiTr123,
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'kill_war',
                            child: Text(l10n.crewUiTr62),
                          ),
                          DropdownMenuItem(
                            value: 'economy_war',
                            child: Text(l10n.crewUiTr63),
                          ),
                          DropdownMenuItem(
                            value: 'territory_war',
                            child: Text(l10n.crewUiTr64),
                          ),
                          DropdownMenuItem(
                            value: 'total_war',
                            child: Text(l10n.crewUiTr65),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _selectedWarType = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _crewWarLoading ? null : _declareCrewWar,
                          icon: const Icon(Icons.gavel),
                          label: Text(
                            l10n.crewUiTr124,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (currentWar != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${currentWar['attackerCrew'] is Map ? ((currentWar['attackerCrew'] as Map)['name'] ?? '#${currentWar['attackerCrewId']}') : '#${currentWar['attackerCrewId']}'} vs ${currentWar['defenderCrew'] is Map ? ((currentWar['defenderCrew'] as Map)['name'] ?? '#${currentWar['defenderCrewId']}') : '#${currentWar['defenderCrewId']}'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Chip(
                            label: Text(_formatCrewWarStatus(l10n, status)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCrewWarType(
                          l10n,
                          currentWar['warType'] as String?,
                        ),
                      ),
                      if ((currentWar['warType'] as String?) ==
                              'territory_war' ||
                          (currentWar['warType'] as String?) ==
                              'total_war') ...[
                        const SizedBox(height: 12),
                        Text(
                          l10n.crewUiTr125,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: territories.map<Widget>((territory) {
                            final currentHolderCrewId =
                                territory['currentHolderCrewId'];
                            final holderLabel =
                                currentHolderCrewId ==
                                    currentWar['attackerCrewId']
                                ? ((currentWar['attackerCrew'] as Map?)?['name']
                                          ?.toString() ??
                                      '#${currentWar['attackerCrewId']}')
                                : currentHolderCrewId ==
                                      currentWar['defenderCrewId']
                                ? ((currentWar['defenderCrew'] as Map?)?['name']
                                          ?.toString() ??
                                      '#${currentWar['defenderCrewId']}')
                                : l10n.crewUiTr126;
                            return Chip(
                              avatar: const Icon(
                                Icons.place_outlined,
                                size: 18,
                              ),
                              label: Text(
                                '${_formatWarTerritoryOptionLabel(l10n, territory)} • $holderLabel • ${_formatWarTerritoryBonusSummary(l10n, territory)}',
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      if (opponentMembers.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.crewUiTr127}: ${currentWar['opponentCrew'] is Map ? ((currentWar['opponentCrew'] as Map)['name'] ?? '-') : '-'}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: opponentMembers.map((member) {
                            final player = (member['player'] as Map?)
                                ?.cast<String, dynamic>();
                            final participant = (member['participant'] as Map?)
                                ?.cast<String, dynamic>();
                            final playerId =
                                (member['playerId'] as num?)?.toInt() ?? 0;
                            final username =
                                (player?['username'] ?? '#$playerId')
                                    .toString();
                            final role = _formatCrewWarRole(
                              l10n,
                              (member['role'] ?? 'member').toString(),
                            );
                            final kills =
                                (participant?['kills'] as num?)?.toInt() ?? 0;
                            final deaths =
                                (participant?['deaths'] as num?)?.toInt() ?? 0;
                            return Chip(
                              avatar: const Icon(Icons.person, size: 18),
                              label: Text(
                                '$username • $role • K:$kills D:$deaths',
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      Text(
                        '${l10n.crewUiTr128}: ${currentWar['activeFrom'] ?? '-'}',
                      ),
                      if (myParticipant == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: ElevatedButton.icon(
                            onPressed: _crewWarLoading
                                ? null
                                : () => _joinCrewWar(currentWar['id'] as int),
                            icon: const Icon(Icons.login),
                            label: Text(l10n.crewUiTr129),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildWarActionButton(
                                l10n.crewUiWarActionKill,
                                Icons.close,
                                canAct,
                                () => handleAction('attack_kill'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionMug,
                                Icons.paid,
                                canAct,
                                () => handleAction('attack_mug'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionSabotage,
                                Icons.construction,
                                canAct,
                                () => handleAction('attack_sabotage'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionIntel,
                                Icons.search,
                                canAct,
                                () => handleAction('intel_scan'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionRaid,
                                Icons.local_fire_department,
                                canAct,
                                () => handleAction('raid'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionShield,
                                Icons.shield,
                                canAct,
                                () => handleAction('crew_shield'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionBoost,
                                Icons.bolt,
                                canAct,
                                () => handleAction('war_boost'),
                              ),
                              _buildWarActionButton(
                                l10n.crewUiWarActionTerritory,
                                Icons.flag,
                                canAct,
                                () => handleAction('territory_claim'),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.crewUiTr130,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...standings.map(
                        (standing) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            child: Text('${standing['rank'] ?? '-'}'),
                          ),
                          title: Text(
                            standing['crew'] is Map
                                ? ((standing['crew'] as Map)['name'] ??
                                      '#${standing['crewId']}')
                                : '#${standing['crewId']}',
                          ),
                          subtitle: Text(
                            '${l10n.crewUiTr41}: ${standing['totalKills'] ?? 0} • ${l10n.crewUiTr42}: ${standing['totalDeaths'] ?? 0} • ${l10n.crewUiTr131}: ${standing['territoriesHeld'] ?? 0}',
                          ),
                          trailing: Text('${standing['totalPoints'] ?? 0} pt'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.crewUiTr132,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (recentActions.isEmpty)
                        Text(
                          l10n.crewUiTr133,
                        ),
                      ...recentActions
                          .take(10)
                          .map(
                            (action) => ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.bolt, size: 18),
                              title: Text(
                                '${action['actionType']} • +${action['pointsAwarded'] ?? 0} pt',
                              ),
                              subtitle: Text(
                                '${action['actor'] is Map ? ((action['actor'] as Map)['username'] ?? '#${action['actorId']}') : '#${action['actorId']}'} ${l10n.crewUiTr134} ${action['target'] is Map ? ((action['target'] as Map)['username'] ?? '-') : '-'}',
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.crewUiTr135,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (seasonLeaderboard.isEmpty)
                      Text(
                        l10n.crewUiTr136,
                      ),
                    ...seasonLeaderboard.map(
                      (entry) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text('${entry['rank'] ?? '-'}'),
                        ),
                        title: Text(
                          entry['crew'] is Map
                              ? ((entry['crew'] as Map)['name'] ??
                                    '#${entry['crewId']}')
                              : '#${entry['crewId']}',
                        ),
                        subtitle: Text(
                          '${l10n.crewUiTr41}: ${entry['totalKills'] ?? 0} • ${l10n.crewUiTr137}: €${entry['totalLoot'] ?? 0}',
                        ),
                        trailing: Text('${entry['totalPoints'] ?? 0} pt'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.crewUiTr138,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (recentWars.isEmpty)
                      Text(
                        l10n.crewUiTr139,
                      ),
                    ...recentWars.map(
                      (war) => ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.history),
                        title: Text(
                          '${_formatCrewWarType(l10n, war['warType'] as String?)} • ${_formatCrewWarStatus(l10n, war['status'] as String?)}',
                        ),
                        subtitle: Text(
                          '#${war['attackerCrewId']} vs #${war['defenderCrewId']}',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarActionButton(
    String label,
    IconData icon,
    bool enabled,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }

  Widget _buildSingleBuildingCard(
    String buildingType,
    bool isLeader,
  ) {
    final building = _crewBuildings.firstWhere(
      (b) => (b['type'] as String?) == buildingType,
      orElse: () => {
        'type': buildingType,
        'label': _getBuildingLabel(buildingType, l10n),
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
    final localizedLabel = _getBuildingLabel(type ?? buildingType, l10n);
    final imagePath = _getCrewBuildingImagePath(type, hqStyle, level);
    final capacity = building['capacity'] as int?;
    final memberCap = building['memberCap'] as int?;
    final parkingSlots = building['parkingSlots'] as int?;
    final nextCost = building['nextUpgradeCost'] as int?;
    final crewVip = building['crewVip'] as bool? ?? false;
    final allowedLevelByHq = building['allowedLevelByHq'] as int? ?? 0;

    final status = level == null
        ? _t(l10n, 'status.notOwned')
        : '${_t(l10n, 'label.level')} $level/$maxLevel';

    if (type == 'hq') {
      final displayLevel = _getHqGlobalLevel(
        building['style'] as String?,
        level,
      );
      final displayCap = memberCap ?? 0;
      final nextStyle = _getNextHqStyle();
      final canUnlockNextStyle =
          level != null && level >= maxLevel && nextStyle != null;
      final requiredSideLevel = _requiredSideBuildingLevelForHqUpgrade(
        building['style'] as String?,
        level,
      );
      final missingSideBuildings =
          (level != null &&
              ((level < maxLevel && nextCost != null) || canUnlockNextStyle))
          ? _getMissingSideBuildingsForHqUpgrade(requiredSideLevel, l10n)
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
              Center(
                child: Text(
                  localizedLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                              child: WebAssetHelper.image(
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
                          : canUnlockNextStyle
                          ? (isLeader && !hqUpgradeBlockedBySideBuildings
                                ? () => _purchaseBuilding(type ?? '')
                                : null)
                          : null,
                      child: Text(
                        (level == null)
                            ? '${_t(l10n, 'action.purchase')}${nextCost != null ? ' (${_money(nextCost)})' : ''}'
                            : (level < maxLevel && nextCost != null)
                            ? '${_t(l10n, 'action.upgrade')} (${_money(nextCost)})'
                            : canUnlockNextStyle
                            ? '${_t(l10n, 'action.upgrade')}${nextCost != null ? ' (${_money(nextCost)})' : ''}'
                            : status,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: _t(l10n, 'help.showCaps'),
                    onPressed: () =>
                        _showBuildingCapsDialog(type ?? '', label),
                    icon: const Icon(Icons.info_outline),
                  ),
                ],
              ),
              if (!isLeader &&
                  ((level == null) ||
                      (level < maxLevel && nextCost != null) ||
                      canUnlockNextStyle))
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.crewUiTr140,
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
                              l10n.crewUiTr141,
                              style: const TextStyle(color: Colors.orange),
                            ),
                            const SizedBox(height: 4),
                            TextButton.icon(
                              onPressed: () => _showHqUpgradeRequirementsDialog(
                                requiredSideLevel,
                                missingSideBuildings,
                              ),
                              icon: const Icon(Icons.info_outline, size: 16),
                              label: Text(_t(l10n, 'action.details')),
                            ),
                          ],
                        )
                      : Text(
                          l10n.crewUiHqUpgradeSideBuildingsMessage(
                            requiredSideLevel.toString(),
                            missingSideBuildings.isEmpty
                                ? '—'
                                : '- ${missingSideBuildings.join('\n- ')}',
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
                    l10n.crewUiTr142,
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
            Center(
              child: Text(
                localizedLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
                            child: _buildCrewBuildingCardImage(
                              type: type,
                              imagePath: imagePath,
                              level: level,
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
                          ? '${_t(l10n, 'action.purchase')}${nextCost != null ? ' (${_money(nextCost)})' : ''}'
                          : (level < maxLevel && nextCost != null)
                          ? '${_t(l10n, 'action.upgrade')} (${_money(nextCost)})'
                          : status,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: _t(l10n, 'help.showCaps'),
                  onPressed: () =>
                      _showBuildingCapsDialog(type ?? '', label),
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
            if (!isLeader &&
                ((level == null) || (level < maxLevel && nextCost != null)))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.crewUiTr140,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            if (level != null && allowedLevelByHq < level)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.crewUiTr143,
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
                      ? l10n.crewUiTr3
                      : l10n.crewUiTr144,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        );
      },
    );
  }

  String _getBuildingLabel(String buildingType, AppLocalizations loc) {
    switch (buildingType) {
      case 'hq':
        return loc.crewUiBuildingHq;
      case 'car_storage':
        return loc.crewUiBuildingCarStorage;
      case 'boat_storage':
        return loc.crewUiBuildingBoatStorage;
      case 'weapon_storage':
        return loc.crewUiBuildingWeaponStorage;
      case 'ammo_storage':
        return loc.crewUiBuildingAmmoStorage;
      case 'drug_storage':
        return loc.crewUiBuildingDrugStorage;
      case 'trade_storage':
        return Localizations.localeOf(context).languageCode == 'nl'
            ? 'Handelswarenopslag'
            : 'Trade storage';
      case 'cash_storage':
        return loc.crewUiBuildingCashStorage;
      default:
        return buildingType;
    }
  }

  Widget _buildCrewMissionsTab() {
    if (_myCrew == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flag_outlined, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _t(l10n, 'state.crewMissionNoCrew'),
              style: const TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_crewMissionsLoading && _crewMissionsOverview == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final overview = _crewMissionsOverview ?? <String, dynamic>{};
    final templates = (overview['templates'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final activeRun = overview['activeRun'] is Map<String, dynamic>
        ? overview['activeRun'] as Map<String, dynamic>
        : null;
    final recentRuns = (overview['recentRuns'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final crewProgress = overview['crewProgress'] is Map<String, dynamic>
        ? overview['crewProgress'] as Map<String, dynamic>
        : null;
    final role = (overview['role'] ?? '').toString().toLowerCase();
    final canManage = role == 'leader' || role == 'co_leader';

    return RefreshIndicator(
      onRefresh: () => _loadCrewMissionsOverview(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _t(l10n, 'section.crewMissions'),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_crewMissionsLoading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
                if (!canManage) ...[
                  const SizedBox(height: 8),
                  Text(
                    _t(l10n, 'hint.missionLeaderOnly'),
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
                const SizedBox(height: 12),
                if (_crewMissionActionLoading)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _t(l10n, 'state.missionActionBusy'),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                if (crewProgress != null) ...[
                  _buildCrewMissionProgressCard(crewProgress, l10n),
                  const SizedBox(height: 16),
                ],
                if (templates.any((template) => template['unlocked'] != true)) ...[
                  Card(
                    color: Colors.orange.withValues(alpha: 0.08),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _t(l10n, 'hint.missionUnlockCta'),
                            style: const TextStyle(height: 1.35),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              OutlinedButton.icon(
                                onPressed: _openCrewHqTab,
                                icon: const Icon(Icons.apartment, size: 18),
                                label: Text(_t(l10n, 'action.goToHqForMissions')),
                              ),
                              OutlinedButton.icon(
                                onPressed: _openCrewStorageTab,
                                icon: const Icon(Icons.inventory_2_outlined, size: 18),
                                label: Text(_t(l10n, 'action.goToStorage')),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (activeRun != null) ...[
                  Text(
                    _t(l10n, 'label.activeMission'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildActiveCrewMissionCard(activeRun, canManage, l10n),
                  const SizedBox(height: 16),
                ],
                if (templates.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      _t(l10n, 'state.crewMissionsEmpty'),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: templates
                        .map(
                          (template) => SizedBox(
                            width: 340,
                            child: _buildCrewMissionTemplateCard(
                              template,
                              loc: l10n,
                              canManage: canManage,
                              hasActiveRun: activeRun != null,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 18),
                Text(
                  _t(l10n, 'label.recentMissions'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (recentRuns.isEmpty)
                  Text(
                    l10n.crewUiMissionNoHistory,
                    style: const TextStyle(color: Colors.grey),
                  )
                else
                  ...recentRuns
                      .take(6)
                      .map((run) => _buildCrewMissionRunRow(run, l10n)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCrewMissionProgressCard(
    Map<String, dynamic> crewProgress,
    AppLocalizations loc,
  ) {
    final level = (crewProgress['level'] as num?)?.toInt() ?? 1;
    final totalXp = (crewProgress['totalXp'] as num?)?.toInt() ?? 0;
    final xpIntoLevel = (crewProgress['xpIntoLevel'] as num?)?.toInt() ?? 0;
    final xpForNextLevel =
        (crewProgress['xpForNextLevel'] as num?)?.toInt() ?? 1;
    final progressPct = (crewProgress['progressPct'] as num?)?.toDouble() ?? 0;
    final cashRewardBonusPct =
        (crewProgress['cashRewardBonusPct'] as num?)?.toDouble() ?? 0;
    final nextLevelCashRewardBonusPct =
        (crewProgress['nextLevelCashRewardBonusPct'] as num?)?.toDouble() ??
        cashRewardBonusPct;
    final progressValue = progressPct.clamp(0, 100) / 100;

    return Card(
      color: const Color(0xFF1A2332),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _t(loc, 'label.crewMissionProgress'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFD4AF37)),
                  ),
                  child: Text(
                    '${_t(loc, 'label.level')} $level',
                    style: const TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _t(loc, 'hint.missionLevelProgress'),
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                Text('${_t(loc, 'label.crewMissionXp')}: $totalXp'),
                Text(
                  '${_t(loc, 'label.crewMissionLevelBonus')}: +${cashRewardBonusPct.toStringAsFixed(cashRewardBonusPct % 1 == 0 ? 0 : 1)}%',
                ),
                Text(
                  '${_t(loc, 'label.crewMissionNextLevelBonus')}: +${nextLevelCashRewardBonusPct.toStringAsFixed(nextLevelCashRewardBonusPct % 1 == 0 ? 0 : 1)}%',
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progressValue,
              minHeight: 14,
              borderRadius: BorderRadius.circular(999),
              backgroundColor: Colors.white12,
              color: const Color(0xFFD4AF37),
            ),
            const SizedBox(height: 8),
            Text(
              '$xpIntoLevel / $xpForNextLevel XP',
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrewMissionTemplateCard(
    Map<String, dynamic> template, {
    required AppLocalizations loc,
    required bool canManage,
    required bool hasActiveRun,
  }) {
    final isNl = loc.localeName.startsWith('nl');
    final title = isNl
        ? (template['titleNl'] ?? template['missionKey'] ?? '').toString()
        : (template['titleEn'] ?? template['missionKey'] ?? '').toString();
    final description = isNl
        ? (template['descriptionNl'] ?? '').toString()
        : (template['descriptionEn'] ?? '').toString();
    final tier = (template['tier'] as num?)?.toInt() ?? 1;
    final durationSeconds = (template['durationSeconds'] as num?)?.toInt() ?? 0;
    final cooldownSeconds = (template['cooldownSeconds'] as num?)?.toInt() ?? 0;
    final rewardCashMin = (template['rewardCashMin'] as num?)?.toInt() ?? 0;
    final rewardCashMax = (template['rewardCashMax'] as num?)?.toInt() ?? 0;
    final rewardCrewXp = (template['rewardCrewXp'] as num?)?.toInt() ?? 0;
    final unlocked = template['unlocked'] == true;
    final lockedReason = template['lockedReason']?.toString();
    final missionKey = (template['missionKey'] ?? '').toString();
    final imagePath = (template['imageCardPath'] ?? '').toString();
    final fallbackPath = _crewMissionFallbackImagePath(missionKey);
    final tradeRequirements = _extractMissionTradeRequirements(template);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: imagePath.isNotEmpty
                ? WebAssetHelper.image(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        WebAssetHelper.image(
                          fallbackPath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.black12,
                                alignment: Alignment.center,
                                child: const Icon(Icons.image_not_supported),
                              ),
                        ),
                  )
                : Container(
                    color: Colors.black12,
                    child: WebAssetHelper.image(
                      fallbackPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        alignment: Alignment.center,
                        child: const Icon(Icons.flag),
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('${_t(loc, 'label.missionTier')} $tier'),
                    ),
                  ],
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Text(
                  '${_t(loc, 'label.missionDuration')}: ${_formatRemaining(durationSeconds, loc)}',
                ),
                Text(
                  '${_t(loc, 'label.missionCooldown')}: ${_formatRemaining(cooldownSeconds, loc)}',
                ),
                Text(
                  '${_t(loc, 'label.missionRewards')}: ${_money(rewardCashMin)} - ${_money(rewardCashMax)} + $rewardCrewXp XP',
                ),
                if (tradeRequirements.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    _t(loc, 'label.missionTradeCargo'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _t(loc, 'hint.missionTradeCargo'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: tradeRequirements.map((row) {
                      final goodType = (row['goodType'] ?? '').toString();
                      final quantity = (row['quantity'] as num?)?.toInt() ?? 0;
                      final held = _crewTradeHeldQuantity(goodType);
                      final ready = held >= quantity;
                      return Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        backgroundColor: ready
                            ? Colors.green.withValues(alpha: 0.16)
                            : Colors.orange.withValues(alpha: 0.16),
                        label: Text(
                          loc.crewUiMissionTradeHeldNeed(
                            TradeGoodL10n.name(loc, goodType),
                            held,
                            quantity,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tradeRequirements.every((row) {
                          final goodType = (row['goodType'] ?? '').toString();
                          final quantity = (row['quantity'] as num?)?.toInt() ?? 0;
                          return _crewTradeHeldQuantity(goodType) >= quantity;
                        })
                        ? _t(loc, 'hint.missionPrepReady')
                        : _t(loc, 'hint.missionPrepShort'),
                    style: TextStyle(
                      color: tradeRequirements.every((row) {
                            final goodType = (row['goodType'] ?? '').toString();
                            final quantity = (row['quantity'] as num?)?.toInt() ?? 0;
                            return _crewTradeHeldQuantity(goodType) >= quantity;
                          })
                          ? Colors.green.shade300
                          : Colors.orange.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (tradeRequirements.any((row) {
                    final goodType = (row['goodType'] ?? '').toString();
                    final quantity = (row['quantity'] as num?)?.toInt() ?? 0;
                    return _crewTradeHeldQuantity(goodType) < quantity;
                  })) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: _openCrewStorageTab,
                          child: Text(_t(loc, 'action.goToStorage')),
                        ),
                        OutlinedButton(
                          onPressed: _openBlackMarketTrade,
                          child: Text(_t(loc, 'action.goToTradeMarket')),
                        ),
                      ],
                    ),
                  ],
                ],
                if (!unlocked) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_t(loc, 'status.missionLocked')}: ${_crewMissionLockedReason(loc, lockedReason)}',
                    style: const TextStyle(color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: _openCrewHqTab,
                    child: Text(_t(loc, 'action.goToHqForMissions')),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (!canManage ||
                            !unlocked ||
                            hasActiveRun ||
                            missionKey.isEmpty ||
                            _crewMissionActionLoading)
                        ? null
                        : () => _openCrewMissionRoleAssignDialog(missionKey),
                    child: Text(_t(loc, 'action.startMission')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCrewMissionCard(
    Map<String, dynamic> activeRun,
    bool canManage,
    AppLocalizations loc,
  ) {
    final runId = (activeRun['id'] as num?)?.toInt();
    final isNl = loc.localeName.startsWith('nl');
    final title = isNl
        ? (activeRun['titleNl'] ?? activeRun['missionKey'] ?? '').toString()
        : (activeRun['titleEn'] ?? activeRun['missionKey'] ?? '').toString();
    final status = (activeRun['status'] ?? '').toString();
    final endedInSeconds = _secondsUntil(activeRun['endsAt']?.toString());
    final cooldownInSeconds = _secondsUntil(
      activeRun['cooldownUntil']?.toString(),
    );
    final outcome = (activeRun['outcome'] ?? '').toString();
    final progressPct = (activeRun['progressPct'] as num?)?.toInt() ?? 0;
    final rewardCrewCash = (activeRun['rewardCrewCash'] as num?)?.toInt() ?? 0;
    final rewardCrewXp = (activeRun['rewardCrewXp'] as num?)?.toInt() ?? 0;
    final rewardPersonalXp =
        (activeRun['rewardPersonalXp'] as num?)?.toInt() ?? 0;
    final rewardsClaimedAt = activeRun['rewardsClaimedAt']?.toString();
    final missionContributions = _extractMissionContributions(activeRun);

    final canResolve =
        runId != null &&
        canManage &&
        status == 'in_progress' &&
        endedInSeconds <= 0;
    final canClaim =
        runId != null && status == 'completed' && rewardsClaimedAt == null;
    final canSpeedup = runId != null && cooldownInSeconds > 0;
    final speedupQuote = runId == null
        ? null
        : _crewMissionSpeedupQuotes[runId];
    final speedupCredits = (speedupQuote?['credits'] as num?)?.toInt();
    final speedupMinutes = (speedupQuote?['remainingMinutes'] as num?)?.toInt();
    final speedupLoading =
        runId != null && _crewMissionSpeedupQuoteLoading.contains(runId);

    if (canSpeedup && speedupQuote == null && !speedupLoading) {
      Future.microtask(() => _loadCrewMissionSpeedupQuote(runId));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_t(loc, 'label.missionStatus')}: ${status == 'completed' ? _t(loc, 'status.completed') : _t(loc, 'status.inProgress')}',
            ),
            Text('${_t(loc, 'label.level')}: ${activeRun['tier'] ?? '-'}'),
            Text(
              '${_t(loc, 'label.missionDuration')}: ${endedInSeconds > 0 ? _formatRemaining(endedInSeconds, loc) : _t(loc, 'status.ready')}',
            ),
            if (status == 'completed') ...[
              Text('Outcome: ${outcome.isEmpty ? '-' : outcome}'),
              Text(
                '${_t(loc, 'label.missionRewards')}: ${_money(rewardCrewCash)} | Crew XP $rewardCrewXp | XP $rewardPersonalXp',
              ),
              Text('Progress: $progressPct%'),
            ],
            if (missionContributions.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _t(loc, 'label.roleContributions'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: missionContributions.take(6).map((row) {
                  final playerId = (row['playerId'] as num?)?.toInt();
                  final username = (row['username'] ?? '').toString().trim();
                  final roleKey = (row['roleKey'] ?? 'none').toString();
                  final contributionScore = (row['contributionScore'] as num?)
                      ?.toDouble();
                  final payoutMultiplier = (row['payoutMultiplier'] as num?)
                      ?.toDouble();
                  final chipTitle = username.isNotEmpty
                      ? username
                      : '#${playerId ?? 0}';
                  final chipText =
                      '$chipTitle • ${_crewRoleLabel(loc, roleKey)} • ${_t(loc, 'label.contribution')} ${_formatContributionValue(contributionScore)}${payoutMultiplier != null && (payoutMultiplier - 1).abs() > 0.01 ? ' • ${_t(loc, 'label.multiplier')} x${_formatContributionValue(payoutMultiplier)}' : ''}';
                  return Chip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    label: Text(chipText),
                  );
                }).toList(),
              ),
            ],
            if (cooldownInSeconds > 0)
              Text(
                '${_t(loc, 'label.cooldownActive')}: ${_formatRemaining(cooldownInSeconds, loc)}',
              ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (canResolve)
                  ElevatedButton(
                    onPressed: _crewMissionActionLoading
                        ? null
                        : () => _resolveCrewMission(runId),
                    child: Text(_t(loc, 'action.resolveMission')),
                  ),
                if (canClaim)
                  ElevatedButton(
                    onPressed: _crewMissionActionLoading
                        ? null
                        : () => _claimCrewMissionRewards(runId),
                    child: Text(_t(loc, 'action.claimRewards')),
                  ),
                if (canSpeedup)
                  OutlinedButton.icon(
                    onPressed: _crewMissionActionLoading || speedupLoading
                        ? null
                        : () => _confirmSpeedupCrewMissionCooldown(runId),
                    icon: const Icon(Icons.bolt),
                    label: Text(
                      speedupLoading
                          ? _t(loc, 'state.loadingPrice')
                          : speedupCredits == null
                          ? _t(loc, 'action.speedupCooldown')
                          : '${_t(loc, 'action.speedupCooldown')} ($speedupCredits ${_t(loc, 'label.credits')}${speedupMinutes != null ? ', ${speedupMinutes}m' : ''})',
                    ),
                  ),
                if (rewardsClaimedAt != null)
                  Chip(label: Text(_t(loc, 'status.rewardsClaimed'))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCrewMissionRunRow(Map<String, dynamic> run, AppLocalizations loc) {
    final isNl = loc.localeName.startsWith('nl');
    final title = isNl
        ? (run['titleNl'] ?? run['missionKey'] ?? '').toString()
        : (run['titleEn'] ?? run['missionKey'] ?? '').toString();
    final outcome = (run['outcome'] ?? '-').toString();
    final rewardCrewCash = (run['rewardCrewCash'] as num?)?.toInt() ?? 0;
    final cooldownInSeconds = _secondsUntil(run['cooldownUntil']?.toString());
    final hasCooldown = cooldownInSeconds > 0;
    final missionContributions = _extractMissionContributions(run);
    final contributionsPreview = missionContributions
        .take(3)
        .map((row) {
          final username = (row['username'] ?? '').toString().trim();
          final playerId = (row['playerId'] as num?)?.toInt();
          final roleKey = (row['roleKey'] ?? 'none').toString();
          final contributionScore = (row['contributionScore'] as num?)
              ?.toDouble();
          final displayName = username.isNotEmpty
              ? username
              : '#${playerId ?? 0}';
          return '$displayName (${_crewRoleLabel(loc, roleKey)} ${_formatContributionValue(contributionScore)})';
        })
        .join(' • ');

    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(
          missionContributions.isEmpty
              ? '${_t(loc, 'label.missionRewards')}: ${_money(rewardCrewCash)} - Outcome: $outcome'
              : '${_t(loc, 'label.missionRewards')}: ${_money(rewardCrewCash)} - Outcome: $outcome\n${_t(loc, 'label.roleContributions')}: $contributionsPreview',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: hasCooldown
            ? Text(
                '${_t(loc, 'label.missionCooldown')}: ${_formatRemaining(cooldownInSeconds, loc)}',
                style: const TextStyle(fontSize: 12),
              )
            : Text(
                _t(loc, 'status.ready'),
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
      ),
    );
  }

  Widget _buildAllCrewsTab() {
    final locale = Localizations.localeOf(context).languageCode;

    if (_allCrews.isEmpty) {
      return Center(
        child: Text(
          _t(l10n, 'state.noCrewsFound'),
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
                    '${_t(l10n, 'label.memberCount')}: ${crew.memberCount}',
                  ),
                  Text(
                    crew.autoAccept
                        ? (locale == 'nl'
                            ? 'Open · direct joinen'
                            : 'Open · instant join')
                        : (locale == 'nl'
                            ? 'Open · verzoek nodig'
                            : 'Open · request required'),
                    style: const TextStyle(fontSize: 12),
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
                        _t(l10n, 'badge.myCrew'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : _myCrew != null
                  ? null
                  : _pendingJoinCrewIds.contains(crew.id)
                  ? OutlinedButton(
                      onPressed: () => _cancelJoin(crew.id),
                      child: Text(
                        locale == 'nl' ? 'Annuleer' : 'Cancel',
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () => _joinCrew(crew.id),
                      child: Text(
                        crew.autoAccept
                            ? (locale == 'nl' ? 'Join nu' : 'Join now')
                            : _t(l10n, 'action.join'),
                      ),
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _t(l10n, 'state.notInCrew'),
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              _t(l10n, 'hint.chatJoinCrew'),
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
