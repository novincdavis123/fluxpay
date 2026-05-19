import '../../domain/entities/currency_entity.dart';

const supportedCurrencies = [
  CurrencyEntity(code: 'USD', symbol: '\$', name: 'US Dollar', flag: '🇺🇸'),
  CurrencyEntity(code: 'INR', symbol: '₹', name: 'Indian Rupee', flag: '🇮🇳'),
  CurrencyEntity(code: 'EUR', symbol: '€', name: 'Euro', flag: '🇪🇺'),
  CurrencyEntity(code: 'GBP', symbol: '£', name: 'British Pound', flag: '🇬🇧'),
  CurrencyEntity(code: 'AED', symbol: 'د.إ', name: 'UAE Dirham', flag: '🇦🇪'),
  CurrencyEntity(
    code: 'SGD',
    symbol: 'S\$',
    name: 'Singapore Dollar',
    flag: '🇸🇬',
  ),
  CurrencyEntity(
    code: 'CAD',
    symbol: 'C\$',
    name: 'Canadian Dollar',
    flag: '🇨🇦',
  ),
  CurrencyEntity(
    code: 'AUD',
    symbol: 'A\$',
    name: 'Australian Dollar',
    flag: '🇦🇺',
  ),
];
