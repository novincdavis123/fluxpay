import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

class ExchangeState extends Equatable {
  final bool isLoading;

  final bool isStale;

  final String fromCurrency;

  final String toCurrency;

  final Decimal senderAmount;

  final Decimal recipientAmount;

  final Decimal exchangeRate;

  final Decimal fee;

  final Decimal totalPayable;

  final DateTime? lastUpdated;

  final String? errorMessage;

  const ExchangeState({
    required this.isLoading,
    required this.isStale,
    required this.fromCurrency,
    required this.toCurrency,
    required this.senderAmount,
    required this.recipientAmount,
    required this.exchangeRate,
    required this.fee,
    required this.totalPayable,
    required this.lastUpdated,
    required this.errorMessage,
  });

  factory ExchangeState.initial() {
    return ExchangeState(
      isLoading: false,
      isStale: false,
      fromCurrency: 'USD',
      toCurrency: 'INR',
      senderAmount: Decimal.parse('100'),
      recipientAmount: Decimal.zero,
      exchangeRate: Decimal.zero,
      fee: Decimal.zero,
      totalPayable: Decimal.zero,
      lastUpdated: null,
      errorMessage: null,
    );
  }

  ExchangeState copyWith({
    bool? isLoading,
    bool? isStale,
    String? fromCurrency,
    String? toCurrency,
    Decimal? senderAmount,
    Decimal? recipientAmount,
    Decimal? exchangeRate,
    Decimal? fee,
    Decimal? totalPayable,
    DateTime? lastUpdated,
    String? errorMessage,
  }) {
    return ExchangeState(
      isLoading: isLoading ?? this.isLoading,
      isStale: isStale ?? this.isStale,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      senderAmount: senderAmount ?? this.senderAmount,
      recipientAmount: recipientAmount ?? this.recipientAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      fee: fee ?? this.fee,
      totalPayable: totalPayable ?? this.totalPayable,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isStale,
    fromCurrency,
    toCurrency,
    senderAmount,
    recipientAmount,
    exchangeRate,
    fee,
    totalPayable,
    lastUpdated,
    errorMessage,
  ];
}
