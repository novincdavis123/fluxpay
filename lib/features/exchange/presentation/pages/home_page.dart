import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_event.dart';
import 'package:fluxpay/features/beneficiaries/presentation/pages/beneficiary_page.dart';

import 'package:fluxpay/features/exchange/presentation/pages/exchange_page.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('FluxPay', style: AppTextStyles.headingLarge),

                      const SizedBox(height: AppSpacing.xs),

                      Text(
                        'Global Remittance Platform',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              /// BALANCE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance', style: AppTextStyles.bodyMedium),

                    const SizedBox(height: AppSpacing.sm),

                    Text('\$24,860.45', style: AppTextStyles.displayLarge),

                    const SizedBox(height: AppSpacing.lg),

                    Row(
                      children: [
                        _CurrencyChip(label: 'USD Wallet'),

                        const SizedBox(width: AppSpacing.sm),

                        _CurrencyChip(label: 'INR Wallet'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              /// QUICK ACTIONS
              Text('Quick Actions', style: AppTextStyles.headingMedium),

              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      title: 'Send Money',
                      icon: Icons.send_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ExchangePage(),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: _ActionCard(
                      title: 'Beneficiaries',
                      icon: Icons.people_alt_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BeneficiaryPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              /// LIVE MARKET CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white.withOpacity(0.05),
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
                          style: AppTextStyles.headingSmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    _MarketRateTile(
                      pair: 'USD → INR',
                      rate: '83.42',
                      change: '+0.24%',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _MarketRateTile(
                      pair: 'EUR → USD',
                      rate: '1.08',
                      change: '+0.11%',
                    ),

                    const SizedBox(height: AppSpacing.md),

                    _MarketRateTile(
                      pair: 'AED → INR',
                      rate: '22.71',
                      change: '-0.09%',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              /// RECENT ACTIVITY
              Text('Recent Activity', style: AppTextStyles.headingMedium),

              const SizedBox(height: AppSpacing.md),

              const _RecentActivityTile(
                title: 'Transfer to Alex Johnson',
                subtitle: 'Completed • Today',
                amount: '- \$420.00',
              ),

              const SizedBox(height: AppSpacing.md),

              const _RecentActivityTile(
                title: 'Transfer to Rahul Kumar',
                subtitle: 'Processing • Yesterday',
                amount: '- \$180.00',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;

  final IconData icon;

  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white.withOpacity(0.05),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4F46E5).withOpacity(0.2),
              ),
              child: Icon(icon, color: Colors.white),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(title, style: AppTextStyles.headingSmall),
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
        color: Colors.white.withOpacity(0.15),
      ),
      child: Text(label, style: AppTextStyles.label),
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
            Text(rate, style: AppTextStyles.headingSmall),

            const SizedBox(height: AppSpacing.xs),

            Text(
              change,
              style: TextStyle(
                color: isPositive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
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

  final String amount;

  const _RecentActivityTile({
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4F46E5).withOpacity(0.2),
            ),
            child: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),

                const SizedBox(height: AppSpacing.xs),

                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          Text(amount, style: AppTextStyles.headingSmall),
        ],
      ),
    );
  }
}
