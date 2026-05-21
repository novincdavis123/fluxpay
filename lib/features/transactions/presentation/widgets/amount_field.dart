import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';

class AmountField extends StatelessWidget {
  final TextEditingController controller;

  final String hint;

  final Function(String) onChanged;

  const AmountField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.getInputFill(context),
        border: Border.all(color: AppColors.getBorderColor(context)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
