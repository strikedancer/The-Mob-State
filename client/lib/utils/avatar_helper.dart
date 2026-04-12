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

  static ImageProvider<Object> getAvatarImageProvider(String? avatar) {
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
