import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';

class ExchangeState extends Equatable {
  final bool isLoading;

  final bool isStale;

  final bool isOfflineMode;

  final String fromCurrency;

  final String toCurrency;

  /// ======================================================
  /// AMOUNTS
  /// ======================================================

  final Decimal senderAmount;

  final Decimal recipientAmount;

  /// ======================================================
  /// RATE + FEES
  /// ======================================================

  final Decimal exchangeRate;

  final Decimal previousRate;

  final Decimal fee;

  final Decimal totalPayable;

  /// ======================================================
  /// LIVE FLUCTUATION
  /// ======================================================

  final Decimal rateChangePercent;

  final bool isRateIncreasing;

  /// ======================================================
  /// METADATA
  /// ======================================================

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
    required this.previousRate,
    required this.fee,
    required this.totalPayable,
    required this.rateChangePercent,
    required this.isRateIncreasing,
    required this.lastUpdated,
    required this.errorMessage,
  });

  /// ======================================================
  /// INITIAL
  /// ======================================================

  factory ExchangeState.initial() {
    return ExchangeState(
      isLoading: false,
      isStale: false,
      isOfflineMode: false,

      /// DEFAULT PAIR
      fromCurrency: 'USD',
      toCurrency: 'INR',

      /// DEFAULT AMOUNT
      senderAmount: Decimal.parse('100.00'),

      recipientAmount: Decimal.zero,

      exchangeRate: Decimal.zero,

      previousRate: Decimal.zero,

      fee: Decimal.zero,

      totalPayable: Decimal.zero,

      /// LIVE RATE
      rateChangePercent: Decimal.zero,

      isRateIncreasing: true,

      lastUpdated: null,

      errorMessage: null,
    );
  }

  /// ======================================================
  /// COPY WITH
  /// ======================================================

  ExchangeState copyWith({
    bool? isLoading,
    bool? isStale,
    bool? isOfflineMode,
    String? fromCurrency,
    String? toCurrency,
    Decimal? senderAmount,
    Decimal? recipientAmount,
    Decimal? exchangeRate,
    Decimal? previousRate,
    Decimal? fee,
    Decimal? totalPayable,
    Decimal? rateChangePercent,
    bool? isRateIncreasing,
    DateTime? lastUpdated,
    String? errorMessage,

    /// CLEAR ERROR SUPPORT
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

      previousRate: previousRate ?? this.previousRate,

      fee: fee ?? this.fee,

      totalPayable: totalPayable ?? this.totalPayable,

      rateChangePercent: rateChangePercent ?? this.rateChangePercent,

      isRateIncreasing: isRateIncreasing ?? this.isRateIncreasing,

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
    return senderAmount > Decimal.zero &&
        recipientAmount > Decimal.zero &&
        totalPayable > Decimal.zero;
  }

  bool get isSameCurrency {
    return fromCurrency == toCurrency;
  }

  bool get ratesExpired {
    if (lastUpdated == null) {
      return true;
    }

    final difference = DateTime.now().difference(lastUpdated!);

    return difference.inSeconds >= 30;
  }

  /// ======================================================
  /// LIVE RATE HELPERS
  /// ======================================================

  bool get hasRateMovement {
    return rateChangePercent != Decimal.zero;
  }

  String get formattedRateChange {
    final sign = isRateIncreasing ? '+' : '';

    return '$sign${rateChangePercent.toStringAsFixed(2)}%';
  }

  /// ======================================================
  /// FORMATTERS
  /// ======================================================

  String _formatDecimal(Decimal value) {
    return value.toStringAsFixed(2);
  }

  String get formattedRate {
    return exchangeRate.toStringAsFixed(4);
  }

  String get formattedSenderAmount {
    return _formatDecimal(senderAmount);
  }

  String get formattedRecipientAmount {
    return _formatDecimal(recipientAmount);
  }

  String get formattedFee {
    return _formatDecimal(fee);
  }

  String get formattedTotalPayable {
    return _formatDecimal(totalPayable);
  }

  /// ======================================================
  /// DISPLAY HELPERS
  /// ======================================================

  String get rateLabel {
    return '1 $fromCurrency = '
        '$formattedRate $toCurrency';
  }

  String get feeLabel {
    if (isSameCurrency) {
      return 'Flat fee applied';
    }

    return 'Transfer fee';
  }

  String get staleMessage {
    if (!isStale) {
      return '';
    }

    return 'Rates are outdated. Refreshing...';
  }

  String get updatedTimeLabel {
    if (lastUpdated == null) {
      return 'Not updated';
    }

    final seconds = DateTime.now().difference(lastUpdated!).inSeconds;

    if (seconds < 60) {
      return 'Updated ${seconds}s ago';
    }

    final minutes = seconds ~/ 60;

    return 'Updated ${minutes}m ago';
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
    previousRate,
    fee,
    totalPayable,
    rateChangePercent,
    isRateIncreasing,
    lastUpdated,
    errorMessage,
  ];
}
