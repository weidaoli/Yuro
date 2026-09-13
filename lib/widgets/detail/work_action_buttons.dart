import 'package:asmrapp/data/models/mark_status.dart';
import 'package:flutter/material.dart';

class WorkActionButtons extends StatelessWidget {
  final VoidCallback onRecommendationsTap;
  final bool hasRecommendations;
  final bool checkingRecommendations;
  final VoidCallback onFavoriteTap;
  final bool loadingFavorite;
  final VoidCallback onMarkTap;
  final MarkStatus? currentMarkStatus;
  final bool loadingMark;

  const WorkActionButtons({
    super.key,
    required this.onRecommendationsTap,
    required this.hasRecommendations,
    required this.checkingRecommendations,
    required this.onFavoriteTap,
    this.loadingFavorite = false,
    required this.onMarkTap,
    this.currentMarkStatus,
    this.loadingMark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.favorite_outline_rounded,
                  label: '收藏',
                  onTap: onFavoriteTap,
                  loading: loadingFavorite,
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.bookmark_border_rounded,
                  label: currentMarkStatus?.label ?? '标记',
                  onTap: onMarkTap,
                  loading: loadingMark,
                ),
              ),
              const Expanded(
                child: _ActionButton(
                  icon: Icons.star_outline_rounded,
                  label: '评分',
                ),
              ),
              Expanded(
                child: _ActionButton(
                  icon: Icons.auto_awesome_outlined,
                  label: checkingRecommendations
                      ? '检查中'
                      : hasRecommendations
                          ? '相关推荐'
                          : '暂无推荐',
                  onTap: hasRecommendations ? onRecommendationsTap : null,
                  loading: checkingRecommendations,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool loading;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final disabled = onTap == null && !loading;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: disabled
                    ? colors.surfaceContainerHigh
                    : colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: loading
                  ? Padding(
                      padding: const EdgeInsets.all(11),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.primary,
                      ),
                    )
                  : Icon(
                      icon,
                      size: 21,
                      color: disabled ? colors.outline : colors.primary,
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: disabled ? colors.outline : colors.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
