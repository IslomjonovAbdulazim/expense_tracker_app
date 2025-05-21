import 'package:flutter/material.dart';

@immutable
class CustomTheme extends ThemeExtension<CustomTheme> {
  final Color selectionColor;
  final Color blueColor;
  final Color yellowColor;
  final Color greenColor;

  // Category colors
  final Color foodColor;
  final Color transportColor;
  final Color housingColor;
  final Color utilitiesColor;
  final Color healthcareColor;
  final Color entertainmentColor;
  final Color shoppingColor;
  final Color educationColor;

  const CustomTheme({
    required this.selectionColor,
    required this.blueColor,
    required this.yellowColor,
    required this.greenColor,
    required this.foodColor,
    required this.transportColor,
    required this.housingColor,
    required this.utilitiesColor,
    required this.healthcareColor,
    required this.entertainmentColor,
    required this.shoppingColor,
    required this.educationColor,
  });

  @override
  CustomTheme copyWith({
    Color? selectionColor,
    Color? blueColor,
    Color? yellowColor,
    Color? greenColor,
    Color? foodColor,
    Color? transportColor,
    Color? housingColor,
    Color? utilitiesColor,
    Color? healthcareColor,
    Color? entertainmentColor,
    Color? shoppingColor,
    Color? educationColor,
  }) {
    return CustomTheme(
      selectionColor: selectionColor ?? this.selectionColor,
      blueColor: blueColor ?? this.blueColor,
      yellowColor: yellowColor ?? this.yellowColor,
      greenColor: greenColor ?? this.greenColor,
      foodColor: foodColor ?? this.foodColor,
      transportColor: transportColor ?? this.transportColor,
      housingColor: housingColor ?? this.housingColor,
      utilitiesColor: utilitiesColor ?? this.utilitiesColor,
      healthcareColor: healthcareColor ?? this.healthcareColor,
      entertainmentColor: entertainmentColor ?? this.entertainmentColor,
      shoppingColor: shoppingColor ?? this.shoppingColor,
      educationColor: educationColor ?? this.educationColor,
    );
  }

  @override
  CustomTheme lerp(CustomTheme? other, double t) {
    if (other == null) return this;
    return CustomTheme(
      selectionColor: Color.lerp(selectionColor, other.selectionColor, t)!,
      blueColor: Color.lerp(blueColor, other.blueColor, t)!,
      yellowColor: Color.lerp(yellowColor, other.yellowColor, t)!,
      greenColor: Color.lerp(greenColor, other.greenColor, t)!,
      foodColor: Color.lerp(foodColor, other.foodColor, t)!,
      transportColor: Color.lerp(transportColor, other.transportColor, t)!,
      housingColor: Color.lerp(housingColor, other.housingColor, t)!,
      utilitiesColor: Color.lerp(utilitiesColor, other.utilitiesColor, t)!,
      healthcareColor: Color.lerp(healthcareColor, other.healthcareColor, t)!,
      entertainmentColor: Color.lerp(entertainmentColor, other.entertainmentColor, t)!,
      shoppingColor: Color.lerp(shoppingColor, other.shoppingColor, t)!,
      educationColor: Color.lerp(educationColor, other.educationColor, t)!,
    );
  }
}