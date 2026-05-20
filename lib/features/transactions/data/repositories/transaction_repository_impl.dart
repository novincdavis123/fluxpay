import 'package:flutter/foundation.dart';

import 'package:fluxpay/features/transactions/data/datasource/transaction_local_datasource.dart';

import 'package:fluxpay/features/transactions/data/mock/mock_transactions.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_entity.dart';

import 'package:fluxpay/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  /// ======================================================
  /// SAVE TRANSACTIONS
  /// ======================================================

  @override
  Future<void> saveTransactions(List<TransactionEntity> transactions) async {
    final models = transactions.map((e) {
      return TransactionModel.fromEntity(e);
    }).toList();

    await localDataSource.cacheTransactions(models);
  }

  /// ======================================================
  /// GET TRANSACTIONS
  /// ======================================================

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      var transactions = await localDataSource.getTransactions();

      /// ======================================================
      /// AUTO SEED MOCK DATA
      /// ======================================================

      if (transactions.isEmpty) {
        if (kDebugMode) {
          debugPrint('🌱 Seeding mock transactions...');
        }

        await localDataSource.cacheTransactions(generateMockTransactions());

        transactions = await localDataSource.getTransactions();
      }

      return transactions;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Repository error: $e');
      }

      return [];
    }
  }

  /// ======================================================
  /// CLEAR TRANSACTIONS
  /// ======================================================

  @override
  Future<void> clearTransactions() async {
    await localDataSource.clearTransactions();
  }
}
