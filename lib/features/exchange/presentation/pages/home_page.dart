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

import 'package:fluxpay/features/settings/presentation/pages/settings_page.dart';

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
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final cardColor = AppColors.getCardColor(context);

    final primaryText = AppColors.getTextPrimary(context);

    final secondaryText = AppColors.getTextSecondary(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.getBackground(context),

        body: SingleChildScrollView(
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
                          return AppColors.primaryGradient.createShader(bounds);
                        },

                        child: Text(
                          'FluxPay',

                          style: AppTextStyles.displayMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.xs),

                      Text(
                        'Global Remittance Platform',

                        style: AppTextStyles.bodyMedium.copyWith(
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      /// SETTINGS BUTTON
                      _TopActionButton(
                        icon: Icons.settings_rounded,

                        onTap: () async {
                          await AppHaptics.selection();

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(width: AppSpacing.sm),

                      /// PROFILE
                      _TopActionButton(
                        icon: Icons.person_outline_rounded,

                        onTap: () async {
                          await AppHaptics.selection();

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
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              /// =====================================================
              /// BALANCE CARD
              /// =====================================================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(AppSpacing.xl),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),

                  gradient: AppColors.primaryGradient,

                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Total Balance',

                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      '\$24,860.45',

                      style: AppTextStyles.displayLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    Row(
                      children: const [
                        _CurrencyChip(label: 'USD Wallet'),

                        SizedBox(width: AppSpacing.sm),

                        _CurrencyChip(label: 'INR Wallet'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              /// =====================================================
              /// QUICK ACTIONS
              /// =====================================================
              Text(
                'Quick Actions',

                style: AppTextStyles.headingMedium.copyWith(color: primaryText),
              ),

              const SizedBox(height: AppSpacing.lg),

              GridView.count(
                crossAxisCount: 2,

                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                crossAxisSpacing: AppSpacing.md,

                mainAxisSpacing: AppSpacing.md,

                childAspectRatio: 1.05,

                children: [
                  _ActionCard(
                    title: 'Send Money',

                    subtitle: 'Start transfer',

                    icon: Icons.send_rounded,

                    backgroundColor: cardColor,

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

                  _ActionCard(
                    title: 'Beneficiaries',

                    subtitle: 'Manage recipients',

                    icon: Icons.people_alt_rounded,

                    backgroundColor: cardColor,

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

                  _ActionCard(
                    title: 'Transactions',

                    subtitle: 'Transfer history',

                    icon: Icons.receipt_long_rounded,

                    backgroundColor: cardColor,

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

                  _ActionCard(
                    title: 'Analytics',

                    subtitle: 'Spending insights',

                    icon: Icons.bar_chart_rounded,

                    backgroundColor: cardColor,

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
                ],
              ),

              const SizedBox(height: AppSpacing.xxl),

              /// =====================================================
              /// LIVE FX MARKET
              /// =====================================================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(AppSpacing.xl),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  color: cardColor,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.20 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,

                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: AppSpacing.sm),

                        Text(
                          'Live FX Market',

                          style: AppTextStyles.headingSmall.copyWith(
                            color: primaryText,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    const _MarketRateTile(
                      pair: 'USD → INR',
                      rate: '83.42',
                      change: '+0.24%',
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    const _MarketRateTile(
                      pair: 'EUR → USD',
                      rate: '1.08',
                      change: '+0.11%',
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    const _MarketRateTile(
                      pair: 'AED → INR',
                      rate: '22.71',
                      change: '-0.09%',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xxl),

              /// =====================================================
              /// FOOTER
              /// =====================================================
              Center(
                child: Text(
                  'Powered by FluxPay FX Engine',

                  style: AppTextStyles.bodySmall.copyWith(color: secondaryText),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 52,
        height: 52,

        decoration: BoxDecoration(
          shape: BoxShape.circle,

          color: isDark
              ? Colors.white.withOpacity(0.06)
              : Colors.black.withOpacity(0.04),

          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.black.withOpacity(0.05),
          ),
        ),

        child: Icon(icon, color: Theme.of(context).iconTheme.color),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;

  final String subtitle;

  final IconData icon;

  final VoidCallback onTap;

  final Color backgroundColor;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),

        padding: const EdgeInsets.all(AppSpacing.lg),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),

          color: backgroundColor,

          border: Border.all(color: AppColors.getBorderColor(context)),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.20 : 0.04),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 56,
              height: 56,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                gradient: AppColors.primaryGradient,
              ),

              child: Icon(icon, color: Colors.white, size: 28),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              title,

              style: AppTextStyles.headingSmall,

              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,

              style: AppTextStyles.bodySmall,

              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),

      child: Text(
        label,

        style: AppTextStyles.label.copyWith(color: Colors.white),
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

            const SizedBox(height: AppSpacing.xs),

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

            const SizedBox(height: AppSpacing.xs),

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
