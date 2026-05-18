import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryState {
  final List<BeneficiaryEntity> beneficiaries;

  final bool isLoading;

  final bool isAdding;

  final bool isDeleting;

  final bool hasLoaded;

  final String searchQuery;

  final String? selectedCurrency;

  final String? errorMessage;

  const BeneficiaryState({
    required this.beneficiaries,
    required this.isLoading,
    required this.isAdding,
    required this.isDeleting,
    required this.hasLoaded,
    required this.searchQuery,
    this.selectedCurrency,
    this.errorMessage,
  });

  factory BeneficiaryState.initial() {
    return const BeneficiaryState(
      beneficiaries: [],
      isLoading: false,
      isAdding: false,
      isDeleting: false,
      hasLoaded: false,
      searchQuery: '',
      selectedCurrency: null,
      errorMessage: null,
    );
  }

  bool get hasError => errorMessage != null;

  bool get isEmpty => beneficiaries.isEmpty;

  bool get hasBeneficiaries => beneficiaries.isNotEmpty;

  BeneficiaryState copyWith({
    List<BeneficiaryEntity>? beneficiaries,
    bool? isLoading,
    bool? isAdding,
    bool? isDeleting,
    bool? hasLoaded,
    String? searchQuery,
    String? selectedCurrency,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BeneficiaryState(
      beneficiaries: beneficiaries ?? this.beneficiaries,
      isLoading: isLoading ?? this.isLoading,
      isAdding: isAdding ?? this.isAdding,
      isDeleting: isDeleting ?? this.isDeleting,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  String toString() {
    return '''
BeneficiaryState(
  beneficiaries: ${beneficiaries.length},
  isLoading: $isLoading,
  isAdding: $isAdding,
  isDeleting: $isDeleting,
  hasLoaded: $hasLoaded,
  searchQuery: $searchQuery,
  selectedCurrency: $selectedCurrency,
  errorMessage: $errorMessage,
)
''';
  }
}
