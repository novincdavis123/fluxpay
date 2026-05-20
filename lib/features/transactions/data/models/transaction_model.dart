import 'package:hive/hive.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_entity.dart';

/// IMPORTANT:
/// USE THE DOMAIN ENUM ONLY
import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends TransactionEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String senderCurrency;

  @HiveField(2)
  @override
  final String receiverCurrency;

  @HiveField(3)
  @override
  final double senderAmount;

  @HiveField(4)
  @override
  final double receiverAmount;

  @HiveField(5)
  @override
  final double exchangeRate;

  @HiveField(6)
  @override
  final double fee;

  @HiveField(7)
  @override
  final double totalPayable;

  @HiveField(8)
  @override
  final String beneficiaryName;

  @HiveField(9)
  @override
  final String beneficiaryBank;

  @HiveField(10)
  @override
  final DateTime createdAt;

  /// IMPORTANT:
  /// This now uses the DOMAIN enum
  @HiveField(11)
  @override
  final TransactionStatus status;

  @HiveField(12)
  @override
  final String maskedAccountNumber;

  const TransactionModel({
    required this.id,
    required this.senderCurrency,
    required this.receiverCurrency,
    required this.senderAmount,
    required this.receiverAmount,
    required this.exchangeRate,
    required this.fee,
    required this.totalPayable,
    required this.beneficiaryName,
    required this.beneficiaryBank,
    required this.createdAt,
    required this.status,
    required this.maskedAccountNumber,
  }) : super(
         id: id,
         senderCurrency: senderCurrency,
         receiverCurrency: receiverCurrency,
         senderAmount: senderAmount,
         receiverAmount: receiverAmount,
         exchangeRate: exchangeRate,
         fee: fee,
         totalPayable: totalPayable,
         beneficiaryName: beneficiaryName,
         beneficiaryBank: beneficiaryBank,
         createdAt: createdAt,
         status: status,
         maskedAccountNumber: maskedAccountNumber,
       );

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      senderCurrency: json['senderCurrency'] as String,
      receiverCurrency: json['receiverCurrency'] as String,
      senderAmount: (json['senderAmount'] as num).toDouble(),
      receiverAmount: (json['receiverAmount'] as num).toDouble(),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      totalPayable: (json['totalPayable'] as num).toDouble(),
      beneficiaryName: json['beneficiaryName'] as String,
      beneficiaryBank: json['beneficiaryBank'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),
      maskedAccountNumber: json['maskedAccountNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderCurrency': senderCurrency,
      'receiverCurrency': receiverCurrency,
      'senderAmount': senderAmount,
      'receiverAmount': receiverAmount,
      'exchangeRate': exchangeRate,
      'fee': fee,
      'totalPayable': totalPayable,
      'beneficiaryName': beneficiaryName,
      'beneficiaryBank': beneficiaryBank,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'maskedAccountNumber': maskedAccountNumber,
    };
  }

  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      senderCurrency: entity.senderCurrency,
      receiverCurrency: entity.receiverCurrency,
      senderAmount: entity.senderAmount,
      receiverAmount: entity.receiverAmount,
      exchangeRate: entity.exchangeRate,
      fee: entity.fee,
      totalPayable: entity.totalPayable,
      beneficiaryName: entity.beneficiaryName,
      beneficiaryBank: entity.beneficiaryBank,
      createdAt: entity.createdAt,
      status: entity.status,
      maskedAccountNumber: entity.maskedAccountNumber,
    );
  }
}
