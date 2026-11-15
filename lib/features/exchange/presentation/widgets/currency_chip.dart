import 'package:material_ui/material_ui.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class CurrencyChip extends StatelessWidget {
  final String label;

  const CurrencyChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),

        color: Colors.white.withValues(alpha: 0.14),
      ),

      child: Text(
        label,

        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
