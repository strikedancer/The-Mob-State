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
import '../l10n/app_localizations.dart';
import '../widgets/mobile_load_error.dart';

class ChatScreen extends StatefulWidget {
  final int friendId;
  final String friendName;
  final int friendRank;
  final String? friendAvatar;
  final String? friendActivePortraitPath;
  final VoidCallback? onBack;

  const ChatScreen({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendRank,
    this.friendAvatar,
    this.friendActivePortraitPath,
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
  String? _loadError;
  bool _sending = false;
  StreamSubscription? _eventSubscription;
  int? _currentUserId;
  final Set<int> _investigationPendingCaseIds = <int>{};
  final Set<int> _investigationCompletedCaseIds = <int>{};

  bool get _isSystemThread => widget.friendId == 0;

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
    setState(() {
      _loading = _messages.isEmpty;
      _loadError = null;
    });
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
          _messages
            ..clear()
            ..addAll(
              messagesList.map((m) => DirectMessage.fromJson(m)).toList(),
            );
          _loadError = null;
        });

        _scrollToBottom();
        _markAsRead();
      } else {
        throw Exception('error.internal');
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() {
        _loadError = l10n.errorLoadingMessages(e.toString());
      });
    } finally {
      if (mounted) setState(() => _loading = false);
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

    final l10n = AppLocalizations.of(context)!;
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
            data['params']?['error'] ?? data['error'] ?? l10n.messageSendFailed;
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('[ChatScreen] Error sending message: $e');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.error(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _sending = false);
    }
  }

  Future<void> _deleteMessage(DirectMessage message) async {
    final l10n = AppLocalizations.of(context)!;
    if (message.senderId != _currentUserId) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.messageDeleteOwnOnly),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        final dl10n = AppLocalizations.of(context)!;
        return AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: Text(
          dl10n.confirmAction,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dl10n.messageDeleteTitle,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              dl10n.messageDeleteBody,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              dl10n.cancel,
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              dl10n.delete,
            ),
          ),
        ],
      );
      },
    );

    if (confirm != true) return;

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.delete('/messages/${message.id}');

      if (response.statusCode != 200) {
        throw Exception(l10n.messageDeleteFailed);
      }
    } catch (e) {
      print('[ChatScreen] Error deleting message: $e');
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.error(e.toString())),
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

  _MurderCaseMeta? _extractMurderCaseMeta(String rawMessage) {
    final match = RegExp(r'\[\[hitlist_murder_case:(\d+):([^\]]+)\]\]').firstMatch(rawMessage);
    if (match == null) return null;

    final caseId = int.tryParse(match.group(1) ?? '');
    final expiresAtRaw = match.group(2);
    if (caseId == null || expiresAtRaw == null) return null;

    final expiresAt = DateTime.tryParse(expiresAtRaw)?.toUtc();
    if (expiresAt == null) return null;

    return _MurderCaseMeta(caseId: caseId, expiresAt: expiresAt);
  }

  bool _isMurderCaseExpired(_MurderCaseMeta meta) {
    return DateTime.now().toUtc().isAfter(meta.expiresAt);
  }

  Future<void> _startMurderCaseInvestigation(_MurderCaseMeta meta) async {
    final l10n = AppLocalizations.of(context)!;
    if (_investigationPendingCaseIds.contains(meta.caseId) || _investigationCompletedCaseIds.contains(meta.caseId)) {
      return;
    }

    if (_isMurderCaseExpired(meta)) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.investigationWindowExpired),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _investigationPendingCaseIds.add(meta.caseId);
    });

    try {
      final apiClient = AuthService().apiClient;
      final response = await apiClient.post('/hitlist/murder-case/${meta.caseId}/investigate', {});

      if (response.statusCode == 200) {
        setState(() {
          _investigationCompletedCaseIds.add(meta.caseId);
        });
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(l10n.investigationStartedInboxHint),
            backgroundColor: const Color(0xFF1F8B24),
          ),
        );
      } else {
        String errorCode = 'UNKNOWN';
        try {
          final payload = jsonDecode(response.body) as Map<String, dynamic>;
          errorCode = (payload['error'] ?? '').toString();
        } catch (_) {
          // ignore parse errors
        }

        if (errorCode == 'MURDER_CASE_EXPIRED') {
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.investigationWindowExpired),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (errorCode == 'MURDER_CASE_ALREADY_REQUESTED') {
          setState(() {
            _investigationCompletedCaseIds.add(meta.caseId);
          });
          showTopRightFromSnackBar(
            context,
            SnackBar(
              content: Text(l10n.investigationAlreadyInProgress),
              backgroundColor: Colors.blueGrey,
            ),
          );
        } else {
          throw Exception('Failed to start investigation');
        }
      }
    } catch (e) {
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(l10n.investigationStartFailed(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _investigationPendingCaseIds.remove(meta.caseId);
        });
      }
    }
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
            image: AvatarHelper.getAvatarImageProvider(
              widget.friendAvatar,
              activePortraitPath: widget.friendActivePortraitPath,
            ),
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
    final l10n = AppLocalizations.of(context)!;
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
                          ? l10n.messageSystemThreadSubtitle
                          : l10n.chatFriendRankLine(widget.friendRank),
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
                : _loadError != null && _messages.isEmpty
                    ? MobileLoadError(
                        message: _loadError!,
                        onRetry: _loadMessages,
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
                              l10n.noDirectMessagesYet,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isSystemThread
                                  ? l10n.messageSystemThreadEmptyDetail
                                  : l10n.messageSendFirst,
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
                          final itemL10n = AppLocalizations.of(context)!;
                          final message = _messages[index];
                          final caseMeta = _extractMurderCaseMeta(message.message);
                          final canShowAction = _isSystemThread &&
                              message.senderId == 0 &&
                              caseMeta != null;
                          final isExpired = caseMeta != null ? _isMurderCaseExpired(caseMeta) : false;
                          final isPending = caseMeta != null && _investigationPendingCaseIds.contains(caseMeta.caseId);
                          final isCompleted = caseMeta != null && _investigationCompletedCaseIds.contains(caseMeta.caseId);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MessageBubble.fromDirectMessage(
                                message: message,
                                currentUserId: _currentUserId ?? 0,
                                friendAvatar: widget.friendAvatar,
                                friendActivePortraitPath:
                                    widget.friendActivePortraitPath,
                                onLongPress: () => _deleteMessage(message),
                              ),
                              if (canShowAction)
                                Padding(
                                  padding: const EdgeInsets.only(left: 52, right: 16, top: 2, bottom: 8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: ElevatedButton.icon(
                                      onPressed: (isExpired || isPending || isCompleted)
                                          ? null
                                          : () => _startMurderCaseInvestigation(caseMeta),
                                      icon: const Icon(Icons.search, size: 16),
                                      label: Text(
                                        isExpired
                                            ? itemL10n.investigationExpired
                                            : isCompleted
                                                ? itemL10n.investigationStarted
                                                : isPending
                                                    ? itemL10n.investigationStarting
                                                    : itemL10n.startMurderInvestigation,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF36454F),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
          ),
          MessageInput(
            controller: _messageController,
            onSend: _sendMessage,
            enabled: !_sending && !_isSystemThread,
            hint: _isSystemThread
                ? l10n.systemMessagesReadOnlyHint
                : null,
          ),
        ],
      ),
    );
  }
}

class _MurderCaseMeta {
  final int caseId;
  final DateTime expiresAt;

  const _MurderCaseMeta({
    required this.caseId,
    required this.expiresAt,
  });
}
