import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import '../services/auth_service.dart';
import '../providers/event_provider.dart';
import '../models/direct_message.dart';
import '../widgets/conversation_card.dart';
import 'chat_screen.dart';
import '../utils/player_profile_navigation.dart';
import '../utils/top_right_notification.dart';
import '../l10n/app_localizations.dart';
import '../widgets/game_page_info.dart';
import '../widgets/empire_page_hero.dart';

class DirectMessagesScreen extends StatefulWidget {
  const DirectMessagesScreen({super.key, this.embedded = false});

  final bool embedded;

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

  int get _readCount =>
      _conversations.where((c) => c.unreadCount <= 0).length;

  Future<bool> _confirmHide({required String title, required String body}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(body, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }

  Future<void> _hideConversation(Conversation conversation) async {
    final l10n = AppLocalizations.of(context)!;
    if (conversation.unreadCount > 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.messagesHideUnreadBlocked),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.delete(
        '/messages/conversation/${conversation.friendId}',
      );
      if (response.statusCode != 200) {
        throw Exception(l10n.messagesHideFailed);
      }
      if (!mounted) return;
      setState(() {
        _conversations.removeWhere((c) => c.friendId == conversation.friendId);
        if (_openConversation?.friendId == conversation.friendId) {
          _openConversation = null;
        }
      });
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.messagesHidden)),
      );
    } catch (e) {
      if (!mounted) return;
      await _loadConversations();
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.messagesHideFailed),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _clearReadMessages() async {
    final l10n = AppLocalizations.of(context)!;
    if (_readCount <= 0) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.messagesClearReadEmpty)),
      );
      return;
    }
    final ok = await _confirmHide(
      title: l10n.messagesClearRead,
      body: l10n.messagesClearReadConfirm,
    );
    if (!ok || !mounted) return;
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.delete('/messages/read');
      if (response.statusCode != 200) {
        throw Exception(l10n.messagesHideFailed);
      }
      if (!mounted) return;
      await _loadConversations();
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.messagesHidden)),
      );
    } catch (e) {
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.messagesHideFailed),
          backgroundColor: Colors.red,
        ),
      );
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

    PlayerProfileNavigation.open(
      context,
      conversation.friendId,
      conversation.username,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GamePageInfoHost(
      topicId: 'messages',
      showOverlay: false,
      child: _buildPageInfoChild(context),
    );
  }

  Widget _buildPageInfoChild(BuildContext context) {
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

    return EmpireHubScaffold(
      embedded: widget.embedded,
      title: l10n.messages,
      imageAsset: 'assets/images/backgrounds/login_background.png',
      topicId: 'messages',
      onRefresh: _loadConversations,
      fallbackIcon: Icons.mail_outline,
      chips: [
        if (_totalUnread > 0)
          EmpireStatChip(
            icon: Icons.mark_email_unread,
            label: _totalUnread > 99 ? '99+' : '$_totalUnread',
          ),
        if (_readCount > 0)
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _clearReadMessages,
              borderRadius: BorderRadius.circular(20),
              child: EmpireStatChip(
                icon: Icons.delete_sweep_outlined,
                label: l10n.messagesClearRead,
              ),
            ),
          ),
      ],
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
                    final card = ConversationCard(
                      conversation: conversation,
                      onTap: () => _openChat(conversation),
                      onAvatarTap: () => _openPlayerProfile(conversation),
                      onHide: conversation.unreadCount > 0
                          ? null
                          : () async {
                              final ok = await _confirmHide(
                                title: l10n.messagesHideConversation,
                                body: l10n.messagesHideConversationConfirm,
                              );
                              if (ok) {
                                await _hideConversation(conversation);
                              }
                            },
                    );
                    if (conversation.unreadCount > 0) {
                      return card;
                    }
                    return Dismissible(
                      key: ValueKey('inbox-${conversation.friendId}'),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _confirmHide(
                        title: l10n.messagesHideConversation,
                        body: l10n.messagesHideConversationConfirm,
                      ),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: const Color(0xFF8B1A1A),
                        child: const Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      onDismissed: (_) => _hideConversation(conversation),
                      child: card,
                    );
                  },
                ),
              ),
    );
  }
}

