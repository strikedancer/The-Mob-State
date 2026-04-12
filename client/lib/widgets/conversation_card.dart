import 'package:flutter/material.dart';
import '../models/direct_message.dart';
import '../utils/avatar_helper.dart';

/// Card showing a conversation preview in the messages list
class ConversationCard extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;
  final VoidCallback? onAvatarTap;

  const ConversationCard({
    super.key,
    required this.conversation,
    required this.onTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSystemThread = conversation.friendId == 0;

    return Material(
      color: const Color(0xFF1E1E1E),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[800]!, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(isSystemThread),
              
              const SizedBox(width: 12),
              
              // Message info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Username
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  conversation.username,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (isSystemThread)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6B4E00),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.emoji_events,
                                        color: Color(0xFFFFD700),
                                        size: 12,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'SYSTEEM',
                                        style: TextStyle(
                                          color: Color(0xFFFFE082),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xFFFFD700),
                                        size: 12,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        '${conversation.rank}',
                                        style: const TextStyle(
                                          color: Color(0xFFFFD700),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Time
                        Text(
                          conversation.formattedTime,
                          style: TextStyle(
                            color: conversation.unreadCount > 0
                              ? const Color(0xFF1F8B24)
                              : Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Last message + badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isSystemThread
                                ? 'Achievement en systeemberichten'
                                : (conversation.lastMessage ?? 'Nog geen berichten'),
                            style: TextStyle(
                              color: conversation.unreadCount > 0
                                ? Colors.white
                                : Colors.grey[400],
                              fontSize: 14,
                              fontWeight: conversation.unreadCount > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // Unread badge
                        if (conversation.unreadCount > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFF1F8B24),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              conversation.unreadCount > 99 
                                ? '99+' 
                                : '${conversation.unreadCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isSystemThread) {
    final avatarWidget = isSystemThread
        ? Container(
            width: 50,
            height: 50,
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
              size: 26,
            ),
          )
        : Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[800],
              image: DecorationImage(
                image: AssetImage(AvatarHelper.getAvatarPath(conversation.avatar)),
                fit: BoxFit.cover,
              ),
            ),
          );

    if (isSystemThread || onAvatarTap == null) {
      return avatarWidget;
    }

    return GestureDetector(
      onTap: onAvatarTap,
      child: avatarWidget,
    );
  }
}
