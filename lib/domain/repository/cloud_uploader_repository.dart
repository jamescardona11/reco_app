import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/result/app_result.dart';

abstract class CloudUploaderRepository {
  Future<void> init();

  Future<AppResult<String>> upload(AudioRecord audioRecord);
}
