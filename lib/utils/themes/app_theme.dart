// lib/utils/themes/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constants.dart';
import '../extenstions/theme_data.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: LightColorConstants.primary,
      onPrimary: Colors.white,
      secondary: LightColorConstants.secondary,
      onSecondary: Colors.white,
      tertiary: LightColorConstants.tertiary,
      onTertiary: Colors.white,
      surface: LightColorConstants.surface,
      onSurface: LightColorConstants.textPrimary,
      background: LightColorConstants.background,
      onBackground: LightColorConstants.textPrimary,
      error: LightColorConstants.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: LightColorConstants.background,
    cardColor: LightColorConstants.card,
    dividerColor: LightColorConstants.divider,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: LightColorConstants.textPrimary),
      bodyMedium: TextStyle(color: LightColorConstants.textSecondary),
      titleLarge: TextStyle(color: LightColorConstants.textPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: LightColorConstants.textPrimary, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: LightColorConstants.textPrimary, fontWeight: FontWeight.w500),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightColorConstants.primary,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: LightColorConstants.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: LightColorConstants.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LightColorConstants.primary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LightColorConstants.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LightColorConstants.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LightColorConstants.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LightColorConstants.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: LightColorConstants.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    extensions: [
      const CustomTheme(
        selectionColor: LightColorConstants.primary,
        blueColor: LightColorConstants.info,
        yellowColor: LightColorConstants.warning,
        greenColor: LightColorConstants.success,
        foodColor: LightColorConstants.food,
        transportColor: LightColorConstants.transport,
        housingColor: LightColorConstants.housing,
        utilitiesColor: LightColorConstants.utilities,
        healthcareColor: LightColorConstants.healthcare,
        entertainmentColor: LightColorConstants.entertainment,
        shoppingColor: LightColorConstants.shopping,
        educationColor: LightColorConstants.education,
      ),
    ],
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: DarkColorConstants.primary,
      onPrimary: Colors.white,
      secondary: DarkColorConstants.secondary,
      onSecondary: Colors.white,
      tertiary: DarkColorConstants.tertiary,
      onTertiary: Colors.white,
      surface: DarkColorConstants.surface,
      onSurface: DarkColorConstants.textPrimary,
      background: DarkColorConstants.background,
      onBackground: DarkColorConstants.textPrimary,
      error: DarkColorConstants.error,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: DarkColorConstants.background,
    cardColor: DarkColorConstants.card,
    dividerColor: DarkColorConstants.divider,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DarkColorConstants.textPrimary),
      bodyMedium: TextStyle(color: DarkColorConstants.textSecondary),
      titleLarge: TextStyle(color: DarkColorConstants.textPrimary, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: DarkColorConstants.textPrimary, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: DarkColorConstants.textPrimary, fontWeight: FontWeight.w500),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DarkColorConstants.primary,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: DarkColorConstants.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: DarkColorConstants.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: DarkColorConstants.primary,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DarkColorConstants.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: DarkColorConstants.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: DarkColorConstants.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: DarkColorConstants.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: DarkColorConstants.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    extensions: [
      const CustomTheme(
        selectionColor: DarkColorConstants.primary,
        blueColor: DarkColorConstants.info,
        yellowColor: DarkColorConstants.warning,
        greenColor: DarkColorConstants.success,
        foodColor: DarkColorConstants.food,
        transportColor: DarkColorConstants.transport,
        housingColor: DarkColorConstants.housing,
        utilitiesColor: DarkColorConstants.utilities,
        healthcareColor: DarkColorConstants.healthcare,
        entertainmentColor: DarkColorConstants.entertainment,
        shoppingColor: DarkColorConstants.shopping,
        educationColor: DarkColorConstants.education,
      ),
    ],
  );
}