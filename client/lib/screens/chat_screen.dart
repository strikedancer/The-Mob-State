import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:async';
import '../services/auth_service.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../models/direct_message.dart';
import '../widgets/message_bubble.dart';
import '../utils/avatar_helper.dart';
import 'player_profile_screen.dart';
import '../utils/top_right_notification.dart';

class ChatScreen extends StatefulWidget {
  final int friendId;
  final String friendName;
  final int friendRank;
  final String? friendAvatar;
  final VoidCallback? onBack;

  const ChatScreen({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendRank,
    this.friendAvatar,
    this.onBack,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<DirectMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _loading = false;
  bool _sending = false;
  StreamSubscription? _eventSubscription;
  int? _currentUserId;

  bool get _isSystemThread => widget.friendId == 0;

  bool get _isNl => Localizations.localeOf(context).languageCode == 'nl';
  String _tr(String nl, String en) => _isNl ? nl : en;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMessages();
    _setupSSEListener();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _eventSubscription?.cancel();
    super.dispose();
  }

  void _loadCurrentUser() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _currentUserId = authProvider.currentPlayer?.id;
  }

  void _setupSSEListener() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final eventStreamService = eventProvider.eventStreamService;

    _eventSubscription = eventStreamService.eventStream.listen((event) {
      if (event['event'] == 'direct_message.received') {
        final params = event['params'] as Map<String, dynamic>;
        final senderId = params['senderId'] as int?;
        final receiverId = params['receiverId'] as int?;

        if ((senderId == widget.friendId && receiverId == _currentUserId) ||
            (senderId == _currentUserId && receiverId == widget.friendId)) {
          final messageId = params['messageId'] as int;
          final messageExists = _messages.any((m) => m.id == messageId);
          if (messageExists) {
            return;
          }

          final message = DirectMessage(
            id: messageId,
            senderId: senderId!,
            receiverId: receiverId!,
            message: params['message'] as String,
            read: params['read'] as bool? ?? false,
            createdAt: params['createdAt'] as String,
            senderInfo: params['sender'] != null
                ? MessageSender.fromJson(params['sender'])
                : null,
          );

          setState(() {
            _messages.add(message);
          });

          _scrollToBottom();

          if (senderId == widget.friendId) {
            _markAsRead();
          }
        }
      } else if (event['event'] == 'direct_message.deleted') {
        final params = event['params'] as Map<String, dynamic>;
        final messageId = params['messageId'] as int?;

        if (messageId != null) {
          setState(() {
            _messages.removeWhere((m) => m.id == messageId);
          });
        }
      } else if (event['event'] == 'direct_message.read') {
        final params = event['params'] as Map<String, dynamic>;
        final receiverId = params['receiverId'] as int?;

        if (receiverId == widget.friendId) {
          setState(() {
            for (var message in _messages) {
              if (message.senderId == _currentUserId &&
                  message.receiverId == widget.friendId) {
                final index = _messages.indexOf(message);
                _messages[index] = DirectMessage(
                  id: message.id,
                  senderId: message.senderId,
                  receiverId: message.receiverId,
                  message: message.message,
                  read: true,
                  createdAt: message.createdAt,
                  senderInfo: message.senderInfo,
                );
              }
            }
          });
        }
      }
    });
  }

  Future<void> _loadMessages() async {
    setState(() => _loading = true);
    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.get(
        '/messages/conversation/${widget.friendId}?limit=100',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final messagesList = params['messages'] as List;

        setState(() {
          _messages.clear();
          _messages.addAll(
            messagesList.map((m) => DirectMessage.fromJson(m)).toList(),
          );
        });

        _scrollToBottom();
        _markAsRead();
      }
    } catch (e) {
      print('[ChatScreen] Error loading messages: $e');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout bij laden berichten', 'Error loading messages')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _markAsRead() async {
    try {
      final apiClient = AuthService().apiClient;
      await apiClient.post('/messages/mark-read/${widget.friendId}', {});
    } catch (e) {
      print('[ChatScreen] Error marking as read: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_isSystemThread) return;

    final message = _messageController.text.trim();
    if (message.isEmpty || _sending) return;

    setState(() => _sending = true);

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post(
        '/messages/${widget.friendId}',
        {'message': message},
      );

      print('[ChatScreen] Send response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        _messageController.clear();
      } else {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['params']?['error'] ?? data['error'] ?? 'Fout bij versturen';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('[ChatScreen] Error sending message: $e');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _deleteMessage(DirectMessage message) async {
    if (message.senderId != _currentUserId) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(_tr('Je kunt alleen je eigen berichten verwijderen', 'You can only delete your own messages')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          Localizations.localeOf(context).languageCode == 'nl'
              ? 'Weet je het zeker?'
              : 'Are you sure?',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Bericht verwijderen'
                  : 'Delete message',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Dit bericht wordt permanent verwijderd.'
                  : 'This message will be permanently deleted.',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Annuleren'
                  : 'Cancel',
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              Localizations.localeOf(context).languageCode == 'nl'
                  ? 'Verwijderen'
                  : 'Delete',
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.delete('/messages/${message.id}');

      if (response.statusCode != 200) {
        throw Exception('Fout bij verwijderen');
      }
    } catch (e) {
      print('[ChatScreen] Error deleting message: $e');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text('${_tr('Fout', 'Error')}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _openFriendProfile() {
    if (_isSystemThread) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerProfileScreen(
          playerId: widget.friendId,
          username: widget.friendName,
        ),
      ),
    );
  }

  Widget _buildThreadAvatar() {
    if (_isSystemThread) {
      return Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF6B4E00), Color(0xFFB8860B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.emoji_events,
          color: Color(0xFFFFF3C4),
          size: 20,
        ),
      );
    }

    if (widget.friendAvatar != null) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[800],
          image: DecorationImage(
            image: AssetImage(AvatarHelper.getAvatarPath(widget.friendAvatar)),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey[800],
      child: Text(
        widget.friendName.isNotEmpty ? widget.friendName[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: _isSystemThread ? null : _openFriendProfile,
              child: _buildThreadAvatar(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _isSystemThread ? null : _openFriendProfile,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.friendName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _isSystemThread
                          ? 'Achievement- en systeemberichten'
                          : '★ Rank ${widget.friendRank}',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1F8B24),
                    ),
                  )
                : _messages.isEmpty
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
                              _isSystemThread
                                  ? 'Achievement- en systeemberichten verschijnen hier automatisch.'
                                  : 'Stuur het eerste bericht!',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return MessageBubble.fromDirectMessage(
                            message: message,
                            currentUserId: _currentUserId ?? 0,
                            friendAvatar: widget.friendAvatar,
                            onLongPress: () => _deleteMessage(message),
                          );
                        },
                      ),
          ),
          MessageInput(
            controller: _messageController,
            onSend: _sendMessage,
            enabled: !_sending && !_isSystemThread,
            hint: _isSystemThread
                ? 'Systeemberichten kunnen niet beantwoord worden'
                : null,
          ),
        ],
      ),
    );
  }
}
