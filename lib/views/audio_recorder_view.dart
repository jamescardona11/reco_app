import 'package:audio_recorder_app/provider/player/app_player.dart';
import 'package:audio_recorder_app/provider/recorder/app_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class AudioRecorderView extends ConsumerWidget {
  const AudioRecorderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderState = ref.watch(appRecorderProvider);
    final currentPlayingPath = ref.watch(appPlayerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reco APP'),
      ),
      body: Column(
        children: [
          if (recorderState.isRecording)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Recording...', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          Expanded(
            child: recorderState.recordings.isEmpty
                ? const Center(
                    child: Text('No recordings yet'),
                  )
                : ListView.builder(
                    itemCount: recorderState.recordings.length,
                    itemBuilder: (context, index) {
                      final record = recorderState.recordings[index];
                      final isPlaying = currentPlayingPath == record.filePath;

                      return ListTile(
                        leading: Icon(
                          isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: isPlaying ? Colors.blue : Colors.grey,
                        ),
                        title: Text(
                          'Recording ${index + 1}',
                        ),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd').format(record.createdAt),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            ref.read(appRecorderProvider.notifier).deleteRecording(record.id);
                          },
                        ),
                        onTap: () {
                          ref.read(appPlayerProvider.notifier).playAudio(record.filePath);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (recorderState.isRecording) {
            await ref.read(appRecorderProvider.notifier).stopRecording();
          } else {
            await ref.read(appRecorderProvider.notifier).startRecording();
          }
        },
        backgroundColor: recorderState.isRecording ? Colors.red : null,
        child: Icon(recorderState.isRecording ? Icons.stop : Icons.mic),
      ),
    );
  }
}
