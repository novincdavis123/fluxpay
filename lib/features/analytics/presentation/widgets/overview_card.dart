import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/features/analytics/presentation/widgets/analyticstat_card.dart';

class OverviewCard extends StatelessWidget {
  final dynamic summary;

  const OverviewCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),

        gradient: AppColors.primaryGradient,

        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.28),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.14),
                ),

                child: const Icon(Icons.public_rounded, color: Colors.white),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white.withOpacity(0.14),
                ),

                child: Text(
                  '${summary.completedTransactions} Transfers',

                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          Text(
            'Total Transferred',

            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            '\$${summary.totalTransferred.toStringAsFixed(2)}',

            style: AppTextStyles.displayLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          Row(
            children: [
              Expanded(
                child: AnalyticsStatCard(
                  label: 'Completed',
                  value: summary.completedTransactions.toString(),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: AnalyticsStatCard(
                  label: 'Failed',
                  value: summary.failedTransactions.toString(),
                  icon: Icons.cancel_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
