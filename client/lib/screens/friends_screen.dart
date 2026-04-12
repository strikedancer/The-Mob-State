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

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Friend> _friends = [];
  List<FriendRequest> _pendingRequests = [];
  List<PlayerSearchResult> _searchResults = [];
  List<dynamic> _activities = []; // For activity feed

  bool _loading = false;
  bool _activitiesLoading = false;
  bool _activitiesInitialized =
      false; // Track if we've loaded activities at least once
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int _unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadFriends();
    _loadPendingRequests();
    _loadUnreadCount();
    _listenToActivityEvents();
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
    setState(() => _loading = true);
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/friends');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final friendsList = params['friends'] as List;
        setState(() {
          _friends = friendsList.map((f) => Friend.fromJson(f)).toList();
        });
      }
    } catch (e) {
      print('Error loading friends: $e');
    } finally {
      setState(() => _loading = false);
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
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'nl'
                    ? 'Vriendschapsverzoek verstuurd'
                    : 'Friend request sent',
              ),
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
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'nl'
                    ? 'Vriendschapsverzoek geaccepteerd'
                    : 'Friend request accepted',
              ),
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
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text(
                Localizations.localeOf(context).languageCode == 'nl'
                    ? 'Vriendschapsverzoek afgewezen'
                    : 'Friend request rejected',
              ),
              backgroundColor: Colors.orange,
            ),
          );
          _loadPendingRequests();
        }
      }
    } catch (e) {
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _removeFriend(int friendshipId) async {
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
                  ? 'Vriend verwijderen'
                  : 'Remove friend',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Weet je zeker dat je deze vriend wilt verwijderen?'
                  : 'Are you sure you want to remove this friend?',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Annuleren'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Verwijderen'
                  : 'Remove',
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final apiClient = AuthService().apiClient;
        final response = await apiClient.delete('/friends/$friendshipId');
        print('🔵 [FriendsScreen] Delete response: ${response.statusCode}');

        if (response.statusCode == 200) {
          print('✅ [FriendsScreen] Friend removed successfully');
          if (mounted) {
            showTopRightFromSnackBar(context, 
              SnackBar(
                content: Text(
                  Localizations.localeOf(context).languageCode == 'nl'
                      ? 'Vriend verwijderd'
                      : 'Friend removed',
                ),
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
            showTopRightFromSnackBar(context, 
              SnackBar(
                content: Text('Error: ${response.statusCode}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } catch (e) {
        print('❌ [FriendsScreen] Delete exception: $e');
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(
              content: Text('Error: $e'),
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
                  ? 'Speler blokkeren'
                  : 'Block player',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Weet je zeker dat je $username wilt blokkeren? Je kunt geen berichten meer sturen of ontvangen.'
                  : 'Are you sure you want to block $username? You won\'t be able to send or receive messages.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Annuleren'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Block'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final apiClient = AuthService().apiClient;
        final response = await apiClient.post('/friends/$playerId/block', {});

        if (response.statusCode == 200) {
          if (mounted) {
            showTopRightFromSnackBar(context, 
              SnackBar(
                content: Text(
                  Localizations.localeOf(context).languageCode == 'nl'
                      ? 'Speler geblokkeerd'
                      : 'Player blocked',
                ),
                backgroundColor: Colors.red,
              ),
            );
            _loadFriends();
          }
        }
      } catch (e) {
        if (mounted) {
          showTopRightFromSnackBar(context, 
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale == 'nl' ? 'Vrienden' : 'Friends'),
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
          tabs: [
            Tab(text: locale == 'nl' ? 'Vrienden' : 'Friends'),
            Tab(text: locale == 'nl' ? 'Activiteit' : 'Activity'),
            Tab(
              text: locale == 'nl' ? 'Verzoeken' : 'Requests',
              icon: _pendingRequests.isNotEmpty
                  ? Badge(
                      label: Text('${_pendingRequests.length}'),
                      child: const Icon(Icons.notifications),
                    )
                  : null,
            ),
            Tab(text: locale == 'nl' ? 'Zoeken' : 'Search'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(locale, l10n),
          _buildActivityTab(locale, l10n),
          _buildRequestsTab(locale, l10n),
          _buildSearchTab(locale, l10n),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(String locale, AppLocalizations? l10n) {
    if (_loading && _friends.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              locale == 'nl' ? 'Nog geen vrienden' : 'No friends yet',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              locale == 'nl'
                  ? 'Zoek spelers en voeg ze toe als vriend!'
                  : 'Search for players and add them as friends!',
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
                      ? (friend.avatar!.startsWith('http://') ||
                                friend.avatar!.startsWith('https://'))
                            ? NetworkImage(friend.avatar!)
                            : AssetImage('assets/images/avatars/${friend.avatar}.png')
                                  as ImageProvider
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
                  Text('${locale == 'nl' ? 'Rank' : 'Rank'}: ${friend.rank}'),
                  Text(
                    '${locale == 'nl' ? 'Locatie' : 'Location'}: ${l10n != null ? CountryHelper.getLocalizedCountryName(friend.currentCountry, l10n) : friend.currentCountry}',
                  ),
                  Text(
                    '${locale == 'nl' ? 'Gezondheid' : 'Health'}: ${friend.health}%',
                    style: TextStyle(
                      color: friend.health >= 75
                          ? Colors.green
                          : friend.health >= 50
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                  Text(
                    '${locale == 'nl' ? 'Vrienden sinds' : 'Friends since'}: ${_formatDate(friendData.since)}',
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
                            Text(locale == 'nl' ? 'Blokkeer' : 'Block'),
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
                            Text(locale == 'nl' ? 'Verwijder' : 'Remove'),
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

  Widget _buildRequestsTab(String locale, AppLocalizations? l10n) {
    if (_pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              locale == 'nl' ? 'Geen verzoeken' : 'No requests',
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
                      ? (requester.avatar!.startsWith('http://') ||
                                requester.avatar!.startsWith('https://'))
                            ? NetworkImage(requester.avatar!)
                            : AssetImage('assets/images/avatars/${requester.avatar}.png')
                                  as ImageProvider
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
                '${locale == 'nl' ? 'Rank' : 'Rank'}: ${requester.rank}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _acceptFriendRequest(request.friendshipId),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _rejectFriendRequest(request.friendshipId),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchTab(String locale, AppLocalizations? l10n) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: locale == 'nl' ? 'Zoek speler' : 'Search player',
              hintText: locale == 'nl'
                  ? 'Typ minimaal 2 karakters'
                  : 'Type at least 2 characters',
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
              locale == 'nl'
                  ? 'Typ minimaal 2 karakters om te zoeken'
                  : 'Type at least 2 characters to search',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        if (_searchResults.isEmpty && _searchQuery.length >= 2 && !_loading)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              locale == 'nl' ? 'Geen spelers gevonden' : 'No players found',
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
                          ? (result.avatar!.startsWith('http://') ||
                                    result.avatar!.startsWith('https://'))
                                ? NetworkImage(result.avatar!)
                                : AssetImage(
                                        'assets/images/avatars/${result.avatar}.png',
                                      )
                                      as ImageProvider
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
                        '${locale == 'nl' ? 'Rank' : 'Rank'}: ${result.rank}',
                      ),
                      if (result.currentCountry != null)
                        Text(
                          '${locale == 'nl' ? 'Locatie' : 'Location'}: ${l10n != null ? CountryHelper.getLocalizedCountryName(result.currentCountry, l10n) : result.currentCountry}',
                        ),
                      if (result.crewName != null)
                        Text(
                          '${locale == 'nl' ? 'Crew' : 'Crew'}: ${result.crewName}',
                        ),
                    ],
                  ),
                  trailing: _buildActionButton(result, locale),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(PlayerSearchResult result, String locale) {
    if (result.isFriend) {
      return Chip(
        label: Text(locale == 'nl' ? 'Vriend' : 'Friend'),
        backgroundColor: Colors.green[100],
      );
    } else if (result.isPendingSent) {
      return Chip(
        label: Text(
          locale == 'nl' ? 'Verzocht' : 'Pending',
          style: TextStyle(color: Colors.grey[800]),
        ),
        backgroundColor: Colors.orange,
      );
    } else if (result.isPendingReceived) {
      return Tooltip(
        message: locale == 'nl' ? 'Accepteren' : 'Accept',
        child: Chip(
          label: Text(
            locale == 'nl' ? 'Accepteren' : 'Accept',
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
      _activitiesLoading = true;
      _activitiesInitialized =
          true; // Mark as initialized on first load attempt
    });
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/activities/feed?limit=50');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final activitiesList = data['params']['activities'] as List;
        setState(() {
          _activities = activitiesList;
        });
      }
    } catch (e) {
      print('[ActivityFeed] Error: $e');
    } finally {
      setState(() => _activitiesLoading = false);
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

  Widget _buildActivityTab(String locale, AppLocalizations? l10n) {
    // Only trigger initial load if not initialized yet
    if (!_activitiesInitialized && !_activitiesLoading) {
      Future.microtask(() => _loadActivities());
    }

    return _activitiesLoading
        ? const Center(child: CircularProgressIndicator())
        : _activities.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey[600]),
                const SizedBox(height: 16),
                Text(
                  locale == 'nl'
                      ? 'Nog geen vriend activiteit'
                      : 'No friend activity yet',
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
                                      'Level ${player['rank']}',
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
