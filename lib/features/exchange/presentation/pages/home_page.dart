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

                      _TopActionButton(
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
                            _CurrencyChip(label: 'USD Wallet'),

                            SizedBox(width: 12),

                            _CurrencyChip(label: 'INR Wallet'),
                          ],
                        ),

                        const SizedBox(height: 28),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: const [
                            _QuickStat(label: 'This Month', value: '\$8.2K'),

                            _QuickStat(label: 'Transfers', value: '48'),

                            _QuickStat(label: 'Countries', value: '12'),
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
                        child: _MiniInsightCard(
                          title: 'Monthly Growth',
                          value: '+12.4%',
                          icon: Icons.trending_up_rounded,
                        ),
                      ),

                      SizedBox(width: 14),

                      Expanded(
                        child: _MiniInsightCard(
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
                  _LargeActionCard(
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
                        child: _MediumActionCard(
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
                        child: _MediumActionCard(
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
                        child: _MediumActionCard(
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

                        const _MarketRateTile(
                          pair: 'USD → INR',
                          rate: '83.42',
                          change: '+0.24%',
                        ),

                        SizedBox(height: 18),

                        const _MarketRateTile(
                          pair: 'EUR → USD',
                          rate: '1.08',
                          change: '+0.11%',
                        ),

                        SizedBox(height: 18),

                        const _MarketRateTile(
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

                  const _RecentActivityTile(
                    title: 'Transfer to Alex',
                    subtitle: 'Completed • 2 mins ago',
                  ),

                  SizedBox(height: 12),

                  const _RecentActivityTile(
                    title: 'USD → AED Exchange',
                    subtitle: 'Processing • 10 mins ago',
                  ),

                  SizedBox(height: 12),

                  const _RecentActivityTile(
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

class _TopActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopActionButton({required this.icon, required this.onTap});

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

class _LargeActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _LargeActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),

          gradient: AppColors.primaryGradient,
        ),

        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,

                    style: AppTextStyles.headingMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,

                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.14),
              ),

              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediumActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MediumActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 168,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),

          color: AppColors.getCardColor(context),

          border: Border.all(color: AppColors.getBorderColor(context)),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),

                gradient: AppColors.primaryGradient,
              ),

              child: Icon(icon, color: Colors.white),
            ),

            const Spacer(),

            Text(title, style: AppTextStyles.headingSmall),

            const SizedBox(height: 4),

            Text(subtitle, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MiniInsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MiniInsightCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

        color: AppColors.getCardColor(context),

        border: Border.all(color: AppColors.getBorderColor(context)),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: AppColors.primary.withOpacity(0.12),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: AppTextStyles.bodySmall),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;

  const _QuickStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,

          style: AppTextStyles.headingSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,

          style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _CurrencyChip extends StatelessWidget {
  final String label;

  const _CurrencyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),

        color: Colors.white.withOpacity(0.14),
      ),

      child: Text(
        label,

        style: AppTextStyles.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _MarketRateTile extends StatelessWidget {
  final String pair;
  final String rate;
  final String change;

  const _MarketRateTile({
    required this.pair,
    required this.rate,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change.contains('+');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(pair, style: AppTextStyles.headingSmall),

            const SizedBox(height: 4),

            Text('Live interbank rate', style: AppTextStyles.bodySmall),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,

          children: [
            Text(
              rate,

              style: AppTextStyles.headingSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              change,

              style: AppTextStyles.bodySmall.copyWith(
                color: isPositive ? AppColors.success : AppColors.error,

                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecentActivityTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RecentActivityTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        color: AppColors.getCardColor(context),

        border: Border.all(color: AppColors.getBorderColor(context)),
      ),

      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: AppColors.primary.withOpacity(0.12),
            ),

            child: const Icon(Icons.sync_alt_rounded, color: AppColors.primary),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: AppTextStyles.bodyLarge),

                const SizedBox(height: 4),

                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
