import 'package:flutter/material.dart';

/// Custom widget to render FontAwesome Duotone icons with two colors
/// 
/// Creates a layered duotone effect by stacking the same icon with different
/// colors and blend modes to simulate FontAwesome's duotone styling.
class FontAwesomeDuotoneIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color primaryColor;
  final Color secondaryColor;

  const FontAwesomeDuotoneIcon({
    super.key,
    required this.icon,
    this.size = 24,
    required this.primaryColor,
    Color? secondaryColor,
  }) : secondaryColor = secondaryColor ?? primaryColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Base layer - full icon in secondary color (lighter)
          Icon(
            icon,
            size: size,
            color: secondaryColor,
          ),
          // Top layer - same icon in primary color with reduced opacity
          // Creating a gradient effect
          Opacity(
            opacity: 0.6,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primaryColor,
                    primaryColor.withOpacity(0.7),
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcATop,
              child: Icon(
                icon,
                size: size,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
