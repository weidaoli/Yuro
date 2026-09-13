import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/works/work.dart';
import 'work_title.dart';
import 'work_tags_panel.dart';
import 'work_footer.dart';

class WorkInfoSection extends StatelessWidget {
  final Work work;

  const WorkInfoSection({super.key, required this.work});

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(11, 11, 11, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkTitle(work: work),
          const SizedBox(height: 7),
          if (work.duration != null)
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(work.duration),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          const SizedBox(height: 9),
          WorkTagsPanel(work: work),
          const Spacer(),
          const SizedBox(height: 8),
          WorkFooter(work: work),
        ],
      ),
    );
  }
}
