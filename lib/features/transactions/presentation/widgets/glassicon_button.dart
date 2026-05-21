import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';

class GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const GlassIconButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,

        child: Container(
          width: 46,
          height: 46,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            color: AppColors.getCardColor(context).withOpacity(0.9),

            border: Border.all(color: AppColors.getBorderColor(context)),
          ),

          child: Icon(icon, color: AppColors.getTextPrimary(context), size: 20),
        ),
      ),
    );
  }
}
