import 'package:asmrapp/core/platform/wakelock_controller.dart';
import 'package:asmrapp/core/theme/theme_controller.dart';
import 'package:asmrapp/screens/settings/cache_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// 设置页面：主题、屏幕常亮、缓存管理
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = GetIt.I<ThemeController>();
    final wakeLockController = GetIt.I<WakeLockController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          // 主题设置
          ListenableBuilder(
            listenable: themeController,
            builder: (context, _) {
              return ExpansionTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text('主题'),
                subtitle: Text(_themeLabel(themeController.themeMode)),
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('跟随系统'),
                    value: ThemeMode.system,
                    groupValue: themeController.themeMode,
                    onChanged: (mode) {
                      if (mode != null) themeController.setThemeMode(mode);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('浅色模式'),
                    value: ThemeMode.light,
                    groupValue: themeController.themeMode,
                    onChanged: (mode) {
                      if (mode != null) themeController.setThemeMode(mode);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('深色模式'),
                    value: ThemeMode.dark,
                    groupValue: themeController.themeMode,
                    onChanged: (mode) {
                      if (mode != null) themeController.setThemeMode(mode);
                    },
                  ),
                ],
              );
            },
          ),

          // 屏幕常亮
          ListenableBuilder(
            listenable: wakeLockController,
            builder: (context, _) {
              return SwitchListTile(
                secondary: const Icon(Icons.lightbulb_outline),
                title: const Text('屏幕常亮'),
                subtitle: const Text('播放时保持屏幕常亮'),
                value: wakeLockController.enabled,
                onChanged: (_) => wakeLockController.toggle(),
              );
            },
          ),

          const Divider(),

          // 缓存管理
          ListTile(
            leading: const Icon(Icons.storage_outlined),
            title: const Text('缓存管理'),
            subtitle: const Text('音频与字幕缓存大小、清理'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CacheManagerScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色模式';
      case ThemeMode.dark:
        return '深色模式';
    }
  }
}
