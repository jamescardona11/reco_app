import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/result/app_result.dart';
import 'package:audio_recorder_app/domain/types/json_type.dart';

abstract class CloudUploaderRepository {
  Future<void> init(JsonType credentials);

  Future<AppResult<String>> upload(AudioRecord audioRecord);
}
