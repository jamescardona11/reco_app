import 'package:audio_recorder_app/provider/recorder/app_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioRecorderView extends ConsumerWidget {
  const AudioRecorderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderState = ref.watch(appRecorderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recorder'),
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
                : SizedBox(),
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
