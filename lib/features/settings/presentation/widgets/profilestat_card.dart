import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class ProfileStatCard extends StatelessWidget {
  final IconData icon;

  final String title;

  final String value;

  const ProfileStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: AppColors.primary.withOpacity(0.08),
      ),

      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),

          const SizedBox(height: 10),

          Text(
            value,

            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,

            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
