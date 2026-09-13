import 'package:flutter/material.dart';
import 'package:asmrapp/presentation/viewmodels/player_viewmodel.dart';
import 'package:get_it/get_it.dart';

class MiniPlayerControls extends StatelessWidget {
  const MiniPlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.I<PlayerViewModel>();
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return IconButton.filled(
          iconSize: 21,
          tooltip: viewModel.isPlaying ? '暂停' : '播放',
          icon: Icon(
            viewModel.isPlaying
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
          ),
          onPressed: viewModel.playPause,
        );
      },
    );
  }
}
