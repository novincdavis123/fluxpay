import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

import 'package:fluxpay/core/network/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;

  AuthInterceptor({required this.tokenStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await tokenStorage.accessToken;

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';

        if (kDebugMode) {
          debugPrint('🔐 Auth token attached');
        }
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ No auth token found');
        }
      }

      super.onRequest(options, handler);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to attach auth token: $e');
      }

      super.onRequest(options, handler);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('════════ AUTH ERROR ════════');

        debugPrint('❌ Unauthorized request');

        debugPrint('🔄 Token refresh required');

        debugPrint('════════════════════════════');
      }

      /// FUTURE IMPLEMENTATION:
      ///
      /// 1. Refresh access token
      /// 2. Retry original request
      /// 3. Logout if refresh fails
      /// 4. Navigate to login screen
    }

    super.onError(err, handler);
  }
}
