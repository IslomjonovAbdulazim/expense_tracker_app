// lib/utils/extenstions/button_extension.dart
import 'package:flutter/material.dart';
import 'package:expense_tracker_app/utils/extenstions/color_extension.dart';

import '../constants/font_constants.dart';

// Renamed to avoid conflict
extension ButtonTextStylesExtension on BuildContext {
  /// Elevated button text style – bold with a bit of letter spacing for clarity.
  TextStyle get elevatedButtonText => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: backgroundColor,
  );
}

/// Button styles extension that uses your color palette and text style.
extension ButtonStylesExtension on BuildContext {
  /// Standard ElevatedButton style.
  ButtonStyle get elevatedButtonStyle => ElevatedButton.styleFrom(
    foregroundColor: backgroundColor,
    backgroundColor: Theme.of(this).colorScheme.primary,
    textStyle: elevatedButtonText, // Use the renamed method
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 2,
  );

  /// A compact ElevatedButton style for smaller buttons.
  ButtonStyle get elevatedButtonSmallStyle => ElevatedButton.styleFrom(
    foregroundColor: backgroundColor,
    backgroundColor: Theme.of(this).colorScheme.primary,
    textStyle: elevatedButtonText.copyWith(fontSize: 14), // Use the renamed method
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 1,
  );

  /// A larger ElevatedButton style for prominent call-to-actions.
  ButtonStyle get elevatedButtonLargeStyle => ElevatedButton.styleFrom(
    foregroundColor: Theme.of(this).colorScheme.onPrimary,
    backgroundColor: Theme.of(this).colorScheme.primary,
    textStyle: elevatedButtonText.copyWith(fontSize: 18), // Use the renamed method
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 4,
  );
}