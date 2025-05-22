part of 'imports.dart';

class CurrencySetupController extends GetxController {
  final CurrencyService _currencyService = Get.find<CurrencyService>();

  final Rx<Currency?> selectedCurrency = Rx<Currency?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFromSettings = false.obs;
  final RxString searchQuery = ''.obs;
  final TextEditingController searchController = TextEditingController();

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
        // Mark setup as complete and go to onboarding
        final storage = GetStorage();
        await storage.write(StorageKeys.hasCompletedPreferences, true);
        Get.offNamed(AppRoutes.onboarding);
      }
    } catch (e) {
      Logger.error('Failed to change currency: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void skipCurrencySetup() {
    if (isFromSettings.value) {
      Get.back();
    } else {
      Get.offNamed(AppRoutes.onboarding);
    }
  }

  bool isSelected(Currency currency) {
    return selectedCurrency.value?.code == currency.code;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }
}
