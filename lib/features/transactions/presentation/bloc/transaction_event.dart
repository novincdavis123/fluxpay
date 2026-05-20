part of 'transaction_bloc.dart';

/// ======================================================
/// BASE EVENT
/// ======================================================

abstract class TransactionEvent {
  const TransactionEvent();
}

/// ======================================================
/// LOAD TRANSACTIONS
/// ======================================================

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

/// ======================================================
/// ADD TRANSACTION
/// ======================================================

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;

  const AddTransaction(this.transaction);
}

/// ======================================================
/// SEARCH TRANSACTIONS
/// ======================================================

class SearchTransactions extends TransactionEvent {
  final String query;

  const SearchTransactions(this.query);
}

/// ======================================================
/// STATUS FILTER
/// ======================================================

class FilterTransactions extends TransactionEvent {
  final TransactionFilter filter;

  const FilterTransactions(this.filter);
}

/// ======================================================
/// CURRENCY FILTER
/// ======================================================

class CurrencyFilterChanged extends TransactionEvent {
  final String? currency;

  const CurrencyFilterChanged(this.currency);
}

/// ======================================================
/// AMOUNT RANGE FILTER
/// ======================================================

class AmountRangeFilterChanged extends TransactionEvent {
  final double? minAmount;

  final double? maxAmount;

  const AmountRangeFilterChanged({this.minAmount, this.maxAmount});
}

/// ======================================================
/// CLEAR FILTERS
/// ======================================================

class ClearTransactionFilters extends TransactionEvent {
  const ClearTransactionFilters();
}

/// ======================================================
/// LOAD MORE TRANSACTIONS
/// ======================================================

class LoadMoreTransactions extends TransactionEvent {
  const LoadMoreTransactions();
}
