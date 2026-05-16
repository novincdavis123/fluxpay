import 'package:dio/dio.dart';

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
        '/latest?from=$from&to=$to',
        queryParameters: {'from': from, 'to': to},
      );

      return ExchangeRateModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Failed to fetch exchange rates');
    }
  }
}
