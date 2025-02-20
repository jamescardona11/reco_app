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
    return audioRecords[id]?.uploadingState == UploadingState.uploading;
  }

  List<AudioRecord> get recordings => audioRecords.values.map((e) => e.audioRecord).toList();

  AppUploaderState copyWith({
    Map<String, AudioRecordUploadState>? audioRecords,
    bool? isUploadingInProgress,
  }) {
    return AppUploaderState(
      audioRecords: audioRecords ?? this.audioRecords,
      isUploadingInProgress: isUploadingInProgress ?? this.isUploadingInProgress,
    );
  }
}

class AudioRecordUploadState {
  final AudioRecord audioRecord;
  final UploadingState uploadingState;
  final AppError? error;

  AudioRecordUploadState({
    required this.audioRecord,
    this.uploadingState = UploadingState.uploading,
    this.error,
  });

  AudioRecordUploadState copyWith({
    AudioRecord? audioRecord,
    UploadingState? uploadingState,
    AppError? error,
  }) {
    return AudioRecordUploadState(
      audioRecord: audioRecord ?? this.audioRecord,
      uploadingState: uploadingState ?? this.uploadingState,
      error: error,
    );
  }
}

enum UploadingState {
  uploading,
  error,
  completed,
}
