// lib/core/translations/app_translations.dart
import 'dart:ui';

import 'package:get/get.dart';
import 'languages/en_us.dart';
import 'languages/ru_ru.dart';
import 'languages/uz_uz.dart';

class AppTranslations extends Translations {
  // Supported locales
  static const Locale fallbackLocale = Locale('en', 'US');

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ru', 'RU'),
    Locale('uz', 'UZ'),
  ];

  // Language information for UI
  static const List<Map<String, dynamic>> languageInfo = [
    {
      'name': 'English',
      'nativeName': 'English',
      'locale': Locale('en', 'US'),
      'flag': '🇺🇸',
      'flagCode': 'US',
    },
    {
      'name': 'Russian',
      'nativeName': 'Русский',
      'locale': Locale('ru', 'RU'),
      'flag': '🇷🇺',
      'flagCode': 'RU',
    },
    {
      'name': 'Uzbek',
      'nativeName': 'O\'zbek',
      'locale': Locale('uz', 'UZ'),
      'flag': '🇺🇿',
      'flagCode': 'UZ',
    },
  ];

  // Static translations map
  static Map<String, Map<String, String>> get translations => {
    'en_US': enUs,
    'ru_RU': ruRu,
    'uz_UZ': uzUz,
  };

  @override
  Map<String, Map<String, String>> get keys => translations;

  // Helper methods
  static bool isSupported(Locale locale) {
    return supportedLocales.any(
          (supported) =>
      supported.languageCode == locale.languageCode &&
          supported.countryCode == locale.countryCode,
    );
  }

  static Locale getClosestSupportedLocale(Locale locale) {
    // First try exact match
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode &&
          supported.countryCode == locale.countryCode) {
        return supported;
      }
    }

    // Then try language match
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }

    // Return fallback
    return fallbackLocale;
  }

  static Map<String, dynamic>? getLanguageInfo(Locale locale) {
    try {
      return languageInfo.firstWhere(
            (info) {
          final infoLocale = info['locale'] as Locale;
          return infoLocale.languageCode == locale.languageCode &&
              infoLocale.countryCode == locale.countryCode;
        },
      );
    } catch (e) {
      return null;
    }
  }

  static String getLanguageName(Locale locale) {
    final info = getLanguageInfo(locale);
    return info?['name'] ?? 'Unknown';
  }

  static String getNativeLanguageName(Locale locale) {
    final info = getLanguageInfo(locale);
    return info?['nativeName'] ?? 'Unknown';
  }

  static String getFlag(Locale locale) {
    final info = getLanguageInfo(locale);
    return info?['flag'] ?? '🌐';
  }

  static String getFlagCode(Locale locale) {
    final info = getLanguageInfo(locale);
    return info?['flagCode'] ?? 'UN';
  }
}