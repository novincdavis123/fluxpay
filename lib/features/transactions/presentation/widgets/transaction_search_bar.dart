import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';

import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

class TransactionSearchBar extends StatelessWidget {
  TransactionSearchBar({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      onChanged: (value) {
        context.read<TransactionBloc>().add(SearchTransactions(value));
      },

      style: AppTextStyles.bodyLarge,

      decoration: InputDecoration(
        hintText: 'Search transactions',

        hintStyle: AppTextStyles.bodyMedium,

        prefixIcon: const Icon(Icons.search, color: Colors.white54),

        filled: true,

        fillColor: AppColors.card,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
