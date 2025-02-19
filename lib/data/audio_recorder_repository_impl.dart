import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/models/audio_recorder_state.dart';
import 'package:audio_recorder_app/domain/repository/audio_recorder_repository.dart';
import 'package:record/record.dart';

import 'core/database/app_database.dart';

class AudioRecorderRepositoryImpl implements AudioRecorderRepository {
  final AppDatabase _appDatabase;

  AudioRecorderRepositoryImpl(this._appDatabase);

  final _audioRecorder = AudioRecorder();
  String? _currentRecordingPath;
  final List<AudioRecord> _recordings = [];

  @override
  Future<void> deleteRecording(String id) {
    // TODO: implement deleteRecording
    throw UnimplementedError();
  }

  @override
  Future<bool> hasPermission() {
    // TODO: implement hasPermission
    throw UnimplementedError();
  }

  @override
  Stream<AudioRecorderState> recordingState() {
    // TODO: implement recordingState
    throw UnimplementedError();
  }

  @override
  Future<void> startRecording() {
    // TODO: implement startRecording
    throw UnimplementedError();
  }

  @override
  Future<void> stopRecording() {
    // TODO: implement stopRecording
    throw UnimplementedError();
  }

  @override
  Stream<List<AudioRecord>> watchRecordings() {
    // TODO: implement watchRecordings
    throw UnimplementedError();
  }
}
