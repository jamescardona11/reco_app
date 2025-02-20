import 'app_error.dart';

final class UnexpectedError extends AppError {
  const UnexpectedError({dynamic error, StackTrace? stackTrace}) : super('UnexpectedError', error: error, stackTrace: stackTrace);
}

final class FetchingDataError extends AppError {
  final int? code;
  const FetchingDataError(super.message, {this.code});
}

final class UploadingDataError extends AppError {
  const UploadingDataError() : super('Uploading Data Error');
}

final class UpsertError extends AppError {
  const UpsertError() : super('Upsert Error');
}

final class PermissionDeniedError extends AppError {
  const PermissionDeniedError() : super('Permission Denied');
}
