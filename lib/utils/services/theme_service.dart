import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/app_constants.dart';

enum AppThemeEnum {
  light,
  dark,
  system,
}

class ThemeController extends GetxController {
  static ThemeController get to => Get.find<ThemeController>();

  final _storage = GetStorage();
  final Rx<AppThemeEnum> selectedTheme = AppThemeEnum.system.obs;

  @override
  void onInit() {
    super.onInit();
    final storedTheme = _storage.read(StorageKeys.selectedTheme);
    if (storedTheme != null) {
      selectedTheme.value = AppThemeEnum.values[storedTheme];
    }
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
    _storage.write(StorageKeys.selectedTheme, theme.index);
    Get.changeThemeMode(themeMode);
  }
}