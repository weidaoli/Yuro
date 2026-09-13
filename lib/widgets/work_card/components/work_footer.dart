import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/works/work.dart';

class WorkFooter extends StatelessWidget {
  final Work work;

  const WorkFooter({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.onSurfaceVariant.withOpacity(0.82),
          fontSize: 10,
        );

    return Row(
      children: [
        Expanded(
          child: Text(
            work.release ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style,
          ),
        ),
        Icon(Icons.favorite_border_rounded, size: 12, color: colors.secondary),
        const SizedBox(width: 3),
        Text('${work.dlCount ?? 0}', style: style),
      ],
    );
  }
}
