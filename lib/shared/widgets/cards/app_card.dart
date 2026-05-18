import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_radius.dart';
import 'package:fluxpay/app/theme/app_shadows.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? margin;

  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    final card = Container(
      margin: margin,

      padding: padding ?? const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppColors.getCardColor(context),

        borderRadius: BorderRadius.circular(AppRadius.lg),

        border: Border.all(color: AppColors.getBorderColor(context)),

        boxShadow: isDark
            ? AppShadows.primary
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
      ),

      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),

        onTap: onTap,

        child: card,
      ),
    );
  }
}
