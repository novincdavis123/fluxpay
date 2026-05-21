import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class PremiumInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool isBold;
  final Color? valueColor;

  const PremiumInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.isLast = false,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),

      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Text(
              label,

              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,

              style: AppTextStyles.bodyLarge.copyWith(
                color: valueColor ?? AppColors.getTextPrimary(context),

                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
