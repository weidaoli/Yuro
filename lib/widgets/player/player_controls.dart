import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:asmrapp/presentation/viewmodels/player_viewmodel.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.I<PlayerViewModel>();

    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final colors = Theme.of(context).colorScheme;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: '上一首',
              iconSize: 30,
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: viewModel.previous,
            ),
            const SizedBox(width: 22),
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colors.primary, colors.secondary],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withOpacity(0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: IconButton(
                tooltip: viewModel.isPlaying ? '暂停' : '播放',
                iconSize: 36,
                color: Colors.white,
                icon: Icon(
                  viewModel.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                ),
                onPressed: viewModel.playPause,
              ),
            ),
            const SizedBox(width: 22),
            IconButton(
              tooltip: '下一首',
              iconSize: 30,
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: viewModel.next,
            ),
          ],
        );
      },
    );
  }
}
