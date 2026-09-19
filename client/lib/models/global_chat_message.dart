import '../utils/chat_relative_time.dart';

class GlobalChatMessage {
  final int id;
  final int? playerId;
  final String displayName;
  final String source;
  final String message;
  final String? stickerId;
  final String? stickerEmoji;
  final String createdAt;
  final String? staffRole;
  final bool silent;

  const GlobalChatMessage({
    required this.id,
    required this.playerId,
    required this.displayName,
    required this.source,
    required this.message,
    required this.stickerId,
    required this.stickerEmoji,
    required this.createdAt,
    this.staffRole,
    this.silent = false,
  });

  factory GlobalChatMessage.fromJson(Map<String, dynamic> json) {
    final source = json['source'] as String? ?? 'game';
    return GlobalChatMessage(
      id: (json['id'] as num).toInt(),
      playerId: json['playerId'] == null ? null : (json['playerId'] as num).toInt(),
      displayName: json['displayName'] as String? ?? '',
      source: source,
      message: json['message'] as String? ?? '',
      stickerId: json['stickerId'] as String?,
      stickerEmoji: json['stickerEmoji'] as String?,
      createdAt: json['createdAt'] as String? ?? '',
      staffRole: json['staffRole'] as String?,
      silent: json['silent'] == true || source == 'system',
    );
  }

  bool get isStaff => staffRole == 'MOD' || staffRole == 'OPS';

  bool get isSystem => source == 'system';

  String get formattedTime => formatChatRelativeTime(createdAt);
}
