import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum AppThemeEnum {
  light,
  dark,
  system,
}

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final _storage = GetStorage();
  final _key = 'selectedTheme';

  final Rx<AppThemeEnum> selectedTheme = AppThemeEnum.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedTheme();
    _applyTheme();

    // Listen for changes to apply theme
    ever(selectedTheme, (_) => _applyTheme());
  }

  void _loadSavedTheme() {
    final storedTheme = _storage.read<int>(_key);
    if (storedTheme != null) {
      selectedTheme.value = AppThemeEnum.values[storedTheme];
    }
  }

  void _applyTheme() {
    Get.changeThemeMode(themeMode);
  }

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

  void updateTheme(AppThemeEnum theme) {
    selectedTheme.value = theme;
    _storage.write(_key, theme.index);
  }

  bool get isDarkMode {
    if (selectedTheme.value == AppThemeEnum.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return selectedTheme.value == AppThemeEnum.dark;
  }
}