import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/features/transactions/presentation/bloc/transaction_bloc.dart';

class TransactionSearchBar extends StatefulWidget {
  const TransactionSearchBar({super.key});

  @override
  State<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends State<TransactionSearchBar> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  void _clearSearch() {
    controller.clear();

    context.read<TransactionBloc>().add(const SearchTransactions(''));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,

      onChanged: (value) {
        setState(() {});

        context.read<TransactionBloc>().add(SearchTransactions(value));
      },

      style: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.getTextPrimary(context),
      ),

      cursorColor: AppColors.primary,

      decoration: InputDecoration(
        hintText: 'Search transactions',

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.getTextMuted(context),
        ),

        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.getTextSecondary(context),
        ),

        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: _clearSearch,

                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.getTextSecondary(context),
                ),
              )
            : null,

        filled: true,

        fillColor: AppColors.getInputFill(context),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide(color: AppColors.getBorderColor(context)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
