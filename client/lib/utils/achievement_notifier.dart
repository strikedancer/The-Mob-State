import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../l10n/app_localizations.dart';
import '../utils/top_right_notification.dart';

/// Shows achievement unlock notifications as overlay banners
class AchievementNotifier {
  static String _badgeFolderForCategory(String category) {
    switch (category) {
      case 'prostitution':
        return 'prostitution';
      case 'crimes':
        return 'crimes';
      case 'jobs':
        return 'jobs';
      case 'school':
        return 'school';
      case 'vehicles':
        return 'vehicles';
      case 'travel':
        return 'travel';
      case 'drugs':
        return 'drugs';
      case 'trade':
        return 'trade';
      case 'social':
        return 'social';
      case 'mastery':
        return 'mastery';
      case 'power':
        return 'power';
      default:
        return 'legacy';
    }
  }

  static Widget _buildBadgeVisual(Achievement achievement, {double size = 48}) {
    final folder = _badgeFolderForCategory(achievement.category);
    final path = 'assets/images/achievements/badges/$folder/${achievement.id}.png';
    final legacyPath = 'assets/images/achievements/badges/${achievement.id}.png';

    return Image.asset(
      path,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (_, __, ___) => Image.asset(
        legacyPath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => Text(
          achievement.icon,
          style: TextStyle(fontSize: size * 0.85),
        ),
      ),
    );
  }

  /// Show a celebration notification when an achievement is unlocked
  static void showAchievementUnlocked(
    BuildContext context,
    Achievement achievement,
  ) {
    final t = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: SafeArea(
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber.shade800, Colors.amber.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade300, width: 2),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Icon side
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: _buildBadgeVisual(achievement, size: 44),
                      ),
                    ),
                    // Divider
                    Container(
                      width: 2,
                      color: Colors.amber.shade300.withOpacity(0.5),
                    ),
                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '🏆 ',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  t.achievementUnlocked,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              achievement.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement.description,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if ((achievement.rewardMoney ?? 0) > 0) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+€${achievement.rewardMoney ?? 0}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if ((achievement.rewardXp ?? 0) > 0) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.shade700,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '+${achievement.rewardXp} XP',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Close button
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => overlayEntry.remove(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  /// Show multiple achievement notifications sequentially
  static void showMultipleAchievements(
    BuildContext context,
    List<Achievement> achievements,
  ) {
    if (achievements.isEmpty) return;

    // Show first achievement immediately
    showAchievementUnlocked(context, achievements[0]);

    // Show remaining achievements with delays
    for (int i = 1; i < achievements.length; i++) {
      Future.delayed(Duration(seconds: i * 2), () {
        if (context.mounted) {
          showAchievementUnlocked(context, achievements[i]);
        }
      });
    }
  }

  /// Show a simple snackbar notification (alternative to overlay)
  static void showAchievementSnackbar(
    BuildContext context,
    Achievement achievement,
  ) {
    final t = AppLocalizations.of(context)!;
    showTopRightFromSnackBar(context, 
      SnackBar(
        content: Row(
          children: [
            _buildBadgeVisual(achievement, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🏆 ${t.achievementUnlocked}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(achievement.title, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber.shade800,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: t.achievementsDetails,
          textColor: Colors.white,
          onPressed: () {
            // Navigate to achievements screen
            Navigator.pushNamed(context, '/achievements');
          },
        ),
      ),
    );
  }
}
