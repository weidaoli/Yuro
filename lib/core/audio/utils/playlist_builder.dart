import 'package:just_audio/just_audio.dart';
import 'package:asmrapp/data/models/files/child.dart';
import 'package:asmrapp/core/audio/cache/audio_cache_manager.dart';

class PlaylistBuilder {
  static Future<List<AudioSource>> buildAudioSources(List<Child> files) async {
    // 过滤掉没有下载地址的文件，避免 mediaDownloadUrl! 强解包崩溃
    final playable = files.where((f) => f.mediaDownloadUrl != null).toList();
    return await Future.wait(
      playable.map((file) async {
        return AudioCacheManager.createAudioSource(file.mediaDownloadUrl!);
      })
    );
  }

  static Future<void> updatePlaylist(
    ConcatenatingAudioSource playlist,
    List<AudioSource> sources,
  ) async {
    await playlist.clear();
    await playlist.addAll(sources);
  }

  static Future<void> setPlaylistSource({
    required AudioPlayer player,
    required ConcatenatingAudioSource playlist,
    required List<Child> files,
    required int initialIndex,
    required Duration initialPosition,
  }) async {
    final sources = await buildAudioSources(files);
    await updatePlaylist(playlist, sources);

    // 关键修复：不要直接把 initialPosition 传给 setAudioSource。
    // ExoPlayer 会在 timeline 加载回调（onTimelineChanged）里 seekTo(initialPosition)，
    // 若保存的位置超过当前音频实际时长（缓存损坏/URL 变更/服务器 duration 变化），
    // 会抛 IllegalArgumentException 直接杀死应用。
    // 改为先以 0 加载，等 duration 就绪后再 clamp seek。
    await player.setAudioSource(
      playlist,
      initialIndex: initialIndex,
    );

    if (initialPosition > Duration.zero) {
      await _seekSafely(player, initialPosition);
    }
  }

  /// 等待播放器 duration 就绪后 clamp seek，避免越界
  static Future<void> _seekSafely(AudioPlayer player, Duration target) async {
    try {
      // 等待 duration 可用（最多 3 秒）
      Duration? duration;
      for (var i = 0; i < 30; i++) {
        duration = player.duration;
        if (duration != null) break;
        await Future.delayed(const Duration(milliseconds: 100));
      }

      var safe = target;
      if (safe < Duration.zero) safe = Duration.zero;
      if (duration != null && safe > duration) safe = duration;
      await player.seek(safe);
    } catch (_) {
      // seek 失败不致命，忽略
    }
  }
}
