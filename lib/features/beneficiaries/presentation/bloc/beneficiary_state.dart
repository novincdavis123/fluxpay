import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryState {
  final List<BeneficiaryEntity> beneficiaries;

  final bool isLoading;

  final String? error;

  const BeneficiaryState({
    required this.beneficiaries,
    required this.isLoading,
    this.error,
  });

  factory BeneficiaryState.initial() {
    return const BeneficiaryState(beneficiaries: [], isLoading: false);
  }

  BeneficiaryState copyWith({
    List<BeneficiaryEntity>? beneficiaries,
    bool? isLoading,
    String? error,
  }) {
    return BeneficiaryState(
      beneficiaries: beneficiaries ?? this.beneficiaries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
