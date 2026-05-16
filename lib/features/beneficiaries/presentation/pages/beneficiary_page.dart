import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

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

    context.read<BeneficiaryBloc>().add(LoadBeneficiaries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF4F46E5),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) {
              return const AddBeneficiaryBottomSheet();
            },
          );
        },
        label: const Text('Add Beneficiary'),
        icon: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Beneficiaries', style: AppTextStyles.headingLarge),

              const SizedBox(height: AppSpacing.sm),

              Text(
                'Manage your transfer recipients',
                style: AppTextStyles.bodyMedium,
              ),

              const SizedBox(height: AppSpacing.xl),

              Expanded(
                child: BlocBuilder<BeneficiaryBloc, BeneficiaryState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.beneficiaries.isEmpty) {
                      return _EmptyState();
                    }

                    return ListView.separated(
                      itemCount: state.beneficiaries.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final beneficiary = state.beneficiaries[index];

                        return BeneficiaryCard(beneficiary: beneficiary);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              size: 48,
              color: Colors.white54,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text('No Beneficiaries Yet', style: AppTextStyles.headingSmall),

          const SizedBox(height: AppSpacing.sm),

          Text(
            'Add a beneficiary to start sending money globally.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
