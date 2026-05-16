import 'package:decimal/decimal.dart';

class ExchangeCalculationResult {
  final Decimal exchangeRate;
  final Decimal fee;
  final Decimal senderPays;
  final Decimal recipientGets;
  final Decimal totalPayable;

  const ExchangeCalculationResult({
    required this.exchangeRate,
    required this.fee,
    required this.senderPays,
    required this.recipientGets,
    required this.totalPayable,
  });
}
