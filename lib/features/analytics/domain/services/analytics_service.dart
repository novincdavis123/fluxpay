import 'package:fluxpay/features/analytics/domain/entities/analytics_summary.dart';
import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';
import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

class AnalyticsService {
  // Generate analytics summary from a list of transactions
  AnalyticsSummary generateSummary(List<TransactionModel> transactions) {
    double totalTransferred = 0;

    double totalFees = 0;

    int completed = 0;

    int failed = 0;

    final Map<String, double> currencyMap = {};

    final List<double> monthlyVolume = List.generate(6, (_) => 0);

    for (final tx in transactions) {
      totalTransferred += tx.senderAmount;

      totalFees += tx.fee;

      if (tx.status == TransactionStatus.completed) {
        completed++;
      }

      if (tx.status == TransactionStatus.failed) {
        failed++;
      }
      // Update currency distribution
      currencyMap.update(
        tx.senderCurrency,
        (value) => value + tx.senderAmount,
        ifAbsent: () => tx.senderAmount,
      );

      final monthIndex = DateTime.now().month - tx.createdAt.month;

      if (monthIndex >= 0 && monthIndex < 6) {
        monthlyVolume[5 - monthIndex] += tx.senderAmount;
      }
    }

    final double successRate = transactions.isEmpty
        ? 0.0
        : ((completed / transactions.length) * 100).toDouble();
    // Convert currency distribution to percentages
    return AnalyticsSummary(
      totalTransferred: totalTransferred,

      totalFees: totalFees,

      completedTransactions: completed,

      failedTransactions: failed,

      successRate: successRate,

      currencyDistribution: currencyMap,

      monthlyVolume: monthlyVolume,
    );
  }
}
