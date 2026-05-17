import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundblack,
      body: SafeArea(child: child),
    );
  }
}
