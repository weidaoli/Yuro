import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asmrapp/common/constants/strings.dart';
import 'package:asmrapp/presentation/viewmodels/auth_viewmodel.dart';
import 'package:asmrapp/presentation/widgets/auth/login_dialog.dart';
import 'package:asmrapp/screens/favorites_screen.dart';
import 'package:asmrapp/screens/settings/settings_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LoginDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Drawer(
      width: 312,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colors.primaryContainer,
                      colors.secondaryContainer,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: colors.surface.withOpacity(0.72),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        color: colors.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      Strings.appName,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: colors.onPrimaryContainer,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '把喜欢的声音留在夜晚',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colors.onPrimaryContainer.withOpacity(0.72),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '我的空间',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Consumer<AuthViewModel>(
                builder: (context, authVM, _) {
                  return _DrawerItem(
                    icon: authVM.isLoggedIn
                        ? Icons.account_circle_rounded
                        : Icons.login_rounded,
                    title: authVM.isLoggedIn ? authVM.username ?? '账号' : '登录',
                    subtitle: authVM.isLoggedIn ? '点击退出当前账号' : '同步收藏与推荐',
                    onTap: () {
                      Navigator.pop(context);
                      if (authVM.isLoggedIn) {
                        authVM.logout();
                      } else {
                        _showLoginDialog(context);
                      }
                    },
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.favorite_outline_rounded,
                title: Strings.favorites,
                subtitle: '查看收藏和播放列表',
                onTap: () {
                  Navigator.pop(context);
                  final authVM = context.read<AuthViewModel>();
                  if (!authVM.isLoggedIn) {
                    _showLoginDialog(context);
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),
              _DrawerItem(
                icon: Icons.tune_rounded,
                title: Strings.settings,
                subtitle: '外观、播放与缓存',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'Yuro · ASMR.ONE client',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant.withOpacity(0.64),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, size: 21, color: colors.primary),
        ),
        title: Text(title),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: colors.outline,
        ),
        onTap: onTap,
      ),
    );
  }
}
