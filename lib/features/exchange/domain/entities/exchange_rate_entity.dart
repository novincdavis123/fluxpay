import 'package:decimal/decimal.dart';

class ExchangeRateEntity {
  final String baseCurrency;
  final String targetCurrency;
  final Decimal rate;
  final DateTime timestamp;

  const ExchangeRateEntity({
    required this.baseCurrency,
    required this.targetCurrency,
    required this.rate,
    required this.timestamp,
  });
}
