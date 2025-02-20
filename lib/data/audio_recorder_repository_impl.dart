import 'dart:io';

import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/models/audio_recorder_state.dart';
import 'package:audio_recorder_app/domain/repository/audio_recorder_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'core/database/app_database.dart';

class AudioRecorderRepositoryImpl implements AudioRecorderRepository {
  final AppDatabase _appDatabase;

  AudioRecorderRepositoryImpl(this._appDatabase);

  late final String _pathFile;

  final _audioRecorder = AudioRecorder();
  final _recordingState = BehaviorSubject.seeded(AudioRecorderState.idle);
  String? _currentId;

  @override
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    _pathFile = '${directory.path}/recordings';
  }

  @override
  Future<void> startRecording() async {
    if (_recordingState.value.isIdle) {
      _recordingState.add(AudioRecorderState.recording);
      _currentId = Uuid().v4();

      await _audioRecorder.start(RecordConfig(), path: _pathFromCurrentId);
    }
  }

  @override
  Future<void> stopRecording() async {
    if (!_recordingState.value.isRecording) return;
    _recordingState.add(AudioRecorderState.stopped);

    try {
      await _audioRecorder.stop();

      final file = File(_pathFromCurrentId);
      final exists = await file.exists();
      if (exists) {
        final newRecord = AudioRecord(
          id: _currentId!,
          filePath: _pathFromCurrentId,
          createdAt: DateTime.now(),
        );

        await _appDatabase.upsert(id: newRecord.id, data: newRecord.toJson());
      }
      _recordingState.add(AudioRecorderState.idle);
    } catch (e) {
      _recordingState.add(AudioRecorderState.error);
      debugPrint('Error stopping recording: $e');
    } finally {
      _currentId = null;
    }
  }

  @override
  Future<void> deleteRecording(String id) => _appDatabase.remove(id);

  @override
  Future<bool> hasPermission() => _audioRecorder.hasPermission();

  @override
  Stream<AudioRecorderState> recordingState() => _recordingState.stream;

  @override
  Stream<List<AudioRecord>> watchRecordings() =>
      _appDatabase.watchAll().map((records) => records.map((e) => AudioRecord.fromJson(e)).toList());

  String get _pathFromCurrentId {
    return '$_pathFile$_currentId.m4a';
  }
}
