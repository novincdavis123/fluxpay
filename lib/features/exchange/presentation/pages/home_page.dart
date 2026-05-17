import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';
import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_bloc.dart';
import 'package:fluxpay/features/beneficiaries/presentation/bloc/beneficiary_event.dart';
import 'package:fluxpay/features/beneficiaries/presentation/pages/beneficiary_page.dart';
import 'package:fluxpay/features/exchange/presentation/pages/exchange_page.dart';
import 'package:fluxpay/features/transactions/presentation/pages/transaction_page.dart';
import 'package:fluxpay/features/analytics/presentation/pages/analytics_page.dart';
import 'package:fluxpay/shared/widgets/common/app_scaffold.dart';

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
    return AppScaffold(
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
                  width: 52,
                  height: 52,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white10,
                  ),

                  child: const Icon(Icons.person_outline, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            /// BALANCE CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(AppSpacing.xl),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),

                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

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

            GridView.count(
              crossAxisCount: 2,

              shrinkWrap: true,

              physics: const NeverScrollableScrollPhysics(),

              crossAxisSpacing: AppSpacing.md,

              mainAxisSpacing: AppSpacing.md,

              childAspectRatio: 1.1,

              children: [
                _ActionCard(
                  title: 'Send Money',

                  subtitle: 'Start transfer',

                  icon: Icons.send_rounded,

                  onTap: () {
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

                  onTap: () {
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

                  onTap: () {
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

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AnalyticsPage()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            /// LIVE FX MARKET
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(AppSpacing.lg),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),

                color: AppColors.card,
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

                      Text('Live FX Market', style: AppTextStyles.headingSmall),
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

            /// INSIGHTS
            Text('Insights', style: AppTextStyles.headingMedium),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _InsightCard(
                    title: 'Monthly Transfers',
                    value: '24',
                    icon: Icons.swap_horiz_rounded,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: _InsightCard(
                    title: 'Volume',
                    value: '\$12.8K',
                    icon: Icons.attach_money_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _InsightCard(
                    title: 'Beneficiaries',
                    value: '8',
                    icon: Icons.people_rounded,
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                Expanded(
                  child: _InsightCard(
                    title: 'Success Rate',
                    value: '98%',
                    icon: Icons.check_circle_rounded,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            /// RECENT ACTIVITY
            Text('Recent Activity', style: AppTextStyles.headingMedium),

            const SizedBox(height: AppSpacing.md),

            const _RecentActivityTile(
              title: 'Transfer to Rahul Kumar',
              subtitle: 'Completed • Today',
              amount: '- \$420.00',
              isPositive: false,
            ),

            const SizedBox(height: AppSpacing.md),

            const _RecentActivityTile(
              title: 'Transfer to Alex Johnson',
              subtitle: 'Processing • Yesterday',
              amount: '- \$180.00',
              isPositive: false,
            ),

            const SizedBox(height: AppSpacing.md),

            const _RecentActivityTile(
              title: 'Wallet Cashback',
              subtitle: 'Reward credited',
              amount: '+ \$12.00',
              isPositive: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;

  final String subtitle;

  final IconData icon;

  final VoidCallback onTap;

  const _ActionCard({
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
        padding: const EdgeInsets.all(AppSpacing.lg),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),

          color: AppColors.card,
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 40,
              height: 40,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: AppColors.primary.withOpacity(0.15),
              ),

              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              title,
              style: AppTextStyles.headingSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 4),

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
                color: isPositive ? AppColors.success : AppColors.error,

                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;

  final String value;

  final IconData icon;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        color: AppColors.card,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: AppColors.primary.withOpacity(0.15),
            ),

            child: Icon(icon, color: AppColors.primary),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(value, style: AppTextStyles.headingMedium),

          const SizedBox(height: 4),

          Text(title, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _RecentActivityTile extends StatelessWidget {
  final String title;

  final String subtitle;

  final String amount;

  final bool isPositive;

  const _RecentActivityTile({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),

        color: AppColors.card,
      ),

      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              shape: BoxShape.circle,

              color: isPositive
                  ? AppColors.success.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.15),
            ),

            child: Icon(
              isPositive
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,

              color: isPositive ? AppColors.success : AppColors.primary,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title, style: AppTextStyles.headingSmall),

                const SizedBox(height: 4),

                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),

          Text(
            amount,

            style: AppTextStyles.headingSmall.copyWith(
              color: isPositive ? AppColors.success : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
