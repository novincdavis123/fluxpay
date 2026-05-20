import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_filter.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

import 'package:fluxpay/features/transactions/domain/repositories/transaction_repository.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  static const int pageSize = 20;

  TransactionBloc({required this.repository})
    : super(const TransactionState()) {
    on<LoadTransactions>(_onLoadTransactions);

    on<AddTransaction>(_onAddTransaction);

    on<SearchTransactions>(_onSearchTransactions);

    on<FilterTransactions>(_onFilterTransactions);

    on<CurrencyFilterChanged>(_onCurrencyFilterChanged);

    on<AmountRangeFilterChanged>(_onAmountRangeFilterChanged);

    on<ClearTransactionFilters>(_onClearTransactionFilters);

    on<LoadMoreTransactions>(_onLoadMoreTransactions);
  }

  /// ======================================================
  /// LOAD TRANSACTIONS
  /// ======================================================

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final transactions = await repository.getTransactions();
      print('TOTAL TX: ${transactions.length}');

      /// SORT ONLY ON INITIAL LOAD
      final sortedTransactions = List<TransactionModel>.from(transactions)
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      final updatedState = state.copyWith(
        isLoading: false,
        transactions: sortedTransactions,
      );

      _applyFilters(emit, updatedState);
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isPaginating: false,
          errorMessage: 'Failed to load transactions',
        ),
      );
    }
  }

  /// ======================================================
  /// ADD TRANSACTION
  /// ======================================================

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final updatedTransactions = <TransactionModel>[
        event.transaction,
        ...state.transactions,
      ];

      await repository.saveTransactions(updatedTransactions);

      final updatedState = state.copyWith(
        transactions: updatedTransactions,
        clearError: true,
      );

      _applyFilters(emit, updatedState);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save transaction'));
    }
  }

  /// ======================================================
  /// SEARCH
  /// ======================================================

  void _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(searchQuery: event.query.trim());

    _applyFilters(emit, updatedState);
  }

  /// ======================================================
  /// STATUS FILTER
  /// ======================================================

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(filter: event.filter);

    _applyFilters(emit, updatedState);
  }

  /// ======================================================
  /// CURRENCY FILTER
  /// ======================================================

  void _onCurrencyFilterChanged(
    CurrencyFilterChanged event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(selectedCurrency: event.currency);

    _applyFilters(emit, updatedState);
  }

  /// ======================================================
  /// AMOUNT RANGE FILTER
  /// ======================================================

  void _onAmountRangeFilterChanged(
    AmountRangeFilterChanged event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(
      minAmount: event.minAmount,
      maxAmount: event.maxAmount,
    );

    _applyFilters(emit, updatedState);
  }

  /// ======================================================
  /// CLEAR FILTERS
  /// ======================================================

  void _onClearTransactionFilters(
    ClearTransactionFilters event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(
      searchQuery: '',
      filter: TransactionFilter.all,
      selectedCurrency: null,
      minAmount: null,
      maxAmount: null,
      clearCurrency: true,
      clearError: true,
    );

    _applyFilters(emit, updatedState);
  }

  /// ======================================================
  /// APPLY FILTERS
  /// ======================================================

  void _applyFilters(
    Emitter<TransactionState> emit,
    TransactionState currentState,
  ) {
    final filtered = _filterTransactions(
      transactions: currentState.transactions,
      currentState: currentState,
    );

    final paginatedItems = filtered.take(pageSize).toList(growable: false);

    emit(
      currentState.copyWith(
        filteredTransactions: paginatedItems,
        hasReachedMax: filtered.length <= pageSize,
        isPaginating: false,
      ),
    );
  }

  /// ======================================================
  /// FILTER LOGIC
  /// ======================================================

  List<TransactionModel> _filterTransactions({
    required List<TransactionModel> transactions,
    required TransactionState currentState,
  }) {
    Iterable<TransactionModel> filtered = transactions;

    /// ======================================================
    /// STATUS FILTER
    /// ======================================================

    switch (currentState.filter) {
      case TransactionFilter.completed:
        filtered = filtered.where(
          (tx) => tx.status == TransactionStatus.completed,
        );
        break;

      case TransactionFilter.pending:
        filtered = filtered.where(
          (tx) => tx.status == TransactionStatus.pending,
        );
        break;

      case TransactionFilter.processing:
        filtered = filtered.where(
          (tx) => tx.status == TransactionStatus.processing,
        );
        break;

      case TransactionFilter.failed:
        filtered = filtered.where(
          (tx) => tx.status == TransactionStatus.failed,
        );
        break;

      case TransactionFilter.refunded:
        filtered = filtered.where(
          (tx) => tx.status == TransactionStatus.refunded,
        );
        break;

      case TransactionFilter.all:
        break;
    }

    /// ======================================================
    /// SEARCH FILTER
    /// ======================================================

    if (currentState.searchQuery.isNotEmpty) {
      final query = currentState.searchQuery.toLowerCase();

      filtered = filtered.where((tx) {
        return tx.beneficiaryName.toLowerCase().contains(query) ||
            tx.beneficiaryBank.toLowerCase().contains(query) ||
            tx.senderCurrency.toLowerCase().contains(query) ||
            tx.receiverCurrency.toLowerCase().contains(query) ||
            tx.id.toLowerCase().contains(query);
      });
    }

    /// ======================================================
    /// CURRENCY FILTER
    /// ======================================================

    if (currentState.selectedCurrency != null &&
        currentState.selectedCurrency!.isNotEmpty) {
      filtered = filtered.where((tx) {
        return tx.senderCurrency == currentState.selectedCurrency ||
            tx.receiverCurrency == currentState.selectedCurrency;
      });
    }

    /// ======================================================
    /// MIN AMOUNT
    /// ======================================================

    if (currentState.minAmount != null) {
      filtered = filtered.where(
        (tx) => tx.senderAmount >= currentState.minAmount!,
      );
    }

    /// ======================================================
    /// MAX AMOUNT
    /// ======================================================

    if (currentState.maxAmount != null) {
      filtered = filtered.where(
        (tx) => tx.senderAmount <= currentState.maxAmount!,
      );
    }

    return filtered.toList(growable: false);
  }

  /// ======================================================
  /// PAGINATION
  /// ======================================================

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state.hasReachedMax || state.isPaginating) {
      return;
    }

    emit(state.copyWith(isPaginating: true));

    final filtered = _filterTransactions(
      transactions: state.transactions,
      currentState: state,
    );

    final currentLength = state.filteredTransactions.length;

    final nextItems = filtered
        .skip(currentLength)
        .take(pageSize)
        .toList(growable: false);

    final updatedList = <TransactionModel>[
      ...state.filteredTransactions,
      ...nextItems,
    ];

    emit(
      state.copyWith(
        filteredTransactions: updatedList,
        hasReachedMax: updatedList.length >= filtered.length,
        isPaginating: false,
      ),
    );
  }
}
