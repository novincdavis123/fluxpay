import 'package:fluxpay/features/transactions/data/datasource/transaction_local_datasource.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    await localDataSource.cacheTransactions(transactions);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return await localDataSource.getTransactions();
  }
}
