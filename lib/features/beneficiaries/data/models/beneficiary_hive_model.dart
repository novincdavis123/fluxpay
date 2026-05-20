import 'package:hive/hive.dart';

part 'beneficiary_hive_model.g.dart';

@HiveType(typeId: 4)
class BeneficiaryHiveModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nickname;

  @HiveField(2)
  final String bankName;

  @HiveField(3)
  final String country;

  @HiveField(4)
  final String currencyCode;

  @HiveField(5)
  final String accountNumber;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final bool isRecent;

  BeneficiaryHiveModel({
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
