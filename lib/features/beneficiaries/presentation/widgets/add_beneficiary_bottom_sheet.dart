import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import '../bloc/beneficiary_bloc.dart';
import '../bloc/beneficiary_event.dart';

class AddBeneficiaryBottomSheet extends StatefulWidget {
  const AddBeneficiaryBottomSheet({super.key});

  @override
  State<AddBeneficiaryBottomSheet> createState() =>
      _AddBeneficiaryBottomSheetState();
}

class _AddBeneficiaryBottomSheetState extends State<AddBeneficiaryBottomSheet> {
  final formKey = GlobalKey<FormState>();

  final nicknameController = TextEditingController();

  final bankController = TextEditingController();

  final countryController = TextEditingController();

  final currencyController = TextEditingController();

  final accountController = TextEditingController();

  @override
  void dispose() {
    nicknameController.dispose();

    bankController.dispose();

    countryController.dispose();

    currencyController.dispose();

    accountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: const BoxDecoration(
            color: Color(0xFF161B22),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white24,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Text('Add Beneficiary', style: AppTextStyles.headingMedium),

                  const SizedBox(height: AppSpacing.xl),

                  _InputField(
                    controller: nicknameController,
                    label: 'Nickname',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nickname required';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _InputField(controller: bankController, label: 'Bank Name'),

                  const SizedBox(height: AppSpacing.md),

                  _InputField(controller: countryController, label: 'Country'),

                  const SizedBox(height: AppSpacing.md),

                  _InputField(
                    controller: currencyController,
                    label: 'Currency Code',
                  ),

                  const SizedBox(height: AppSpacing.md),

                  _InputField(
                    controller: accountController,
                    label: 'Account Number',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Invalid account number';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: const Color(0xFF4F46E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        context.read<BeneficiaryBloc>().add(
                          AddBeneficiary(
                            nickname: nicknameController.text.trim(),
                            bankName: bankController.text.trim(),
                            country: countryController.text.trim(),
                            currencyCode: currencyController.text.trim(),
                            accountNumber: accountController.text.trim(),
                          ),
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Save Beneficiary'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;

  final String label;

  final String? Function(String?)? validator;

  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );
  }
}
