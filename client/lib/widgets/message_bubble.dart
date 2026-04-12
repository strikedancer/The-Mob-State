// ignore_for_file: unused_element
import 'package:flutter/material.dart';
import '../models/direct_message.dart';
import '../models/crew_message.dart';
import '../utils/avatar_helper.dart';
import '../screens/player_profile_screen.dart';

/// WhatsApp-style message bubble widget
class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;
  final String? senderName;
  final int? senderId;
  final int? senderRank;
  final String? senderAvatar;
  final VoidCallback? onLongPress;
  final bool showSenderInfo;
  final bool? isRead;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
    this.senderName,
    this.senderId,
    this.senderRank,
    this.senderAvatar,
    this.onLongPress,
    this.showSenderInfo = false,
    this.isRead,
  });

  /// Create from DirectMessage
  factory MessageBubble.fromDirectMessage({
    required DirectMessage message,
    required int currentUserId,
    String? friendAvatar,
    VoidCallback? onLongPress,
  }) {
    final isMe = message.senderId == currentUserId;
    return MessageBubble(
      message: message.message,
      time: message.formattedDateTime,
      isMe: isMe,
      senderName: message.senderInfo?.username,
      senderId: message.senderInfo?.id,
      senderRank: message.senderInfo?.rank,
      senderAvatar: isMe ? null : (message.senderInfo?.avatar ?? friendAvatar),
      onLongPress: onLongPress,
      showSenderInfo: false,
      isRead: message.read,
    );
  }

  /// Create from CrewMessage
  factory MessageBubble.fromCrewMessage({
    required CrewMessage message,
    required int currentUserId,
    VoidCallback? onLongPress,
  }) {
    final isMe = message.playerId == currentUserId;
    return MessageBubble(
      message: message.message,
      time: message.formattedTime,
      isMe: isMe,
      senderName: message.sender?.username,
      senderId: message.sender?.id,
      senderRank: message.sender?.rank,
      onLongPress: onLongPress,
      showSenderInfo: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final achievementMeta = _parseAchievementMeta(message);
    final cleanedMessage = _stripAchievementMeta(message);
    final isAchievementMessage = achievementMeta != null;

    void openSenderProfile() {
      if (isMe || senderId == null || senderName == null) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlayerProfileScreen(
            playerId: senderId!,
            username: senderName!,
          ),
        ),
      );
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar for received messages (left side)
            if (!isMe && senderAvatar != null) ...[
              GestureDetector(
                onTap: senderId != null ? openSenderProfile : null,
                child: Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[800],
                    image: DecorationImage(
                      image: AvatarHelper.getAvatarImageProvider(senderAvatar),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ] else if (!isMe) ...[
              const SizedBox(width: 40), // Spacer when no avatar
            ],
            
            // Message bubble
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isAchievementMessage
                      ? const LinearGradient(
                          colors: [Color(0xFF2B2108), Color(0xFF1E1E1E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isAchievementMessage
                      ? null
                      : (isMe
                          ? const Color(0xFF1F8B24) // WhatsApp green
                          : const Color(0xFF2A2A2A)), // Dark gray
                  border: isAchievementMessage
                      ? Border.all(color: const Color(0xFFB8860B), width: 1.2)
                      : null,
                  boxShadow: isAchievementMessage
                      ? const [
                          BoxShadow(
                            color: Color(0x55291606),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft: Radius.circular(isMe ? 12 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sender info (for group chats)
                    if (showSenderInfo && !isMe && senderName != null) ...[
                      Row(
                        children: [
                          GestureDetector(
                            onTap: senderId != null ? openSenderProfile : null,
                            child: Text(
                              senderName!,
                              style: TextStyle(
                                color: _getColorForName(senderName!),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (senderRank != null) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                '★ $senderRank',
                                style: const TextStyle(
                                  color: Color(0xFFFFD700),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],

                    if (isAchievementMessage) ...[
                      _buildAchievementHeader(cleanedMessage),
                      const SizedBox(height: 8),
                    ],
                    
                    // Message text
                    if (achievementMeta != null) ...[
                      _buildAchievementBadgePreview(achievementMeta),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      cleanedMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    
                    // Time and checkmarks
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style: TextStyle(
                            color: isMe 
                              ? Colors.white70 
                              : Colors.grey[400],
                            fontSize: 11,
                          ),
                        ),
                        // WhatsApp-style checkmarks (only for sent messages)
                        if (isMe && isRead != null) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: isRead! 
                              ? const Color(0xFF53BDEB) // Blue when read
                              : Colors.white70, // Gray when delivered but unread
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    if (senderName == null) return Colors.grey[800]!;
    
    final colors = [
      const Color(0xFF1F8B24), // Green
      const Color(0xFF0088CC), // Blue
      const Color(0xFFE91E63), // Pink
      const Color(0xFFFF9800), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF009688), // Teal
      const Color(0xFFF44336), // Red
      const Color(0xFF795548), // Brown
    ];
    
    final hash = senderName!.codeUnits.fold(0, (sum, unit) => sum + unit);
    return colors[hash % colors.length];
  }

  _AchievementMeta? _parseAchievementMeta(String rawMessage) {
    final match = RegExp(r'\[\[achievement:([a-z_]+)/([a-z0-9_]+)\]\]').firstMatch(rawMessage);
    if (match == null) return null;

    final category = match.group(1);
    final id = match.group(2);
    if (category == null || id == null) return null;

    return _AchievementMeta(category: category, id: id);
  }

  String _stripAchievementMeta(String rawMessage) {
    return rawMessage
        .replaceAll(RegExp(r'\n?\[\[achievement:[a-z_]+/[a-z0-9_]+\]\]\n?'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  Widget _buildAchievementBadgePreview(_AchievementMeta meta) {
    final assetPath = 'assets/images/achievements/badges/${meta.category}/${meta.id}.png';
    final legacyAssetPath = 'assets/images/achievements/badges/${meta.id}.png';

    return Container(
      width: 72,
      height: 78,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white24),
      ),
      alignment: Alignment.center,
      child: Image.asset(
        assetPath,
        width: 64,
        height: 70,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          legacyAssetPath,
          width: 64,
          height: 70,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.emoji_events,
            color: Color(0xFFFFD700),
            size: 34,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementHeader(String cleanedMessage) {
    final isNl = cleanedMessage.contains('Prestatie') || cleanedMessage.contains('Beloning');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x33FFD54F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x66FFD54F)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 16),
          const SizedBox(width: 6),
          Text(
            isNl ? 'Prestatie Vrijgespeeld' : 'Achievement Unlocked',
            style: const TextStyle(
              color: Color(0xFFFFE082),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  /// Generate consistent color for sender name
  Color _getColorForName(String name) {
    final colors = [
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFFFF9800), // Orange
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF4CAF50), // Green
      const Color(0xFFE91E63), // Pink
      const Color(0xFF2196F3), // Blue
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF009688), // Teal
    ];
    
    final hash = name.codeUnits.fold(0, (sum, unit) => sum + unit);
    return colors[hash % colors.length];
  }
}

class _AchievementMeta {
  final String category;
  final String id;

  const _AchievementMeta({required this.category, required this.id});
}

/// Input field for sending messages
class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool enabled;
  final String? hint;

  const MessageInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.enabled = true,
    this.hint,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: widget.controller,
                enabled: widget.enabled,
                maxLines: null,
                maxLength: 1000,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: widget.hint ?? 'Typ een bericht...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: _hasText 
              ? const Color(0xFF1F8B24) 
              : Colors.grey[700],
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: _hasText && widget.enabled ? widget.onSend : null,
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.send,
                  color: _hasText ? Colors.white : Colors.grey[400],
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
