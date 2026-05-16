class CurrencyData {
  final String code;
  final String name;
  final String flag;

  const CurrencyData({
    required this.code,
    required this.name,
    required this.flag,
  });
}

const currencies = [
  CurrencyData(code: 'USD', name: 'US Dollar', flag: '🇺🇸'),
  CurrencyData(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳'),
  CurrencyData(code: 'EUR', name: 'Euro', flag: '🇪🇺'),
  CurrencyData(code: 'GBP', name: 'British Pound', flag: '🇬🇧'),
  CurrencyData(code: 'AED', name: 'UAE Dirham', flag: '🇦🇪'),
];
