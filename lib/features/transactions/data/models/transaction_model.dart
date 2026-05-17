import 'package:fluxpay/features/transactions/domain/entities/transaction_entity.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    required super.id,

    required super.senderCurrency,

    required super.receiverCurrency,

    required super.senderAmount,

    required super.receiverAmount,

    required super.exchangeRate,

    required super.fee,

    required super.totalPayable,

    required super.beneficiaryName,

    required super.beneficiaryBank,

    required super.createdAt,

    required super.status,

    required super.maskedAccountNumber,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],

      senderCurrency: json['senderCurrency'],

      receiverCurrency: json['receiverCurrency'],

      senderAmount: (json['senderAmount'] as num).toDouble(),

      receiverAmount: (json['receiverAmount'] as num).toDouble(),

      exchangeRate: (json['exchangeRate'] as num).toDouble(),

      fee: (json['fee'] as num).toDouble(),

      totalPayable: (json['totalPayable'] as num).toDouble(),

      beneficiaryName: json['beneficiaryName'],

      beneficiaryBank: json['beneficiaryBank'],

      createdAt: DateTime.parse(json['createdAt']),

      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
      ),

      maskedAccountNumber: json['maskedAccountNumber'],
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
}
