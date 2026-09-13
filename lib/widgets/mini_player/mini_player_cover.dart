import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class MiniPlayerCover extends StatelessWidget {
  final String? coverUrl;
  final double size;

  const MiniPlayerCover({
    super.key,
    this.coverUrl,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(15);

    if (coverUrl == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: radius,
        ),
        child: Icon(Icons.graphic_eq_rounded, color: colors.primary),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: coverUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: colors.surfaceContainerHighest,
          highlightColor: colors.surfaceContainer,
          child: Container(width: size, height: size, color: Colors.white),
        ),
        errorWidget: (_, __, ___) => Container(
          width: size,
          height: size,
          color: colors.errorContainer,
          child: Icon(Icons.broken_image_outlined, color: colors.error),
        ),
      ),
    );
  }
}
