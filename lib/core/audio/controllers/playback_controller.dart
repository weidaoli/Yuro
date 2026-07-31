import 'package:asmrapp/utils/logger.dart';
import 'package:just_audio/just_audio.dart';
import '../models/playback_context.dart';
import '../state/playback_state_manager.dart';
import '../utils/playlist_builder.dart';
import '../utils/audio_error_handler.dart';
import 'package:asmrapp/data/models/files/child.dart';
import 'package:asmrapp/data/models/works/work.dart';


class PlaybackController {
  final AudioPlayer _player;
  final PlaybackStateManager _stateManager;
  final ConcatenatingAudioSource _playlist;

  PlaybackController({
    required AudioPlayer player,
    required PlaybackStateManager stateManager,
    required ConcatenatingAudioSource playlist,
  }) : _player = player,
       _stateManager = stateManager,
       _playlist = playlist;

  // 基础播放控制
  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> stop() => _player.stop();
  Future<void> seek(Duration position, {int? index}) => _player.seek(position, index: index);
  
  // 播放列表控制
  Future<void> next() async {
    try {
      AppLogger.debug('尝试切换下一曲');
      if (_stateManager.currentContext == null) {
        AppLogger.debug('当前上下文为空，无法切换下一曲');
        return;
      }

      if (_player.hasNext) {
        AppLogger.debug('执行切换到下一曲');
        await _player.seekToNext();
      } else {
        AppLogger.debug('没有下一曲可切换');
      }
    } catch (e, stack) {
      AppLogger.error('切换下一曲失败', e, stack);
      AudioErrorHandler.handleError(
        AudioErrorType.playback,
        '切换下一曲',
        e,
        stack,
      );
    }
  }

  Future<void> previous() async {
    try {
      AppLogger.debug('尝试切换上一曲');
      if (_stateManager.currentContext == null) {
        AppLogger.debug('当前上下文为空，无法切换上一曲');
        return;
      }

      if (_player.hasPrevious) {
        final previousFile = _stateManager.currentContext!.getPreviousFile();
        AppLogger.debug('获取到上一个文件: ${previousFile?.title}');
        if (previousFile != null) {
          _updateTrackAndContext(
            previousFile,
            _stateManager.currentContext!.work
          );
          AppLogger.debug('执行切换到上一曲');
          await _player.seekToPrevious();
        }
      } else {
        AppLogger.debug('没有上一曲可切换');
      }
    } catch (e, stack) {
      AppLogger.error('切换上一曲失败', e, stack);
      AudioErrorHandler.handleError(
        AudioErrorType.playback,
        '切换上一曲',
        e,
        stack,
      );
    }
  }

  // 播放上下文设置
  Future<void> setPlaybackContext(PlaybackContext context, {Duration? initialPosition}) async {
    try {
      AppLogger.debug('准备设置播放上下文: workId=${context.work.id}, file=${context.currentFile.title}');
      AppLogger.debug('播放列表状态: 长度=${context.playlist.length}, 当前索引=${context.currentIndex}');

      // 过滤掉没有下载地址的文件，避免 mediaDownloadUrl! 强解包崩溃；
      // 同时保证播放源与 _stateManager 中保存的播放列表保持一致。
      final playableFiles = context.playlist
          .where((f) => f.mediaDownloadUrl != null)
          .toList();
      if (playableFiles.length != context.playlist.length) {
        AppLogger.debug('过滤掉 ${context.playlist.length - playableFiles.length} 个无下载地址的文件');
        final newIndex = playableFiles
            .indexWhere((f) => f.title == context.currentFile.title);
        context = PlaybackContext.withPlaylist(
          work: context.work,
          files: context.files,
          currentFile: context.currentFile,
          playlist: playableFiles,
          currentIndex: newIndex >= 0 ? newIndex : 0,
          playMode: context.playMode,
        );
      }

      // 验证上下文
      try {
        context.validate();
      } catch (e) {
        AppLogger.error('播放上下文验证失败', e);
        rethrow;
      }
      
      // 1. 先停止当前播放
      AppLogger.debug('停止当前播放');
      await _player.stop();
      
      // 2. 等待播放器就绪
      AppLogger.debug('暂停播放器');
      await _player.pause();
      
      // 3. 更新上下文
      AppLogger.debug('更新播放上下文');
      _stateManager.updateContext(context);
      
      // 4. 设置新的播放源
      AppLogger.debug('设置播放源: 初始位置=${initialPosition?.inMilliseconds}ms');
      try {
        await PlaylistBuilder.setPlaylistSource(
          player: _player,
          playlist: _playlist,
          files: context.playlist,
          initialIndex: context.currentIndex,
          initialPosition: initialPosition ?? Duration.zero,
        );
      } catch (e, stack) {
        AppLogger.error('设置播放源失败', e, stack);
        rethrow;
      }

      // 5. 等待播放器准备完成
      // 删掉，会导致播放器索引回到0
      // AppLogger.debug('等待播放器加载');
      // await _player.load();
      
      // 6. 更新轨道信息
      AppLogger.debug('更新轨道信息');
      _updateTrackAndContext(context.currentFile, context.work);
      
      AppLogger.debug('播放上下文设置完成');
    } catch (e, stack) {
      AppLogger.error('设置播放上下文失败', e, stack);
      AudioErrorHandler.handleError(
        AudioErrorType.context,
        '设置播放上下文',
        e,
        stack,
      );
      rethrow;
    }
  }

  // 私有辅助方法
  void _updateTrackAndContext(Child file, Work work) {
    AppLogger.debug('更新轨道和上下文: file=${file.title}');
    _stateManager.updateTrackAndContext(file, work);
  }
} 