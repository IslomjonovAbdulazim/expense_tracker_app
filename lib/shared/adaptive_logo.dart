// lib/shared/adaptive_logo.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/constants/brand_constants.dart';

class AdaptiveLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool showText;

  const AdaptiveLogo({
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.showText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current theme brightness
    final brightness = Theme.of(context).brightness;

    // Choose logo based on theme
    final logoPath = brightness == Brightness.dark
        ? BrandConstants.logoDark
        : BrandConstants.logoLight;

    // Try to load image, fallback to text if image fails
    return Image.asset(
      logoPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to text logo if image fails to load
        return _buildTextLogo(context);
      },
    );
  }

  Widget _buildTextLogo(BuildContext context) {
    if (showText) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogoIcon(context),
          const SizedBox(height: 8),
          _buildLogoText(context),
        ],
      );
    } else {
      return _buildLogoIcon(context);
    }
  }

  Widget _buildLogoIcon(BuildContext context) {
    return Container(
      width: width ?? 60,
      height: height ?? 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.account_balance_wallet_rounded,
          color: Colors.white,
          size: (width ?? 60) * 0.5,
        ),
      ),
    );
  }

  Widget _buildLogoText(BuildContext context) {
    return Text(
      'MT',
      style: TextStyle(
        fontSize: (width ?? 60) * 0.25,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 2,
      ),
    );
  }
}

// Theme-aware extension
extension AdaptiveLogoExtension on GetInterface {
  /// Returns the appropriate logo based on current theme
  String get adaptiveLogo {
    final context = Get.context;
    if (context == null) return BrandConstants.logoLight;

    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? BrandConstants.logoDark
        : BrandConstants.logoLight;
  }
}