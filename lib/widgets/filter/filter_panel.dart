import 'package:flutter/material.dart';

class FilterPanel extends StatelessWidget {
  final bool expanded;
  final bool hasSubtitle;
  final String orderField;
  final bool isDescending;
  final ValueChanged<bool> onSubtitleChanged;
  final ValueChanged<String> onOrderFieldChanged;
  final ValueChanged<bool> onSortDirectionChanged;

  const FilterPanel({
    super.key,
    this.expanded = false,
    required this.hasSubtitle,
    required this.orderField,
    required this.isDescending,
    required this.onSubtitleChanged,
    required this.onOrderFieldChanged,
    required this.onSortDirectionChanged,
  });

  String _getOrderFieldText(String field) {
    switch (field) {
      case 'create_date':
        return '收录时间';
      case 'release':
        return '发售日期';
      case 'dl_count':
        return '销量';
      case 'price':
        return '价格';
      case 'rate_average_2dp':
        return '评价';
      case 'review_count':
        return '评论数';
      case 'id':
        return 'RJ号';
      case 'rating':
        return '我的评价';
      case 'nsfw':
        return '全年龄';
      case 'random':
        return '随机';
      default:
        return '排序';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Row(
        children: [
          FilterChip(
            selected: hasSubtitle,
            avatar: Icon(
              hasSubtitle
                  ? Icons.closed_caption_rounded
                  : Icons.closed_caption_off_outlined,
              size: 18,
            ),
            label: const Text('有字幕'),
            onSelected: onSubtitleChanged,
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: onOrderFieldChanged,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            itemBuilder: (_) => [
              _item('收录时间', 'create_date'),
              _item('发售日期', 'release'),
              _item('销量', 'dl_count'),
              _item('价格', 'price'),
              _item('评价', 'rate_average_2dp'),
              _item('评论数', 'review_count'),
              _item('RJ号', 'id'),
              _item('我的评价', 'rating'),
              _item('全年龄', 'nsfw'),
              _item('随机', 'random'),
            ],
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swap_vert_rounded, size: 18),
                  const SizedBox(width: 7),
                  Text(_getOrderFieldText(orderField)),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down_rounded, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          ActionChip(
            avatar: Icon(
              isDescending ? Icons.south_rounded : Icons.north_rounded,
              size: 17,
            ),
            label: Text(isDescending ? '降序' : '升序'),
            onPressed: () => onSortDirectionChanged(!isDescending),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _item(String text, String value) {
    return PopupMenuItem(value: value, child: Text(text));
  }
}
