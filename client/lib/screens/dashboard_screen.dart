import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import '../l10n/app_localizations.dart';
import '../models/player.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../utils/support_badge_state.dart';
import '../utils/avatar_helper.dart';
import '../utils/country_helper.dart';
import '../utils/fontawesome_icons.dart';
import '../utils/formatters.dart';
import '../widgets/event_feed.dart';
import '../widgets/icu_overlay.dart';
import '../utils/localized_game_event_template.dart';
import '../utils/top_right_notification.dart';
import '../utils/localized_api_message.dart';
import '../services/event_renderer.dart';
import 'crime_screen.dart';
import 'jobs_screen.dart';
import 'travel_screen.dart';
import 'aviation_screen.dart';
import 'crew_screen.dart';
import 'friends_screen.dart';
import 'inventory_screen.dart';
import 'property_screen.dart';
import 'casino_screen.dart';
import 'black_market_screen.dart';
import 'court_screen.dart';
import 'hospital_screen.dart';
import 'vehicle_heist_screen.dart';
import 'tune_shop_screen.dart';
import 'direct_messages_screen.dart';
import 'tools_screen.dart';
import 'hitlist_screen.dart';
import 'security_screen.dart';
import 'training_hub_screen.dart';
import 'ammo_factory_screen.dart';
import 'school_screen.dart';
import 'prostitution_screen.dart';
import 'bank_screen.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';
import 'prison_screen.dart';
import 'drug_environment_screen.dart';
import 'smuggling_screen.dart';
import 'nightclub_screen.dart';
import 'crypto_screen.dart';
import 'stock_market_screen.dart';
import 'events_screen.dart';
import 'help_screen.dart';
import 'territory_screen.dart';
import 'player_profile_screen.dart';
import 'premium_screen.dart';
import 'support_tickets_screen.dart';
import 'vault_screen.dart';

enum _WebSection {
  support,
  dashboard,
  vault,
  events,
  crimes,
  jobs,
  messages,
  help,
  settings,
  travel,
  aviation,
  crew,
  premium,
  friends,
  inventory,
  properties,
  bank,
  casino,
  blackMarket,
  drugs,
  nightclub,
  crypto,
  stockMarket,
  smuggling,
  tools,
  court,
  hitlist,
  security,
  hospital,
  prison,
  vehicleHeist,
  tuneShop,
  garage,
  marina,
  trainingHub,
  ammoFactory,
  school,
  territory,
  prostitution,
  redLightDistricts,
  achievements,
}

_WebSection _webSectionFromQueryParam(String? value) {
  switch ((value ?? '').toLowerCase()) {
    case 'premium':
      return _WebSection.premium;
    case 'vault':
      return _WebSection.vault;
    default:
      return _WebSection.dashboard;
  }
}

String _rankProgressLabel(BuildContext context, int rank) {
  final l10n = AppLocalizations.of(context)!;
  final baseLabel = l10n.rankProgress;
  return '$baseLabel (${l10n.rank} $rank)';
}

String _cashLabel(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.cash;
}

String _newMessagesLabel(BuildContext context, int count) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.dashboardNewMessagesCount(count);
}

String _killProgressLabel(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.dashboardKillProgress;
}

String _localizedVehicleOpsHeatLevel(AppLocalizations l10n, String raw) {
  switch (raw.trim().toUpperCase()) {
    case 'LOW':
      return l10n.vehicleOpsHeatLevelLow;
    case 'MEDIUM':
    case 'MID':
      return l10n.vehicleOpsHeatLevelMedium;
    case 'HIGH':
      return l10n.vehicleOpsHeatLevelHigh;
    default:
      return raw;
  }
}

const Color _dashboardGold = Color(0xFFFFB347);
const Color _dashboardBgStart = Color(0xFF160707);
const Color _dashboardBgMid = Color(0xFF261010);
const Color _dashboardBgEnd = Color(0xFF100505);
const Color _dashboardPanelDark = Color(0xFF1B1212);
const Color _dashboardPanelLight = Color(0xFF2A1A1A);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Mobile-first layout threshold (small phones)
  static const double _mobileBreakpoint = 600;
  // Tablet layout threshold (drawers / stacked dashboard cards)
  static const double _tabletBreakpoint = 900;
  // Wide desktop threshold (both side panels visible)
  static const double _wideDesktopBreakpoint = 1200;

  int _unreadCount = 0;
  int _pendingFriendRequestCount = 0;
  int _supportBadgeCount = 0;

  void _openPlayerProfile(Player player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PlayerProfileScreen(playerId: player.id, username: player.username),
      ),
    );
  }

  StreamSubscription? _eventSubscription;
  Timer? _playerRefreshTimer;
  bool _checkedPremiumPopup = false;
  _WebSection _selectedWebSection = _WebSection.dashboard;
  int _webSectionRefreshSeed = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _vehicleHeistTabIndex = 0;

  void _openVehicleHeist([int initialTabIndex = 0]) {
    setState(() {
      _vehicleHeistTabIndex = initialTabIndex;
      _selectedWebSection = _WebSection.vehicleHeist;
    });
  }

  void _selectWebSection(_WebSection section) {
    setState(() {
      if (_selectedWebSection == section) {
        _webSectionRefreshSeed++;
      } else {
        _selectedWebSection = section;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedWebSection = _webSectionFromQueryParam(
      Uri.base.queryParameters['section'],
    );
    // Connect to event stream when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.connect();
      _refreshDashboardBadges();
      _setupSSEListener();
      _startPlayerRefreshTimer();
      _checkPremiumPopupOnOpen();
    });
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _playerRefreshTimer?.cancel();
    super.dispose();
  }

  void _startPlayerRefreshTimer() {
    _playerRefreshTimer?.cancel();
    _playerRefreshTimer = Timer.periodic(const Duration(seconds: 30), (
      _,
    ) async {
      if (!mounted) {
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (!authProvider.isAuthenticated) {
        return;
      }

      await authProvider.refreshPlayer();
      await _refreshDashboardBadges();
    });
  }

  void _setupSSEListener() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final eventStreamService = eventProvider.eventStreamService;

    _eventSubscription = eventStreamService.eventStream.listen((event) {
      if (event['event'] == 'direct_message.received' ||
          event['event'] == 'direct_message.deleted' ||
          event['event'] == 'direct_message.read') {
        _refreshDashboardBadges();
      }
    });
  }

  Future<void> _refreshDashboardBadges() async {
    await Future.wait<void>([
      _loadUnreadCount(),
      _loadPendingFriendRequestCount(),
      _loadSupportBadgeCount(),
    ]);
  }

  Future<void> _loadUnreadCount() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/messages/unread');

      print('[Dashboard] Response status: ${response.statusCode}');
      print('[Dashboard] Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('[Dashboard] Empty response body');
          if (mounted) {
            setState(() => _unreadCount = 0);
          }
          return;
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print('[Dashboard] Decoded data keys: ${data.keys}');

        final params = data['params'] as Map<String, dynamic>?;
        print('[Dashboard] Params: $params');

        if (params != null) {
          final unreadRaw = params['unreadCount'] ?? params['count'] ?? 0;
          final unreadCount = unreadRaw is int
              ? unreadRaw
              : int.tryParse(unreadRaw.toString()) ?? 0;

          if (mounted) {
            setState(() {
              _unreadCount = unreadCount;
            });
          }
          print('[Dashboard] Total unread: $unreadCount');
        } else {
          print('[Dashboard] Params is null');
          if (mounted) {
            setState(() => _unreadCount = 0);
          }
        }
      } else {
        print('[Dashboard] Non-200 status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('[Dashboard] Error loading unread count: $e');
      print('[Dashboard] Stack trace: $stackTrace');
    }
  }

  Future<void> _loadPendingFriendRequestCount() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/friends/pending');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          if (mounted) {
            setState(() => _pendingFriendRequestCount = 0);
          }
          return;
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>?;
        final requests = params?['requests'] as List<dynamic>?;

        if (mounted) {
          setState(() {
            _pendingFriendRequestCount = requests?.length ?? 0;
          });
        }
      } else if (mounted) {
        setState(() => _pendingFriendRequestCount = 0);
      }
    } catch (e) {
      print('[Dashboard] Error loading pending friend requests: $e');
    }
  }

  Future<void> _loadSupportBadgeCount() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/tickets/my');

      if (response.statusCode != 200 || response.body.isEmpty) {
        if (mounted) {
          setState(() => _supportBadgeCount = 0);
        }
        return;
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final params = decoded['params'] as Map<String, dynamic>? ?? const {};
      final rawTickets = params['tickets'] as List<dynamic>? ?? const [];
      final currentSignatures = <int, String>{};

      for (final rawTicket in rawTickets) {
        final ticket = rawTicket as Map<String, dynamic>;
        final ticketId = _asDashboardInt(ticket['id']);
        if (ticketId <= 0) {
          continue;
        }

        currentSignatures[ticketId] = buildSupportTicketSeenSignature(
          updatedAt: _asDashboardDateTime(ticket['updatedAt']),
          status: (ticket['status'] ?? 'new').toString(),
          lastMessageBy: ticket['lastMessageBy']?.toString(),
        );
      }

      final badgeCount = await countUnseenSupportTicketUpdates(
        currentSignatures,
        initializeIfEmpty: true,
      );

      if (mounted) {
        setState(() => _supportBadgeCount = badgeCount);
      }
    } catch (e) {
      print('[Dashboard] Error loading support badge count: $e');
    }
  }

  int _asDashboardInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  DateTime _asDashboardDateTime(dynamic value) {
    final parsed = DateTime.tryParse(value?.toString() ?? '');
    return (parsed ?? DateTime.now()).toLocal();
  }

  Future<void> _checkPremiumPopupOnOpen() async {
    if (_checkedPremiumPopup || !mounted) return;
    _checkedPremiumPopup = true;

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get(
        '/subscriptions/checkout/one-time/popup?locale=$locale',
      );

      if (response.statusCode != 200 || response.body.isEmpty || !mounted) {
        return;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final popup = data['popup'] as Map<String, dynamic>?;
      if (popup == null) return;

      final productKey = (popup['key'] ?? '').toString();
      final titleRaw = (popup['title'] ?? '').toString().trim();
      final price = (popup['priceEur'] ?? '0.00').toString();
      final reward = (popup['reward'] ?? '').toString();
      final imageUrl = (popup['imageUrl'] ?? '').toString();

      await showDialog<void>(
        context: context,
        builder: (ctx) {
          final l10n = AppLocalizations.of(ctx)!;
          return AlertDialog(
            title: Text(
              titleRaw.isEmpty
                  ? l10n.dashboardPremiumOfferDefaultTitle
                  : titleRaw,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Image.network(
                      imageUrl,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),
                  ),
                Text('€$price'),
                if (reward.isNotEmpty) Text(reward),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(l10n.close),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (kIsWeb) {
                    setState(() => _selectedWebSection = _WebSection.crew);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CrewScreen()),
                    );
                  }
                },
                child: Text(l10n.viewOffer),
              ),
            ],
          );
        },
      );

      if (productKey.isNotEmpty) {
        await apiClient.post('/subscriptions/checkout/one-time/popup/seen', {
          'productKey': productKey,
        });
      }
    } catch (_) {}
  }

  Widget _buildWebShell(
    BuildContext context,
    AppLocalizations l10n,
    dynamic player,
  ) {
    final countryName = CountryHelper.getLocalizedCountryName(
      player.currentCountry,
      l10n,
      fallbackName: player.currentCountry?.toString(),
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final showSidebars = screenWidth >= _wideDesktopBreakpoint;
    final showLeftSidebar = screenWidth >= _tabletBreakpoint;

    return Scaffold(
      key: _scaffoldKey,
      drawer: !showLeftSidebar
          ? _buildDrawer(context, l10n, 'navigation')
          : null,
      endDrawer: !showSidebars ? _buildDrawer(context, l10n, 'actions') : null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_dashboardPanelLight, _dashboardPanelDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(color: _dashboardGold, width: 1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                if (!showLeftSidebar)
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    tooltip: l10n.menu,
                  ),
                if (!showLeftSidebar) const SizedBox(width: 8),
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 600,
                      maxHeight: 100,
                      minHeight: 60,
                    ),
                    child: Image.network(
                      'title_mobstate.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) => Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!showSidebars)
                  IconButton(
                    icon: const Icon(Icons.flash_on),
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                    tooltip: l10n.quickActions,
                  ),
                PopupMenuButton<String>(
                  tooltip: l10n.userAccountMenuTooltip,
                  onSelected: (value) async {
                    switch (value) {
                      case 'messages':
                        _selectWebSection(_WebSection.messages);
                        break;
                      case 'help':
                        if (kIsWeb) {
                          _selectWebSection(_WebSection.help);
                        } else if (context.mounted) {
                          Navigator.of(context).pushNamed('/help');
                        }
                        break;
                      case 'settings':
                        if (kIsWeb) {
                          _selectWebSection(_WebSection.settings);
                        } else if (context.mounted) {
                          Navigator.of(context).pushNamed('/settings');
                        }
                        break;
                      case 'logout':
                        final authProvider = Provider.of<AuthProvider>(
                          context,
                          listen: false,
                        );
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).pushNamedAndRemoveUntil('/login', (route) => false);
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      enabled: false,
                      child: Text(
                        player.username,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'messages',
                      child: Row(
                        children: [
                          const Icon(Icons.mail, size: 20),
                          const SizedBox(width: 12),
                          Text(l10n.messages),
                          if (_unreadCount > 0)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.red,
                                child: Text(
                                  _unreadCount > 99 ? '99+' : '$_unreadCount',
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'help',
                      child: Row(
                        children: [
                          const Icon(Icons.menu_book, size: 20),
                          const SizedBox(width: 12),
                          Text(l10n.helpAndGuide),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings, size: 20),
                          const SizedBox(width: 12),
                          Text(l10n.settings),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, size: 20, color: Colors.red),
                          const SizedBox(width: 12),
                          Text(
                            l10n.logOut,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade700,
                        ),
                        child: ClipOval(
                          child: Image(
                            image: AvatarHelper.getAvatarImageProvider(
                              player.avatar,
                              activePortraitPath: player.activePortraitPath,
                            ),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.account_circle,
                              size: 28,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ),
                      if (_unreadCount > 0)
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              _unreadCount > 99 ? '99+' : '$_unreadCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (showLeftSidebar)
                  Container(
                    width: 230,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_dashboardPanelLight, _dashboardPanelDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border(
                        right: BorderSide(
                          color: _dashboardGold.withOpacity(0.6),
                        ),
                      ),
                    ),
                    child: ListView(
                      children: _buildWebMenuItems(context, l10n),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildCompactStatusBar(context, player, countryName),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  _dashboardBgStart,
                                  _dashboardBgMid,
                                  _dashboardBgEnd,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _dashboardGold.withOpacity(0.45),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context)
                                    .copyWith(
                                      dragDevices: {
                                        PointerDeviceKind.touch,
                                        PointerDeviceKind.mouse,
                                        PointerDeviceKind.stylus,
                                        PointerDeviceKind.invertedStylus,
                                        PointerDeviceKind.trackpad,
                                        PointerDeviceKind.unknown,
                                      },
                                    ),
                                child: KeyedSubtree(
                                  key: ValueKey(
                                    '${_selectedWebSection.name}-$_webSectionRefreshSeed',
                                  ),
                                  child: _buildWebContent(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (showSidebars)
                  Container(
                    width: 240,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_dashboardPanelLight, _dashboardPanelDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      border: Border(
                        left: BorderSide(
                          color: _dashboardGold.withOpacity(0.6),
                        ),
                      ),
                    ),
                    child: _buildActionsPanel(context, l10n),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWebMenuItems(
    BuildContext context,
    AppLocalizations l10n, {
    VoidCallback? onBeforeNavigate,
  }) {
    final items =
        <({IconData icon, String label, _WebSection section, int badge})>[
          (
            icon: Icons.dashboard,
            label: l10n.dashboard,
            section: _WebSection.dashboard,
            badge: 0,
          ),
          (
            icon: Icons.lock,
            label: l10n.menuCrackVault,
            section: _WebSection.vault,
            badge: 0,
          ),
          (
            icon: Icons.menu_book,
            label: l10n.helpAndGuide,
            section: _WebSection.help,
            badge: 0,
          ),
          (
            icon: FontAwesomeIcons.commentsSolid,
            label: l10n.support,
            section: _WebSection.support,
            badge: _supportBadgeCount,
          ),
          (
            icon: Icons.event,
            label: l10n.events,
            section: _WebSection.events,
            badge: 0,
          ),
          (
            icon: Icons.warning,
            label: l10n.crimes,
            section: _WebSection.crimes,
            badge: 0,
          ),
          (
            icon: Icons.work,
            label: l10n.jobs,
            section: _WebSection.jobs,
            badge: 0,
          ),
          (
            icon: Icons.flight,
            label: l10n.travel,
            section: _WebSection.travel,
            badge: 0,
          ),
          (
            icon: FontAwesomeIcons.planeSolid,
            label: l10n.aviation,
            section: _WebSection.aviation,
            badge: 0,
          ),
          (
            icon: Icons.groups,
            label: l10n.crew,
            section: _WebSection.crew,
            badge: 0,
          ),
          (
            icon: Icons.workspace_premium,
            label: l10n.premiumAndCredits,
            section: _WebSection.premium,
            badge: 0,
          ),
          (
            icon: Icons.group,
            label: l10n.friends,
            section: _WebSection.friends,
            badge: _pendingFriendRequestCount,
          ),
          (
            icon: Icons.inventory,
            label: l10n.inventory,
            section: _WebSection.inventory,
            badge: 0,
          ),
          (
            icon: Icons.business,
            label: l10n.properties,
            section: _WebSection.properties,
            badge: 0,
          ),
          (
            icon: Icons.account_balance,
            label: l10n.bank,
            section: _WebSection.bank,
            badge: 0,
          ),
          (
            icon: Icons.casino,
            label: l10n.casino,
            section: _WebSection.casino,
            badge: 0,
          ),
          (
            icon: Icons.store,
            label: l10n.blackMarket,
            section: _WebSection.blackMarket,
            badge: 0,
          ),
          (
            icon: Icons.local_pharmacy,
            label: l10n.drugs,
            section: _WebSection.drugs,
            badge: 0,
          ),
          (
            icon: Icons.nightlife,
            label: l10n.nightclub,
            section: _WebSection.nightclub,
            badge: 0,
          ),
          (
            icon: Icons.currency_bitcoin,
            label: l10n.crypto,
            section: _WebSection.crypto,
            badge: 0,
          ),
          (
            icon: Icons.show_chart,
            label: l10n.stockMarketTitle,
            section: _WebSection.stockMarket,
            badge: 0,
          ),
          (
            icon: Icons.local_shipping,
            label: l10n.smuggling,
            section: _WebSection.smuggling,
            badge: 0,
          ),
          (
            icon: Icons.build,
            label: l10n.tools,
            section: _WebSection.tools,
            badge: 0,
          ),
          (
            icon: Icons.gavel,
            label: l10n.court,
            section: _WebSection.court,
            badge: 0,
          ),
          (
            icon: Icons.gps_fixed,
            label: l10n.hitlist,
            section: _WebSection.hitlist,
            badge: 0,
          ),
          (
            icon: Icons.shield,
            label: l10n.security,
            section: _WebSection.security,
            badge: 0,
          ),
          (
            icon: Icons.local_hospital,
            label: l10n.hospital,
            section: _WebSection.hospital,
            badge: 0,
          ),
          (
            icon: Icons.gpp_bad,
            label: l10n.jail,
            section: _WebSection.prison,
            badge: 0,
          ),
          (
            icon: Icons.directions_car_filled,
            label: l10n.vehicleHeist,
            section: _WebSection.vehicleHeist,
            badge: 0,
          ),
          (
            icon: Icons.tune,
            label: l10n.tuneShop,
            section: _WebSection.tuneShop,
            badge: 0,
          ),
          (
            // fitness_center: reliably bundled on Flutter Web (sports_martial_arts can render empty).
            icon: Icons.fitness_center,
            label: l10n.trainingHubMenuLabel,
            section: _WebSection.trainingHub,
            badge: 0,
          ),
          (
            icon: Icons.factory,
            label: l10n.ammoFactory,
            section: _WebSection.ammoFactory,
            badge: 0,
          ),
          (
            icon: Icons.school,
            label: l10n.schoolMenuLabel,
            section: _WebSection.school,
            badge: 0,
          ),
          (
            icon: Icons.language,
            label: l10n.territory,
            section: _WebSection.territory,
            badge: 0,
          ),
          (
            icon: Icons.favorite,
            label: l10n.prostitutionTitle,
            section: _WebSection.prostitution,
            badge: 0,
          ),
          (
            icon: Icons.storefront,
            label: l10n.prostitutionRedLightDistricts,
            section: _WebSection.redLightDistricts,
            badge: 0,
          ),
          (
            icon: Icons.emoji_events,
            label: l10n.achievements,
            section: _WebSection.achievements,
            badge: 0,
          ),
        ];

    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                gradient: _selectedWebSection == item.section
                    ? LinearGradient(
                        colors: [
                          _dashboardGold.withOpacity(0.22),
                          _dashboardGold.withOpacity(0.08),
                        ],
                      )
                    : const LinearGradient(
                        colors: [_dashboardPanelLight, _dashboardPanelDark],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedWebSection == item.section
                      ? _dashboardGold.withOpacity(0.9)
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: ListTile(
                selected: _selectedWebSection == item.section,
                leading: Icon(
                  item.icon,
                  color: _selectedWebSection == item.section
                      ? _dashboardGold
                      : Colors.white70,
                ),
                title: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _selectedWebSection == item.section
                        ? Colors.white
                        : Colors.white70,
                    fontWeight: _selectedWebSection == item.section
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                trailing: item.badge > 0
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          item.badge > 99 ? '99+' : '${item.badge}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
                onTap: () {
                  onBeforeNavigate?.call();
                  _selectWebSection(item.section);
                },
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildActionsPanel(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.quickActions,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: _dashboardGold,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _buildActionCard(
                context,
                icon: Icons.warning,
                title: l10n.crimes,
                subtitle: l10n.quickActionsCrimesSubtitle,
                color: Colors.red.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.crimes),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.directions_car_filled,
                title: l10n.vehicleHeist,
                subtitle: l10n.quickActionsVehicleHeistSubtitle,
                color: Colors.orange.shade700,
                onTap: () => _openVehicleHeist(0),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.tune,
                title: l10n.tuneShop,
                subtitle: l10n.quickActionsTuneShopSubtitle,
                color: Colors.purple.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.tuneShop),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.event,
                title: l10n.events,
                subtitle: l10n.quickActionsEventsSubtitle,
                color: Colors.teal.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.events),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.work,
                title: l10n.jobs,
                subtitle: l10n.quickActionsJobsSubtitle,
                color: Colors.green.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.jobs),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.casino,
                title: l10n.casino,
                subtitle: l10n.quickActionsCasinoSubtitle,
                color: Colors.purple.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.casino),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.account_balance,
                title: l10n.bank,
                subtitle: l10n.quickActionsBankSubtitle,
                color: Colors.indigo.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.bank),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.show_chart,
                title: l10n.stockMarketTitle,
                subtitle: l10n.stockMarketHint,
                color: Colors.teal.shade700,
                onTap: () => setState(
                  () => _selectedWebSection = _WebSection.stockMarket,
                ),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.school,
                title: l10n.schoolMenuLabel,
                subtitle: l10n.schoolMenuSubtitle,
                color: Colors.amber.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.school),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.26), color.withOpacity(0.08)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: color.withOpacity(0.45)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.65)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    AppLocalizations l10n,
    String type,
  ) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'title_mobstate.png',
                    height: 60,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(
                      l10n.appTitle,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: type == 'navigation'
                    ? _buildWebMenuItems(
                        context,
                        l10n,
                        onBeforeNavigate: () =>
                            _scaffoldKey.currentState?.closeDrawer(),
                      )
                    : [
                        ListTile(
                          leading: Icon(
                            Icons.warning,
                            color: Colors.red.shade700,
                          ),
                          title: Text(l10n.crimes),
                          subtitle: Text(l10n.quickActionsCrimesSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.crimes,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.directions_car_filled,
                            color: Colors.orange.shade700,
                          ),
                          title: Text(l10n.vehicleHeist),
                          subtitle: Text(l10n.quickActionsVehicleHeistSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            _openVehicleHeist(0);
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.event,
                            color: Colors.teal.shade700,
                          ),
                          title: Text(l10n.events),
                          subtitle: Text(l10n.quickActionsEventsSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.events,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.work,
                            color: Colors.green.shade700,
                          ),
                          title: Text(l10n.jobs),
                          subtitle: Text(l10n.quickActionsJobsSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.jobs,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.casino,
                            color: Colors.purple.shade700,
                          ),
                          title: Text(l10n.casino),
                          subtitle: Text(l10n.quickActionsCasinoSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.casino,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.account_balance,
                            color: Colors.indigo.shade700,
                          ),
                          title: Text(l10n.bank),
                          subtitle: Text(l10n.quickActionsBankSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.bank,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.currency_bitcoin,
                            color: Colors.cyan.shade700,
                          ),
                          title: Text(l10n.crypto),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.crypto,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.show_chart,
                            color: Colors.teal.shade700,
                          ),
                          title: Text(l10n.stockMarketTitle),
                          subtitle: Text(l10n.stockMarketHint),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () =>
                                  _selectedWebSection = _WebSection.stockMarket,
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.school,
                            color: Colors.amber.shade700,
                          ),
                          title: Text(l10n.schoolMenuLabel),
                          subtitle: Text(l10n.schoolMenuSubtitle),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.school,
                            );
                          },
                        ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatusBar(
    BuildContext context,
    Player player,
    String countryName,
  ) {
    // Calculate rank progress
    final xpForCurrentRank = _getXPForRank(player.rank);
    final xpForNextRank = _getXPForRank(player.rank + 1);
    final xpNeededForNextRank = xpForNextRank - xpForCurrentRank;
    final xpProgressInCurrentRank = player.xp - xpForCurrentRank;
    final rankProgress = (xpProgressInCurrentRank / xpNeededForNextRank).clamp(
      0.0,
      1.0,
    );
    final healthProgress = (player.health / 100).clamp(0.0, 1.0);
    final wantedLevel = (player.wantedLevel ?? 0).toDouble();
    final wantedProgress = (wantedLevel / 5.0).clamp(0.0, 1.0);
    final fbiHeat = (player.fbiHeat ?? 0).toDouble();
    final fbiProgress = (fbiHeat / 100.0).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_dashboardPanelLight, _dashboardPanelDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _dashboardGold.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.32),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // First row: 3 main progress bars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildLargeProgressBar(
                  context,
                  _rankProgressLabel(context, player.rank),
                  rankProgress,
                  '${(rankProgress * 100).toStringAsFixed(0)}%',
                  Colors.amber.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLargeProgressBar(
                  context,
                  AppLocalizations.of(context)!.health,
                  healthProgress,
                  '${player.health}%',
                  player.health > 50
                      ? Colors.green
                      : (player.health > 25 ? Colors.orange : Colors.red),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLargeProgressBar(
                  context,
                  AppLocalizations.of(context)!.security,
                  0.0,
                  '0%',
                  Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Second row: Info + Wanted + FBI
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 2,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _buildTopInfoItem(
                      '${_cashLabel(context)} ${formatCurrency(player.money)}',
                      Colors.green.shade300,
                    ),
                    _buildTopInfoItem(
                      _getRankTitle(AppLocalizations.of(context)!, player.rank),
                      Colors.amber.shade300,
                    ),
                    _buildTopInfoItem(
                      _newMessagesLabel(context, _unreadCount),
                      Colors.white70,
                    ),
                    _buildTopInfoItem(
                      '${CountryHelper.getCountryFlag(player.currentCountry)} $countryName',
                      Colors.white70,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLargeProgressBar(
                  context,
                  AppLocalizations.of(context)!.wantedLevel,
                  wantedProgress,
                  '${wantedLevel.toInt()}/5',
                  wantedLevel > 0 ? Colors.orange : Colors.blueGrey,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLargeProgressBar(
                  context,
                  'FBI',
                  fbiProgress,
                  '${fbiHeat.toInt()}%',
                  fbiHeat > 0 ? Colors.deepPurple : Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopInfoItem(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildLargeProgressBar(
    BuildContext context,
    String label,
    double progress,
    String valueText,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $valueText',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 9,
            backgroundColor: Colors.white.withOpacity(0.14),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  String _getRankTitle(AppLocalizations l10n, int rank) {
    if (rank <= 5) return l10n.rankBeginner;
    if (rank <= 10) return l10n.rankCriminal;
    if (rank <= 15) return l10n.rankGangster;
    if (rank <= 20) return l10n.rankMafioso;
    return l10n.rankGodfather;
  }

  Widget _buildWebContent(BuildContext context) {
    switch (_selectedWebSection) {
      case _WebSection.support:
        return SupportTicketsScreen(
          embedded: true,
          onSeenSnapshotChanged: _loadSupportBadgeCount,
        );
      case _WebSection.dashboard:
        return const _WebDashboardHomeContent();
      case _WebSection.vault:
        return const VaultScreen(embedded: true);
      case _WebSection.events:
        return const EventsScreen(embedded: true);
      case _WebSection.crimes:
        return const CrimeScreen();
      case _WebSection.jobs:
        return const JobsScreen();
      case _WebSection.messages:
        return const DirectMessagesScreen();
      case _WebSection.help:
        return const HelpScreen(embedded: true);
      case _WebSection.settings:
        return const SettingsScreen(embedded: true);
      case _WebSection.travel:
        return const TravelScreen();
      case _WebSection.aviation:
        return const AviationScreen();
      case _WebSection.crew:
        return const CrewScreen();
      case _WebSection.premium:
        return const PremiumScreen(embedded: true);
      case _WebSection.friends:
        return const FriendsScreen();
      case _WebSection.inventory:
        return const InventoryScreen();
      case _WebSection.properties:
        return PropertyScreen();
      case _WebSection.bank:
        return const BankScreen();
      case _WebSection.casino:
        return const CasinoScreen();
      case _WebSection.blackMarket:
        return const BlackMarketScreen();
      case _WebSection.drugs:
        return const DrugEnvironmentScreen();
      case _WebSection.nightclub:
        return const NightclubScreen();
      case _WebSection.crypto:
        return const CryptoScreen();
      case _WebSection.stockMarket:
        return const StockMarketScreen();
      case _WebSection.smuggling:
        return const SmugglingScreen();
      case _WebSection.tools:
        return const ToolsScreen();
      case _WebSection.court:
        return const CourtScreen();
      case _WebSection.hitlist:
        return const HitlistScreen();
      case _WebSection.security:
        return const SecurityScreen();
      case _WebSection.hospital:
        return const HospitalScreen();
      case _WebSection.prison:
        return const PrisonScreen();
      case _WebSection.vehicleHeist:
        return VehicleHeistScreen(
          key: ValueKey('vehicle-heist-$_vehicleHeistTabIndex'),
          embedded: true,
          initialTabIndex: _vehicleHeistTabIndex,
        );
      case _WebSection.tuneShop:
        return const TuneShopScreen(embedded: true);
      case _WebSection.garage:
        return const VehicleHeistScreen(embedded: true, initialTabIndex: 0);
      case _WebSection.marina:
        return const VehicleHeistScreen(embedded: true, initialTabIndex: 2);
      case _WebSection.trainingHub:
        return TrainingHubScreen(
          onOpenCrimes: () => _selectWebSection(_WebSection.crimes),
        );
      case _WebSection.ammoFactory:
        return const AmmoFactoryScreen();
      case _WebSection.school:
        return const SchoolScreen();
      case _WebSection.territory:
        return const TerritoryScreen();
      case _WebSection.prostitution:
        return const ProstitutionScreen();
      case _WebSection.redLightDistricts:
        // Deep-link into Empire hub RLD tab (Workers=0, RLD=1, Events=2, Social=3).
        return const ProstitutionScreen(initialTabIndex: 1);
      case _WebSection.achievements:
        return const AchievementsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final useEmbeddedWebShell = kIsWeb;

    return Scaffold(
      appBar: useEmbeddedWebShell
          ? null
          : AppBar(
              title: Text(l10n.dashboard),
              actions: [
                IconButton(
                  icon: const Icon(Icons.chat),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DirectMessagesScreen(),
                      ),
                    ).then((_) => _loadUnreadCount());
                  },
                  tooltip: l10n.messages,
                ),
                IconButton(
                  icon: const Icon(Icons.backpack),
                  onPressed: () => Navigator.pushNamed(context, '/inventory'),
                  tooltip: l10n.inventory,
                ),
                IconButton(
                  icon: const Icon(Icons.menu_book),
                  onPressed: () => Navigator.of(context).pushNamed('/help'),
                  tooltip: l10n.helpAndGuide,
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.of(context).pushNamed('/settings'),
                  tooltip: l10n.settings,
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    final authProvider = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    await authProvider.logout();
                    if (context.mounted) {
                      Navigator.of(
                        context,
                      ).pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  },
                  tooltip: l10n.logout,
                ),
              ],
            ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final player = authProvider.currentPlayer;

          if (player == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (useEmbeddedWebShell) {
            return _buildWebShell(context, l10n, player);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: () => _openPlayerProfile(player),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 32,
                                child: ClipOval(
                                  child: Image(
                                    image: AvatarHelper.getAvatarImageProvider(
                                      player.avatar,
                                      activePortraitPath: player.activePortraitPath,
                                    ),
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      final avatar =
                                          player.avatar ?? 'default_1';
                                      return Center(
                                        child: Text(
                                          avatar.isNotEmpty
                                              ? avatar[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(fontSize: 32),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              if (_unreadCount > 0)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).cardColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      _unreadCount > 99
                                          ? '99+'
                                          : '$_unreadCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Player info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.welcome(player.username),
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 12),
                              _RankProgressBar(
                                rank: player.rank,
                                currentXP: player.xp,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Action buttons - Grid layout
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            // Responsive action grid: adjust columns based on screen width
                            int crossAxisCount;
                            if (constraints.maxWidth > _wideDesktopBreakpoint) {
                              // Wide desktop: 7 cols
                              crossAxisCount = 7;
                            } else if (constraints.maxWidth >
                                _tabletBreakpoint) {
                              // Tablet: 6 cols
                              crossAxisCount = 6;
                            } else if (constraints.maxWidth >
                                _mobileBreakpoint) {
                              // Medium mobile: 5 cols
                              crossAxisCount = 5;
                            } else {
                              // Small mobile: 3 cols
                              crossAxisCount = 3;
                            }

                            return GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                _buildMenuTile(
                                  context,
                                  icon: Icons.event,
                                  label: l10n.events,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const EventsScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.warning,
                                  label: l10n.crimes,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CrimeScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.work,
                                  label: l10n.jobs,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const JobsScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.chat,
                                  label: l10n.messages,
                                  badge: _unreadCount,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DirectMessagesScreen(),
                                    ),
                                  ).then((_) => _refreshDashboardBadges()),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.menu_book,
                                  label: l10n.helpAndGuide,
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/help'),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: FontAwesomeIcons.commentsSolid,
                                  label: l10n.support,
                                  badge: _supportBadgeCount,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SupportTicketsScreen(
                                        onSeenSnapshotChanged:
                                            _loadSupportBadgeCount,
                                      ),
                                    ),
                                  ).then((_) => _refreshDashboardBadges()),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.flight,
                                  label: l10n.travel,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TravelScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: FontAwesomeIcons.planeSolid,
                                  label: l10n.aviation,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AviationScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.groups,
                                  label: l10n.crew,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CrewScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.group,
                                  label: l10n.friends,
                                  badge: _pendingFriendRequestCount,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FriendsScreen(),
                                    ),
                                  ).then((_) => _refreshDashboardBadges()),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.business,
                                  label: l10n.properties,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PropertyScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.casino,
                                  label: l10n.casino,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CasinoScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.account_balance,
                                  label: l10n.bank,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const BankScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.currency_bitcoin,
                                  label: l10n.crypto,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CryptoScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.show_chart,
                                  label: l10n.stockMarketTitle,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const StockMarketScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.local_shipping,
                                  label: l10n.smuggling,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SmugglingScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.store,
                                  label: l10n.blackMarket,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const BlackMarketScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.local_pharmacy,
                                  label: l10n.drugs,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DrugEnvironmentScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.nightlife,
                                  label: l10n.nightclub,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const NightclubScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.build,
                                  label: l10n.tools,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ToolsScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.favorite,
                                  label: l10n.prostitutionTitle,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/prostitution',
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.storefront,
                                  label: l10n.prostitutionRedLightDistricts,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/prostitution',
                                    // Empire hub: Workers=0, RLD=1, Events=2, Social=3
                                    arguments: {'tabIndex': 1},
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.gavel,
                                  label: l10n.court,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CourtScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.gps_fixed,
                                  label: l10n.hitlist,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HitlistScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.shield,
                                  label: l10n.security,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SecurityScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.local_hospital,
                                  label: l10n.hospital,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HospitalScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.gpp_bad,
                                  label: l10n.jail,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const PrisonScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.directions_car_filled,
                                  label: l10n.vehicleHeist,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const VehicleHeistScreen(
                                        initialTabIndex: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.tune,
                                  label: l10n.tuneShop,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TuneShopScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.fitness_center,
                                  label: l10n.trainingHubMenuLabel,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TrainingHubScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.factory,
                                  label: l10n.ammoFactory,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AmmoFactoryScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.school,
                                  label: l10n.schoolMenuLabel,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const SchoolScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.language,
                                  label: l10n.territory,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    '/territory',
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Events feed card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.feed, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              l10n.liveEvents,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const Spacer(),
                            Consumer<EventProvider>(
                              builder: (context, eventProvider, _) {
                                return Icon(
                                  eventProvider.isConnected
                                      ? Icons.wifi
                                      : Icons.wifi_off,
                                  size: 20,
                                  color: eventProvider.isConnected
                                      ? Colors.green
                                      : Colors.grey,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300,
                          child: const EventFeed(maxEvents: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          const ICUOverlay(), // Always rendered, shows itself when in ICU
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    int badge = 0,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(color: Colors.amber.shade700, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.shade700.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 36, color: Colors.amber.shade700),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (badge > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    badge > 99 ? '99+' : '$badge',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WebDashboardHomeContent extends StatefulWidget {
  const _WebDashboardHomeContent();

  @override
  State<_WebDashboardHomeContent> createState() =>
      _WebDashboardHomeContentState();
}

class _WebDashboardHomeContentState extends State<_WebDashboardHomeContent> {
  DashboardStats? _stats;
  bool _loading = true;
  List<Map<String, dynamic>> _gameEventsActive = const [];
  Map<String, dynamic>? _dailyGoals;
  bool _dailyGoalsLoading = false;
  Map<String, dynamic>? _weeklyGoals;
  bool _weeklyGoalsLoading = false;
  Timer? _cooldownTimer;
  Timer? _refreshTimer;

  String _dailyGoalTitle(AppLocalizations l10n, String key) {
    switch (key) {
      case 'crime_3':
        return l10n.dailyGoalTitle_crime_3;
      case 'job_2':
        return l10n.dailyGoalTitle_job_2;
      case 'vehicle_theft_1':
        return l10n.dailyGoalTitle_vehicle_theft_1;
      case 'travel_1':
        return l10n.dailyGoalTitle_travel_1;
      case 'weekly_crime_20':
        return l10n.dailyGoalTitle_weekly_crime_20;
      case 'weekly_job_10':
        return l10n.dailyGoalTitle_weekly_job_10;
      case 'weekly_vehicle_theft_5':
        return l10n.dailyGoalTitle_weekly_vehicle_theft_5;
      case 'weekly_travel_3':
        return l10n.dailyGoalTitle_weekly_travel_3;
      default:
        return key;
    }
  }

  String _timeAgoLabel(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final l10n = AppLocalizations.of(context)!;
    if (diff.inSeconds < 20) return l10n.justNow;
    if (diff.inMinutes < 1) {
      return l10n.secondsAgo(diff.inSeconds.toString());
    }
    if (diff.inHours < 1) {
      return l10n.minutesAgo(diff.inMinutes.toString());
    }
    return l10n.hoursAgo(diff.inHours.toString());
  }

  void _openSessionRecap(AppLocalizations l10n) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final renderer = EventRenderer(l10n);
    final items = eventProvider.events.take(10).toList();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF141012).withOpacity(0.98),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _dashboardGold.withOpacity(0.35)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.75,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt_long, color: _dashboardGold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.sessionRecap,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close, color: Colors.white70),
                      tooltip: l10n.close,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.last10EventsLive,
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: items.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noEventsYetSession,
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                        )
                      : ListView.separated(
                          itemCount: items.length,
                          separatorBuilder: (_, _) => Divider(color: Colors.white.withOpacity(0.08)),
                          itemBuilder: (_, i) {
                            final ev = items[i];
                            final text = renderer.renderEvent(ev.eventKey, ev.params);
                            final when = _timeAgoLabel(ev.timestamp);
                            final isPositive = ev.eventKey.endsWith('.success') ||
                                ev.eventKey == 'job.success' ||
                                ev.eventKey == 'crime.success';
                            final accent = isPositive ? Colors.greenAccent : Colors.white70;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: accent.withOpacity(0.85),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          text,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          when,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.55),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => eventProvider.clearEvents(),
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.clearRecap),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.18)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadStats();
    _loadGameEventsOverview();
    _loadDailyGoals();
    _loadWeeklyGoals();

    // Update cooldowns every second
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _stats != null) {
        setState(() {
          // Decrement cooldowns
          _stats = DashboardStats(
            crimeAttempts: _stats!.crimeAttempts,
            breakoutCount: _stats!.breakoutCount,
            killCount: _stats!.killCount,
            hitsPlacedCount: _stats!.hitsPlacedCount,
            successfulCrimes: _stats!.successfulCrimes,
            jobAttempts: _stats!.jobAttempts,
            vehicleThieves: _stats!.vehicleThieves,
            boatThieves: _stats!.boatThieves,
            streetProstitutes: _stats!.streetProstitutes,
            redLightProstitutes: _stats!.redLightProstitutes,
            totalAmmo: _stats!.totalAmmo,
            drugsTotalQuantity: _stats!.drugsTotalQuantity,
            nightclubVenues: _stats!.nightclubVenues,
            nightclubRevenueAllTime: _stats!.nightclubRevenueAllTime,
            travelCount: _stats!.travelCount,
            weapons: _stats!.weapons,
            selectedWeaponName: _stats!.selectedWeaponName,
            activeVehicle: _stats!.activeVehicle,
            jailed: _stats!.jailTimeRemaining > 1,
            jailTimeRemaining: _stats!.jailTimeRemaining > 0
                ? _stats!.jailTimeRemaining - 1
                : 0,
            bankBalance: _stats!.bankBalance,
            economy: _stats!.economy,
            economy24h: _stats!.economy24h,
            activity7d: _stats!.activity7d,
            operations: _tickOperations(_stats!.operations),
            notifications: _stats!.notifications,
            risk: _stats!.risk,
            crewWar: _stats!.crewWar?.copyWith(
              phaseEndsInSeconds: (_stats!.crewWar?.phaseEndsInSeconds ?? 0) > 0
                  ? (_stats!.crewWar?.phaseEndsInSeconds ?? 0) - 1
                  : 0,
            ),
            territoryLeaderStats: _stats!.territoryLeaderStats,
            territoryDrama: _stats!.territoryDrama,
            vehicleOps: _tickVehicleOps(_stats!.vehicleOps),
            cooldowns: Map.fromEntries(
              _stats!.cooldowns.entries.map(
                (e) => MapEntry(e.key, e.value > 0 ? e.value - 1 : 0),
              ),
            ),
          );
        });
      }
    });

    // Refresh stats every 15 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) {
        _loadStats();
        _loadGameEventsOverview();
        _loadDailyGoals();
        _loadWeeklyGoals();
      }
    });

    // Listen to events for immediate refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.addListener(_onEventReceived);
    });
  }

  void _onEventReceived() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final lastEvent = eventProvider.events.isNotEmpty
        ? eventProvider.events.last
        : null;

    if (lastEvent != null) {
      // Refresh on action completion events
      if (lastEvent.eventKey == 'crime.success' ||
          lastEvent.eventKey == 'job.success' ||
          lastEvent.eventKey == 'job.work' ||
          lastEvent.eventKey == 'casino.gamble' ||
          lastEvent.eventKey == 'trade.buy' ||
          lastEvent.eventKey == 'travel.arrive' ||
          lastEvent.eventKey == 'crew.war_declared' ||
          lastEvent.eventKey == 'crew.war_started' ||
          lastEvent.eventKey == 'crew.war_lockdown' ||
          lastEvent.eventKey == 'crew.war_resolved' ||
          lastEvent.eventKey == 'crew.war_action') {
        _loadStats();
      }
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _refreshTimer?.cancel();
    // Remove event listener
    try {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.removeListener(_onEventReceived);
    } catch (e) {
      // Context might not be available
    }
    super.dispose();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await DashboardService.getDashboardStats();
      if (mounted) {
        setState(() {
          _stats = stats;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _loadDailyGoals() async {
    if (_dailyGoalsLoading) return;
    setState(() => _dailyGoalsLoading = true);
    try {
      final api = AuthService().apiClient;
      final response = await api.get('/daily-goals/daily');
      if (response.statusCode != 200) {
        return;
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] == true && decoded['data'] is Map) {
        if (mounted) {
          setState(() => _dailyGoals = Map<String, dynamic>.from(decoded['data'] as Map));
        }
      }
    } catch (_) {
      // keep last known state
    } finally {
      if (mounted) setState(() => _dailyGoalsLoading = false);
    }
  }

  Future<void> _loadWeeklyGoals() async {
    if (_weeklyGoalsLoading) return;
    setState(() => _weeklyGoalsLoading = true);
    try {
      final api = AuthService().apiClient;
      final response = await api.get('/daily-goals/weekly');
      if (response.statusCode != 200) {
        return;
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] == true && decoded['data'] is Map) {
        if (mounted) {
          setState(() => _weeklyGoals = Map<String, dynamic>.from(decoded['data'] as Map));
        }
      }
    } catch (_) {
      // keep last known state
    } finally {
      if (mounted) setState(() => _weeklyGoalsLoading = false);
    }
  }

  Future<void> _claimDailyGoal(String goalKey) async {
    try {
      final api = AuthService().apiClient;
      final response = await api.post('/daily-goals/daily/claim', {
        'goalKey': goalKey,
      });
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      if (decoded['success'] == true) {
        final isWeekly = goalKey.startsWith('weekly_');
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(
              isWeekly
                  ? l10n.weeklyGoalClaimed
                  : l10n.dailyGoalClaimed,
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.zero,
          ),
        );
        await _loadStats();
        await _loadDailyGoals();
        await _loadWeeklyGoals();
        return;
      }
      final params = (decoded['params'] as Map<String, dynamic>?) ?? const {};
      final l10n = AppLocalizations.of(context)!;
      final fromApi = localizedApiMessage(context, params);
      final text = fromApi ?? l10n.failed;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(text),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
        ),
      );
    } catch (_) {
      final l10n = AppLocalizations.of(context)!;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.failedPleaseTryAgain),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.zero,
        ),
      );
    }
  }

  Widget _buildDailyGoalsCard() {
    final data = _dailyGoals;
    final goals = (data?['goals'] as List?) ?? const [];
    if (goals.isEmpty && !_dailyGoalsLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _panelDecoration(accent: Colors.lightGreenAccent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.task_alt, color: Colors.lightGreenAccent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.dailyGoals,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_dailyGoalsLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 10),
          ...goals.whereType<Map>().map((raw) {
            final g = Map<String, dynamic>.from(raw);
            final key = g['key']?.toString() ?? '';
            final l10n = AppLocalizations.of(context)!;
            final title = _dailyGoalTitle(l10n, key);
            final progress = (g['progress'] as num?)?.toInt() ?? 0;
            final target = (g['target'] as num?)?.toInt() ?? 0;
            final claimable = g['claimable'] == true;
            final claimed = g['claimed'] == true;
            final rewardCash = (g['rewardCash'] as num?)?.toInt() ?? 0;
            final rewardXp = (g['rewardXp'] as num?)?.toInt() ?? 0;

            final ratio = target <= 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (claimed)
                          Text(
                            AppLocalizations.of(context)!.claimed,
                            style: TextStyle(
                              color: Colors.greenAccent.withOpacity(0.9),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          )
                        else if (claimable)
                          Text(
                            AppLocalizations.of(context)!.ready,
                            style: TextStyle(
                              color: Colors.lightGreenAccent.withOpacity(0.9),
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          )
                        else
                          Text(
                            '$progress/$target',
                            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.12),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          claimable ? Colors.lightGreenAccent : _dashboardGold.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.dailyGoalReward(
                              formatCurrency(rewardCash),
                              rewardXp.toString(),
                            ),
                            style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (!claimed)
                          OutlinedButton(
                            onPressed: claimable && key.isNotEmpty ? () => _claimDailyGoal(key) : null,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: (claimable ? Colors.lightGreenAccent : Colors.white24).withOpacity(0.8),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.claim),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeeklyGoalsMiniCard() {
    final data = _weeklyGoals;
    final goals = (data?['goals'] as List?) ?? const [];
    if (goals.isEmpty && !_weeklyGoalsLoading) {
      return const SizedBox.shrink();
    }

    int completed = 0;
    int total = 0;
    int claimable = 0;
    for (final raw in goals.whereType<Map>()) {
      final g = Map<String, dynamic>.from(raw);
      total += 1;
      if (g['claimed'] == true) completed += 1;
      if (g['claimable'] == true) claimable += 1;
    }

    final ratio = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    final subtitle = claimable > 0
        ? AppLocalizations.of(context)!.readyToClaim(claimable.toString())
        : AppLocalizations.of(context)!.completedOutOfTotal(
            completed.toString(),
            total.toString(),
          );

    void openWeeklyGoalsSheet() {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF141012).withOpacity(0.98),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.35)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.cyanAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.weeklyGoals,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: Colors.white70),
                        tooltip: AppLocalizations.of(context)!.close,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView(
                      children: goals.whereType<Map>().map((raw) {
                        final g = Map<String, dynamic>.from(raw);
                        final key = g['key']?.toString() ?? '';
                        final l10n = AppLocalizations.of(context)!;
                        final title = _dailyGoalTitle(l10n, key);
                        final progress = (g['progress'] as num?)?.toInt() ?? 0;
                        final target = (g['target'] as num?)?.toInt() ?? 0;
                        final claimableLocal = g['claimable'] == true;
                        final claimedLocal = g['claimed'] == true;
                        final rewardCash = (g['rewardCash'] as num?)?.toInt() ?? 0;
                        final rewardXp = (g['rewardXp'] as num?)?.toInt() ?? 0;
                        final ratioLocal = target <= 0 ? 0.0 : (progress / target).clamp(0.0, 1.0);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        title.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    if (claimedLocal)
                                      Text(
                                        AppLocalizations.of(context)!.claimed,
                                        style: TextStyle(
                                          color: Colors.greenAccent.withOpacity(0.9),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                        ),
                                      )
                                    else if (claimableLocal)
                                      Text(
                                        AppLocalizations.of(context)!.ready,
                                        style: TextStyle(
                                          color: Colors.cyanAccent.withOpacity(0.9),
                                          fontWeight: FontWeight.w800,
                                          fontSize: 12,
                                        ),
                                      )
                                    else
                                      Text(
                                        '$progress/$target',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
                                          fontSize: 12,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: ratioLocal,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withOpacity(0.12),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      claimableLocal
                                          ? Colors.cyanAccent.withOpacity(0.9)
                                          : Colors.cyanAccent.withOpacity(0.55),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.dailyGoalReward(
                                          formatCurrency(rewardCash),
                                          rewardXp.toString(),
                                        ),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    if (!claimedLocal)
                                      OutlinedButton(
                                        onPressed: claimableLocal && key.isNotEmpty
                                            ? () => _claimDailyGoal(key)
                                            : null,
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          side: BorderSide(
                                            color: (claimableLocal
                                                    ? Colors.cyanAccent
                                                    : Colors.white24)
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                        child: Text(AppLocalizations.of(context)!.claim),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _panelDecoration(accent: Colors.cyanAccent),
      child: InkWell(
        onTap: openWeeklyGoalsSheet,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: Colors.cyanAccent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.weeklyGoals,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_weeklyGoalsLoading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 8,
                backgroundColor: Colors.white.withOpacity(0.12),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent.withOpacity(0.9)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadGameEventsOverview() async {
    try {
      final api = AuthService().apiClient;
      final response = await api.get('/game-events/overview');
      if (response.statusCode != 200) {
        return;
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final active = ((data['active'] as List?) ?? const <dynamic>[])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      if (mounted) {
        setState(() {
          _gameEventsActive = active;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _gameEventsActive = const [];
        });
      }
    }
  }

  String _formatCooldown(int seconds) {
    return formatAdaptiveDurationFromSeconds(
      seconds,
      localeName: Localizations.localeOf(context).languageCode,
    );
  }

  VehicleOpsCategoryDashboardSummary? _tickVehicleOpsCategory(
    VehicleOpsCategoryDashboardSummary? category,
  ) {
    if (category == null) return null;
    return category.copyWith(
      cooldowns: Map.fromEntries(
        category.cooldowns.entries.map(
          (entry) => MapEntry(entry.key, entry.value > 0 ? entry.value - 1 : 0),
        ),
      ),
    );
  }

  VehicleOpsDashboardSummary? _tickVehicleOps(
    VehicleOpsDashboardSummary? summary,
  ) {
    if (summary == null) return null;
    return summary.copyWith(
      car: _tickVehicleOpsCategory(summary.car),
      motorcycle: _tickVehicleOpsCategory(summary.motorcycle),
      boat: _tickVehicleOpsCategory(summary.boat),
    );
  }

  DashboardOperationsSummary? _tickOperations(
    DashboardOperationsSummary? operations,
  ) {
    if (operations == null) return null;
    return DashboardOperationsSummary(
      activeCooldownCount: operations.activeCooldownCount,
      longestCooldownSeconds: operations.longestCooldownSeconds > 0
          ? operations.longestCooldownSeconds - 1
          : 0,
      activeDrugProductionsCount: operations.activeDrugProductionsCount,
      nextDrugProductionEndsInSeconds:
          operations.nextDrugProductionEndsInSeconds > 0
          ? operations.nextDrugProductionEndsInSeconds - 1
          : 0,
      activeNightclubEventsCount: operations.activeNightclubEventsCount,
      nextNightclubEventStartsInSeconds:
          operations.nextNightclubEventStartsInSeconds > 0
          ? operations.nextNightclubEventStartsInSeconds - 1
          : 0,
      activeVehicleCount: operations.activeVehicleCount,
      listedVehicleCount: operations.listedVehicleCount,
      inTransitVehicleCount: operations.inTransitVehicleCount,
    );
  }

  BoxDecoration _panelDecoration({Color accent = _dashboardGold}) {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [_dashboardPanelLight, _dashboardPanelDark],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: accent.withOpacity(0.45)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.28),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;
    final l10n = AppLocalizations.of(context)!;

    if (player == null) {
      return Center(child: Text(AppLocalizations.of(context)!.noPlayerData));
    }

    // Calculate rank progress
    final xpForCurrentRank = _getXPForRank(player.rank);
    final xpForNextRank = _getXPForRank(player.rank + 1);
    final xpNeededForNextRank = xpForNextRank - xpForCurrentRank;
    final xpProgressInCurrentRank = player.xp - xpForCurrentRank;
    final rankProgress = (xpProgressInCurrentRank / xpNeededForNextRank).clamp(
      0.0,
      1.0,
    );

    final countryName = CountryHelper.getLocalizedCountryName(
      player.currentCountry ?? 'netherlands',
      l10n,
    );

    if (_loading) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_dashboardBgStart, _dashboardBgMid, _dashboardBgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_dashboardBgStart, _dashboardBgMid, _dashboardBgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () => _openSessionRecap(l10n),
                icon: const Icon(Icons.receipt_long, color: Colors.white70),
                tooltip: l10n.sessionRecap,
              ),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                // Dashboard cards: stack vertically on tablet, 3-column layout on desktop
                final isCompact =
                    constraints.maxWidth < _DashboardScreenState._tabletBreakpoint;

                final dailyGoalsCard = _buildDailyGoalsCard();
                final weeklyGoalsCard = _buildWeeklyGoalsMiniCard();

            Widget buildLeftCard() {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _panelDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoRow(l10n.nameLabel, player.username, Colors.white),
                    _buildInfoRow(
                      '${l10n.rank} (${player.rank})',
                      _getRankTitle(l10n, player.rank),
                      Colors.amber.shade300,
                    ),
                    _buildInfoRow(
                      l10n.moneyStatusLabel,
                      _getMoneyStatus(l10n, player.money),
                      Colors.green.shade300,
                    ),
                    _buildInfoRow(
                      l10n.bullets,
                      '${_stats?.totalAmmo ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(l10n.xp, '${player.xp}', Colors.white),
                    _buildInfoRow(
                      l10n.dashboardClicks,
                      l10n.dashboardValueNotAvailable,
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.countryLabel,
                      '${CountryHelper.getCountryFlag(player.currentCountry)} $countryName',
                      Colors.white,
                    ),
                    if (player.wantedLevel != null && player.wantedLevel! > 0)
                      _buildInfoRow(
                        l10n.wantedLevel,
                        '${player.wantedLevel}',
                        Colors.red.shade300,
                      ),
                    if (player.fbiHeat != null && player.fbiHeat! > 0)
                      _buildInfoRow(
                        l10n.fbiHeat,
                        '${player.fbiHeat}',
                        Colors.orange.shade300,
                      ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      l10n.cash,
                      formatCurrency(_stats?.economy?.cashBalance ?? player.money),
                      Colors.green.shade300,
                    ),
                    _buildInfoRow(
                      l10n.bank,
                      formatCurrency(_stats?.economy?.bankBalance ?? _stats?.bankBalance ?? 0),
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.crypto,
                      formatCurrency(_stats?.economy?.cryptoPortfolioValue ?? 0),
                      Colors.cyan.shade300,
                    ),
                    _buildInfoRow(
                      l10n.stockMarketTitle,
                      formatCurrency(_stats?.economy?.stockPortfolioValue ?? 0),
                      Colors.teal.shade200,
                    ),
                    _buildInfoRow(
                      l10n.properties,
                      formatCurrency(_stats?.economy?.propertyPortfolioValue ?? 0),
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.vehicles,
                      formatCurrency(_stats?.economy?.vehiclePortfolioValue ?? 0),
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.netWorth,
                      formatCurrency(_stats?.economy?.netWorth ?? 0),
                      Colors.amber.shade300,
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      l10n.securityLabel,
                      l10n.noSecurity,
                      Colors.grey.shade400,
                    ),
                    _buildInfoRow(
                      l10n.weaponLabel,
                      _stats?.selectedWeaponName != null
                          ? _stats!.selectedWeaponName!
                          : l10n.none,
                      _stats?.selectedWeaponName != null
                          ? Colors.green.shade300
                          : Colors.grey.shade400,
                    ),
                    _buildInfoRow(
                      l10n.vehicleLabel,
                      _stats?.activeVehicle?.name ?? l10n.none,
                      _stats?.activeVehicle != null
                          ? Colors.green.shade300
                          : Colors.grey.shade400,
                    ),
                  ],
                ),
              );
            }

            Widget buildMiddleCard() {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _panelDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.statistics,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow(
                          l10n.breakouts,
                          '${_stats?.breakoutCount ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.murders,
                          '${_stats?.killCount ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.hitlistContracts,
                          '${_stats?.hitsPlacedCount ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.carsStolen,
                          '${_stats?.vehicleThieves ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.boatsStolen,
                          '${_stats?.boatThieves ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.crimeAttempts,
                          '${_stats?.crimeAttempts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.successful,
                          '${_stats?.successfulCrimes ?? 0}',
                          Colors.green.shade300,
                        ),
                        _buildInfoRow(
                          l10n.jobAttempts,
                          '${_stats?.jobAttempts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.streetProstitutes,
                          '${_stats?.streetProstitutes ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.rldProstitutes,
                          '${_stats?.redLightProstitutes ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.dashboardInfoDrugsGrams,
                          '${_stats?.drugsTotalQuantity ?? 0}g',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.dashboardInfoNightclubs,
                          '${_stats?.nightclubVenues ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.dashboardInfoNightclubRevenue,
                          '€${_stats?.nightclubRevenueAllTime ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.travels,
                          '${_stats?.travelCount ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.bullets,
                          '${_stats?.totalAmmo ?? 0}',
                          Colors.white,
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          l10n.dashboardEconomy24h,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          l10n.dashboardGrossIncome,
                          formatCurrency(_stats?.economy24h?.grossIncome ?? 0),
                          Colors.green.shade300,
                        ),
                        _buildInfoRow(
                          l10n.dashboardPropertySpend,
                          formatCurrency(_stats?.economy24h?.propertySpend ?? 0),
                          Colors.orange.shade300,
                        ),
                        _buildInfoRow(
                          l10n.dashboardNetCashflow,
                          formatCurrency(_stats?.economy24h?.netCashflow ?? 0),
                          (_stats?.economy24h?.netCashflow ?? 0) >= 0
                              ? Colors.green.shade300
                              : Colors.red.shade300,
                        ),
                        _buildInfoRow(
                          l10n.dashboardTrendVsPrevious,
                          '${_stats?.economy24h?.trendVsPreviousPct ?? 0}%',
                          (_stats?.economy24h?.trendVsPreviousPct ?? 0) >= 0
                              ? Colors.green.shade300
                              : Colors.red.shade300,
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          l10n.dashboardActivity7d,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          l10n.crimes,
                          '${_stats?.activity7d?.crimeAttempts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.jobs,
                          '${_stats?.activity7d?.jobAttempts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.dashboardVehicleThefts,
                          '${_stats?.activity7d?.vehicleThefts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          l10n.travels,
                          '${_stats?.activity7d?.travels ?? 0}',
                          Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _panelDecoration(accent: Colors.blueGrey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDetailedProgressBar(
                          _rankProgressLabel(context, player.rank),
                          rankProgress,
                          '${(rankProgress * 100).toStringAsFixed(0)}%',
                          Colors.amber.shade700,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailedProgressBar(
                          l10n.health,
                          player.health / 100,
                          '${player.health}%',
                          player.health > 50
                              ? Colors.green
                              : (player.health > 25
                                    ? Colors.orange
                                    : Colors.red),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailedProgressBar(
                          _killProgressLabel(context),
                          0.0,
                          '0%',
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget buildRightCard() {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: _panelDecoration(accent: Colors.deepOrange),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.dashboardTimeouts,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.dashboardOpsOverview,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      l10n.dashboardActiveCooldowns,
                      '${_stats?.operations?.activeCooldownCount ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardLongestTimer,
                      _formatCooldown(_stats?.operations?.longestCooldownSeconds ?? 0),
                      Colors.orange.shade300,
                    ),
                    _buildInfoRow(
                      l10n.dashboardActiveProduction,
                      '${_stats?.operations?.activeDrugProductionsCount ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardProductionReadyIn,
                      _formatCooldown(
                        _stats?.operations?.nextDrugProductionEndsInSeconds ?? 0,
                      ),
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardNightclubEvents,
                      '${_stats?.operations?.activeNightclubEventsCount ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardNextEventStartsIn,
                      _formatCooldown(
                        _stats?.operations?.nextNightclubEventStartsInSeconds ?? 0,
                      ),
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardVehiclesActiveListedTransit,
                      '${_stats?.operations?.activeVehicleCount ?? 0}/${_stats?.operations?.listedVehicleCount ?? 0}/${_stats?.operations?.inTransitVehicleCount ?? 0}',
                      Colors.white,
                    ),
                    if (_gameEventsActive.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        l10n.dashboardLivePlayerEvents,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._gameEventsActive.take(3).map(
                        (e) {
                          final template = e['template'] is Map
                              ? Map<String, dynamic>.from(
                                  e['template'] as Map,
                                )
                              : null;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '• ${localizedGameEventTitle(l10n, template)}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EventsScreen(),
                            ),
                          );
                        },
                        child: Text(
                          l10n.dashboardOpenEvents,
                          style: const TextStyle(color: Colors.orangeAccent),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      l10n.dashboardNotificationsAndRisk,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      l10n.dashboardUnreadDm,
                      '${_stats?.notifications?.unreadDirectMessages ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardSupportWaitingOnYou,
                      '${_stats?.notifications?.supportNeedsReply ?? 0}',
                      (_stats?.notifications?.supportNeedsReply ?? 0) > 0
                          ? Colors.orange.shade300
                          : Colors.green.shade300,
                    ),
                    _buildInfoRow(
                      l10n.dashboardEventsLast24h,
                      '${_stats?.notifications?.eventsLast24h ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardRiskScore,
                      '${_stats?.risk?.score ?? 0}/100',
                      (_stats?.risk?.score ?? 0) >= 70
                          ? Colors.red.shade300
                          : (_stats?.risk?.score ?? 0) >= 40
                                ? Colors.orange.shade300
                                : Colors.green.shade300,
                    ),
                    _buildCooldownRow(l10n.dashboardTimeoutCrime, 'crime'),
                    _buildCooldownRow(l10n.dashboardTimeoutJob, 'job'),
                    _buildCooldownRow(l10n.dashboardTimeoutTravel, 'travel'),
                    _buildCooldownRow(
                      l10n.dashboardTimeoutVehicleTheft,
                      'vehicle_theft',
                    ),
                    _buildCooldownRow(
                      l10n.dashboardTimeoutBoatTheft,
                      'boat_theft',
                    ),
                    _buildCooldownRow(
                      l10n.dashboardTimeoutNightclubSeason,
                      'nightclub',
                    ),
                    _buildCooldownRow(l10n.dashboardTimeoutAmmo, 'ammo'),
                    _buildCooldownRow(
                      l10n.dashboardTimeoutShootingRange,
                      'shooting_range',
                    ),
                    _buildCooldownRow(l10n.dashboardTimeoutGym, 'gym'),
                    _buildCooldownRow(l10n.hospital, 'hospital'),
                    _buildCooldownRow(
                      l10n.dashboardRecruitProstitute,
                      'prostitute_recruit',
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),
                    _buildVehicleOpsDashboardSection(),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      l10n.jail,
                      _stats != null && _stats!.jailed
                          ? l10n.dashboardJailStatusIn(
                              _formatCooldown(_stats!.jailTimeRemaining),
                            )
                          : l10n.free,
                      _stats != null && _stats!.jailed
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      l10n.dashboardCrewWars,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      l10n.dashboardStatusLabel,
                      _formatCrewWarDashboardStatus(l10n, _stats?.crewWar?.status),
                      _stats?.crewWar?.hasActiveWar == true
                          ? Colors.orange.shade300
                          : Colors.grey.shade400,
                    ),
                    _buildInfoRow(
                      l10n.dashboardCanDeclare,
                      _stats?.crewWar?.canDeclare == true
                          ? l10n.yes
                          : l10n.no,
                      _stats?.crewWar?.canDeclare == true
                          ? Colors.green.shade300
                          : Colors.grey.shade400,
                    ),
                    if ((_stats?.crewWar?.warType ?? '').isNotEmpty)
                      _buildInfoRow(
                        l10n.dashboardTypeLabel,
                        _formatCrewWarDashboardType(l10n, _stats?.crewWar?.warType),
                        Colors.white,
                      ),
                    if ((_stats?.crewWar?.opponentCrewName ?? '').isNotEmpty)
                      _buildInfoRow(
                        l10n.dashboardOpponent,
                        _stats!.crewWar!.opponentCrewName!,
                        Colors.white,
                      ),
                    _buildInfoRow(
                      l10n.dashboardCrewPoints,
                      '${_stats?.crewWar?.myCrewPoints ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardWarRank,
                      _stats?.crewWar?.myCrewRank?.toString() ?? '-',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardSeasonRank,
                      _stats?.crewWar?.seasonRank?.toString() ?? '-',
                      Colors.white,
                    ),
                    _buildInfoRow(
                      l10n.dashboardOpenTargets,
                      '${_stats?.crewWar?.availableTargetsCount ?? 0}',
                      Colors.white,
                    ),
                    if ((_stats?.crewWar?.phaseEndsInSeconds ?? 0) > 0)
                      _buildInfoRow(
                        l10n.dashboardPhaseEndsIn,
                        _formatCooldown(_stats!.crewWar!.phaseEndsInSeconds),
                        Colors.orange.shade300,
                      ),
                    if ((_stats?.crewWar?.theaterRegionKey ?? '').isNotEmpty)
                      _buildInfoRow(
                        l10n.dashboardWarTheater,
                        _stats!.crewWar!.theaterRegionKey!,
                        Colors.white,
                      ),
                    if ((_stats?.crewWar?.hotRegionKeys.isNotEmpty ?? false))
                      _buildInfoRow(
                        l10n.dashboardHotRegions,
                        _stats!.crewWar!.hotRegionKeys.take(3).join(', '),
                        Colors.orange.shade200,
                      ),
                    if (_stats?.territoryLeaderStats != null) ...[
                      const SizedBox(height: 12),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        l10n.dashboardCrewTerritory,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        l10n.dashboardRegions,
                        '${_stats!.territoryLeaderStats!.regionsOwned}',
                        Colors.white,
                      ),
                      _buildInfoRow(
                        l10n.dashboardCountriesCaptured,
                        '${_stats!.territoryLeaderStats!.countriesOwned}',
                        Colors.white,
                      ),
                      _buildInfoRow(
                        l10n.dashboardPayout,
                        '${formatCurrency(_stats!.territoryLeaderStats!.passiveIncomePerInterval)} · ${_territoryIncomeIntervalLabel(l10n, _stats!.territoryLeaderStats!.incomeIntervalMinutes)}',
                        Colors.green.shade300,
                      ),
                      _buildInfoRow(
                        l10n.dashboardEarningPerHour,
                        formatCurrency(
                          _stats!.territoryLeaderStats!.passiveIncomePerHour,
                        ),
                        Colors.green.shade300,
                      ),
                      _buildInfoRow(
                        l10n.dashboardEarningPerDay,
                        formatCurrency(
                          _stats!.territoryLeaderStats!.passiveIncomePerDay,
                        ),
                        Colors.green.shade300,
                      ),
                      _buildInfoRow(
                        l10n.dashboardTotalEarned,
                        formatCurrency(
                          _stats!
                              .territoryLeaderStats!
                              .totalPassiveIncomeEarned,
                        ),
                        Colors.amber.shade300,
                      ),
                      _buildInfoRow(
                        l10n.crewBank,
                        formatCurrency(
                          _stats!.territoryLeaderStats!.crewBankBalance,
                        ),
                        Colors.white,
                      ),
                    ],
                    if (_stats?.territoryDrama?.hasContent == true) ...[
                      const SizedBox(height: 12),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 12),
                      Text(
                        l10n.territoryDramaTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_stats!.territoryDrama!.hottestContestLines.isNotEmpty)
                        _buildInfoRow(
                          l10n.territoryDramaHotContests,
                          _stats!.territoryDrama!.hottestContestLines.join(' · '),
                          Colors.orange.shade200,
                        ),
                      if (_stats!.territoryDrama!.recentCaptureLines.isNotEmpty)
                        _buildInfoRow(
                          l10n.territoryDramaRecentCaptures,
                          _stats!.territoryDrama!.recentCaptureLines.join(' · '),
                          Colors.lightGreen.shade200,
                        ),
                      if (_stats!.territoryDrama!.risingCrewLines.isNotEmpty)
                        _buildInfoRow(
                          l10n.territoryDramaRisingCrews,
                          _stats!.territoryDrama!.risingCrewLines.join(' · '),
                          Colors.cyan.shade200,
                        ),
                      if (_stats!.territoryDrama!.warTheaterLines.isNotEmpty)
                        _buildInfoRow(
                          l10n.territoryDramaWarTheaters,
                          _stats!.territoryDrama!.warTheaterLines.join(' · '),
                          Colors.red.shade200,
                        ),
                      if (_stats!.territoryDrama!.regionEventLines.isNotEmpty)
                        _buildInfoRow(
                          l10n.territoryDramaRegionEvents,
                          _stats!.territoryDrama!.regionEventLines.join(' · '),
                          Colors.purple.shade200,
                        ),
                    ],
                  ],
                ),
              );
            }

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildLeftCard(),
                      if (dailyGoalsCard is! SizedBox) ...[
                        const SizedBox(height: 16),
                        dailyGoalsCard,
                      ],
                      if (weeklyGoalsCard is! SizedBox) ...[
                        const SizedBox(height: 16),
                        weeklyGoalsCard,
                      ],
                      const SizedBox(height: 16),
                      buildMiddleCard(),
                      const SizedBox(height: 16),
                      buildRightCard(),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              buildLeftCard(),
                              if (dailyGoalsCard is! SizedBox) ...[
                                const SizedBox(height: 16),
                                dailyGoalsCard,
                              ],
                              if (weeklyGoalsCard is! SizedBox) ...[
                                const SizedBox(height: 16),
                                weeklyGoalsCard,
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: buildMiddleCard()),
                        const SizedBox(width: 16),
                        Expanded(flex: 2, child: buildRightCard()),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCooldownRow(String label, String actionType) {
    final cooldown = _stats?.getCooldownSeconds(actionType) ?? 0;
    final canDo = cooldown == 0;
    final displayText = _formatCooldown(cooldown);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Text(
            displayText,
            style: TextStyle(
              color: canDo ? Colors.green.shade300 : Colors.orange.shade300,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleOpsDashboardSection() {
    final l10n = AppLocalizations.of(context)!;
    final vehicleOps = _stats?.vehicleOps;
    final roleLabel = (vehicleOps?.crewRole ?? '').toLowerCase();
    final crewRole = roleLabel.isEmpty
        ? '-'
        : switch (roleLabel) {
            'leader' => l10n.crewRoleLeader,
            'co_leader' => l10n.crewRoleCoLeader,
            'member' => l10n.crewRoleMember,
            _ => roleLabel,
          };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.dashboardVehicleOps,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        _buildVehicleOpsCategoryCard(
          title: l10n.dashboardCar,
          category: vehicleOps?.car,
          accent: const Color(0xFF4FC3F7),
        ),
        const SizedBox(height: 8),
        _buildVehicleOpsCategoryCard(
          title: l10n.dashboardMotorcycle,
          category: vehicleOps?.motorcycle,
          accent: const Color(0xFFFFB74D),
        ),
        const SizedBox(height: 8),
        _buildVehicleOpsCategoryCard(
          title: l10n.dashboardBoat,
          category: vehicleOps?.boat,
          accent: const Color(0xFF4DD0A6),
        ),
        const SizedBox(height: 10),
        _buildInfoRow(
          l10n.dashboardCrewAccess,
          vehicleOps?.hasCrew == true ? l10n.yes : l10n.no,
          vehicleOps?.hasCrew == true
              ? Colors.green.shade300
              : Colors.orange.shade300,
        ),
        _buildInfoRow(l10n.dashboardCrewRole, crewRole, Colors.white),
      ],
    );
  }

  Widget _buildVehicleOpsCategoryCard({
    required String title,
    required VehicleOpsCategoryDashboardSummary? category,
    required Color accent,
  }) {
    final l10n = AppLocalizations.of(context)!;
    if (category == null) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.22),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          '$title: ${l10n.dashboardUnavailable}',
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    final trendLabel = switch (category.partsTrend.toLowerCase()) {
      'up' => l10n.vehicleOpsPartsTrendUp,
      'down' => l10n.vehicleOpsPartsTrendDown,
      _ => l10n.vehicleOpsPartsTrendStable,
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              Text(
                '${l10n.vehicleOpsHeat} ${category.heatCurrent} (${_localizedVehicleOpsHeatLevel(l10n, category.heatLevel)})',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${l10n.vehicleOpsReputation} L${category.reputationLevel} (${category.reputationValue})',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                trendLabel,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _buildVehicleOpsCooldownChip(
                l10n.vehicleOpsHotspot,
                category.cooldowns['hotspot'] ?? 0,
              ),
              _buildVehicleOpsCooldownChip(
                l10n.vehicleOpsCrew,
                category.cooldowns['crew'] ?? 0,
              ),
              _buildVehicleOpsCooldownChip(
                l10n.vehicleOpsCrewMatch,
                category.cooldowns['crewMatch'] ?? 0,
              ),
              _buildVehicleOpsCooldownChip(
                l10n.vehicleOpsChop,
                category.cooldowns['chop'] ?? 0,
              ),
              _buildVehicleOpsCooldownChip(
                l10n.vehicleOpsContract,
                category.cooldowns['contract'] ?? 0,
              ),
              _buildVehicleOpsCooldownChip(
                l10n.vehicleOpsCounter,
                category.cooldowns['counter'] ?? 0,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              Text(
                '${l10n.vehicleOpsContracts}: ${category.contractsAvailable}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${l10n.vehicleOpsClaims}: ${category.openInsuranceClaims}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${l10n.vehicleOpsSeason}: ${category.seasonPoints}p (${category.seasonWins}W/${category.seasonLosses}L)',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                category.blacklistActive
                    ? l10n.vehicleOpsBlacklistActive
                    : l10n.vehicleOpsNoBlacklist,
                style: TextStyle(
                  color: category.blacklistActive
                      ? Colors.red.shade300
                      : Colors.green.shade300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleOpsCooldownChip(String label, int cooldownSeconds) {
    final ready = cooldownSeconds <= 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ready
            ? Colors.green.withOpacity(0.14)
            : Colors.orange.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: ready
              ? Colors.green.withOpacity(0.65)
              : Colors.orange.withOpacity(0.65),
        ),
      ),
      child: Text(
        '$label ${_formatCooldown(cooldownSeconds)}',
        style: TextStyle(
          color: ready ? Colors.green.shade200 : Colors.orange.shade200,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatCrewWarDashboardStatus(AppLocalizations l10n, String? status) {
    switch (status) {
      case 'preparing':
        return l10n.dashboardCrewWarStatusPreparing;
      case 'active':
        return l10n.dashboardCrewWarStatusActive;
      case 'lockdown':
        return l10n.dashboardCrewWarStatusLockdown;
      case 'resolved':
        return l10n.dashboardCrewWarStatusResolved;
      case 'archived':
        return l10n.dashboardCrewWarStatusArchived;
      case 'cancelled':
        return l10n.dashboardCrewWarStatusCancelled;
      default:
        return l10n.dashboardCrewWarStatusNone;
    }
  }

  String _formatCrewWarDashboardType(AppLocalizations l10n, String? warType) {
    switch (warType) {
      case 'kill_war':
        return l10n.dashboardCrewWarTypeKill;
      case 'economy_war':
        return l10n.dashboardCrewWarTypeEconomy;
      case 'territory_war':
        return l10n.dashboardCrewWarTypeTerritory;
      case 'total_war':
        return l10n.dashboardCrewWarTypeTotal;
      default:
        return l10n.dashboardCrewWarTypeUnknown;
    }
  }

  String _territoryIncomeIntervalLabel(AppLocalizations l10n, int minutes) {
    if (minutes <= 0) {
      return l10n.dashboardTerritoryIncomeNotConfigured;
    }
    if (minutes % 60 != 0) {
      return l10n.dashboardTerritoryIncomeEveryMinutes(minutes);
    }
    final hours = minutes ~/ 60;
    return l10n.dashboardTerritoryIncomeEveryHours(hours);
  }

  Widget _buildDetailedProgressBar(
    String label,
    double progress,
    String valueText,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              valueText,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 24,
            backgroundColor: Colors.white.withOpacity(0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  String _getRankTitle(AppLocalizations l10n, int rank) {
    if (rank <= 5) return l10n.rankBeginner;
    if (rank <= 10) return l10n.rankCriminal;
    if (rank <= 15) return l10n.rankGangster;
    if (rank <= 20) return l10n.rankMafioso;
    return l10n.rankGodfather;
  }

  String _getMoneyStatus(AppLocalizations l10n, int money) {
    if (money < 10000) return l10n.moneyStatusPoor;
    if (money < 100000) return l10n.moneyStatusRising;
    if (money < 1000000) return l10n.moneyStatusRich;
    return l10n.moneyStatusMultimillionaire;
  }
}

/// Helper function to calculate total XP required for a specific rank
/// Mirrors backend logic in backend/src/config/index.ts
int _getXPForRank(int targetRank) {
  if (targetRank <= 1) {
    return 0;
  }

  const int xpBasePerRank = 1000;
  const double xpGrowthEarly = 0.07;
  const double xpGrowthMid = 0.05;
  const double xpGrowthLate = 0.035;

  double xpForNextRank = xpBasePerRank.toDouble();
  int totalXP = 0;

  for (int rank = 1; rank < targetRank; rank++) {
    totalXP += xpForNextRank.ceil();

    final growthRate = rank <= 60
        ? xpGrowthEarly
        : rank <= 150
        ? xpGrowthMid
        : xpGrowthLate;
    xpForNextRank = (xpForNextRank * (1 + growthRate)).ceilToDouble();
  }

  return totalXP;
}

/// Custom widget showing rank and XP progress in a beautiful progress bar
class _RankProgressBar extends StatelessWidget {
  final int rank;
  final int currentXP;

  const _RankProgressBar({required this.rank, required this.currentXP});

  @override
  Widget build(BuildContext context) {
    final xpForCurrentRank = _getXPForRank(rank);
    final xpForNextRank = _getXPForRank(rank + 1);
    final xpNeededForNextRank = xpForNextRank - xpForCurrentRank;
    final xpProgressInCurrentRank = currentXP - xpForCurrentRank;
    final progress = (xpProgressInCurrentRank / xpNeededForNextRank).clamp(
      0.0,
      1.0,
    );

    return Row(
      children: [
        // Rank badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber.shade700, Colors.amber.shade400],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Progress bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '$xpProgressInCurrentRank / $xpNeededForNextRank XP',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.amber.shade600, Colors.amber.shade400],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.4),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
