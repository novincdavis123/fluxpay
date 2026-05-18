import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class OfflineEmptyState extends StatelessWidget {
  final String title;

  final String subtitle;

  final VoidCallback? onRetry;

  const OfflineEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            /// ICON CONTAINER
            Container(
              width: 110,
              height: 110,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: Colors.red.withOpacity(0.08),

                border: Border.all(color: Colors.red.withOpacity(0.15)),
              ),

              child: const Icon(
                Icons.cloud_off_rounded,
                size: 52,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            /// TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingSmall,
            ),

            const SizedBox(height: AppSpacing.sm),

            /// SUBTITLE
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),

            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),

              SizedBox(
                width: 180,

                child: ElevatedButton.icon(
                  onPressed: onRetry,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    padding: const EdgeInsets.symmetric(vertical: 16),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  icon: const Icon(Icons.refresh_rounded),

                  label: const Text('Retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
