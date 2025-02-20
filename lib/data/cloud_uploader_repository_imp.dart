import 'dart:io';

import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/repository/cloud_uploader_repository.dart';
import 'package:audio_recorder_app/domain/result/app_error/custom_def_errors.dart';
import 'package:audio_recorder_app/domain/result/app_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:mime/mime.dart';

class CloudUploaderRepositoryImpl implements CloudUploaderRepository {
  CloudUploaderRepositoryImpl();

  late auth.AutoRefreshingAuthClient _client;
  @override
  Future<void> init() async {
    final credentials = await rootBundle.loadString('credentials/credentials.json');
    _client = await auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(credentials), Storage.SCOPES);

    debugPrint('CloudUploaderRepositoryImpl init with credentials: ${_client.credentials.toJson()}');
  }

  @override
  Future<AppResult<String>> upload(AudioRecord audioRecord) async {
    try {
      final file = File(audioRecord.filePath);
      final bytes = await file.readAsBytes();

      // Instantiate objects to cloud storage
      final storage = Storage(_client, 'flutter-learning-apps');
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

      return AppResult.ok(response.downloadLink.toString());
    } catch (e) {
      debugPrint('CloudUploaderRepositoryImpl upload error: $e');

      return AppResult.error(UploadingDataError());
    }
  }
}
