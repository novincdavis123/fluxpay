import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class MarketRateTile extends StatelessWidget {
  final String pair;
  final String rate;
  final String change;

  const MarketRateTile({
    super.key,
    required this.pair,
    required this.rate,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change.contains('+');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(pair, style: AppTextStyles.headingSmall),

            const SizedBox(height: 4),

            Text('Live interbank rate', style: AppTextStyles.bodySmall),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(
              rate,

              style: AppTextStyles.headingSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              change,

              style: AppTextStyles.bodySmall.copyWith(
                color: isPositive ? AppColors.success : AppColors.error,

                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
