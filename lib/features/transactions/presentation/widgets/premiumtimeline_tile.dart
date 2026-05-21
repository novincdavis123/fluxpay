import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class PremiumTimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool isLast;

  const PremiumTimelineTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                width: 20,
                height: 20,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: completed
                      ? AppColors.success
                      : AppColors.getTextMuted(context),

                  boxShadow: completed
                      ? [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.4),
                            blurRadius: 12,
                          ),
                        ]
                      : [],
                ),

                child: completed
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 58,

                  color: completed
                      ? AppColors.success
                      : AppColors.getBorderColor(context),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.getTextPrimary(context),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.getTextSecondary(context),
                    height: 1.5,
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
