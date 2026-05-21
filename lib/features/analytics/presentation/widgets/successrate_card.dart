import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class SuccessRateCard extends StatelessWidget {
  final double successRate;

  const SuccessRateCard({super.key, required this.successRate});

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.getCardColor(context);

    final primaryText = AppColors.getTextPrimary(context);

    final secondaryText = AppColors.getTextSecondary(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.xl),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: cardColor,

        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.black.withOpacity(0.04),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Success Rate',

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  '${successRate.toStringAsFixed(1)}%',

                  style: AppTextStyles.displayLarge.copyWith(
                    color: primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Successful transfer completion ratio',

                  style: AppTextStyles.bodySmall.copyWith(color: secondaryText),
                ),
              ],
            ),
          ),

          SizedBox(
            width: 120,
            height: 120,

            child: Stack(
              alignment: Alignment.center,

              children: [
                SizedBox(
                  width: 110,
                  height: 110,

                  child: CircularProgressIndicator(
                    value: successRate / 100,
                    strokeWidth: 10,

                    backgroundColor: AppColors.primary.withOpacity(0.08),

                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),

                Container(
                  width: 72,
                  height: 72,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.12),
                  ),

                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.primary,
                    size: 34,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
