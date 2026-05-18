import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';

import 'package:fluxpay/core/errors/exceptions.dart';

import 'package:fluxpay/core/network/dio_client.dart';

import '../models/exchange_rate_model.dart';

abstract class ExchangeRemoteDataSource {
  Future<ExchangeRateModel> getExchangeRate({
    required String from,
    required String to,
  });
}

class ExchangeRemoteDataSourceImpl implements ExchangeRemoteDataSource {
  final DioClient dioClient;

  ExchangeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<ExchangeRateModel> getExchangeRate({
    required String from,
    required String to,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/latest',
        queryParameters: {'from': from, 'to': to},
      );

      if (response.statusCode == 200 && response.data != null) {
        if (kDebugMode) {
          debugPrint('✅ Exchange rate fetched successfully');
        }

        return ExchangeRateModel.fromJson(response.data);
      }

      throw const ServerException('Invalid server response');
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('════════ EXCHANGE API ERROR ════════');

        debugPrint('TYPE: ${e.type}');

        debugPrint('STATUS: ${e.response?.statusCode}');

        debugPrint('MESSAGE: ${e.message}');

        debugPrint('════════════════════════════════════');
      }

      /// CONNECTION ERRORS
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw const NetworkException('Please check your internet connection');
      }

      /// UNAUTHORIZED
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException(
          'Session expired. Please login again',
        );
      }

      /// VALIDATION ERROR
      if (e.response?.statusCode == 400) {
        throw const ValidationException('Invalid currency request');
      }

      /// SERVER ERROR
      if (e.response?.statusCode == 500) {
        throw const ServerException('Internal server error');
      }

      /// UNKNOWN DIO ERROR
      throw ServerException(e.message ?? 'Unexpected network error occurred');
    } on FormatException {
      throw const ServerException('Invalid response format');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Unexpected exchange datasource error: $e');
      }

      throw const UnknownException('Unexpected error occurred');
    }
  }
}
