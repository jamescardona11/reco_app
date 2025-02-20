import 'dart:async';

import 'package:audio_recorder_app/config/di.dart';
import 'package:audio_recorder_app/domain/result/app_error/custom_def_errors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_recorder_state.dart';

part 'app_recorder.g.dart';

@riverpod
class AppRecorder extends _$AppRecorder {
  StreamSubscription? _isRecordingSubscription;
  StreamSubscription? _recordingItemsSubscription;

  @override
  AppRecorderState build() {
    _init();

    ref.onDispose(() {
      _isRecordingSubscription?.cancel();
      _recordingItemsSubscription?.cancel();
    });

    return AppRecorderState(
      isPermissionGranted: false,
    );
  }

  Future<void> _init() async {
    final repository = ref.read(audioRecorderRepositoryProvider);

    _isRecordingSubscription = repository.recordingState().distinct().map((state) => state.isRecording).listen((isRecording) {
      state = state.copyWith(isRecording: isRecording);
    });

    _recordingItemsSubscription = repository.watchRecordings().listen((recordings) {
      state = state.copyWith(recordings: recordings);
    });

    final hasPermission = (await Permission.microphone.status).isGranted;
    state = state.copyWith(isPermissionGranted: hasPermission);
  }

  Future<void> startRecording() async {
    if (!state.isPermissionGranted) {
      await _requestPermission();
    }

    if (!state.isPermissionGranted) {
      state = state.copyWith(error: const PermissionDeniedError());
      return;
    }

    final repository = ref.read(audioRecorderRepositoryProvider);
    await repository.startRecording();
  }

  Future<void> stopRecording() async {
    final repository = ref.read(audioRecorderRepositoryProvider);
    await repository.stopRecording();
  }

  Future<void> deleteRecording(String id) async {
    final repository = ref.read(audioRecorderRepositoryProvider);
    await repository.deleteRecording(id);
  }

  Future<void> _requestPermission() async {
    await Permission.microphone.request();
    final hasPermission = await ref.read(audioRecorderRepositoryProvider).hasPermission();
    state = state.copyWith(isPermissionGranted: hasPermission);
  }
}
