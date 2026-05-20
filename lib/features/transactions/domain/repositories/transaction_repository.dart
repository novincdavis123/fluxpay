import 'package:fluxpay/features/transactions/domain/entities/transaction_entity.dart';

abstract class TransactionRepository {
  /// ======================================================
  /// GET TRANSACTIONS
  /// ======================================================

  Future<List<TransactionEntity>> getTransactions();

  /// ======================================================
  /// SAVE TRANSACTIONS
  /// ======================================================

  Future<void> saveTransactions(List<TransactionEntity> transactions);

  /// ======================================================
  /// CLEAR TRANSACTIONS
  /// ======================================================

  Future<void> clearTransactions();
}
