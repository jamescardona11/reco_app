import 'dart:async';

import 'package:audio_recorder_app/config/di.dart';
import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/types/json_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_uploader_state.dart';

part 'app_uploader.g.dart';

@riverpod
class AppUploader extends _$AppUploader {
  @override
  AppUploaderState build() {
    return AppUploaderState();
  }

  Future<void> init(JsonType credentials) async {
    final cloudRepository = ref.read(cloudUploaderRepositoryProvider);
    await cloudRepository.init(credentials);
  }

  Future<void> upload(AudioRecord audioRecord) async {
    if (state.isCurrentUploading(audioRecord.id)) return;

    state = state.copyWith(
      audioRecords: {
        ...state.audioRecords,
        audioRecord.id: AudioRecordUploadState(
          audioRecord: audioRecord,
          isInProgress: true,
        ),
      },
      isInProgress: true,
    );

    final cloudRepository = ref.read(cloudUploaderRepositoryProvider);
    final appDatabase = ref.read(appDatabaseProvider);

    final response = await cloudRepository.upload(audioRecord);

    if (response.isOk) {
      final audioRecord = response.asOk.value;
      await appDatabase.upsert(id: audioRecord.id, data: audioRecord.toJson());

      state = state.copyWith(
        audioRecords: {
          ...state.audioRecords,
          audioRecord.id: AudioRecordUploadState(
            audioRecord: audioRecord,
            isInProgress: false,
          ),
        },
        isInProgress: false,
      );
    } else {
      state = state.copyWith(
        audioRecords: {
          ...state.audioRecords,
          audioRecord.id: AudioRecordUploadState(
            audioRecord: audioRecord,
            isInProgress: false,
            error: response.appError,
          ),
        },
        isInProgress: false,
      );
    }
  }

  Future<void> download(AudioRecord audioRecord) async {
    if (audioRecord.downloadUrl == null) return;

    state = state.copyWith(
      audioRecords: {
        ...state.audioRecords,
        audioRecord.id: AudioRecordUploadState(
          audioRecord: audioRecord,
          isInProgress: true,
        ),
      },
      isInProgress: true,
    );

    final cloudRepository = ref.read(cloudUploaderRepositoryProvider);
    final response = await cloudRepository.download(audioRecord);

    if (response.isOk) {
      final appDatabase = ref.read(appDatabaseProvider);

      final audioRecord = response.asOk.value;
      await appDatabase.upsert(id: audioRecord.id, data: audioRecord.toJson());

      state = state.copyWith(
        audioRecords: {
          ...state.audioRecords,
          audioRecord.id: AudioRecordUploadState(
            audioRecord: audioRecord,
            isInProgress: false,
          ),
        },
        isInProgress: false,
      );
    } else {
      state = state.copyWith(
        audioRecords: {
          ...state.audioRecords,
          audioRecord.id: AudioRecordUploadState(
            audioRecord: audioRecord,
            isInProgress: false,
            error: response.appError,
          ),
        },
        isInProgress: false,
      );
    }
  }
}
