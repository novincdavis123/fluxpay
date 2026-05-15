import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/shared/widgets/cards/app_card.dart';
import 'package:fluxpay/shared/widgets/common/app_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.lg),

            Text('FluxPay', style: AppTextStyles.headingLarge),

            const SizedBox(height: AppSpacing.sm),

            Text('Fast. Transparent. Global.', style: AppTextStyles.bodyMedium),

            const SizedBox(height: AppSpacing.xl),

            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Live Exchange Rates'),

                  SizedBox(height: AppSpacing.md),

                  Text('USD → INR'),

                  SizedBox(height: AppSpacing.sm),

                  Text('1 USD = ₹83.24'),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Transfers'),

                  SizedBox(height: AppSpacing.md),

                  Text('No recent transfers yet.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
