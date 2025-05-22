// lib/utils/extenstions/text_style_extention.dart
import 'package:flutter/material.dart';

import '../constants/font_constants.dart';

/// Extension on BuildContext providing consistent, semantic text styles
/// organized by purpose rather than just by size
extension AppTextStyles on BuildContext {
  // HEADINGS - For page and section titles

  /// Large display heading for splash screens, heroes, or major section intros
  TextStyle get displayLarge => TextStyle(
    fontFamily: FontConstants.oswald,
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 1.1,
    letterSpacing: -0.5,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Medium display heading for major section headers
  TextStyle get displayMedium => TextStyle(
    fontFamily: FontConstants.oswald,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Primary page heading (e.g., page titles)
  TextStyle get headingLarge => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.25,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Secondary heading (e.g., section titles)
  TextStyle get headingMedium => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Tertiary heading (e.g., card titles, list section headers)
  TextStyle get headingSmall => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Theme.of(this).colorScheme.onSurface,
  );

  // BODY TEXT - For content and descriptions

  /// Primary body text for main content
  TextStyle get bodyLarge => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Secondary body text for descriptions and subtitles
  TextStyle get bodyMedium => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Theme.of(this).colorScheme.onSurface.withOpacity(0.8),
  );

  /// Small body text for less important information
  TextStyle get bodySmall => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Theme.of(this).colorScheme.onSurface.withOpacity(0.7),
  );

  // LABELS & UI TEXT - For interactive elements

  /// Primary label text for buttons, tabs, and other interactive elements
  TextStyle get labelLarge => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.5,
    color: Theme.of(this).colorScheme.primary,
  );

  /// Secondary label for smaller interactive elements
  TextStyle get labelMedium => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.25,
    color: Theme.of(this).colorScheme.primary,
  );

  /// Small label for minor interactive elements
  TextStyle get labelSmall => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
    color: Theme.of(this).colorScheme.primary,
  );

  // NUMERIC TEXT - For financial data and statistics

  /// Large numeric display (e.g., account balances, totals)
  TextStyle get numberLarge => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.5,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Medium numeric display (e.g., transaction amounts)
  TextStyle get numberMedium => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Small numeric display (e.g., dates, percentages)
  TextStyle get numberSmall => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
    color: Theme.of(this).colorScheme.onSurface,
  );

  // SPECIAL TEXT STYLES - For specific use cases

  /// Action button text style
  TextStyle get buttonText => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 16,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: 0.5,
    color: Theme.of(this).scaffoldBackgroundColor, // For contrast on colored buttons
  );

  /// Caption for images, footnotes, and supplementary info
  TextStyle get caption => TextStyle(
    fontFamily: FontConstants.nunito,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    height: 1.4,
    color: Theme.of(this).colorScheme.onSurface.withOpacity(0.6),
  );

  /// Monospace text for code, data, or technical information
  TextStyle get monospace => TextStyle(
    fontFamily: FontConstants.sourceCodePro,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    letterSpacing: 0,
    color: Theme.of(this).colorScheme.onSurface,
  );

  /// Overline text for labels, categories, and headers
  TextStyle get overline => TextStyle(
    fontFamily: FontConstants.montserrat,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.5,
    textBaseline: TextBaseline.alphabetic,
    color: Theme.of(this).colorScheme.onSurface.withOpacity(0.7),
  );
}

// MODIFIERS - Helper methods to modify existing styles
extension TextStyleModifiers on TextStyle {
  /// Makes any text style bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Makes any text style italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Apply line-through decoration to text (for crossed-out prices, completed tasks)
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  /// Apply underline decoration to text
  TextStyle get underlined => copyWith(decoration: TextDecoration.underline);

  /// Add letter spacing for specific effects
  TextStyle withLetterSpacing(double value) => copyWith(letterSpacing: value);

  /// Adjust the text size by a percentage
  TextStyle scale(double factor) => copyWith(fontSize: (fontSize ?? 14) * factor);

  /// Apply a specific color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Apply opacity to the text color
  TextStyle withOpacity(double opacity) => copyWith(
    color: (color ?? const Color(0xFF000000)).withOpacity(opacity),
  );
}

// COLOR MODIFIERS - Helper methods to apply theme colors to text styles
extension TextStyleColorModifiers on BuildContext {
  /// Apply primary color to any text style
  TextStyle primaryText(TextStyle base) => base.copyWith(
    color: Theme.of(this).colorScheme.primary,
  );

  /// Apply secondary color to any text style
  TextStyle secondaryText(TextStyle base) => base.copyWith(
    color: Theme.of(this).colorScheme.secondary,
  );

  /// Apply tertiary color to any text style
  TextStyle tertiaryText(TextStyle base) => base.copyWith(
    color: Theme.of(this).colorScheme.tertiary,
  );

  /// Apply error color to any text style
  TextStyle errorText(TextStyle base) => base.copyWith(
    color: Theme.of(this).colorScheme.error,
  );

  /// Make any text style subdued (reduced opacity)
  TextStyle subduedText(TextStyle base) => base.copyWith(
    color: (base.color ?? Theme.of(this).colorScheme.onSurface).withOpacity(0.6),
  );
}