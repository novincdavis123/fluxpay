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
        return Icons.replay_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(24),

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
            color: AppColors.getCardColor(context),

            borderRadius: BorderRadius.circular(24),

            border: Border.all(color: AppColors.getBorderColor(context)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  AppColors.isDark(context) ? 0.18 : 0.04,
                ),

                blurRadius: 18,

                offset: const Offset(0, 8),
              ),
            ],
          ),

          child: Row(
            children: [
              /// STATUS ICON
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,

                  color: statusColor.withOpacity(0.15),
                ),

                child: Icon(_statusIcon(), color: statusColor, size: 28),
              ),

              const SizedBox(width: AppSpacing.md),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      transaction.beneficiaryName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${transaction.senderCurrency} → '
                      '${transaction.receiverCurrency}',

                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      DateFormat(
                        'dd MMM • hh:mm a',
                      ).format(transaction.createdAt),

                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.getTextMuted(context),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              /// AMOUNT + STATUS
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,

                children: [
                  Text(
                    '${transaction.senderCurrency} '
                    '${transaction.senderAmount.toStringAsFixed(2)}',

                    style: AppTextStyles.headingSmall.copyWith(
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),

                      color: statusColor.withOpacity(0.15),

                      border: Border.all(color: statusColor.withOpacity(0.25)),
                    ),

                    child: Text(
                      transaction.status.name.toUpperCase(),

                      style: TextStyle(
                        color: statusColor,

                        fontSize: 11,

                        fontWeight: FontWeight.w700,

                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
