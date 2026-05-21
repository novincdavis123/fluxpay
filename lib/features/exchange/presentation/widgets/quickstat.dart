import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class QuickStat extends StatelessWidget {
  final String label;
  final String value;

  const QuickStat({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,

          style: AppTextStyles.headingSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,

          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
