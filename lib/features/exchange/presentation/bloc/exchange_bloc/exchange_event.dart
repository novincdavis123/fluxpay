import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch initial exchange rate
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

/// Sender amount changed
class AmountChanged extends ExchangeEvent {
  final String amount;

  const AmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// Recipient amount changed (reverse calculation)
class RecipientAmountChanged extends ExchangeEvent {
  final String amount;

  const RecipientAmountChanged(this.amount);

  @override
  List<Object?> get props => [amount];
}

/// Swap sender and receiver currencies
class SwapCurrencies extends ExchangeEvent {
  const SwapCurrencies();
}

/// Currency selection changed
class CurrencyChanged extends ExchangeEvent {
  final String fromCurrency;
  final String toCurrency;

  const CurrencyChanged({required this.fromCurrency, required this.toCurrency});

  @override
  List<Object?> get props => [fromCurrency, toCurrency];
}

/// Refresh exchange rates periodically
class RefreshExchangeRates extends ExchangeEvent {
  const RefreshExchangeRates();
}

/// Mark rates as stale after expiry
class MarkRatesAsStale extends ExchangeEvent {
  const MarkRatesAsStale();
}

/// Update live rate from simulation
class LiveRateUpdated extends ExchangeEvent {
  final Decimal updatedRate;

  const LiveRateUpdated(this.updatedRate);

  @override
  List<Object> get props => [updatedRate];
}
