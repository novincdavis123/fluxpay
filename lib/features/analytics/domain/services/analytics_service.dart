import 'package:fluxpay/features/analytics/domain/entities/analytics_summary.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

class AnalyticsService {
  AnalyticsSummary generateSummary(List<TransactionModel> transactions) {
    double totalTransferred = 0;

    double totalFees = 0;

    int completed = 0;

    int failed = 0;

    int pending = 0;

    int processing = 0;

    int refunded = 0;

    final Map<String, double> currencyMap = {};

    final List<double> monthlyVolume = List.generate(6, (_) => 0);

    for (final tx in transactions) {
      totalTransferred += tx.senderAmount;

      totalFees += tx.fee;

      /// STATUS COUNTS
      switch (tx.status) {
        case TransactionStatus.completed:
          completed++;
          break;

        case TransactionStatus.failed:
          failed++;
          break;

        case TransactionStatus.pending:
          pending++;
          break;

        case TransactionStatus.processing:
          processing++;
          break;

        case TransactionStatus.refunded:
          refunded++;
          break;
      }

      /// CURRENCY DISTRIBUTION
      currencyMap.update(
        tx.senderCurrency,
        (value) => value + tx.senderAmount,
        ifAbsent: () => tx.senderAmount,
      );

      /// LAST 6 MONTHS VOLUME
      final now = DateTime.now();

      final monthDifference =
          (now.year - tx.createdAt.year) * 12 +
          (now.month - tx.createdAt.month);

      if (monthDifference >= 0 && monthDifference < 6) {
        monthlyVolume[5 - monthDifference] += tx.senderAmount;
      }
    }

    final totalTransactions = transactions.length;

    final double successRate = totalTransactions == 0
        ? 0
        : (completed / totalTransactions) * 100;

    final double averageTransferAmount = totalTransactions == 0
        ? 0
        : totalTransferred / totalTransactions;

    return AnalyticsSummary(
      totalTransferred: totalTransferred,

      totalFees: totalFees,

      totalTransactions: totalTransactions,

      completedTransactions: completed,

      failedTransactions: failed,

      pendingTransactions: pending,

      processingTransactions: processing,

      refundedTransactions: refunded,

      successRate: successRate,

      averageTransferAmount: averageTransferAmount,

      supportedCurrencies: currencyMap.keys.length,

      currencyDistribution: currencyMap,

      monthlyVolume: monthlyVolume,
    );
  }
}
