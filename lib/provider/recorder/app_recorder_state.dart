import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/result/app_error/app_error.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppRecorderState {
  final bool isRecording;
  final List<AudioRecord> recordings;
  final AppError? error;

  const AppRecorderState({
    this.isRecording = false,
    this.recordings = const [],
    this.error,
  });

  AppRecorderState copyWith({
    bool? isRecording,
    List<AudioRecord>? recordings,
    AppError? error,
  }) {
    return AppRecorderState(
      isRecording: isRecording ?? this.isRecording,
      recordings: recordings ?? this.recordings,
      error: error,
    );
  }
}
