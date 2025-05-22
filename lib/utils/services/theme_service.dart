// lib/utils/services/theme_service.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constants.dart';

enum AppThemeEnum {
  light,
  dark,
  system,
}

class ThemeController extends GetxController with WidgetsBindingObserver {
  static ThemeController get to => Get.find<ThemeController>();

  final _storage = GetStorage();
  final Rx<AppThemeEnum> selectedTheme = AppThemeEnum.system.obs;
  final RxBool _systemIsDark = false.obs;

  // Public getters for compatibility with existing code
  ThemeMode get themeMode {
    switch (selectedTheme.value) {
      case AppThemeEnum.light:
        return ThemeMode.light;
      case AppThemeEnum.dark:
        return ThemeMode.dark;
      case AppThemeEnum.system:
        return ThemeMode.system;
    }
  }

  bool get isDarkMode {
    switch (selectedTheme.value) {
      case AppThemeEnum.light:
        return false;
      case AppThemeEnum.dark:
        return true;
      case AppThemeEnum.system:
        return _systemIsDark.value;
    }
  }

  String get currentThemeName {
    switch (selectedTheme.value) {
      case AppThemeEnum.light:
        return 'Light';
      case AppThemeEnum.dark:
        return 'Dark';
      case AppThemeEnum.system:
        return 'System';
    }
  }

  IconData get currentThemeIcon {
    switch (selectedTheme.value) {
      case AppThemeEnum.light:
        return Icons.light_mode;
      case AppThemeEnum.dark:
        return Icons.dark_mode;
      case AppThemeEnum.system:
        return Icons.settings_brightness;
    }
  }

  // New getter for enhanced UI display
  String get themeStatusText {
    final theme = currentThemeName;
    if (selectedTheme.value == AppThemeEnum.system) {
      return '$theme (${isDarkMode ? 'Dark' : 'Light'})';
    }
    return theme;
  }

  @override
  void onInit() {
    super.onInit();

    // Add observer for system theme changes
    WidgetsBinding.instance.addObserver(this);

    // Initialize system brightness
    _updateSystemBrightness();

    // Load saved theme preference
    _loadSavedTheme();

    // Apply the initial theme
    _applyTheme();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    // Update our internal system brightness tracker
    _updateSystemBrightness();

    // If using system theme, update the app theme immediately
    if (selectedTheme.value == AppThemeEnum.system) {
      _applyTheme();
      update(); // Trigger GetBuilder widgets to rebuild
    }
  }

  void _updateSystemBrightness() {
    final context = Get.context;
    if (context != null) {
      final brightness = MediaQuery.of(context).platformBrightness;
      _systemIsDark.value = brightness == Brightness.dark;
    }
  }

  void _loadSavedTheme() {
    try {
      final storedTheme = _storage.read(StorageKeys.selectedTheme);
      if (storedTheme != null && storedTheme is int) {
        if (storedTheme >= 0 && storedTheme < AppThemeEnum.values.length) {
          selectedTheme.value = AppThemeEnum.values[storedTheme];
        }
      }
    } catch (e) {
      // Default to system theme if loading fails
      selectedTheme.value = AppThemeEnum.system;
    }
  }

  void _applyTheme() {
    Get.changeThemeMode(themeMode);
    _updateSystemUIOverlay();
  }

  void _updateSystemUIOverlay() {
    final isDark = isDarkMode;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: isDark ? const Color(0xFF121212) : Colors.white,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  // Main method to update theme with persistence and UI feedback
  Future<void> updateTheme(AppThemeEnum theme) async {
    try {
      selectedTheme.value = theme;
      await _storage.write(StorageKeys.selectedTheme, theme.index);

      _applyTheme();
      update(); // Trigger GetBuilder rebuild

      // Optional: Show user feedback
      Get.snackbar(
        'Theme Updated',
        'Changed to ${currentThemeName} theme',
        duration: const Duration(seconds: 1),
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
        colorText: Get.theme.colorScheme.primary,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      // Handle errors gracefully
      Get.snackbar(
        'Theme Error',
        'Failed to update theme. Please try again.',
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  // Convenience methods for easy theme switching
  void setLightTheme() => updateTheme(AppThemeEnum.light);
  void setDarkTheme() => updateTheme(AppThemeEnum.dark);
  void setSystemTheme() => updateTheme(AppThemeEnum.system);

  void toggleTheme() {
    if (selectedTheme.value == AppThemeEnum.light) {
      updateTheme(AppThemeEnum.dark);
    } else {
      updateTheme(AppThemeEnum.light);
    }
  }

  void cycleTheme() {
    final currentIndex = selectedTheme.value.index;
    final nextIndex = (currentIndex + 1) % AppThemeEnum.values.length;
    updateTheme(AppThemeEnum.values[nextIndex]);
  }

  // Helper method to check current theme
  bool isTheme(AppThemeEnum theme) => selectedTheme.value == theme;

  // Additional utility methods
  bool get isLightTheme => selectedTheme.value == AppThemeEnum.light;
  bool get isDarkTheme => selectedTheme.value == AppThemeEnum.dark;
  bool get isSystemTheme => selectedTheme.value == AppThemeEnum.system;
}