import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<void> saveTransactions(List<TransactionModel> transactions);

  Future<List<TransactionModel>> getTransactions();
}
