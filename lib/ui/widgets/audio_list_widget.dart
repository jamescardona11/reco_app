import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/provider/player/app_player.dart';
import 'package:audio_recorder_app/provider/uploader/app_uploader.dart';
import 'package:audio_recorder_app/ui/widgets/audio_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioListWidget extends ConsumerWidget {
  const AudioListWidget({
    super.key,
    required this.recordings,
  });

  final List<AudioRecord> recordings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentlyPlaying = ref.watch(appPlayerProvider);

    if (recordings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic_none_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No recordings yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the microphone button to start recording',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: recordings.length,
      itemBuilder: (context, index) {
        final record = recordings[index];
        final isPlaying = currentlyPlaying == record.filePath;

        return AudioItemWidget(
          record: record,
          isPlaying: isPlaying,
          index: index,
          onPlay: () => ref.read(appPlayerProvider.notifier).playAudio(record.filePath),
          onUpload: () => ref.read(appUploaderProvider.notifier).upload(record),
        );
      },
    );
  }
}
