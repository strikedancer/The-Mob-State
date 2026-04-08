import 'package:intl/intl.dart';

class _DurationUnitLabel {
  const _DurationUnitLabel({
    required this.years,
    required this.months,
    required this.days,
    required this.hours,
    required this.minutes,
    required this.seconds,
    required this.now,
  });

  final String years;
  final String months;
  final String days;
  final String hours;
  final String minutes;
  final String seconds;
  final String now;
}

_DurationUnitLabel _durationUnitLabel(String? localeName) {
  final normalized = (localeName ?? 'en').toLowerCase();
  if (normalized.startsWith('nl')) {
    return const _DurationUnitLabel(
      years: 'j',
      months: 'mnd',
      days: 'd',
      hours: 'u',
      minutes: 'm',
      seconds: 's',
      now: 'Nu',
    );
  }

  return const _DurationUnitLabel(
    years: 'y',
    months: 'mo',
    days: 'd',
    hours: 'h',
    minutes: 'm',
    seconds: 's',
    now: 'Now',
  );
}

/// Format currency with Euro symbol
String formatCurrency(num amount) {
  final formatter = NumberFormat.currency(symbol: '€', decimalDigits: 0);
  return formatter.format(amount);
}

/// Format large numbers with K, M, B suffixes
String formatCompactNumber(num number) {
  if (number >= 1000000000) {
    return '${(number / 1000000000).toStringAsFixed(1)}B';
  } else if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  }
  return number.toString();
}

/// Format percentage (0-100)
String formatPercentage(num percentage) {
  return '${percentage.toStringAsFixed(1)}%';
}

/// Format duration in human-readable format
String formatDuration(Duration duration) {
  return formatAdaptiveDuration(duration);
}

String formatAdaptiveDuration(
  Duration duration, {
  String? localeName,
  bool includeSeconds = true,
}) {
  final labels = _durationUnitLabel(localeName);
  var totalSeconds = duration.inSeconds;

  if (totalSeconds <= 0) {
    return labels.now;
  }

  final parts = <String>[];
  const secondsPerMinute = 60;
  const secondsPerHour = 60 * secondsPerMinute;
  const secondsPerDay = 24 * secondsPerHour;
  const secondsPerMonth = 30 * secondsPerDay;
  const secondsPerYear = 365 * secondsPerDay;

  final years = totalSeconds ~/ secondsPerYear;
  totalSeconds %= secondsPerYear;

  final months = totalSeconds ~/ secondsPerMonth;
  totalSeconds %= secondsPerMonth;

  final days = totalSeconds ~/ secondsPerDay;
  totalSeconds %= secondsPerDay;

  final hours = totalSeconds ~/ secondsPerHour;
  totalSeconds %= secondsPerHour;

  final minutes = totalSeconds ~/ secondsPerMinute;
  final seconds = totalSeconds % secondsPerMinute;

  if (years > 0) parts.add('$years${labels.years}');
  if (months > 0) parts.add('$months${labels.months}');
  if (days > 0) parts.add('$days${labels.days}');
  if (hours > 0) parts.add('$hours${labels.hours}');
  if (minutes > 0) parts.add('$minutes${labels.minutes}');
  if (includeSeconds && seconds > 0) parts.add('$seconds${labels.seconds}');

  if (parts.isEmpty) {
    return includeSeconds ? '0${labels.seconds}' : labels.now;
  }

  return parts.join(' ');
}

String formatAdaptiveDurationFromSeconds(
  int totalSeconds, {
  String? localeName,
  bool includeSeconds = true,
}) {
  return formatAdaptiveDuration(
    Duration(seconds: totalSeconds),
    localeName: localeName,
    includeSeconds: includeSeconds,
  );
}

/// Format time ago (e.g., "5 minutes ago")
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years jaar geleden';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months maanden geleden';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} dagen geleden';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} uur geleden';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minuten geleden';
  } else {
    return 'zojuist';
  }
}
