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

    on<LoadMoreTransactions>(_onLoadMoreTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final transactions = await repository.getTransactions();

      final initialItems = transactions.take(pageSize).toList();

      emit(
        state.copyWith(
          isLoading: false,

          transactions: transactions,

          filteredTransactions: initialItems,

          hasReachedMax: transactions.length <= pageSize,

          isPaginating: false,
        ),
      );
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

  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final updatedTransactions = [event.transaction, ...state.transactions];

      await repository.saveTransactions(updatedTransactions);

      final updatedState = state.copyWith(
        transactions: updatedTransactions,
        errorMessage: null,
      );

      _applyFilters(emit, updatedState);
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save transaction'));
    }
  }

  void _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(searchQuery: event.query);

    _applyFilters(emit, updatedState);
  }

  void _onFilterTransactions(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(filter: event.filter);

    _applyFilters(emit, updatedState);
  }

  void _onCurrencyFilterChanged(
    CurrencyFilterChanged event,
    Emitter<TransactionState> emit,
  ) {
    final updatedState = state.copyWith(selectedCurrency: event.currency);

    _applyFilters(emit, updatedState);
  }

  void _applyFilters(
    Emitter<TransactionState> emit,
    TransactionState currentState,
  ) {
    List<TransactionModel> filtered = List.from(currentState.transactions);

    /// STATUS FILTER
    switch (currentState.filter) {
      case TransactionFilter.completed:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.completed;
        }).toList();
        break;

      case TransactionFilter.pending:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.pending;
        }).toList();
        break;

      case TransactionFilter.processing:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.processing;
        }).toList();
        break;

      case TransactionFilter.failed:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.failed;
        }).toList();
        break;

      case TransactionFilter.all:
        break;
    }

    /// SEARCH FILTER
    if (currentState.searchQuery.isNotEmpty) {
      filtered = filtered.where((tx) {
        final query = currentState.searchQuery.toLowerCase();

        return tx.beneficiaryName.toLowerCase().contains(query) ||
            tx.beneficiaryBank.toLowerCase().contains(query) ||
            tx.senderCurrency.toLowerCase().contains(query) ||
            tx.receiverCurrency.toLowerCase().contains(query) ||
            tx.id.toLowerCase().contains(query);
      }).toList();
    }

    /// CURRENCY FILTER
    if (currentState.selectedCurrency != null) {
      filtered = filtered.where((tx) {
        return tx.senderCurrency == currentState.selectedCurrency ||
            tx.receiverCurrency == currentState.selectedCurrency;
      }).toList();
    }

    final paginatedItems = filtered.take(pageSize).toList();

    emit(
      currentState.copyWith(
        filteredTransactions: paginatedItems,

        hasReachedMax: filtered.length <= pageSize,

        isPaginating: false,
      ),
    );
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    if (state.hasReachedMax || state.isPaginating) {
      return;
    }

    emit(state.copyWith(isPaginating: true));

    await Future.delayed(const Duration(milliseconds: 500));

    final currentLength = state.filteredTransactions.length;

    List<TransactionModel> filtered = List.from(state.transactions);

    /// APPLY ACTIVE FILTERS
    switch (state.filter) {
      case TransactionFilter.completed:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.completed;
        }).toList();
        break;

      case TransactionFilter.pending:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.pending;
        }).toList();
        break;

      case TransactionFilter.processing:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.processing;
        }).toList();
        break;

      case TransactionFilter.failed:
        filtered = filtered.where((tx) {
          return tx.status == TransactionStatus.failed;
        }).toList();
        break;

      case TransactionFilter.all:
        break;
    }

    if (state.searchQuery.isNotEmpty) {
      filtered = filtered.where((tx) {
        final query = state.searchQuery.toLowerCase();

        return tx.beneficiaryName.toLowerCase().contains(query) ||
            tx.id.toLowerCase().contains(query);
      }).toList();
    }

    final nextItems = filtered.skip(currentLength).take(pageSize).toList();

    final updatedList = [...state.filteredTransactions, ...nextItems];

    emit(
      state.copyWith(
        filteredTransactions: updatedList,

        hasReachedMax: updatedList.length >= filtered.length,

        isPaginating: false,
      ),
    );
  }
}
