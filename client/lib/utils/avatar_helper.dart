/// Helper functions for avatar images
class AvatarHelper {
  /// Get the asset path for an avatar
  /// Returns the path to the local avatar image
  static String getAvatarPath(String? avatar) {
    if (avatar == null || avatar.isEmpty) {
      return 'images/avatars/default_1.png';
    }

    // If it's a valid avatar name, return the asset path
    return 'images/avatars/$avatar.png';
  }

  /// Check if an avatar exists (has a non-empty name)
  static bool hasAvatar(String? avatar) {
    return avatar != null && avatar.isNotEmpty;
  }
}
