import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';

import 'package:fluxpay/core/widgets/shimmer_box.dart';

class ExchangeLoadingView extends StatelessWidget {
  const ExchangeLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          const ShimmerBox(height: 34, width: 220),

          const SizedBox(height: AppSpacing.md),

          const ShimmerBox(height: 18, width: 180),

          const SizedBox(height: AppSpacing.xl),

          /// MAIN EXCHANGE CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Theme.of(context).cardColor,
            ),
            child: Column(
              children: [
                /// SEND SECTION
                _buildCurrencySkeleton(),

                const SizedBox(height: AppSpacing.xl),

                /// SWAP BUTTON
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.06),
                  ),
                  child: const Center(child: ShimmerBox(height: 24, width: 24)),
                ),

                const SizedBox(height: AppSpacing.xl),

                /// RECEIVE SECTION
                _buildCurrencySkeleton(),

                const SizedBox(height: AppSpacing.xl),

                /// RATE INFO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Colors.white.withOpacity(0.04),
                  ),
                  child: Column(
                    children: [
                      _buildRateRow(),

                      const SizedBox(height: AppSpacing.lg),

                      _buildRateRow(),

                      const SizedBox(height: AppSpacing.lg),

                      _buildRateRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          /// EXTRA LOADING BLOCKS
          Row(
            children: [
              Expanded(child: const ShimmerBox(height: 120)),

              const SizedBox(width: AppSpacing.md),

              Expanded(child: const ShimmerBox(height: 120)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerBox(height: 16, width: 100),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: [
            const ShimmerBox(height: 40, width: 40),

            const SizedBox(width: AppSpacing.md),

            const Expanded(child: ShimmerBox(height: 42)),

            const SizedBox(width: AppSpacing.md),

            const ShimmerBox(height: 24, width: 50),
          ],
        ),
      ],
    );
  }

  Widget _buildRateRow() {
    return const Row(
      children: [
        ShimmerBox(height: 16, width: 110),

        Spacer(),

        ShimmerBox(height: 16, width: 120),
      ],
    );
  }
}
