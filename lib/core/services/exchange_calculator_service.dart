import 'package:decimal/decimal.dart';

import '../models/exchange_calculation_result.dart';

class ExchangeCalculatorService {
  /// ======================================================
  /// FORWARD CALCULATION
  /// Sender Pays -> Recipient Gets
  /// ======================================================

  ExchangeCalculationResult calculateFromSender({
    required Decimal senderAmount,
    required Decimal rate,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    if (senderAmount <= Decimal.zero || rate <= Decimal.zero) {
      return _empty(rate);
    }

    final adjustedRate = _applyRateAdjustment(rate: rate, isWeekend: isWeekend);

    /// Fee based on sender amount
    final fee = _calculateFee(
      amount: senderAmount,
      isWeekend: isWeekend,
      sameCurrency: sameCurrency,
    );

    /// Transferable amount after fee
    final transferableAmount = senderAmount - fee;

    final recipientGets = _roundMoney(transferableAmount * adjustedRate);

    return ExchangeCalculationResult(
      exchangeRate: adjustedRate,
      fee: fee,
      senderPays: senderAmount,
      recipientGets: recipientGets,
      totalPayable: senderAmount,
    );
  }

  /// ======================================================
  /// REVERSE CALCULATION
  /// Recipient Gets -> Sender Pays
  /// ======================================================

  ExchangeCalculationResult calculateFromRecipient({
    required Decimal recipientAmount,
    required Decimal rate,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    if (recipientAmount <= Decimal.zero || rate <= Decimal.zero) {
      return _empty(rate);
    }

    final adjustedRate = _applyRateAdjustment(rate: rate, isWeekend: isWeekend);

    /// Base sender amount before fees
    Decimal senderAmount = (recipientAmount / adjustedRate).toDecimal();

    senderAmount = _roundMoney(senderAmount);

    /// Fee recalculated
    final fee = _calculateFee(
      amount: senderAmount,
      isWeekend: isWeekend,
      sameCurrency: sameCurrency,
    );

    /// Final sender payable
    final totalPayable = _roundMoney(senderAmount + fee);

    return ExchangeCalculationResult(
      exchangeRate: adjustedRate,
      fee: fee,
      senderPays: totalPayable,
      recipientGets: recipientAmount,
      totalPayable: totalPayable,
    );
  }

  /// ======================================================
  /// DYNAMIC FEES
  /// ======================================================

  Decimal _calculateFee({
    required Decimal amount,
    required bool isWeekend,
    required bool sameCurrency,
  }) {
    Decimal fee;

    if (sameCurrency) {
      fee = Decimal.parse('1');
    } else if (amount < Decimal.parse('100')) {
      fee = Decimal.parse('2.5');
    } else if (amount < Decimal.parse('1000')) {
      fee = amount * Decimal.parse('0.015');
    } else {
      fee = amount * Decimal.parse('0.008');
    }

    /// Weekend surcharge
    if (isWeekend) {
      fee += amount * Decimal.parse('0.01');
    }

    return _roundMoney(fee);
  }

  /// ======================================================
  /// RATE ADJUSTMENT
  /// ======================================================

  Decimal _applyRateAdjustment({
    required Decimal rate,
    required bool isWeekend,
  }) {
    if (!isWeekend) {
      return rate;
    }

    return rate * Decimal.parse('0.995');
  }

  /// ======================================================
  /// ROUNDING
  /// ======================================================

  Decimal _roundMoney(Decimal value) {
    return value.round(scale: 2);
  }

  /// ======================================================
  /// EMPTY
  /// ======================================================

  ExchangeCalculationResult _empty(Decimal rate) {
    return ExchangeCalculationResult(
      exchangeRate: rate,
      fee: Decimal.zero,
      senderPays: Decimal.zero,
      recipientGets: Decimal.zero,
      totalPayable: Decimal.zero,
    );
  }

  /// ======================================================
  /// DELIVERY
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
