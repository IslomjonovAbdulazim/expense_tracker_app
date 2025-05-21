import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_translations.dart';
import 'translation_keys.dart';

class LocalizationService extends Translations {
  // Default locale
  static final locale = Locale('en', 'US');

  // Fallback locale
  static final fallbackLocale = Locale('en', 'US');

  // Supported languages with their respective translation keys
  static final Map<String, Locale> languages = {
    TKeys.english: Locale('en', 'US'),
    TKeys.russian: Locale('ru', 'RU'),
    TKeys.uzbek: Locale('uz', 'UZ'),
  };

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

  // Get current language name
  String getCurrentLanguageName() {
    final currentLocale = Get.locale ?? getSavedLanguage();

    for (var entry in languages.entries) {
      if (entry.value.languageCode == currentLocale.languageCode &&
          entry.value.countryCode == currentLocale.countryCode) {
        return entry.key;
      }
    }

    return TKeys.english; // Default
  }

  // Save selected language
  Future<void> saveLanguage(Locale locale) async {
    await _box.write(languageKey, locale.languageCode);
    await _box.write(countryKey, locale.countryCode);
  }

  // Change language
  void changeLanguage(String languageName) {
    final newLocale = languages[languageName];
    if (newLocale != null) {
      saveLanguage(newLocale);
      Get.updateLocale(newLocale);
    }
  }

  // Get translated text directly
  static String tr(String key) {
    return key.tr;
  }

  // Get translated text with parameters
  static String trParams(String key, Map<String, String> params) {
    return key.trParams(params);
  }

  // Get translated plural form with parameters
  static String trPlural(String key, num count, [Map<String, String>? params]) {
    if (params != null) {
      return key.trPluralParams(count, params);
    } else {
      return key.trPlural(count);
    }
  }
}