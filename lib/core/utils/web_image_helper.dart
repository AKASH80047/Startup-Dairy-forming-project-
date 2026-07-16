import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Helper to wrap network image URLs on web with a CORS proxy to bypass browser restrictions.
String getWebSafeImageUrl(String url) {
  if (kIsWeb && url.startsWith('http') && !url.contains('images.weserv.nl')) {
    return 'https://images.weserv.nl/?url=${Uri.encodeComponent(url)}';
  }
  return url;
}

/// A responsive image widget that loads local asset files or network images.
class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Alignment alignment;
  final FilterQuality filterQuality;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.filterQuality = FilterQuality.low,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        filterQuality: filterQuality,
        errorBuilder: errorBuilder ?? (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF3F6F4),
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image_rounded, color: Colors.black26),
          );
        },
      );
    } else {
      return Image.network(
        getWebSafeImageUrl(path),
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        filterQuality: filterQuality,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder ?? (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF3F6F4),
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image_rounded, color: Colors.black26),
          );
        },
      );
    }
  }
}
