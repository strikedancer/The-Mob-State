import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
// FontAwesome replaced with Material Icons
import '../l10n/app_localizations.dart';
import '../models/player.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../utils/country_helper.dart';
import '../utils/formatters.dart';
import '../widgets/event_feed.dart';
import '../widgets/icu_overlay.dart';
import 'crime_screen.dart';
import 'jobs_screen.dart';
import 'travel_screen.dart';
import 'crew_screen.dart';
import 'friends_screen.dart';
import 'inventory_screen.dart';
import 'property_screen.dart';
import 'casino_screen.dart';
import 'black_market_screen.dart';
import 'trade_screen.dart';
import 'court_screen.dart';
import 'hospital_screen.dart';
import 'vehicle_heist_screen.dart';
import 'tune_shop_screen.dart';
import 'direct_messages_screen.dart';
import 'tools_screen.dart';
import 'hitlist_screen.dart';
import 'security_screen.dart';
import 'shooting_range_screen.dart';
import 'gym_screen.dart';
import 'ammo_factory_screen.dart';
import 'school_screen.dart';
import 'prostitution_screen.dart';
import 'red_light_districts_screen.dart';
import 'bank_screen.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';
import 'prison_screen.dart';
import 'drug_environment_screen.dart';
import 'smuggling_screen.dart';
import 'nightclub_screen.dart';
import 'crypto_screen.dart';
import 'events_screen.dart';
import 'help_screen.dart';

enum _WebSection {
  dashboard,
  events,
  crimes,
  jobs,
  messages,
  help,
  settings,
  travel,
  crew,
  friends,
  inventory,
  properties,
  bank,
  casino,
  trade,
  blackMarket,
  drugs,
  nightclub,
  crypto,
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
  shootingRange,
  gym,
  ammoFactory,
  school,
  prostitution,
  redLightDistricts,
  achievements,
}

String _rankProgressLabel(BuildContext context, int rank) {
  final l10n = AppLocalizations.of(context)!;
  final baseLabel = l10n.localeName == 'nl' ? 'Rankvordering' : 'Rank Progress';
  return '$baseLabel (${l10n.rank} $rank)';
}

String _cashLabel(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.localeName == 'nl' ? 'Contant' : 'Cash';
}

String _newMessagesLabel(BuildContext context, int count) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.localeName == 'nl'
      ? '$count nieuwe berichten'
      : '$count new messages';
}

String _killProgressLabel(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return l10n.localeName == 'nl' ? 'Moordvordering' : 'Kill Progress';
}

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
  StreamSubscription? _eventSubscription;
  Timer? _playerRefreshTimer;
  bool _checkedPremiumPopup = false;
  _WebSection _selectedWebSection = _WebSection.dashboard;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;
  int _vehicleHeistTabIndex = 0;

  void _openVehicleHeist([int initialTabIndex = 0]) {
    setState(() {
      _vehicleHeistTabIndex = initialTabIndex;
      _selectedWebSection = _WebSection.vehicleHeist;
    });
  }

  @override
  void initState() {
    super.initState();
    // Connect to event stream when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      eventProvider.connect();
      _loadUnreadCount();
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
    });
  }

  void _setupSSEListener() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final eventStreamService = eventProvider.eventStreamService;

    _eventSubscription = eventStreamService.eventStream.listen((event) {
      if (event['event'] == 'direct_message.received' ||
          event['event'] == 'direct_message.deleted' ||
          event['event'] == 'direct_message.read') {
        _loadUnreadCount();
      }
    });
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

  Future<void> _checkPremiumPopupOnOpen() async {
    if (_checkedPremiumPopup || !mounted) return;
    _checkedPremiumPopup = true;

    try {
      final locale = Localizations.localeOf(context).languageCode;
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get(
        '/subscriptions/checkout/one-time/popup?locale=$locale',
      );

      if (response.statusCode != 200 || response.body.isEmpty || !mounted)
        return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final popup = data['popup'] as Map<String, dynamic>?;
      if (popup == null) return;

      final productKey = (popup['key'] ?? '').toString();
      final title = (popup['title'] ?? 'Special offer').toString();
      final price = (popup['priceEur'] ?? '0.00').toString();
      final reward = (popup['reward'] ?? '').toString();
      final imageUrl = (popup['imageUrl'] ?? '').toString();

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
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
              child: Text(_tr('Sluiten', 'Close')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                if (kIsWeb) {
                  setState(() => _selectedWebSection = _WebSection.crew);
                } else {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const CrewScreen()));
                }
              },
              child: Text(_tr('Bekijk aanbieding', 'View offer')),
            ),
          ],
        ),
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
              color: Theme.of(context).colorScheme.surface,
              border: Border(bottom: BorderSide(color: Colors.amber[600]!)),
            ),
            child: Row(
              children: [
                if (!showLeftSidebar)
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    tooltip: 'Menu',
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
                        'The Mob State',
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
                    tooltip: 'Quick Actions',
                  ),
                PopupMenuButton<String>(
                  tooltip: 'Account',
                  onSelected: (value) async {
                    switch (value) {
                      case 'messages':
                        setState(
                          () => _selectedWebSection = _WebSection.messages,
                        );
                        break;
                      case 'help':
                        if (kIsWeb) {
                          setState(
                            () => _selectedWebSection = _WebSection.help,
                          );
                        } else if (context.mounted) {
                          Navigator.of(context).pushNamed('/help');
                        }
                        break;
                      case 'settings':
                        if (kIsWeb) {
                          setState(
                            () => _selectedWebSection = _WebSection.settings,
                          );
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
                          Text(_tr('Berichten', 'Messages')),
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
                          Text(_tr('Help & Uitleg', 'Help & Guide')),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          const Icon(Icons.settings, size: 20),
                          const SizedBox(width: 12),
                          Text(_tr('Instellingen', 'Settings')),
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
                            _tr('Uitloggen', 'Log out'),
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
                          child: Image.network(
                            'images/avatars/${player.avatar ?? 'default_1'}.png',
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
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        right: BorderSide(color: Colors.amber[600]!),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildWebContent(context),
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
                      color: Theme.of(context).colorScheme.surface,
                      border: Border(
                        left: BorderSide(color: Colors.amber[600]!),
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
            icon: Icons.menu_book,
            label: _tr('Help & Uitleg', 'Help & Guide'),
            section: _WebSection.help,
            badge: 0,
          ),
          (
            icon: Icons.event,
            label: _tr('Events', 'Events'),
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
            icon: Icons.groups,
            label: l10n.crew,
            section: _WebSection.crew,
            badge: 0,
          ),
          (
            icon: Icons.group,
            label: l10n.friends,
            section: _WebSection.friends,
            badge: _unreadCount,
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
            label: 'Bank',
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
            icon: Icons.work,
            label: 'Handelswaar',
            section: _WebSection.trade,
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
            label: 'Drugs',
            section: _WebSection.drugs,
            badge: 0,
          ),
          (
            icon: Icons.nightlife,
            label: _tr('Nachtclub', 'Nightclub'),
            section: _WebSection.nightclub,
            badge: 0,
          ),
          (
            icon: Icons.currency_bitcoin,
            label: _tr('Crypto', 'Crypto'),
            section: _WebSection.crypto,
            badge: 0,
          ),
          (
            icon: Icons.local_shipping,
            label: _tr('Smokkelen', 'Smuggling'),
            section: _WebSection.smuggling,
            badge: 0,
          ),
          (
            icon: Icons.build,
            label: 'Gereedschap',
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
            label: _tr('Voertuig Stelen', 'Vehicle Heist'),
            section: _WebSection.vehicleHeist,
            badge: 0,
          ),
          (
            icon: Icons.tune,
            label: _tr('TuneShop', 'Tune Shop'),
            section: _WebSection.tuneShop,
            badge: 0,
          ),
          (
            icon: Icons.gps_fixed,
            label: l10n.shootingRange,
            section: _WebSection.shootingRange,
            badge: 0,
          ),
          (
            icon: Icons.fitness_center,
            label: l10n.gym,
            section: _WebSection.gym,
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
            label: 'Prestaties',
            section: _WebSection.achievements,
            badge: 0,
          ),
        ];

    return items
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ListTile(
              selected: _selectedWebSection == item.section,
              leading: Icon(item.icon),
              title: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                setState(() => _selectedWebSection = item.section);
              },
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
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _buildActionCard(
                context,
                icon: Icons.warning,
                title: 'Misdaden',
                subtitle: 'Pleeg criminele acties',
                color: Colors.red.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.crimes),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.directions_car_filled,
                title: _tr('Voertuig Stelen', 'Vehicle Heist'),
                subtitle: _tr(
                  'Auto, motor en boot',
                  'Car, motorcycle and boat',
                ),
                color: Colors.orange.shade700,
                onTap: () => _openVehicleHeist(0),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.tune,
                title: _tr('TuneShop', 'Tune Shop'),
                subtitle: _tr('Onderdelen en upgrades', 'Parts and upgrades'),
                color: Colors.purple.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.tuneShop),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.event,
                title: _tr('Events', 'Events'),
                subtitle: _tr(
                  'Actieve en aankomende events',
                  'Active and upcoming events',
                ),
                color: Colors.teal.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.events),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.work,
                title: 'Werk',
                subtitle: 'Verdien legaal geld',
                color: Colors.green.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.jobs),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.casino,
                title: 'Casino',
                subtitle: 'Gok je geld',
                color: Colors.purple.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.casino),
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                context,
                icon: Icons.account_balance,
                title: 'Bank',
                subtitle: 'Beheer je globale saldo',
                color: Colors.indigo.shade700,
                onTap: () =>
                    setState(() => _selectedWebSection = _WebSection.bank),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
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
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
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
                    errorBuilder: (context, error, stackTrace) => const Text(
                      'The Mob State',
                      style: TextStyle(
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
                          title: Text(_tr('Misdaden', 'Crimes')),
                          subtitle: Text(
                            _tr(
                              'Pleeg criminele acties',
                              'Commit criminal actions',
                            ),
                          ),
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
                          title: Text(_tr('Voertuig Stelen', 'Vehicle Heist')),
                          subtitle: Text(
                            _tr(
                              'Auto, motor en boot',
                              'Car, motorcycle and boat',
                            ),
                          ),
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
                          title: Text(_tr('Events', 'Events')),
                          subtitle: Text(
                            _tr(
                              'Actieve en aankomende events',
                              'Active and upcoming events',
                            ),
                          ),
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
                          title: Text(_tr('Werk', 'Work')),
                          subtitle: Text(
                            _tr('Verdien legaal geld', 'Earn legal money'),
                          ),
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
                          title: const Text('Casino'),
                          subtitle: Text(
                            _tr('Gok je geld', 'Gamble your money'),
                          ),
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
                          title: const Text('Bank'),
                          subtitle: Text(
                            _tr(
                              'Beheer je globale saldo',
                              'Manage your global balance',
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            setState(
                              () => _selectedWebSection = _WebSection.bank,
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
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
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
                      _getRankTitle(player.rank),
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
                  'Wanted',
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
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
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
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade700,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  String _getRankTitle(int rank) {
    if (rank <= 5) return 'Beginner';
    if (rank <= 10) return 'Crimineel';
    if (rank <= 15) return 'Gangster';
    if (rank <= 20) return 'Mafioso';
    return 'Godfather';
  }

  Widget _buildWebContent(BuildContext context) {
    switch (_selectedWebSection) {
      case _WebSection.dashboard:
        return const _WebDashboardHomeContent();
      case _WebSection.events:
        return const EventsScreen();
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
      case _WebSection.crew:
        return const CrewScreen();
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
      case _WebSection.trade:
        return const TradeScreen();
      case _WebSection.blackMarket:
        return const BlackMarketScreen();
      case _WebSection.drugs:
        return const DrugEnvironmentScreen();
      case _WebSection.nightclub:
        return const NightclubScreen();
      case _WebSection.crypto:
        return const CryptoScreen();
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
      case _WebSection.shootingRange:
        return ShootingRangeScreen();
      case _WebSection.gym:
        return GymScreen();
      case _WebSection.ammoFactory:
        return const AmmoFactoryScreen();
      case _WebSection.school:
        return const SchoolScreen();
      case _WebSection.prostitution:
        return const ProstitutionScreen();
      case _WebSection.redLightDistricts:
        return const RedLightDistrictsScreen();
      case _WebSection.achievements:
        return const AchievementsScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: kIsWeb
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
                  tooltip: _tr('Berichten', 'Messages'),
                ),
                IconButton(
                  icon: const Icon(Icons.backpack),
                  onPressed: () => Navigator.pushNamed(context, '/inventory'),
                  tooltip: l10n.inventory,
                ),
                IconButton(
                  icon: const Icon(Icons.menu_book),
                  onPressed: () => Navigator.of(context).pushNamed('/help'),
                  tooltip: _tr('Help & Uitleg', 'Help & Guide'),
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

          if (kIsWeb) {
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
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 32,
                              child: ClipOval(
                                child: Image.asset(
                                  'images/avatars/${player.avatar ?? 'default_1'}.png',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    final avatar = player.avatar ?? 'default_1';
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
                                    _unreadCount > 99 ? '99+' : '$_unreadCount',
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
                                  label: _tr('Events', 'Events'),
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
                                  label: 'Berichten',
                                  badge: _unreadCount,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const DirectMessagesScreen(),
                                    ),
                                  ).then((_) => _loadUnreadCount()),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.menu_book,
                                  label: _tr('Help & Uitleg', 'Help & Guide'),
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/help'),
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
                                  badge: _unreadCount,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FriendsScreen(),
                                    ),
                                  ).then((_) => _loadUnreadCount()),
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
                                  label: 'Bank',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const BankScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.shopping_bag,
                                  label: 'Handelswaar',
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TradeScreen(),
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
                                  label: 'Drugs',
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
                                  label: _tr('Nachtclub', 'Nightclub'),
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
                                  label: 'Gereedschap',
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
                                  label: _tr(
                                    'Voertuig Stelen',
                                    'Vehicle Heist',
                                  ),
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
                                  label: _tr('TuneShop', 'Tune Shop'),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const TuneShopScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.gps_fixed,
                                  label: l10n.shootingRange,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ShootingRangeScreen(),
                                    ),
                                  ),
                                ),
                                _buildMenuTile(
                                  context,
                                  icon: Icons.fitness_center,
                                  label: l10n.gym,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => GymScreen(),
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
                              'Live Events',
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
  Timer? _cooldownTimer;
  Timer? _refreshTimer;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadStats();

    // Update cooldowns every second
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _stats != null) {
        setState(() {
          // Decrement cooldowns
          _stats = DashboardStats(
            crimeAttempts: _stats!.crimeAttempts,
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
            weapons: _stats!.weapons,
            selectedWeaponName: _stats!.selectedWeaponName,
            activeVehicle: _stats!.activeVehicle,
            jailed: _stats!.jailTimeRemaining > 1,
            jailTimeRemaining: _stats!.jailTimeRemaining > 0
                ? _stats!.jailTimeRemaining - 1
                : 0,
            bankBalance: _stats!.bankBalance,
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
          lastEvent.eventKey == 'travel.arrive') {
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

  String _formatCooldown(int seconds) {
    return formatAdaptiveDurationFromSeconds(
      seconds,
      localeName: _isNl ? 'nl' : 'en',
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final player = authProvider.currentPlayer;
    final l10n = AppLocalizations.of(context)!;

    if (player == null) {
      return Center(child: Text(_tr('Geen speler data', 'No player data')));
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
        color: Colors.grey.shade900,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      color: Colors.grey.shade900,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Dashboard cards: stack vertically on tablet, 3-column layout on desktop
            final isCompact =
                constraints.maxWidth < _DashboardScreenState._tabletBreakpoint;

            Widget buildLeftCard() {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildInfoRow('Naam', player.username, Colors.white),
                    _buildInfoRow(
                      'Rank (${player.rank})',
                      _getRankTitle(player.rank),
                      Colors.amber.shade300,
                    ),
                    _buildInfoRow(
                      'Geldstatus',
                      _getMoneyStatus(player.money),
                      Colors.green.shade300,
                    ),
                    _buildInfoRow(
                      'Kogels',
                      '${_stats?.totalAmmo ?? 0}',
                      Colors.white,
                    ),
                    _buildInfoRow('XP', '${player.xp}', Colors.white),
                    _buildInfoRow('Clicks', '-', Colors.white),
                    _buildInfoRow(
                      'Land',
                      '${CountryHelper.getCountryFlag(player.currentCountry)} $countryName',
                      Colors.white,
                    ),
                    if (player.wantedLevel != null && player.wantedLevel! > 0)
                      _buildInfoRow(
                        'Wanted Level',
                        '${player.wantedLevel}',
                        Colors.red.shade300,
                      ),
                    if (player.fbiHeat != null && player.fbiHeat! > 0)
                      _buildInfoRow(
                        'FBI Heat',
                        '${player.fbiHeat}',
                        Colors.orange.shade300,
                      ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Contant',
                      '\$${player.money}',
                      Colors.green.shade300,
                    ),
                    _buildInfoRow(
                      'Bank',
                      '\$${_stats?.bankBalance ?? 0}',
                      Colors.white,
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Beveiliging',
                      'Geen beveiliging',
                      Colors.grey.shade400,
                    ),
                    _buildInfoRow(
                      'Wapen',
                      _stats?.selectedWeaponName != null
                          ? _stats!.selectedWeaponName!
                          : 'Geen',
                      _stats?.selectedWeaponName != null
                          ? Colors.green.shade300
                          : Colors.grey.shade400,
                    ),
                    _buildInfoRow(
                      'Voertuig',
                      _stats?.activeVehicle?.name ?? 'Geen',
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
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Statistieken',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Uitbraken', '0', Colors.white),
                        _buildInfoRow('Moorden', '0', Colors.white),
                        _buildInfoRow('Autoraces gewonnen', '0', Colors.white),
                        _buildInfoRow(
                          'Auto gestolen',
                          '${_stats?.vehicleThieves ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          'Boten gestolen',
                          '${_stats?.boatThieves ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          'Misdaadpogingen',
                          '${_stats?.crimeAttempts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          'Succesvol',
                          '${_stats?.successfulCrimes ?? 0}',
                          Colors.green.shade300,
                        ),
                        _buildInfoRow(
                          'Werk pogingen',
                          '${_stats?.jobAttempts ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          'Hoeren op straat',
                          '${_stats?.streetProstitutes ?? 0}',
                          Colors.white,
                        ),
                        _buildInfoRow(
                          'Hoeren in RLD',
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
                        _buildInfoRow('Reizen', '0', Colors.white),
                        _buildInfoRow('Kogels gekocht', '0', Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
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
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(8),
                ),
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
                    _buildCooldownRow('Hoeren werven', 'prostitute_recruit'),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Gevangenis',
                      _stats != null && _stats!.jailed
                          ? 'In cel (${_formatCooldown(_stats!.jailTimeRemaining)})'
                          : 'Vrij',
                      _stats != null && _stats!.jailed
                          ? Colors.red.shade300
                          : Colors.green.shade300,
                    ),
                  ],
                ),
              );
            }

            if (isCompact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildLeftCard(),
                  const SizedBox(height: 16),
                  buildMiddleCard(),
                  const SizedBox(height: 16),
                  buildRightCard(),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: buildLeftCard()),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: buildMiddleCard()),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: buildRightCard()),
              ],
            );
          },
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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 24,
            backgroundColor: Colors.grey.shade700,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  String _getRankTitle(int rank) {
    if (rank <= 5) return 'Beginner';
    if (rank <= 10) return 'Crimineel';
    if (rank <= 15) return 'Gangster';
    if (rank <= 20) return 'Mafioso';
    return 'Godfather';
  }

  String _getMoneyStatus(int money) {
    if (money < 10000) return 'Arm';
    if (money < 100000) return 'Opkomend';
    if (money < 1000000) return 'Rijk';
    return 'Multimiljonair';
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
