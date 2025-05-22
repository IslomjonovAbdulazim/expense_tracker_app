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
  }

  Future<void> confirmSelection() async {
    if (selectedTheme.value == null) return;

    try {
      isLoading.value = true;
      await _themeController.updateTheme(selectedTheme.value!);

      Logger.success('Theme changed to: ${selectedTheme.value}');

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
        Get.offNamed(AppRoutes.currencySetup);
      }
    } catch (e) {
      Logger.error('Failed to change theme: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void skipThemeSetup() {
    if (isFromSettings.value) {
      Get.back();
    } else {
      Get.offNamed(AppRoutes.currencySetup);
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
        return 'Automatically switches between light and dark based on your device settings';
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
}
