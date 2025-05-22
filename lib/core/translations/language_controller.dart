// lib/core/translations/language_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/helpers/logger.dart';
import 'app_translations.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _storage = GetStorage();
  static const String _storageKey = 'selected_language';

  // Observable current locale for UI reactivity
  final Rx<Locale> _currentLocale = AppTranslations.fallbackLocale.obs;

  // Getters
  Locale get currentLanguage => _currentLocale.value;
  Rx<Locale> get currentLocaleRx => _currentLocale;
  List<Map<String, dynamic>> get languages => AppTranslations.languageInfo;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  void _loadSavedLanguage() {
    try {
      final savedLanguageCode = _storage.read(_storageKey);

      if (savedLanguageCode != null && savedLanguageCode is String) {
        final parts = savedLanguageCode.split('_');
        if (parts.length == 2) {
          final locale = Locale(parts[0], parts[1]);
          final supportedLocale = AppTranslations.getClosestSupportedLocale(locale);
          _setCurrentLocale(supportedLocale, updateGetX: true);
          Logger.log('Loaded saved language: ${supportedLocale.toString()}');
          return;
        }
      }

      // Use device locale or fallback
      final deviceLocale = Get.deviceLocale;
      if (deviceLocale != null) {
        final supportedLocale = AppTranslations.getClosestSupportedLocale(deviceLocale);
        _setCurrentLocale(supportedLocale, updateGetX: true);
        Logger.log('Using device language: ${supportedLocale.toString()}');
      } else {
        _setCurrentLocale(AppTranslations.fallbackLocale, updateGetX: true);
        Logger.log('Using fallback language: ${AppTranslations.fallbackLocale.toString()}');
      }

    } catch (e) {
      Logger.error('Error loading saved language: $e');
      _setCurrentLocale(AppTranslations.fallbackLocale, updateGetX: true);
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    try {
      if (!AppTranslations.isSupported(locale)) {
        Logger.warning('Locale not supported: $locale, using closest match');
        locale = AppTranslations.getClosestSupportedLocale(locale);
      }

      await _saveLanguage(locale);
      _setCurrentLocale(locale, updateGetX: true);

      Logger.success('Language changed to: ${locale.toString()}');

    } catch (e) {
      Logger.error('Error changing language: $e');
    }
  }

  void _setCurrentLocale(Locale locale, {bool updateGetX = false}) {
    _currentLocale.value = locale;

    if (updateGetX) {
      Get.updateLocale(locale);
    }
  }

  Future<void> _saveLanguage(Locale locale) async {
    try {
      final languageCode = '${locale.languageCode}_${locale.countryCode}';
      await _storage.write(_storageKey, languageCode);
    } catch (e) {
      Logger.error('Error saving language: $e');
      rethrow;
    }
  }

  // Helper methods
  String getLanguageName([Locale? locale]) {
    locale ??= currentLanguage;
    return AppTranslations.getLanguageName(locale);
  }

  String getNativeLanguageName([Locale? locale]) {
    locale ??= currentLanguage;
    return AppTranslations.getNativeLanguageName(locale);
  }

  String getFlag([Locale? locale]) {
    locale ??= currentLanguage;
    return AppTranslations.getFlag(locale);
  }

  String getFlagCode([Locale? locale]) {
    locale ??= currentLanguage;
    return AppTranslations.getFlagCode(locale);
  }

  bool isSelected(Locale locale) {
    return currentLanguage.languageCode == locale.languageCode &&
        currentLanguage.countryCode == locale.countryCode;
  }

  // Get language info for UI display
  Map<String, dynamic>? getLanguageInfo([Locale? locale]) {
    locale ??= currentLanguage;
    return AppTranslations.getLanguageInfo(locale);
  }

  // Reset to device language
  Future<void> resetToDeviceLanguage() async {
    final deviceLocale = Get.deviceLocale;
    if (deviceLocale != null) {
      await changeLanguage(deviceLocale);
    }
  }

  // Reset to fallback language
  Future<void> resetToDefault() async {
    await changeLanguage(AppTranslations.fallbackLocale);
  }
}