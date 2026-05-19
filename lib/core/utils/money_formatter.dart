import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

String formatCurrency({required Decimal amount, required String currencyCode}) {
  final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2);

  return '${formatter.format(amount.toDouble())} $currencyCode';
}
