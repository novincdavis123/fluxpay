part of 'transaction_bloc.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;

  const AddTransaction(this.transaction);
}

class SearchTransactions extends TransactionEvent {
  final String query;

  const SearchTransactions(this.query);
}

class FilterTransactions extends TransactionEvent {
  final TransactionFilter filter;

  const FilterTransactions(this.filter);
}

class CurrencyFilterChanged extends TransactionEvent {
  final String? currency;

  const CurrencyFilterChanged(this.currency);
}

class LoadMoreTransactions extends TransactionEvent {
  const LoadMoreTransactions();
}
