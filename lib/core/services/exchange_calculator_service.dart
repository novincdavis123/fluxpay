import 'package:decimal/decimal.dart';

import '../models/exchange_calculation_result.dart';

class ExchangeCalculatorService {
  /// ======================================================
  /// MAIN CALCULATION
  /// ======================================================

  ExchangeCalculationResult calculate({
    required Decimal amount,
    required Decimal rate,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    /// SAFETY
    if (amount <= Decimal.zero || rate <= Decimal.zero) {
      return ExchangeCalculationResult(
        exchangeRate: rate,
        fee: Decimal.zero,
        senderPays: amount,
        recipientGets: Decimal.zero,
        totalPayable: amount,
      );
    }

    final adjustedRate = _applyRateAdjustment(rate: rate, isWeekend: isWeekend);

    final fee = _calculateFee(
      amount: amount,
      isWeekend: isWeekend,
      sameCurrency: sameCurrency,
    );

    final recipientGets = _roundMoney(amount * adjustedRate);

    final totalPayable = _roundMoney(amount + fee);

    return ExchangeCalculationResult(
      exchangeRate: adjustedRate,
      fee: fee,
      senderPays: amount,
      recipientGets: recipientGets,
      totalPayable: totalPayable,
    );
  }

  /// ======================================================
  /// FEE CALCULATION
  /// ======================================================

  Decimal _calculateFee({
    required Decimal amount,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    Decimal fee;

    /// SAME CURRENCY
    if (sameCurrency) {
      fee = Decimal.parse('1');
    }
    /// SMALL TRANSFER
    else if (amount < Decimal.parse('100')) {
      fee = Decimal.parse('2.5');
    }
    /// MEDIUM TRANSFER
    else if (amount < Decimal.parse('1000')) {
      fee = amount * Decimal.parse('0.015');
    }
    /// LARGE TRANSFER
    else {
      fee = amount * Decimal.parse('0.008');
    }

    /// WEEKEND EXTRA FEE
    if (isWeekend) {
      fee += amount * Decimal.parse('0.01');
    }

    return _roundMoney(fee);
  }

  /// ======================================================
  /// WEEKEND FX ADJUSTMENT
  /// ======================================================

  Decimal _applyRateAdjustment({
    required Decimal rate,
    required bool isWeekend,
  }) {
    if (!isWeekend) {
      return rate;
    }

    /// SLIGHT WEEKEND SPREAD
    final adjustment = Decimal.parse('0.995');

    return rate * adjustment;
  }

  /// ======================================================
  /// MONEY ROUNDING
  /// ======================================================

  Decimal _roundMoney(Decimal value) {
    return Decimal.parse(value.toStringAsFixed(2));
  }

  /// ======================================================
  /// REVERSE CALCULATION
  /// ======================================================

  Decimal reverseCalculateSenderAmount({
    required Decimal recipientAmount,
    required Decimal exchangeRate,
  }) {
    if (exchangeRate <= Decimal.zero) {
      return Decimal.zero;
    }

    return _roundMoney((recipientAmount / exchangeRate).toDecimal());
  }

  /// ======================================================
  /// ESTIMATED DELIVERY TIME
  /// ======================================================

  String getEstimatedDelivery({
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    if (sameCurrency) {
      return 'Instant';
    }

    if (isWeekend) {
      return '1-2 business days';
    }

    return 'Within minutes';
  }
}
