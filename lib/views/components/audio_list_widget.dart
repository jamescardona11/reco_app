import 'package:audio_recorder_app/provider/player/app_player.dart';
import 'package:audio_recorder_app/provider/recorder/app_recorder.dart';
import 'package:audio_recorder_app/provider/uploader/app_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AudioListWidget extends ConsumerWidget {
  const AudioListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayingPath = ref.watch(appPlayerProvider);
    final recorderState = ref.watch(appRecorderProvider);

    return ListView.builder(
      itemCount: recorderState.recordings.length,
      itemBuilder: (context, index) {
        final record = recorderState.recordings[index];
        final isPlaying = currentPlayingPath == record.filePath;

        return InkWell(
          onTap: () {
            ref.read(appPlayerProvider.notifier).playAudio(record.filePath);
          },
          child: Row(
            children: [
              Icon(
                isPlaying ? Icons.pause_circle : Icons.play_circle,
                color: isPlaying ? Colors.blue : Colors.grey,
              ),
              Column(
                children: [
                  Text(
                    'Recording ${index + 1}',
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(record.createdAt),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      ref.read(appRecorderProvider.notifier).deleteRecording(record.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.upload),
                    onPressed: () {
                      ref.read(appUploaderProvider.notifier).upload(record);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
