import 'package:hive/hive.dart';

part 'transaction_status.g.dart';

@HiveType(typeId: 0)
enum TransactionStatus {
  @HiveField(0)
  completed,

  @HiveField(1)
  pending,

  @HiveField(2)
  processing,

  @HiveField(3)
  failed,

  @HiveField(4)
  refunded,
}
