import 'package:shared_preferences/shared_preferences.dart';

/// When `true`, the "spend credits to skip theft cooldown" confirm dialog is skipped
/// and redeem runs immediately. Reversible in Settings.
class TheftCooldownConfirmPrefs {
  static const _k = 'skip_theft_cooldown_credit_confirm_v1';

  static Future<bool> get skipConfirmDialog async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_k) ?? false;
  }

  static Future<void> setSkipConfirmDialog(bool value) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_k, value);
  }
}
