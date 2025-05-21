import 'package:flutter/material.dart';

/// ----------------------
/// Light Theme Constants
/// ----------------------
class LightColorConstants {
  // Primary brand colors
  static const Color primary = Color(0xFF5E72E4);      // Royal blue - your main brand color
  static const Color secondary = Color(0xFF2DCE89);    // Emerald green - for positive/income
  static const Color tertiary = Color(0xFFFB6340);     // Coral - for expenses/negative

  // UI colors
  static const Color background = Color(0xFFFAFAFA);   // Almost white background
  static const Color surface = Color(0xFFFFFFFF);      // Pure white surface
  static const Color card = Color(0xFFF5F6FA);         // Light gray for cards

  // Text colors
  static const Color textPrimary = Color(0xFF32325D);  // Dark blue-gray primary text
  static const Color textSecondary = Color(0xFF8898AA); // Medium gray secondary text

  // Accent & functional colors
  static const Color success = Color(0xFF2DCE89);      // Success green (same as secondary)
  static const Color warning = Color(0xFFFFB236);      // Amber warning
  static const Color error = Color(0xFFF5365C);        // Ruby red error
  static const Color info = Color(0xFF11CDEF);         // Cyan information

  // UI element colors
  static const Color border = Color(0xFFE9ECEF);       // Light gray border
  static const Color divider = Color(0xFFE0E0E0);      // Light gray divider

  // Category colors (for expense categories)
  static const Color food = Color(0xFFFFC75F);         // Mango
  static const Color transport = Color(0xFF845EC2);    // Purple
  static const Color housing = Color(0xFF00C2A8);      // Turquoise
  static const Color utilities = Color(0xFF008B74);    // Dark teal
  static const Color healthcare = Color(0xFFD65DB1);   // Pink
  static const Color entertainment = Color(0xFF0089BA); // Blue
  static const Color shopping = Color(0xFFF9F871);     // Yellow
  static const Color education = Color(0xFFC34A36);    // Brick red
}

/// ----------------------
/// Dark Theme Constants
/// ----------------------
class DarkColorConstants {
  // Primary brand colors
  static const Color primary = Color(0xFF6C63FF);      // Brighter purple for dark theme
  static const Color secondary = Color(0xFF00B894);    // Mint green for positive/income
  static const Color tertiary = Color(0xFFFF7675);     // Soft red for expenses/negative

  // UI colors
  static const Color background = Color(0xFF121212);   // Near black background
  static const Color surface = Color(0xFF1E1E1E);      // Dark gray surface
  static const Color card = Color(0xFF2D2D2D);         // Medium dark gray for cards

  // Text colors
  static const Color textPrimary = Color(0xFFF5F5F5);  // Near white text
  static const Color textSecondary = Color(0xFFBDBDBD); // Light gray secondary text

  // Accent & functional colors
  static const Color success = Color(0xFF00B894);      // Success mint (same as secondary)
  static const Color warning = Color(0xFFFDCB6E);      // Soft amber warning
  static const Color error = Color(0xFFFF7675);        // Soft red error (same as tertiary)
  static const Color info = Color(0xFF0984E3);         // Dark blue information

  // UI element colors
  static const Color border = Color(0xFF333333);       // Dark gray border
  static const Color divider = Color(0xFF424242);      // Medium gray divider

  // Category colors (for expense categories - slightly adjusted for dark theme)
  static const Color food = Color(0xFFFFD166);         // Slightly darker mango
  static const Color transport = Color(0xFF9B6DFF);    // Brighter purple
  static const Color housing = Color(0xFF00D9C0);      // Brighter turquoise
  static const Color utilities = Color(0xFF00A896);    // Brighter teal
  static const Color healthcare = Color(0xFFEF81BB);   // Brighter pink
  static const Color entertainment = Color(0xFF05B4F0); // Brighter blue
  static const Color shopping = Color(0xFFFFF07C);     // Brighter yellow
  static const Color education = Color(0xFFE57373);    // Brighter brick red
}