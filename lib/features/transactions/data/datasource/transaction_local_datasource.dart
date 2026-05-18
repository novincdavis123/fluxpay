import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:fluxpay/core/constants/storage_constants.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> cacheTransactions(List<TransactionModel> transactions);

  Future<List<TransactionModel>> getTransactions();

  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String _transactionsKey = 'transactions';

  static const String _boxName = StorageConstants.transactionsBox;

  /// ======================================================
  /// OPEN BOX SAFELY
  /// ======================================================

  Future<Box<TransactionModel>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<TransactionModel>(_boxName);
    }

    return await Hive.openBox<TransactionModel>(_boxName);
  }

  /// ======================================================
  /// CACHE TRANSACTIONS
  /// ======================================================

  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    try {
      final box = await _openBox();

      await box.clear();

      for (final transaction in transactions) {
        await box.put(transaction.id, transaction);
      }

      if (kDebugMode) {
        debugPrint('✅ Transactions cached successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to cache transactions: $e');
      }

      rethrow;
    }
  }

  /// ======================================================
  /// GET TRANSACTIONS
  /// ======================================================

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final box = await _openBox();

      final transactions = box.values.toList();

      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (kDebugMode) {
        debugPrint('✅ Transactions loaded successfully');
      }

      return transactions;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load transactions: $e');
      }

      return [];
    }
  }

  /// ======================================================
  /// CLEAR TRANSACTIONS
  /// ======================================================

  @override
  Future<void> clearTransactions() async {
    try {
      final box = await _openBox();

      await box.clear();

      if (kDebugMode) {
        debugPrint('🗑️ Transactions cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to clear transactions: $e');
      }
    }
  }
}
