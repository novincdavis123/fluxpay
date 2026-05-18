abstract class BeneficiaryEvent {
  const BeneficiaryEvent();
}

/// LOAD BENEFICIARIES
class LoadBeneficiaries extends BeneficiaryEvent {
  const LoadBeneficiaries();
}

/// ADD BENEFICIARY
class AddBeneficiary extends BeneficiaryEvent {
  final String nickname;

  final String bankName;

  final String country;

  final String currencyCode;

  final String accountNumber;

  const AddBeneficiary({
    required this.nickname,
    required this.bankName,
    required this.country,
    required this.currencyCode,
    required this.accountNumber,
  });
}

/// DELETE BENEFICIARY
class DeleteBeneficiary extends BeneficiaryEvent {
  final String id;

  const DeleteBeneficiary(this.id);
}

/// SEARCH BENEFICIARIES
class SearchBeneficiaries extends BeneficiaryEvent {
  final String query;

  const SearchBeneficiaries(this.query);
}

/// FILTER BENEFICIARIES BY CURRENCY
class FilterBeneficiariesByCurrency extends BeneficiaryEvent {
  final String? currencyCode;

  const FilterBeneficiariesByCurrency(this.currencyCode);
}

/// CLEAR ERROR
class ClearBeneficiaryError extends BeneficiaryEvent {
  const ClearBeneficiaryError();
}
