import 'package:hive/hive.dart';

import 'package:fluxpay/core/constants/hive_boxes.dart';

import '../models/exchange_rate_cache_model.dart';

abstract class ExchangeCacheDataSource {
  Future<void> cacheRate(ExchangeRateCacheModel model);

  Future<ExchangeRateCacheModel?> getRate(String pair);
}

class ExchangeCacheDataSourceImpl implements ExchangeCacheDataSource {
  late final Box _box;

  ExchangeCacheDataSourceImpl() {
    _box = Hive.box(HiveBoxes.exchangeRates);
  }

  @override
  Future<void> cacheRate(ExchangeRateCacheModel model) async {
    await _box.put(model.pair, model.toJson());
  }

  @override
  Future<ExchangeRateCacheModel?> getRate(String pair) async {
    final data = _box.get(pair);

    if (data == null) {
      return null;
    }

    return ExchangeRateCacheModel.fromJson(Map<String, dynamic>.from(data));
  }
}
