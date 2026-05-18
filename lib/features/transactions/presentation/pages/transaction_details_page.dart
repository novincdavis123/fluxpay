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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),

        title: Text(
          'Transaction Details',
          style: AppTextStyles.headingSmall.copyWith(
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// STATUS CARD
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(AppSpacing.xl),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),

                color: AppColors.getCardColor(context),

                border: Border.all(color: AppColors.getBorderColor(context)),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor().withOpacity(0.15),
                    ),

                    child: Icon(_statusIcon(), color: _statusColor(), size: 40),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    transaction.status.name.toUpperCase(),

                    style: AppTextStyles.headingMedium.copyWith(
                      color: _statusColor(),
                      letterSpacing: 1.1,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    DateFormat(
                      'dd MMM yyyy • hh:mm a',
                    ).format(transaction.createdAt),

                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    '${transaction.senderAmount.toStringAsFixed(2)} '
                    '${transaction.senderCurrency}',

                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.getTextPrimary(context),
                    ),

                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.primary.withOpacity(0.08),
                    ),

                    child: Text(
                      'Recipient gets '
                      '${transaction.receiverAmount.toStringAsFixed(2)} '
                      '${transaction.receiverCurrency}',

                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),

                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            /// BENEFICIARY
            _SectionCard(
              context: context,
              title: 'Beneficiary',

              child: Column(
                children: [
                  _InfoRow(
                    context: context,
                    label: 'Name',
                    value: transaction.beneficiaryName,
                  ),

                  _InfoRow(
                    context: context,
                    label: 'Bank',
                    value: transaction.beneficiaryBank,
                  ),

                  _InfoRow(
                    context: context,
                    label: 'Account',
                    value: transaction.maskedAccountNumber,
                  ),

                  _InfoRow(
                    context: context,
                    label: 'Transfer ID',
                    value: transaction.id,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            /// EXCHANGE DETAILS
            _SectionCard(
              context: context,
              title: 'Exchange Details',

              child: Column(
                children: [
                  _InfoRow(
                    context: context,

                    label: 'Exchange Rate',

                    value:
                        '1 ${transaction.senderCurrency} = '
                        '${transaction.exchangeRate.toStringAsFixed(2)} '
                        '${transaction.receiverCurrency}',
                  ),

                  _InfoRow(
                    context: context,

                    label: 'Transfer Fee',

                    value:
                        '${transaction.fee.toStringAsFixed(2)} '
                        '${transaction.senderCurrency}',
                  ),

                  _InfoRow(
                    context: context,

                    label: 'Total Paid',

                    value:
                        '${(transaction.senderAmount + transaction.fee).toStringAsFixed(2)} '
                        '${transaction.senderCurrency}',

                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            /// TIMELINE
            _SectionCard(
              context: context,
              title: 'Transfer Timeline',

              child: Column(
                children: [
                  const _TimelineTile(
                    title: 'Transfer Created',
                    subtitle: 'Your transfer request was initiated',
                    completed: true,
                    isLast: false,
                  ),

                  _TimelineTile(
                    title: 'Payment Processed',

                    subtitle: transaction.status == TransactionStatus.failed
                        ? 'Payment processing failed'
                        : 'Funds received successfully',

                    completed: transaction.status != TransactionStatus.failed,

                    isLast: false,
                  ),

                  _TimelineTile(
                    title: 'Recipient Delivery',

                    subtitle: transaction.status == TransactionStatus.completed
                        ? 'Money delivered successfully'
                        : transaction.status == TransactionStatus.processing
                        ? 'Transfer is being processed'
                        : transaction.status == TransactionStatus.pending
                        ? 'Waiting for processing'
                        : transaction.status == TransactionStatus.refunded
                        ? 'Transfer refunded'
                        : 'Delivery unsuccessful',

                    completed:
                        transaction.status == TransactionStatus.completed,

                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
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
}

class _SectionCard extends StatelessWidget {
  final BuildContext context;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.context,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),

        color: AppColors.getCardColor(context),

        border: Border.all(color: AppColors.getBorderColor(context)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.20 : 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.getTextPrimary(context),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final BuildContext context;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.context,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: Text(
              label,

              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.getTextSecondary(context),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,

              style: AppTextStyles.headingSmall.copyWith(
                color: AppColors.getTextPrimary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool completed;
  final bool isLast;

  const _TimelineTile({
    required this.title,
    required this.subtitle,
    required this.completed,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: completed
                      ? AppColors.success
                      : AppColors.getTextMuted(context),
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 52,

                  color: completed
                      ? AppColors.success
                      : AppColors.getBorderColor(context),
                ),
            ],
          ),

          const SizedBox(width: AppSpacing.md),

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

                const SizedBox(height: 4),

                Text(
                  subtitle,

                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.getTextSecondary(context),
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
