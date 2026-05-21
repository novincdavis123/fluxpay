import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/utils/haptics.dart';

import 'package:fluxpay/features/analytics/domain/services/analytics_service.dart';
import 'package:fluxpay/features/analytics/presentation/widgets/monthly_volume_chart.dart';
import 'package:fluxpay/features/analytics/presentation/widgets/overview_card.dart';
import 'package:fluxpay/features/analytics/presentation/widgets/successrate_card.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

import 'package:fluxpay/injection_container.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.getCardColor(context);

    final primaryText = AppColors.getTextPrimary(context);

    final secondaryText = AppColors.getTextSecondary(context);

    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        final summary = sl<AnalyticsService>().generateSummary(
          state.transactions,
        );

        final monthlyVolume = summary.monthlyVolume;

        return Scaffold(
          body: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: cardColor,
            onRefresh: () async {
              await AppHaptics.selection();

              if (!context.mounted) {
                return;
              }

              context.read<TransactionBloc>().add(const LoadTransactions());
            },

            child: state.isLoading && state.transactions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                /// EMPTY STATE
                : state.transactions.isEmpty
                ? const _AnalyticsEmptyState()
                /// CONTENT
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),

                    padding: const EdgeInsets.all(AppSpacing.lg),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// =====================================================
                        /// HEADER
                        /// =====================================================
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return AppColors.primaryGradient.createShader(
                              bounds,
                            );
                          },

                          child: Text(
                            'Analytics',

                            style: AppTextStyles.displayMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ).animate().fadeIn(),

                        const SizedBox(height: AppSpacing.sm),

                        Text(
                          'Track your international transfer performance and spending insights.',

                          style: AppTextStyles.bodyMedium.copyWith(
                            color: secondaryText,
                          ),
                        ).animate().fadeIn(delay: 100.ms),

                        const SizedBox(height: AppSpacing.xxl),

                        /// TOTAL TRANSFERRED
                        OverviewCard(
                          summary: summary,
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),

                        const SizedBox(height: 32),

                        /// SUCCESS RATE
                        SuccessRateCard(
                          successRate: summary.successRate,
                        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15),

                        const SizedBox(height: 36),

                        /// MONTHLY VOLUME
                        Text(
                          'Monthly Volume',

                          style: AppTextStyles.headingMedium.copyWith(
                            color: primaryText,
                          ),
                        ).animate().fadeIn(delay: 350.ms),

                        const SizedBox(height: AppSpacing.lg),

                        MonthlyVolumeChart(
                          monthlyVolume: monthlyVolume,
                        ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.15),

                        const SizedBox(height: 36),

                        /// QUICK STATS
                        Text(
                          'Quick Stats',

                          style: AppTextStyles.headingMedium.copyWith(
                            color: primaryText,
                          ),
                        ).animate().fadeIn(delay: 500.ms),

                        const SizedBox(height: AppSpacing.lg),

                        Row(
                          children: [
                            Expanded(
                              child: _MiniAnalyticsCard(
                                title: 'Transactions',
                                value: state.transactions.length.toString(),
                                icon: Icons.receipt_long_rounded,
                              ),
                            ),

                            const SizedBox(width: AppSpacing.md),

                            Expanded(
                              child: _MiniAnalyticsCard(
                                title: 'Currencies',
                                value: summary.supportedCurrencies.toString(),
                                icon: Icons.currency_exchange_rounded,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 550.ms),

                        const SizedBox(height: AppSpacing.xl),

                        Row(
                          children: [
                            Expanded(
                              child: _MiniAnalyticsCard(
                                title: 'Success',
                                value:
                                    '${summary.successRate.toStringAsFixed(0)}%',
                                icon: Icons.trending_up_rounded,
                              ),
                            ),

                            const SizedBox(width: AppSpacing.md),

                            Expanded(
                              child: _MiniAnalyticsCard(
                                title: 'Completed',
                                value: summary.completedTransactions.toString(),
                                icon: Icons.check_circle_rounded,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 650.ms),

                        const SizedBox(height: 50),

                        Center(
                          child: Text(
                            'Powered by FluxPay Analytics Engine',

                            style: AppTextStyles.bodySmall.copyWith(
                              color: secondaryText,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _MiniAnalyticsCard extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  const _MiniAnalyticsCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.getCardColor(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText = AppColors.getTextPrimary(context);

    final secondaryText = AppColors.getTextSecondary(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: cardColor,

        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.black.withOpacity(0.04),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.primary.withOpacity(0.10),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            value,

            style: AppTextStyles.headingMedium.copyWith(
              color: primaryText,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: AppTextStyles.bodySmall.copyWith(color: secondaryText),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsEmptyState extends StatelessWidget {
  const _AnalyticsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(0.08),

                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.12),
                      ),
                    ),

                    child: const Icon(
                      Icons.analytics_outlined,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(
                    duration: 2.seconds,
                    begin: const Offset(1, 1),
                    end: const Offset(1.05, 1.05),
                  ),

              const SizedBox(height: AppSpacing.xl),

              Text(
                'No Analytics Yet',

                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.getTextPrimary(context),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Complete your first international transfer to unlock analytics insights and performance tracking.',

                textAlign: TextAlign.center,

                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.getTextSecondary(context),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              ElevatedButton.icon(
                onPressed: () async {
                  await AppHaptics.selection();
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),

                icon: const Icon(Icons.send_rounded),

                label: Text('Start Transfer', style: AppTextStyles.buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
