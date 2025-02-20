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
    final recorderState = ref.watch(appRecorderProvider);
    final currentlyPlaying = ref.watch(appPlayerProvider);

    if (recorderState.recordings.isEmpty) {
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
      itemCount: recorderState.recordings.length,
      itemBuilder: (context, index) {
        final record = recorderState.recordings[index];
        final isPlaying = currentlyPlaying == record.filePath;

        return InkWell(
          onTap: () {
            ref.read(appPlayerProvider.notifier).playAudio(record.filePath);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Play/Pause Button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isPlaying ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isPlaying ? Colors.blue : Colors.grey.shade700,
                      size: 28,
                    ),
                    onPressed: () {
                      ref.read(appPlayerProvider.notifier).playAudio(record.filePath);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Recording Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recording ${index + 1}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MMM dd, yyyy').format(record.createdAt),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.upload_rounded,
                        color: Colors.blue.shade700,
                      ),
                      onPressed: () {
                        ref.read(appUploaderProvider.notifier).upload(record);
                      },
                      tooltip: 'Upload recording',
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade400,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Recording'),
                            content: const Text('Are you sure you want to delete this recording?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ref.read(appRecorderProvider.notifier).deleteRecording(record.id);
                                },
                                child: Text(
                                  'DELETE',
                                  style: TextStyle(color: Colors.red.shade400),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      tooltip: 'Delete recording',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
