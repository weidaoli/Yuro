import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:asmrapp/presentation/viewmodels/player_viewmodel.dart';

class PlayerSeekControls extends StatelessWidget {
  const PlayerSeekControls({super.key});

  // 相对跳转必须 clamp 到 [0, duration]，否则负数/超时长 seek 会让
  // ExoPlayer 抛 IllegalArgumentException（主线程崩溃）
  void _seekRelative(PlayerViewModel viewModel, Duration delta) {
    final position = viewModel.position;
    if (position == null) return;

    var target = position + delta;
    if (target < Duration.zero) target = Duration.zero;
    final duration = viewModel.duration;
    if (duration != null && target > duration) target = duration;
    viewModel.seek(target);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.I<PlayerViewModel>();
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // 后退30s
        IconButton(
          icon: const Icon(Icons.replay_30),
          iconSize: 24,
          onPressed: () => _seekRelative(viewModel, const Duration(seconds: -30)),
        ),
        // 后退5s
        IconButton(
          icon: const Icon(Icons.replay_5),
          iconSize: 24,
          onPressed: () => _seekRelative(viewModel, const Duration(seconds: -5)),
        ),
        // 上一句歌词
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 24,
          onPressed: () => viewModel.seekToPreviousLyric(),
        ),
        // 下一句歌词
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 24,
          onPressed: () => viewModel.seekToNextLyric(),
        ),
        // 快进5s
        IconButton(
          icon: const Icon(Icons.forward_5),
          iconSize: 24,
          onPressed: () => _seekRelative(viewModel, const Duration(seconds: 5)),
        ),
        // 快进30s
        IconButton(
          icon: const Icon(Icons.forward_30),
          iconSize: 24,
          onPressed: () => _seekRelative(viewModel, const Duration(seconds: 30)),
        ),
      ],
    );
  }
} 