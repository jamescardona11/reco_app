part of 'app_result.dart';

/// Subclass of Result for values
final class Ok<T> extends AppResult<T> {
  const Ok(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}
