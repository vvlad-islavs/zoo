import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.aspectRatio,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    Widget child = CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      placeholder: (context, _) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, error, st) => Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: const Icon(Icons.image_not_supported_outlined),
      ),
    );

    if (aspectRatio != null) {
      child = AspectRatio(aspectRatio: aspectRatio!, child: child);
    }
    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }
}

