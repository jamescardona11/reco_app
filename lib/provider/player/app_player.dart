import 'dart:async';

import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_player.g.dart';

@riverpod
class AppPlayer extends _$AppPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _subscription;

  @override
  AudioRecord? build() {
    _initSubscription();
    ref.onDispose(_dispose);

    return null;
  }

  Future<void> playAudio(AudioRecord audioRecord) async {
    await _audioPlayer.stop();

    if (state == audioRecord) {
      state = null;
    } else {
      final source = audioRecord.fileUrl != null ? UrlSource(audioRecord.fileUrl!) : DeviceFileSource(audioRecord.filePath);

      await _audioPlayer.play(source);
      state = audioRecord;
    }
  }

  void _initSubscription() {
    _subscription = _audioPlayer.onPlayerComplete.listen((_) {
      state = null;
    });
  }

  void _dispose() {
    _subscription?.cancel();
    _audioPlayer.dispose();
  }
}
