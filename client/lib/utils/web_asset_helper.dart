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
      final suffix = path
          .substring('assets/images/'.length)
          .replaceAll('assets/images/', '');
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
        'materials',
        'security',
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

  static String _withCacheBust(String url, String? cacheBust) {
    if (cacheBust == null || cacheBust.isEmpty) return url;
    final sep = url.contains('?') ? '&' : '?';
    return '$url${sep}v=$cacheBust';
  }

  static List<String> _webImageUrlCandidates(
    String assetPath, {
    String? cacheBust,
  }) {
    final normalized = normalizeAssetPath(assetPath);
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return [_withCacheBust(normalized, cacheBust)];
    }

    final suffix = _stripAssetsImagesPrefix(assetPath);
    // Prefer nginx `/images/` (runtime mount); then bundled-style paths. See PROTOCOL_MASTER / client/docker/nginx.conf.
    return [
      _withCacheBust(_resolveRelative('images/$suffix'), cacheBust),
      _withCacheBust(_resolveRelative('assets/images/$suffix'), cacheBust),
      _withCacheBust(
        _resolveRelative('assets/assets/images/$suffix'),
        cacheBust,
      ),
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
      publicPath =
          'images/${normalized.substring('assets/assets/images/'.length)}';
    } else if (normalized.startsWith('images/')) {
      publicPath = 'images/${normalized.substring('images/'.length)}';
    } else if (normalized.startsWith('assets/')) {
      publicPath = normalized;
    } else {
      publicPath = normalized.startsWith('/')
          ? normalized.substring(1)
          : normalized;
    }

    return _resolveRelative(publicPath);
  }

  static ImageProvider<Object> provider(String assetPath) {
    return AssetImage(assetPath);
  }

  /// Web: load via HTTP only (`/images/…` first). Skips [Image.asset], so the Flutter web engine does not request `assets/assets/images/…` (avoids 404 noise; nginx serves avatars from the external mount).
  static Widget imageHttpFirst(
    String assetPath, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    String? cacheBust,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    if (!kIsWeb) {
      return image(
        assetPath,
        key: key,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        cacheBust: cacheBust,
        errorBuilder: errorBuilder,
      );
    }

    final normalizedPath = normalizeAssetPath(assetPath);
    final candidates = _webImageUrlCandidates(
      normalizedPath,
      cacheBust: cacheBust,
    );

    Widget chain(BuildContext context, int index) {
      if (index >= candidates.length) {
        if (errorBuilder != null) {
          return errorBuilder(
            context,
            StateError('web image candidates exhausted'),
            StackTrace.current,
          );
        }
        return const SizedBox.shrink();
      }
      return Image.network(
        candidates[index],
        key: key,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        errorBuilder: (ctx, err, st) => chain(ctx, index + 1),
      );
    }

    return Builder(
      builder: (context) => chain(context, 0),
    );
  }

  static Widget image(
    String assetPath, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    String? cacheBust,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
  }) {
    final normalizedPath = normalizeAssetPath(assetPath);

    if (kIsWeb) {
      if (cacheBust != null && cacheBust.isNotEmpty) {
        return imageHttpFirst(
          assetPath,
          key: key,
          width: width,
          height: height,
          fit: fit,
          alignment: alignment,
          cacheBust: cacheBust,
          errorBuilder: errorBuilder,
        );
      }
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
