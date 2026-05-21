import 'dart:math';

import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class AnimatedEmptyState extends StatefulWidget {
  final IconData icon;

  final String title;

  final String subtitle;

  final Widget? action;

  const AnimatedEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  State<AnimatedEmptyState> createState() => _AnimatedEmptyStateState();
}

class _AnimatedEmptyStateState extends State<AnimatedEmptyState>
    with TickerProviderStateMixin {
  late final AnimationController _floatingController;

  late final AnimationController _fadeController;

  late final Animation<double> _fadeAnimation;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    /// FLOATING LOOP
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    /// ENTRANCE ANIMATION
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _floatingController.dispose();

    _fadeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,

      child: ScaleTransition(
        scale: _scaleAnimation,

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                /// FLOATING ICON
                AnimatedBuilder(
                  animation: _floatingController,

                  builder: (context, child) {
                    final offset = sin(_floatingController.value * 2 * pi) * 8;

                    return Transform.translate(
                      offset: Offset(0, offset),

                      child: child,
                    );
                  },

                  child: Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      color: AppColors.borderDark.withOpacity(0.04),

                      border: Border.all(
                        color: AppColors.borderDark.withOpacity(0.05),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: AppColors.borderDark.withOpacity(0.08),

                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),

                    child: Icon(
                      widget.icon,
                      size: 56,
                      color: AppColors.borderDark,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// TITLE
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingSmall,
                ),

                const SizedBox(height: AppSpacing.sm),

                /// SUBTITLE
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium,
                ),

                if (widget.action != null) ...[
                  const SizedBox(height: 28),

                  widget.action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
