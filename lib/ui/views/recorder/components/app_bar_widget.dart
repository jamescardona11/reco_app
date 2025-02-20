import 'package:audio_recorder_app/provider/uploader/app_uploader.dart';
import 'package:audio_recorder_app/ui/views/uploader_state/uploader_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecorderAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const RecorderAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uploaderState = ref.watch(appUploaderProvider);
    final isUploading = uploaderState.isUploadingInProgress;

    return AppBar(
      title: const Text(
        'Reco APP',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.cloud_upload_outlined),
              onPressed: () {
                _showUploadingBottomSheet(context, ref);
              },
              tooltip: 'Show uploading recordings',
            ),
            if (isUploading)
              Positioned(
                right: 8,
                top: 8,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(seconds: 1),
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.8),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.5),
                            spreadRadius: value * 2,
                            blurRadius: value * 3,
                          ),
                        ],
                      ),
                      child: const SizedBox(
                        width: 4,
                        height: 4,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showUploadingBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const UploaderBottomSheet(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
