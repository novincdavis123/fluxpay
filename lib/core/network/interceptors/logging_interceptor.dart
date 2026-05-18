import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  void log(dynamic message) {
    // Only log in debug mode to avoid performance issues in production
    if (kDebugMode) {
      debugPrint(message.toString());
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final startTime = DateTime.now();

    options.extra['startTime'] = startTime;

    log('');

    log('╔══════════════════ HTTP REQUEST ══════════════════');

    log('║ METHOD: ${options.method}');

    log('║ URL: ${options.baseUrl}${options.path}');

    log('║ QUERY: ${options.queryParameters}');

    log('║ HEADERS:');

    options.headers.forEach((key, value) {
      log('║   $key: $value');
    });

    if (options.data != null) {
      log('║ BODY: ${options.data}');
    }

    log('╚══════════════════════════════════════════════════');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final startTime = response.requestOptions.extra['startTime'] as DateTime?;

    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : 0;

    log('');

    log('╔══════════════════ HTTP RESPONSE ═════════════════');

    log('║ STATUS CODE: ${response.statusCode}');

    log('║ PATH: ${response.requestOptions.path}');

    log('║ RESPONSE TIME: ${duration}ms');

    log('║ DATA: ${response.data}');

    log('╚══════════════════════════════════════════════════');

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final startTime = err.requestOptions.extra['startTime'] as DateTime?;

    final duration = startTime != null
        ? DateTime.now().difference(startTime).inMilliseconds
        : 0;

    log('');

    log('╔══════════════════ HTTP ERROR ════════════════════');

    log('║ TYPE: ${err.type}');

    log('║ MESSAGE: ${err.message}');

    log('║ PATH: ${err.requestOptions.path}');

    log('║ RESPONSE TIME: ${duration}ms');

    log('║ STATUS CODE: ${err.response?.statusCode}');

    log('║ RESPONSE DATA: ${err.response?.data}');

    log('╚══════════════════════════════════════════════════');

    super.onError(err, handler);
  }
}
