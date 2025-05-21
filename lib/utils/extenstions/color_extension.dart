import 'package:flutter/material.dart';
import 'package:iut_football_app/utils/extenstions/theme_data.dart';

extension ColorExtension on BuildContext {
  /// Background used for Scaffold and AppBar.
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;

  /// Card color.
  Color get cardColor => Theme.of(this).cardColor;

  /// Divider color.
  Color get dividerColor => Theme.of(this).dividerColor;

  // — ColorScheme Colors —

  /// Primary color.
  Color get primary => Theme.of(this).colorScheme.primary;

  /// Secondary color (positive/income)
  Color get secondary => Theme.of(this).colorScheme.secondary;

  /// Tertiary color (negative/expense)
  Color get tertiary => Theme.of(this).colorScheme.tertiary;

  /// Color shown on top of the primary color.
  Color get white => Theme.of(this).colorScheme.onPrimary;

  /// Surface color.
  Color get surface => Theme.of(this).colorScheme.surface;

  /// Color used for text/icons on the surface.
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  /// Error color.
  Color get error => Theme.of(this).colorScheme.error;

  // — Text Colors —

  /// Primary text color.
  Color get textPrimary => Theme.of(this).textTheme.bodyLarge!.color!;

  /// Secondary text color.
  Color get textSecondary => Theme.of(this).textTheme.bodyMedium!.color!;

  /// Custom theme extension colors
  Color get selection => Theme.of(this).extension<CustomTheme>()!.selectionColor;
  Color get blueColor => Theme.of(this).extension<CustomTheme>()!.blueColor;
  Color get yellowColor => Theme.of(this).extension<CustomTheme>()!.yellowColor;
  Color get greenColor => Theme.of(this).extension<CustomTheme>()!.greenColor;

  // Category colors
  Color get foodColor => Theme.of(this).extension<CustomTheme>()!.foodColor;
  Color get transportColor => Theme.of(this).extension<CustomTheme>()!.transportColor;
  Color get housingColor => Theme.of(this).extension<CustomTheme>()!.housingColor;
  Color get utilitiesColor => Theme.of(this).extension<CustomTheme>()!.utilitiesColor;
  Color get healthcareColor => Theme.of(this).extension<CustomTheme>()!.healthcareColor;
  Color get entertainmentColor => Theme.of(this).extension<CustomTheme>()!.entertainmentColor;
  Color get shoppingColor => Theme.of(this).extension<CustomTheme>()!.shoppingColor;
  Color get educationColor => Theme.of(this).extension<CustomTheme>()!.educationColor;
}