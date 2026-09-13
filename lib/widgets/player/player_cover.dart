import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class PlayerCover extends StatelessWidget {
  final String? coverUrl;
  final double? maxWidth;

  const PlayerCover({
    super.key,
    this.coverUrl,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 480),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withOpacity(0.18),
              blurRadius: 36,
              spreadRadius: -8,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: coverUrl != null
              ? CachedNetworkImage(
                  imageUrl: coverUrl!,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Shimmer.fromColors(
                    baseColor: colors.surfaceContainerHighest,
                    highlightColor: colors.surfaceContainer,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: colors.errorContainer,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 48,
                      color: colors.error,
                    ),
                  ),
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors.primaryContainer,
                        colors.secondaryContainer
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(Icons.graphic_eq_rounded,
                        size: 82, color: colors.primary),
                  ),
                ),
        ),
      ),
    );
  }
}
