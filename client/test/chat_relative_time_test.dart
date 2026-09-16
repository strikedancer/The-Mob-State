import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game_client/utils/chat_relative_time.dart';

void main() {
  tearDown(ServerClock.debugReset);

  test('fresh UTC timestamp is Nu', () {
    final now = DateTime.utc(2026, 9, 16, 10);
    expect(formatChatRelativeTime(now.toIso8601String(), now: now), 'Nu');
  });

  test('naive timestamp is treated as UTC', () {
    final now = DateTime.utc(2026, 9, 16, 10, 10);
    expect(formatChatRelativeTime('2026-09-16T10:05:00.000', now: now), '5m');
  });

  test('device clock 51 minutes ahead is corrected after server sync', () {
    final serverNow = DateTime.utc(2026, 9, 16, 10);
    final clientNow = DateTime.utc(2026, 9, 16, 10, 51);
    expect(
      formatChatRelativeTime(serverNow.toIso8601String(), now: clientNow),
      '51m',
    );
    ServerClock.debugReset(now: () => clientNow);
    ServerClock.syncFromIso(serverNow.toIso8601String());
    expect(formatChatRelativeTime(serverNow.toIso8601String()), 'Nu');
  });
}
