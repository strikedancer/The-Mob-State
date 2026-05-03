import 'package:flutter/material.dart';

import 'training_hub_screen.dart';

/// Legacy route: gym and shooting range are combined in [TrainingHubScreen].
class ShootingRangeScreen extends StatelessWidget {
  const ShootingRangeScreen({super.key});

  @override
  Widget build(BuildContext context) => const TrainingHubScreen();
}
