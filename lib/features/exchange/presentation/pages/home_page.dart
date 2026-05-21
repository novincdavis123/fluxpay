import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/utils/haptics.dart';

import 'package:fluxpay/features/analytics/presentation/pages/analytics_page.dart';

import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_event.dart';
import 'package:fluxpay/features/beneficiaries/presentation/pages/beneficiary_page.dart';

import 'package:fluxpay/features/exchange/presentation/pages/exchange_page.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/currency_chip.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/largeaction_card.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/marketrate_tile.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/mediumaction_card.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/miniinsight_card.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/quickstat.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/recentactivity_tile.dart';
import 'package:fluxpay/features/exchange/presentation/widgets/topaction_button.dart';

import 'package:fluxpay/features/settings/presentation/pages/profile.dart';

import 'package:fluxpay/features/transactions/presentation/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    context.read<BeneficiaryBloc>().add(LoadBeneficiaries());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    final cardColor = AppColors.getCardColor(context);

    final primaryText = AppColors.getTextPrimary(context);

    final secondaryText = AppColors.getTextSecondary(context);

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),

      body: Stack(
        children: [
          /// BACKGROUND GLOW
          Positioned(
            top: -120,
            right: -80,

            child: Container(
              width: 260,
              height: 260,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors.primary.withOpacity(isDark ? 0.14 : 0.08),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  /// =====================================================
                  /// HEADER
                  /// =====================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) {
                              return AppColors.primaryGradient.createShader(
                                bounds,
                              );
                            },

                            child: Text(
                              'FluxPay',

                              style: AppTextStyles.displayMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            'Global Remittance Platform',

                            style: AppTextStyles.bodyMedium.copyWith(
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),

                      TopActionButton(
                        icon: Icons.account_circle_rounded,

                        onTap: () async {
                          await AppHaptics.selection();

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// =====================================================
                  /// HERO BALANCE CARD
                  /// =====================================================
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(28),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),

                      gradient: AppColors.primaryGradient,

                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.32),
                          blurRadius: 34,
                          offset: const Offset(0, 18),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Text(
                              'Total Balance',

                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),

                                color: Colors.white.withOpacity(0.14),
                              ),

                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,

                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.greenAccent,
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    'Live FX',

                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          '\$24,860.45',

                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: const [
                            CurrencyChip(label: 'USD Wallet'),

                            SizedBox(width: 12),

                            CurrencyChip(label: 'INR Wallet'),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: const [
                            QuickStat(label: 'This Month', value: '\$8.2K'),

                            QuickStat(label: 'Transfers', value: '48'),

                            QuickStat(label: 'Countries', value: '12'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// =====================================================
                  /// MINI INSIGHTS
                  /// =====================================================
                  Row(
                    children: const [
                      Expanded(
                        child: MiniInsightCard(
                          title: 'Monthly Growth',
                          value: '+12.4%',
                          icon: Icons.trending_up_rounded,
                        ),
                      ),

                      SizedBox(width: 14),

                      Expanded(
                        child: MiniInsightCard(
                          title: 'Transfers',
                          value: '24',
                          icon: Icons.swap_horiz_rounded,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  /// =====================================================
                  /// QUICK ACTIONS TITLE
                  /// =====================================================
                  Text(
                    'Quick Actions',

                    style: AppTextStyles.headingMedium.copyWith(
                      color: primaryText,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// =====================================================
                  /// LARGE SEND MONEY CARD
                  /// =====================================================
                  LargeActionCard(
                    title: 'Send Money',
                    subtitle: 'Transfer funds globally in seconds',
                    icon: Icons.north_east_rounded,

                    onTap: () async {
                      await AppHaptics.selection();

                      if (!context.mounted) {
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ExchangePage()),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  /// =====================================================
                  /// MEDIUM ACTIONS
                  /// =====================================================
                  Row(
                    children: [
                      Expanded(
                        child: MediumActionCard(
                          title: 'Beneficiaries',
                          subtitle: 'Recipients',
                          icon: Icons.group_add_rounded,

                          onTap: () async {
                            await AppHaptics.selection();

                            if (!context.mounted) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const BeneficiaryPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: MediumActionCard(
                          title: 'Transactions',
                          subtitle: 'History',
                          icon: Icons.wallet_rounded,

                          onTap: () async {
                            await AppHaptics.selection();

                            if (!context.mounted) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TransactionPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: MediumActionCard(
                          title: 'Analytics',
                          subtitle: 'Insights',
                          icon: Icons.query_stats_rounded,

                          onTap: () async {
                            await AppHaptics.selection();

                            if (!context.mounted) {
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AnalyticsPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Container(
                          height: 168,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),

                            color: cardColor,

                            border: Border.all(
                              color: AppColors.getBorderColor(context),
                            ),
                          ),

                          child: Center(
                            child: Text(
                              'Premium FX',
                              style: AppTextStyles.headingSmall,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 34),

                  /// =====================================================
                  /// LIVE FX MARKET
                  /// =====================================================
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(24),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),

                      color: cardColor,

                      border: Border.all(
                        color: AppColors.getBorderColor(context),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'Live FX Market',

                          style: AppTextStyles.headingSmall.copyWith(
                            color: primaryText,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const MarketRateTile(
                          pair: 'USD → INR',
                          rate: '83.42',
                          change: '+0.24%',
                        ),

                        SizedBox(height: 18),

                        const MarketRateTile(
                          pair: 'EUR → USD',
                          rate: '1.08',
                          change: '+0.11%',
                        ),

                        SizedBox(height: 18),

                        const MarketRateTile(
                          pair: 'AED → INR',
                          rate: '22.71',
                          change: '-0.09%',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 34),

                  /// =====================================================
                  /// RECENT ACTIVITY
                  /// =====================================================
                  Text(
                    'Recent Activity',

                    style: AppTextStyles.headingMedium.copyWith(
                      color: primaryText,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const RecentActivityTile(
                    title: 'Transfer to Alex',
                    subtitle: 'Completed • 2 mins ago',
                  ),

                  SizedBox(height: 12),

                  const RecentActivityTile(
                    title: 'USD → AED Exchange',
                    subtitle: 'Processing • 10 mins ago',
                  ),

                  SizedBox(height: 12),

                  const RecentActivityTile(
                    title: 'INR Wallet Topup',
                    subtitle: 'Completed • Today',
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: Text(
                      'Powered by FluxPay FX Engine',

                      style: AppTextStyles.bodySmall.copyWith(
                        color: secondaryText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
