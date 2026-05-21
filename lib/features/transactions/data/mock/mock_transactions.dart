import 'dart:math';

import 'package:fluxpay/features/transactions/data/models/transaction_model.dart';
import 'package:fluxpay/features/transactions/domain/entities/transaction_status.dart';

List<TransactionModel> generateMockTransactions() {
  final random = Random();

  final statuses = TransactionStatus.values;

  final names = [
    'John Smith',
    'Emma Wilson',
    'Michael Brown',
    'Sophia Taylor',
    'Daniel Johnson',
    'Olivia Davis',
    'James Miller',
    'Ava Anderson',
    'Noah Thomas',
    'Isabella Jackson',
  ];

  final banks = [
    'Chase Bank',
    'HSBC',
    'Citibank',
    'Wells Fargo',
    'Bank of America',
    'Axis Bank',
    'ICICI Bank',
    'HDFC Bank',
  ];

  final currencies = ['USD', 'EUR', 'GBP', 'INR', 'AED'];
  // Generate 1200 mock transactions
  return List.generate(1200, (index) {
    final senderCurrency = currencies[random.nextInt(currencies.length)];

    String receiverCurrency = currencies[random.nextInt(currencies.length)];

    while (receiverCurrency == senderCurrency) {
      receiverCurrency = currencies[random.nextInt(currencies.length)];
    }

    final senderAmount = (random.nextDouble() * 5000) + 100;

    final exchangeRate = (random.nextDouble() * 40) + 0.5;

    final fee = (random.nextDouble() * 25) + 2;

    final receiverAmount = senderAmount * exchangeRate;

    return TransactionModel(
      id: 'TX-${100000 + index}',

      beneficiaryName: names[random.nextInt(names.length)],

      beneficiaryBank: banks[random.nextInt(banks.length)],

      maskedAccountNumber: '****${1000 + random.nextInt(9000)}',

      senderCurrency: senderCurrency,

      receiverCurrency: receiverCurrency,

      senderAmount: senderAmount,

      receiverAmount: receiverAmount,

      exchangeRate: exchangeRate,

      fee: fee,

      totalPayable: senderAmount + fee,

      status: statuses[random.nextInt(statuses.length)],

      createdAt: DateTime.now().subtract(
        Duration(
          days: random.nextInt(180),
          hours: random.nextInt(24),
          minutes: random.nextInt(60),
        ),
      ),
    );
  });
}
