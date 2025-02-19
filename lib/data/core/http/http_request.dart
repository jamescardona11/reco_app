class HttpRequest {
  String path;
  Method method;
  ContentType? contentType;
  Map<String, dynamic>? data;
  Map<String, String>? queryParameters;
  Map<String, String>? headers;

  HttpRequest({
    required this.path,
    required this.method,
    this.data,
    this.contentType,
    this.queryParameters,
  });
}

enum Method {
  GET('get'),
  POST('post'),
  PUT('put'),
  DELETE('delete'),
  PATCH('patch');

  const Method(this._value);

  final String _value;

  String get value => _value;
}

enum ContentType {
  binary('application/octet-stream'),
  json('application/json; charset=utf-8'),
  onlyJson('application/json');

  const ContentType(this._value);

  final String _value;

  String get value => _value;

  @override
  String toString() => value;
}
