import 'package:flutter/material.dart';
import 'package:asmrapp/data/models/works/work.dart';

class WorkTitle extends StatelessWidget {
  final Work work;

  const WorkTitle({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return Text(
      work.title ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.28,
          ),
    );
  }
}
