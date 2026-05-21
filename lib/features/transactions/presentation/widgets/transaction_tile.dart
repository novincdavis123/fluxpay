import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
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

  String _statusText() {
    switch (transaction.status) {
      case TransactionStatus.completed:
        return 'Completed';

      case TransactionStatus.pending:
        return 'Pending';

      case TransactionStatus.processing:
        return 'Processing';

      case TransactionStatus.failed:
        return 'Failed';

      case TransactionStatus.refunded:
        return 'Refunded';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Hero(
      tag: transaction.id,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    TransactionDetailsPage(transaction: transaction),
              ),
            );
          },

          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),

            margin: const EdgeInsets.only(bottom: 16),

            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: isDark
                    ? [const Color(0xFF1B1F2A), const Color(0xFF11151D)]
                    : [Colors.white, const Color(0xFFF8FAFD)],
              ),

              border: Border.all(color: AppColors.getBorderColor(context)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.22 : 0.05),

                  blurRadius: 26,

                  offset: const Offset(0, 12),
                ),
              ],
            ),

            child: Row(
              children: [
                /// ======================================================
                /// STATUS ICON
                /// ======================================================
                Container(
                  width: 62,
                  height: 62,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: LinearGradient(
                      colors: [
                        statusColor.withOpacity(0.22),
                        statusColor.withOpacity(0.08),
                      ],
                    ),
                  ),

                  child: Icon(_statusIcon(), color: statusColor, size: 30),
                ),

                const SizedBox(width: 16),

                /// ======================================================
                /// DETAILS
                /// ======================================================
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

                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${transaction.senderCurrency} → '
                        '${transaction.receiverCurrency}',

                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,

                            color: AppColors.getTextMuted(context),
                          ),

                          const SizedBox(width: 6),

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
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                /// ======================================================
                /// AMOUNT + STATUS
                /// ======================================================
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,

                  children: [
                    Text(
                      '${transaction.senderCurrency} '
                      '${transaction.senderAmount.toStringAsFixed(2)}',

                      style: AppTextStyles.headingSmall.copyWith(
                        color: AppColors.getTextPrimary(context),

                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 7,
                      ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),

                        color: statusColor.withOpacity(0.12),

                        border: Border.all(
                          color: statusColor.withOpacity(0.20),
                        ),
                      ),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          Container(
                            width: 8,
                            height: 8,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusColor,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            _statusText(),

                            style: TextStyle(
                              color: statusColor,

                              fontSize: 11,

                              fontWeight: FontWeight.w700,

                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
