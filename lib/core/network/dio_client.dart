import 'package:dio/dio.dart';

import 'package:fluxpay/core/network/interceptors/auth_interceptor.dart';

import 'package:fluxpay/core/network/interceptors/logging_interceptor.dart';

import 'package:fluxpay/core/network/token_storage.dart';

class DioClient {
  late final Dio dio;

  DioClient({required TokenStorage tokenStorage}) {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.frankfurter.app',

        connectTimeout: const Duration(seconds: 15),

        receiveTimeout: const Duration(seconds: 15),

        sendTimeout: const Duration(seconds: 15),
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage: tokenStorage),

      LoggingInterceptor(),
    ]);
  }
}
