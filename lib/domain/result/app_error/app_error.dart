abstract class AppError {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const AppError(this.message, {this.error, this.stackTrace});

  @override
  String toString() {
    var msg = 'ErrorType [$runtimeType], \n message: $message,';
    if (error is Error) {
      msg += '\n${(error as Error).stackTrace}';
    }
    if (stackTrace != null) {
      msg += '\nSource stack:\n$stackTrace';
    }

    return Error.safeToString(msg);
  }

  @override
  bool operator ==(covariant AppError other) {
    if (identical(this, other)) return true;

    return other.message == message && other.error == error && other.stackTrace == stackTrace;
  }

  @override
  int get hashCode => message.hashCode ^ error.hashCode ^ stackTrace.hashCode;
}
