import 'package:flutter/material.dart';

import 'web_asset_helper.dart';

/// Helper functions for avatar images
class AvatarHelper {
  /// Get the bundled asset path for an avatar.
  static String getAvatarPath(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return 'assets/images/avatars/default_1.png';
    }

    return 'assets/images/avatars/$avatar.png';
  }

  static String getAvatarUrl(String? avatar) {
    return WebAssetHelper.toPublicUrl(getAvatarPath(avatar));
  }

  /// [activePortraitPath] is relative under `/images/` (e.g. `player_avatars/5/uuid.png`).
  static ImageProvider<Object> getAvatarImageProvider(
    String? avatar, {
    String? activePortraitPath,
  }) {
    final custom = activePortraitPath?.trim();
    if (custom != null && custom.isNotEmpty) {
      if (custom.startsWith('http://') || custom.startsWith('https://')) {
        return NetworkImage(custom);
      }
      final url = WebAssetHelper.toPublicUrl('assets/images/$custom');
      return NetworkImage(url);
    }

    if (avatar != null &&
        avatar.isNotEmpty &&
        (avatar.startsWith('http://') || avatar.startsWith('https://'))) {
      return NetworkImage(avatar);
    }

    return WebAssetHelper.provider(getAvatarPath(avatar));
  }

  /// Check if an avatar exists (has a non-empty name)
  static bool hasAvatar(String? avatar) {
    return avatar != null && avatar.isNotEmpty;
  }
}
