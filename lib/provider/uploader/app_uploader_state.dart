import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/result/app_error/app_error.dart';

class AppUploaderState {
  final AudioRecord? audioRecord;
  final double? progress;
  final AppError? error;
  final bool isUploading;

  AppUploaderState({
    this.audioRecord,
    this.progress,
    this.error,
    this.isUploading = false,
  });

  AppUploaderState copyWith({
    AudioRecord? audioRecord,
    double? progress,
    AppError? error,
    bool? isUploading,
  }) {
    return AppUploaderState(
      audioRecord: audioRecord ?? this.audioRecord,
      progress: progress ?? this.progress,
      error: error,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
