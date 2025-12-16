
import 'package:flutter/widgets.dart';

class Currency {
  final String code;
  final String symbol;
  final String name;

  const Currency({
    required this.code,
    required this.symbol,
    required this.name,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}
class AppCurrencies {
  static const Currency usd = Currency(code: 'USD', symbol: '\$', name: 'US Dollar');
  static const Currency eur = Currency(code: 'EUR', symbol: '€', name: 'Euro');
  static const Currency gbp = Currency(code: 'GBP', symbol: '£', name: 'British Pound');
  static const Currency jpy = Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen');
  static const Currency pkr = Currency(code: 'PKR', symbol: 'Rs', name: 'Pakistani Rupee');
  static const Currency inr = Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee');
  static const Currency aed = Currency(code: 'AED', symbol: 'AED', name: 'UAE Dirham');
  static const Currency sar = Currency(code: 'SAR', symbol: 'SAR', name: 'Saudi Riyal');
  static const Currency cad = Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar');
  static const Currency aud = Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar');
  static const Currency cny = Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan');

  static const List<Currency> all = [
    usd,
    eur,
    gbp,
    jpy,
    pkr,
    inr,
    aed,
    sar,
    cad,
    aud,
    cny,
  ];
}
class CurrencyProvider extends ChangeNotifier{
  Currency _currency = AppCurrencies.usd;

  Currency get currency => _currency;

  void setCurrency(Currency  currency){
    _currency =currency;
    notifyListeners();
  }

}