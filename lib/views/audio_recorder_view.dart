import 'package:audio_recorder_app/provider/recorder/app_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/app_bar_widget.dart';
import 'components/audio_list_widget.dart';

class AudioRecorderView extends ConsumerWidget {
  const AudioRecorderView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderState = ref.watch(appRecorderProvider);

    return Scaffold(
      appBar: const RecorderAppBar(),
      body: Column(
        children: [
          if (recorderState.isRecording)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: Colors.red.shade50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.red.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Recording...',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: recorderState.recordings.isEmpty
                ? const Center(
                    child: Text('No recordings yet'),
                  )
                : const AudioListWidget(),
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
