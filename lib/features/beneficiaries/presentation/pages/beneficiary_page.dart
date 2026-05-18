import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

import 'package:fluxpay/core/utils/app_snackbar.dart';
import 'package:fluxpay/core/utils/haptics.dart';
import 'package:fluxpay/core/widgets/animated_empty_state.dart';
import 'package:fluxpay/shared/widgets/common/app_scaffold.dart';

import '../bloc/beneficiary_bloc.dart';
import '../bloc/beneficiary_event.dart';
import '../bloc/beneficiary_state.dart';

import '../widgets/add_beneficiary_bottom_sheet.dart';
import '../widgets/beneficiary_card.dart';

class BeneficiaryPage extends StatefulWidget {
  const BeneficiaryPage({super.key});

  @override
  State<BeneficiaryPage> createState() => _BeneficiaryPageState();
}

class _BeneficiaryPageState extends State<BeneficiaryPage> {
  @override
  void initState() {
    super.initState();

    context.read<BeneficiaryBloc>().add(const LoadBeneficiaries());
  }

  Future<void> _showAddBeneficiarySheet() async {
    await AppHaptics.selection();

    if (!mounted) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) {
        return const AddBeneficiaryBottomSheet();
      },
    );
  }

  Future<bool> _showDeleteDialog(String name) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: AppColors.getCardColor(context),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),

              title: Text(
                'Remove Beneficiary',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.getTextPrimary(context),
                ),
              ),

              content: Text(
                'Are you sure you want to remove $name from your beneficiaries?',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.getTextSecondary(context),
                ),
              ),

              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 18),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },

                  child: Text(
                    'Cancel',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.error,
                        AppColors.error.withOpacity(isDark ? 0.8 : 0.9),
                      ],
                    ),
                  ),

                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Text('Delete'),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryText = AppColors.getTextPrimary(context);

    final secondaryText = AppColors.getTextSecondary(context);

    final cardColor = AppColors.getCardColor(context);

    return BlocListener<BeneficiaryBloc, BeneficiaryState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null &&
            state.errorMessage!.trim().isNotEmpty) {
          AppSnackbar.showError(context, message: state.errorMessage!);
        }
      },

      child: AppScaffold(
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,

          onPressed: _showAddBeneficiarySheet,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),

          icon: const Icon(Icons.add_rounded),

          label: Text(
            'Add Beneficiary',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// =====================================================
                /// HEADER
                /// =====================================================
                ShaderMask(
                  shaderCallback: (bounds) {
                    return AppColors.primaryGradient.createShader(bounds);
                  },

                  child: Text(
                    'Beneficiaries',

                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Manage your trusted transfer recipients globally',

                  style: AppTextStyles.bodyMedium.copyWith(
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                /// =====================================================
                /// BENEFICIARY LIST
                /// =====================================================
                Expanded(
                  child: BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
                    builder: (context, state) {
                      /// LOADING
                      if (state.isLoading && state.beneficiaries.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      /// EMPTY STATE
                      if (state.beneficiaries.isEmpty) {
                        return AnimatedEmptyState(
                          icon: Icons.people_alt_outlined,

                          title: 'No Beneficiaries Yet',

                          subtitle:
                              'Add a beneficiary to start sending money globally.',

                          action: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 0,

                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            onPressed: _showAddBeneficiarySheet,

                            child: Text(
                              'Add Beneficiary',
                              style: AppTextStyles.buttonText,
                            ),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: cardColor,

                        onRefresh: () async {
                          context.read<BeneficiaryBloc>().add(
                            const LoadBeneficiaries(),
                          );
                        },

                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),

                          padding: const EdgeInsets.only(bottom: 120),

                          itemCount: state.beneficiaries.length,

                          separatorBuilder: (_, __) {
                            return const SizedBox(height: AppSpacing.md);
                          },

                          itemBuilder: (context, index) {
                            final beneficiary = state.beneficiaries[index];

                            return Dismissible(
                              key: Key(beneficiary.id),

                              direction: DismissDirection.endToStart,

                              background: Container(
                                alignment: Alignment.centerRight,

                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                ),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),

                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.error,
                                      AppColors.error.withOpacity(0.8),
                                    ],
                                  ),
                                ),

                                child: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),

                              confirmDismiss: (_) async {
                                await AppHaptics.selection();

                                return _showDeleteDialog(beneficiary.nickname);
                              },

                              onDismissed: (_) {
                                context.read<BeneficiaryBloc>().add(
                                  DeleteBeneficiary(beneficiary.id),
                                );

                                AppSnackbar.showSuccess(
                                  context,
                                  message:
                                      '${beneficiary.nickname} removed successfully',
                                );
                              },

                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),

                                  color: cardColor,

                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white.withOpacity(0.04)
                                        : Colors.black.withOpacity(0.04),
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                        isDark ? 0.18 : 0.04,
                                      ),
                                      blurRadius: 14,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),

                                child: BeneficiaryCard(
                                  beneficiary: beneficiary,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                /// FOOTER
                Center(
                  child: Text(
                    'Secure international beneficiary management',

                    style: AppTextStyles.bodySmall.copyWith(
                      color: secondaryText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
