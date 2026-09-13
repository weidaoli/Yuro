import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asmrapp/presentation/viewmodels/settings/cache_manager_viewmodel.dart';

class CacheManagerScreen extends StatelessWidget {
  const CacheManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CacheManagerViewModel()..loadCacheSize(),
      child: Scaffold(
        appBar: AppBar(title: const Text('缓存管理')),
        body: Consumer<CacheManagerViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading && viewModel.totalCacheSize == 0) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.error != null) {
              return _CacheError(
                message: viewModel.error!,
                onRetry: viewModel.loadCacheSize,
              );
            }

            final colors = Theme.of(context).colorScheme;
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: colors.primaryContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.data_usage_rounded, color: colors.primary),
                          const SizedBox(width: 8),
                          Text(
                            '本地缓存',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        viewModel.totalCacheSizeFormatted,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: colors.onPrimaryContainer,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '已用于加速最近播放的音频与字幕',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  colors.onPrimaryContainer.withOpacity(0.72),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _CacheItem(
                  icon: Icons.multitrack_audio_rounded,
                  title: '音频缓存',
                  value: viewModel.audioCacheSizeFormatted,
                  loading: viewModel.isLoading,
                  onClear: viewModel.clearAudioCache,
                ),
                const SizedBox(height: 12),
                _CacheItem(
                  icon: Icons.subtitles_rounded,
                  title: '字幕缓存',
                  value: viewModel.subtitleCacheSizeFormatted,
                  loading: viewModel.isLoading,
                  onClear: viewModel.clearSubtitleCache,
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed:
                      viewModel.isLoading ? null : viewModel.clearAllCache,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  label: const Text('清理全部缓存'),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: 20, color: colors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '缓存可以减少重复加载。系统也会在缓存过期或超过容量限制时自动清理。',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                    height: 1.45,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CacheItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool loading;
  final VoidCallback onClear;

  const _CacheItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.loading,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: colors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: loading ? null : onClear,
              child: const Text('清理'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CacheError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CacheError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('重新加载'),
            ),
          ],
        ),
      ),
    );
  }
}
