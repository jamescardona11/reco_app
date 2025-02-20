import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/result/app_error/app_error.dart';

class AppUploaderState {
  final Map<String, AudioRecordUploadState> audioRecords;
  final bool isUploadingInProgress;

  AppUploaderState({
    this.audioRecords = const {},
    this.isUploadingInProgress = false,
  });

  bool isCurrentUploading(String id) {
    return audioRecords[id]?.isInProgress ?? false;
  }

  List<AudioRecord> get recordings => audioRecords.values.map((e) => e.audioRecord).toList();

  AppUploaderState copyWith({
    Map<String, AudioRecordUploadState>? audioRecords,
    bool? isInProgress,
  }) {
    return AppUploaderState(
      audioRecords: audioRecords ?? this.audioRecords,
      isUploadingInProgress: isInProgress ?? isUploadingInProgress,
    );
  }
}

class AudioRecordUploadState {
  final AudioRecord audioRecord;
  final bool isInProgress;
  final AppError? error;

  AudioRecordUploadState({
    required this.audioRecord,
    this.isInProgress = false,
    this.error,
  });

  AudioRecordUploadState copyWith({
    AudioRecord? audioRecord,
    bool? isInProgress,
    AppError? error,
  }) {
    return AudioRecordUploadState(
      audioRecord: audioRecord ?? this.audioRecord,
      isInProgress: isInProgress ?? this.isInProgress,
      error: error,
    );
  }
}
