import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import '../services/auth_service.dart';
import '../providers/event_provider.dart';
import '../models/direct_message.dart';
import '../widgets/conversation_card.dart';
import 'chat_screen.dart';
import 'player_profile_screen.dart';
import '../utils/top_right_notification.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  final List<Conversation> _conversations = [];
  bool _loading = false;
  StreamSubscription? _eventSubscription;
  int _totalUnread = 0;
  Conversation? _openConversation;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _setupSSEListener();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _setupSSEListener() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final eventStreamService = eventProvider.eventStreamService;
    
    _eventSubscription = eventStreamService.eventStream.listen((event) {
      if (event['event'] == 'direct_message.received') {
        final params = event['params'] as Map<String, dynamic>;
        final senderId = params['senderId'] as int?;
        
        if (senderId != null) {
          // Reload conversations to update last message and unread count
          // Use debouncing to avoid multiple reloads
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _loadConversations();
            }
          });
        }
      } else if (event['event'] == 'direct_message.deleted') {
        // Reload to reflect deleted message
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _loadConversations();
          }
        });
      }
    });
  }

  Future<void> _loadConversations() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/messages/conversations');

      print('[DirectMessages] Response status: ${response.statusCode}');
      print('[DirectMessages] Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print('[DirectMessages] Empty response body');
          if (mounted) {
            setState(() {
              _conversations.clear();
              _totalUnread = 0;
            });
          }
          return;
        }

        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print('[DirectMessages] Decoded data keys: ${data.keys}');
        
        final params = data['params'] as Map<String, dynamic>?;
        print('[DirectMessages] Params: $params');
        
        if (params != null) {
          final conversationsList = params['conversations'];
          print('[DirectMessages] Conversations raw type: ${conversationsList.runtimeType}');
          print('[DirectMessages] Conversations raw value: $conversationsList');
          
          if (conversationsList is List) {
            print('[DirectMessages] Converting ${conversationsList.length} items');
            try {
              final conversations = conversationsList
                  .map((c) {
                    print('[DirectMessages] Processing item: $c (type: ${c.runtimeType})');
                    if (c is Map<String, dynamic>) {
                      return Conversation.fromJson(c);
                    } else if (c is Map) {
                      // Convert Map to Map<String, dynamic>
                      return Conversation.fromJson(Map<String, dynamic>.from(c));
                    } else {
                      print('[DirectMessages] WARNING: Item is not a Map: ${c.runtimeType}');
                      return null;
                    }
                  })
                  .whereType<Conversation>()
                  .toList();
              
              if (mounted) {
                setState(() {
                  _conversations.clear();
                  _conversations.addAll(conversations);
                  
                  // Calculate total unread
                  _totalUnread = _conversations.fold(
                    0, 
                    (sum, conv) => sum + conv.unreadCount,
                  );
                });
              }
              print('[DirectMessages] Loaded ${_conversations.length} conversations');
            } catch (e, stackTrace) {
              print('[DirectMessages] Error converting conversations: $e');
              print('[DirectMessages] Stack trace: $stackTrace');
              rethrow;
            }
          } else {
            print('[DirectMessages] Conversations is not a List, it is: ${conversationsList?.runtimeType}');
            if (mounted) {
              setState(() {
                _conversations.clear();
                _totalUnread = 0;
              });
            }
          }
        } else {
          print('[DirectMessages] Params is null');
          if (mounted) {
            setState(() {
              _conversations.clear();
              _totalUnread = 0;
            });
          }
        }
      } else {
        print('[DirectMessages] Non-200 status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('[DirectMessages] Error loading conversations: $e');
      print('[DirectMessages] Stack trace: $stackTrace');
      if (mounted) {
        showTopRightFromSnackBar(context, 
          SnackBar(
            content: Text('${_tr('Fout bij laden gesprekken', 'Error loading conversations')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _markAsRead(int friendId) async {
    try {
      final apiClient = AuthService().apiClient;
      await apiClient.post('/messages/mark-read/$friendId', {});
      
      // Update local state
      if (mounted) {
        setState(() {
          final conv = _conversations.firstWhere(
            (c) => c.friendId == friendId,
            orElse: () => _conversations.first,
          );
          _totalUnread = _totalUnread - conv.unreadCount;
        });
      }
    } catch (e) {
      print('[DirectMessages] Error marking as read: $e');
    }
  }

  void _openChat(Conversation conversation) async {
    // Mark as read
    await _markAsRead(conversation.friendId);
    if (!mounted) return;
    setState(() => _openConversation = conversation);
  }

  void _closeChat() {
    setState(() => _openConversation = null);
    _loadConversations();
  }

  void _openPlayerProfile(Conversation conversation) {
    if (conversation.friendId <= 0) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerProfileScreen(
          playerId: conversation.friendId,
          username: conversation.username,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show chat inline if a conversation is selected
    if (_openConversation != null) {
      return ChatScreen(
        friendId: _openConversation!.friendId,
        friendName: _openConversation!.username,
        friendRank: _openConversation!.rank,
        friendAvatar: _openConversation!.avatar,
        onBack: _closeChat,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            const Text(
              'Berichten',
              style: TextStyle(color: Colors.white),
            ),
            if (_totalUnread > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F8B24),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _totalUnread > 99 ? '99+' : '$_totalUnread',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadConversations,
          ),
        ],
      ),
      body: _loading
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1F8B24),
            ),
          )
        : _conversations.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nog geen berichten',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stuur een bericht naar je vrienden!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                color: const Color(0xFF1F8B24),
                onRefresh: _loadConversations,
                child: ListView.builder(
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = _conversations[index];
                    return ConversationCard(
                      conversation: conversation,
                      onTap: () => _openChat(conversation),
                      onAvatarTap: () => _openPlayerProfile(conversation),
                    );
                  },
                ),
              ),
    );
  }
}
