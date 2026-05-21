import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';

class TopActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const TopActionButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 54,
        height: 54,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: AppColors.getCardColor(context),

          border: Border.all(color: AppColors.getBorderColor(context)),
        ),

        child: Icon(icon),
      ),
    );
  }
}
