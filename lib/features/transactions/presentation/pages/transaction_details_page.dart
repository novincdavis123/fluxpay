import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';
import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

class TransactionDetailsPage extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionDetailsPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),

      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),

        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.getBackground(context),

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: _GlassIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _GlassIconButton(
                  icon: Icons.share_rounded,
                  onTap: () {},
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,

              title: Text(
                'Transaction Details',

                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),

              child: Column(
                children: [
                  /// HERO CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),

                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,

                        colors: isDark
                            ? [const Color(0xFF1B1F2A), const Color(0xFF10141D)]
                            : [Colors.white, const Color(0xFFF6F8FC)],
                      ),

                      border: Border.all(
                        color: AppColors.getBorderColor(context),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),

                          blurRadius: 30,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),

                    child: Column(
                      children: [
                        /// STATUS
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),

                            color: _statusColor().withOpacity(0.12),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Container(
                                width: 10,
                                height: 10,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _statusColor(),
                                ),
                              ),

                              const SizedBox(width: 10),

                              Text(
                                transaction.status.name.toUpperCase(),

                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: _statusColor(),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// ICON
                        Container(
                          width: 110,
                          height: 110,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            gradient: LinearGradient(
                              colors: [
                                _statusColor().withOpacity(0.28),
                                _statusColor().withOpacity(0.08),
                              ],
                            ),
                          ),

                          child: Icon(
                            _statusIcon(),
                            color: _statusColor(),
                            size: 48,
                          ),
                        ),

                        const SizedBox(height: 32),

                        /// AMOUNT
                        Text(
                          transaction.senderAmount.toStringAsFixed(2),

                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          transaction.senderCurrency,

                          style: AppTextStyles.headingMedium.copyWith(
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: 56,
                          height: 56,

                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.12),
                          ),

                          child: Icon(
                            Icons.arrow_downward_rounded,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// RECEIVER CARD
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),

                            color: AppColors.primary.withOpacity(0.06),
                          ),

                          child: Column(
                            children: [
                              Text(
                                'Recipient Receives',

                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                '${transaction.receiverAmount.toStringAsFixed(2)} '
                                '${transaction.receiverCurrency}',

                                textAlign: TextAlign.center,

                                style: AppTextStyles.headingLarge.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// RATE SNAPSHOT
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),

                            color: AppColors.getInputFill(context),
                          ),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.show_chart_rounded,
                                    color: AppColors.primary,
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    'FX Snapshot',

                                    style: AppTextStyles.headingSmall.copyWith(
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 18),

                              Row(
                                children: [
                                  Expanded(
                                    child: _MiniMetric(
                                      context,
                                      title: 'Rate',
                                      value: transaction.exchangeRate
                                          .toStringAsFixed(4),
                                      icon: Icons.currency_exchange_rounded,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: _MiniMetric(
                                      context,
                                      title: 'Fee',
                                      value:
                                          '${transaction.fee.toStringAsFixed(2)}',
                                      icon: Icons.payments_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        Text(
                          DateFormat(
                            'dd MMM yyyy • hh:mm a',
                          ).format(transaction.createdAt),

                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// BENEFICIARY
                  _PremiumSectionCard(
                    title: 'Beneficiary',
                    icon: Icons.person_rounded,

                    child: Column(
                      children: [
                        _PremiumInfoRow(
                          label: 'Recipient',
                          value: transaction.beneficiaryName,
                        ),

                        _PremiumInfoRow(
                          label: 'Bank',
                          value: transaction.beneficiaryBank,
                        ),

                        _PremiumInfoRow(
                          label: 'Account',
                          value: transaction.maskedAccountNumber,
                        ),

                        _PremiumInfoRow(
                          label: 'Transfer ID',
                          value: transaction.id,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// EXCHANGE DETAILS
                  _PremiumSectionCard(
                    title: 'Exchange Details',
                    icon: Icons.currency_exchange_rounded,

                    child: Column(
                      children: [
                        _PremiumInfoRow(
                          label: 'Exchange Rate',

                          value:
                              '1 ${transaction.senderCurrency} = '
                              '${transaction.exchangeRate.toStringAsFixed(2)} '
                              '${transaction.receiverCurrency}',
                        ),

                        _PremiumInfoRow(
                          label: 'Transfer Fee',

                          value:
                              '${transaction.fee.toStringAsFixed(2)} '
                              '${transaction.senderCurrency}',
                        ),

                        _PremiumInfoRow(
                          label: 'Total Paid',

                          value:
                              '${transaction.totalPayable.toStringAsFixed(2)} '
                              '${transaction.senderCurrency}',

                          valueColor: AppColors.primary,
                          isBold: true,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// TIMELINE
                  _PremiumSectionCard(
                    title: 'Transfer Timeline',
                    icon: Icons.timeline_rounded,

                    child: Column(
                      children: [
                        const _PremiumTimelineTile(
                          title: 'Transfer Created',
                          subtitle: 'Your transfer request was initiated',
                          completed: true,
                          isLast: false,
                        ),

                        _PremiumTimelineTile(
                          title: 'Payment Processing',

                          subtitle: _processingSubtitle(),

                          completed:
                              transaction.status != TransactionStatus.pending,

                          isLast: false,
                        ),

                        _PremiumTimelineTile(
                          title: 'Recipient Delivery',

                          subtitle: _deliverySubtitle(),

                          completed:
                              transaction.status == TransactionStatus.completed,

                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _MiniMetric(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        color: AppColors.getCardColor(context),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(icon, color: AppColors.primary, size: 22),

          const SizedBox(height: 12),

          Text(
            title,

            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.getTextSecondary(context),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,

            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.getTextPrimary(context),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor() {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return AppColors.success;

      case TransactionStatus.pending:
        return AppColors.warning;

      case TransactionStatus.processing:
        return AppColors.info;

      case TransactionStatus.failed:
        return AppColors.error;

      case TransactionStatus.refunded:
        return AppColors.refunded;
    }
  }

  IconData _statusIcon() {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return Icons.check_circle_rounded;

      case TransactionStatus.pending:
        return Icons.schedule_rounded;

      case TransactionStatus.processing:
        return Icons.sync_rounded;

      case TransactionStatus.failed:
        return Icons.cancel_rounded;

      case TransactionStatus.refunded:
        return Icons.replay_circle_filled_rounded;
    }
  }

  String _processingSubtitle() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return 'Waiting for payment confirmation';

      case TransactionStatus.processing:
        return 'Transfer is currently processing';

      case TransactionStatus.completed:
        return 'Funds processed successfully';

      case TransactionStatus.failed:
        return 'Payment processing failed';

      case TransactionStatus.refunded:
        return 'Funds refunded successfully';
    }
  }

  String _deliverySubtitle() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return 'Transfer has not started yet';

      case TransactionStatus.processing:
        return 'Recipient bank is processing transfer';

      case TransactionStatus.completed:
        return 'Money delivered successfully';

      case TransactionStatus.failed:
        return 'Recipient delivery failed';

      case TransactionStatus.refunded:
        return 'Transfer refunded successfully';
    }
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,

        child: Container(
          width: 46,
          height: 46,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            color: AppColors.getCardColor(context).withOpacity(0.9),

            border: Border.all(color: AppColors.getBorderColor(context)),
          ),

          child: Icon(icon, color: AppColors.getTextPrimary(context), size: 20),
        ),
      ),
    );
  }
}

class _PremiumSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _PremiumSectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        color: AppColors.getCardColor(context),

        border: Border.all(color: AppColors.getBorderColor(context)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.16 : 0.03),

            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),

                  color: AppColors.primary.withOpacity(0.10),
                ),

                child: Icon(icon, color: AppColors.primary),
              ),

              const SizedBox(width: 14),

              Text(
                title,

                style: AppTextStyles.headingMedium.copyWith(
                  color: AppColors.getTextPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          child,
        ],
      ),
    );
  }
}

class _PremiumInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final bool isBold;
  final Color? valueColor;

  const _PremiumInfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),

      padding: const EdgeInsets.symmetric(vertical: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Text(
              label,

              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,

              style: AppTextStyles.bodyLarge.copyWith(
                color: valueColor ?? AppColors.getTextPrimary(context),

                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumTimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool isLast;

  const _PremiumTimelineTile({
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 20),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),

                width: 20,
                height: 20,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: completed
                      ? AppColors.success
                      : AppColors.getTextMuted(context),

                  boxShadow: completed
                      ? [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.4),
                            blurRadius: 12,
                          ),
                        ]
                      : [],
                ),

                child: completed
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 58,

                  color: completed
                      ? AppColors.success
                      : AppColors.getBorderColor(context),
                ),
            ],
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  title,

                  style: AppTextStyles.headingSmall.copyWith(
                    color: AppColors.getTextPrimary(context),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,

                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.getTextSecondary(context),
                    height: 1.5,
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
