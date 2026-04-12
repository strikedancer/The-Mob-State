import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebAssetHelper {
  static String toPublicUrl(String assetPath) {
    final normalized = assetPath.replaceAll('\\', '/');

    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return normalized;
    }

    String publicPath;
    if (normalized.startsWith('assets/images/')) {
      // Flutter web emits assets declared under assets/images/* at assets/assets/images/*.
      publicPath = 'assets/assets/images/${normalized.substring('assets/images/'.length)}';
    } else if (normalized.startsWith('images/')) {
      publicPath = 'images/${normalized.substring('images/'.length)}';
    } else if (normalized.startsWith('assets/')) {
      publicPath = normalized;
    } else {
      publicPath = normalized.startsWith('/') ? normalized.substring(1) : normalized;
    }

    return Uri.base.resolve(publicPath).toString();
  }

  static ImageProvider<Object> provider(String assetPath) {
    if (kIsWeb) {
      return NetworkImage(toPublicUrl(assetPath));
    }

    return AssetImage(assetPath);
  }

  static Widget image(
    String assetPath, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    if (kIsWeb) {
      return Image.network(
        toPublicUrl(assetPath),
        key: key,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: errorBuilder,
      );
    }

    return Image.asset(
      assetPath,
      key: key,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: errorBuilder,
    );
  }
}