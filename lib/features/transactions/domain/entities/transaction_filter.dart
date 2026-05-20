enum TransactionFilter { all, completed, pending, processing, failed, refunded }

extension TransactionFilterX on TransactionFilter {
  String get label {
    switch (this) {
      case TransactionFilter.all:
        return 'All';

      case TransactionFilter.completed:
        return 'Completed';

      case TransactionFilter.pending:
        return 'Pending';

      case TransactionFilter.processing:
        return 'Processing';

      case TransactionFilter.failed:
        return 'Failed';

      case TransactionFilter.refunded:
        return 'Refunded';
    }
  }
}
