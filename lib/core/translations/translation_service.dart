import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_translations.dart';

class TranslationService extends Translations {
  // Default locale
  static final locale = Locale('en', 'US');

  // Fallback locale
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages
  static final languages = [
    'English',
    'Русский',
    'O\'zbek',
  ];

  // Supported locales
  static final locales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('uz', 'UZ'),
  ];

  // Keys for storage
  static const String languageKey = 'language_code';
  static const String countryKey = 'country_code';

  // Storage
  final _box = GetStorage();

  @override
  Map<String, Map<String, String>> get keys => AppTranslations.translations;

  // Get saved language
  Locale getSavedLanguage() {
    String? languageCode = _box.read(languageKey);
    String? countryCode = _box.read(countryKey);

    if (languageCode != null && countryCode != null) {
      return Locale(languageCode, countryCode);
    }

    return Get.deviceLocale ?? locale;
  }

  // Get current language
  String getLanguage() {
    String? languageCode = _box.read(languageKey);
    String? countryCode = _box.read(countryKey);

    if (languageCode != null && countryCode != null) {
      Locale currentLocale = Locale(languageCode, countryCode);
      int index = locales.indexOf(currentLocale);

      if (index >= 0 && index < languages.length) {
        return languages[index];
      }
    }

    return languages[0]; // Default to first language
  }

  // Save selected language
  Future<void> saveLanguage(Locale locale) async {
    await _box.write(languageKey, locale.languageCode);
    await _box.write(countryKey, locale.countryCode);
  }

  // Change language
  void changeLanguage(String lang) {
    final int index = languages.indexOf(lang);
    if (index >= 0 && index < locales.length) {
      final Locale locale = locales[index];
      Get.updateLocale(locale);
      saveLanguage(locale);
    }
  }
}