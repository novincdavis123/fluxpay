class AnalyticsSummary {
  final double totalTransferred;

  final double totalFees;

  final int totalTransactions;

  final int completedTransactions;

  final int failedTransactions;

  final int pendingTransactions;

  final int processingTransactions;

  final int refundedTransactions;

  final double successRate;

  final double averageTransferAmount;

  final int supportedCurrencies;

  final Map<String, double> currencyDistribution;

  final List<double> monthlyVolume;

  const AnalyticsSummary({
    required this.totalTransferred,

    required this.totalFees,

    required this.totalTransactions,

    required this.completedTransactions,

    required this.failedTransactions,

    required this.pendingTransactions,

    required this.processingTransactions,

    required this.refundedTransactions,

    required this.successRate,

    required this.averageTransferAmount,

    required this.supportedCurrencies,

    required this.currencyDistribution,

    required this.monthlyVolume,
  });

  factory AnalyticsSummary.empty() {
    return const AnalyticsSummary(
      totalTransferred: 0,

      totalFees: 0,

      totalTransactions: 0,

      completedTransactions: 0,

      failedTransactions: 0,

      pendingTransactions: 0,

      processingTransactions: 0,

      refundedTransactions: 0,

      successRate: 0,

      averageTransferAmount: 0,

      supportedCurrencies: 0,

      currencyDistribution: {},

      monthlyVolume: [0, 0, 0, 0, 0, 0],
    );
  }

  bool get hasTransactions => totalTransactions > 0;

  double get completionRate {
    if (totalTransactions == 0) {
      return 0;
    }

    return (completedTransactions / totalTransactions) * 100;
  }

  double get failureRate {
    if (totalTransactions == 0) {
      return 0;
    }

    return (failedTransactions / totalTransactions) * 100;
  }

  double get pendingRate {
    if (totalTransactions == 0) {
      return 0;
    }

    return (pendingTransactions / totalTransactions) * 100;
  }

  double get processingRate {
    if (totalTransactions == 0) {
      return 0;
    }

    return (processingTransactions / totalTransactions) * 100;
  }

  double get refundedRate {
    if (totalTransactions == 0) {
      return 0;
    }

    return (refundedTransactions / totalTransactions) * 100;
  }

  String get topCurrency {
    if (currencyDistribution.isEmpty) {
      return '--';
    }

    final sorted = currencyDistribution.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.first.key;
  }
}
