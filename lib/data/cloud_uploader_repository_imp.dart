import 'dart:io';

import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/repository/cloud_uploader_repository.dart';
import 'package:audio_recorder_app/domain/result/app_error/custom_def_errors.dart';
import 'package:audio_recorder_app/domain/result/app_result.dart';
import 'package:audio_recorder_app/domain/types/json_type.dart';
import 'package:flutter/foundation.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:mime/mime.dart';

class CloudUploaderRepositoryImpl implements CloudUploaderRepository {
  CloudUploaderRepositoryImpl();

  auth.AutoRefreshingAuthClient? _client;

  @override
  Future<void> init(JsonType credentials) async {
    _client = await auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(credentials), Storage.SCOPES);

    debugPrint('CloudUploaderRepositoryImpl init');
  }

  @override
  Future<AppResult<String>> upload(AudioRecord audioRecord) async {
    try {
      final file = File(audioRecord.filePath);
      final bytes = await file.readAsBytes();

      // Instantiate objects to cloud storage
      final storage = Storage(_client!, 'flutter-learning-apps');
      final bucket = storage.bucket('my_bucket_200225');

      // Save to bucket
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final type = lookupMimeType(audioRecord.name);
      final ObjectInfo response = await bucket.writeBytes(
        audioRecord.name,
        bytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ),
      );

      String url = response.downloadLink.toString().split('?')[0];
      url = url.split('/o/')[1];
      url = 'https://storage.cloud.google.com/my_bucket_200225/$url';

      return AppResult.ok(url);
    } catch (e) {
      debugPrint('CloudUploaderRepositoryImpl upload error: $e');

      return AppResult.error(UploadingDataError());
    }
  }
}
