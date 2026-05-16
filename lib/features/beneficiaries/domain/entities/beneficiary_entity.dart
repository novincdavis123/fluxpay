class BeneficiaryEntity {
  final String id;

  final String nickname;

  final String bankName;

  final String country;

  final String currencyCode;

  final String accountNumber;

  final DateTime createdAt;

  final bool isRecent;

  const BeneficiaryEntity({
    required this.id,
    required this.nickname,
    required this.bankName,
    required this.country,
    required this.currencyCode,
    required this.accountNumber,
    required this.createdAt,
    required this.isRecent,
  });
}
