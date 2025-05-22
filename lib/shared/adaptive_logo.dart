// lib/utils/widgets/adaptive_logo.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/brand_constants.dart';

class AdaptiveLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;

  const AdaptiveLogo({
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GetX way to get system brightness
    final brightness = Get.mediaQuery.platformBrightness;

    // Choose logo based on system theme
    final logoPath = brightness == Brightness.dark
        ? BrandConstants.logoDark
        : BrandConstants.logoLight;

    return Image.asset(
      logoPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}

// GetX Extension
extension AdaptiveLogoExtension on GetInterface {
  /// Returns the appropriate logo based on system theme
  String get adaptiveLogo {
    final brightness = Get.mediaQuery.platformBrightness;
    return brightness == Brightness.dark
        ? BrandConstants.logoDark
        : BrandConstants.logoLight;
  }
}