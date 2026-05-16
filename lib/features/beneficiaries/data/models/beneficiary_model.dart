import '../../domain/entities/beneficiary_entity.dart';

class BeneficiaryModel extends BeneficiaryEntity {
  const BeneficiaryModel({
    required super.id,
    required super.nickname,
    required super.bankName,
    required super.country,
    required super.currencyCode,
    required super.accountNumber,
    required super.createdAt,
    required super.isRecent,
  });

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      id: json['id'],
      nickname: json['nickname'],
      bankName: json['bankName'],
      country: json['country'],
      currencyCode: json['currencyCode'],
      accountNumber: json['accountNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      isRecent: json['isRecent'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'bankName': bankName,
      'country': country,
      'currencyCode': currencyCode,
      'accountNumber': accountNumber,
      'createdAt': createdAt.toIso8601String(),
      'isRecent': isRecent,
    };
  }
}
