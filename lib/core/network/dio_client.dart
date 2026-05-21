import 'package:dio/dio.dart';

import 'package:fluxpay/core/network/api_constants.dart';

import 'package:fluxpay/core/network/interceptors/logging_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,

        connectTimeout: ApiConstants.connectTimeout,

        receiveTimeout: ApiConstants.receiveTimeout,

        sendTimeout: ApiConstants.sendTimeout,
      ),
    );

    dio.interceptors.addAll([LoggingInterceptor()]);
  }
}
