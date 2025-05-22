// Updated language setup controller with better navigation
// lib/features/setup/language_setup/controller.dart

part of 'imports.dart';

class LanguageSetupController extends GetxController {
  final LanguageController _languageController = Get.find<LanguageController>();

  final Rx<Locale?> selectedLocale = Rx<Locale?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFromSettings = false.obs;

  List<Map<String, dynamic>> get languages => _languageController.languages;

  @override
  void onInit() {
    super.onInit();
    // Set current language as selected
    selectedLocale.value = _languageController.currentLanguage;

    // Check if we're coming from settings
    final args = Get.arguments;
    if (args != null && args['fromSettings'] == true) {
      isFromSettings.value = true;
    }
  }

  void selectLanguage(Locale locale) {
    selectedLocale.value = locale;
  }

  Future<void> confirmSelection() async {
    if (selectedLocale.value == null) return;

    try {
      isLoading.value = true;

      // Apply the language
      await _languageController.changeLanguage(selectedLocale.value!);

      Logger.success('Language changed to: ${selectedLocale.value}');

      // Navigate based on context
      if (isFromSettings.value) {
        // Return to settings
        Get.back();
        Get.snackbar(
          AppTranslationKeys.language.tr,
          'Language updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
          colorText: Get.theme.colorScheme.primary,
        );
      } else {
        // Continue to next step in setup flow
        await SetupNavigationHelper.navigateToNextSetupStep(
            AppRoutes.languageSetup);
      }
    } catch (e) {
      Logger.error('Failed to change language: $e');
      Get.snackbar(
        'Error',
        'Failed to update language. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void skipLanguageSetup() {
    if (isFromSettings.value) {
      Get.back();
    } else {
      SetupNavigationHelper.skipCurrentStep(AppRoutes.languageSetup);
    }
  }

  bool isSelected(Locale locale) {
    return selectedLocale.value?.languageCode == locale.languageCode &&
        selectedLocale.value?.countryCode == locale.countryCode;
  }

  // Get progress information for UI
  double get setupProgress =>
      SetupNavigationHelper.getSetupProgress(AppRoutes.languageSetup);

  int get currentStep =>
      SetupNavigationHelper.getStepNumber(AppRoutes.languageSetup);

  int get totalSteps => SetupNavigationHelper.totalSteps;

  List<String> get stepLabels => SetupNavigationHelper.stepLabels;
}