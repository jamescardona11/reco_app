import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/models/audio_recorder_state.dart';

abstract class AudioRecorderRepository {
  Future<void> init();

  Future<void> startRecording();

  Future<void> stopRecording();

  Future<void> deleteRecording(String id);

  Future<bool> hasPermission();

  Stream<AudioRecorderState> recordingState();

  Stream<List<AudioRecord>> watchRecordings();
}
