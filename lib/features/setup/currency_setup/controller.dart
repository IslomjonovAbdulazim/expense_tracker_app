// Enhanced currency setup controller
// lib/features/setup/currency_setup/controller.dart

part of 'imports.dart';

class CurrencySetupController extends GetxController {
  final CurrencyService _currencyService = Get.find<CurrencyService>();

  final Rx<Currency?> selectedCurrency = Rx<Currency?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFromSettings = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

  // Popular currencies for quick selection
  List<Currency> get popularCurrencies => [
    _currencyService.supportedCurrencies.firstWhere((c) => c.code == 'USD'),
    _currencyService.supportedCurrencies.firstWhere((c) => c.code == 'EUR'),
    _currencyService.supportedCurrencies.firstWhere((c) => c.code == 'GBP'),
    _currencyService.supportedCurrencies.firstWhere((c) => c.code == 'UZS'),
    _currencyService.supportedCurrencies.firstWhere((c) => c.code == 'RUB'),
    _currencyService.supportedCurrencies.firstWhere((c) => c.code == 'JPY'),
  ];

  List<Currency> get allCurrencies => _currencyService.supportedCurrencies;

  List<Currency> get filteredCurrencies {
    if (searchQuery.value.isEmpty) {
      return allCurrencies;
    }

    final query = searchQuery.value.toLowerCase();
    return allCurrencies.where((currency) =>
    currency.name.toLowerCase().contains(query) ||
        currency.code.toLowerCase().contains(query) ||
        currency.symbol.contains(query)
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Set current currency as selected
    selectedCurrency.value = _currencyService.currentCurrency.value;

    // Check if we're coming from settings
    final args = Get.arguments;
    if (args != null && args['fromSettings'] == true) {
      isFromSettings.value = true;
    }

    // Listen to search changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void selectCurrency(Currency currency) {
    selectedCurrency.value = currency;
  }

  Future<void> confirmSelection() async {
    if (selectedCurrency.value == null) return;

    try {
      isLoading.value = true;

      // Apply the currency
      await _currencyService.changeCurrency(selectedCurrency.value!);

      Logger.success('Currency changed to: ${selectedCurrency.value!.code}');

      // Navigate based on context
      if (isFromSettings.value) {
        // Return to settings
        Get.back();
        Get.snackbar(
          'Currency',
          'Currency updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
          colorText: Get.theme.colorScheme.primary,
        );
      } else {
        // Complete setup flow and go to onboarding
        await SetupNavigationHelper.navigateToNextSetupStep(AppRoutes.currencySetup);
      }
    } catch (e) {
      Logger.error('Failed to change currency: $e');
      Get.snackbar(
        'Error',
        'Failed to update currency. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void skipCurrencySetup() {
    if (isFromSettings.value) {
      Get.back();
    } else {
      SetupNavigationHelper.skipCurrentStep(AppRoutes.currencySetup);
    }
  }

  bool isSelected(Currency currency) {
    return selectedCurrency.value?.code == currency.code;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  // Get progress information for UI
  double get setupProgress => SetupNavigationHelper.getSetupProgress(AppRoutes.currencySetup);
  int get currentStep => SetupNavigationHelper.getStepNumber(AppRoutes.currencySetup);
  int get totalSteps => SetupNavigationHelper.totalSteps;
  List<String> get stepLabels => SetupNavigationHelper.stepLabels;

  // Get recommended currency based on user's locale
  Currency get recommendedCurrency => _currencyService.currentCurrency.value;

  // Format amount for preview
  String formatPreviewAmount(double amount) {
    if (selectedCurrency.value == null) return '';
    return _currencyService.formatAmount(amount, currency: selectedCurrency.value);
  }

  // Get currency by region for better organization
  Map<String, List<Currency>> get currenciesByRegion {
    final regions = <String, List<Currency>>{
      'Popular': popularCurrencies,
      'Americas': [],
      'Europe': [],
      'Asia': [],
      'Africa & Middle East': [],
      'Crypto': [],
    };

    for (final currency in allCurrencies) {
      if (popularCurrencies.contains(currency)) continue;

      if (currency.code.startsWith('BTC') || currency.code.startsWith('ETH') ||
          currency.code == 'USDT') {
        regions['Crypto']!.add(currency);
      } else if (['USD', 'CAD', 'MXN', 'BRL', 'ARS', 'CLP', 'COP', 'PEN'].contains(currency.code)) {
        regions['Americas']!.add(currency);
      } else if (['EUR', 'GBP', 'CHF', 'NOK', 'SEK', 'DKK', 'PLN', 'CZK', 'HUF', 'RON', 'BGN', 'HRK', 'RSD', 'UAH'].contains(currency.code)) {
        regions['Europe']!.add(currency);
      } else if (['JPY', 'CNY', 'INR', 'KRW', 'SGD', 'HKD', 'THB', 'MYR', 'IDR', 'PHP', 'VND', 'UZS', 'KZT', 'KGS', 'TJS', 'TMT', 'RUB'].contains(currency.code)) {
        regions['Asia']!.add(currency);
      } else {
        regions['Africa & Middle East']!.add(currency);
      }
    }

    // Remove empty regions
    regions.removeWhere((key, value) => value.isEmpty);

    return regions;
  }
}