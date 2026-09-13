import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/works/work.dart';
import 'components/work_cover_image.dart';
import 'components/work_info_section.dart';

class WorkCard extends StatelessWidget {
  final Work work;
  final VoidCallback? onTap;

  const WorkCard({
    super.key,
    required this.work,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'work-cover-${work.id}',
              child: Material(
                type: MaterialType.transparency,
                child: WorkCoverImage(
                  imageUrl: work.mainCoverUrl ?? '',
                  workId: work.id ?? 0,
                  sourceId: work.sourceId ?? '',
                ),
              ),
            ),
            Expanded(child: WorkInfoSection(work: work)),
          ],
        ),
      ),
    );
  }
}
