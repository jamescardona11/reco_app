import 'package:audio_recorder_app/config/di.dart';
import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_uploader_state.dart';

part 'app_uploader.g.dart';

@riverpod
class AppUploader extends _$AppUploader {
  @override
  AppUploaderState build() {
    return AppUploaderState();
  }

  Future<void> upload(AudioRecord audioRecord) async {
    final cloudRepository = ref.read(cloudUploaderRepositoryProvider);
    final appDatabase = ref.read(appDatabaseProvider);
    state = state.copyWith(isUploading: true);

    final response = await cloudRepository.upload(audioRecord);

    if (response.isOk) {
      audioRecord = audioRecord.copyWith(fileUrl: response.asOk.value);
      await appDatabase.upsert(id: audioRecord.id, data: audioRecord.toJson());
    } else {
      state = state.copyWith(error: response.appError);
    }
    state = state.copyWith(isUploading: false);
  }
}
