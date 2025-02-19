import 'package:audio_recorder_app/data/core/database/app_database.dart';
import 'package:audio_recorder_app/data/core/database/mock_app_database_impl.dart';
import 'package:audio_recorder_app/data/core/http/app_http_client.dart';
import 'package:audio_recorder_app/data/core/http/client/dio_http_client.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'di.g.dart';

@Riverpod(keepAlive: true)
AppHttpClient appHttpClient(ref) {
  return DioHttpClient(Dio());
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(ref) {
  return MockAppDatabaseImpl();
}
