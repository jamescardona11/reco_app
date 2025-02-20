import 'package:audio_recorder_app/provider/player/app_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayingFrom extends ConsumerWidget {
  const PlayingFrom({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayingAudio = ref.watch(appPlayerProvider);

    if (currentPlayingAudio == null) {
      return const SizedBox.shrink();
    }

    if (currentPlayingAudio.fileUrl != null) {
      return Center(
        child: Text('Playing from Cloud'),
      );
    }

    return Center(
      child: Text('Playing from Local'),
    );
  }
}
