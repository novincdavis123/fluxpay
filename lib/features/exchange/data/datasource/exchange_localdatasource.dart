import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:fluxpay/core/constants/hive_boxes.dart';

import '../models/exchange_rate_model.dart';

abstract class ExchangeLocalDataSource {
  Future<void> cacheExchangeRate(ExchangeRateModel model);

  Future<ExchangeRateModel?> getCachedExchangeRate({
    required String from,
    required String to,
  });

  Future<void> clearCache();
}

class ExchangeLocalDataSourceImpl implements ExchangeLocalDataSource {
  static const String _cachePrefix = 'exchange_rate_';

  final Box<ExchangeRateModel> _box = Hive.box<ExchangeRateModel>(
    HiveBoxes.exchangeRates,
  );

  @override
  Future<void> cacheExchangeRate(ExchangeRateModel model) async {
    try {
      final cacheKey = '$_cachePrefix${model.base}_${model.targetCurrency}';

      await _box.put(cacheKey, model);

      if (kDebugMode) {
        debugPrint('✅ Exchange rate cached: $cacheKey');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to cache exchange rate: $e');
      }

      rethrow;
    }
  }

  @override
  Future<ExchangeRateModel?> getCachedExchangeRate({
    required String from,
    required String to,
  }) async {
    try {
      final cacheKey = '$_cachePrefix${from}_$to';

      final model = _box.get(cacheKey);

      if (model == null) {
        if (kDebugMode) {
          debugPrint('⚠️ No cached exchange rate found');
        }

        return null;
      }

      if (kDebugMode) {
        debugPrint('✅ Cached exchange rate loaded');
      }

      return model;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load cached exchange rate: $e');
      }

      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();

      if (kDebugMode) {
        debugPrint('🗑️ Exchange cache cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to clear exchange cache: $e');
      }
    }
  }
}
