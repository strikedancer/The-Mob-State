import 'package:flutter/material.dart';

class WealthStatusHelper {
  static String getWealthStatusLabel(
    BuildContext context,
    String? wealthStatus,
  ) {
    // Simply return the wealth status as-is since localization keys don't exist
    return wealthStatus ?? '';
  }

  static String getWealthStatusIcon(String? wealthStatus) {
    switch (wealthStatus) {
      case 'Sloeber':
        return '🚫';
      case 'Ars':
        return '💸';
      case 'Modaal':
        return '💵';
      case 'Rijk':
        return '💰';
      case 'Erg Rijk':
        return '💎';
      case 'Te Rijk om Waar te Zijn':
        return '👑';
      case 'Rijker dan God':
        return '🌟';
      default:
        return '💰';
    }
  }
}
