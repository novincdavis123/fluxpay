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
  static const String _boxName = StorageConstants.transactionsBox;

  /// ======================================================
  /// SAFE BOX ACCESS
  /// BOX MUST ALREADY BE OPENED IN MAIN.DART
  /// ======================================================

  Box<TransactionModel> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw Exception('$_boxName is not opened. Open it in main.dart');
    }

    return Hive.box<TransactionModel>(_boxName);
  }

  /// ======================================================
  /// CACHE TRANSACTIONS
  /// ======================================================

  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    try {
      final box = _box;

      await box.clear();

      final Map<dynamic, TransactionModel> mapped = {
        for (final transaction in transactions) transaction.id: transaction,
      };

      await box.putAll(mapped);

      if (kDebugMode) {
        debugPrint('✅ Transactions cached successfully');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Failed to cache transactions: $e');

        debugPrintStack(stackTrace: stackTrace);
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
      final transactions = _box.values.toList();

      transactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (kDebugMode) {
        debugPrint('✅ Transactions loaded successfully');
      }

      return transactions;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load transactions: $e');

        debugPrintStack(stackTrace: stackTrace);
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
      await _box.clear();

      if (kDebugMode) {
        debugPrint('🗑️ Transactions cleared');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Failed to clear transactions: $e');

        debugPrintStack(stackTrace: stackTrace);
      }
    }
  }
}
