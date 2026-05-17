import 'dart:convert';

import 'package:hive/hive.dart';

import 'package:fluxpay/core/constants/storage_constants.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> cacheTransactions(List<TransactionModel> transactions);

  Future<List<TransactionModel>> getTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    final box = await Hive.openBox(StorageConstants.transactionsBox);

    final encodedList = transactions
        .map((e) => jsonEncode(e.toJson()))
        .toList();

    await box.put('transactions', encodedList);
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final box = await Hive.openBox(StorageConstants.transactionsBox);

    final data = box.get('transactions');

    if (data == null) {
      return [];
    }

    final decoded = List<String>.from(data);

    return decoded
        .map((e) => TransactionModel.fromJson(jsonDecode(e)))
        .toList();
  }
}
