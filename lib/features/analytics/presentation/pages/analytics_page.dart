import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/features/analytics/domain/services/analytics_service.dart';
import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:fluxpay/injection_container.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final summary = sl<AnalyticsService>().generateSummary(
          state.transactions,
        );

        return Scaffold(
          backgroundColor: AppColors.backgroundblack,

          appBar: AppBar(
            backgroundColor: Colors.transparent,

            elevation: 0,

            title: Text('Analytics', style: AppTextStyles.headingSmall),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// TOTAL TRANSFERRED
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(AppSpacing.xl),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),

                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                    ),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Total Transferred',

                        style: AppTextStyles.bodyMedium,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Text(
                        '\$${summary.totalTransferred.toStringAsFixed(2)}',

                        style: AppTextStyles.displayLarge,
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      Row(
                        children: [
                          _StatChip(
                            label: '${summary.completedTransactions} Completed',
                          ),

                          const SizedBox(width: AppSpacing.sm),

                          _StatChip(
                            label: '${summary.failedTransactions} Failed',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                /// MONTHLY CHART
                Text('Monthly Volume', style: AppTextStyles.headingMedium),

                const SizedBox(height: 20),

                Container(
                  height: 240,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),

                    color: Colors.white.withOpacity(0.05),
                  ),

                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),

                      borderData: FlBorderData(show: false),

                      titlesData: FlTitlesData(show: false),

                      lineBarsData: [
                        LineChartBarData(
                          isCurved: true,

                          spots: List.generate(summary.monthlyVolume.length, (
                            index,
                          ) {
                            return FlSpot(
                              index.toDouble(),
                              summary.monthlyVolume[index],
                            );
                          }),

                          dotData: FlDotData(show: false),

                          belowBarData: BarAreaData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// SUCCESS RATE
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),

                    color: Colors.white.withOpacity(0.05),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text('Success Rate', style: AppTextStyles.headingSmall),

                      const SizedBox(height: 16),

                      Text(
                        '${summary.successRate.toStringAsFixed(1)}%',

                        style: AppTextStyles.displayLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;

  const _StatChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),

        color: Colors.white.withOpacity(0.15),
      ),

      child: Text(label, style: AppTextStyles.bodySmall),
    );
  }
}
