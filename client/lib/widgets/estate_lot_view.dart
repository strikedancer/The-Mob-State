import 'package:flutter/material.dart';

/// Composites one estate lot image from independently upgradeable layers.
///
/// Levels are 1..10. The player always sees a single stacked view:
/// fixed grass base + fence + shed + house + parking.
class EstateLotView extends StatelessWidget {
  final int houseLevel;
  final int parkingLevel;
  final int shedLevel;
  final int fenceLevel;
  final BoxFit fit;

  static const int minLevel = 1;
  static const int maxLevel = 10;

  const EstateLotView({
    super.key,
    this.houseLevel = 1,
    this.parkingLevel = 1,
    this.shedLevel = 1,
    this.fenceLevel = 1,
    this.fit = BoxFit.contain,
  });

  static String _pad(int level) => level.clamp(minLevel, maxLevel).toString().padLeft(2, '0');

  static String houseAsset(int level) =>
      'assets/images/homes/estate_lot/house/house_${_pad(level)}.png';

  static String parkingAsset(int level) =>
      'assets/images/homes/estate_lot/parking/parking_${_pad(level)}.png';

  static String shedAsset(int level) =>
      'assets/images/homes/estate_lot/shed/shed_${_pad(level)}.png';

  static String fenceAsset(int level) =>
      'assets/images/homes/estate_lot/fence/fence_${_pad(level)}.png';

  static const String baseAsset =
      'assets/images/homes/estate_lot/base_grass.png';

  @override
  Widget build(BuildContext context) {
    // Painter order: base → back structures → house → front parking → fence overlay
    final layers = <String>[
      baseAsset,
      shedAsset(shedLevel),
      houseAsset(houseLevel),
      parkingAsset(parkingLevel),
      fenceAsset(fenceLevel),
    ];

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final asset in layers)
            Image.asset(
              asset,
              fit: fit,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
        ],
      ),
    );
  }
}
