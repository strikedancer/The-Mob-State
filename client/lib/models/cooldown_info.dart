/// Model representing a cooldown state for an action
class CooldownInfo {
  final String actionType; // 'crime', 'job', 'travel', 'heist', 'appeal'
  final int remainingSeconds;
  final DateTime expiresAt;

  CooldownInfo({
    required this.actionType,
    required this.remainingSeconds,
  }) : expiresAt = DateTime.now().add(Duration(seconds: remainingSeconds));

  /// Get the display name for the action type (localized)
  String getActionName(String locale) {
    final names = {
      'crime': locale == 'nl' ? 'Misdaad' : 'Crime',
      'job': locale == 'nl' ? 'Werk' : 'Job',
      'travel': locale == 'nl' ? 'Reizen' : 'Travel',
      'heist': locale == 'nl' ? 'Overval' : 'Heist',
      'appeal': locale == 'nl' ? 'Hoger Beroep' : 'Appeal',
      'school': locale == 'nl' ? 'Opleiding' : 'School',
    };
    return names[actionType] ?? actionType;
  }

  /// Get the cartoon image path for this action type
  String getImagePath() {
    final images = {
      'crime': 'assets/images/cooldown_crimes.png',
      'job': 'assets/images/cooldown_jobs.png',
      'travel': 'assets/images/cooldown_airfield.png',
      'heist': 'assets/images/cooldown_crimes.png',
      'appeal': 'assets/images/cooldown_jail.png',
      'school': 'assets/images/cooldown_school.png',
    };
    // Default to crime image if action type not found
    return images[actionType] ?? 'assets/images/cooldown_crimes.png';
  }

  /// Get the icon for this action type
  String getIcon() {
    final icons = {
      'crime': '⚠️',
      'job': '💼',
      'travel': '✈️',
      'heist': '💰',
      'appeal': '⚖️',
      'school': '📚',
    };
    return icons[actionType] ?? '⏳';
  }
}
