import 'dart:convert';

import 'package:audio_recorder_app/provider/recorder/app_recorder.dart';
import 'package:audio_recorder_app/provider/uploader/app_uploader.dart';
import 'package:audio_recorder_app/ui/widgets/audio_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/app_bar_widget.dart';
import 'components/playing_from.dart';

class AudioRecorderView extends ConsumerStatefulWidget {
  const AudioRecorderView({super.key});

  @override
  ConsumerState<AudioRecorderView> createState() => _AudioRecorderViewState();
}

class _AudioRecorderViewState extends ConsumerState<AudioRecorderView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      rootBundle.loadString('credentials/credentials.json').then((json) {
        final credentials = jsonDecode(json);
        ref.read(appUploaderProvider.notifier).init(credentials);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final recorderState = ref.watch(appRecorderProvider);

    return Scaffold(
      appBar: const RecorderAppBar(),
      body: Column(
        children: [
          const PlayingFrom(),
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
                : AudioListWidget(
                    recordings: recorderState.recordings,
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
