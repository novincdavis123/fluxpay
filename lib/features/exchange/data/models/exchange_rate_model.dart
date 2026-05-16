import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/exchange_rate_entity.dart';

part 'exchange_rate_model.g.dart';

@JsonSerializable()
class ExchangeRateModel {
  final String base;

  final String date;

  final Map<String, dynamic> rates;

  const ExchangeRateModel({
    required this.base,
    required this.date,
    required this.rates,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);

  ExchangeRateEntity toEntity() {
    final targetCurrency = rates.keys.first;

    final rateValue = rates.values.first;

    return ExchangeRateEntity(
      baseCurrency: base,
      targetCurrency: targetCurrency,
      rate: Decimal.parse(rateValue.toString()),
      timestamp: DateTime.parse(date),
    );
  }
}
