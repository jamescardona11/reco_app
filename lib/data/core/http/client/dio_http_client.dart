import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../app_http_client.dart';
import '../http_request.dart';
import '../http_result.dart';

class DioHttpClient extends AppHttpClient {
  DioHttpClient(this.dio) : super();

  final Dio dio;

  @override
  Future<HttpResult> createRequest(HttpRequest request) async {
    try {
      final response = await switch (request.method) {
        Method.GET => _getRequest(request),
        Method.POST => _postRequest(request),
        Method.PUT => _putRequest(request),
        Method.DELETE => _deleteRequest(request),
        Method.PATCH => _patchRequest(request),
      };

      if (isSuccessRequest(response.statusCode)) {
        return HttpResult.success(
          statusCode: response.statusCode,
          data: response.data,
          originalRequest: request,
        );
      } else {
        debugPrint('Error request ${response.data}');
        return HttpResult.failure(
          originalRequest: request,
          error: response.data,
          statusCode: response.statusCode,
        );
      }
    } catch (err, stackTrace) {
      return HttpResult.failure(
        originalRequest: request,
        error: err,
        stackTrace: stackTrace,
        statusCode: 100, //custom code
      );
    }
  }

  Future<Response<dynamic>> _getRequest(HttpRequest request) async {
    final headers = request.headers ?? {};
    return dio
        .get(
          request.path,
          queryParameters: request.queryParameters,
          options: Options(
            headers: headers,
          ),
        )
        .timeout(timeout);
  }

  Future<Response<dynamic>> _postRequest(HttpRequest request) async {
    final headers = request.headers ?? {};
    return dio
        .post(
          request.path,
          data: request.data,
          options: Options(
            headers: headers,
          ),
        )
        .timeout(timeout);
  }

  Future<Response<dynamic>> _putRequest(HttpRequest request) async {
    final headers = request.headers ?? {};
    return dio
        .put(
          request.path,
          data: request.data,
          options: Options(
            headers: headers,
          ),
        )
        .timeout(timeout);
  }

  Future<Response<dynamic>> _deleteRequest(HttpRequest request) async {
    final headers = request.headers ?? {};
    return dio
        .delete(
          request.path,
          options: Options(
            headers: headers,
          ),
        )
        .timeout(timeout);
  }

  Future<Response<dynamic>> _patchRequest(HttpRequest request) async {
    final headers = request.headers ?? {};
    return dio
        .patch(
          request.path,
          data: request.data,
          options: Options(
            headers: headers,
          ),
        )
        .timeout(timeout);
  }
}
