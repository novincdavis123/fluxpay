// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange_rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExchangeRateModel _$ExchangeRateModelFromJson(Map<String, dynamic> json) =>
    ExchangeRateModel(
      base: json['base'] as String,
      date: json['date'] as String,
      rates: json['rates'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ExchangeRateModelToJson(ExchangeRateModel instance) =>
    <String, dynamic>{
      'base': instance.base,
      'date': instance.date,
      'rates': instance.rates,
    };
