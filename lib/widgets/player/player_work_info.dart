import 'package:flutter/material.dart';
import 'package:asmrapp/core/audio/models/playback_context.dart';

class PlayerWorkInfo extends StatelessWidget {
  final PlaybackContext? context;

  const PlayerWorkInfo({
    super.key,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.context?.work.title ?? '未知作品',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            this
                    .context
                    ?.work
                    .vas
                    ?.map((va) => va['name'] as String?)
                    .where((name) => name != null)
                    .join('、') ??
                '未知演员',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
