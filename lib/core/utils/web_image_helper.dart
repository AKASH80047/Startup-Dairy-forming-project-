import 'package:flutter/foundation.dart';

/// Helper to wrap network image URLs on web with a CORS proxy to bypass browser restrictions.
String getWebSafeImageUrl(String url) {
  if (kIsWeb && url.startsWith('http') && !url.contains('images.weserv.nl')) {
    return 'https://images.weserv.nl/?url=${Uri.encodeComponent(url)}';
  }
  return url;
}
