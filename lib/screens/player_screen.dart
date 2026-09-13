import 'package:asmrapp/core/platform/lyric_overlay_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:asmrapp/presentation/viewmodels/player_viewmodel.dart';
import 'package:asmrapp/widgets/player/player_controls.dart';
import 'package:asmrapp/widgets/player/player_progress.dart';
import 'package:asmrapp/widgets/player/player_cover.dart';
import 'package:asmrapp/screens/detail_screen.dart';
import 'package:asmrapp/widgets/lyrics/components/player_lyric_view.dart';
import 'package:asmrapp/widgets/player/player_work_info.dart';
import 'package:asmrapp/core/platform/wakelock_controller.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool _showLyrics = false;
  bool _canSwitchView = true;
  late final PlayerViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<PlayerViewModel>();
  }

  Widget _buildContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 360),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final isLyrics = child.key == const ValueKey('lyrics');
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, isLyrics ? 0.06 : -0.06),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: Alignment.center,
        children: [...previousChildren, if (currentChild != null) currentChild],
      ),
      child: _showLyrics
          ? PlayerLyricView(
              key: const ValueKey('lyrics'),
              onScrollStateChanged: (canSwitch) {
                setState(() => _canSwitchView = canSwitch);
              },
            )
          : ListenableBuilder(
              key: const ValueKey('cover'),
              listenable: _viewModel,
              builder: (context, _) {
                final colors = Theme.of(context).colorScheme;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Hero(
                        tag: 'mini-player-cover',
                        child: PlayerCover(
                          coverUrl: _viewModel.currentTrackInfo?.coverUrl,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Hero(
                            tag: 'player-title',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                _viewModel.currentTrackInfo?.title ?? '还没有播放内容',
                                style: Theme.of(context).textTheme.titleLarge,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            _viewModel.currentTrackInfo?.artist ??
                                '点击封面区域可切换歌词',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PlayerWorkInfo(context: _viewModel.currentContext),
                    ),
                  ],
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lyricManager = GetIt.I<LyricOverlayManager>();
    final wakeLockController = GetIt.I<WakeLockController>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.all(5),
          child: IconButton.filledTonal(
            tooltip: '收起播放器',
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          IconButton(
            tooltip: '作品信息',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              final work = _viewModel.currentContext?.work;
              if (work != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(work: work, fromPlayer: true),
                  ),
                );
              }
            },
          ),
          IconButton(
            tooltip: lyricManager.isShowing ? '关闭悬浮歌词' : '开启悬浮歌词',
            icon: Icon(
              lyricManager.isShowing
                  ? Icons.lyrics_rounded
                  : Icons.lyrics_outlined,
            ),
            onPressed: () => lyricManager.toggle(context),
          ),
          ListenableBuilder(
            listenable: wakeLockController,
            builder: (context, _) => IconButton(
              tooltip: wakeLockController.enabled ? '关闭屏幕常亮' : '开启屏幕常亮',
              icon: Icon(
                wakeLockController.enabled
                    ? Icons.lightbulb_rounded
                    : Icons.lightbulb_outline_rounded,
              ),
              onPressed: wakeLockController.toggle,
            ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primaryContainer.withOpacity(0.34),
              colors.surface,
              colors.surface,
            ],
            stops: const [0, 0.34, 1],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (_canSwitchView)
                      setState(() => _showLyrics = !_showLyrics);
                  },
                  child: _buildContent(),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 14),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer.withOpacity(0.94),
                  borderRadius: BorderRadius.circular(28),
                  border:
                      Border.all(color: colors.outlineVariant.withOpacity(0.5)),
                ),
                child: const Column(
                  children: [
                    PlayerProgress(),
                    SizedBox(height: 12),
                    PlayerControls(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
