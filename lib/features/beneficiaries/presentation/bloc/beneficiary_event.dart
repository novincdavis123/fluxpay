abstract class BeneficiaryEvent {
  const BeneficiaryEvent();
}

class LoadBeneficiaries extends BeneficiaryEvent {}

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
