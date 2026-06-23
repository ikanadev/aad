class CurrencyInfo {
  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
  });

  final String code;
  final String symbol;
  final String name;
}

const supportedCurrencies = <CurrencyInfo>[
  CurrencyInfo(code: 'USD', symbol: r'$', name: 'US Dollar'),
  CurrencyInfo(code: 'BOB', symbol: 'Bs', name: 'Bolivian Boliviano'),
];

CurrencyInfo currencyInfoByCode(String code) {
  final normalizedCode = code.trim().toUpperCase();
  return supportedCurrencies.firstWhere(
    (currency) => currency.code == normalizedCode,
    orElse: () => CurrencyInfo(
      code: normalizedCode,
      symbol: normalizedCode,
      name: normalizedCode,
    ),
  );
}

String currencySymbolByCode(String code) => currencyInfoByCode(code).symbol;

String currencyNameByCode(String code) => currencyInfoByCode(code).name;
