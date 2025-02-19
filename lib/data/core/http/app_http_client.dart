import 'http_request.dart';
import 'http_result.dart';

abstract class AppHttpClient {
  Future<HttpResult> createRequest(HttpRequest request);

  Duration get timeout => const Duration(milliseconds: 3000);
}

bool isSuccessRequest(int? statusCode) =>
    statusCode != null &&
    ![
      100, // Custom code
      400, // Bad Request
      401, // Unauthorized
      402, // Payment Required
      403, // Forbidden
      404, // Not Found
      405, // Method Not Allowed,
      413, // Request Entity Too Large
      414, // Request URI Too Long,
      415, // Unsupported Media Type
    ].contains(statusCode);
