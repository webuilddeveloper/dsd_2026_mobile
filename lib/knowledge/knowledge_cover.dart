import 'package:flutter/material.dart';

/// Supports the base64 covers embedded in the DSD bookshelf and ordinary URLs.
class KnowledgeCover extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  const KnowledgeCover({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    Widget fallback() => Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40),
      ),
    );
    try {
      if (source.isEmpty) return fallback();
      final ImageProvider provider;
      if (source.startsWith('data:image/')) {
        provider = MemoryImage(UriData.parse(source).contentAsBytes());
      } else {
        provider = NetworkImage(source);
      }
      return Image(
        image: provider,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => fallback(),
      );
    } on FormatException {
      return fallback();
    }
  }
}
