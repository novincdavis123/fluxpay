import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

class ExchangeState extends Equatable {
  final bool isLoading;

  final bool isStale;

  final bool isOfflineMode;

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
    required this.isOfflineMode,
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
      isOfflineMode: false,
      fromCurrency: 'USD',
      toCurrency: 'INR',

      /// DEFAULT VALUES
      senderAmount: Decimal.parse('100'),
      recipientAmount: Decimal.parse('0'),
      exchangeRate: Decimal.parse('0'),

      fee: Decimal.parse('0'),
      totalPayable: Decimal.parse('0'),

      lastUpdated: null,
      errorMessage: null,
    );
  }

  ExchangeState copyWith({
    bool? isLoading,
    bool? isStale,
    bool? isOfflineMode,
    String? fromCurrency,
    String? toCurrency,
    Decimal? senderAmount,
    Decimal? recipientAmount,
    Decimal? exchangeRate,
    Decimal? fee,
    Decimal? totalPayable,
    DateTime? lastUpdated,
    String? errorMessage,

    /// ALLOW CLEARING ERROR
    bool clearError = false,
  }) {
    return ExchangeState(
      isLoading: isLoading ?? this.isLoading,

      isStale: isStale ?? this.isStale,

      isOfflineMode: isOfflineMode ?? this.isOfflineMode,

      fromCurrency: fromCurrency ?? this.fromCurrency,

      toCurrency: toCurrency ?? this.toCurrency,

      senderAmount: senderAmount ?? this.senderAmount,

      recipientAmount: recipientAmount ?? this.recipientAmount,

      exchangeRate: exchangeRate ?? this.exchangeRate,

      fee: fee ?? this.fee,

      totalPayable: totalPayable ?? this.totalPayable,

      lastUpdated: lastUpdated ?? this.lastUpdated,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  /// ======================================================
  /// HELPERS
  /// ======================================================

  bool get hasError {
    return errorMessage != null && errorMessage!.isNotEmpty;
  }

  bool get hasExchangeRate {
    return exchangeRate > Decimal.zero;
  }

  bool get hasValidCalculation {
    return recipientAmount > Decimal.zero && totalPayable > Decimal.zero;
  }

  String get formattedRate {
    return exchangeRate.toString();
  }

  String get formattedSenderAmount {
    return senderAmount.toString();
  }

  String get formattedRecipientAmount {
    return recipientAmount.toString();
  }

  String get formattedFee {
    return fee.toString();
  }

  String get formattedTotalPayable {
    return totalPayable.toString();
  }

  @override
  List<Object?> get props => [
    isLoading,
    isStale,
    isOfflineMode,
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
