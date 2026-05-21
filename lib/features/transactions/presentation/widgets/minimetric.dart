import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class Minimetric extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const Minimetric({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        color: AppColors.getCardColor(context),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: AppColors.primary, size: 22),

          const SizedBox(height: 12),

          Text(
            title,

            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.getTextPrimary(context),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
