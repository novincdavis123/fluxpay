class AnalyticsSummary {
  final double totalTransferred;

  final double totalFees;

  final int completedTransactions;

  final int failedTransactions;

  final double successRate;

  final Map<String, double> currencyDistribution;

  final List<double> monthlyVolume;

  const AnalyticsSummary({
    required this.totalTransferred,
    required this.totalFees,
    required this.completedTransactions,
    required this.failedTransactions,
    required this.successRate,
    required this.currencyDistribution,
    required this.monthlyVolume,
  });
}
