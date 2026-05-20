part of 'transaction_bloc.dart';

class TransactionState {
  final List<TransactionModel> transactions;

  final List<TransactionModel> filteredTransactions;

  final bool isLoading;

  final bool isPaginating;

  final bool hasReachedMax;

  final String searchQuery;

  final TransactionFilter filter;

  final String? selectedCurrency;

  final String? errorMessage;

  /// ======================================================
  /// ADVANCED FILTERS
  /// ======================================================

  final double? minAmount;

  final double? maxAmount;

  const TransactionState({
    this.transactions = const [],

    this.filteredTransactions = const [],

    this.isLoading = false,

    this.isPaginating = false,

    this.hasReachedMax = false,

    this.searchQuery = '',

    this.filter = TransactionFilter.all,

    this.selectedCurrency,

    this.errorMessage,

    this.minAmount,

    this.maxAmount,
  });

  /// ======================================================
  /// COPY WITH
  /// ======================================================

  TransactionState copyWith({
    List<TransactionModel>? transactions,

    List<TransactionModel>? filteredTransactions,

    bool? isLoading,

    bool? isPaginating,

    bool? hasReachedMax,

    String? searchQuery,

    TransactionFilter? filter,

    String? selectedCurrency,

    String? errorMessage,

    double? minAmount,

    double? maxAmount,

    bool clearCurrency = false,

    bool clearError = false,

    bool clearMinAmount = false,

    bool clearMaxAmount = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,

      filteredTransactions: filteredTransactions ?? this.filteredTransactions,

      isLoading: isLoading ?? this.isLoading,

      isPaginating: isPaginating ?? this.isPaginating,

      hasReachedMax: hasReachedMax ?? this.hasReachedMax,

      searchQuery: searchQuery ?? this.searchQuery,

      filter: filter ?? this.filter,

      selectedCurrency: clearCurrency
          ? null
          : selectedCurrency ?? this.selectedCurrency,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,

      minAmount: clearMinAmount ? null : minAmount ?? this.minAmount,

      maxAmount: clearMaxAmount ? null : maxAmount ?? this.maxAmount,
    );
  }

  /// ======================================================
  /// HELPERS
  /// ======================================================

  bool get hasFilters {
    return filter != TransactionFilter.all ||
        selectedCurrency != null ||
        searchQuery.isNotEmpty ||
        minAmount != null ||
        maxAmount != null;
  }

  bool get hasCurrencyFilter {
    return selectedCurrency != null && selectedCurrency!.isNotEmpty;
  }

  bool get hasAmountFilter {
    return minAmount != null || maxAmount != null;
  }

  bool get hasTransactions {
    return filteredTransactions.isNotEmpty;
  }

  bool get isEmpty {
    return !isLoading && filteredTransactions.isEmpty;
  }

  bool get hasError {
    return errorMessage != null && errorMessage!.isNotEmpty;
  }

  /// ======================================================
  /// DATE GROUPING
  /// ======================================================

  Map<String, List<TransactionModel>> get groupedTransactions {
    final Map<String, List<TransactionModel>> grouped = {};

    for (final transaction in filteredTransactions) {
      final date = transaction.createdAt;

      final now = DateTime.now();

      final difference = now.difference(date).inDays;

      String key;

      if (difference == 0) {
        key = 'Today';
      } else if (difference == 1) {
        key = 'Yesterday';
      } else {
        key = '${date.day}/${date.month}/${date.year}';
      }

      grouped.putIfAbsent(key, () => []);

      grouped[key]!.add(transaction);
    }

    return grouped;
  }

  /// ======================================================
  /// CLEAR FILTERS
  /// ======================================================

  TransactionState clearFilters() {
    return copyWith(
      filter: TransactionFilter.all,

      searchQuery: '',

      clearCurrency: true,

      clearMinAmount: true,

      clearMaxAmount: true,
    );
  }
}
