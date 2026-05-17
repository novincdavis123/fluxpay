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
    return Scaffold(
      backgroundColor: AppColors.backgroundblack,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,

        title: Text('Transaction Details', style: AppTextStyles.headingSmall),
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
                borderRadius: BorderRadius.circular(28),
                color: Colors.white.withOpacity(0.05),
              ),

              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 78,

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _statusColor().withOpacity(0.15),
                    ),

                    child: Icon(_statusIcon(), color: _statusColor(), size: 38),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    transaction.status.name.toUpperCase(),
                    style: AppTextStyles.headingMedium,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    DateFormat(
                      'dd MMM yyyy • hh:mm a',
                    ).format(transaction.createdAt),

                    style: AppTextStyles.bodyMedium,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Text(
                    '${transaction.senderAmount.toStringAsFixed(2)} ${transaction.senderCurrency}',
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'Recipient gets '
                    '${transaction.receiverAmount.toStringAsFixed(2)} '
                    '${transaction.receiverCurrency}',

                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            /// BENEFICIARY
            _SectionCard(
              title: 'Beneficiary',
              child: Column(
                children: [
                  _InfoRow(label: 'Name', value: transaction.beneficiaryName),

                  _InfoRow(label: 'Bank', value: transaction.beneficiaryBank),

                  _InfoRow(
                    label: 'Account',
                    value: transaction.maskedAccountNumber,
                  ),

                  _InfoRow(
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
              title: 'Exchange Details',
              child: Column(
                children: [
                  _InfoRow(
                    label: 'Exchange Rate',
                    value:
                        '1 ${transaction.senderCurrency} = '
                        '${transaction.exchangeRate.toStringAsFixed(2)} '
                        '${transaction.receiverCurrency}',
                  ),

                  _InfoRow(
                    label: 'Transfer Fee',
                    value:
                        '${transaction.fee.toStringAsFixed(2)} '
                        '${transaction.senderCurrency}',
                  ),

                  _InfoRow(
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
        return Colors.orange;

      case TransactionStatus.processing:
        return Colors.blue;

      case TransactionStatus.failed:
        return AppColors.error;

      case TransactionStatus.refunded:
        return Colors.purple;
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
  final String title;

  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(AppSpacing.lg),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: AppTextStyles.headingSmall),

          const SizedBox(height: AppSpacing.lg),

          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;

  final String value;

  final bool isLast;

  const _InfoRow({
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
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),

          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.headingSmall,
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
                  color: completed ? AppColors.success : Colors.white24,
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 52,
                  color: completed ? AppColors.success : Colors.white12,
                ),
            ],
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
        ],
      ),
    );
  }
}
