import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WorkCover extends StatelessWidget {
  final String imageUrl;
  final int workId;
  final String sourceId;
  final String? releaseDate;
  final String? heroTag;

  const WorkCover({
    super.key,
    required this.imageUrl,
    required this.workId,
    required this.sourceId,
    this.releaseDate,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      fit: StackFit.passthrough,
      children: [
        AspectRatio(
          aspectRatio: 195 / 146,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorWidget: (_, __, ___) => Container(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xB3000000)],
                stops: [0.52, 1],
              ),
            ),
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: _CoverLabel(icon: Icons.tag_rounded, text: sourceId),
        ),
        if (releaseDate != null)
          Positioned(
            right: 12,
            bottom: 12,
            child: _CoverLabel(
                icon: Icons.calendar_month_rounded, text: releaseDate!),
          ),
      ],
    );

    if (heroTag != null) {
      content = Hero(tag: heroTag!, child: content);
    }
    return content;
  }
}

class _CoverLabel extends StatelessWidget {
  final IconData icon;
  final String text;

  const _CoverLabel({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.17)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
