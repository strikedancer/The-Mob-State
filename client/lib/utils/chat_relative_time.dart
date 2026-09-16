/// Relative chat labels ("Nu", "5m") must follow server time, not the device clock.
class ServerClock {
  static Duration _offset = Duration.zero;
  static DateTime Function() _now = DateTime.now;

  static void syncFromIso(String? iso) {
    final parsed = parseServerInstant(iso);
    if (parsed == null) return;
    _offset = _now().toUtc().difference(parsed);
  }

  static DateTime nowUtc() => _now().toUtc().subtract(_offset);

  static void debugReset({
    DateTime Function()? now,
    Duration offset = Duration.zero,
  }) {
    _now = now ?? DateTime.now;
    _offset = offset;
  }
}

DateTime? parseServerInstant(String? raw) {
  final s = (raw ?? '').trim();
  if (s.isEmpty) return null;
  final hasZone = s.endsWith('Z') ||
      s.endsWith('z') ||
      RegExp(r'[+-]\d{2}:\d{2}$').hasMatch(s) ||
      RegExp(r'[+-]\d{4}$').hasMatch(s);
  final withTime = s.contains('T') ? s : s.replaceFirst(' ', 'T');
  final normalized = hasZone ? withTime : '${withTime}Z';
  return DateTime.tryParse(normalized)?.toUtc();
}

enum ChatRelativeStyle { world, thread }

String formatChatRelativeTime(
  String createdAt, {
  DateTime? now,
  ChatRelativeStyle style = ChatRelativeStyle.world,
}) {
  final at = parseServerInstant(createdAt);
  if (at == null) return '';
  final current = (now ?? ServerClock.nowUtc()).toUtc();
  final difference = current.difference(at);
  if (difference.isNegative || difference.inMinutes < 1) return 'Nu';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m';
  if (difference.inHours < 24) return '${difference.inHours}u';
  final local = at.toLocal();
  if (style == ChatRelativeStyle.thread) {
    if (difference.inDays < 7) return '${difference.inDays}d';
    return '${local.day}/${local.month}';
  }
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
}
