import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_player.g.dart';

@riverpod
class AppPlayer extends _$AppPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _subscription;

  @override
  String? build() {
    _initSubscription();
    ref.onDispose(_dispose);

    return null;
  }

  Future<void> playAudio(String filePath) async {
    await _audioPlayer.stop();

    if (state == filePath) {
      state = null;
    } else {
      await _audioPlayer.play(DeviceFileSource(filePath));
      state = filePath;
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
