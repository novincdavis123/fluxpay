import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

class TransactionEntity {
  final String id;

  final String senderCurrency;

  final String receiverCurrency;

  final double senderAmount;

  final double receiverAmount;

  final double exchangeRate;

  final double fee;

  final double totalPayable;

  final String beneficiaryName;

  final String beneficiaryBank;

  final DateTime createdAt;

  final TransactionStatus status;

  final String maskedAccountNumber;

  const TransactionEntity({
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
  });
}
