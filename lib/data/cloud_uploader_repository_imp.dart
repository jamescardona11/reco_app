import 'dart:io';

import 'package:audio_recorder_app/domain/models/audio_record.dart';
import 'package:audio_recorder_app/domain/repository/cloud_uploader_repository.dart';
import 'package:audio_recorder_app/domain/result/app_error/custom_def_errors.dart';
import 'package:audio_recorder_app/domain/result/app_result.dart';
import 'package:audio_recorder_app/domain/types/json_type.dart';
import 'package:flutter/foundation.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

class CloudUploaderRepositoryImpl implements CloudUploaderRepository {
  CloudUploaderRepositoryImpl();

  auth.AutoRefreshingAuthClient? _client;

  static const _bucketName = 'my_bucket_200225';
  late final String _pathFile;

  @override
  Future<void> init(JsonType credentials) async {
    _client = await auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(credentials), Storage.SCOPES);
    final directory = await getApplicationDocumentsDirectory();
    _pathFile = '${directory.path}/recordings';
    debugPrint('CloudUploaderRepositoryImpl init');
  }

  @override
  Future<AppResult<AudioRecord>> upload(AudioRecord audioRecord) async {
    try {
      final file = File(audioRecord.originalFilePath);
      final bytes = await file.readAsBytes();

      // Instantiate objects to cloud storage
      final storage = Storage(_client!, 'flutter-learning-apps');
      final bucket = storage.bucket(_bucketName);

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

      return AppResult.ok(
        audioRecord.copyWith(
          fileUrl: 'https://storage.googleapis.com/$_bucketName/${response.name}',
          downloadUrl: response.downloadLink.toString(),
        ),
      );
    } catch (e) {
      debugPrint('CloudUploaderRepositoryImpl upload error: $e');

      return AppResult.error(UploadingDataError());
    }
  }

  @override
  Future<AppResult<AudioRecord>> download(AudioRecord audioRecord) async {
    final originalName = audioRecord.originalFilePath.split('/').last;
    final newName = 'd_$originalName';

    try {
      final response = await http.get(Uri.parse(audioRecord.downloadUrl!));

      if (response.statusCode == 200) {
        final file = File('$_pathFile/$newName');
        await file.writeAsBytes(response.bodyBytes);

        return AppResult.ok(audioRecord.copyWith(downloadFilePath: '$_pathFile/$newName'));
      } else {
        return AppResult.error(DownloadingDataError());
      }
    } catch (e) {
      return AppResult.error(DownloadingDataError());
    }
  }
}
