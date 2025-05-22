// Enhanced theme setup controller
// lib/features/setup/theme_setup/controller.dart

part of 'imports.dart';

class ThemeSetupController extends GetxController {
  final ThemeController _themeController = Get.find<ThemeController>();

  final Rx<AppThemeEnum?> selectedTheme = Rx<AppThemeEnum?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFromSettings = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedTheme.value = _themeController.selectedTheme.value;

    final args = Get.arguments;
    if (args != null && args['fromSettings'] == true) {
      isFromSettings.value = true;
    }
  }

  void selectTheme(AppThemeEnum theme) {
    selectedTheme.value = theme;
    // Apply theme immediately for preview
    _themeController.updateTheme(theme);
  }

  Future<void> confirmSelection() async {
    if (selectedTheme.value == null) return;

    try {
      isLoading.value = true;

      // Theme is already applied from selectTheme, just save it
      await _themeController.updateTheme(selectedTheme.value!);

      Logger.success('Theme confirmed: ${selectedTheme.value}');

      if (isFromSettings.value) {
        Get.back();
        Get.snackbar(
          'Theme',
          'Theme updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
          colorText: Get.theme.colorScheme.primary,
        );
      } else {
        // Continue to next step in setup flow
        await SetupNavigationHelper.navigateToNextSetupStep(AppRoutes.themeSetup);
      }
    } catch (e) {
      Logger.error('Failed to change theme: $e');
      Get.snackbar(
        'Error',
        'Failed to update theme. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void skipThemeSetup() {
    if (isFromSettings.value) {
      Get.back();
    } else {
      SetupNavigationHelper.skipCurrentStep(AppRoutes.themeSetup);
    }
  }

  bool isSelected(AppThemeEnum theme) {
    return selectedTheme.value == theme;
  }

  String getThemeDescription(AppThemeEnum theme) {
    switch (theme) {
      case AppThemeEnum.light:
        return 'Perfect for daytime use with bright, clean interface';
      case AppThemeEnum.dark:
        return 'Easy on the eyes, ideal for low-light environments';
      case AppThemeEnum.system:
        return 'Automatically switches based on your device settings';
    }
  }

  IconData getThemeIcon(AppThemeEnum theme) {
    switch (theme) {
      case AppThemeEnum.light:
        return Icons.light_mode;
      case AppThemeEnum.dark:
        return Icons.dark_mode;
      case AppThemeEnum.system:
        return Icons.settings_brightness;
    }
  }

  String getThemeName(AppThemeEnum theme) {
    switch (theme) {
      case AppThemeEnum.light:
        return 'Light Theme';
      case AppThemeEnum.dark:
        return 'Dark Theme';
      case AppThemeEnum.system:
        return 'System Default';
    }
  }

  // Get progress information for UI
  double get setupProgress => SetupNavigationHelper.getSetupProgress(AppRoutes.themeSetup);
  int get currentStep => SetupNavigationHelper.getStepNumber(AppRoutes.themeSetup);
  int get totalSteps => SetupNavigationHelper.totalSteps;
  List<String> get stepLabels => SetupNavigationHelper.stepLabels;

  // Get recommended theme based on current system settings
  AppThemeEnum get recommendedTheme {
    final context = Get.context;
    if (context != null) {
      final brightness = MediaQuery.of(context).platformBrightness;
      // Recommend system theme for best user experience
      return AppThemeEnum.system;
    }
    return AppThemeEnum.light; // Fallback
  }

  // Check if current selection is recommended
  bool get isRecommendedSelected => selectedTheme.value == recommendedTheme;
}