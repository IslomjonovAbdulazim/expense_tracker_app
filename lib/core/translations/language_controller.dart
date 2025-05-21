// lib/core/controllers/language_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final _storage = GetStorage();
  final String _storageKey = 'language';

  // Available languages
  final List<Map<String, dynamic>> languages = [
    {
      'name': 'English',
      'locale': const Locale('en', 'US'),
    },
    {
      'name': 'Русский',
      'locale': const Locale('ru', 'RU'),
    },
    {
      'name': 'O\'zbek',
      'locale': const Locale('uz', 'UZ'),
    },
  ];

  // Current language
  Locale? get currentLanguage {
    final String? languageCode = _storage.read(_storageKey);
    if (languageCode != null) {
      return Locale(languageCode.split('_')[0], languageCode.split('_')[1]);
    }
    return Get.deviceLocale;
  }

  // Change language
  void changeLanguage(Locale locale) {
    final String languageCode = '${locale.languageCode}_${locale.countryCode}';
    _storage.write(_storageKey, languageCode);
    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    super.onInit();
    // Set initial language
    if (currentLanguage != null) {
      Get.updateLocale(currentLanguage!);
    }
  }
}