import 'package:shared_preferences/shared_preferences.dart';

/// Persisted Workers-tab layout on the prostitution hub.
enum ProstitutionWorkersLayout {
  list,
  grid4,
  grid7;

  static const storageKey = 'prostitution_workers_layout_v1';

  static ProstitutionWorkersLayout fromStorage(String? raw) {
    switch (raw) {
      case 'list':
        return ProstitutionWorkersLayout.list;
      case 'grid4':
        return ProstitutionWorkersLayout.grid4;
      case 'grid7':
        return ProstitutionWorkersLayout.grid7;
      default:
        return ProstitutionWorkersLayout.grid4;
    }
  }

  String get storageValue {
    switch (this) {
      case ProstitutionWorkersLayout.list:
        return 'list';
      case ProstitutionWorkersLayout.grid4:
        return 'grid4';
      case ProstitutionWorkersLayout.grid7:
        return 'grid7';
    }
  }

  /// Desired columns for grid modes; `null` means list (full-width cards).
  int? get preferredColumns {
    switch (this) {
      case ProstitutionWorkersLayout.list:
        return null;
      case ProstitutionWorkersLayout.grid4:
        return 4;
      case ProstitutionWorkersLayout.grid7:
        return 7;
    }
  }
}

class ProstitutionWorkersLayoutPrefs {
  static Future<ProstitutionWorkersLayout> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ProstitutionWorkersLayout.fromStorage(prefs.getString(ProstitutionWorkersLayout.storageKey));
  }

  static Future<void> save(ProstitutionWorkersLayout layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ProstitutionWorkersLayout.storageKey, layout.storageValue);
  }
}
