class GlobalChatMessage {
  final int id;
  final int? playerId;
  final String displayName;
  final String source;
  final String message;
  final String? stickerId;
  final String? stickerEmoji;
  final String createdAt;

  const GlobalChatMessage({
    required this.id,
    required this.playerId,
    required this.displayName,
    required this.source,
    required this.message,
    required this.stickerId,
    required this.stickerEmoji,
    required this.createdAt,
  });

  factory GlobalChatMessage.fromJson(Map<String, dynamic> json) {
    return GlobalChatMessage(
      id: (json['id'] as num).toInt(),
      playerId: json['playerId'] == null ? null : (json['playerId'] as num).toInt(),
      displayName: json['displayName'] as String? ?? '',
      source: json['source'] as String? ?? 'game',
      message: json['message'] as String? ?? '',
      stickerId: json['stickerId'] as String?,
      stickerEmoji: json['stickerEmoji'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  bool get isSystem => source == 'system';

  String get formattedTime {
    try {
      final dateTime = DateTime.parse(createdAt).toLocal();
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      if (difference.inMinutes < 1) return 'Nu';
      if (difference.inMinutes < 60) return '${difference.inMinutes}m';
      if (difference.inHours < 24) return '${difference.inHours}u';
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
