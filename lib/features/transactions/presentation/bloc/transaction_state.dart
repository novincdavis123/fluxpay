part of 'transaction_bloc.dart';

class TransactionState {
  final List<TransactionModel> transactions;

  final List<TransactionModel> filteredTransactions;

  final bool isLoading;

  final bool hasReachedMax;

  final String searchQuery;

  final TransactionFilter filter;

  final String? selectedCurrency;

  final String? errorMessage;

  const TransactionState({
    this.transactions = const [],

    this.filteredTransactions = const [],

    this.isLoading = false,

    this.hasReachedMax = false,

    this.searchQuery = '',

    this.filter = TransactionFilter.all,

    this.selectedCurrency,

    this.errorMessage,
  });

  TransactionState copyWith({
    List<TransactionModel>? transactions,

    List<TransactionModel>? filteredTransactions,

    bool? isLoading,

    bool? hasReachedMax,

    String? searchQuery,

    TransactionFilter? filter,

    String? selectedCurrency,

    String? errorMessage,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,

      filteredTransactions: filteredTransactions ?? this.filteredTransactions,

      isLoading: isLoading ?? this.isLoading,

      hasReachedMax: hasReachedMax ?? this.hasReachedMax,

      searchQuery: searchQuery ?? this.searchQuery,

      filter: filter ?? this.filter,

      selectedCurrency: selectedCurrency ?? this.selectedCurrency,

      errorMessage: errorMessage,
    );
  }
}
