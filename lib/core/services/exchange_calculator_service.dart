import 'package:decimal/decimal.dart';
import '../models/exchange_calculation_result.dart';

class ExchangeCalculatorService {
  ExchangeCalculationResult calculate({
    required Decimal amount,
    required Decimal rate,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    final fee = _calculateFee(
      amount: amount,
      isWeekend: isWeekend,
      sameCurrency: sameCurrency,
    );

    final recipientGets = amount * rate;

    final totalPayable = amount + fee;

    return ExchangeCalculationResult(
      exchangeRate: rate,
      fee: fee,
      senderPays: amount,
      recipientGets: recipientGets,
      totalPayable: totalPayable,
    );
  }

  Decimal _calculateFee({
    required Decimal amount,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    Decimal fee;
    // Fee structure:
    if (sameCurrency) {
      fee = Decimal.parse('1');
    } else if (amount < Decimal.parse('100')) {
      fee = Decimal.parse('2.5');
    } else if (amount < Decimal.parse('1000')) {
      fee = amount * Decimal.parse('0.015');
    } else {
      fee = amount * Decimal.parse('0.008');
    }

    if (isWeekend) {
      fee += amount * Decimal.parse('0.01');
    }

    return fee;
  }
}
