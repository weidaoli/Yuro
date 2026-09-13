import 'package:asmrapp/screens/player_screen.dart';
import 'package:flutter/material.dart';
import 'package:asmrapp/presentation/viewmodels/player_viewmodel.dart';
import 'mini_player_controls.dart';
import 'mini_player_progress.dart';
import 'package:get_it/get_it.dart';
import 'mini_player_cover.dart';

class MiniPlayer extends StatelessWidget {
  static const height = 72.0;

  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.I<PlayerViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colors = Theme.of(context).colorScheme;
        final hasTrack = viewModel.currentTrackInfo != null;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const PlayerScreen(),
                  transitionsBuilder: (_, animation, __, child) {
                    final curved = CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    );
                    return FadeTransition(
                      opacity: curved,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.16),
                          end: Offset.zero,
                        ).animate(curved),
                        child: child,
                      ),
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 360),
                ),
              );
            },
            child: SizedBox(
              height: height,
              child: Column(
                children: [
                  const MiniPlayerProgress(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                      child: Row(
                        children: [
                          Hero(
                            tag: 'mini-player-cover',
                            child: MiniPlayerCover(
                              coverUrl: viewModel.currentTrackInfo?.coverUrl,
                              size: 50,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: 'player-title',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      viewModel.currentTrackInfo?.title ??
                                          '还没有播放内容',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  hasTrack
                                      ? viewModel.currentTrackInfo?.artist ??
                                          '正在聆听'
                                      : '选一个作品，开始你的声场',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                          const MiniPlayerControls(),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
