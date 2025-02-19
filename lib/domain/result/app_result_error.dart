part of 'app_result.dart';

/// Subclass of Result for errors
final class Error<T> extends AppResult<T> {
  const Error(this.error);

  final AppError error;

  @override
  String toString() => 'Result<$T>.error($error)';
}
