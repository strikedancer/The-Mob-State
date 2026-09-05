import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/auth_service.dart';
import '../models/friendship.dart';
import 'direct_messages_screen.dart';
import 'chat_screen.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../utils/avatar_helper.dart';
import '../l10n/app_localizations.dart';
import '../utils/country_helper.dart';
import 'player_profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../utils/top_right_notification.dart';
import '../widgets/responsive_modal.dart';
import '../widgets/mobile_load_error.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  static bool _friendTimeagoLocalesRegistered = false;

  late TabController _tabController;

  List<Friend> _friends = [];
  List<FriendRequest> _pendingRequests = [];
  List<PlayerSearchResult> _searchResults = [];
  List<dynamic> _activities = []; // For activity feed

  bool _loading = false;
  String? _friendsError;
  String? _activitiesError;
  bool _activitiesLoading = false;
  bool _activitiesInitialized =
      false; // Track if we've loaded activities at least once
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    _ensureFriendTimeagoLocales();
    _tabController = TabController(length: 4, vsync: this);
    _loadFriends();
    _loadPendingRequests();
    _loadUnreadCount();
    _listenToActivityEvents();
  }

  /// Registers timeago locales used on the activity tab (matches app supported languages).
  void _ensureFriendTimeagoLocales() {
    if (_friendTimeagoLocalesRegistered) return;
    _friendTimeagoLocalesRegistered = true;
    timeago.setLocaleMessages('nl', timeago.NlMessages());
    timeago.setLocaleMessages('de', timeago.DeMessages());
    timeago.setLocaleMessages('es', timeago.EsMessages());
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    timeago.setLocaleMessages('it', timeago.ItMessages());
    timeago.setLocaleMessages('pl', timeago.PlMessages());
    timeago.setLocaleMessages('pt_br', timeago.PtBrMessages());
  }

  String _timeagoLocale(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode.toLowerCase();
    if (code == 'pt') return 'pt_br';
    return code;
  }

  void _listenToActivityEvents() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.eventStreamService.eventStream.listen((event) {
      if (!mounted) return;
      if (event['event'] == 'player.activity') {
        _loadActivities();
      }
    });
  }

  void _openPlayerProfile(int playerId, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerProfileScreen(playerId: playerId, username: username),
      ),
    );
  }

  Future<void> _loadUnreadCount() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/messages/unread');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        setState(() {
          _unreadMessages = params['unreadCount'] as int? ?? 0;
        });
      }
    } catch (e) {
      print('Error loading unread count: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    setState(() {
      _loading = _friends.isEmpty;
      _friendsError = null;
    });
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/friends');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final friendsList = params['friends'] as List;
        setState(() {
          _friends = friendsList.map((f) => Friend.fromJson(f)).toList();
          _friendsError = null;
        });
      } else {
        throw Exception('error.internal');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _friendsError = AppLocalizations.of(context)!.connectionErrorGeneric;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadPendingRequests() async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/friends/pending');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final requestsList = params['requests'] as List;
        setState(() {
          _pendingRequests = requestsList
              .map((r) => FriendRequest.fromJson(r))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading pending requests: $e');
    }
  }

  Future<void> _searchPlayers(String query) async {
    print('🔍 [FriendsScreen] _searchPlayers called with query: "$query"');

    if (query.length < 2) {
      print('🔍 [FriendsScreen] Query too short, clearing results');
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _loading = true);
    try {
      final apiClient = AuthService().apiClient;
      final url = '/friends/search?q=$query';
      print('🔍 [FriendsScreen] Making API call to: $url');

      final response = await apiClient.get(url);
      print('🔍 [FriendsScreen] Response status: ${response.statusCode}');
      print('🔍 [FriendsScreen] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final resultsList = params['results'] as List;
        print('🔍 [FriendsScreen] Found ${resultsList.length} results');
        setState(() {
          _searchResults = resultsList
              .map((r) => PlayerSearchResult.fromJson(r))
              .toList();
        });
      }
    } catch (e) {
      print('❌ Error searching players: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _sendFriendRequest(int playerId) async {
    print(
      '🔵 [FriendsScreen] _sendFriendRequest called for playerId: $playerId',
    );
    try {
      final apiClient = AuthService().apiClient;
      print('🔵 [FriendsScreen] Making POST request to /friends/request');
      final response = await apiClient.post('/friends/request', {
        'addresseeId': playerId,
      });
      print('🔵 [FriendsScreen] Response status: ${response.statusCode}');
      print('🔵 [FriendsScreen] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ [FriendsScreen] Friend request sent successfully');
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.friendsUiSnackRequestSent),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          // Refresh search results
          print('🔵 [FriendsScreen] Refreshing search results...');
          await _searchPlayers(_searchQuery);
        }
      } else {
        print('❌ [FriendsScreen] Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [FriendsScreen] Error sending friend request: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.friendsUiSnackError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _acceptFriendRequest(int friendshipId) async {
    print(
      '🔵 [FriendsScreen] _acceptFriendRequest called for friendshipId: $friendshipId',
    );
    try {
      final apiClient = AuthService().apiClient;
      print(
        '🔵 [FriendsScreen] Making POST request to /friends/$friendshipId/accept',
      );
      final response = await apiClient.post(
        '/friends/$friendshipId/accept',
        {},
      );
      print('🔵 [FriendsScreen] Response status: ${response.statusCode}');
      print('🔵 [FriendsScreen] Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ [FriendsScreen] Friend request accepted successfully');
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.friendsUiSnackRequestAccepted),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          await _loadFriends();
          await _loadPendingRequests();
          // Also refresh search if we're in search tab
          if (_searchQuery.isNotEmpty) {
            await _searchPlayers(_searchQuery);
          }
        }
      } else {
        print(
          '❌ [FriendsScreen] Accept failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ [FriendsScreen] Exception accepting friend request: $e');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.friendsUiSnackError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectFriendRequest(int friendshipId) async {
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/friends/$friendshipId/reject',
        {},
      );

      if (response.statusCode == 200) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.friendsUiSnackRequestRejected),
              backgroundColor: Colors.orange,
            ),
          );
          _loadPendingRequests();
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.friendsUiSnackError(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeFriend(int friendshipId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dlgL10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(dlgL10n.propertiesConfirmPurchaseTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dlgL10n.friendsUiRemoveDialogTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(dlgL10n.friendsUiRemoveDialogBody),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dlgL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(dlgL10n.friendsUiRemoveConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final apiClient = AuthService().apiClient;
        final response = await apiClient.delete('/friends/$friendshipId');
        print('🔵 [FriendsScreen] Delete response: ${response.statusCode}');

        if (response.statusCode == 200) {
          print('✅ [FriendsScreen] Friend removed successfully');
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            showTopRightFromSnackBar(
              context,
              SnackBar(
                content: Text(l10n.friendsUiSnackFriendRemoved),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
            // Refresh all lists
            await _loadFriends();
            await _loadPendingRequests();
            // Refresh search results if we're on the search tab
            if (_tabController.index == 3 &&
                _searchController.text.isNotEmpty) {
              await _searchPlayers(_searchController.text);
            }
          }
        } else {
          print(
            '❌ [FriendsScreen] Delete failed with status ${response.statusCode}',
          );
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            showTopRightFromSnackBar(
              context,
              SnackBar(
                content: Text(
                  l10n.friendsUiSnackError(response.statusCode.toString()),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('❌ [FriendsScreen] Delete exception: $e');
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.friendsUiSnackError(e.toString())),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<void> _blockPlayer(int playerId, String username) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final dlgL10n = AppLocalizations.of(dialogContext)!;
        return AlertDialog(
          title: Text(dlgL10n.propertiesConfirmPurchaseTitle),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dlgL10n.friendsUiBlockDialogTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(dlgL10n.friendsUiBlockDialogBody(username)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dlgL10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(dlgL10n.friendsUiBlockButton),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final apiClient = AuthService().apiClient;
        final response = await apiClient.post('/friends/$playerId/block', {});

        if (response.statusCode == 200) {
          if (mounted) {
            final l10n = AppLocalizations.of(context)!;
            showTopRightFromSnackBar(
              context,
              SnackBar(
                content: Text(l10n.friendsUiSnackPlayerBlocked),
                backgroundColor: Colors.red,
              ),
            );
            _loadFriends();
          }
        }
      } catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.friendsUiSnackError(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.friends),
        actions: [
          // Messages button with badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DirectMessagesScreen(),
                    ),
                  ).then((_) => _loadUnreadCount());
                },
              ),
              if (_unreadMessages > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1F8B24),
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _unreadMessages > 99 ? '99+' : '$_unreadMessages',
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
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.friends),
            Tab(text: l10n.friendsUiTabActivity),
            Tab(
              text: l10n.friendsUiTabRequests,
              icon: _pendingRequests.isNotEmpty
                  ? Badge(
                      label: Text('${_pendingRequests.length}'),
                      child: const Icon(Icons.notifications),
                    )
                  : null,
            ),
            Tab(text: l10n.friendsUiTabSearch),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildFriendsTab(l10n),
          _buildActivityTab(l10n),
          _buildRequestsTab(l10n),
          _buildSearchTab(l10n),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(AppLocalizations l10n) {
    if (_loading && _friends.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_friendsError != null && _friends.isEmpty) {
      return MobileLoadError(
        message: _friendsError!,
        onRetry: _loadFriends,
      );
    }

    if (_friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.friendsUiEmptyListTitle,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.friendsUiEmptyListSubtitle,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFriends,
      child: ListView.builder(
        itemCount: _friends.length,
        itemBuilder: (context, index) {
          final friendData = _friends[index];
          final friend = friendData.friend;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => _openPlayerProfile(friend.id, friend.username),
                child: CircleAvatar(
                  backgroundImage:
                      friend.avatar != null && friend.avatar!.isNotEmpty
                        ? AvatarHelper.getAvatarImageProvider(
                            friend.avatar,
                            activePortraitPath: friend.activePortraitPath,
                          )
                      : null,
                  child: friend.avatar == null || friend.avatar!.isEmpty
                      ? Text(friend.username[0].toUpperCase())
                      : null,
                ),
              ),
              title: GestureDetector(
                onTap: () => _openPlayerProfile(friend.id, friend.username),
                child: Text(
                  friend.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.friendsUiLineRank('${friend.rank}')),
                  Text(
                    l10n.friendsUiLineLocation(
                      CountryHelper.getLocalizedCountryName(
                        friend.currentCountry,
                        l10n,
                      ),
                    ),
                  ),
                  Text(
                    l10n.friendsUiLineHealth('${friend.health}'),
                    style: TextStyle(
                      color: friend.health >= 75
                          ? Colors.green
                          : friend.health >= 50
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                  Text(
                    l10n.friendsUiLineFriendsSince(_formatDate(friendData.since)),
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFF1F8B24),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            friendId: friend.id,
                            friendName: friend.username,
                            friendRank: friend.rank,
                            friendAvatar: friend.avatar,
                            friendActivePortraitPath: friend.activePortraitPath,
                          ),
                        ),
                      ).then((_) => _loadUnreadCount());
                    },
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'block') {
                        _blockPlayer(friend.id, friend.username);
                      } else if (value == 'remove') {
                        _removeFriend(friendData.friendshipId);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'block',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.block,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(l10n.friendsUiMenuBlock),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person_remove,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(l10n.friendsUiMenuRemove),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestsTab(AppLocalizations l10n) {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              l10n.friendsUiNoRequests,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadPendingRequests,
      child: ListView.builder(
        itemCount: _pendingRequests.length,
        itemBuilder: (context, index) {
          final request = _pendingRequests[index];
          final requester = request.requesterInfo;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => _openPlayerProfile(requester.id, requester.username),
                child: CircleAvatar(
                  backgroundImage:
                      requester.avatar != null && requester.avatar!.isNotEmpty
                        ? AvatarHelper.getAvatarImageProvider(
                            requester.avatar,
                            activePortraitPath: requester.activePortraitPath,
                          )
                      : null,
                  child: requester.avatar == null || requester.avatar!.isEmpty
                      ? Text(requester.username[0].toUpperCase())
                      : null,
                ),
              ),
              title: GestureDetector(
                onTap: () => _openPlayerProfile(requester.id, requester.username),
                child: Text(
                  requester.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              subtitle: Text(
                l10n.friendsUiLineRank('${requester.rank}'),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: l10n.friendsUiAccept,
                    child: IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () => _acceptFriendRequest(request.friendshipId),
                    ),
                  ),
                  Tooltip(
                    message: l10n.friendsUiReject,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => _rejectFriendRequest(request.friendshipId),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchTab(AppLocalizations l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: l10n.friendsUiSearchLabel,
              hintText: l10n.friendsUiSearchHint,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _searchResults = [];
                        });
                      },
                    )
                  : null,
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
              _searchPlayers(value);
            },
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        if (_searchQuery.isNotEmpty && _searchQuery.length < 2)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.friendsUiSearchMinChars,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        if (_searchResults.isEmpty && _searchQuery.length >= 2 && !_loading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              l10n.friendsUiNoPlayersFound,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final result = _searchResults[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: GestureDetector(
                    onTap: () => _openPlayerProfile(result.id, result.username),
                    child: CircleAvatar(
                      backgroundImage:
                          result.avatar != null && result.avatar!.isNotEmpty
                          ? AvatarHelper.getAvatarImageProvider(
                              result.avatar,
                              activePortraitPath: result.activePortraitPath,
                            )
                          : null,
                      child: result.avatar == null || result.avatar!.isEmpty
                          ? Text(result.username[0].toUpperCase())
                          : null,
                    ),
                  ),
                  title: GestureDetector(
                    onTap: () => _openPlayerProfile(result.id, result.username),
                    child: Text(
                      result.username,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.friendsUiLineRank('${result.rank}'),
                      ),
                      if (result.currentCountry != null)
                        Text(
                          l10n.friendsUiLineLocation(
                            CountryHelper.getLocalizedCountryName(
                              result.currentCountry,
                              l10n,
                            ),
                          ),
                        ),
                      if (result.crewName != null)
                        Text(
                          l10n.friendsUiLineCrew(result.crewName!),
                        ),
                    ],
                  ),
                  trailing: _buildActionButton(result, l10n),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(PlayerSearchResult result, AppLocalizations l10n) {
    if (result.isFriend) {
      return Chip(
        label: Text(l10n.friendsUiChipFriend),
        backgroundColor: Colors.green[100],
      );
    } else if (result.isPendingSent) {
      return Chip(
        label: Text(
          l10n.friendsUiChipPending,
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.orange,
      );
    } else if (result.isPendingReceived) {
      return Tooltip(
        message: l10n.friendsUiAccept,
        child: Chip(
          label: Text(
            l10n.friendsUiAccept,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          deleteIcon: const Icon(Icons.check, size: 18, color: Colors.white),
          onDeleted: () => _acceptFriendRequest(result.friendshipId!),
        ),
      );
    } else if (result.canSendRequest) {
      return IconButton(
        icon: const Icon(Icons.person_add, color: Colors.blue),
        onPressed: () => _sendFriendRequest(result.id),
      );
    }
    return const SizedBox();
  }

  Future<void> _loadActivities() async {
    setState(() {
      _activitiesLoading = _activities.isEmpty;
      _activitiesInitialized = true;
      _activitiesError = null;
    });
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/activities/feed?limit=50');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final activitiesList = data['params']['activities'] as List;
        setState(() {
          _activities = activitiesList;
          _activitiesError = null;
        });
      } else {
        throw Exception('error.internal');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _activitiesError = AppLocalizations.of(context)!.connectionErrorGeneric;
      });
    } finally {
      if (mounted) setState(() => _activitiesLoading = false);
    }
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType) {
      case 'CRIME':
        return Icons.local_police;
      case 'JOB':
        return Icons.work;
      case 'RANK_UP':
        return Icons.trending_up;
      case 'HEIST':
        return Icons.shield;
      case 'TRAVEL':
        return Icons.flight;
      default:
        return Icons.info;
    }
  }

  Color _getActivityColor(String activityType) {
    switch (activityType) {
      case 'CRIME':
        return Colors.red;
      case 'JOB':
        return Colors.blue;
      case 'RANK_UP':
        return Colors.amber;
      case 'HEIST':
        return Colors.purple;
      case 'TRAVEL':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _buildActivityTab(AppLocalizations l10n) {
    // Only trigger initial load if not initialized yet
    if (!_activitiesInitialized && !_activitiesLoading) {
      Future.microtask(() => _loadActivities());
    }

    if (_activitiesLoading && _activities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_activitiesError != null && _activities.isEmpty) {
      return MobileLoadError(
        message: _activitiesError!,
        onRetry: _loadActivities,
      );
    }
    return _activities.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[600]),
                const SizedBox(height: 16),
                Text(
                  l10n.friendsUiActivityEmpty,
                  style: TextStyle(color: Colors.grey[400], fontSize: 18),
                ),
              ],
            ),
          )
        : RefreshIndicator(
            onRefresh: _loadActivities,
            child: ListView.builder(
              itemCount: _activities.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final activity = _activities[index];
                final player = activity['player'];
                if (player == null) return const SizedBox.shrink();

                return Card(
                  color: const Color(0xFF16213E),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        GestureDetector(
                          onTap: () => _openPlayerProfile(player['id'] as int, player['username'] as String),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                  AvatarHelper.getAvatarPath(player['avatar']),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _openPlayerProfile(player['id'] as int, player['username'] as String),
                                    child: Text(
                                      player['username'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      l10n.friendsUiActivityLevel(
                                        '${player['rank']}',
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    _getActivityIcon(activity['activityType']),
                                    size: 16,
                                    color: _getActivityColor(
                                      activity['activityType'],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      activity['description'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                timeago.format(
                                  DateTime.parse(activity['createdAt']),
                                  locale: _timeagoLocale(context),
                                ),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }
}
