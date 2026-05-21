import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object?> get props => [];
}

/// ======================================================
/// FETCH EXCHANGE RATE
/// ======================================================

class FetchExchangeRate extends ExchangeEvent {
  final String fromCurrency;

  final String toCurrency;

  const FetchExchangeRate({
    required this.fromCurrency,
    required this.toCurrency,
  });

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// ======================================================
/// SENDER AMOUNT CHANGED
/// ======================================================

class AmountChanged extends ExchangeEvent {
  final String amount;

  const AmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// ======================================================
/// RECIPIENT AMOUNT CHANGED
/// ======================================================

class RecipientAmountChanged extends ExchangeEvent {
  final String amount;

  const RecipientAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// ======================================================
/// UPDATE SENDER AMOUNT
/// ======================================================

class UpdateSenderAmount extends ExchangeEvent {
  final Decimal amount;

  const UpdateSenderAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// ======================================================
/// UPDATE RECEIVER AMOUNT
/// ======================================================

class UpdateReceiverAmount extends ExchangeEvent {
  final Decimal amount;

  const UpdateReceiverAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// ======================================================
/// SWAP CURRENCIES
/// ======================================================

class SwapCurrencies extends ExchangeEvent {
  const SwapCurrencies();
}

/// ======================================================
/// CHANGE BOTH CURRENCIES
/// ======================================================

class CurrencyChanged extends ExchangeEvent {
  final String fromCurrency;

  final String toCurrency;

  const CurrencyChanged({required this.fromCurrency, required this.toCurrency});

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// ======================================================
/// CHANGE FROM CURRENCY
/// ======================================================

class ChangeFromCurrency extends ExchangeEvent {
  final String currencyCode;

  const ChangeFromCurrency(this.currencyCode);

  @override
  List<Object?> get props => [currencyCode];
}

/// ======================================================
/// CHANGE TO CURRENCY
/// ======================================================

class ChangeToCurrency extends ExchangeEvent {
  final String currencyCode;

  const ChangeToCurrency(this.currencyCode);

  @override
  List<Object?> get props => [currencyCode];
}

/// ======================================================
/// REFRESH RATES
/// ======================================================

class RefreshExchangeRates extends ExchangeEvent {
  const RefreshExchangeRates();
}

/// ======================================================
/// REFRESH SINGLE RATE
/// ======================================================

class RefreshExchangeRate extends ExchangeEvent {
  const RefreshExchangeRate();
}

/// ======================================================
/// MARK RATE AS STALE
/// ======================================================

class MarkRatesAsStale extends ExchangeEvent {
  const MarkRatesAsStale();
}

/// ======================================================
/// LIVE RATE UPDATED
/// ======================================================

class LiveRateUpdated extends ExchangeEvent {
  final Decimal updatedRate;

  /// percentage movement from previous rate
  final Decimal percentageChange;

  const LiveRateUpdated({
    required this.updatedRate,
    required this.percentageChange,
  });

  @override
  List<Object?> get props => [updatedRate, percentageChange];
}

/// ======================================================
/// CLEAR ERROR
/// ======================================================

class ClearExchangeError extends ExchangeEvent {
  const ClearExchangeError();
}
