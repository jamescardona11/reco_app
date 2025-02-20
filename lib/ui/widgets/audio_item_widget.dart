import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/models/uploading_state.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AudioItemWidget extends StatelessWidget {
  const AudioItemWidget({
    super.key,
    required this.record,
    this.uploadingState,
    required this.isPlaying,
    required this.onPlay,
    required this.index,
    this.onUpload,
    this.onDownload,
  });

  final AudioRecord record;
  final UploadingState? uploadingState;
  final int index;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback? onUpload;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlay,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 4),
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
                onPressed: onPlay,
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
            if (uploadingState != null) ...[
              if (uploadingState!.isUploading) const CircularProgressIndicator(),
              if (uploadingState!.isError)
                IconButton(
                  icon: const Icon(Icons.error_outline_rounded),
                  onPressed: onUpload,
                ),
              if (uploadingState!.isCompleted)
                IconButton(
                  icon: const Icon(Icons.check_circle_rounded),
                  onPressed: onUpload,
                ),
            ] else ...[
              Row(
                children: [
                  if (record.fileUrl == null)
                    IconButton(
                      icon: Icon(
                        Icons.upload_rounded,
                        color: Colors.blue.shade700,
                      ),
                      onPressed: onUpload,
                      tooltip: 'Upload recording',
                    )
                  else if (record.downloadFilePath == null)
                    IconButton(
                      icon: Icon(
                        Icons.download_rounded,
                        color: Colors.blue.shade700,
                      ),
                      onPressed: onDownload,
                      tooltip: 'Download recording',
                    )
                  else
                    Icon(
                      Icons.check,
                      color: Colors.blue.shade700,
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
