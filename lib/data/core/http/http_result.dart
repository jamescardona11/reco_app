import 'package:audio_recorder_app/domain/result/app_error/app_error.dart';
import 'package:audio_recorder_app/domain/result/app_error/app_remote_error.dart';

import 'app_http_client.dart';
import 'http_request.dart';

class HttpResult {
  // Request info.
  final HttpRequest originalRequest;

  // Error
  final AppError? appError;

  // Response
  final dynamic data;
  final int? statusCode;

  HttpResult._({
    required this.originalRequest,
    this.data,
    this.statusCode,
    this.appError,
  });

  factory HttpResult.success({
    required dynamic data,
    required HttpRequest originalRequest,
    int? statusCode,
  }) =>
      HttpResult._(
        data: data,
        originalRequest: originalRequest,
        statusCode: statusCode,
      );

  factory HttpResult.failure({
    required dynamic error,
    required HttpRequest originalRequest,
    int? statusCode,
    StackTrace? stackTrace,
  }) =>
      HttpResult._(
        originalRequest: originalRequest,
        statusCode: statusCode,
        appError: AppRemoteError.fromError(error, stackTrace, statusCode),
      );

  /// Returns true if [Result] is [Failure].
  bool get isFailure => appError != null || !isSuccess;

  /// Returns true if [Result] is [Success].
  bool get isSuccess => isSuccessRequest(statusCode);

  Map<String, dynamic>? get dataJson => data is Map<String, dynamic> ? data as Map<String, dynamic> : null;

  List<int>? get dataBytes => data is List<int> ? data as List<int> : null;

  String? get dataString => data is String ? data as String : null;

  String get errorMessage {
    return appError?.error is List<int> ? String.fromCharCodes(appError!.error) : (appError.toString());
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'SuccessResult(\nstatusCode: $statusCode, data: $data, }\n)';
    }

    return 'FailureResult \nstatusCode: $statusCode, \nError: ${appError?.toString()}';
  }
}
