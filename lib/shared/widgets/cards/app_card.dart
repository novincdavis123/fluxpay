import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_radius.dart';
import 'package:fluxpay/app/theme/app_shadows.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.primary,
      ),
      child: child,
    );
  }
}
