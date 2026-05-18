import 'package:decimal/decimal.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/exchange_rate_entity.dart';

part 'exchange_rate_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class ExchangeRateModel {
  @HiveField(0)
  final String base;

  @HiveField(1)
  final String date;

  @HiveField(2)
  final Map<String, dynamic> rates;

  @HiveField(3)
  final DateTime cachedAt;

  const ExchangeRateModel({
    required this.base,
    required this.date,
    required this.rates,
    required this.cachedAt,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      base: json['base'] as String? ?? '',
      date: json['date'] as String? ?? '',
      rates: Map<String, dynamic>.from(json['rates'] ?? {}),
      cachedAt: json['cachedAt'] != null
          ? DateTime.parse(json['cachedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base': base,
      'date': date,
      'rates': rates,
      'cachedAt': cachedAt.toIso8601String(),
    };
  }

  ExchangeRateEntity toEntity() {
    if (rates.isEmpty) {
      throw Exception('Exchange rates are empty');
    }

    final targetCurrency = rates.keys.first;

    final rateValue = rates.values.first;

    return ExchangeRateEntity(
      baseCurrency: base,
      targetCurrency: targetCurrency,
      rate: Decimal.parse(rateValue.toString()),
      timestamp: DateTime.tryParse(date) ?? cachedAt,
    );
  }

  double get rateValue {
    if (rates.isEmpty) {
      return 0;
    }

    return (rates.values.first as num).toDouble();
  }

  String get targetCurrency {
    if (rates.isEmpty) {
      return '';
    }

    return rates.keys.first;
  }

  bool get isExpired {
    final now = DateTime.now();

    return now.difference(cachedAt).inMinutes > 30;
  }

  ExchangeRateModel copyWith({
    String? base,
    String? date,
    Map<String, dynamic>? rates,
    DateTime? cachedAt,
  }) {
    return ExchangeRateModel(
      base: base ?? this.base,
      date: date ?? this.date,
      rates: rates ?? this.rates,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
