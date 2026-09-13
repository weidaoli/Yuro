import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/works/work.dart';

class WorkTagsPanel extends StatelessWidget {
  final Work work;

  const WorkTagsPanel({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final chips = <Widget>[];

    if (work.circle?.name?.isNotEmpty == true) {
      chips.add(_MiniTag(
        label: work.circle!.name!,
        color: colors.secondaryContainer,
        textColor: colors.onSecondaryContainer,
      ));
    }
    if (work.vas?.isNotEmpty == true) {
      chips.add(_MiniTag(
        label: work.vas!.first['name'] ?? '',
        color: colors.primaryContainer,
        textColor: colors.onPrimaryContainer,
      ));
    }
    if (work.hasSubtitle == true) {
      chips.add(_MiniTag(
        label: '字幕',
        icon: Icons.closed_caption_rounded,
        color: colors.surfaceContainerHighest,
        textColor: colors.onSurfaceVariant,
      ));
    }

    return Wrap(spacing: 5, runSpacing: 5, children: chips.take(3).toList());
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final Color textColor;

  const _MiniTag({
    required this.label,
    required this.color,
    required this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: 3),
          ],
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 78),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
