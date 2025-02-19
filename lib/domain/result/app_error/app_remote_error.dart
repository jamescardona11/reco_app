import 'dart:async';
import 'dart:io';

import 'app_error.dart';

abstract class AppRemoteError extends AppError {
  final int? statusCode;

  const AppRemoteError(super.message, this.statusCode, {super.error, super.stackTrace});

  static AppRemoteError fromError(dynamic error, StackTrace? stackTrace, int? statusCode) {
    if (error is TimeoutException) {
      return ConnectionTimeoutError(error: error, stackTrace: stackTrace, statusCode: statusCode);
    } else if (error is SocketException) {
      return SocketError(error: error, stackTrace: stackTrace, statusCode: statusCode);
    } else if (error is Exception) {
      return RequestException(error: error, stackTrace: stackTrace, statusCode: statusCode);
    }

    return ResponseError(error: error, stackTrace: stackTrace, statusCode: statusCode);
  }
}

final class RequestException extends AppRemoteError {
  const RequestException({dynamic error, StackTrace? stackTrace, int? statusCode})
      : super(
          'Request exception',
          statusCode,
          error: error,
          stackTrace: stackTrace,
        );
}

final class ResponseError extends AppRemoteError {
  const ResponseError({dynamic error, StackTrace? stackTrace, int? statusCode})
      : super(
          'Response error',
          statusCode,
          error: error,
          stackTrace: stackTrace,
        );
}

final class ConnectionTimeoutError extends AppRemoteError {
  const ConnectionTimeoutError({dynamic error, StackTrace? stackTrace, int? statusCode})
      : super(
          'Connection timeout',
          statusCode,
          error: error,
          stackTrace: stackTrace,
        );
}

final class SocketError extends AppRemoteError {
  const SocketError({dynamic error, StackTrace? stackTrace, int? statusCode})
      : super(
          'Socket error',
          statusCode,
          error: error,
          stackTrace: stackTrace,
        );
}
