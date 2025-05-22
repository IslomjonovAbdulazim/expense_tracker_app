// lib/utils/services/currency_service.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/currency.dart';
import '../constants/app_constants.dart';
import '../helpers/logger.dart';

class CurrencyService extends GetxService {
  static CurrencyService get to => Get.find();

  final _storage = GetStorage();
  final Rx<Currency> currentCurrency = _getDefaultCurrency().obs;

  // Popular currencies list - Made non-static to fix the access issue
  final List<Currency> supportedCurrencies = const [
    // Major currencies
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
    Currency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺'),
    Currency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧'),
    Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', decimalPlaces: 0, flag: '🇯🇵'),
    Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'CHF', flag: '🇨🇭'),
    Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', flag: '🇨🇦'),
    Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flag: '🇦🇺'),
    Currency(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', flag: '🇳🇿'),

    // Central Asia / Former Soviet Union
    Currency(code: 'UZS', name: 'Uzbek Som', symbol: 'soʻm', flag: '🇺🇿'),
    Currency(code: 'KZT', name: 'Kazakhstani Tenge', symbol: '₸', flag: '🇰🇿'),
    Currency(code: 'KGS', name: 'Kyrgyzstani Som', symbol: 'с', flag: '🇰🇬'),
    Currency(code: 'TJS', name: 'Tajikistani Somoni', symbol: 'ЅМ', flag: '🇹🇯'),
    Currency(code: 'TMT', name: 'Turkmenistani Manat', symbol: 'm', flag: '🇹🇲'),
    Currency(code: 'RUB', name: 'Russian Ruble', symbol: '₽', flag: '🇷🇺'),

    // Asia
    Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳'),
    Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳'),
    Currency(code: 'KRW', name: 'South Korean Won', symbol: '₩', decimalPlaces: 0, flag: '🇰🇷'),
    Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', flag: '🇸🇬'),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', flag: '🇭🇰'),
    Currency(code: 'THB', name: 'Thai Baht', symbol: '฿', flag: '🇹🇭'),
    Currency(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', flag: '🇲🇾'),
    Currency(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', decimalPlaces: 0, flag: '🇮🇩'),
    Currency(code: 'PHP', name: 'Philippine Peso', symbol: '₱', flag: '🇵🇭'),
    Currency(code: 'VND', name: 'Vietnamese Dong', symbol: '₫', decimalPlaces: 0, flag: '🇻🇳'),

    // Middle East & Africa
    Currency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪'),
    Currency(code: 'SAR', name: 'Saudi Riyal', symbol: '﷼', flag: '🇸🇦'),
    Currency(code: 'QAR', name: 'Qatari Riyal', symbol: '﷼', flag: '🇶🇦'),
    Currency(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'د.ك', decimalPlaces: 3, flag: '🇰🇼'),
    Currency(code: 'BHD', name: 'Bahraini Dinar', symbol: 'د.ب', decimalPlaces: 3, flag: '🇧🇭'),
    Currency(code: 'OMR', name: 'Omani Rial', symbol: '﷼', decimalPlaces: 3, flag: '🇴🇲'),
    Currency(code: 'ILS', name: 'Israeli Shekel', symbol: '₪', flag: '🇮🇱'),
    Currency(code: 'TRY', name: 'Turkish Lira', symbol: '₺', flag: '🇹🇷'),
    Currency(code: 'EGP', name: 'Egyptian Pound', symbol: '£', flag: '🇪🇬'),
    Currency(code: 'ZAR', name: 'South African Rand', symbol: 'R', flag: '🇿🇦'),
    Currency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', flag: '🇳🇬'),

    // Europe
    Currency(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', flag: '🇳🇴'),
    Currency(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', flag: '🇸🇪'),
    Currency(code: 'DKK', name: 'Danish Krone', symbol: 'kr', flag: '🇩🇰'),
    Currency(code: 'PLN', name: 'Polish Zloty', symbol: 'zł', flag: '🇵🇱'),
    Currency(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč', flag: '🇨🇿'),
    Currency(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft', decimalPlaces: 0, flag: '🇭🇺'),
    Currency(code: 'RON', name: 'Romanian Leu', symbol: 'lei', flag: '🇷🇴'),
    Currency(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв', flag: '🇧🇬'),
    Currency(code: 'HRK', name: 'Croatian Kuna', symbol: 'kn', flag: '🇭🇷'),
    Currency(code: 'RSD', name: 'Serbian Dinar', symbol: 'дин', flag: '🇷🇸'),
    Currency(code: 'UAH', name: 'Ukrainian Hryvnia', symbol: '₴', flag: '🇺🇦'),

    // Americas
    Currency(code: 'MXN', name: 'Mexican Peso', symbol: '\$', flag: '🇲🇽'),
    Currency(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', flag: '🇧🇷'),
    Currency(code: 'ARS', name: 'Argentine Peso', symbol: '\$', flag: '🇦🇷'),
    Currency(code: 'CLP', name: 'Chilean Peso', symbol: '\$', decimalPlaces: 0, flag: '🇨🇱'),
    Currency(code: 'COP', name: 'Colombian Peso', symbol: '\$', flag: '🇨🇴'),
    Currency(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/', flag: '🇵🇪'),

    // Cryptocurrencies (popular ones)
    Currency(code: 'BTC', name: 'Bitcoin', symbol: '₿', decimalPlaces: 8),
    Currency(code: 'ETH', name: 'Ethereum', symbol: 'Ξ', decimalPlaces: 8),
    Currency(code: 'USDT', name: 'Tether', symbol: '₮', decimalPlaces: 6),
  ];

  static Currency _getDefaultCurrency() {
    // Default fallback - we'll set it properly in the instance method
    return const Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸');
  }

  Currency _getDefaultCurrencyFromLocale() {
    // Try to detect user's locale and provide appropriate default
    final locale = Get.deviceLocale;
    if (locale != null) {
      switch (locale.countryCode) {
        case 'US':
          return supportedCurrencies.firstWhere((c) => c.code == 'USD');
        case 'UZ':
          return supportedCurrencies.firstWhere((c) => c.code == 'UZS');
        case 'RU':
          return supportedCurrencies.firstWhere((c) => c.code == 'RUB');
        case 'KZ':
          return supportedCurrencies.firstWhere((c) => c.code == 'KZT');
        case 'GB':
          return supportedCurrencies.firstWhere((c) => c.code == 'GBP');
        case 'JP':
          return supportedCurrencies.firstWhere((c) => c.code == 'JPY');
        case 'CN':
          return supportedCurrencies.firstWhere((c) => c.code == 'CNY');
        case 'IN':
          return supportedCurrencies.firstWhere((c) => c.code == 'INR');
        case 'AE':
          return supportedCurrencies.firstWhere((c) => c.code == 'AED');
        case 'TR':
          return supportedCurrencies.firstWhere((c) => c.code == 'TRY');
        default:
        // For EU countries, default to EUR
          if (_isEuroCountry(locale.countryCode)) {
            return supportedCurrencies.firstWhere((c) => c.code == 'EUR');
          }
      }
    }

    // Default fallback
    return supportedCurrencies.firstWhere((c) => c.code == DefaultConstants.defaultCurrency);
  }

  bool _isEuroCountry(String? countryCode) {
    const euroCountries = [
      'DE', 'FR', 'IT', 'ES', 'NL', 'BE', 'AT', 'PT', 'FI', 'IE',
      'LU', 'MT', 'CY', 'SK', 'SI', 'EE', 'LV', 'LT', 'GR'
    ];
    return euroCountries.contains(countryCode);
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    // Set proper default currency based on locale
    currentCurrency.value = _getDefaultCurrencyFromLocale();
    await _loadSavedCurrency();
  }

  Future<void> _loadSavedCurrency() async {
    try {
      final savedCurrencyCode = _storage.read('selected_currency');
      if (savedCurrencyCode != null) {
        final savedCurrency = supportedCurrencies
            .where((c) => c.code == savedCurrencyCode)
            .firstOrNull;

        if (savedCurrency != null) {
          currentCurrency.value = savedCurrency;
          Logger.log('Loaded saved currency: ${savedCurrency.code}');
          return;
        }
      }

      // Use default currency from locale
      currentCurrency.value = _getDefaultCurrencyFromLocale();
      Logger.log('Using default currency: ${currentCurrency.value.code}');
    } catch (e) {
      Logger.error('Error loading saved currency: $e');
      currentCurrency.value = _getDefaultCurrencyFromLocale();
    }
  }

  Future<void> changeCurrency(Currency currency) async {
    try {
      currentCurrency.value = currency;
      await _storage.write('selected_currency', currency.code);
      Logger.success('Currency changed to: ${currency.code}');
    } catch (e) {
      Logger.error('Error changing currency: $e');
      rethrow;
    }
  }

  String formatAmount(double amount, {Currency? currency, bool showSymbol = true}) {
    final curr = currency ?? currentCurrency.value;

    // Format the number based on decimal places
    String formatted;
    if (curr.decimalPlaces == 0) {
      formatted = amount.round().toString();
    } else {
      formatted = amount.toStringAsFixed(curr.decimalPlaces);
    }

    // Add thousand separators
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    // Add thousand separators to integer part
    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }

    String result = buffer.toString();
    if (decimalPart.isNotEmpty) {
      result += '.$decimalPart';
    }

    if (showSymbol) {
      // Handle symbol position based on currency
      if (curr.code == 'EUR' || curr.code == 'JPY') {
        result = '$result ${curr.symbol}';
      } else {
        result = '${curr.symbol}$result';
      }
    }

    return result;
  }

  Currency? getCurrencyByCode(String code) {
    try {
      return supportedCurrencies.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  List<Currency> searchCurrencies(String query) {
    if (query.isEmpty) return supportedCurrencies;

    final lowercaseQuery = query.toLowerCase();
    return supportedCurrencies.where((currency) =>
    currency.name.toLowerCase().contains(lowercaseQuery) ||
        currency.code.toLowerCase().contains(lowercaseQuery) ||
        currency.symbol.contains(query)
    ).toList();
  }

  // Helper getters
  String get currentCurrencyCode => currentCurrency.value.code;
  String get currentCurrencySymbol => currentCurrency.value.symbol;
  String get currentCurrencyName => currentCurrency.value.name;
}