import 'package:shared_preferences/shared_preferences.dart';

/// Persisted list / 4-across / 7-across layout for collection-style grids.
enum CollectionViewLayout {
  list,
  grid4,
  grid7;

  static CollectionViewLayout fromStorage(String? raw) {
    switch (raw) {
      case 'list':
        return CollectionViewLayout.list;
      case 'grid4':
        return CollectionViewLayout.grid4;
      case 'grid7':
        return CollectionViewLayout.grid7;
      default:
        return CollectionViewLayout.grid4;
    }
  }

  String get storageValue {
    switch (this) {
      case CollectionViewLayout.list:
        return 'list';
      case CollectionViewLayout.grid4:
        return 'grid4';
      case CollectionViewLayout.grid7:
        return 'grid7';
    }
  }

  /// Desired columns for grid modes; `null` means list (row layout).
  int? get preferredColumns {
    switch (this) {
      case CollectionViewLayout.list:
        return null;
      case CollectionViewLayout.grid4:
        return 4;
      case CollectionViewLayout.grid7:
        return 7;
    }
  }
}

class CollectionViewLayoutPrefs {
  static Future<CollectionViewLayout> load(String storageKey) async {
    final prefs = await SharedPreferences.getInstance();
    return CollectionViewLayout.fromStorage(prefs.getString(storageKey));
  }

  static Future<void> save(String storageKey, CollectionViewLayout layout) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, layout.storageValue);
  }
}
