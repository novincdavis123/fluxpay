import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

import 'package:fluxpay/features/transactions/presentation/pages/transaction_details_page.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

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
        return Icons.replay_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TransactionDetailsPage(transaction: transaction),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: AppColors.card,

          borderRadius: BorderRadius.circular(24),
        ),

        child: Row(
          children: [
            /// STATUS ICON
            Container(
              width: 58,
              height: 58,

              decoration: BoxDecoration(
                shape: BoxShape.circle,

                color: _statusColor().withOpacity(0.15),
              ),

              child: Icon(_statusIcon(), color: _statusColor(), size: 28),
            ),

            const SizedBox(width: AppSpacing.md),

            /// DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    transaction.beneficiaryName,

                    style: AppTextStyles.headingSmall,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '${transaction.senderCurrency} → ${transaction.receiverCurrency}',

                    style: AppTextStyles.bodySmall,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    DateFormat(
                      'dd MMM • hh:mm a',
                    ).format(transaction.createdAt),

                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),

            /// AMOUNT + STATUS
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,

              children: [
                Text(
                  '${transaction.senderCurrency} ${transaction.senderAmount.toStringAsFixed(2)}',

                  style: AppTextStyles.headingSmall,
                ),

                const SizedBox(height: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),

                    color: _statusColor().withOpacity(0.15),
                  ),

                  child: Text(
                    transaction.status.name.toUpperCase(),

                    style: TextStyle(
                      color: _statusColor(),

                      fontSize: 11,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
