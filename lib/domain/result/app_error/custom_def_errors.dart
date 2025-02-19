import 'app_error.dart';

final class UnexpectedError extends AppError {
  const UnexpectedError({dynamic error, StackTrace? stackTrace}) : super('UnexpectedError', error: error, stackTrace: stackTrace);
}

final class FetchingDataError extends AppError {
  final int? code;
  const FetchingDataError(super.message, {this.code});
}

final class UpsertError extends AppError {
  const UpsertError() : super('Upsert Error');
}

final class ValueError extends AppError {
  const ValueError() : super('Encountered a Unexpected Value');
}

final class PureException extends AppError {
  const PureException(Exception exception) : super('Pure Exception', error: exception);
}
