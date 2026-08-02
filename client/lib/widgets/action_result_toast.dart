import 'package:flutter/material.dart';

import '../utils/top_right_notification.dart';

/// Lightweight shared result feedback for jobs/school (not crime overlay).
void showActionResultToast(
  BuildContext context, {
  required String title,
  String? moneyDelta,
  String? xpDelta,
  String? cooldownLine,
  bool success = true,
}) {
  final parts = <String>[title];
  if (moneyDelta != null && moneyDelta.isNotEmpty) {
    parts.add(moneyDelta);
  }
  if (xpDelta != null && xpDelta.isNotEmpty) {
    parts.add(xpDelta);
  }
  if (cooldownLine != null && cooldownLine.isNotEmpty) {
    parts.add(cooldownLine);
  }

  showTopRightFromSnackBar(
    context,
    SnackBar(
      content: Text(parts.join(' · ')),
      backgroundColor: success ? Colors.green : Colors.red,
    ),
  );
}
