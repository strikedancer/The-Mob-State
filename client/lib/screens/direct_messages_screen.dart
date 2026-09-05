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
import '../l10n/app_localizations.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key});

  @override
  State<DirectMessagesScreen> createState() => _DirectMessagesScreenState();
}

class _DirectMessagesScreenState extends State<DirectMessagesScreen> {
  final List<Conversation> _conversations = [];
  bool _loading = true;
  String? _error;
  StreamSubscription? _eventSubscription;
  int _totalUnread = 0;
  Conversation? _openConversation;

  @override
  void initState() {
    super.initState();
    _loadConversations(autoRetry: true);
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

  Future<void> _loadConversations({bool autoRetry = false}) async {
    if (!mounted) return;
    setState(() {
      _loading = _conversations.isEmpty;
      _error = null;
    });
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get('/messages/conversations');
      Map<String, dynamic> data = const {};
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      } catch (_) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          throw const FormatException('invalid conversations payload');
        }
      }

      if (!mounted) return;

      if (response.statusCode != 200) {
        throw Exception(data['event']?.toString() ?? 'error.internal');
      }

      final params = data['params'] is Map
          ? Map<String, dynamic>.from(data['params'] as Map)
          : const <String, dynamic>{};
      final conversationsList = params['conversations'];
      final conversations = conversationsList is List
          ? conversationsList.whereType<Map>().map((item) {
              try {
                return Conversation.fromJson(
                  Map<String, dynamic>.from(item),
                );
              } catch (_) {
                return null;
              }
            }).whereType<Conversation>().toList()
          : <Conversation>[];

      setState(() {
        _conversations
          ..clear()
          ..addAll(conversations);
        _totalUnread = _conversations.fold(
          0,
          (sum, conv) => sum + conv.unreadCount,
        );
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _error = l10n.errorLoadingConversations(e.toString());
        _loading = false;
      });
      if (_conversations.isEmpty) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.errorLoadingConversations(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (autoRetry && _error != null && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!mounted || _error == null) return;
      await _loadConversations();
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
    final l10n = AppLocalizations.of(context)!;
    // Show chat inline if a conversation is selected
    if (_openConversation != null) {
      return ChatScreen(
        friendId: _openConversation!.friendId,
        friendName: _openConversation!.username,
        friendRank: _openConversation!.rank,
        friendAvatar: _openConversation!.avatar,
        friendActivePortraitPath: _openConversation!.activePortraitPath,
        onBack: _closeChat,
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          children: [
            Text(
              l10n.messages,
              style: const TextStyle(color: Colors.white),
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
      body: _loading && _conversations.isEmpty
        ? const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF1F8B24),
            ),
          )
        : _error != null && _conversations.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadConversations,
                        icon: const Icon(Icons.refresh),
                        label: Text(l10n.retry),
                      ),
                    ],
                  ),
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
                      l10n.noDirectMessagesYet,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.sendMessageToFriendsHint,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _loadConversations,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.retry),
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
