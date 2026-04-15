import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String _supportTicketSeenSignaturesKey =
    'support_ticket_seen_signatures_v1';

String buildSupportTicketSeenSignature({
  required DateTime updatedAt,
  required String status,
  String? lastMessageBy,
}) {
  return '${updatedAt.millisecondsSinceEpoch}|$status|${lastMessageBy ?? 'none'}';
}

Future<Map<String, String>> loadSupportTicketSeenSignatures() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_supportTicketSeenSignaturesKey);
  if (raw == null || raw.isEmpty) {
    return const {};
  }

  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      return const {};
    }

    return decoded.map<String, String>(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
    );
  } catch (_) {
    return const {};
  }
}

Future<void> markSupportTicketSignaturesSeen(
  Map<int, String> currentSignatures,
) async {
  final prefs = await SharedPreferences.getInstance();
  final serializable = currentSignatures.map<String, String>(
    (key, value) => MapEntry(key.toString(), value),
  );
  await prefs.setString(
    _supportTicketSeenSignaturesKey,
    jsonEncode(serializable),
  );
}

Future<int> countUnseenSupportTicketUpdates(
  Map<int, String> currentSignatures, {
  bool initializeIfEmpty = false,
}) async {
  final seenSignatures = await loadSupportTicketSeenSignatures();

  if (seenSignatures.isEmpty && initializeIfEmpty) {
    await markSupportTicketSignaturesSeen(currentSignatures);
    return 0;
  }

  var unseenCount = 0;
  for (final entry in currentSignatures.entries) {
    if (seenSignatures[entry.key.toString()] != entry.value) {
      unseenCount += 1;
    }
  }
  return unseenCount;
}
