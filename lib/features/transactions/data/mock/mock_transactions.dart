import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';

import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

final mockTransactions = [
  TransactionModel(
    id: 'TXN001',

    senderCurrency: 'USD',

    receiverCurrency: 'INR',

    senderAmount: 500,

    receiverAmount: 41700,

    exchangeRate: 83.4,

    fee: 7.5,

    totalPayable: 507.5,

    beneficiaryName: 'Rahul Kumar',

    beneficiaryBank: 'HDFC Bank',

    createdAt: DateTime.now(),

    status: TransactionStatus.completed,

    maskedAccountNumber: 'XXXXXX1298',
  ),

  TransactionModel(
    id: 'TXN002',

    senderCurrency: 'EUR',

    receiverCurrency: 'USD',

    senderAmount: 320,

    receiverAmount: 346,

    exchangeRate: 1.08,

    fee: 4.5,

    totalPayable: 324.5,

    beneficiaryName: 'Alex Johnson',

    beneficiaryBank: 'Bank of America',

    createdAt: DateTime.now().subtract(const Duration(hours: 5)),

    status: TransactionStatus.processing,

    maskedAccountNumber: 'XXXXXX4421',
  ),

  TransactionModel(
    id: 'TXN003',

    senderCurrency: 'AED',

    receiverCurrency: 'INR',

    senderAmount: 1000,

    receiverAmount: 22710,

    exchangeRate: 22.71,

    fee: 8,

    totalPayable: 1008,

    beneficiaryName: 'Arjun Nair',

    beneficiaryBank: 'ICICI Bank',

    createdAt: DateTime.now().subtract(const Duration(days: 1)),

    status: TransactionStatus.pending,

    maskedAccountNumber: 'XXXXXX8744',
  ),

  TransactionModel(
    id: 'TXN004',

    senderCurrency: 'GBP',

    receiverCurrency: 'USD',

    senderAmount: 250,

    receiverAmount: 311,

    exchangeRate: 1.24,

    fee: 5,

    totalPayable: 255,

    beneficiaryName: 'Sophia Williams',

    beneficiaryBank: 'Chase Bank',

    createdAt: DateTime.now().subtract(const Duration(days: 2)),

    status: TransactionStatus.failed,

    maskedAccountNumber: 'XXXXXX9911',
  ),

  TransactionModel(
    id: 'TXN005',

    senderCurrency: 'USD',

    receiverCurrency: 'PHP',

    senderAmount: 700,

    receiverAmount: 39200,

    exchangeRate: 56.0,

    fee: 9.5,

    totalPayable: 709.5,

    beneficiaryName: 'Maria Santos',

    beneficiaryBank: 'BDO Unibank',

    createdAt: DateTime.now().subtract(const Duration(days: 3)),

    status: TransactionStatus.refunded,

    maskedAccountNumber: 'XXXXXX7720',
  ),
];
