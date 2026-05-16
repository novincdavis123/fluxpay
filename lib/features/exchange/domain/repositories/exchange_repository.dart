import '../entities/exchange_rate_entity.dart';

abstract class ExchangeRepository {
  Future<ExchangeRateEntity> getExchangeRate({
    required String from,
    required String to,
  });
}
