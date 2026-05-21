import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class PremiumSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const PremiumSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        color: AppColors.getCardColor(context),

        border: Border.all(color: AppColors.getBorderColor(context)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.16 : 0.03),

            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),

                  color: AppColors.primary.withOpacity(0.10),
                ),

                child: Icon(icon, color: AppColors.primary),
              ),

              const SizedBox(width: 14),

              Text(
                title,

                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          child,
        ],
      ),
    );
  }
}
