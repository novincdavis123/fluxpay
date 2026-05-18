class ExchangeRateCacheModel {
  final String pair;

  final double rate;

  final DateTime updatedAt;

  ExchangeRateCacheModel({
    required this.pair,
    required this.rate,
    required this.updatedAt,
  });

  factory ExchangeRateCacheModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateCacheModel(
      pair: json['pair'],
      rate: json['rate'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pair': pair,
      'rate': rate,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
