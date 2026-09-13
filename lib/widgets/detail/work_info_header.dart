import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/works/work.dart';
import 'package:asmrapp/widgets/common/tag_chip.dart';
import 'package:asmrapp/widgets/detail/work_stats_info.dart';
import 'package:asmrapp/utils/logger.dart';

class WorkInfoHeader extends StatelessWidget {
  final Work work;

  const WorkInfoHeader({super.key, required this.work});

  void _onTagTap(BuildContext context, String keyword) {
    if (keyword.isEmpty) return;
    AppLogger.debug('点击标签: $keyword');
    Navigator.pushNamed(context, '/search', arguments: keyword);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          work.title ?? '',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(height: 1.3),
        ),
        const SizedBox(height: 12),
        WorkStatsInfo(work: work),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (work.circle?.name != null)
              TagChip(
                text: work.circle?.name ?? '',
                backgroundColor: colors.secondaryContainer,
                textColor: colors.onSecondaryContainer,
                onTap: () => _onTagTap(context, work.circle?.name ?? ''),
              ),
            ...?work.vas?.take(3).map(
                  (va) => TagChip(
                    text: va['name'] ?? '',
                    backgroundColor: colors.primaryContainer,
                    textColor: colors.onPrimaryContainer,
                    onTap: () => _onTagTap(context, va['name'] ?? ''),
                  ),
                ),
            if (work.hasSubtitle == true)
              TagChip(
                text: '字幕',
                backgroundColor: colors.surfaceContainerHighest,
                textColor: colors.onSurfaceVariant,
              ),
          ],
        ),
      ],
    );
  }
}
