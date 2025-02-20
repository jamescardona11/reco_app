import 'package:audio_recorder_app/provider/uploader/app_uploader.dart';
import 'package:audio_recorder_app/ui/widgets/audio_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploaderBottomSheet extends ConsumerWidget {
  const UploaderBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploaderState = ref.watch(appUploaderProvider);
    final isUploading = uploaderState.isUploadingInProgress;
    final audioRecords = uploaderState.recordings;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          // Bottom sheet handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.cloud_upload_outlined, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Upload Progress',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Upload progress
          if (!isUploading)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_done_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No active uploads',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else if (audioRecords.isNotEmpty)
            Expanded(
              child: AudioListWidget(
                recordings: audioRecords,
              ),
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
