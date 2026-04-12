import 'package:flutter/material.dart';

/// A widget that displays a base image with optional overlay images composited on top.
/// 
/// This is useful for showing states like:
/// - Damaged vehicles (damaged.png overlay)
/// - Locked items (locked.png overlay)
/// - Upgraded properties (upgraded.png overlay)
/// - In-transit vehicles (in_transit.png overlay)
/// 
/// All images should have the same dimensions for proper alignment.
/// 
/// Example:
/// ```dart
/// OverlayImage(
///   base: 'assets/images/vehicles/toyota_corolla.png',
///   overlays: ['assets/images/overlays/vehicles/damaged.png'],
///   width: 200,
///   height: 150,
/// )
/// ```
class OverlayImage extends StatelessWidget {
  /// Path to the base image
  final String base;
  
  /// List of overlay image paths to composite on top of the base image
  final List<String> overlays;
  
  /// Width of the image (all layers will use this width)
  final double? width;
  
  /// Height of the image (all layers will use this height)
  final double? height;
  
  /// How the image should be fitted
  final BoxFit fit;
  
  /// Border radius for rounded corners
  final BorderRadius? borderRadius;
  
  /// Opacity of overlay images (0.0 - 1.0)
  final double overlayOpacity;

  const OverlayImage({
    super.key,
    required this.base,
    this.overlays = const [],
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.overlayOpacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Build list of image layers
    final List<Widget> layers = [
      // Base image
      Image.asset(
        base,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.grey),
            ),
          );
        },
      ),
    ];

    // Add overlay images
    for (final overlay in overlays) {
      layers.add(
        Opacity(
          opacity: overlayOpacity,
          child: Image.asset(
            overlay,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              // If overlay fails to load, just skip it
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    }

    Widget imageStack = Stack(
      children: layers,
    );

    // Apply border radius if specified
    if (borderRadius != null) {
      imageStack = ClipRRect(
        borderRadius: borderRadius!,
        child: imageStack,
      );
    }

    return imageStack;
  }
}

/// Extension to easily add common vehicle overlays
extension VehicleOverlays on String {
  /// Returns the path with damaged overlay
  static String damaged = 'assets/images/overlays/vehicles/damaged.png';
  
  /// Returns the path with locked overlay
  static String locked = 'assets/images/overlays/vehicles/locked.png';
  
  /// Returns the path with upgraded overlay
  static String upgraded = 'assets/images/overlays/vehicles/upgraded.png';
  
  /// Returns the path with in-transit overlay
  static String inTransit = 'assets/images/overlays/vehicles/in_transit.png';
}

/// Helper class for building overlay image configurations
class OverlayImageBuilder {
  String _base = '';
  final List<String> _overlays = [];
  double? _width;
  double? _height;
  BoxFit _fit = BoxFit.cover;
  BorderRadius? _borderRadius;
  double _overlayOpacity = 1.0;

  /// Set the base image path
  OverlayImageBuilder base(String path) {
    _base = path;
    return this;
  }

  /// Add an overlay
  OverlayImageBuilder addOverlay(String path) {
    _overlays.add(path);
    return this;
  }

  /// Add damaged overlay if condition is met
  OverlayImageBuilder damaged({bool when = true}) {
    if (when) {
      _overlays.add(VehicleOverlays.damaged);
    }
    return this;
  }

  /// Add locked overlay if condition is met
  OverlayImageBuilder locked({bool when = true}) {
    if (when) {
      _overlays.add(VehicleOverlays.locked);
    }
    return this;
  }

  /// Add upgraded overlay if condition is met
  OverlayImageBuilder upgraded({bool when = true}) {
    if (when) {
      _overlays.add(VehicleOverlays.upgraded);
    }
    return this;
  }

  /// Add in-transit overlay if condition is met
  OverlayImageBuilder inTransit({bool when = true}) {
    if (when) {
      _overlays.add(VehicleOverlays.inTransit);
    }
    return this;
  }

  /// Set the width
  OverlayImageBuilder width(double w) {
    _width = w;
    return this;
  }

  /// Set the height
  OverlayImageBuilder height(double h) {
    _height = h;
    return this;
  }

  /// Set the box fit
  OverlayImageBuilder fit(BoxFit f) {
    _fit = f;
    return this;
  }

  /// Set border radius
  OverlayImageBuilder borderRadius(BorderRadius radius) {
    _borderRadius = radius;
    return this;
  }

  /// Set overlay opacity
  OverlayImageBuilder overlayOpacity(double opacity) {
    _overlayOpacity = opacity;
    return this;
  }

  /// Build the OverlayImage widget
  OverlayImage build() {
    return OverlayImage(
      base: _base,
      overlays: _overlays,
      width: _width,
      height: _height,
      fit: _fit,
      borderRadius: _borderRadius,
      overlayOpacity: _overlayOpacity,
    );
  }
}
