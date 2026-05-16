import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryCard extends StatelessWidget {
  final BeneficiaryEntity beneficiary;

  const BeneficiaryCard({super.key, required this.beneficiary});

  @override
  Widget build(BuildContext context) {
    final initials = beneficiary.nickname
        .trim()
        .split(' ')
        .map((e) => e[0])
        .take(2)
        .join();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.05),
      ),
      child: Row(
        children: [
          /// AVATAR
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4F46E5),
            ),
            alignment: Alignment.center,
            child: Text(
              initials.toUpperCase(),
              style: AppTextStyles.headingSmall,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        beneficiary.nickname,
                        style: AppTextStyles.headingSmall,
                      ),
                    ),

                    if (beneficiary.isRecent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.green.withOpacity(0.15),
                        ),
                        child: const Text(
                          'RECENT',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xs),

                Text(beneficiary.bankName, style: AppTextStyles.bodyMedium),

                const SizedBox(height: AppSpacing.xs),

                Text(
                  '${beneficiary.country} • ${beneficiary.currencyCode}',
                  style: AppTextStyles.bodySmall,
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  _maskAccountNumber(beneficiary.accountNumber),
                  style: AppTextStyles.label,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _maskAccountNumber(String accountNumber) {
    if (accountNumber.length < 4) {
      return 'XXXX';
    }

    return 'XXXXXX${accountNumber.substring(accountNumber.length - 4)}';
  }
}
