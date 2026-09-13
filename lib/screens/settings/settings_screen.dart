import 'package:asmrapp/core/platform/wakelock_controller.dart';
import 'package:asmrapp/core/theme/theme_controller.dart';
import 'package:asmrapp/screens/settings/cache_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = GetIt.I<ThemeController>();
    final wakeLockController = GetIt.I<WakeLockController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colors.primaryContainer, colors.secondaryContainer],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.surface.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(
                    Icons.headphones_rounded,
                    color: colors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '属于你的聆听空间',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colors.onPrimaryContainer,
                                ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '调整外观、播放体验与本地存储',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color:
                                  colors.onPrimaryContainer.withOpacity(0.72),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const _SectionLabel('外观'),
          const SizedBox(height: 10),
          ListenableBuilder(
            listenable: themeController,
            builder: (context, _) {
              return _SettingsCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _SettingIcon(icon: Icons.palette_outlined),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('显示模式',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 2),
                                Text(
                                  '让界面适应不同的聆听环境',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<ThemeMode>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto_rounded),
                            label: Text('自动'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_outlined),
                            label: Text('浅色'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_outlined),
                            label: Text('深色'),
                          ),
                        ],
                        selected: {themeController.themeMode},
                        onSelectionChanged: (modes) {
                          themeController.setThemeMode(modes.first);
                        },
                        style: ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          side: WidgetStatePropertyAll(
                            BorderSide(color: colors.outlineVariant),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 26),
          const _SectionLabel('播放'),
          const SizedBox(height: 10),
          _SettingsCard(
            child: ListenableBuilder(
              listenable: wakeLockController,
              builder: (context, _) {
                return SwitchListTile(
                  secondary:
                      const _SettingIcon(icon: Icons.lightbulb_outline_rounded),
                  title: const Text('屏幕常亮'),
                  subtitle: const Text('播放内容时避免设备自动锁屏'),
                  value: wakeLockController.enabled,
                  onChanged: (_) => wakeLockController.toggle(),
                );
              },
            ),
          ),
          const SizedBox(height: 26),
          const _SectionLabel('存储'),
          const SizedBox(height: 10),
          _SettingsCard(
            child: ListTile(
              leading: const _SettingIcon(icon: Icons.storage_rounded),
              title: const Text('缓存管理'),
              subtitle: const Text('查看音频、字幕占用并清理'),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: colors.outline,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CacheManagerScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Widget child;

  const _SettingsCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(child: child);
  }
}

class _SettingIcon extends StatelessWidget {
  final IconData icon;

  const _SettingIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: colors.primary, size: 21),
    );
  }
}
