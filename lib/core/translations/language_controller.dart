// lib/core/translations/language_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _storage = GetStorage();
  final String _storageKey = 'language';

  // Observable current locale for UI reactivity
  final Rx<Locale?> currentLocaleRx = Rx<Locale?>(null);

  // Available languages with their details
  final List<Map<String, dynamic>> languages = [
    {
      'name': 'English',
      'locale': const Locale('en', 'US'),
      'flag': 'US',
    },
    {
      'name': 'Русский',
      'locale': const Locale('ru', 'RU'),
      'flag': 'RU',
    },
    {
      'name': 'O\'zbek',
      'locale': const Locale('uz', 'UZ'),
      'flag': 'UZ',
    },
  ];

  // Get current language
  Locale? get currentLanguage => currentLocaleRx.value;

  // Find language name by locale
  String getLanguageName(Locale locale) {
    final language = languages.firstWhere(
          (lang) => (lang['locale'] as Locale).languageCode == locale.languageCode,
      orElse: () => languages.first,
    );
    return language['name'];
  }

  // Change language
  void changeLanguage(Locale locale) {
    final String languageCode = '${locale.languageCode}_${locale.countryCode}';
    _storage.write(_storageKey, languageCode);
    Get.updateLocale(locale);
    currentLocaleRx.value = locale;
  }

  @override
  void onInit() {
    super.onInit();
    // Load saved language
    final String? languageCode = _storage.read(_storageKey);

    if (languageCode != null && languageCode.contains('_')) {
      final parts = languageCode.split('_');
      final locale = Locale(parts[0], parts[1]);
      currentLocaleRx.value = locale;
      Get.updateLocale(locale);
    } else {
      // Use device locale or fallback to English
      currentLocaleRx.value = Get.deviceLocale ?? const Locale('en', 'US');
    }
  }
}