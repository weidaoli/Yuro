import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/files/files.dart';
import 'package:asmrapp/data/models/files/child.dart';
import 'package:asmrapp/widgets/detail/work_folder_item.dart';
import 'package:asmrapp/widgets/detail/work_file_item.dart';

class WorkFilesList extends StatelessWidget {
  final Files files;
  final Function(Child file)? onFileTap;

  const WorkFilesList({
    super.key,
    required this.files,
    this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    WorkFolderItem.resetExpandState();
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(Icons.queue_music_rounded, color: colors.primary),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('音轨列表',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      '选择一个文件开始播放',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: colors.outlineVariant.withOpacity(0.55)),
          ...files.children
                  ?.map((child) => child.type == 'folder'
                      ? WorkFolderItem(
                          folder: child,
                          indentation: 0,
                          onFileTap: onFileTap,
                        )
                      : WorkFileItem(
                          file: child,
                          indentation: 0,
                          onFileTap: onFileTap,
                        ))
                  .toList() ??
              [],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
