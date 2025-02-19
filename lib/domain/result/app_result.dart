import 'app_error/app_error.dart';

part 'app_result_error.dart';
part 'app_result_ok.dart';

/// Utility class to wrap result data
/// https://docs.flutter.dev/app-architecture/design-patterns/result#using-the-result-pattern
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Error(): {
///     print(result.error);
///   }
/// }
/// ```
sealed class AppResult<T> {
  const AppResult();

  /// Creates an instance of Result containing a value
  factory AppResult.ok(T value) => Ok(value);

  /// Create an instance of Result containing an error
  factory AppResult.error(AppError error) => Error(error);

  /// Convenience method to cast to Ok
  Ok<T> get asOk => this as Ok<T>;

  /// Convenience method to cast to Error
  Error get asError => this as Error<T>;

  /// Returns a nullable value if the result is Ok
  bool get isError => this is Error;

  /// Returns a nullable value if the result is Ok
  bool get isOk => this is Ok;
}

typedef SuccessCompletion<V, T> = T Function(V value);
typedef ErrorCompletion<V, T> = T Function(V error);

extension ResultFold<T> on AppResult<T> {
  /// Returns a new value of [AppResult] from closure
  R fold<R>(ErrorCompletion<AppError, R> failure, SuccessCompletion<T, R> success) {
    if (isOk) {
      final right = this as Ok<T>;
      return success(right.value);
    } else {
      final left = this as Error;
      return failure(left.error);
    }
  }
}
