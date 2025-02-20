import 'package:audio_recorder_app/provider/player/app_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayingFrom extends ConsumerWidget {
  const PlayingFrom({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPlayingAudio = ref.watch(appPlayerProvider);

    if (currentPlayingAudio == null) {
      return const SizedBox.shrink();
    }

    final isCloudPlayback = currentPlayingAudio.fileUrl != null && currentPlayingAudio.downloadFilePath == null;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(isCloudPlayback),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isCloudPlayback ? Colors.blue.shade50 : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCloudPlayback ? Colors.blue.shade100 : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated playing indicator
            _PlayingIndicator(isCloudPlayback: isCloudPlayback),
            const SizedBox(width: 8),
            // Source text
            Text(
              isCloudPlayback
                  ? 'Playing from Cloud'
                  : currentPlayingAudio.downloadFilePath == null
                      ? 'Playing from Local - Original'
                      : 'Playing from Local - Download',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isCloudPlayback ? Colors.blue.shade700 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayingIndicator extends StatefulWidget {
  final bool isCloudPlayback;

  const _PlayingIndicator({
    required this.isCloudPlayback,
  });

  @override
  State<_PlayingIndicator> createState() => _PlayingIndicatorState();
}

class _PlayingIndicatorState extends State<_PlayingIndicator> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animations = List.generate(
      3,
      (index) => Tween<double>(begin: 3, end: 8).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isCloudPlayback ? Colors.blue.shade700 : Colors.grey.shade700;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: _animations.map((animation) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 2,
              height: animation.value,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
