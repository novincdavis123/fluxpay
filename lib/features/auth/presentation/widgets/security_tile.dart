import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class SecurityTile extends StatelessWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final bool value;

  final ValueChanged<bool> onChanged;

  const SecurityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.04),

        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),

      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),

              color: AppColors.primary.withOpacity(0.12),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: AppTextStyles.headingSmall),

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
