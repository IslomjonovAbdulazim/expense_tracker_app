part of 'imports.dart';

class LanguageSelectController extends GetxController {
  // Get instance of the global language controller
  final LanguageController _languageController = Get.find<LanguageController>();

  // Observable for the current language locale
  final Rx<Locale?> currentLocale = Get.locale.obs;

  // List of available languages
  List<Map<String, dynamic>> get languages => _languageController.languages;

  @override
  void onInit() {
    super.onInit();
    // Listen for language changes
    ever(_languageController.currentLocaleRx, (locale) {
      currentLocale.value = locale;
    });
  }

  // Change language
  void changeLanguage(Locale locale) {
    _languageController.changeLanguage(locale);
  }

  // Check if a language is selected
  bool isSelected(Locale locale) {
    return currentLocale.value?.languageCode == locale.languageCode &&
        currentLocale.value?.countryCode == locale.countryCode;
  }
}