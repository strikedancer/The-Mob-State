import 'package:shared_preferences/shared_preferences.dart';

const _pendingReferralKey = 'pending_referral_code';

class ReferralInviteStore {
  static String? normalize(String? raw) {
    final code = (raw ?? '').trim().toUpperCase();
    if (code.length < 4 || code.length > 12) return null;
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(code)) return null;
    return code;
  }

  static Future<void> captureFromUri(Uri uri) async {
    final code = normalize(uri.queryParameters['ref']);
    if (code == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pendingReferralKey, code);
  }

  static Future<String?> peek() async {
    final prefs = await SharedPreferences.getInstance();
    return normalize(prefs.getString(_pendingReferralKey));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_pendingReferralKey);
  }
}
