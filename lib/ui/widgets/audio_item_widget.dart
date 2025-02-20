import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AudioItemWidget extends StatelessWidget {
  const AudioItemWidget({
    super.key,
    required this.record,
    required this.isPlaying,
    required this.onPlay,
    required this.index,
    this.onUpload,
  });

  final AudioRecord record;
  final int index;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback? onUpload;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlay,
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
            // Action Buttons
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.upload_rounded,
                    color: Colors.blue.shade700,
                  ),
                  onPressed: onUpload,
                  tooltip: 'Upload recording',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade400,
                  ),
                  onPressed: () {},
                  tooltip: 'Delete recording',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
