import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WebAssetHelper {
  static String _normalize(String value) => value.replaceAll('\\', '/');

  static String normalizeAssetPath(String assetPath) {
    var path = _normalize(assetPath).trim();
    if (path.isEmpty) return path;

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    if (path.contains('assets/assets/images/')) {
      final idx = path.indexOf('assets/assets/images/');
      final suffix = path.substring(idx + 'assets/assets/images/'.length);
      path = 'assets/images/$suffix';
    } else if (path.contains('assets/images/')) {
      final idx = path.indexOf('assets/images/');
      path = path.substring(idx);
    } else if (path.startsWith('images/')) {
      path = 'assets/images/${path.substring('images/'.length)}';
    }

    if (path.startsWith('assets/images/')) {
      final suffix = path.substring('assets/images/'.length).replaceAll(
        'assets/images/',
        '',
      );
      path = 'assets/images/$suffix';

      for (final dir in const [
        'vehicles',
        'drugs',
        'facilities',
        'backgrounds',
        'avatars',
        'jobs',
        'weapons',
        'tools',
        'travel',
      ]) {
        while (path.contains('/$dir/$dir/')) {
          path = path.replaceAll('/$dir/$dir/', '/$dir/');
        }
      }
    }

    return path;
  }

  static String _trimLeadingSlash(String value) {
    if (value.startsWith('/')) {
      return value.substring(1);
    }
    return value;
  }

  static String _stripAssetsImagesPrefix(String assetPath) {
    final normalized = normalizeAssetPath(assetPath);
    if (normalized.startsWith('assets/images/')) {
      return normalized.substring('assets/images/'.length);
    }
    if (normalized.startsWith('assets/assets/images/')) {
      return normalized.substring('assets/assets/images/'.length);
    }
    if (normalized.startsWith('images/')) {
      return normalized.substring('images/'.length);
    }
    if (normalized.startsWith('/images/')) {
      return normalized.substring('/images/'.length);
    }
    return _trimLeadingSlash(normalized);
  }

  static String _resolveRelative(String path) {
    return Uri.base.resolve(_trimLeadingSlash(path)).toString();
  }

  static List<String> _webImageUrlCandidates(String assetPath) {
    final normalized = normalizeAssetPath(assetPath);
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return [normalized];
    }

    final suffix = _stripAssetsImagesPrefix(assetPath);
    return [
      _resolveRelative('images/$suffix'),
      _resolveRelative('assets/assets/images/$suffix'),
      _resolveRelative('assets/images/$suffix'),
    ];
  }

  static String toPublicUrl(String assetPath) {
    final normalized = normalizeAssetPath(assetPath);

    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return normalized;
    }

    String publicPath;
    if (normalized.startsWith('assets/images/')) {
      // Route image requests through /images so nginx can serve from Flutter's bundled image directory.
      publicPath = 'images/${normalized.substring('assets/images/'.length)}';
    } else if (normalized.startsWith('assets/assets/images/')) {
      publicPath = 'images/${normalized.substring('assets/assets/images/'.length)}';
    } else if (normalized.startsWith('images/')) {
      publicPath = 'images/${normalized.substring('images/'.length)}';
    } else if (normalized.startsWith('assets/')) {
      publicPath = normalized;
    } else {
      publicPath = normalized.startsWith('/') ? normalized.substring(1) : normalized;
    }

    return _resolveRelative(publicPath);
  }

  static ImageProvider<Object> provider(String assetPath) {
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
    final normalizedPath = normalizeAssetPath(assetPath);

    if (kIsWeb) {
      return Image.asset(
        normalizedPath,
        key: key,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          final candidates = _webImageUrlCandidates(normalizedPath);

          Widget buildCandidate(int index) {
            return Image.network(
              candidates[index],
              key: key,
              width: width,
              height: height,
              fit: fit,
              alignment: alignment,
              errorBuilder: (ctx, err, st) {
                if (index + 1 < candidates.length) {
                  return buildCandidate(index + 1);
                }
                if (errorBuilder != null) {
                  return errorBuilder(ctx, err, st);
                }
                return const SizedBox.shrink();
              },
            );
          }

          return buildCandidate(0);
        },
      );
    }

    return Image.asset(
      normalizedPath,
      key: key,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      errorBuilder: errorBuilder,
    );
  }
}