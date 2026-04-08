class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final String requirementType;
  final int requirementValue;
  final int? rewardMoney;
  final int? rewardXp;
  final String icon;
  final bool unlocked;
  final DateTime? unlockedAt;
  final Map<String, dynamic>? achievementData;
  final int currentValue;
  final int progressPercent;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.requirementType,
    required this.requirementValue,
    this.rewardMoney,
    this.rewardXp,
    required this.icon,
    this.unlocked = false,
    this.unlockedAt,
    this.achievementData,
    this.currentValue = 0,
    this.progressPercent = 0,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'legacy',
      requirementType: (json['requirementType'] as String?) ?? 'unknown',
      requirementValue: (json['requirementValue'] as num?)?.toInt() ?? 0,
      rewardMoney: (json['rewardMoney'] as num?)?.toInt(),
      rewardXp: (json['rewardXp'] as num?)?.toInt(),
      icon: json['icon'] as String,
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      achievementData: json['achievementData'] as Map<String, dynamic>?,
      currentValue: (json['currentValue'] as num?)?.toInt() ?? 0,
      progressPercent: (json['progressPercent'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'requirementType': requirementType,
      'requirementValue': requirementValue,
      'rewardMoney': rewardMoney,
      'rewardXp': rewardXp,
      'icon': icon,
      'unlocked': unlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'achievementData': achievementData,
      'currentValue': currentValue,
      'progressPercent': progressPercent,
    };
  }

  // Helper to get category name
  String get categoryName {
    switch (category) {
      case 'progression':
        return 'Progression';
      case 'prostitution':
        return 'Prostitutie';
      case 'rld':
        return 'RLD';
      case 'crimes':
        return 'Crimes';
      case 'jobs':
        return 'Werk';
      case 'vehicles':
        return 'Voertuigen';
      case 'travel':
        return 'Reizen';
      case 'drugs':
        return 'Drugs';
      case 'trade':
        return 'Handel';
      case 'wealth':
        return 'Wealth';
      case 'power':
        return 'Power';
      case 'social':
        return 'Social';
      case 'mastery':
        return 'Mastery';
      default:
        return 'General';
    }
  }

  // Helper to get formatted rewards
  String get rewardText {
    final List<String> rewards = [];
    if (rewardMoney != null && rewardMoney! > 0) {
      rewards.add('€${_formatNumber(rewardMoney!)}');
    }
    if (rewardXp != null && rewardXp! > 0) {
      rewards.add('${_formatNumber(rewardXp!)} XP');
    }
    return rewards.isEmpty ? 'No rewards' : rewards.join(' + ');
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class PlayerAchievementProgress {
  final List<Achievement> achievements;
  final int totalAchievements;
  final int unlockedCount;
  final int progress; // 0-100%

  PlayerAchievementProgress({
    required this.achievements,
    required this.totalAchievements,
    required this.unlockedCount,
    required this.progress,
  });

  factory PlayerAchievementProgress.fromJson(Map<String, dynamic> json) {
    final List<dynamic> achievementsJson =
        (json['achievements'] as List<dynamic>?) ?? const [];
    final achievements = achievementsJson
        .map((a) => Achievement.fromJson(a))
        .toList();

    return PlayerAchievementProgress(
      achievements: achievements,
      totalAchievements: (json['totalAchievements'] as num?)?.toInt() ?? 0,
      unlockedCount: (json['unlockedCount'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
    );
  }

  // Get achievements by category
  List<Achievement> achievementsByCategory(String category) {
    return achievements.where((a) => a.category == category).toList();
  }

  // Get unlocked achievements
  List<Achievement> get unlockedAchievements {
    return achievements.where((a) => a.unlocked).toList();
  }

  // Get locked achievements
  List<Achievement> get lockedAchievements {
    return achievements.where((a) => !a.unlocked).toList();
  }

  // Get all categories
  List<String> get categories {
    return achievements.map((a) => a.category).toSet().toList()..sort();
  }
}
