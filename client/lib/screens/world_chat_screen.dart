import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/global_chat_stickers.dart';
import '../l10n/app_localizations.dart';
import '../models/global_chat_message.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../services/auth_service.dart';
import '../utils/top_right_notification.dart';
import '../widgets/empire_page_hero.dart';
import '../widgets/game_page_info.dart';
import '../widgets/message_bubble.dart';
import '../widgets/mobile_load_error.dart';
import '../widgets/responsive_modal.dart';

class WorldChatScreen extends StatefulWidget {
  const WorldChatScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<WorldChatScreen> createState() => _WorldChatScreenState();
}

class _WorldChatScreenState extends State<WorldChatScreen> {
  final List<GlobalChatMessage> _messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _eventSubscription;
  bool _loading = false;
  bool _sending = false;
  bool _loadFailed = false;
  bool _showStickers = false;
  String? _selectedStickerId;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _setupSse();
  }

  @override
  void dispose() {
    _eventSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _setupSse() {
    final eventStream = Provider.of<EventProvider>(context, listen: false)
        .eventStreamService
        .eventStream;
    _eventSubscription = eventStream.listen((event) {
      final name = event['event'];
      final params = event['params'];
      if (name == 'global_chat.message' && params is Map) {
        final raw = params['message'];
        if (raw is! Map) return;
        final message = GlobalChatMessage.fromJson(
          Map<String, dynamic>.from(raw),
        );
        if (_messages.any((row) => row.id == message.id)) return;
        setState(() => _messages.add(message));
        _scrollToBottom();
      } else if (name == 'global_chat.message_deleted' && params is Map) {
        final id = (params['messageId'] as num?)?.toInt();
        if (id == null) return;
        setState(() => _messages.removeWhere((row) => row.id == id));
      }
    });
  }

  Future<void> _loadMessages() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final response = await AuthService().apiClient.get('/global-chat/messages?limit=100');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final list = params['messages'] as List? ?? [];
        setState(() {
          _messages
            ..clear()
            ..addAll(
              list.map(
                (row) => GlobalChatMessage.fromJson(
                  Map<String, dynamic>.from(row as Map),
                ),
              ),
            );
        });
        _scrollToBottom();
      } else {
        setState(() => _loadFailed = true);
      }
    } catch (_) {
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _reasonFromBody(String body) {
    try {
      final data = jsonDecode(body);
      if (data is Map && data['params'] is Map) {
        return data['params']['reason'] as String?;
      }
    } catch (_) {}
    return null;
  }

  String _errorCopy(AppLocalizations l10n, String? reason) {
    switch (reason) {
      case 'GLOBAL_CHAT_MUTED':
        return l10n.worldChatErrorMuted;
      case 'GLOBAL_CHAT_RATE_LIMIT':
        return l10n.worldChatErrorRateLimit;
      case 'GLOBAL_CHAT_TOO_LONG':
        return l10n.worldChatErrorTooLong;
      case 'GLOBAL_CHAT_DISABLED':
        return l10n.worldChatErrorDisabled;
      case 'GLOBAL_CHAT_DELETE_EXPIRED':
        return l10n.worldChatErrorDeleteExpired;
      default:
        return l10n.worldChatErrorGeneric;
    }
  }

  Future<void> _sendMessage() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _messageController.text.trim();
    final stickerId = _selectedStickerId;
    if (text.isEmpty && stickerId == null) return;
    if (text.length > 200) {
      showTopRightFromSnackBar(
        context,
        SnackBar(content: Text(l10n.worldChatErrorTooLong)),
      );
      return;
    }
    setState(() => _sending = true);
    try {
      final response = await AuthService().apiClient.post(
        '/global-chat/messages',
        {
          'message': text,
          if (stickerId != null) 'stickerId': stickerId,
        },
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final params = data['params'] as Map<String, dynamic>;
        final created = GlobalChatMessage.fromJson(
          Map<String, dynamic>.from(params['message'] as Map),
        );
        setState(() {
          if (!_messages.any((row) => row.id == created.id)) {
            _messages.add(created);
          }
          _messageController.clear();
          _selectedStickerId = null;
          _showStickers = false;
        });
        _scrollToBottom();
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_errorCopy(l10n, _reasonFromBody(response.body))),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.worldChatErrorGeneric)),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _deleteOwn(int messageId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final response = await AuthService().apiClient.delete(
        '/global-chat/messages/$messageId',
      );
      if (response.statusCode == 200) {
        setState(() => _messages.removeWhere((row) => row.id == messageId));
      } else {
        showTopRightFromSnackBar(
          context,
          SnackBar(
            content: Text(_errorCopy(l10n, _reasonFromBody(response.body))),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.worldChatErrorGeneric)),
        );
      }
    }
  }

  Future<void> _report(int messageId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final response = await AuthService().apiClient.post(
        '/global-chat/messages/$messageId/report',
        const {},
      );
      if (!mounted) return;
      showTopRightFromSnackBar(
        context,
        SnackBar(
          content: Text(
            response.statusCode == 200
                ? l10n.worldChatReported
                : l10n.worldChatErrorGeneric,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        showTopRightFromSnackBar(
          context,
          SnackBar(content: Text(l10n.worldChatErrorGeneric)),
        );
      }
    }
  }

  Future<void> _onLongPress(GlobalChatMessage message, bool isOwn) async {
    final action = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final loc = AppLocalizations.of(ctx)!;
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          title: Text(
            loc.worldChatMessageActions,
            style: const TextStyle(color: Colors.white),
          ),
          content: ResponsiveDialogContent(
            phoneMaxWidth: 320,
            tabletMaxWidth: 380,
            desktopMaxWidth: 420,
            child: Text(
              isOwn ? loc.worldChatDeleteBody : loc.worldChatReportBody,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(loc.crewChatCancel),
            ),
            if (isOwn)
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'delete'),
                child: Text(
                  loc.crewChatDelete,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else
              TextButton(
                onPressed: () => Navigator.pop(ctx, 'report'),
                child: Text(loc.worldChatReport),
              ),
          ],
        );
      },
    );
    if (action == 'delete') await _deleteOwn(message.id);
    if (action == 'report') await _report(message.id);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final playerId = context.watch<AuthProvider>().currentPlayer?.id;
    final body = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: EmpirePageHero(
            title: l10n.worldChatTitle,
            subtitle: l10n.worldChatSubtitle,
            imageAsset: 'assets/images/backgrounds/login_background.png',
            topicId: 'world-chat',
            fallbackIcon: Icons.public,
            onRefresh: _loading ? null : _loadMessages,
            refreshEnabled: !_loading,
          ),
        ),
        Expanded(child: _buildList(l10n, playerId)),
        if (_showStickers) _buildStickerTray(),
        if (_selectedStickerId != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Row(
              children: [
                Text(
                  globalChatStickerById(_selectedStickerId)?.emoji ?? '',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => setState(() => _selectedStickerId = null),
                  child: Text(l10n.worldChatClearSticker),
                ),
              ],
            ),
          ),
        MessageInput(
          controller: _messageController,
          onSend: _sendMessage,
          enabled: !_sending,
          hint: l10n.worldChatHint,
          allowEmptySend: _selectedStickerId != null,
          leading: IconButton(
            tooltip: l10n.worldChatStickers,
            onPressed: () => setState(() => _showStickers = !_showStickers),
            icon: Icon(
              Icons.emoji_emotions_outlined,
              color: _showStickers ? const Color(0xFFFFB347) : Colors.grey[400],
            ),
          ),
        ),
      ],
    );

    return GamePageInfoHost(
      topicId: 'world-chat',
      showOverlay: false,
      child: widget.embedded
          ? ColoredBox(color: kEmpireBgEnd, child: body)
          : Scaffold(
              backgroundColor: kEmpireBgEnd,
              appBar: AppBar(title: Text(l10n.worldChatTitle)),
              body: body,
            ),
    );
  }

  Widget _buildList(AppLocalizations l10n, int? playerId) {
    if (_loading && _messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFB347)),
      );
    }
    if (_loadFailed && _messages.isEmpty) {
            return MobileLoadError(
              message: l10n.worldChatErrorGeneric,
              onRetry: _loadMessages,
            );
    }
    if (_messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.forum_outlined, size: 64, color: Colors.grey[700]),
              const SizedBox(height: 12),
              Text(
                l10n.worldChatEmpty,
                style: TextStyle(color: Colors.grey[400], fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.worldChatEmptyHint,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final isOwn = playerId != null && message.playerId == playerId;
        return MessageBubble(
          message: message.message,
          time: message.formattedTime,
          isMe: isOwn,
          senderName: message.displayName,
          senderId: message.playerId,
          showSenderInfo: true,
          stickerEmoji: message.stickerEmoji ??
              globalChatStickerById(message.stickerId)?.emoji,
          sourceLabel: message.source == 'discord' ? l10n.worldChatFromDiscord : null,
          onLongPress: () => _onLongPress(message, isOwn),
        );
      },
    );
  }

  Widget _buildStickerTray() {
    return Container(
      height: 168,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1212),
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: GridView.builder(
        itemCount: kGlobalChatStickers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          final sticker = kGlobalChatStickers[index];
          final selected = sticker.id == _selectedStickerId;
          return InkWell(
            onTap: () => setState(() {
              _selectedStickerId = selected ? null : sticker.id;
            }),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0x33FFB347)
                    : const Color(0xFF2A1A1A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? const Color(0xFFFFB347)
                      : Colors.white10,
                ),
              ),
              child: Center(
                child: Text(sticker.emoji, style: const TextStyle(fontSize: 26)),
              ),
            ),
          );
        },
      ),
    );
  }
}
